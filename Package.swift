// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "OpenAlpha",
    platforms: [
        .iOS("14.0"),
        .macOS("10.15")
    ],
    products: [
        .library(
            name: "OpenAlpha",
            targets: ["OpenAlpha"]),
    ],
    targets: [
        .target(
            name: "OpenAlpha",
            dependencies: []
        ),
        .testTarget(
            name: "OpenAlphaTests",
            dependencies: ["OpenAlpha"]
        ),
    ]
)
