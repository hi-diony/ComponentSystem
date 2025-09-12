// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ComponentSystem",
    defaultLocalization: "en",
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
        // Main library target
        .target(
            name: "ComponentSystem",
            dependencies: [
                .product(name: "PinLayout", package: "PinLayout"),
                .product(name: "FlexLayout", package: "FlexLayout")
            ]
        ),
        
        // Example app target (not included in products, so not distributed)
        .executableTarget(
            name: "Example",
            dependencies: ["ComponentSystem"],
            path: "Example"
        ),
        
        // Test target
        .testTarget(
            name: "ComponentSystemTests",
            dependencies: ["ComponentSystem"]
        ),
    ]
)
