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
final class SnapshotTests: XCTestCase {
    // SKIP INSERT: @get:Rule val composeRule = createComposeRule()

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
        XCTAssertEqual(plaf("00FF00", macos: "000000", android: "000000"), try render(darkMode: true, view: Color.clear.frame(width: 1.0, height: 1.0)))
    }

    func testColorClearLight() throws {
        XCTAssertEqual(plaf("FFFF00", macos: "FFFFFF", android: "000000"), try render(view: Color.clear.frame(width: 1.0, height: 1.0)))
    }

    func testColorBlackDark() throws {
        XCTAssertEqual(plaf("000000"), try render(darkMode: true, view: Color.black.frame(width: 1.0, height: 1.0)))
    }

    func testColorBlackLight() throws {
        XCTAssertEqual(plaf("000000"), try render(view: Color.black.frame(width: 1.0, height: 1.0)))
    }

    func testColorWhiteDark() throws {
        XCTAssertEqual(plaf("FFFFFF"), try render(darkMode: true, view: Color.white.frame(width: 1.0, height: 1.0)))
    }

    func testColorWhiteLight() throws {
        XCTAssertEqual(plaf("FFFFFF"), try render(view: Color.white.frame(width: 1.0, height: 1.0)))
    }

    func testColorGrayDark() throws {
        XCTAssertEqual(plaf("8E8E93", macos: "86868B", android: "888888"), try render(darkMode: true, view: Color.gray.frame(width: 1.0, height: 1.0)))
    }

    func testColorGrayLight() throws {
        XCTAssertEqual(plaf("8E8E93", macos: "7B7B81", android: "888888"), try render(view: Color.gray.frame(width: 1.0, height: 1.0)))
    }

    func testColorRedDark() throws {
        XCTAssertEqual(plaf("FF453A", macos: "FC2B2D", android: "FF0000"), try render(darkMode: true, view: Color.red.frame(width: 1.0, height: 1.0)))
    }

    func testColorRedLight() throws {
        XCTAssertEqual(plaf("FF3B30", macos: "FC2125", android: "FF0000"), try render(view: Color.red.frame(width: 1.0, height: 1.0)))
    }

    func testColorOrangeDark() throws {
        XCTAssertEqual(plaf("FF9F0A", macos: "FD8D0E"), try render(darkMode: true, view: Color.orange.frame(width: 1.0, height: 1.0)))
    }

    func testColorOrangeLight() throws {
        XCTAssertEqual(plaf("FF9500", macos: "FD8208", android: "FF9F0A"), try render(view: Color.orange.frame(width: 1.0, height: 1.0)))
    }

    func testColorYellowDark() throws {
        XCTAssertEqual(plaf("FFD60A", macos: "FECF0F", android: "FFFF00"), try render(darkMode: true, view: Color.yellow.frame(width: 1.0, height: 1.0)))
    }

    func testColorYellowLight() throws {
        XCTAssertEqual(plaf("FFCC00", macos: "FEC309", android: "FFFF00"), try render(view: Color.yellow.frame(width: 1.0, height: 1.0)))
    }

    func testColorGreenDark() throws {
        XCTAssertEqual(plaf("30D158", macos: "30D33B", android: "00FF00"), try render(darkMode: true, view: Color.green.frame(width: 1.0, height: 1.0)))
    }

    func testColorGreenLight() throws {
        XCTAssertEqual(plaf("34C759", macos: "29C732", android: "00FF00"), try render(view: Color.green.frame(width: 1.0, height: 1.0)))
    }

    func testColorMintDark() throws {
        XCTAssertEqual(plaf("63E6E2", macos: "56E2DB", android: "5AC8FA"), try render(darkMode: true, view: Color.mint.frame(width: 1.0, height: 1.0)))
    }

    func testColorMintLight() throws {
        XCTAssertEqual(plaf("00C7BE", macos: "18BDB0", android: "5AC8FA"), try render(view: Color.mint.frame(width: 1.0, height: 1.0)))
    }

    func testColortTealDark() throws {
        XCTAssertEqual(plaf("40C8E0", macos: "5AB8D4", android: "64D2FF"), try render(darkMode: true, view: Color.teal.frame(width: 1.0, height: 1.0)))
    }

    func testColorTealLight() throws {
        XCTAssertEqual(plaf("30B0C7", macos: "4A9DB7", android: "64D2FF"), try render(view: Color.teal.frame(width: 1.0, height: 1.0)))
    }

    func testColorCyanDark() throws {
        XCTAssertEqual(plaf("64D2FF", macos: "4CBCF2", android: "00FFFF"), try render(darkMode: true, view: Color.cyan.frame(width: 1.0, height: 1.0)))
    }

    func testColorCyanLight() throws {
        XCTAssertEqual(plaf("32ADE6", macos: "47B0EC", android: "00FFFF"), try render(view: Color.cyan.frame(width: 1.0, height: 1.0)))
    }

    func testColorBlueDark() throws {
        XCTAssertEqual(plaf("0A84FF", macos: "106BFF", android: "0000FF"), try render(darkMode: true, view: Color.blue.frame(width: 1.0, height: 1.0)))
    }

    func testColorBlueLight() throws {
        XCTAssertEqual(plaf("007AFF", macos: "0A60FF", android: "0000FF"), try render(view: Color.blue.frame(width: 1.0, height: 1.0)))
    }

    func testColorIndigoDark() throws {
        XCTAssertEqual(plaf("5E5CE6", macos: "4B40E0", android: "5856D6"), try render(darkMode: true, view: Color.indigo.frame(width: 1.0, height: 1.0)))
    }

    func testColorIndigoLight() throws {
        XCTAssertEqual(plaf("5856D6", macos: "453CCC"), try render(view: Color.indigo.frame(width: 1.0, height: 1.0)))
    }

    func testColorPurpleDark() throws {
        XCTAssertEqual(plaf("BF5AF2", macos: "AF39EE", android: "AF52DE"), try render(darkMode: true, view: Color.purple.frame(width: 1.0, height: 1.0)))
    }

    func testColorPurpleLight() throws {
        XCTAssertEqual(plaf("AF52DE", macos: "9D33D6"), try render(view: Color.purple.frame(width: 1.0, height: 1.0)))
    }

    func testColorPinkDark() throws {
        XCTAssertEqual(plaf("FF375F", macos: "FC1A4D", android: "FF2D55"), try render(darkMode: true, view: Color.pink.frame(width: 1.0, height: 1.0)))
    }

    func testColorPinkLight() throws {
        XCTAssertEqual(plaf("FF2D55", macos: "FB0D44"), try render(view: Color.pink.frame(width: 1.0, height: 1.0)))
    }

    func testColorBrownDark() throws {
        XCTAssertEqual(plaf("AC8E68", macos: "9B7C55", android: "A2845E"), try render(darkMode: true, view: Color.brown.frame(width: 1.0, height: 1.0)))
    }

    func testColorBrownLight() throws {
        XCTAssertEqual(plaf("A2845E", macos: "90714C"), try render(view: Color.brown.frame(width: 1.0, height: 1.0)))
    }

    func testOrangeVariations() throws {
        #if os(iOS)
        XCTAssertEqual(plaf("FF9F0A"), try render(darkMode: true, view: Color.orange.background(Color.black).frame(width: 1.0, height: 1.0)))
        XCTAssertEqual(plaf("FF9F0A"), try render(darkMode: true, view: Color.orange.background(Color.white).frame(width: 1.0, height: 1.0)))
        XCTAssertEqual(plaf("FF9F0A"), try render(darkMode: true, view: Color.orange.background(Color.red).frame(width: 1.0, height: 1.0)))
        #endif
    }

    func testRenderWhiteSquare() throws {
        XCTAssertEqual(try render(outputFile: "/tmp/SKipUITests-testRenderWhiteSquare", view: Color.white.frame(width: 4.0, height: 4.0)),
        plaf("""
        FFFFFF FFFFFF FFFFFF FFFFFF
        FFFFFF FFFFFF FFFFFF FFFFFF
        FFFFFF FFFFFF FFFFFF FFFFFF
        FFFFFF FFFFFF FFFFFF FFFFFF
        """,
        android: """
        FFFFFF FFFFFF FFFFFF FFFFFF
        FFFFFF 000000 000000 000000
        FFFFFF 000000 000000 000000
        FFFFFF 000000 000000 000000
        """))
    }

    func testRenderWhiteSquareBig() throws {
        XCTAssertEqual(try render(outputFile: "/tmp/SKipUITests-testRenderWhiteSquareBig", view: Color.white.frame(width: 12.0, height: 12.0)),
        plaf("""
        FFFFFF FFFFFF FFFFFF FFFFFF FFFFFF FFFFFF FFFFFF FFFFFF FFFFFF FFFFFF FFFFFF FFFFFF
        FFFFFF FFFFFF FFFFFF FFFFFF FFFFFF FFFFFF FFFFFF FFFFFF FFFFFF FFFFFF FFFFFF FFFFFF
        FFFFFF FFFFFF FFFFFF FFFFFF FFFFFF FFFFFF FFFFFF FFFFFF FFFFFF FFFFFF FFFFFF FFFFFF
        FFFFFF FFFFFF FFFFFF FFFFFF FFFFFF FFFFFF FFFFFF FFFFFF FFFFFF FFFFFF FFFFFF FFFFFF
        FFFFFF FFFFFF FFFFFF FFFFFF FFFFFF FFFFFF FFFFFF FFFFFF FFFFFF FFFFFF FFFFFF FFFFFF
        FFFFFF FFFFFF FFFFFF FFFFFF FFFFFF FFFFFF FFFFFF FFFFFF FFFFFF FFFFFF FFFFFF FFFFFF
        FFFFFF FFFFFF FFFFFF FFFFFF FFFFFF FFFFFF FFFFFF FFFFFF FFFFFF FFFFFF FFFFFF FFFFFF
        FFFFFF FFFFFF FFFFFF FFFFFF FFFFFF FFFFFF FFFFFF FFFFFF FFFFFF FFFFFF FFFFFF FFFFFF
        FFFFFF FFFFFF FFFFFF FFFFFF FFFFFF FFFFFF FFFFFF FFFFFF FFFFFF FFFFFF FFFFFF FFFFFF
        FFFFFF FFFFFF FFFFFF FFFFFF FFFFFF FFFFFF FFFFFF FFFFFF FFFFFF FFFFFF FFFFFF FFFFFF
        FFFFFF FFFFFF FFFFFF FFFFFF FFFFFF FFFFFF FFFFFF FFFFFF FFFFFF FFFFFF FFFFFF FFFFFF
        FFFFFF FFFFFF FFFFFF FFFFFF FFFFFF FFFFFF FFFFFF FFFFFF FFFFFF FFFFFF FFFFFF FFFFFF
        """, android: """
        FFFFFF FFFFFF FFFFFF FFFFFF FFFFFF FFFFFF FFFFFF FFFFFF FFFFFF FFFFFF FFFFFF FFFFFF
        FFFFFF 000000 000000 000000 000000 000000 000000 000000 000000 000000 000000 000000
        FFFFFF 000000 000000 000000 000000 000000 000000 000000 000000 000000 000000 000000
        FFFFFF 000000 000000 000000 000000 000000 000000 000000 000000 000000 000000 000000
        FFFFFF 000000 000000 000000 000000 000000 000000 000000 000000 000000 000000 000000
        FFFFFF 000000 000000 000000 000000 000000 000000 000000 000000 000000 000000 000000
        FFFFFF 000000 000000 000000 000000 000000 000000 000000 000000 000000 000000 000000
        FFFFFF 000000 000000 000000 000000 000000 000000 000000 000000 000000 000000 000000
        FFFFFF 000000 000000 000000 000000 000000 000000 000000 000000 000000 000000 000000
        FFFFFF 000000 000000 000000 000000 000000 000000 000000 000000 000000 000000 000000
        FFFFFF 000000 000000 000000 000000 000000 000000 000000 000000 000000 000000 000000
        FFFFFF 000000 000000 000000 000000 000000 000000 000000 000000 000000 000000 000000
        """))
    }

    /// **NOTE**: macOS and Android are both wrong currently
    func testRenderStacks() throws {
        XCTAssertEqual(try render(outputFile: "/tmp/SKipUITests-testRenderStacks", view: VStack {
            HStack {
                ZStack { Spacer() }.background(Color.black).frame(width: 4.0, height: 3.0)
                ZStack { Spacer() }.background(Color.white).frame(width: 8.0, height: 3.0)
            }
            HStack {
                ZStack { Spacer() }.background(Color.white).frame(width: 8.0, height: 9.0)
                ZStack { Spacer() }.background(Color.black).frame(width: 4.0, height: 9.0)
            }
        }
        .frame(width: 12.0, height: 12.0)), plaf("""
            000000 000000 000000 000000 FFFFFF FFFFFF FFFFFF FFFFFF FFFFFF FFFFFF FFFFFF FFFFFF
            000000 000000 000000 000000 FFFFFF FFFFFF FFFFFF FFFFFF FFFFFF FFFFFF FFFFFF FFFFFF
            000000 000000 000000 000000 FFFFFF FFFFFF FFFFFF FFFFFF FFFFFF FFFFFF FFFFFF FFFFFF
            FFFFFF FFFFFF FFFFFF FFFFFF FFFFFF FFFFFF 000000 000000 000000 000000 000000 000000
            FFFFFF FFFFFF FFFFFF FFFFFF FFFFFF FFFFFF 000000 000000 000000 000000 000000 000000
            FFFFFF FFFFFF FFFFFF FFFFFF FFFFFF FFFFFF 000000 000000 000000 000000 000000 000000
            FFFFFF FFFFFF FFFFFF FFFFFF FFFFFF FFFFFF 000000 000000 000000 000000 000000 000000
            FFFFFF FFFFFF FFFFFF FFFFFF FFFFFF FFFFFF 000000 000000 000000 000000 000000 000000
            FFFFFF FFFFFF FFFFFF FFFFFF FFFFFF FFFFFF 000000 000000 000000 000000 000000 000000
            FFFFFF FFFFFF FFFFFF FFFFFF FFFFFF FFFFFF 000000 000000 000000 000000 000000 000000
            FFFFFF FFFFFF FFFFFF FFFFFF FFFFFF FFFFFF 000000 000000 000000 000000 000000 000000
            FFFFFF FFFFFF FFFFFF FFFFFF FFFFFF FFFFFF 000000 000000 000000 000000 000000 000000
            """, macos: """
            000000 000000 000000 000000 000000 000000 000000 000000 FFFFFF FFFFFF FFFFFF FFFFFF
            000000 000000 000000 000000 000000 000000 000000 000000 FFFFFF FFFFFF FFFFFF FFFFFF
            000000 000000 000000 000000 000000 000000 000000 000000 FFFFFF FFFFFF FFFFFF FFFFFF
            000000 000000 000000 000000 000000 000000 000000 000000 FFFFFF FFFFFF FFFFFF FFFFFF
            000000 000000 000000 000000 000000 000000 000000 000000 FFFFFF FFFFFF FFFFFF FFFFFF
            000000 000000 000000 000000 000000 000000 000000 000000 FFFFFF FFFFFF FFFFFF FFFFFF
            FFFFFF FFFFFF FFFFFF FFFFFF FFFFFF FFFFFF FFFFFF FFFFFF FFFFFF FFFFFF FFFFFF FFFFFF
            FFFFFF FFFFFF FFFFFF FFFFFF FFFFFF FFFFFF FFFFFF FFFFFF FFFFFF FFFFFF FFFFFF FFFFFF
            FFFFFF FFFFFF FFFFFF FFFFFF FFFFFF FFFFFF FFFFFF FFFFFF FFFFFF FFFFFF FFFFFF FFFFFF
            FFFFFF FFFFFF FFFFFF FFFFFF FFFFFF FFFFFF FFFFFF FFFFFF FFFFFF FFFFFF FFFFFF FFFFFF
            FFFFFF FFFFFF FFFFFF FFFFFF FFFFFF FFFFFF FFFFFF FFFFFF FFFFFF FFFFFF FFFFFF FFFFFF
            FFFFFF FFFFFF FFFFFF FFFFFF FFFFFF FFFFFF FFFFFF FFFFFF FFFFFF FFFFFF FFFFFF FFFFFF
            """, android: """
            000000 FFFFFF FFFFFF FFFFFF FFFFFF FFFFFF FFFFFF FFFFFF FFFFFF 000000 000000 000000
            000000 FFFFFF FFFFFF FFFFFF FFFFFF FFFFFF FFFFFF FFFFFF FFFFFF 000000 000000 000000
            FFFFFF 000000 000000 000000 000000 000000 000000 000000 000000 000000 000000 000000
            FFFFFF 000000 000000 000000 000000 000000 000000 000000 000000 000000 000000 000000
            000000 000000 000000 000000 000000 000000 000000 000000 000000 000000 000000 000000
            000000 000000 000000 000000 000000 000000 000000 000000 000000 000000 000000 000000
            000000 000000 000000 000000 000000 000000 000000 000000 000000 000000 000000 000000
            000000 000000 000000 000000 000000 000000 000000 000000 000000 000000 000000 000000
            000000 000000 000000 000000 000000 000000 000000 000000 000000 000000 000000 000000
            000000 000000 000000 000000 000000 000000 000000 000000 000000 000000 000000 000000
            000000 000000 000000 000000 000000 000000 000000 000000 000000 000000 000000 000000
            000000 000000 000000 000000 000000 000000 000000 000000 000000 000000 000000 000000
            """))
    }

    /// Renders the given SwiftUI view as an ASCII string representing the shapes and colors in the view.
    /// The optional `outputFile` can be specified to save a PNG form of the view to the given file.
    /// This function handles the three separate scenarios of iOS (UIKit), macOS (AppKit), and Android (SkipKit), which all have different mechanisms for converting a view into a bitmap image.
    func render<V: View>(outputFile: String? = nil, darkMode: Bool = false, view content: V) throws -> String {
        #if !SKIP
        let v = content.environment(\.colorScheme, darkMode ? .dark : .light).environment(\.displayScale, 1.0)
        #if canImport(UIKit)
        let controller = UIHostingController(rootView: v)
        guard let view: UIView = controller.view else {
            throw RenderViewError(errorDescription: "cannot access view of hosting controller")
        }
        view.backgroundColor = darkMode ? UIColor.black : UIColor.white
        #elseif canImport(AppKit)
        let controller = NSHostingController(rootView: v)
        let view: NSView = controller.view
        view.layer!.backgroundColor = darkMode ? CGColor.black : CGColor.white
        //view.layer!.contentsScale = 0.5
        //view.scaleUnitSquare(to: NSSize(width: 0.5, height: 0.5))
        #else
        fatalError("unsupported platform for rendering a view") // e.g., Windows/Linux
        #endif

        let viewSize = view.intrinsicContentSize
        let bounds = CGRect(origin: .zero, size: viewSize)
        assert(bounds.width > 0.0)
        assert(bounds.height > 0.0)
        view.frame = bounds

        #if canImport(UIKit)
        let format = UIGraphicsImageRendererFormat.default() // (for: traits)
        format.opaque = false
        format.scale = 1.0
        let renderer = UIGraphicsImageRenderer(size: viewSize, format: format)

        let win = UIWindow()
        win.makeKeyAndVisible() // seems to be the only way to avoid empty screenshots
        defer { win.resignKey() }
        win.bounds = bounds
        win.rootViewController = controller

        let image: UIImage = renderer.image { ctx in
            // doesn't work for SwiftUI shape/color views
            //view.drawHierarchy(in: bounds, afterScreenUpdates: true)
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
        view.needsDisplay = true
        view.needsLayout = true
        var scaledSize = bounds.size
        //scaledSize.width *= 2.0
        //scaledSize.height *= 2.0

        guard let bitmap = view.bitmapImageRepForCachingDisplay(in: bounds) else {
            throw RenderViewError(errorDescription: "cannot create bitmap")
        }
        bitmap.size = scaledSize // scale down the bitmap to get 1-to-1 pixels
        view.cacheDisplay(in: bounds, to: bitmap)

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
                pdesc += String(format: "%02X%02X%02X", red, green, blue)
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
            let fmt = "%02X%02X%02X"

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
}


extension Sequence where Element == UInt8 {
    /// Convert this sequence of bytes into a hex string
    func hex() -> String { map { String(format: "%02x", $0) }.joined() }
}
