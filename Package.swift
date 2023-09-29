// swift-tools-version: 5.6

import PackageDescription

let package = Package(
    name: "Personnummer",
    products: [
        .library(name: "Personnummer", targets: ["Personnummer"]),
    ],
    targets: [
        .target(
            name: "Personnummer",
            dependencies: [],
            path: "source"
        ),
        .testTarget(
            name: "PersonnummerTests",
            dependencies: ["Personnummer"],
            path: "PersonnummerExample/PersonnummerExampleTests",
            exclude: ["Info.plist"]
        ),
    ]
)
