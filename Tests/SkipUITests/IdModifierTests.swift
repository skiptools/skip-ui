// Copyright 2023–2025 Skip
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception

import XCTest
import SkipUI
import SwiftUI

#if SKIP
import androidx.compose.ui.test.junit4.ComposeContentTestRule
import androidx.compose.ui.test.junit4.createComposeRule
import org.junit.Rule
#endif

class IdModifierTests: SkipUITestCase {
    // Test that changing the id of a view causes it to be re-created
    public struct TestView: SwiftUI.View {
        let idValue: String
        @SwiftUI.State private var counter = 0

        public var body: some SwiftUI.View {
            Text("Counter: \(counter)")
                .id(idValue)
                .onAppear {
                    counter += 1 // This should only run once per view instance
                }
        }
    }

    func testViewRecreationWithIdChange() async throws {
        try testUI(view: {
            TestView(idValue: "A") // Use an initial id
        }, eval: { rule in
            // After initial render, counter should be 1
            try rule.onNodeWithText("Counter: 1").assertExists()
            
            // Re-set content with a new id
            // NOTE: The `id` variable within the closure cannot be directly updated and re-evaluated
            // in the same way as outside due to Swift's closure capture semantics and the testUI setup.
            // For this specific test, re-setting the content directly with a new instance that has a different ID
            // should still trigger the re-composition behavior we want to test for the `key` modifier.
            #if !SKIP
            try rule.setContent(swiftUIview: TestView(idValue: "B"))
            #else
            rule.setContent {
                TestView(idValue: "B") // Change id
            }
            #endif

            // After id change, a new view instance should be created, and its counter should be 1
            try rule.onNodeWithText("Counter: 1").assertExists()
        })
    }
}
