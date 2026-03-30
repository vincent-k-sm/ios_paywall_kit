//
//  I18N.swift
//  InAppPurchaseKit
//

import Foundation

enum I18N {
    // MARK: - Errors
    static let error_verification_failed = NSLocalizedString(
        "iap_error_verification_failed",
        bundle: Bundle.module,
        comment: ""
    )
    static let error_no_products = NSLocalizedString(
        "iap_error_no_products",
        bundle: Bundle.module,
        comment: ""
    )
    static let error_purchase_failed = NSLocalizedString(
        "iap_error_purchase_failed",
        bundle: Bundle.module,
        comment: ""
    )
    static let error_restore_failed = NSLocalizedString(
        "iap_error_restore_failed",
        bundle: Bundle.module,
        comment: ""
    )
    static let error_timeout = NSLocalizedString(
        "iap_error_timeout",
        bundle: Bundle.module,
        comment: ""
    )

    // MARK: - Messages
    static let msg_purchase_success = NSLocalizedString(
        "iap_msg_purchase_success",
        bundle: Bundle.module,
        comment: ""
    )
    static let msg_restore_success = NSLocalizedString(
        "iap_msg_restore_success",
        bundle: Bundle.module,
        comment: ""
    )

    // MARK: - Alerts
    static let alert_subscription_required_title = NSLocalizedString(
        "iap_alert_subscription_required_title",
        bundle: Bundle.module,
        comment: ""
    )
    static let alert_subscription_required_message = NSLocalizedString(
        "iap_alert_subscription_required_message",
        bundle: Bundle.module,
        comment: ""
    )
    static let alert_subscription_required_action = NSLocalizedString(
        "iap_alert_subscription_required_action",
        bundle: Bundle.module,
        comment: ""
    )
    static let alert_cancel = NSLocalizedString(
        "iap_alert_cancel",
        bundle: Bundle.module,
        comment: ""
    )

    // MARK: - Reward Code (Firebase)
    static let reward_section_title = NSLocalizedString(
        "iap_reward_section_title",
        bundle: Bundle.module,
        comment: ""
    )
    static let reward_section_description = NSLocalizedString(
        "iap_reward_section_description",
        bundle: Bundle.module,
        comment: ""
    )
    static let reward_input_placeholder = NSLocalizedString(
        "iap_reward_input_placeholder",
        bundle: Bundle.module,
        comment: ""
    )
    static let reward_button_verify = NSLocalizedString(
        "iap_reward_button_verify",
        bundle: Bundle.module,
        comment: ""
    )
    static let reward_apple_signin_title = NSLocalizedString(
        "iap_reward_apple_signin_title",
        bundle: Bundle.module,
        comment: ""
    )
    static let reward_apple_signin_description = NSLocalizedString(
        "iap_reward_apple_signin_description",
        bundle: Bundle.module,
        comment: ""
    )
    static let reward_apple_signin_button = NSLocalizedString(
        "iap_reward_apple_signin_button",
        bundle: Bundle.module,
        comment: ""
    )

    // MARK: - PremiumFeatureManager - Feature Descriptions
    static let feature_unlimited_items = NSLocalizedString("iap_feature_unlimited_items", bundle: Bundle.module, comment: "")
    static let feature_custom_tags = NSLocalizedString("iap_feature_custom_tags", bundle: Bundle.module, comment: "")
    static let feature_unlimited_photos = NSLocalizedString("iap_feature_unlimited_photos", bundle: Bundle.module, comment: "")
    static let feature_unlimited_memos = NSLocalizedString("iap_feature_unlimited_memos", bundle: Bundle.module, comment: "")
    static let feature_app_lock = NSLocalizedString("iap_feature_app_lock", bundle: Bundle.module, comment: "")
    static let feature_priority_support = NSLocalizedString("iap_feature_priority_support", bundle: Bundle.module, comment: "")

    // MARK: - PremiumFeatureManager - Free Limit Descriptions
    static let free_limit_items = NSLocalizedString("iap_free_limit_items", bundle: Bundle.module, comment: "")
    static let free_limit_tags = NSLocalizedString("iap_free_limit_tags", bundle: Bundle.module, comment: "")
    static let free_limit_photos = NSLocalizedString("iap_free_limit_photos", bundle: Bundle.module, comment: "")
    static let free_limit_memos = NSLocalizedString("iap_free_limit_memos", bundle: Bundle.module, comment: "")
    static let free_limit_app_lock = NSLocalizedString("iap_free_limit_app_lock", bundle: Bundle.module, comment: "")
    static let free_limit_support = NSLocalizedString("iap_free_limit_support", bundle: Bundle.module, comment: "")

    // MARK: - ProService
    static let promo_code_not_found = NSLocalizedString("iap_promo_code_not_found", bundle: Bundle.module, comment: "")
    static let promo_code_invalid = NSLocalizedString("iap_promo_code_invalid", bundle: Bundle.module, comment: "")
    static let promo_success_lifetime = NSLocalizedString("iap_promo_success_lifetime", bundle: Bundle.module, comment: "")
    static let promo_success_until = NSLocalizedString("iap_promo_success_until", bundle: Bundle.module, comment: "")
    static let promo_unknown_error = NSLocalizedString("iap_promo_unknown_error", bundle: Bundle.module, comment: "")
}
