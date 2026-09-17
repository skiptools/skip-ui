// Copyright 2026 Skip
// SPDX-License-Identifier: MPL-2.0
import Foundation
import SwiftUI
import XCTest

#if SKIP
import androidx.compose.runtime.Composable
import androidx.compose.ui.test.junit4.createComposeRule
import androidx.compose.ui.test.onNodeWithText
import androidx.compose.ui.test.onAllNodesWithText
import androidx.compose.ui.test.assertIsDisplayed
import androidx.compose.ui.test.assertCountEquals
#endif

/// Toolbar content travels to the navigation bar as a preference, and `ToolbarContentPreferences`
/// compares that content by comparing the views themselves (Toolbar.swift). Weakening that
/// comparison is a tempting way to quiet the idle recomposition reported in
/// https://github.com/skiptools/skip-ui/issues/462, because a caller that rebuilds its content on
/// every composition never compares equal and so writes the preference every time.
///
/// This test says what that costs. Measured: with `==` returning true for any two non-nil contents,
/// it fails with "contains 'item-beta' … is not displayed", because Compose then does not store the
/// new content and the bar keeps rendering the views it collected first.
///
/// Robolectric-only: needs `createComposeRule()`, which is not available on the host Swift side.
final class ToolbarTests: SkipUITestCase {
    // SKIP INSERT: @get:org.junit.Rule val composeRule = createComposeRule()

    /// The label is built into a local constant before the toolbar modifier is applied, so the only
    /// way the change reaches the bar is through the preference.
    func testToolbarContentTracksStateChanges() throws {
        #if !SKIP
        throw XCTSkip("Compose UI testing is Android-only")
        #else
        let label = State(initialValue: "alpha")
        composeRule.setContent {
            ToolbarLabelProbe(label: label).Compose()
        }
        composeRule.waitForIdle()
        composeRule.onNodeWithText("item-alpha").assertIsDisplayed()

        label.wrappedValue = "beta"
        composeRule.waitForIdle()
        composeRule.onNodeWithText("item-beta").assertIsDisplayed()
        composeRule.onAllNodesWithText("item-alpha").assertCountEquals(0)
        #endif
    }
}

#if SKIP
/// `ComposeView`'s content runs when its host composes, which is the shape a bridged view tree
/// produces: `.toolbar` receives a newly built item each time rather than the same instance a
/// transpiled `body` would hand it.
private struct ToolbarLabelProbe: View {
    let label: State<String>

    var body: some View {
        NavigationStack {
            ComposeView { context in
                let text = "item-" + label.wrappedValue
                Text("content")
                    .navigationTitle("probe")
                    .toolbar(id: "", bridgedContent: ToolbarItem(placement: .topBarTrailing) { Text(text) })
                    .Compose(context: context)
            }
        }
    }
}
#endif
