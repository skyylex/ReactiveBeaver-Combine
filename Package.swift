// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ReactiveBeaverSwift",
    
    platforms: [
        .macOS(.v10_11)
    ],
    products: [
        // Products define the executables and libraries produced by a package, and make them visible to other packages.
        .library(
            name: "ReactiveBeaverSwift",
            targets: ["ReactiveBeaverSwift"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
         .package(url: "https://github.com/weichsel/ZIPFoundation", from: "0.9.0"),
	 .package(url: "https://github.com/tid-kijyun/Kanna.git", from: "4.0.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "ReactiveBeaverSwift",
            dependencies: ["ZIPFoundation", "Kanna"]),
        .testTarget(
            name: "ReactiveBeaverSwiftTests",
            dependencies: ["ReactiveBeaverSwift"]),
    ]
)
