// swift-tools-version: 5.8
import PackageDescription

let package = Package(
    name: "SwiftUI",
    platforms: [.macOS("13"), .iOS("17")],
    products: [
        .library(name: "SwiftUI", targets: ["SwiftUI"]),
        .library(name: "SwiftUIKt", targets: ["SwiftUIKt"]),
    ],
    dependencies: [ 
        .package(url: "https://skip.tools/skiptools/skip.git", from: "0.5.13"),
        .package(url: "https://github.com/skiptools/skiphub.git", from: "0.4.10"),
    ],  
    targets: [
        .target(name: "SwiftUI",
            plugins: [.plugin(name: "preflight", package: "skip")]),
        .testTarget(name: "SwiftUITests", dependencies: ["SwiftUI"],
            plugins: [.plugin(name: "preflight", package: "skip")]),

        .target(name: "SwiftUIKt",
            dependencies: [ "SwiftUI", .product(name: "SkipFoundationKt", package: "skiphub", moduleAliases: ["SwiftUI": "SwiftUIOld"]) ],
            resources: [.process("Skip")],
            plugins: [.plugin(name: "transpile", package: "skip")]),
        .testTarget(name: "SwiftUIKtTests",
            dependencies: ["SwiftUIKt", .product(name: "SkipUnitKt", package: "skiphub")], resources: [.process("Skip")], plugins: [
            .plugin(name: "transpile", package: "skip")
        ]),
    ]
)
