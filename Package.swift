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
        .package(url: "https://github.com/revosystems/revofoundation.git", .upToNextMinor(from: "0.2.0"))
    ],
    targets: [
        .target(
            name: "RevoUIComponents",
            dependencies: [
                .product(name: "RevoFoundation", package: "revofoundation")
            ],
            path: "RevoUIComponents/src",
            exclude: [],
            resources: [] // Afegeix recursos si n'hi ha
        ),
    ],
    swiftLanguageVersions: [.v5]
)
