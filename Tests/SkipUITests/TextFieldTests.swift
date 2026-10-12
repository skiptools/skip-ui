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
import androidx.compose.ui.semantics.SemanticsProperties
import androidx.compose.ui.test.SemanticsMatcher
import androidx.compose.ui.test.assert
import androidx.compose.ui.test.assertIsFocused
import androidx.compose.ui.test.assertTextEquals
import androidx.compose.ui.test.junit4.createComposeRule
import androidx.compose.ui.test.onNodeWithTag
import androidx.compose.ui.test.performClick
import androidx.compose.ui.test.performImeAction
import androidx.compose.ui.test.performTextReplacement
import androidx.compose.ui.text.AnnotatedString
#endif

final class TextFieldTests: SkipUITestCase {
    // SKIP INSERT: @get:org.junit.Rule val composeRule = createComposeRule()

    #if SKIP
    private func assertFieldText(_ text: String) {
        let _ = composeRule.onNodeWithTag("field").assert(SemanticsMatcher.expectValue(SemanticsProperties.EditableText, AnnotatedString(text)))
    }
    #endif

    /// A String binding whose setter filters what is typed shows the filtered text.
    func testFilteringBindingShowsFilteredText() throws {
        #if !SKIP
        throw XCTSkip("Android-only")
        #else
        composeRule.setContent {
            FilteringTextFieldTestView().Compose()
        }
        composeRule.waitForIdle()
        composeRule.onNodeWithTag("field").performTextReplacement("abcdefg")
        composeRule.waitForIdle()
        composeRule.onNodeWithTag("value").assertTextEquals("abcde")
        assertFieldText("abcde")
        #endif
    }

    /// While a field that formats a value has focus, it keeps text that leaves the value unchanged
    /// and writes text that parses.
    func testFormattedValueKeepsTypedTextWhileFocused() throws {
        #if !SKIP
        throw XCTSkip("Android-only")
        #else
        composeRule.setContent {
            FormattedTextFieldTestView().Compose()
        }
        composeRule.waitForIdle()
        assertFieldText("7")

        composeRule.onNodeWithTag("field").performClick()
        composeRule.onNodeWithTag("field").performTextReplacement("")
        composeRule.waitForIdle()
        composeRule.onNodeWithTag("value").assertTextEquals("value: 7")
        assertFieldText("")

        composeRule.onNodeWithTag("field").performTextReplacement("7.")
        composeRule.waitForIdle()
        composeRule.onNodeWithTag("field").assertIsFocused()
        composeRule.onNodeWithTag("value").assertTextEquals("value: 7")
        assertFieldText("7.")

        composeRule.onNodeWithTag("field").performTextReplacement("12")
        composeRule.waitForIdle()
        composeRule.onNodeWithTag("value").assertTextEquals("value: 12")
        assertFieldText("12")
        #endif
    }

    /// Clearing a field that formats a value and moving focus away shows the value again.
    func testFormattedValueRestoresValueWhenFocusLeaves() throws {
        #if !SKIP
        throw XCTSkip("Android-only")
        #else
        composeRule.setContent {
            FormattedTextFieldTestView().Compose()
        }
        composeRule.waitForIdle()
        composeRule.onNodeWithTag("field").performClick()
        composeRule.onNodeWithTag("field").performTextReplacement("")
        composeRule.waitForIdle()
        assertFieldText("")

        composeRule.onNodeWithTag("other").performClick()
        composeRule.waitForIdle()
        composeRule.onNodeWithTag("other").assertIsFocused()
        composeRule.onNodeWithTag("value").assertTextEquals("value: 7")
        assertFieldText("7")
        #endif
    }

    /// Submitting a field that formats a value shows the value as formatted.
    func testFormattedValueShowsValueOnSubmit() throws {
        #if !SKIP
        throw XCTSkip("Android-only")
        #else
        composeRule.setContent {
            FormattedTextFieldTestView().Compose()
        }
        composeRule.waitForIdle()
        composeRule.onNodeWithTag("field").performClick()
        composeRule.onNodeWithTag("field").performTextReplacement("7.")
        composeRule.waitForIdle()
        assertFieldText("7.")

        composeRule.onNodeWithTag("field").performImeAction()
        composeRule.waitForIdle()
        assertFieldText("7")
        #endif
    }

    /// A value changed from outside a focused field that formats it replaces the typed text.
    func testFormattedValueFollowsExternalChangeWhileFocused() throws {
        #if !SKIP
        throw XCTSkip("Android-only")
        #else
        composeRule.setContent {
            FormattedTextFieldTestView().Compose()
        }
        composeRule.waitForIdle()
        composeRule.onNodeWithTag("field").performClick()
        composeRule.onNodeWithTag("field").performTextReplacement("7.")
        composeRule.waitForIdle()
        assertFieldText("7.")

        composeRule.onNodeWithTag("set").performClick()
        composeRule.waitForIdle()
        composeRule.onNodeWithTag("field").assertIsFocused()
        assertFieldText("42")
        #endif
    }

    /// A value whose format drops precision keeps the typed text while focused and reaches the
    /// binding unrounded; once focus leaves, the field shows the formatted value and the value
    /// takes it, as in SwiftUI.
    func testLossyFormatShowsFormattedValueWhenFocusLeaves() throws {
        #if !SKIP
        throw XCTSkip("Android-only")
        #else
        composeRule.setContent {
            LossyFormattedTextFieldTestView().Compose()
        }
        composeRule.waitForIdle()
        assertFieldText("1")

        composeRule.onNodeWithTag("field").performClick()
        composeRule.onNodeWithTag("field").performTextReplacement("1.2")
        composeRule.waitForIdle()
        composeRule.onNodeWithTag("value").assertTextEquals("tenths: 12")
        assertFieldText("1.2")

        composeRule.onNodeWithTag("other").performClick()
        composeRule.waitForIdle()
        composeRule.onNodeWithTag("value").assertTextEquals("tenths: 10")
        assertFieldText("1")
        #endif
    }
}

struct FilteringTextFieldTestView: View {
    @State var text = "abc"

    var body: some View {
        VStack {
            TextField("Code", text: Binding(get: { text }, set: { text = String($0.prefix(5)) }))
                .accessibilityIdentifier("field")
            Text(text)
                .accessibilityIdentifier("value")
        }
    }
}

#if SKIP
/// Builds its field the way a bridged `TextField(value:format:)` does: the binding renders an
/// Int, text that parses is written, and text that does not parse leaves the value alone.
struct FormattedTextFieldTestView: View {
    @State var value = 7
    @State var other = ""

    var body: some View {
        VStack {
            TextField(getText: { "\(value)" }, setText: { if let parsed = Int($0) { value = parsed } }, getSelection: { nil }, setSelection: { _ in }, prompt: nil, isSecure: false, formatsValue: true, bridgedAxis: Axis.horizontal.rawValue, bridgedLabel: Text("Dose"))
                .submitLabel(.done)
                .accessibilityIdentifier("field")
            TextField("Other", text: $other)
                .accessibilityIdentifier("other")
            Text("value: \(value)")
                .accessibilityIdentifier("value")
            Button("Set 42") {
                value = 42
            }
            .accessibilityIdentifier("set")
        }
    }
}

/// A bridged formatted field whose format shows no fraction digits, so 1.1 and 1.2 both read "1".
struct LossyFormattedTextFieldTestView: View {
    @State var value = 1.1
    @State var other = ""

    var body: some View {
        VStack {
            TextField(getText: { "\(Int(value + 0.5))" }, setText: { if let parsed = Double($0) { value = parsed } }, getSelection: { nil }, setSelection: { _ in }, prompt: nil, isSecure: false, formatsValue: true, bridgedAxis: Axis.horizontal.rawValue, bridgedLabel: Text("Amount"))
                .accessibilityIdentifier("field")
            TextField("Other", text: $other)
                .accessibilityIdentifier("other")
            Text("tenths: \(Int(value * 10 + 0.5))")
                .accessibilityIdentifier("value")
        }
    }
}
#endif
