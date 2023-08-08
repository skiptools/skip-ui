// swift-tools-version: 5.8
import PackageDescription

let package = Package(
    name: "SkipUI",
    platforms: [.macOS("13"), .iOS("17")],
    products: [
        .library(name: "SkipUI", targets: ["SkipUI"]),
//        .library(name: "SkipUIKt", targets: ["SkipUIKt"]),
    ],
    dependencies: [ 
//        .package(url: "https://skip.tools/skiptools/skip.git", from: "0.0.0"),
//        .package(url: "https://skip.tools/skiptools/skiphub.git", from: "0.0.0"),
    ],
    targets: [
        .target(name: "SkipUI"),
        .testTarget(name: "SkipUITests", dependencies: ["SkipUI"]),

//        .target(name: "SkipUI",
//            plugins: [.plugin(name: "preflight", package: "skip")]),
//        .testTarget(name: "SkipUITests", dependencies: ["SkipUI"],
//            plugins: [.plugin(name: "preflight", package: "skip")]),

//        .target(name: "SkipUIKt",
//            dependencies: [ "SkipUI", .product(name: "SkipFoundationKt", package: "skiphub") ],
//            resources: [.process("Skip")],
//            plugins: [.plugin(name: "transpile", package: "skip")]),
//        .testTarget(name: "SkipUIKtTests",
//            dependencies: ["SkipUIKt", .product(name: "SkipUnitKt", package: "skiphub")], resources: [.process("Skip")], plugins: [
//            .plugin(name: "transpile", package: "skip")
//        ]),
    ]
)

import class Foundation.ProcessInfo

// For Skip library development in peer directories, run: SKIPLOCAL=.. xed Package.swift
if let localPath = ProcessInfo.processInfo.environment["SKIPLOCAL"] {
//    package.dependencies[0] = .package(path: localPath + "/skip")
//    package.dependencies[1] = .package(path: localPath + "/skiphub")
}
