// swift-tools-version: 6.4

import PackageDescription

let package = Package(
    name: "swift-ascii-parser",
    platforms: [
        .macOS(.v27),
        .iOS(.v27),
        .tvOS(.v27),
        .watchOS(.v27),
        .visionOS(.v27),
    ],
    products: [
        .library(
            name: "Parseable ASCII",
            targets: ["Parseable ASCII"]
        ),
        .library(
            name: "ASCII Decimal Parser",
            targets: ["ASCII Decimal Parser"]
        ),
        .library(
            name: "ASCII Decimal Machine",
            targets: ["ASCII Decimal Machine"]
        ),
        .library(
            name: "ASCII Hexadecimal Parser",
            targets: ["ASCII Hexadecimal Parser"]
        ),
        .library(
            name: "ASCII Binary Parser",
            targets: ["ASCII Binary Parser"]
        ),
        .library(
            name: "ASCII Octal Parser",
            targets: ["ASCII Octal Parser"]
        ),
        .library(
            name: "ASCII Parser Standard Library Integration",
            targets: ["ASCII Parser Standard Library Integration"]
        ),
        .library(
            name: "ASCII Parser",
            targets: ["ASCII Parser"]
        ),
        .library(
            name: "ASCII Parser Test Support",
            targets: ["ASCII Parser Test Support"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/swift-atoms/swift-either.git", branch: "main"),
        .package(
            url: "https://github.com/swift-molecules/swift-cursor-parser.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-atoms/swift-ascii.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-molecules/swift-binary-parser.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-molecules/swift-buffer-linear.git",
            branch: "main"
        ),
        .package(url: "https://github.com/swift-molecules/swift-iterator-parser.git", branch: "main"),
        .package(
            url: "https://github.com/swift-atoms/swift-parser.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-molecules/swift-ownership-shared.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-atoms/swift-byte.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-atoms/swift-cursor.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-atoms/swift-checkpoint.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-atoms/swift-iterator.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-atoms/swift-pair.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-molecules/swift-pair-parser.git",
            branch: "main"
        ),
    ],
    targets: [

        .target(
            name: "Parseable ASCII",
            dependencies: [
                .product(name: "ASCII", package: "swift-ascii")
            ]
        ),

        .target(
            name: "ASCII Decimal Parser",
            dependencies: [
                .product(name: "ASCII", package: "swift-ascii"),
                .product(name: "Parser", package: "swift-parser"),
                .product(name: "Byte", package: "swift-byte"),
                .product(name: "Cursor", package: "swift-cursor"),
                .product(name: "Checkpoint", package: "swift-checkpoint"),
                .product(name: "Iterator", package: "swift-iterator"),
                .product(name: "Iterator Protocol", package: "swift-iterator"),
            ]
        ),
        .target(
            name: "ASCII Decimal Machine",
            dependencies: [
                "ASCII Decimal Parser",
                .product(name: "ASCII", package: "swift-ascii"),
                .product(name: "Parser", package: "swift-parser"),
                .product(
                    name: "Binary Machine",
                    package: "swift-binary-parser"
                ),
            ]
        ),
        .target(
            name: "ASCII Hexadecimal Parser",
            dependencies: [
                .product(name: "ASCII", package: "swift-ascii"),
                .product(name: "Parser", package: "swift-parser"),
                .product(name: "Byte", package: "swift-byte"),
                .product(name: "Cursor", package: "swift-cursor"),
                .product(name: "Checkpoint", package: "swift-checkpoint"),
                .product(name: "Iterator", package: "swift-iterator"),
                .product(name: "Iterator Protocol", package: "swift-iterator"),
            ]
        ),
        .target(
            name: "ASCII Binary Parser",
            dependencies: [
                .product(name: "ASCII", package: "swift-ascii"),
                .product(name: "Parser", package: "swift-parser"),
                .product(name: "Byte", package: "swift-byte"),
                .product(name: "Cursor", package: "swift-cursor"),
                .product(name: "Checkpoint", package: "swift-checkpoint"),
                .product(name: "Iterator", package: "swift-iterator"),
                .product(name: "Iterator Protocol", package: "swift-iterator"),
            ]
        ),
        .target(
            name: "ASCII Octal Parser",
            dependencies: [
                .product(name: "ASCII", package: "swift-ascii"),
                .product(name: "Parser", package: "swift-parser"),
                .product(name: "Byte", package: "swift-byte"),
                .product(name: "Cursor", package: "swift-cursor"),
                .product(name: "Checkpoint", package: "swift-checkpoint"),
                .product(name: "Iterator", package: "swift-iterator"),
                .product(name: "Iterator Protocol", package: "swift-iterator"),
            ]
        ),

        .target(
            name: "ASCII Parser Standard Library Integration",
            dependencies: [
                "ASCII Decimal Parser",
                "Parseable ASCII",
                .product(
                    name: "Buffer Linear Primitive",
                    package: "swift-buffer-linear"
                ),
                .product(
                    name: "Buffer Linear",
                    package: "swift-buffer-linear"
                ),
                .product(name: "Byte Standard Library Integration", package: "swift-byte"),
                .product(name: "Cursor Standard Library Integration", package: "swift-cursor"),
                .product(name: "Either", package: "swift-either"),
                .product(
                    name: "Ownership Shared Primitive",
                    package: "swift-ownership-shared"
                ),
            ]
        ),

        .target(
            name: "ASCII Parser",
            dependencies: [
                "Parseable ASCII",
                "ASCII Decimal Parser",
                "ASCII Hexadecimal Parser",
                "ASCII Binary Parser",
                "ASCII Octal Parser",
                "ASCII Parser Standard Library Integration",
            ]
        ),

        .testTarget(
            name: "ASCII Decimal Parser Tests",
            dependencies: [
                "ASCII Decimal Parser",
                "ASCII Parser Test Support",
                .product(name: "Byte", package: "swift-byte"),
                .product(name: "Byte Standard Library Integration", package: "swift-byte"),
                .product(name: "Cursor Standard Library Integration", package: "swift-cursor"),
                .product(name: "Either", package: "swift-either"),
            ]
        ),
        .testTarget(
            name: "ASCII Decimal Machine Tests",
            dependencies: [
                "ASCII Decimal Machine",
                "ASCII Parser Test Support",
            ]
        ),
        .testTarget(
            name: "ASCII Hexadecimal Parser Tests",
            dependencies: [
                "ASCII Hexadecimal Parser",
                "ASCII Parser Test Support",
                .product(name: "Byte", package: "swift-byte"),
                .product(name: "Byte Standard Library Integration", package: "swift-byte"),
                .product(name: "Cursor Standard Library Integration", package: "swift-cursor"),
                .product(name: "Either", package: "swift-either"),
            ]
        ),
        .testTarget(
            name: "ASCII Binary Parser Tests",
            dependencies: [
                "ASCII Binary Parser",
                "ASCII Parser Test Support",
                .product(name: "Byte", package: "swift-byte"),
                .product(name: "Byte Standard Library Integration", package: "swift-byte"),
                .product(name: "Cursor Standard Library Integration", package: "swift-cursor"),
                .product(name: "Either", package: "swift-either"),
            ]
        ),
        .testTarget(
            name: "ASCII Octal Parser Tests",
            dependencies: [
                "ASCII Octal Parser",
                "ASCII Parser Test Support",
                .product(name: "Byte", package: "swift-byte"),
                .product(name: "Byte Standard Library Integration", package: "swift-byte"),
                .product(name: "Cursor Standard Library Integration", package: "swift-cursor"),
                .product(name: "Either", package: "swift-either"),
            ]
        ),
        .testTarget(
            name: "ASCII Parser Standard Library Integration Tests",
            dependencies: [
                "ASCII Parser Standard Library Integration",
                .product(name: "Cursor Parser Test Support", package: "swift-cursor-parser"),
            ]
        ),
        .testTarget(
            name: "Declarative Parser Syntax Tests",
            dependencies: [
                "ASCII Decimal Parser",
                .product(name: "Byte", package: "swift-byte"),
                .product(name: "Byte Standard Library Integration", package: "swift-byte"),
                .product(name: "Byte Standard Library Integration", package: "swift-byte"),
                .product(name: "Cursor Standard Library Integration", package: "swift-cursor"),
                .product(name: "Either", package: "swift-either"),
                .product(name: "Iterator Parser", package: "swift-iterator-parser"),
                .product(name: "Cursor", package: "swift-cursor"),
                .product(name: "Parser Error", package: "swift-parser"),
                .product(name: "Parser Map", package: "swift-parser"),
                .product(name: "Parser Sequence", package: "swift-parser"),
                .product(name: "Parser Skip", package: "swift-parser"),
            ],
        ),

        .target(
            name: "ASCII Parser Test Support",
            dependencies: [
                "ASCII Parser",
                .product(name: "Byte", package: "swift-byte"),
                .product(name: "Byte Standard Library Integration", package: "swift-byte"),
                .product(name: "Cursor Standard Library Integration", package: "swift-cursor"),
                .product(name: "Either", package: "swift-either"),
            ],
            path: "Tests/Support"
        ),
    ],
    swiftLanguageModes: [.v6]
)

for target in package.targets where ![.system, .binary, .plugin, .macro].contains(target.type) {
    let ecosystem: [SwiftSetting] = [
        .strictMemorySafety(),
        .enableUpcomingFeature("ExistentialAny"),
        .enableUpcomingFeature("InternalImportsByDefault"),
        .enableUpcomingFeature("MemberImportVisibility"),
        .enableUpcomingFeature("NonisolatedNonsendingByDefault"),
        .enableExperimentalFeature("Lifetimes"),
        .enableUpcomingFeature("InferIsolatedConformances"),
    ]

    let package: [SwiftSetting] = []

    target.swiftSettings = (target.swiftSettings ?? []) + ecosystem + package
}
