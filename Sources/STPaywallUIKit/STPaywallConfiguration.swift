//
//  STPaywallConfiguration.swift
//  STPaywallUIKit
//

import STPaywallCore
import Foundation

public struct STPaywallConfiguration {

    // MARK: - Feature Item

    public struct FeatureItem {
        public let title: String
        public let iconName: String

        public init(title: String, iconName: String) {
            self.title = title
            self.iconName = iconName
        }
    }

    // MARK: - List Scene

    public let sceneTitle: String

    // MARK: - Detail Scene

    public let detailSceneTitle: String
    public let features: [FeatureItem]
    public let headerEmoji: String
    public let headerTitleFormat: String
    public let headerSubtitle: String
    public let noticeText: String
    public let termsOfServiceURL: String
    public let privacyPolicyURL: String

    // MARK: - Service

    public let serviceBase: IAPServiceBase

    // MARK: - Initialization

    public init(
        sceneTitle: String,
        detailSceneTitle: String,
        features: [FeatureItem],
        headerEmoji: String = "✨",
        headerTitleFormat: String,
        headerSubtitle: String,
        noticeText: String,
        termsOfServiceURL: String,
        privacyPolicyURL: String,
        serviceBase: IAPServiceBase
    ) {
        self.sceneTitle = sceneTitle
        self.detailSceneTitle = detailSceneTitle
        self.features = features
        self.headerEmoji = headerEmoji
        self.headerTitleFormat = headerTitleFormat
        self.headerSubtitle = headerSubtitle
        self.noticeText = noticeText
        self.termsOfServiceURL = termsOfServiceURL
        self.privacyPolicyURL = privacyPolicyURL
        self.serviceBase = serviceBase
    }
}
