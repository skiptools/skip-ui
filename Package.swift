// swift-tools-version: 5.8
import PackageDescription

let package = Package(
    name: "skip-ui",
    platforms: [.macOS("13"), .iOS("17")],
    products: [
        .library(name: "SkipUI", targets: ["SkipUI"]),
    ],
    dependencies: [ 
        .package(url: "https://source.skip.tools/skip.git", from: "0.6.60"),
        .package(url: "https://source.skip.tools/skip-model.git", from: "0.0.6"),
    ],
    targets: [
        .target(name: "SkipUI", dependencies: [.product(name: "SkipModel", package: "skip-model", condition: .when(platforms: [.macOS]))],
            plugins: [.plugin(name: "skipstone", package: "skip")]),
        .testTarget(name: "SkipUITests", dependencies: ["SkipUI", .product(name: "SkipTest", package: "skip", condition: .when(platforms: [.macOS]))],
            plugins: [.plugin(name: "skipstone", package: "skip")]),
    ]
)
