// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "mParticle-Rokt",
    platforms: [ .iOS(.v11), .tvOS(.v11) ], 
    products: [
        .library(
            name: "mParticle-Rokt",
            targets: ["mParticle-Rokt-Swift"]),
        .library(
            name: "mParticle-Rokt-NoLocation",
            targets: ["mParticle-Rokt-Swift-NoLocation"]),
    ],
    dependencies: [
      .package(name: "mParticle-Apple-SDK",
               url: "https://github.com/mParticle/mparticle-apple-sdk",
               .upToNextMajor(from: "8.0.0")),
      .package(name: "Rokt-Widget",
               url: "https://github.com/ROKT/rokt-sdk-ios",
               .upToNextMajor(from: "4.10.0")),
    ],
    targets: [
        .target(
            name: "mParticle-Rokt",
            dependencies: [
              .product(name: "mParticle-Apple-SDK", package: "mParticle-Apple-SDK"),
              .product(name: "Rokt-Widget", package: "Rokt-Widget"),
            ],
            path: "mParticle-Rokt",
            publicHeadersPath: "."
        ),
        .target(
            name: "mParticle-Rokt-Swift",
            dependencies: [
                "mParticle-Rokt",
            ],
            path: "mParticle-Rokt-Swift"
        ),
        
        .target(
            name: "mParticle-Rokt-NoLocation",
            dependencies: [
              .product(name: "mParticle-Apple-SDK-NoLocation", package: "mParticle-Apple-SDK"),
              .product(name: "Rokt-Widget", package: "Rokt-Widget"),
            ],
            path: "mParticle-Rokt-NoLocation",
            publicHeadersPath: "."
        ),
        .target(
            name: "mParticle-Rokt-Swift-NoLocation",
            dependencies: [
                "mParticle-Rokt-NoLocation",
            ],
            path: "mParticle-Rokt-Swift-NoLocation"
        ),
    ]
) 
