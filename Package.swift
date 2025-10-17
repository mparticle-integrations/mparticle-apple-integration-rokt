// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "mParticle-Rokt",
    platforms: [ .iOS(.v11), .tvOS(.v11) ], 
    products: [
        .library(
            name: "mParticle-Rokt",
            targets: ["mParticle-Rokt", "mParticle-Rokt-Swift"]),
    ],
    dependencies: [
        .package(name: "Rokt-Widget",
                 url: "https://github.com/ROKT/rokt-sdk-ios",
                 .branch("test-static-lib")),
    ],
    targets: [
        .target(
            name: "mParticle-Rokt",
            dependencies: [
                .product(name: "Rokt-Widget", package: "Rokt-Widget"),
            ],
            path: "mParticle-Rokt",
            publicHeadersPath: ".",
            linkerSettings: [
                .unsafeFlags(["-undefined", "dynamic_lookup"], .when(platforms: [.iOS, .tvOS]))
            ]
        ),
        .target(
            name: "mParticle-Rokt-Swift",
            dependencies: [
                "mParticle-Rokt",
                .product(name: "Rokt-Widget", package: "Rokt-Widget"),
            ],
            path: "mParticle-Rokt-Swift",
            linkerSettings: [
                .unsafeFlags(["-undefined", "dynamic_lookup"], .when(platforms: [.iOS, .tvOS]))
            ]
        ),
    ]
)
