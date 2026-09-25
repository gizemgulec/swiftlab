// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "SwiftLab",
    platforms: [
        .macOS(.v13),
        .iOS(.v16)
    ],
    products: [
        .library(
            name: "SwiftLab",
            targets: ["SwiftLab"]
        )
    ],
    targets: [
        .target(
            name: "SwiftLab"
        ),
        .testTarget(
            name: "SwiftLabTests",
            dependencies: ["SwiftLab"]
        )
    ]
)
