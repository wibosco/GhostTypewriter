// swift-tools-version:5.0

import PackageDescription

let package = Package(
    name: "GhostTypewriter",
    platforms: [.iOS(.v10)],
    products: [
        .library(
            name: "GhostTypewriter",
            targets: ["GhostTypewriter"]
        )
    ],
    targets: [
        .target(
            name: "GhostTypewriter",
            path: "GhostTypewriter"
        ),
        .testTarget(
            name: "GhostTypewriterTests",
            dependencies: ["GhostTypewriter"],
            path: "GhostTypewriterTests"
        )
    ]
)
