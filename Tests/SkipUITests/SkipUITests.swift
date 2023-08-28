// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

import SwiftUI
import XCTest
import Foundation

// SKIP INSERT: import android.os.Build
// SKIP INSERT: import android.graphics.Bitmap
// SKIP INSERT: import android.graphics.Canvas

// SKIP INSERT: import androidx.compose.foundation.ExperimentalFoundationApi
// SKIP INSERT: import androidx.compose.foundation.background
// SKIP INSERT: import androidx.compose.foundation.border
// SKIP INSERT: import androidx.compose.foundation.interaction.FocusInteraction
// SKIP INSERT: import androidx.compose.foundation.interaction.Interaction
// SKIP INSERT: import androidx.compose.foundation.interaction.MutableInteractionSource
// SKIP INSERT: import androidx.compose.foundation.layout.Box
// SKIP INSERT: import androidx.compose.foundation.layout.Column
// SKIP INSERT: import androidx.compose.foundation.layout.IntrinsicSize
// SKIP INSERT: import androidx.compose.foundation.layout.Row
// SKIP INSERT: import androidx.compose.foundation.layout.Spacer
// SKIP INSERT: import androidx.compose.foundation.layout.fillMaxHeight
// SKIP INSERT: import androidx.compose.foundation.layout.fillMaxSize
// SKIP INSERT: import androidx.compose.foundation.layout.fillMaxWidth
// SKIP INSERT: import androidx.compose.foundation.layout.height
// SKIP INSERT: import androidx.compose.foundation.layout.padding
// SKIP INSERT: import androidx.compose.foundation.layout.requiredHeight
// SKIP INSERT: import androidx.compose.foundation.layout.size
// SKIP INSERT: import androidx.compose.foundation.layout.width
// SKIP INSERT: import androidx.compose.foundation.layout.wrapContentSize

// SKIP INSERT: import androidx.compose.material3.Text
// SKIP INSERT: import androidx.compose.material3.Button

// SKIP INSERT: import androidx.compose.runtime.Composable
// SKIP INSERT: import androidx.compose.runtime.CompositionLocalProvider
// SKIP INSERT: import androidx.compose.runtime.MutableState
// SKIP INSERT: import androidx.compose.runtime.getValue
// SKIP INSERT: import androidx.compose.runtime.mutableStateOf
// SKIP INSERT: import androidx.compose.runtime.remember
// SKIP INSERT: import androidx.compose.runtime.rememberCoroutineScope
// SKIP INSERT: import androidx.compose.runtime.saveable.rememberSaveable
// SKIP INSERT: import androidx.compose.runtime.setValue

// SKIP INSERT: import androidx.compose.ui.Modifier
// SKIP INSERT: import androidx.compose.ui.draw.drawBehind
// SKIP INSERT: import androidx.compose.ui.focus.onFocusChanged
// SKIP INSERT: import androidx.compose.ui.geometry.Offset
// SKIP INSERT: import androidx.compose.ui.geometry.Rect
// SKIP INSERT: import androidx.compose.ui.graphics.ImageBitmap
// SKIP INSERT: import androidx.compose.ui.graphics.RectangleShape
// SKIP INSERT: import androidx.compose.ui.graphics.Shadow
// SKIP INSERT: import androidx.compose.ui.graphics.SolidColor
// SKIP INSERT: import androidx.compose.ui.graphics.toPixelMap
// SKIP INSERT: import androidx.compose.ui.graphics.drawscope.drawIntoCanvas

// SKIP INSERT: import androidx.compose.ui.input.key.KeyEvent
// SKIP INSERT: import androidx.compose.ui.input.key.NativeKeyEvent
// SKIP INSERT: import androidx.compose.ui.layout.onGloballyPositioned

// SKIP INSERT: import androidx.compose.ui.text.AnnotatedString
// SKIP INSERT: import androidx.compose.ui.text.ExperimentalTextApi
// SKIP INSERT: import androidx.compose.ui.text.ParagraphStyle
// SKIP INSERT: import androidx.compose.ui.text.SpanStyle
// SKIP INSERT: import androidx.compose.ui.text.TextLayoutResult
// SKIP INSERT: import androidx.compose.ui.text.TextRange
// SKIP INSERT: import androidx.compose.ui.text.TextStyle
// SKIP INSERT: import androidx.compose.ui.text.UrlAnnotation
// SKIP INSERT: import androidx.compose.ui.text.VerbatimTtsAnnotation
// SKIP INSERT: import androidx.compose.ui.text.buildAnnotatedString
// SKIP INSERT: import androidx.compose.ui.text.font.Font
// SKIP INSERT: import androidx.compose.ui.text.font.FontStyle
// SKIP INSERT: import androidx.compose.ui.text.font.FontSynthesis
// SKIP INSERT: import androidx.compose.ui.text.font.FontWeight
// SKIP INSERT: import androidx.compose.ui.text.font.toFontFamily
// SKIP INSERT: import androidx.compose.ui.text.input.CommitTextCommand
// SKIP INSERT: import androidx.compose.ui.text.input.EditCommand
// SKIP INSERT: import androidx.compose.ui.text.input.ImeAction
// SKIP INSERT: import androidx.compose.ui.text.input.OffsetMapping
// SKIP INSERT: import androidx.compose.ui.text.input.PasswordVisualTransformation
// SKIP INSERT: import androidx.compose.ui.text.input.PlatformTextInputService
// SKIP INSERT: import androidx.compose.ui.text.input.TextFieldValue
// SKIP INSERT: import androidx.compose.ui.text.input.TextFieldValue.Companion.Saver
// SKIP INSERT: import androidx.compose.ui.text.input.TextInputService
// SKIP INSERT: import androidx.compose.ui.text.input.TransformedText
// SKIP INSERT: import androidx.compose.ui.text.intl.Locale
// SKIP INSERT: import androidx.compose.ui.text.intl.LocaleList
// SKIP INSERT: import androidx.compose.ui.text.style.BaselineShift
// SKIP INSERT: import androidx.compose.ui.text.style.TextAlign
// SKIP INSERT: import androidx.compose.ui.text.style.TextDecoration
// SKIP INSERT: import androidx.compose.ui.text.style.TextDirection
// SKIP INSERT: import androidx.compose.ui.text.style.TextGeometricTransform
// SKIP INSERT: import androidx.compose.ui.text.style.TextIndent
// SKIP INSERT: import androidx.compose.ui.text.toUpperCase
// SKIP INSERT: import androidx.compose.ui.text.withAnnotation
// SKIP INSERT: import androidx.compose.ui.text.withStyle

// SKIP INSERT: import androidx.compose.ui.unit.Density
// SKIP INSERT: import androidx.compose.ui.unit.IntSize
// SKIP INSERT: import androidx.compose.ui.unit.toSize
// SKIP INSERT: import androidx.compose.ui.unit.dp
// SKIP INSERT: import androidx.compose.ui.unit.em
// SKIP INSERT: import androidx.compose.ui.unit.sp

// SKIP INSERT: import androidx.compose.ui.platform.ComposeView
// SKIP INSERT: import androidx.compose.ui.platform.LocalDensity
// SKIP INSERT: import androidx.compose.ui.platform.LocalFocusManager
// SKIP INSERT: import androidx.compose.ui.platform.LocalFontFamilyResolver
// SKIP INSERT: import androidx.compose.ui.platform.LocalTextInputService
// SKIP INSERT: import androidx.compose.ui.platform.LocalTextToolbar
// SKIP INSERT: import androidx.compose.ui.platform.LocalView
// SKIP INSERT: import androidx.compose.ui.platform.TextToolbar
// SKIP INSERT: import androidx.compose.ui.platform.TextToolbarStatus
// SKIP INSERT: import androidx.compose.ui.platform.testTag
// SKIP INSERT: import androidx.compose.ui.semantics.SemanticsActions
// SKIP INSERT: import androidx.compose.ui.semantics.SemanticsNode
// SKIP INSERT: import androidx.compose.ui.semantics.SemanticsConfiguration
// SKIP INSERT: import androidx.compose.ui.semantics.SemanticsProperties
// SKIP INSERT: import androidx.compose.ui.semantics.getOrNull
// SKIP INSERT: import androidx.compose.ui.test.ExperimentalTestApi
// SKIP INSERT: import androidx.compose.ui.test.SemanticsMatcher
// SKIP INSERT: import androidx.compose.ui.test.SemanticsNodeInteraction
// SKIP INSERT: import androidx.compose.ui.test.assert
// SKIP INSERT: import androidx.compose.ui.test.assertHasClickAction
// SKIP INSERT: import androidx.compose.ui.test.assertIsFocused
// SKIP INSERT: import androidx.compose.ui.test.assertTextEquals
// SKIP INSERT: import androidx.compose.ui.test.captureToImage
// SKIP INSERT: import androidx.compose.ui.test.click
// SKIP INSERT: import androidx.compose.ui.test.hasText
// SKIP INSERT: import androidx.compose.ui.test.hasImeAction
// SKIP INSERT: import androidx.compose.ui.test.hasSetTextAction
// SKIP INSERT: import androidx.compose.ui.test.isFocused
// SKIP INSERT: import androidx.compose.ui.test.isNotFocused
// SKIP INSERT: import androidx.compose.ui.test.junit4.StateRestorationTester
// SKIP INSERT: import androidx.compose.ui.test.junit4.createComposeRule
// SKIP INSERT: import androidx.compose.ui.test.junit4.ComposeContentTestRule
// SKIP INSERT: import androidx.compose.ui.test.longClick
// SKIP INSERT: import androidx.compose.ui.test.assertIsDisplayed
// SKIP INSERT: import androidx.compose.ui.test.onNodeWithTag
// SKIP INSERT: import androidx.compose.ui.test.onNodeWithText
// SKIP INSERT: import androidx.compose.ui.test.performClick
// SKIP INSERT: import androidx.compose.ui.test.onRoot
// SKIP INSERT: import androidx.compose.ui.test.printToLog
// SKIP INSERT: import androidx.compose.ui.test.performImeAction
// SKIP INSERT: import androidx.compose.ui.test.performKeyPress
// SKIP INSERT: import androidx.compose.ui.test.performSemanticsAction
// SKIP INSERT: import androidx.compose.ui.test.performTextClearance
// SKIP INSERT: import androidx.compose.ui.test.performTextInput
// SKIP INSERT: import androidx.compose.ui.test.performTextInputSelection
// SKIP INSERT: import androidx.compose.ui.test.performTouchInput
// SKIP INSERT: import androidx.compose.ui.test.performGesture
// SKIP INSERT: import androidx.compose.ui.test.*

// SKIP INSERT: import androidx.compose.ui.graphics.asAndroidBitmap


// SKIP INSERT: import androidx.test.ext.junit.runners.AndroidJUnit4

// SKIP INSERT: import kotlin.test.assertFailsWith
// SKIP INSERT: import kotlinx.coroutines.CoroutineScope
// SKIP INSERT: import kotlinx.coroutines.launch

// SKIP INSERT: import org.junit.Ignore
// SKIP INSERT: import org.junit.Rule
// SKIP INSERT: import org.junit.Test

// SKIP INSERT: import kotlinx.coroutines.runBlocking

// needed to override M3.Text
// SKIP INSERT: import skip.ui.Text


// SKIP INSERT: @org.junit.runner.RunWith(androidx.test.ext.junit.runners.AndroidJUnit4::class)
// SKIP INSERT: @org.robolectric.annotation.Config(manifest=org.robolectric.annotation.Config.NONE, sdk = [33])
final class SkipUITests: XCTestCase {
    // SKIP INSERT: @get:Rule val composeRule = createComposeRule()

    func testSkipUI() throws {
        XCTAssertEqual(3, 1 + 2)
    }

    #if !SKIP
    typealias Evaluator = Never
    #else
    typealias Evaluator = ComposeContentTestRule
    #endif

    // SKIP DECLARE: internal fun testUI(view: () -> View, eval: (ComposeContentTestRule) -> Unit)
    func testUI<V: View>(@ViewBuilder view: () throws -> V, eval: (Evaluator) throws -> ()) throws {
        #if !SKIP
        let v = try view()
        throw XCTSkip("headless UI testing not available for SwiftUI")
        #else
        composeRule.setContent {
            view().Compose()
        }
        eval(composeRule)
        #endif
    }


    func testSkipUIButton() throws {
        try testUI(view: {
            // SKIP REPLACE: var counter by remember { mutableStateOf(1) }
            var counter = 1
            // SKIP NOWARN
            let binding = Binding(get: { counter }, set: { counter = $0 })

            VStack {
                Text("Counter: \(binding.wrappedValue.description)")
                    .accessibilityIdentifier("counter-label")
                    .accessibilityLabel(Text("Counter Label"))

                Button {
                    binding.wrappedValue += 1
                } label: {
                    Text("Increment")
                }
                .accessibilityIdentifier("increment-button")
            }
            .accessibilityIdentifier("vstack-container")
        }, eval: { rule in
            #if SKIP
            rule.onNodeWithTag("counter-label").assert(hasText("Counter: 1"))
            //rule.onNodeWithText("Increment").performClick()
            rule.onNodeWithTag("increment-button").performClick()
            rule.onNodeWithTag("counter-label").assert(hasText("Counter: 2"))

            //rule.onNodeWithTag("vstack-container").onNodeWithTag("increment-button").performClick()
            //rule.onNodeWithTag("counter-label").assert(hasText("Counter: 3"))
            //rule.onNodeWithContentDescription("Counter Label").assert(hasText("Counter: 3"))
            #endif
        })
    }

    func testSkipUISlider() throws {
        // TODO: https://github.com/tikurahul/androidx/blob/ccac66729a5e461b3a05944014f42e2dc55337d6/compose/material/material/src/androidAndroidTest/kotlin/androidx/compose/material/ButtonTest.kt#L48
        // https://github.com/tikurahul/androidx/blob/ccac66729a5e461b3a05944014f42e2dc55337d6/compose/material/material/src/androidAndroidTest/kotlin/androidx/compose/material/SliderTest.kt

        try testUI(view: {
            // SKIP REPLACE: var sliderValue by remember { mutableStateOf(0.0) }
            var sliderValue = 0.0
            let binding = Binding(get: { sliderValue }, set: { sliderValue = $0 })

            VStack {
                Text("\(binding.wrappedValue.description)")
                    .accessibilityIdentifier("label")
                Slider(value: binding, in: 0.0...1.0)
                    .accessibilityIdentifier("slider")
            }
        }, eval: { rule in
            #if SKIP
            // https://developer.android.com/jetpack/compose/testing-cheatsheet
            rule.onNodeWithTag("label").assertIsDisplayed()
            rule.onNodeWithTag("label").assert(hasText("0.0"))
            rule.onNodeWithTag("slider").performGesture {
                //swipeRight(Offset(Float(0.0), Float(0.0)), Offset(Float(1000.0), Float(0.0)))
                down(Offset(Float(0.0), Float(0.0)))
                moveTo(Offset(Float(1000.0), Float(0.0)))
                up()
            }
            rule.onNodeWithTag("label").assert(hasText("1.0"))
            #endif
        })
    }

    func testCompose() {
        #if SKIP
        composeRule.setContent {
            androidx.compose.material3.Text(text: "ABC")
        }

        //composeRule.onRoot().printToLog("TAG")
        composeRule.onNodeWithText("ABC").assertIsDisplayed()

        XCTAssertEqual(composeRule.onRoot().fetchSemanticsNode().treeString(), """
        Node:
          Node:Text=[ABC] GetTextLayoutResult=AccessibilityAction(label=null, action=(kotlin.collections.MutableList<androidx.compose.ui.text.TextLayoutResult>) -> kotlin.Boolean)
        """)
        #endif
    }

    /// Returns one of the strings based on the current platform.
    /// - Parameters:
    ///   - ios: the default iOS string
    ///   - macos: the macOS string
    ///   - android: the Android string
    /// - Returns: the string according to the platform
    func plaf(_ ios: String, macos: String? = nil, android: String? = nil) -> String {
        #if SKIP
        return android ?? ios
        #elseif canImport(UIKit)
        return ios
        #elseif canImport(AppKit)
        return macos ?? ios
        #else
        fatal("unsupported platform")
        #endif
    }

    func testColorClearDark() throws {
        XCTAssertEqual(plaf("0x000000"), try render(darkMode: true, view: Spacer().background(Color.clear).frame(width: 1.0, height: 1.0)))
    }

    func testColorClearLight() throws {
        XCTAssertEqual(plaf("0xFF0000", macos: "0x000000", android: "0x000000"), try render(view: Spacer().background(Color.clear).frame(width: 1.0, height: 1.0)))
    }

    func testColorBlackDark() throws {
        XCTAssertEqual(plaf("0x000000"), try render(darkMode: true, view: Spacer().background(Color.black).frame(width: 1.0, height: 1.0)))
    }

    func testColorBlackLight() throws {
        XCTAssertEqual(plaf("0x000000"), try render(view: Spacer().background(Color.black).frame(width: 1.0, height: 1.0)))
    }

    func testColorWhiteDark() throws {
        XCTAssertEqual(plaf("0xFFFFFF"), try render(darkMode: true, view: Spacer().background(Color.white).frame(width: 1.0, height: 1.0)))
    }

    func testColorWhiteLight() throws {
        XCTAssertEqual(plaf("0xFFFFFF"), try render(view: Spacer().background(Color.white).frame(width: 1.0, height: 1.0)))
    }

    func testColorGrayDark() throws {
        XCTAssertEqual(plaf("0x8E8E93", macos: "0x86868B", android: "0x888888"), try render(darkMode: true, view: Spacer().background(Color.gray).frame(width: 1.0, height: 1.0)))
    }

    func testColorGrayLight() throws {
        XCTAssertEqual(plaf("0x8E8E93", macos: "0x7B7B81", android: "0x888888"), try render(view: Spacer().background(Color.gray).frame(width: 1.0, height: 1.0)))
    }

    func testColorRedDark() throws {
        XCTAssertEqual(plaf("0xFF453A", macos: "0xFC2B2D", android: "0xFF0000"), try render(darkMode: true, view: Spacer().background(Color.red).frame(width: 1.0, height: 1.0)))
    }

    func testColorRedLight() throws {
        XCTAssertEqual(plaf("0xFF3B30", macos: "0xFC2125", android: "0xFF0000"), try render(view: Spacer().background(Color.red).frame(width: 1.0, height: 1.0)))
    }

    func testColorOrangeDark() throws {
        XCTAssertEqual(plaf("0xFF9F0A", macos: "0xFD8D0E"), try render(darkMode: true, view: Spacer().background(Color.orange).frame(width: 1.0, height: 1.0)))
    }

    func testColorOrangeLight() throws {
        XCTAssertEqual(plaf("0xFF9500", macos: "0xFD8208", android: "0xFF9F0A"), try render(view: Spacer().background(Color.orange).frame(width: 1.0, height: 1.0)))
    }

    func testColorYellowDark() throws {
        XCTAssertEqual(plaf("0xFFD60A", macos: "0xFECF0F", android: "0xFFFF00"), try render(darkMode: true, view: Spacer().background(Color.yellow).frame(width: 1.0, height: 1.0)))
    }

    func testColorYellowLight() throws {
        XCTAssertEqual(plaf("0xFFCC00", macos: "0xFEC309", android: "0xFFFF00"), try render(view: Spacer().background(Color.yellow).frame(width: 1.0, height: 1.0)))
    }

    func testColorGreenDark() throws {
        XCTAssertEqual(plaf("0x30D158", macos: "0x30D33B", android: "0x00FF00"), try render(darkMode: true, view: Spacer().background(Color.green).frame(width: 1.0, height: 1.0)))
    }

    func testColorGreenLight() throws {
        XCTAssertEqual(plaf("0x34C759", macos: "0x29C732", android: "0x00FF00"), try render(view: Spacer().background(Color.green).frame(width: 1.0, height: 1.0)))
    }

    func testColorMintDark() throws {
        XCTAssertEqual(plaf("0x63E6E2", macos: "0x56E2DB", android: "0x5AC8FA"), try render(darkMode: true, view: Spacer().background(Color.mint).frame(width: 1.0, height: 1.0)))
    }

    func testColorMintLight() throws {
        XCTAssertEqual(plaf("0x00C7BE", macos: "0x18BDB0", android: "0x5AC8FA"), try render(view: Spacer().background(Color.mint).frame(width: 1.0, height: 1.0)))
    }

    func testColortTealDark() throws {
        XCTAssertEqual(plaf("0x40C8E0", macos: "0x5AB8D4", android: "0x64D2FF"), try render(darkMode: true, view: Spacer().background(Color.teal).frame(width: 1.0, height: 1.0)))
    }

    func testColorTealLight() throws {
        XCTAssertEqual(plaf("0x30B0C7", macos: "0x4A9DB7", android: "0x64D2FF"), try render(view: Spacer().background(Color.teal).frame(width: 1.0, height: 1.0)))
    }

    func testColorCyanDark() throws {
        XCTAssertEqual(plaf("0x64D2FF", macos: "0x4CBCF2", android: "0x00FFFF"), try render(darkMode: true, view: Spacer().background(Color.cyan).frame(width: 1.0, height: 1.0)))
    }

    func testColorCyanLight() throws {
        XCTAssertEqual(plaf("0x32ADE6", macos: "0x47B0EC", android: "0x00FFFF"), try render(view: Spacer().background(Color.cyan).frame(width: 1.0, height: 1.0)))
    }

    func testColorBlueDark() throws {
        XCTAssertEqual(plaf("0x0A84FF", macos: "0x106BFF", android: "0x0000FF"), try render(darkMode: true, view: Spacer().background(Color.blue).frame(width: 1.0, height: 1.0)))
    }

    func testColorBlueLight() throws {
        XCTAssertEqual(plaf("0x007AFF", macos: "0x0A60FF", android: "0x0000FF"), try render(view: Spacer().background(Color.blue).frame(width: 1.0, height: 1.0)))
    }

    func testColorIndigoDark() throws {
        XCTAssertEqual(plaf("0x5E5CE6", macos: "0x4B40E0", android: "0x5856D6"), try render(darkMode: true, view: Spacer().background(Color.indigo).frame(width: 1.0, height: 1.0)))
    }

    func testColorIndigoLight() throws {
        XCTAssertEqual(plaf("0x5856D6", macos: "0x453CCC"), try render(view: Spacer().background(Color.indigo).frame(width: 1.0, height: 1.0)))
    }

    func testColorPurpleDark() throws {
        XCTAssertEqual(plaf("0xBF5AF2", macos: "0xAF39EE", android: "0xAF52DE"), try render(darkMode: true, view: Spacer().background(Color.purple).frame(width: 1.0, height: 1.0)))
    }

    func testColorPurpleLight() throws {
        XCTAssertEqual(plaf("0xAF52DE", macos: "0x9D33D6"), try render(view: Spacer().background(Color.purple).frame(width: 1.0, height: 1.0)))
    }

    func testColorPinkDark() throws {
        XCTAssertEqual(plaf("0xFF375F", macos: "0xFC1A4D", android: "0xFF2D55"), try render(darkMode: true, view: Spacer().background(Color.pink).frame(width: 1.0, height: 1.0)))
    }

    func testColorPinkLight() throws {
        XCTAssertEqual(plaf("0xFF2D55", macos: "0xFB0D44"), try render(view: Spacer().background(Color.pink).frame(width: 1.0, height: 1.0)))
    }

    func testColorBrownDark() throws {
        XCTAssertEqual(plaf("0xAC8E68", macos: "0x9B7C55", android: "0xA2845E"), try render(darkMode: true, view: Spacer().background(Color.brown).frame(width: 1.0, height: 1.0)))
    }

    func testColorBrownLight() throws {
        XCTAssertEqual(plaf("0xA2845E", macos: "0x90714C"), try render(view: Spacer().background(Color.brown).frame(width: 1.0, height: 1.0)))
    }

    func testRenderWhiteSquare() throws {
        #if SKIP
        throw XCTSkip("TODO: fix layout on Skip")
        #endif
        XCTAssertEqual(try render(outputFile: "/tmp/SKipUITests-testRenderWhite", view: Spacer().background(Color.white).frame(width: 2.0, height: 2.0)),
        """
        0xFFFFFF 0xFFFFFF
        0xFFFFFF 0xFFFFFF
        """)
    }

    func testRenderStacks() throws {
        #if !os(macOS)
        throw XCTSkip("TODO: calculate platform-dependent values")
        #endif
        #if os(iOS)
        throw XCTSkip("TODO: calculate platform-dependent values")
        #endif
        #if SKIP
        throw XCTSkip("TODO: fix layout on Skip")
        #endif

        // this is never run (yet)
        XCTAssertEqual(try render(outputFile: "/tmp/SKipUITests-testRenderStacks", view: VStack {
            HStack {
                Spacer().background(Color.purple)
                Spacer().background(Color.orange)
            }
            HStack {
                Spacer().background(Color.blue)
                Spacer().background(Color.red)
            }
        }
        .frame(width: 10.0, height: 10.0)), """
            0x180821 0x180821 0x000000 0x000000 0x000000 0x000000 0x000000 0x000000 0x000000 0x000000
            0x180821 0x180821 0x000000 0x000000 0x000000 0x000000 0x000000 0x000000 0x000000 0x000000
            0x000000 0x000000 0x000000 0x000000 0x000000 0x000000 0x000000 0x000000 0x000000 0x000000
            0x000000 0x000000 0x000000 0x000000 0x000000 0x000000 0x000000 0x000000 0x000000 0x000000
            0x000000 0x000000 0x000000 0x000000 0x000000 0x000000 0x000000 0x000000 0x000000 0x000000
            0x000000 0x000000 0x000000 0x000000 0x000000 0x000000 0x000000 0x000000 0x000000 0x000000
            0x000000 0x000000 0x000000 0x000000 0x000000 0x000000 0x000000 0x000000 0x000000 0x000000
            0x000000 0x000000 0x000000 0x000000 0x000000 0x000000 0x000000 0x000000 0x000000 0x000000
            0x000000 0x000000 0x000000 0x000000 0x000000 0x000000 0x000000 0x000000 0x000000 0x000000
            0x000000 0x000000 0x000000 0x000000 0x000000 0x000000 0x000000 0x000000 0x000000 0x000000
            """)
    }

    /// Renders the given SwiftUI view as an ASCII string representing the shapes and colors in the view.
    /// The optional `outputFile` can be specified to save a PNG form of the view to the given file.
    /// This function handles the three separate scenarios of iOS (UIKit), macOS (AppKit), and Android (SkipKit), which all have different mechanisms for converting a view into a bitmap image.
    func render<V: View>(outputFile: String? = nil, darkMode: Bool = false, view content: V) throws -> String {
        #if !SKIP
        let v = content.environment(\.colorScheme, darkMode ? .dark : .light)
        #if canImport(UIKit)
        let controller = UIHostingController(rootView: v)
        guard let view: UIView = controller.view else {
            throw RenderViewError(errorDescription: "cannot access view of hosting controller")
        }
        view.backgroundColor = darkMode ? UIColor.black : UIColor.white
        #elseif canImport(AppKit)
        let controller = NSHostingController(rootView: v)
        let view: NSView = controller.view
        view.layer?.backgroundColor = darkMode ? CGColor.black : CGColor.white
        #else
        fatalError("unsupported platform for rendering a view") // e.g., Windows/Linux
        #endif

        let viewSize = view.intrinsicContentSize
        assert(viewSize.width > 0.0)
        assert(viewSize.height > 0.0)
        view.frame = CGRect(origin: .zero, size: viewSize)
        assert(view.bounds.width > 0.0)
        assert(view.bounds.height > 0.0)

        #if canImport(UIKit)
        let format = UIGraphicsImageRendererFormat.default() // (for: traits)
        format.opaque = true
        format.scale = 1.0
        let renderer = UIGraphicsImageRenderer(size: viewSize, format: format)

        let win = UIWindow()
        win.makeKeyAndVisible() // seems to be the only way to avoid empty screenshots
        defer { win.resignKey() }
        win.bounds = view.bounds
        win.rootViewController = controller

        let image: UIImage = renderer.image { ctx in
            // doesn't work for SwiftUI shape/color views
            //view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
            view.layer.render(in: ctx.cgContext)
        }

        // save PNG to the output file base if specified
        if let outputFile = outputFile, let data = image.pngData() {
            try data.write(to: URL(fileURLWithPath: outputFile + "-ios.png", isDirectory: false))
        }

        guard let cgImage: CGImage = image.cgImage else {
            throw RenderViewError(errorDescription: "cannot create CGImage")
        }

        let pdata = cgImage.dataProvider?.data
        let pixelData: UnsafePointer<UInt8> = CFDataGetBytePtr(pdata)
        let bytesPerPixel = cgImage.bitsPerPixel / cgImage.bitsPerComponent
        return createPixmapFromColors(pixelData: pixelData, width: Int(viewSize.width), height: Int(viewSize.height), bytesPerRow: cgImage.bytesPerRow, bytesPerPixel: bytesPerPixel)
        #elseif canImport(AppKit)
        guard let bitmap = view.bitmapImageRepForCachingDisplay(in: view.bounds) else {
            throw RenderViewError(errorDescription: "cannot create bitmap")
        }

        view.cacheDisplay(in: view.bounds, to: bitmap)

        guard let graphicsContext = NSGraphicsContext(bitmapImageRep: bitmap) else {
            throw RenderViewError(errorDescription: "cannot create graphics context")
        }

        // save PNG to the output file base if specified
        if let outputFile = outputFile, let data = bitmap.representation(using: .png, properties: [:]) {
            try data.write(to: URL(fileURLWithPath: outputFile + "-macos.png", isDirectory: false))
        }

        let pixelData = bitmap.bitmapData
        let bytesPerPixel = bitmap.bitsPerPixel / bitmap.bitsPerSample
        return createPixmapFromColors(pixelData: UnsafePointer(pixelData), width: Int(viewSize.width), height: Int(viewSize.height), bytesPerRow: bitmap.bytesPerRow, bytesPerPixel: bytesPerPixel)
        #endif // canImport(AppKit)
        #else // SKIP
        // SKIP INSERT: lateinit
        var renderView: android.view.View
        composeRule.setContent {
            //androidx.compose.material3.Text(text: "ABCDEF")
            renderView = LocalView.current
            // render the compose view to the canvas
            view.Compose(ComposeContext())
        }

        // https://github.com/robolectric/robolectric/issues/8071 — cannot use captureToImage from Robolectric
        // androidx.compose.ui.test.ComposeTimeoutException: Condition still not satisfied after 2000 ms
        // runBlocking {
        //     onRoot().captureToImage().asAndroidBitmap()
        // }

        let width = renderView.width
        let height = renderView.height

        // draw the view onto a canvas
        let bitmap = Bitmap.createBitmap(width, height, Bitmap.Config.ARGB_8888)
        let canvas = Canvas(bitmap)
        renderView.draw(canvas)

        var pixels = IntArray(width * height)
        bitmap.getPixels(pixels, 0, width, 0, 0, width, height)

        if let outputFile = outputFile {
            // save to the specified output file base
            let out = java.io.FileOutputStream(outputFile + "-android.png")
            bitmap.compress(Bitmap.CompressFormat.PNG, 100, out)
            out.close()
        }
        return createPixmap(pixels: Array(pixels.toList()), width: Int64(width))
        #endif
    }

    struct CannotAccessCGImage : Error { }
    struct CannotCreateBitmap : Error { }

    public struct RenderViewError : LocalizedError {
        public var errorDescription: String?
    }

    #if !SKIP
    private func createPixmapFromColors(pixelData: UnsafePointer<UInt8>!, width: Int, height: Int, bytesPerRow: Int, bytesPerPixel: Int) -> String {
        var pdesc = ""
        for y in 0..<height {
            if y > 0 {
                pdesc += "\n"
            }
            for x in 0..<width {
                let offset = (bytesPerRow * y) + (bytesPerPixel * x)
                let red = pixelData[offset]
                let green = pixelData[offset + 1]
                let blue = pixelData[offset + 2]

                if x > 0 {
                    pdesc += " "
                }
                pdesc += String(format: "0x%02X%02X%02X", red, green, blue)
            }
        }
        return pdesc
    }
    #endif

    /// Creates an ASCII representation of an array of pixels, averaging each color into one of 26 letters
    private func createPixmap(pixels: [Int], width: Int64) -> String {
        func rgb(_ packedColor: Int) -> String {
            let red = (packedColor >> 16) & 0xFF
            let green = (packedColor >> 8) & 0xFF
            let blue = packedColor & 0xFF
            let fmt = "0x%02X%02X%02X"

            #if SKIP
            return fmt.format(red, green, blue)
            #else
            return String(format: fmt, red, green, blue)
            #endif
        }

        var desc = ""
        for (i, p) in pixels.enumerated() {
            if !desc.isEmpty {
                // add in a newline for each width
                desc += i % Int(width) == 0 ? "\n" : " "
            }
            desc += rgb(p)
        }

        return desc
    }

    func testPressButton() {
        #if SKIP
        composeRule.setContent {
            // SKIP INSERT: var counter by remember { mutableStateOf(0) }

            androidx.compose.material3.Text(
                text: counter.toString(),
                modifier: Modifier.testTag("Counter")
            )
            androidx.compose.material3.Button(onClick = { counter++ }) {
                androidx.compose.material3.Text("Increment")
            }
        }

        XCTAssertEqual(composeRule.onRoot().fetchSemanticsNode().treeString(), """
        Node:
          Node:Text=[0] GetTextLayoutResult=AccessibilityAction(label=null, action=(kotlin.collections.MutableList<androidx.compose.ui.text.TextLayoutResult>) -> kotlin.Boolean) TestTag=Counter
          Node:OnClick=AccessibilityAction(label=null, action=() -> kotlin.Boolean) Focused=false RequestFocus=AccessibilityAction(label=null, action=() -> kotlin.Boolean) Role=Button Text=[Increment] GetTextLayoutResult=AccessibilityAction(label=null, action=(kotlin.collections.MutableList<androidx.compose.ui.text.TextLayoutResult>) -> kotlin.Boolean)
        """)

        composeRule
            .onNodeWithTag("Counter")
            .assertTextEquals("0")
        composeRule
            .onNodeWithText("Increment")
            .performClick()
        composeRule
            .onNodeWithTag("Counter")
            .assertTextEquals("1")

        XCTAssertEqual(composeRule.onRoot().fetchSemanticsNode().treeString(), """
        Node:
          Node:Text=[1] GetTextLayoutResult=AccessibilityAction(label=null, action=(kotlin.collections.MutableList<androidx.compose.ui.text.TextLayoutResult>) -> kotlin.Boolean) TestTag=Counter
          Node:OnClick=AccessibilityAction(label=null, action=() -> kotlin.Boolean) Focused=false RequestFocus=AccessibilityAction(label=null, action=() -> kotlin.Boolean) Role=Button Text=[Increment] GetTextLayoutResult=AccessibilityAction(label=null, action=(kotlin.collections.MutableList<androidx.compose.ui.text.TextLayoutResult>) -> kotlin.Boolean)
        """)

        #endif
    }
}


extension Sequence where Element == UInt8 {
    /// Convert this sequence of bytes into a hex string
    func hex() -> String { map { String(format: "%02x", $0) }.joined() }
}

#if SKIP

extension SemanticsNode {
    /// Returns a description of this node's hierarchy and attributes
    func treeString(indent: String = "") -> String {
        let nodeDescription = "\(indent)Node:\(attrList())"
        let cdesc = self.children.joinToString(separator = "\n") { child in
            child.treeString(indent + "  ")
        }
        return cdesc.isBlank() ? nodeDescription : (nodeDescription + "\n" + cdesc)
    }

    private func attrList() -> String {
        var desc = ""

        config.forEach { configValue in
            let key = configValue.key.name
            let values = configValue.value
            if !desc.isEmpty {
                desc += " "
            }
            desc += "\(key)=\(values)"
        }

        return desc
    }
}

#endif
