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
    targets: [
        .target(
            name: "AIEngineCpp",
            dependencies: [
                "llama"
            ],
            path: "Sources/AIEngineCpp",
            cxxSettings: [
                .headerSearchPath("include"),
                .headerSearchPath("../llama.xcframework/ios-arm64/llama.framework/Headers"),
                .unsafeFlags(["-std=c++20"])
            ]
        ),
        .target(
            name: "AIKit",
            dependencies: [
                "AIEngineCpp"
            ],
            path: "Sources/AIKit",
            resources: [
                .process("LLM")
            ],
            swiftSettings: [
                .interoperabilityMode(.Cxx)
            ]
        ),
        .binaryTarget(
            name: "llama",
            path: "Sources/llama.xcframework"
        )
    ],
    swiftLanguageModes: [.v6],
    cxxLanguageStandard: .cxx20
)
