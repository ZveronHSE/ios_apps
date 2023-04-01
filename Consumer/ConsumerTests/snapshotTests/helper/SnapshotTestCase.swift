//
//  SnapshotTestCase.swift
//  iosappTests
//
//  Created by alexander on 16.03.2023.
//

import Foundation

import XCTest

open class SnapshotTestCase: XCTestCase {
    private static let requiredDevice = "iPhone13,2"

    private static let requiredOSVersion = 13

    override open class func setUp() {
        super.setUp()

        checkEnvironments()

        UIView.setAnimationsEnabled(false)
    }

    private static func checkEnvironments() {
//        let deviceModel = ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"]
//        let osVersion = ProcessInfo().operatingSystemVersion
//
//        guard deviceModel?.contains(requiredDevice) ?? false else {
//            fatalError("Switch to using iPhone 12 for these tests.")
//        }
//
//        guard osVersion.majorVersion == requiredOSVersion else {
//            fatalError("Switch to iOS \(requiredOSVersion) for these tests.")
//        }
    }
}
