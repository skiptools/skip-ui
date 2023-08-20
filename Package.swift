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
        .package(url: "https://skip.tools/skiptools/skip.git", from: "0.0.0"),
        .package(url: "https://skip.tools/skiptools/skip-unit.git", from: "0.0.0"),
        .package(url: "https://skip.tools/skiptools/skip-lib.git", from: "0.0.0"),
        .package(url: "https://skip.tools/skiptools/skip-foundation.git", from: "0.0.0"),
    ],
    targets: [
        .target(name: "SkipUI",
            plugins: [.plugin(name: "preflight", package: "skip")]),
        .testTarget(name: "SkipUITests", dependencies: ["SkipUI"],
            plugins: [.plugin(name: "preflight", package: "skip")]),

        .target(name: "SkipUIKt",
            dependencies: [ "SkipUI", .product(name: "SkipUIKt", package: "skiphub") ],
            resources: [.process("Skip")],
            plugins: [.plugin(name: "transpile", package: "skip")]),
        .testTarget(name: "SkipUIKtTests",
            dependencies: ["SkipUIKt", .product(name: "SkipUnitKt", package: "skiphub")], resources: [.process("Skip")], plugins: [
            .plugin(name: "transpile", package: "skip")
        ]),
    ]
)
