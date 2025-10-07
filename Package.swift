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
    ],
    dependencies: [
      .package(name: "mParticle-Apple-SDK",
               url: "https://github.com/mParticle/mparticle-apple-sdk",
               .upToNextMajor(from: "8.0.0")),
      .package(name: "Rokt-Widget",
               url: "https://github.com/ROKT/rokt-sdk-ios",
               .revision("485507587a376291c5f0e46fea55a3503b10dbe0")),
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
                .product(name: "mParticle-Apple-SDK", package: "mParticle-Apple-SDK"),
                .product(name: "Rokt-Widget", package: "Rokt-Widget"),
            ],
            path: "mParticle-Rokt-Swift"
        ),
    ]
) 
