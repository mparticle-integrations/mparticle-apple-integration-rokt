// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "mParticle-Rokt",
    platforms: [ .iOS(.v11), .tvOS(.v11) ], 
    products: [
        .library(
            name: "mParticle-Rokt",
            targets: ["mParticle-Rokt"]),
    ],
    dependencies: [
      .package(name: "mParticle-Apple-SDK",
               url: "https://github.com/mParticle/mparticle-apple-sdk",
               .upToNextMajor(from: "8.0.0"))

    ],
    targets: [
        .binaryTarget(
            name: "Rokt_Widget",
            path: "Rokt_Widget.xcframework"
        ),
        .target(
            name: "mParticle-Rokt",
            dependencies: [
              .product(name: "mParticle-Apple-SDK", package: "mParticle-Apple-SDK"),
              "Rokt_Widget"
            ],
            path: "mParticle-Rokt",
            publicHeadersPath: "."
        ),
    ]
) 
