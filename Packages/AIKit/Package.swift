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
            targets: ["Engine"]
        )
    ],
    targets: [
        .target(
            name: "Bridge",
            dependencies: [ "llama" ],
            path: "Sources/Bridge",
            cxxSettings: [
                .headerSearchPath("include"),
                .headerSearchPath("../llama.xcframework/ios-arm64/llama.framework/Headers"),
                .unsafeFlags(["-std=c++20"])
            ]
        ),
        .target(
            name: "Engine",
            dependencies: [ "Bridge" ],
            path: "Sources/Engine",
            resources: [ .process("../qwen2.5-1.5b-instruct-q4_k_m.gguf") ],
            swiftSettings: [ .interoperabilityMode(.Cxx) ]
        ),
        .binaryTarget(
            name: "llama",
            path: "Sources/llama.xcframework"
        )
    ],
    swiftLanguageModes: [.v6],
    cxxLanguageStandard: .cxx20
)
