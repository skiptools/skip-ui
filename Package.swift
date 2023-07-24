// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SkipUI",
    platforms: [.macOS("13"), .iOS("17")],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "SkipUI",
            targets: ["SkipUI"]),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "SkipUI"),
        .testTarget(
            name: "SkipUITests",
            dependencies: ["SkipUI"]),
    ]
)
