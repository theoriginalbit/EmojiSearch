// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "EmojiSearch",
    platforms: [
        .iOS(.v10),
    ],
    products: [
        .library(name: "EmojiSearch", targets: ["EmojiSearch"]),
        .library(name: "EmojiLibDataSource", targets: ["EmojiLibDataSource"]),
        .library(name: "FuseSearchProvider", targets: ["FuseSearchProvider"]),
    ],
    dependencies: [
        .package(name: "Fuse", url: "https://github.com/krisk/fuse-swift.git", .upToNextMinor(from: "1.4.0")),
    ],
    targets: [
        .target(name: "EmojiSearch"),
        .testTarget(name: "EmojiSearchTests",
                    dependencies: ["EmojiSearch"]),
        
        .target(name: "EmojiLibDataSource",
                dependencies: [
                    .target(name: "EmojiSearch"),
                ],
                resources: [
                    .copy("emojis.json"),
                ]),
        .testTarget(name: "EmojiLibDataSourceTests",
                    dependencies: ["EmojiLibDataSource"]),
        
        .target(name: "FuseSearchProvider",
                dependencies: [
                    .target(name: "EmojiSearch"),
                    "Fuse",
                ]),
        .testTarget(name: "FuseSearchProviderTests",
                    dependencies: ["FuseSearchProvider"])
    ]
)
