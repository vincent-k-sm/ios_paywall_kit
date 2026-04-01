//
//  STPaywallDesign.swift
//  STPaywallUIKit
//

import UIKit

// MARK: - Colors

public enum STPaywallColors {

    public static let background = UIColor { traits in
        traits.userInterfaceStyle == .dark
            ? UIColor(stHex: "#1C1C1E")
            : UIColor(stHex: "#F3F6FC")
    }

    public static let backgroundWhite = UIColor { traits in
        traits.userInterfaceStyle == .dark
            ? UIColor(stHex: "#2C2C2E")
            : UIColor.white
    }

    public static let cardBackground = UIColor { traits in
        traits.userInterfaceStyle == .dark
            ? UIColor(stHex: "#3A3A3C")
            : UIColor(stHex: "#F5F7FA")
    }

    public static let contentBackground = UIColor { traits in
        traits.userInterfaceStyle == .dark
            ? UIColor(stHex: "#2C2C2E")
            : UIColor.white
    }

    public static let textPrimary = UIColor { traits in
        traits.userInterfaceStyle == .dark
            ? UIColor.white
            : UIColor(stHex: "#1C1E21")
    }

    public static let textSecondary = UIColor { traits in
        traits.userInterfaceStyle == .dark
            ? UIColor(stHex: "#ABABAB")
            : UIColor(stHex: "#4B5563")
    }

    public static let textTertiary = UIColor { traits in
        traits.userInterfaceStyle == .dark
            ? UIColor(stHex: "#8E8E93")
            : UIColor(stHex: "#6B7280")
    }

    public static let primary = UIColor(stHex: "#1F6FFF")

    public static let success = UIColor(stHex: "#00B86C")
    public static let danger = UIColor(stHex: "#F04452")

    public static let separator = UIColor { traits in
        traits.userInterfaceStyle == .dark
            ? UIColor(stHex: "#38383A")
            : UIColor(stHex: "#F2F3F5")
    }

    public static let chipBackground = UIColor { traits in
        traits.userInterfaceStyle == .dark
            ? UIColor(stHex: "#3A3A3C")
            : UIColor(stHex: "#F2F3F5")
    }
}

// MARK: - Typography

public enum STPaywallTypography {
    public static let body = UIFont.systemFont(ofSize: 16, weight: .regular)
    public static let bodyBold = UIFont.systemFont(ofSize: 16, weight: .semibold)
    public static let caption1 = UIFont.systemFont(ofSize: 13, weight: .regular)
    public static let caption1Bold = UIFont.systemFont(ofSize: 13, weight: .semibold)
}

// MARK: - Spacing

public enum STPaywallSpacing {
    public static let sm: CGFloat = 8
    public static let md: CGFloat = 12
    public static let lg: CGFloat = 16
}

// MARK: - Radius

public enum STPaywallRadius {
    public static let sm: CGFloat = 8
    public static let lg: CGFloat = 16
}

// MARK: - UIColor Hex Initializer

extension UIColor {
    convenience init(stHex hex: String) {
        var hexString = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        if hexString.hasPrefix("#") {
            hexString.removeFirst()
        }

        var rgbValue: UInt64 = 0
        Scanner(string: hexString).scanHexInt64(&rgbValue)

        self.init(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: 1.0
        )
    }
}
