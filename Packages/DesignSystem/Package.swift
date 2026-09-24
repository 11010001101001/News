// swift-tools-version: 6.4
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "DesignSystem",
    defaultLocalization: "en",
    platforms: [.iOS(.v27)],
    products: [
        .library(
            name: "DesignSystem",
            targets: ["DesignSystem"]
        )
    ],
    dependencies: [
        .package(path: "../LocalizationKit"),
        .package(path: "../CoreKit")
    ],
    targets: [
        .target(
            name: "DesignSystem",
            dependencies: [
                .product(name: "LocalizationKit", package: "LocalizationKit"),
                .product(name: "CoreKit", package: "CoreKit")
            ],
            resources: [
                .process("LottieJsons"),
                .process("Assets.xcassets"),
                .process("Sounds")
            ],
            swiftSettings: [
                .enableUpcomingFeature("ApproachableConcurrency")
            ]
        )
    ]
)
