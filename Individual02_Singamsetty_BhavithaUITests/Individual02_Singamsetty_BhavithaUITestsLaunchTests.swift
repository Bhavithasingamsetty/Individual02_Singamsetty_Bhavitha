//
//  Individual02_Singamsetty_BhavithaUITestsLaunchTests.swift
//  Individual02_Singamsetty_BhavithaUITests
//
//  Created by Singamsetty, Bhavitha on 3/22/24.
//

import XCTest

final class Individual02_Singamsetty_BhavithaUITestsLaunchTests: XCTestCase {

    override class var runsForEachTargetApplicationUIConfiguration: Bool {
        true
    }

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

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
