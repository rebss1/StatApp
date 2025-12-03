// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "StatLogic",
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "StatLogic",
            targets: ["StatLogic"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/ReactiveX/RxSwift.git", from: "6.9.1"),
        .package(url: "https://github.com/realm/realm-swift.git", from: "10.54.6")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "StatLogic",
            dependencies: [
                .product(name: "RealmSwift", package: "realm-swift"),
                "RxSwift"
            ]
        )
    ]
)
