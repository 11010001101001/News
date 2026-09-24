// swift-tools-version: 6.4
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "CoreKit",
    defaultLocalization: "en",
    platforms: [.iOS(.v27)],
    products: [
        .library(
            name: "CoreKit",
            targets: ["CoreKit"]
        )
    ],
    dependencies: [
        .package(path: "../LocalizationKit")
    ],
    targets: [
        .target(
            name: "CoreKit",
            dependencies: [
                .product(name: "LocalizationKit", package: "LocalizationKit")
            ],
            swiftSettings: [
                .enableUpcomingFeature("ApproachableConcurrency")
            ]
        )
    ]
)
