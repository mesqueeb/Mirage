// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "Mirage",
  platforms: [.macOS(.v15), .iOS(.v18), .visionOS(.v2)],
  products: [.library(name: "Mirage", targets: ["Mirage"])],
  dependencies: [
    .package(url: "https://github.com/mesqueeb/JustSugar", from: "0.2.2"),
    .package(url: "https://github.com/mesqueeb/MapSugar", from: "0.1.0"),
  ],
  targets: [
    .target(
      name: "Mirage",
      dependencies: ["JustSugar", "MapSugar"],
      path: "Sources",
      swiftSettings: [.enableExperimentalFeature("StrictConcurrency")]
    )
  ]
)
