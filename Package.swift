// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Text",
    platforms: [
        .macOS(.v13),
        .iOS(.v14),
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "Text",
            targets: ["Text"]),
        .library(
            name: "TextSwiftUI",
            targets: ["Text"]),
    ],
    dependencies: [
        .package(url: "https://github.com/OperatorFoundation/Datable", from: "4.0.1"),
        .package(url: "https://github.com/OperatorFoundation/SwiftHexTools", from: "1.2.6"),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "Text",
            dependencies: [
                "Datable",
                "SwiftHexTools",
            ]
        ),
        .target(
            name: "TextSwiftUI",
            dependencies: [
                "Datable",
                "SwiftHexTools",
            ]
        ),
        .testTarget(
            name: "TextTests",
            dependencies: ["Text"]),
    ],
    swiftLanguageVersions: [.v5]
)
