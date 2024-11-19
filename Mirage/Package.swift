// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "Mirage",
  platforms: [.macOS(.v15), .iOS(.v18), .visionOS(.v2)],
  products: [.library(name: "Mirage", targets: ["Mirage"])],
  dependencies: [],
  targets: [
    .target(
      name: "Mirage",
      path: "Sources",
      swiftSettings: [.enableExperimentalFeature("StrictConcurrency")]
    )
  ]
)
