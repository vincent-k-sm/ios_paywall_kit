//
//  STPaywallModels.swift
//  STPaywallUIKit
//

import UIKit

// MARK: - List Section Model

public struct STPaywallSection {
    public let headerTitle: String?
    public let items: [STPaywallItem]

    public init(headerTitle: String? = nil, items: [STPaywallItem]) {
        self.headerTitle = headerTitle
        self.items = items
    }
}

// MARK: - List Item Model

public struct STPaywallItem {
    public let title: String
    public let iconName: String
    public let iconColor: UIColor
    public let accessory: Accessory
    public let isEnabled: Bool
    public let isDestructive: Bool
    public let action: () -> Void

    public enum Accessory {
        case arrow
        case label(String)
        case toggle(isOn: Bool, onChange: (Bool) -> Void)
        case none
    }

    public init(
        title: String,
        iconName: String,
        iconColor: UIColor = STPaywallColors.textSecondary,
        accessory: Accessory = .arrow,
        isEnabled: Bool = true,
        isDestructive: Bool = false,
        action: @escaping () -> Void = {}
    ) {
        self.title = title
        self.iconName = iconName
        self.iconColor = iconColor
        self.accessory = accessory
        self.isEnabled = isEnabled
        self.isDestructive = isDestructive
        self.action = action
    }
}

// MARK: - Detail Cell Types

enum STPaywallDetailCellType {
    case header(STPaywallDetailHeaderViewModel)
    case feature(STPaywallDetailFeatureViewModel)
    case product(STPaywallDetailProductViewModel)
    case restore
    case notice
    case terms
    case spacing(CGFloat)
}

struct STPaywallDetailHeaderViewModel {
    let title: String
    let subtitle: String
    let emoji: String
}

struct STPaywallDetailFeatureViewModel {
    let title: String
    let iconName: String
}

struct STPaywallDetailProductViewModel {
    let id: String
    let title: String
    let price: String
    let pricePerPeriod: String
    let periodDescription: String?
    let promotionText: String?
    let isPopular: Bool
    let index: Int
}
