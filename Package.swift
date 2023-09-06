// swift-tools-version: 5.8
import PackageDescription

let package = Package(
    name: "skip-ui",
    platforms: [.macOS("13"), .iOS("17")],
    products: [
        .library(name: "SkipUI", targets: ["SkipUI"]),
    ],
    dependencies: [ 
        .package(url: "https://source.skip.tools/skip.git", from: "0.6.39"),
        .package(url: "https://source.skip.tools/skip-foundation.git", from: "0.1.9"),
    ],
    targets: [
        .target(name: "SkipUI", dependencies: [.product(name: "SkipFoundation", package: "skip-foundation", condition: .when(platforms: [.macOS]))],
            plugins: [.plugin(name: "skipstone", package: "skip")]),
        .testTarget(name: "SkipUITests", dependencies: ["SkipUI"],
            plugins: [.plugin(name: "skipstone", package: "skip")]),
    ]
)
