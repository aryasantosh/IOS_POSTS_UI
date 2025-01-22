//
//  Assignment_Collapsible_TV_CVUITestsLaunchTests.swift
//  Assignment_Collapsible_TV&CVUITests
//
//  Created by Arya Kulkarni on 21/01/25.
//

import XCTest

final class Assignment_Collapsible_TV_CVUITestsLaunchTests: XCTestCase {

    override class var runsForEachTargetApplicationUIConfiguration: Bool {
        true
    }

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    @MainActor
    func testLaunch() throws {
        let app = XCUIApplication()
        app.launch()

        // Insert steps here to perform after app launch but before taking a screenshot,
        // such as logging into a test account or navigating somewhere in the app

        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = "Launch Screen"
        attachment.lifetime = .keepAlways
        add(attachment)
    }
}
