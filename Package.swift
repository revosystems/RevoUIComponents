// swift-tools-version:5.5
import PackageDescription

let package = Package(
    name: "RevoUIComponents",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(
            name: "RevoUIComponents",
            targets: ["RevoUIComponents"]
        ),
    ],
    dependencies: [
        .package(
            name: "RevoUIComponents",
            url: "https://github.com/revosystems/foundation.git",
            .exact("0.2.22"))
    ],
    targets: [
        .target(
            name: "RevoUIComponents",
            dependencies: ["RevoFoundation"],
            path: "RevoUIComponents/src",
        ),
    ],
    swiftLanguageVersions: [.v5]
)
