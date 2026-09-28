// swift-tools-version: 6.4
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "AIKit",
    defaultLocalization: "en",
    platforms: [.iOS(.v18)],
    products: [
        .library(
            name: "AIKit",
            targets: ["AIKit"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/StanfordBDHG/llama.cpp", .upToNextMinor(from: "0.1.0"))
    ],
    targets: [
        .target(
            name: "AIEngineCpp",
            dependencies: [
                .product(name: "llama", package: "llama.cpp")
            ],
            path: "Sources/AIEngineCpp",
            cxxSettings: [
                .headerSearchPath("include"),
                .unsafeFlags(["-std=c++20"])
            ]
        ),
        .target(
            name: "AIKit",
            dependencies: [
                "AIEngineCpp"
            ],
            path: "Sources/AIKit",
            swiftSettings: [
                .interoperabilityMode(.Cxx)
            ]
        )
    ],
    swiftLanguageModes: [.v6],
    cxxLanguageStandard: .cxx20
)
