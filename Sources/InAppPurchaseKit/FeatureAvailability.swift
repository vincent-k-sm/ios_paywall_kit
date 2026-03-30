//
//  FeatureAvailability.swift
//  InAppPurchaseKit
//
//  구독 상태 기반 기능 접근 제어 일원화
//  IAPManager.shared를 직접 참조하지 말고 이 매니저를 통해 접근
//

import Foundation

public final class FeatureAvailability {
    public static let shared = FeatureAvailability()

    private init() { }

    deinit { }

    // MARK: - 구독 상태

    /// 현재 구독 상태
    public var status: PurchaseStatus {
        return IAPManager.shared.purchaseStatus
    }

    /// 프리미엄 이용 가능 여부 (Admin/구독/체험 모두 포함)
    public var isPremium: Bool {
        return self.status.isPremium
    }

    /// Admin 여부
    public var isAdmin: Bool {
        return self.status == .admin
    }

    // MARK: - 기능별 접근 제어

    /// 광고 제거 (removeSelectors, cssHide) 사용 가능 여부
    public var canRemoveAds: Bool {
        return self.isPremium
    }

    /// Firebase 규칙 자동 업데이트 사용 가능 여부
    public var canFetchRules: Bool {
        return self.isPremium
    }

    /// 쿨다운 제한 적용 여부 (Admin은 제한 없음)
    public var hasCooldownLimit: Bool {
        return !self.isAdmin
    }

    /// 북마크 숨김 사용 가능 여부
    public var canHideBookmarks: Bool {
        return self.isPremium
    }

    /// 앱 잠금 사용 가능 여부
    public var canUseAppLock: Bool {
        return self.isPremium
    }

    /// 웰컴 화면 표시 여부 (Admin은 스킵, 체험 사용자도 스킵)
    public var shouldShowWelcome: Bool {
        if self.isAdmin { return false }
        if IAPManager.shared.hasUsedFreeTrial { return false }
        return true
    }

    // MARK: - 프리미엄 유도

    /// 프리미엄 기능 사용 불가 시 구독 안내 Notification 발송
    public func requestPremiumIfNeeded() {
        guard !self.isPremium else { return }
        NotificationCenter.default.post(
            name: IAPManager.needPresentPurchaseSceneNotification,
            object: nil
        )
    }
}
