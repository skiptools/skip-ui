// Copyright 2026 Skip
// SPDX-License-Identifier: MPL-2.0
import SwiftUI
import XCTest

#if SKIP
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.saveable.Saver
import androidx.compose.runtime.saveable.rememberSaveable
import androidx.compose.ui.test.assertTextEquals
import androidx.compose.ui.test.junit4.createComposeRule
import androidx.compose.ui.test.onNodeWithTag
import androidx.compose.ui.test.performClick
#endif

/// Verifies the `isPresented` environment value on Android.
final class IsPresentedEnvironmentTests: SkipUITestCase {
    // SKIP INSERT: @get:org.junit.Rule val composeRule = createComposeRule()

    func testIsPresentedIsFalseOutsidePresentation() throws {
        #if !SKIP
        throw XCTSkip("Android-only")
        #else
        composeRule.setContent {
            PresentedReader(tag: "root").Compose()
        }
        composeRule.onNodeWithTag("root").assertTextEquals("presented: false")
        #endif
    }

    func testIsPresentedInSheet() throws {
        #if !SKIP
        throw XCTSkip("Android-only")
        #else
        composeRule.setContent {
            SheetHost().Compose()
        }
        composeRule.onNodeWithTag("presenter").assertTextEquals("presented: false")

        composeRule.onNodeWithTag("show").performClick()
        composeRule.waitForIdle()
        composeRule.onNodeWithTag("sheet").assertTextEquals("presented: true")
        // Presenting content is unaffected by the sheet's environment
        composeRule.onNodeWithTag("presenter").assertTextEquals("presented: false")
        #endif
    }

    func testIsPresentedInPushedDestination() throws {
        #if !SKIP
        throw XCTSkip("Android-only")
        #else
        composeRule.setContent {
            NavigationHost().Compose()
        }
        composeRule.onNodeWithTag("stack.root").assertTextEquals("presented: false")

        composeRule.onNodeWithTag("push").performClick()
        composeRule.waitForIdle()
        composeRule.onNodeWithTag("destination").assertTextEquals("presented: true")
        #endif
    }
}

struct PresentedReader: View {
    let tag: String
    @Environment(\.isPresented) var isPresented

    var body: some View {
        Text("presented: \(isPresented)")
            .accessibilityIdentifier(tag)
    }
}

struct SheetHost: View {
    @State var isShowingSheet = false

    var body: some View {
        VStack {
            PresentedReader(tag: "presenter")
            Button("Show") { isShowingSheet = true }
                .accessibilityIdentifier("show")
        }
        .sheet(isPresented: $isShowingSheet) {
            PresentedReader(tag: "sheet")
        }
    }
}

struct NavigationHost: View {
    var body: some View {
        NavigationStack {
            VStack {
                PresentedReader(tag: "stack.root")
                NavigationLink("Push") {
                    PresentedReader(tag: "destination")
                }
                .accessibilityIdentifier("push")
            }
        }
    }
}
