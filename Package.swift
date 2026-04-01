// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "STPaywallKit",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(
            name: "STPaywallCore",
            targets: ["STPaywallCore"]
        ),
        .library(
            name: "STPaywallUIKit",
            targets: ["STPaywallUIKit"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/SnapKit/SnapKit", .upToNextMajor(from: Version(5, 0, 0)))
    ],
    targets: [
        .target(
            name: "STPaywallCore",
            path: "Sources/STPaywallCore",
            resources: [
                .process("Localizable")
            ]
        ),
        .target(
            name: "STPaywallUIKit",
            dependencies: [
                "STPaywallCore",
                "SnapKit"
            ],
            path: "Sources/STPaywallUIKit",
            resources: [
                .process("Localizable")
            ]
        ),
        .testTarget(
            name: "STPaywallCoreTests",
            dependencies: ["STPaywallCore"],
            path: "Tests/STPaywallCoreTests"
        )
    ]
)
