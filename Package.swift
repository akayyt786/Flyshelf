// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "FlyShelf",
    platforms: [
        .macOS(.v14)
    ],
    products: [
        .executable(name: "FlyShelf", targets: ["FlyShelf"])
    ],
    dependencies: [],
    targets: [
        .executableTarget(
            name: "FlyShelf",
            dependencies: [],
            path: "FlyShelf",
            exclude: ["Resources", "Resources/FlyShelf.entitlements", "Info.plist"],
            swiftSettings: [
                .unsafeFlags(["-Xfrontend", "-enable-bare-slash-regex"])
            ]
        )
    ]
)
