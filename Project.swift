import ProjectDescription

let project = Project(
    name: "ProjectNewShoe",
    packages: [
        .remote(
            url: "https://github.com/pointfreeco/swift-composable-architecture",
            requirement: .upToNextMajor(from: "0.20.0")
        ),
    ],
    targets: [
        Target(
            name: "ProjectNewShoe",
            platform: .iOS,
            product: .app,
            bundleId: "com.unieklee.ProjectNewShoe",
            infoPlist: "Config/ProjectNewShoe.plist",
            sources: [
                "Sources/**"
            ],
            resources: [
                "Resources/**"
            ],
            entitlements: "Config/ProjectNewShoe.entitlements",
            dependencies: [
                .sdk(name: "HealthKit.framework", status: .required),
                .package(product: "ComposableArchitecture")
            ]
        ),
        Target(
            name: "ProjectNewShoe_UnitTests",
            platform: .iOS,
            product: .unitTests,
            bundleId: "com.unieklee.PNSUnitTests",
            infoPlist: "UnitTests/Info.plist",
            sources: [
                "UnitTests/Sources/**"
            ],
//            resources: [
//                "UnitTests/Resources/**"
//            ],
            dependencies: [
                .xctest,
                .target(name: "ProjectNewShoe")
            ]
        )
    ]
)
