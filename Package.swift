// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SampleAutoLayout",
    platforms: [
        .iOS(.v12)
    ],
    products: [
        .library(
            name: "SampleAutoLayout",
            targets: ["SampleAutoLayout"]
        ),
    ],
    targets: [
        .target(
            name: "SampleAutoLayout",
            path: "Sources/Classes",
            sources: [
                "LXConstraintExt.swift"
            ]
        )
    ]
)
