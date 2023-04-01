// swift-tools-version:5.5.0
import PackageDescription

import class Foundation.ProcessInfo

let packageName = "ZveronLibrary"
let productName = "ZveronLibrary"
let testProductName = "ZveronLibraryTest"

let networkTargetName = "ZveronNetwork"
let supportTargetName = "ZveronSupport"
let testTargetName = "ZveronTest"

let deprecatedTargetName = "ZveronRemoteDataService"


let packageDependencies: [Package.Dependency] = [
    .package(
        url: "https://github.com/SnapKit/SnapKit.git",
        from: "5.0.0"
      ),
    .package(
        url: "https://github.com/joomcode/BottomSheet.git",
        from: "2.0.0"
      ),
    .package(
        url: "https://github.com/Alamofire/Alamofire.git",
        from: "5.5.0"
      ),
    .package(
        url: "https://github.com/RedMadRobot/input-mask-ios.git",
        from: "6.0.0"
      ),
    .package(
        url: "https://github.com/onevcat/Kingfisher.git",
        from: "7.0.0"
      ),
    .package(
        url: "https://github.com/openid/AppAuth-iOS.git",
        from: "1.6.0"
      ),
    .package(
       // url: "https://github.com/ZveronHSE/contract.git",
       // from: "1.9.0"
        url: "https://github.com/Galaximum/contract.git",
        from: "1.4.0"
      ),
    .package(
        url: "https://github.com/ReactiveX/RxSwift.git",
        from: "6.5.0"
    ),
    .package(
        url: "https://github.com/RxSwiftCommunity/RxDataSources.git",
        from: "5.0.0"
    ),
    .package(
        url: "https://github.com/Swinject/Swinject.git",
        from: "2.8.0"
    ),
    .package(
        url: "https://github.com/evgenyneu/Cosmos.git",
        from: "23.0.0"
    ),
    .package(
        url: "https://github.com/pointfreeco/swift-snapshot-testing.git",
        from: "1.11.0"
    ),
    .package(
        url: "https://github.com/Galaximum/RangeSeekSlider.git",
        from: "1.0.0"
    ),
    .package(
        url: "https://github.com/Galaximum/DropDown.git",
        from: "1.0.0"
    )
]

extension Target.Dependency {
    // External dependencies
    // Product
    static let snapKit: Self = .product(name: "SnapKit", package: "SnapKit")
    static let bottomSheet: Self = .product(name: "BottomSheet", package: "BottomSheet")
    static let alamofire: Self = .product(name: "Alamofire", package: "Alamofire")
    static let inputMaskIos: Self = .product(name: "InputMask", package: "input-mask-ios")
    static let kingfisher: Self = .product(name: "Kingfisher", package: "Kingfisher")
    static let appAuth: Self = .product(name: "AppAuth", package: "AppAuth-iOS")
    static let swiftInject: Self = .product(name: "Swinject", package: "Swinject")
    static let starRating: Self = .product(name: "Cosmos", package: "Cosmos")
    static let rangeSeekSlider: Self = .product(name: "RangeSeekSlider", package: "RangeSeekSlider")
    static let dropDown: Self = .product(name: "DropDown", package: "DropDown")
    // reactive
    static let rxSwift: Self = .product(name: "RxSwift", package: "RxSwift")
    static let rxCocoa: Self = .product(name: "RxCocoa", package: "RxSwift")
    static let rxDataSources: Self = .product(name: "RxDataSources", package: "RxDataSources")
    // testing framework
    static let snapShot: Self = .product(name: "SnapshotTesting", package: "swift-snapshot-testing")
    static let rxBlocking: Self = .product(name: "RxBlocking", package: "RxSwift")

    // Internal dependencies
    // Product
    static let zveronContract: Self = .product(name: "ZveronGRPC", package: "contract")
    // Target
    static let support: Self = .target(name: supportTargetName)
}

extension Target {
    static let networkTarget: Target = .target(
        name: networkTargetName,
        dependencies: [
            // internal dependencies
            .support,
            // external dependencies
            .rxSwift,
            .rxCocoa,
            .rxDataSources,
            .zveronContract
        ]
    )

    static let supportTarget: Target = .target(
        name: supportTargetName,
        dependencies: [
            // external dependencies
            .starRating,
            .rangeSeekSlider,
            .dropDown,
            .snapKit,
            .bottomSheet,
            .inputMaskIos,
            .kingfisher,
            .appAuth,
            .swiftInject
        ]
    )

    static let testTarget: Target = .target(
        name: testTargetName,
        dependencies: [
            // external dependencies
            .rxBlocking,
            .snapShot
        ]
    )
    
    // TODO: remove this after delete ZveronRemoteDataService directory
    static let deprecatedTarget: Target = .target(
        name: deprecatedTargetName,
        dependencies: [.alamofire]
    )
}

extension Product {
    static let zveron: Product = .library(
        name: productName,
        targets: [
            networkTargetName,
            supportTargetName,
            deprecatedTargetName
        ]
    )

    static let testZveron: Product = .library(
        name: testProductName,
        targets: [
            networkTargetName,
            supportTargetName,
            deprecatedTargetName,
            testTargetName
        ]
    )
}

let package = Package(
    name: packageName,
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .zveron,
        .testZveron
    ],
    dependencies: packageDependencies,
    targets: [
        .networkTarget,
        .supportTarget,
        .testTarget,
        .deprecatedTarget
    ]
)
