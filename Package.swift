// swift-tools-version: 5.8
import PackageDescription

let package = Package(
    name: "skip-uix",
    platforms: [.macOS("13"), .iOS("17")],
    products: [
        .library(name: "SkipUIX", targets: ["SkipUIX"]),
        .library(name: "SkipUIXKt", targets: ["SkipUIXKt"]),
    ],
    dependencies: [ 
        .package(url: "https://skip.tools/skiptools/skip.git", from: "0.0.0"),
        .package(url: "https://skip.tools/skiptools/skiphub.git", from: "0.0.0"),
    ],
    targets: [
//        .target(name: "SkipUIX"),
//        .testTarget(name: "SkipUIXTests", dependencies: ["SkipUIX"]),

        .target(name: "SkipUIX",
            plugins: [.plugin(name: "preflight", package: "skip")]),
        .testTarget(name: "SkipUIXTests", dependencies: ["SkipUIX"],
            plugins: [.plugin(name: "preflight", package: "skip")]),

        .target(name: "SkipUIXKt",
            dependencies: [ "SkipUIX", .product(name: "SkipUIKt", package: "skiphub") ],
            resources: [.process("Skip")],
            plugins: [.plugin(name: "transpile", package: "skip")]),
        .testTarget(name: "SkipUIXKtTests",
            dependencies: ["SkipUIXKt", .product(name: "SkipUnitKt", package: "skiphub")], resources: [.process("Skip")], plugins: [
            .plugin(name: "transpile", package: "skip")
        ]),
    ]
)

import class Foundation.ProcessInfo

// For Skip library development in peer directories, run: SKIPLOCAL=.. xed Package.swift
if let localPath = ProcessInfo.processInfo.environment["SKIPLOCAL"] {
    package.dependencies[0] = .package(path: localPath + "/skip")
//    package.dependencies[1] = .package(path: localPath + "/skiphub")
}
