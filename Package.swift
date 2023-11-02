// swift-tools-version:5.9

import PackageDescription

let package = Package(
    name: "LUExpandableTableView",
    platforms: [.iOS(.v13)],
    products: [.library(name: "LUExpandableTableView", targets: ["LUExpandableTableView"])],
    targets: [.target(name: "LUExpandableTableView", path: "Sources")]
)
