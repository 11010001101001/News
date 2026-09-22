// swift-tools-version: 6.4
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Features",
    defaultLocalization: "en",
    platforms: [.iOS(.v27)],
    products: [
        .library(
            name: "Features",
            targets: ["Features"]
        ),
    ],
    dependencies: [
        .package(path: "../ModelsKit"),
        .package(path: "../CoreKit"),
        .package(path: "../DesignSystem"),
        .package(path: "../LocalizationKit")
    ],
    targets: [
        .target(
            name: "Features",
            dependencies: [
                .product(name: "ModelsKit", package: "ModelsKit"),
                .product(name: "CoreKit", package: "CoreKit"),
                .product(name: "DesignSystem", package: "DesignSystem"),
                .product(name: "LocalizationKit", package: "LocalizationKit")
            ],
            swiftSettings: [
                .enableUpcomingFeature("ApproachableConcurrency"),
            ],
        ),

    ]
)
