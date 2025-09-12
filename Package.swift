// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ComponentSystem",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "ComponentSystem",
            targets: ["ComponentSystem"]),
    ],
    dependencies: [
        .package(url: "https://github.com/layoutBox/PinLayout.git", from: "1.10.6"),
        .package(url: "https://github.com/layoutBox/FlexLayout.git", from: "2.2.2")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "ComponentSystem",
            dependencies: [
                .product(name: "PinLayout", package: "PinLayout"),
                .product(name: "FlexLayout", package: "FlexLayout")
            ]
        ),
        .testTarget(
            name: "ComponentSystemTests",
            dependencies: ["ComponentSystem"]
        ),
    ]
)
