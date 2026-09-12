// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "skip-ui",
    platforms: [.iOS(.v16), .macOS(.v13), .tvOS(.v16), .watchOS(.v9), .macCatalyst(.v16)],
    products: [
        .library(name: "SkipUI", targets: ["SkipUI"]),
    ],
    dependencies: [ 
        .package(url: "https://github.com/skiptools/skip.git", from: "1.9.6"),
        .package(url: "https://github.com/skiptools/skip-model.git", from: "1.7.7"),
    ],
    targets: [
        .target(name: "SkipUI", dependencies: [.product(name: "SkipModel", package: "skip-model")], swiftSettings: webSwiftSettings(), plugins: [.plugin(name: "skipstone", package: "skip")]),
        .testTarget(name: "SkipUITests", dependencies: ["SkipUI", .product(name: "SkipTest", package: "skip")], resources: [.process("Resources")], plugins: [.plugin(name: "skipstone", package: "skip")]),
    ]
)

private func webSwiftSettings() -> [SwiftSetting] {
    Context.environment["SKIP_WEB"] == "1" ? [.define("SKIP_WEB")] : []
}

if Context.environment["SKIP_WEB"] == "1" {
    package.products += [.library(name: "SwiftUI", targets: ["SwiftUI"])]
    package.targets += [.target(name: "SwiftUI", dependencies: ["SkipUI"])]
}

if Context.environment["SKIP_BRIDGE"] ?? "0" != "0" {
    package.dependencies += [.package(url: "https://github.com/skiptools/skip-bridge.git", "0.0.0"..<"2.0.0")]
    package.targets.forEach({ target in
        target.dependencies += [.product(name: "SkipBridge", package: "skip-bridge")]
    })
    // all library types must be dynamic to support bridging
    package.products = package.products.map({ product in
        guard let libraryProduct = product as? Product.Library else { return product }
        return .library(name: libraryProduct.name, type: .dynamic, targets: libraryProduct.targets)
    })
}
