// swift-tools-version:4.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "TeddyList",
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        // .package(url: "https://github.com/stephencelis/SQLite.swift.git", .branch("swift-4"))
        .package(url: "https://github.com/groue/GRDB.swift.git", .branch("Swift4"))
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "TeddyList",
            dependencies: ["TeddyListCore"]
        ),
        .target(
            name: "TeddyListCore",
            dependencies: ["GRDB"]
        ),
        .testTarget(
            name: "TeddyListCoreTests",
            dependencies: ["GRDB", "TeddyListCore"]
        )

    ]
)
