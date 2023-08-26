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

    func checkPixmapSupport() throws {
        #if !SKIP
        throw XCTSkip("TODO: SwiftUI pixmap rendering")
        #endif
    }

    func testRenderBlack() throws {
        try checkPixmapSupport()
        XCTAssertEqual(try render(view: ZStack { }.background(Color.black).frame(width: 2.0, height: 2.0)), """
        #000000#000000
        #000000#000000
        """)
    }

    func testRenderWhite() throws {
        try checkPixmapSupport()
        XCTAssertEqual(try render(view: ZStack { }.background(Color.white).frame(width: 2.0, height: 2.0)), """
        #FFFFFF#FFFFFF
        #FFFFFF#000000
        """)
    }

    func testRenderRed() throws {
        try checkPixmapSupport()
        XCTAssertEqual(try render(view: ZStack { }.background(Color.red).frame(width: 1.0, height: 1.0)), """
        #FF0000
        """)
    }

    func testRenderGreen() throws {
        try checkPixmapSupport()
        XCTAssertEqual(try render(view: ZStack { }.background(Color.green).frame(width: 5.0, height: 5.0)), """
        #00FF00#00FF00#00FF00#00FF00#00FF00
        #00FF00#000000#000000#000000#000000
        #00FF00#000000#000000#000000#000000
        #00FF00#000000#000000#000000#000000
        #00FF00#000000#000000#000000#000000
        """)
    }

    func testRenderBlue() throws {
        try checkPixmapSupport()
        XCTAssertEqual(try render(view: ZStack { }.background(Color.blue).frame(width: 1.0, height: 7.0)), """
        #0000FF
        #0000FF
        #0000FF
        #0000FF
        #0000FF
        #0000FF
        #0000FF
        """)
    }

    func testRenderOrange() throws {
        try checkPixmapSupport()
        XCTAssertEqual(try render(view: ZStack { }.background(Color.orange).frame(width: 3.0, height: 3.0)), """
        #FF9F0A#FF9F0A#FF9F0A
        #FF9F0A#000000#000000
        #FF9F0A#000000#000000
        """)
    }

    func testRenderStacks() throws {
        try checkPixmapSupport()
        XCTAssertEqual(try render(outputFile: "/tmp/testScreenshot.png", view: VStack {
            HStack {
                ZStack { }.frame(width: 5.0, height: 5.0).background(Color.purple)
                ZStack { }.frame(width: 5.0, height: 5.0).background(Color.orange)
            }
            HStack {
                ZStack { }.frame(width: 5.0, height: 5.0).background(Color.blue)
                ZStack { }.frame(width: 5.0, height: 5.0).background(Color.red)
            }
        }
        .frame(width: 10.0, height: 10.0)), """
            #FF0000#0000FF#0000FF#0000FF#0000FF#0000FF#000000#000000#000000#000000
            #FF9F0A#000000#000000#000000#000000#AF52DE#000000#000000#000000#000000
            #FF9F0A#000000#000000#000000#000000#AF52DE#000000#000000#000000#000000
            #FF9F0A#000000#000000#000000#000000#AF52DE#000000#000000#000000#000000
            #FF9F0A#000000#000000#000000#000000#AF52DE#000000#000000#000000#000000
            #FF9F0A#AF52DE#AF52DE#AF52DE#AF52DE#AF52DE#000000#000000#000000#000000
            #000000#000000#000000#000000#000000#000000#000000#000000#000000#000000
            #000000#000000#000000#000000#000000#000000#000000#000000#000000#000000
            #000000#000000#000000#000000#000000#000000#000000#000000#000000#000000
            #000000#000000#000000#000000#000000#000000#000000#000000#000000#000000
            """)
    }

    func render<V: View>(outputFile: String? = nil, view: V) throws -> String {
        #if !SKIP
        throw XCTSkip("TODO: generate bitmap string on SwiftUI side")
        #else
        // SKIP INSERT: lateinit
        var renderView: android.view.View
        composeRule.setContent {
            //androidx.compose.material3.Text(text: "ABCDEF")
            renderView = LocalView.current
            // render the compose view to the canvas
            view.Compose(ComposeContext())
        }

        // https://github.com/robolectric/robolectric/issues/8071
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
        let pixmap = createPixmap(pixels: Array(pixels.toList()), width: Int64(width))

        if let outputFile = outputFile {
            let out = java.io.FileOutputStream(outputFile)
            bitmap.compress(Bitmap.CompressFormat.PNG, 100, out)
            out.close()
        }

        return pixmap
        #endif
    }

    /// Creates an ASCII representation of an array of pixels, averaging each color into one of 26 letters
    private func createPixmap(pixels: [Int], width: Int64) -> String {
        func rgb(_ packedColor: Int) -> String {
            let red = (packedColor >> 16) & 0xFF
            let green = (packedColor >> 8) & 0xFF
            let blue = packedColor & 0xFF
            let fmt = "#%02X%02X%02X"
            #if SKIP
            return fmt.format(red, green, blue)
            #else
            return String(format: fmt, red, green, blue)
            #endif
        }

        var desc = ""
        var i = 0
        for (i, p) in pixels.enumerated() {
            if !desc.isEmpty && i % Int(width) == 0 {
                // add in a newline for each width
                desc += "\n"
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
