import ProjectDescription

let project = Project(
    name: "ComponentSystem",
    organizationName: "ComponentSystem",
    packages: [
        // Use the local Swift package as a dependency for the Example app
        .package(path: ".")
    ],
    settings: .settings(base: [:]),
    targets: [
        .target(
            name: "ComponentSystemExample",
            destinations: [.iPhone, .iPad],
            product: .app,
            bundleId: "dev.componentsystem.example",
            deploymentTargets: .iOS("17.0"),
            infoPlist: .file(path: "Example/App/Info.plist"),
            sources: [
                "Example/App/Sources/**"
            ],
            resources: [
                "Example/App/Resources/Assets.xcassets",
                "Example/App/Resources/Base.lproj/**"
            ],
            dependencies: [
                .package(product: "ComponentSystem")
            ]
        )
    ]
)
