//
//  IAPManager.swift
//  InAppPurchaseKit
//
//  공통 SDK. 프로젝트별 설정은 configure()로 주입.
//

import Foundation
import StoreKit
import UIKit

// MARK: - PurchaseStatus

public enum PurchaseStatus: Int, Comparable {
    case free = 0
    case freeTrial = 1
    case subscribed = 2
    case admin = 99

    public var isPremium: Bool {
        return self != .free
    }

    public static func < (lhs: PurchaseStatus, rhs: PurchaseStatus) -> Bool {
        return lhs.rawValue < rhs.rawValue
    }
}

// MARK: - IAPConfiguration

public struct IAPConfiguration {
    /// StoreKit 상품 ID 목록
    public var productIds: [String]
    /// Admin 백도어 문자열
    public var adminString: String
    /// App Group identifier (Share Extension 연동용, nil이면 비활성)
    public var appGroupIdentifier: String?
    /// Free Trial 키체인 키 (nil이면 freeTrial 비활성)
    public var freeTrialKeychainKey: String?
    /// Free Trial 기간 (일)
    public var freeTrialDays: Int
    public init(
        productIds: [String],
        adminString: String = "vincent",
        appGroupIdentifier: String? = nil,
        freeTrialKeychainKey: String? = nil,
        freeTrialDays: Int = 7
    ) {
        self.productIds = productIds
        self.adminString = adminString
        self.appGroupIdentifier = appGroupIdentifier
        self.freeTrialKeychainKey = freeTrialKeychainKey
        self.freeTrialDays = freeTrialDays
    }
}

// MARK: - IAPManager

public final class IAPManager {

    // MARK: - Singleton

    public static let shared = IAPManager()

    // MARK: - Configuration

    private var config: IAPConfiguration = .init(productIds: [])

    /// 앱 시작 시 호출. 반드시 configure 후 사용.
    public func configure(_ config: IAPConfiguration) {
        self.config = config
        self.lastStatus = self.resolveInitialStatus()
        self.syncPurchaseStatusToAppGroup()
    }

    // MARK: - Notifications

    public static let didCompletePurchaseNotification = Notification.Name("IAPManagerDidCompletePurchase")
    public static let didExpirePurchaseNotification = Notification.Name("IAPManagerDidExpirePurchase")
    public static let needPresentPurchaseSceneNotification = Notification.Name("IAPManagerNeedPresentPurchaseScene")

    // MARK: - Force Free (디버그용 백도어)

    private static let forceFreeKey = "IAPManager.forceFree"

    public var isForceFree: Bool {
        return self.lastStatus == .free && UserDefaults.standard.bool(forKey: IAPManager.forceFreeKey)
    }

    public func setForceFree(_ enabled: Bool) {
        UserDefaults.standard.set(enabled, forKey: IAPManager.forceFreeKey)
        if enabled {
            UserDefaults.standard.removeObject(forKey: "IAPManager.isAdmin")
        }
        self.applyStatus(enabled ? .free : self.resolveStoreStatus())
    }

    // MARK: - Free Trial (키체인 기반)

    public var isInFreeTrial: Bool {
        guard let key = self.config.freeTrialKeychainKey,
              let startDateString = Self.keychainGetString(forKey: key),
              let startDate = ISO8601DateFormatter().date(from: startDateString)
        else {
            return false
        }
        let elapsed = Calendar.current.dateComponents([.day], from: startDate, to: Date()).day ?? 0
        return elapsed < self.config.freeTrialDays
    }

    public var hasUsedFreeTrial: Bool {
        guard let key = self.config.freeTrialKeychainKey else { return false }
        return Self.keychainGetString(forKey: key) != nil
    }

    @discardableResult
    public func startFreeTrialIfNeeded() -> Bool {
        guard let key = self.config.freeTrialKeychainKey else { return false }
        guard !self.hasUsedFreeTrial else { return false }
        let formatter = ISO8601DateFormatter()
        Self.keychainSetString(formatter.string(from: Date()), forKey: key)
        self.applyStatus(.freeTrial)
        return true
    }

    // MARK: - Status

    private(set) public var lastStatus: PurchaseStatus = .free

    public var purchaseStatus: PurchaseStatus {
        if self.lastStatus == .freeTrial && !self.isInFreeTrial {
            self.applyStatus(.free)
        }
        return self.lastStatus
    }

    public var isPurchased: Bool {
        return self.lastStatus.isPremium
    }

    public var isAdmin: Bool {
        return self.lastStatus == .admin
    }

    private var updateListenerTask: Task<Void, Error>?

    // MARK: - Initialization

    private init() {
        self.updateListenerTask = self.listenForTransactions()
    }

    deinit {
        self.updateListenerTask?.cancel()
    }

    // MARK: - Transaction Listener

    private func listenForTransactions() -> Task<Void, Error> {
        return Task.detached {
            for await result in Transaction.updates {
                do {
                    let transaction = try self.checkVerified(result)
                    await self.updatePurchasedState()
                    await transaction.finish()
                }
                catch {
                    // Transaction verification failed
                }
            }
        }
    }

    // MARK: - Public Methods

    public func setAdminMode(_ enabled: Bool) {
        if enabled {
            UserDefaults.standard.set(self.config.adminString, forKey: "IAPManager.isAdmin")
            self.applyStatus(.admin)
        }
        else {
            UserDefaults.standard.removeObject(forKey: "IAPManager.isAdmin")
            self.applyStatus(self.resolveStoreStatus())
        }
    }

    public func setPurchased(_ purchased: Bool) {
        self.applyStatus(purchased ? .subscribed : .free)
    }

    @discardableResult
    public func checkPurchaseStatus() async -> Bool {
        if self.isAdmin { return true }

        var hasActiveSubscription = false
        for await result in Transaction.currentEntitlements {
            if case .verified = result {
                hasActiveSubscription = true
                break
            }
        }
        self.applyStatus(hasActiveSubscription ? .subscribed : self.resolveStoreStatus())
        return self.isPurchased
    }

    public func refreshStatusFromExternalSource() {
        self.applyStatus(self.resolveStoreStatus())
    }

    // MARK: - Fetch Products

    public func fetchProducts() async throws -> [Product] {
        let products = try await Product.products(for: self.config.productIds)
        return products.sorted { $0.price < $1.price }
    }

    // MARK: - Purchase

    public func purchase(_ product: Product) async throws -> Transaction? {
        if self.isAdmin { return nil }

        let result = try await product.purchase()

        switch result {
            case let .success(verification):
                let transaction = try self.checkVerified(verification)
                await self.updatePurchasedState()
                await transaction.finish()
                return transaction

            case .userCancelled:
                return nil

            case .pending:
                return nil

            @unknown default:
                return nil
        }
    }

    // MARK: - Restore

    public func restorePurchases() async throws -> Bool {
        if self.isAdmin { return true }

        try await AppStore.sync()
        let isPurchased = await self.checkPurchaseStatus()
        return isPurchased
    }

    // MARK: - Manage Subscriptions

    public func openManageSubscriptions() {
        Task {
            if let windowScene = await UIApplication.shared.connectedScenes.first as? UIWindowScene {
                do {
                    try await AppStore.showManageSubscriptions(in: windowScene)
                }
                catch {
                    await MainActor.run {
                        if let url = URL(string: "https://apps.apple.com/account/subscriptions") {
                            UIApplication.shared.open(url)
                        }
                    }
                }
            }
        }
    }

    public func openRedeemCode(_ code: String) {
        let urlString = "https://apps.apple.com/redeem?code=\(code)"
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url)
        }
    }

    // MARK: - Subscription Alert

    public func presentNeedSubscriptionAlert(from viewController: UIViewController? = nil) {
        let alert = UIAlertController(
            title: I18N.alert_subscription_required_title,
            message: I18N.alert_subscription_required_message,
            preferredStyle: .alert
        )

        let subscribeAction = UIAlertAction(
            title: I18N.alert_subscription_required_action,
            style: .default,
            handler: { [weak self] _ in
                guard let self = self else { return }
                NotificationCenter.default.post(
                    name: IAPManager.needPresentPurchaseSceneNotification,
                    object: nil
                )
            }
        )

        let cancelAction = UIAlertAction(
            title: I18N.alert_cancel,
            style: .cancel
        )

        alert.addAction(subscribeAction)
        alert.addAction(cancelAction)

        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            let presentingVC = viewController ?? self.topViewController()
            presentingVC?.present(alert, animated: true)
        }
    }

    private func topViewController() -> UIViewController? {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first(where: { $0.isKeyWindow })
        else {
            return nil
        }

        var topVC = window.rootViewController
        while let presented = topVC?.presentedViewController {
            topVC = presented
        }
        return topVC
    }

    // MARK: - App Group Sync

    private func syncPurchaseStatusToAppGroup() {
        guard let groupId = self.config.appGroupIdentifier else { return }
        let defaults = UserDefaults(suiteName: groupId)
        defaults?.set(self.isPurchased, forKey: "isPurchased")
    }

    // MARK: - Private Methods

    private func checkVerified<T>(_ result: VerificationResult<T>) throws -> T {
        switch result {
            case .unverified:
                throw IAPError.failedVerification

            case let .verified(safe):
                return safe
        }
    }

    private func updatePurchasedState() async {
        await self.checkPurchaseStatus()
    }

    private func resolveInitialStatus() -> PurchaseStatus {
        if UserDefaults.standard.bool(forKey: IAPManager.forceFreeKey) { return .free }
        if UserDefaults.standard.string(forKey: "IAPManager.isAdmin") == self.config.adminString { return .admin }
        if self.isInFreeTrial { return .freeTrial }
        return .free
    }

    private func resolveStoreStatus() -> PurchaseStatus {
        if self.lastStatus == .admin { return .admin }
        if self.isInFreeTrial { return .freeTrial }
        return .free
    }

    private func applyStatus(_ newStatus: PurchaseStatus) {
        let oldStatus = self.lastStatus
        guard oldStatus != newStatus else { return }
        self.lastStatus = newStatus
        self.syncPurchaseStatusToAppGroup()
        guard oldStatus.isPremium != newStatus.isPremium else { return }
        let notificationName = newStatus.isPremium
            ? IAPManager.didCompletePurchaseNotification
            : IAPManager.didExpirePurchaseNotification
        NotificationCenter.default.post(name: notificationName, object: nil)
    }

    // MARK: - Keychain (최소 구현)

    private static func keychainGetString(forKey key: String) -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        guard status == errSecSuccess, let data = result as? Data else { return nil }
        return String(data: data, encoding: .utf8)
    }

    private static func keychainSetString(_ value: String, forKey key: String) {
        let data = value.data(using: .utf8)!
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key
        ]
        SecItemDelete(query as CFDictionary)
        var newItem = query
        newItem[kSecValueData as String] = data
        SecItemAdd(newItem as CFDictionary, nil)
    }
}

// MARK: - Notification Name Extension

public extension Notification.Name {
    static let didCompletePurchase = IAPManager.didCompletePurchaseNotification
    static let didExpirePurchase = IAPManager.didExpirePurchaseNotification
    static let needPresentPurchaseScene = IAPManager.needPresentPurchaseSceneNotification
}
