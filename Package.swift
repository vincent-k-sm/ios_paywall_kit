// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "InAppPurchaseKit",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        .library(
            name: "InAppPurchaseKit",
            targets: ["InAppPurchaseKit"]
        )
    ],
    targets: [
        .target(
            name: "InAppPurchaseKit",
            resources: [
                .process("Localizable")
            ]
        ),
        .testTarget(
            name: "InAppPurchaseKitTests",
            dependencies: ["InAppPurchaseKit"]
        )
    ]
)
