// swift-tools-version: 6.4
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ModelsKit",
    defaultLocalization: "en",
    platforms: [.iOS(.v27)],
    products: [
        .library(
            name: "ModelsKit",
            targets: ["ModelsKit"]
        )
    ],
    dependencies: [
        .package(path: "../LocalizationKit"),
        .package(path: "../CoreKit")
    ],
    targets: [
        .target(
            name: "ModelsKit",
            dependencies: [
                .product(name: "LocalizationKit", package: "LocalizationKit"),
                .product(name: "CoreKit", package: "CoreKit")
            ],
            swiftSettings: [
                .enableUpcomingFeature("ApproachableConcurrency")
            ]
        )
    ]
)
