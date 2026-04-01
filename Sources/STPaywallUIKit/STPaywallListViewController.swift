//
//  STPaywallListViewController.swift
//  STPaywallUIKit
//

import Combine
import STPaywallCore
import SnapKit
import StoreKit
import UIKit

open class STPaywallListViewController: UIViewController {
    deinit { }

    // MARK: - UI Components

    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.backgroundColor = STPaywallColors.background
        tableView.separatorStyle = .singleLine
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 62, bottom: 0, right: 0)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(STPaywallListCell.self, forCellReuseIdentifier: STPaywallListCell.stIdentifier)
        tableView.register(STPaywallListHeaderView.self, forHeaderFooterViewReuseIdentifier: STPaywallListHeaderView.stIdentifier)
        tableView.keyboardDismissMode = .onDrag
        return tableView
    }()

    // MARK: - Properties

    public let configuration: STPaywallConfiguration
    private var subscriptionItems: [SubscriptionItem] = SubscriptionItem.allCases
    private var cachedAdditionalSections: [STPaywallSection] = []
    private var cancellables = Set<AnyCancellable>()

    private var serviceBase: IAPServiceBase {
        return self.configuration.serviceBase
    }

    // MARK: - Initialization

    public init(configuration: STPaywallConfiguration) {
        self.configuration = configuration
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    open override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()

        self.serviceBase.statusPublisher
            .removeDuplicates()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.reloadAllSections()
            }
            .store(in: &self.cancellables)

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.appDidBecomeActive),
            name: UIApplication.didBecomeActiveNotification,
            object: nil
        )
    }

    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.reloadAllSections()
    }

    @objc private func appDidBecomeActive() {
        guard self.viewIfLoaded?.window != nil else { return }
        self.reloadAllSections()
    }

    // MARK: - Setup Methods

    private func setupUI() {
        self.view.backgroundColor = STPaywallColors.background
        self.navigationItem.title = self.configuration.sceneTitle

        if let items = self.trailingBarButtonItems() {
            self.navigationItem.rightBarButtonItems = items
        }

        self.view.addSubview(self.tableView)

        self.tableView.snp.makeConstraints { make in
            make.edges.equalTo(self.view.safeAreaLayoutGuide)
        }
    }

    // MARK: - Open Override Points

    /// 프로젝트별 추가 섹션. 구독 관리 섹션 아래에 순서대로 표시.
    open func additionalSections() -> [STPaywallSection] {
        return []
    }

    /// 네비게이션 우측 버튼. 기본: nil.
    open func trailingBarButtonItems() -> [UIBarButtonItem]? {
        return nil
    }

    /// Detail 화면 생성. 커스텀 Detail VC 사용 시 오버라이드.
    open func makePurchaseDetailViewController() -> UIViewController {
        return STPaywallDetailViewController(configuration: self.configuration)
    }

    /// 토스트 메시지 표시. 기본: no-op. 프로젝트에서 오버라이드.
    open func showToast(_ message: String) {
        // 프로젝트에서 MKToast 등으로 오버라이드
    }

    /// 로딩 표시. 기본: no-op. 프로젝트에서 오버라이드.
    open func showLoading(_ isLoading: Bool) {
        // 프로젝트에서 ProgressView 등으로 오버라이드
    }

    /// 구독 상태 텍스트. 기본: 프리미엄이면 "구독 중".
    open func subscriptionStatusText() -> String? {
        guard self.serviceBase.isPremium else { return nil }
        return I18N.list_status_subscribed
    }

    // MARK: - Public Methods

    /// 추가 섹션 데이터를 갱신합니다.
    public func reloadAdditionalSections() {
        self.cachedAdditionalSections = self.additionalSections()
        self.tableView.reloadData()
    }

    // MARK: - Private Methods

    private func reloadAllSections() {
        self.cachedAdditionalSections = self.additionalSections()
        self.tableView.reloadData()
    }

    private func restorePurchase() {
        self.showLoading(true)

        Task {
            do {
                let restored = try await self.serviceBase.restorePurchases()
                await MainActor.run {
                    self.showLoading(false)
                    if restored {
                        self.showToast(I18N.list_msg_restore_success)
                        self.reloadAllSections()
                    }
                    else {
                        self.showToast(I18N.list_msg_restore_failed)
                    }
                }
            }
            catch {
                await MainActor.run {
                    self.showLoading(false)
                    self.showToast(error.localizedDescription)
                }
            }
        }
    }

    private func openManageSubscription() {
        self.serviceBase.openManageSubscriptions()
    }

    private func presentPurchaseDetail() {
        let detailVC = self.makePurchaseDetailViewController()
        let navController = UINavigationController(rootViewController: detailVC)
        navController.modalPresentationStyle = .fullScreen
        self.present(navController, animated: true, completion: nil)
    }
}

// MARK: - Subscription Items

extension STPaywallListViewController {

    enum SubscriptionItem: CaseIterable {
        case subscriptionInfo
        case restore
        case manageSubscription

        var title: String {
            switch self {
                case .subscriptionInfo:
                    return I18N.list_menu_subscription_info
                case .restore:
                    return I18N.list_menu_restore
                case .manageSubscription:
                    return I18N.list_menu_manage_subscription
            }
        }

        var icon: String {
            switch self {
                case .subscriptionInfo:
                    return "creditcard"
                case .restore:
                    return "arrow.clockwise"
                case .manageSubscription:
                    return "gearshape"
            }
        }
    }
}

// MARK: - UITableViewDataSource

extension STPaywallListViewController: UITableViewDataSource {

    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1 + self.cachedAdditionalSections.count
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return self.subscriptionItems.count
        }
        return self.cachedAdditionalSections[section - 1].items.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: STPaywallListCell.stIdentifier,
            for: indexPath
        ) as? STPaywallListCell else {
            return UITableViewCell()
        }

        if indexPath.section == 0 {
            let item = self.subscriptionItems[indexPath.row]
            var statusText: String? = nil
            if case .subscriptionInfo = item {
                statusText = self.subscriptionStatusText()
            }
            cell.configure(title: item.title, icon: item.icon, statusText: statusText)
        }
        else {
            let additionalItem = self.cachedAdditionalSections[indexPath.section - 1].items[indexPath.row]
            switch additionalItem.accessory {
                case let .toggle(isOn, onChange):
                    cell.configure(
                        title: additionalItem.title,
                        icon: additionalItem.iconName,
                        isDestructive: additionalItem.isDestructive,
                        hasSwitch: true,
                        isSwitchOn: isOn,
                        isDisabled: !additionalItem.isEnabled
                    )
                    cell.onSwitchChanged = onChange

                case let .label(text):
                    cell.configure(
                        title: additionalItem.title,
                        icon: additionalItem.iconName,
                        isDestructive: additionalItem.isDestructive,
                        statusText: text,
                        isDisabled: !additionalItem.isEnabled
                    )

                case .arrow, .none:
                    cell.configure(
                        title: additionalItem.title,
                        icon: additionalItem.iconName,
                        isDestructive: additionalItem.isDestructive,
                        isDisabled: !additionalItem.isEnabled
                    )
            }
        }

        return cell
    }

    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerView = tableView.dequeueReusableHeaderFooterView(
            withIdentifier: STPaywallListHeaderView.stIdentifier
        ) as? STPaywallListHeaderView else { return nil }

        if section == 0 {
            headerView.configure(title: I18N.list_section_subscription)
        }
        else {
            let sectionModel = self.cachedAdditionalSections[section - 1]
            headerView.configure(title: sectionModel.headerTitle ?? "")
        }
        return headerView
    }

    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
}

// MARK: - UITableViewDelegate

extension STPaywallListViewController: UITableViewDelegate {

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        if indexPath.section == 0 {
            let item = self.subscriptionItems[indexPath.row]
            switch item {
                case .subscriptionInfo:
                    self.presentPurchaseDetail()
                case .restore:
                    self.restorePurchase()
                case .manageSubscription:
                    self.openManageSubscription()
            }
        }
        else {
            let additionalItem = self.cachedAdditionalSections[indexPath.section - 1].items[indexPath.row]
            if case .toggle = additionalItem.accessory {
                return
            }
            additionalItem.action()
        }
    }

    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 52
    }
}

// MARK: - STPaywallListHeaderView Identifier

extension STPaywallListHeaderView {
    static var stIdentifier: String {
        return String(describing: self)
    }
}
