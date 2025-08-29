// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let swift = "-Swift"
let noLocation = "-NoLocation"

// MARK: - External Packages
let roktSDK = "Rokt-Widget"
let mpSDK = "mParticle-Apple-SDK"
let mpSDKNoLocation = mpSDK + noLocation


// MARK: - Names & Paths
let mpRokt = "mParticle-Rokt"
let mpRoktSwift = mpRokt + swift
let mpRoktNoLocation = mpRokt + noLocation
let mpRoktSwiftNoLocation = mpRoktSwift + noLocation

let package = Package(
    name: mpRokt,
    platforms: [ .iOS(.v11), .tvOS(.v11) ],
    products: [
        .library(
            name: mpRokt,
            targets: [mpRoktSwift]),
        .library(
            name: mpRoktNoLocation,
            targets: [mpRoktSwiftNoLocation]),
    ],
    dependencies: [
      .package(name: mpSDK,
               url: "https://github.com/mParticle/mparticle-apple-sdk",
               .upToNextMajor(from: "8.0.0")),
      .package(name: roktSDK,
               url: "https://github.com/ROKT/rokt-sdk-ios",
               .upToNextMajor(from: "4.10.0")),
    ],
    targets: [
        .target(
            name: mpRokt,
            dependencies: [
              .product(name: mpSDK, package: mpSDK),
              .product(name: roktSDK, package: roktSDK),
            ],
            path: mpRokt,
            publicHeadersPath: "."
        ),
        .target(
            name: mpRoktSwift,
            dependencies: [
                .target(name: mpRokt)
            ],
            path: mpRoktSwift
        ),
        
        .target(
            name: mpRoktNoLocation,
            dependencies: [
              .product(name: mpSDKNoLocation, package: mpSDK),
              .product(name: roktSDK, package: roktSDK),
            ],
            path: mpRoktNoLocation,
            publicHeadersPath: "."
        ),
        .target(
            name: mpRoktSwiftNoLocation,
            dependencies: [
                .target(name: mpRoktNoLocation)
            ],
            path: mpRoktSwiftNoLocation
        ),
    ]
) 
