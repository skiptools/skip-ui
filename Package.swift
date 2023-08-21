// swift-tools-version: 5.8
import PackageDescription

let package = Package(
    name: "skip-ui",
    platforms: [.macOS("13"), .iOS("17")],
    products: [
        .library(name: "SkipUI", targets: ["SkipUI"]),
        .library(name: "SkipUIKt", targets: ["SkipUIKt"]),
    ],
    dependencies: [ 
        .package(url: "https://source.skip.tools/skip.git", from: "0.5.92"),
        .package(url: "https://source.skip.tools/skip-unit.git", from: "0.0.17"),
        .package(url: "https://source.skip.tools/skip-lib.git", from: "0.0.14"),
        .package(url: "https://source.skip.tools/skip-foundation.git", from: "0.0.11"),
    ],
    targets: [
        .target(name: "SkipUI",
            plugins: [.plugin(name: "preflight", package: "skip")]),
        .testTarget(name: "SkipUITests", dependencies: ["SkipUI"],
            plugins: [.plugin(name: "preflight", package: "skip")]),

        .target(name: "SkipUIKt",
            dependencies: [
                "SkipUI",
                .product(name: "SkipUnitKt", package: "skip-unit"),
                .product(name: "SkipLibKt", package: "skip-lib"),
                .product(name: "SkipFoundationKt", package: "skip-foundation"),
            ],
            resources: [.process("Skip")],
            plugins: [.plugin(name: "transpile", package: "skip")]),
        .testTarget(name: "SkipUIKtTests",
            dependencies: [
                "SkipUIKt",
                .product(name: "SkipUnit", package: "skip-unit"),
                .product(name: "SkipUnitKt", package: "skip-unit"),
                .product(name: "SkipLibKt", package: "skip-lib"),
                .product(name: "SkipFoundationKt", package: "skip-foundation"),
            ], resources: [.process("Skip")], plugins: [
            .plugin(name: "transpile", package: "skip")
        ]),
    ]
)
