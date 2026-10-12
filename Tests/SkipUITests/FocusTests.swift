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
