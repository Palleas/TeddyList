// swift-tools-version:4.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "TeddyList",
    dependencies: [
        .package(url: "https://github.com/groue/GRDB.swift.git", .branch("Swift4")),
        .package(url: "https://github.com/apple/swift-package-manager.git", from: "0.1.0")
    ],
    targets: [
        .target(
            name: "TeddyList",
            dependencies: ["TeddyListCore"]
        ),
        .target(
            name: "TeddyListCore",
            dependencies: ["GRDB","Utility"]
        ),
        .testTarget(
            name: "TeddyListCoreTests",
            dependencies: ["GRDB", "TeddyListCore"]
        )

    ]
)
