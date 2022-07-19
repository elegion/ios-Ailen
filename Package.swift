// swift-tools-version:5.2

import PackageDescription

let package = Package(
    name: "Ailen",
    platforms: [
        .iOS(.v10),
    ],
    products: [
        .library(
            name: "Ailen",
            targets: ["Ailen"]
        ),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "Ailen",
            dependencies: [],
            path: "Source",
            exclude: ["CoreDataOutput"]
        ),
    ]
)
