// Copyright 2026 Skip
// SPDX-License-Identifier: MPL-2.0
import SwiftUI
import XCTest

#if SKIP
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.saveable.Saver
import androidx.compose.runtime.saveable.rememberSaveable
import androidx.compose.runtime.setValue
import androidx.compose.ui.test.assertIsFocused
import androidx.compose.ui.test.junit4.createComposeRule
import androidx.compose.ui.test.onNodeWithTag
import androidx.compose.ui.test.performClick
#endif

final class FocusTests: SkipUITestCase {
    // SKIP INSERT: @get:org.junit.Rule val composeRule = createComposeRule()

    /// A field whose FocusState is set as it appears takes focus.
    func testFieldFocusedOnAppearTakesFocus() throws {
        #if !SKIP
        throw XCTSkip("Android-only")
        #else
        composeRule.setContent {
            FocusOnAppearTestView().Compose()
        }
        composeRule.waitForIdle()
        composeRule.onNodeWithTag("field").assertIsFocused()
        #endif
    }

    /// Focus moved to a field composed before the focused one stays on the new field.
    func testFocusMovesToEarlierField() throws {
        #if !SKIP
        throw XCTSkip("Android-only")
        #else
        composeRule.setContent {
            FocusTransferTestView().Compose()
        }
        composeRule.waitForIdle()
        composeRule.onNodeWithTag("focus-second").performClick()
        composeRule.waitForIdle()
        composeRule.onNodeWithTag("second").assertIsFocused()
        composeRule.onNodeWithTag("focus-first").performClick()
        composeRule.waitForIdle()
        composeRule.onNodeWithTag("first").assertIsFocused()
        #endif
    }
}

struct FocusOnAppearTestView: View {
    @State var text = ""
    @FocusState var isFocused: Bool

    var body: some View {
        TextField("Name", text: $text)
            .focused($isFocused)
            .accessibilityIdentifier("field")
            .onAppear { isFocused = true }
    }
}

struct FocusTransferTestView: View {
    enum Field {
        case first
        case second
    }

    @State var first = ""
    @State var second = ""
    @FocusState var focus: Field?

    var body: some View {
        VStack {
            TextField("First", text: $first)
                .focused($focus, equals: .first)
                .accessibilityIdentifier("first")
            TextField("Second", text: $second)
                .focused($focus, equals: .second)
                .accessibilityIdentifier("second")
            Button("Focus first") { focus = .first }
                .accessibilityIdentifier("focus-first")
            Button("Focus second") { focus = .second }
                .accessibilityIdentifier("focus-second")
        }
    }
}
