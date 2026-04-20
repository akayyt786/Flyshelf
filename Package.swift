// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "PocketShelf",
    platforms: [
        .macOS(.v14)
    ],
    products: [
        .executable(name: "PocketShelf", targets: ["PocketShelf"])
    ],
    dependencies: [],
    targets: [
        .executableTarget(
            name: "PocketShelf",
            dependencies: [],
            path: "PocketShelf",
            exclude: ["Resources", "Resources/PocketShelf.entitlements", "Info.plist"],
            swiftSettings: [
                .unsafeFlags(["-Xfrontend", "-enable-bare-slash-regex"])
            ]
        )
    ]
)
