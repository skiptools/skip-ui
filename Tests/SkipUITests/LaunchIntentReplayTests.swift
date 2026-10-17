// Copyright 2026 Skip
// SPDX-License-Identifier: MPL-2.0
import Foundation
import SwiftUI
import XCTest

#if SKIP
import androidx.activity.ComponentActivity
import androidx.compose.ui.test.junit4.createAndroidComposeRule
#endif

final class LaunchIntentReplayTests: SkipUITestCase {
    // SKIP INSERT: @get:org.junit.Rule val composeRule = createAndroidComposeRule<ComponentActivity>()

    func testRecreatedActivityGetsItsLaunchIntentAsAReplay() throws {
        #if !SKIP
        throw XCTSkip("Launch intents are Android's")
        #else
        // UIApplication registers a lifecycle observer when it is created, which Android allows
        // only on the main thread; instrumented tests run on their own thread. recreate() blocks
        // until the new activity is resumed, so it stays off the main thread.
        let first = composeRule.activity
        composeRule.runOnUiThread {
            UIApplication.launch(first)
            XCTAssertNil(UIApplication.shared.replayedLaunchIntent)
        }

        composeRule.activityRule.scenario.recreate()
        let recreated = composeRule.activity
        XCTAssertFalse(recreated === first)
        composeRule.runOnUiThread {
            UIApplication.launch(recreated)
            XCTAssertNotNil(UIApplication.shared.replayedLaunchIntent)
            XCTAssertTrue(UIApplication.shared.replayedLaunchIntent === recreated.intent)
        }
        #endif
    }
}
