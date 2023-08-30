// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

import SwiftUI
import XCTest
import OSLog
import Foundation

// SKIP INSERT: import android.os.Build

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
// SKIP INSERT: import androidx.compose.ui.graphics.nativeCanvas
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

// DO NOT IMPORT! conflicts with SwiftUI.Font
// SKIP INSERT: //import androidx.compose.ui.text.font.Font

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
// SKIP INSERT: @org.robolectric.annotation.GraphicsMode(org.robolectric.annotation.GraphicsMode.Mode.NATIVE)
final class SnapshotTests: XCTestCase {
    fileprivate let logger: Logger = Logger(subsystem: "test", category: "SnapshotTests")

    // SKIP INSERT: @get:Rule val composeRule = createComposeRule()

    /// Returns one of the strings based on the current platform.
    /// - Parameters:
    ///   - ios: the default iOS string
    ///   - macos: the macOS string
    ///   - android: the Android string
    /// - Returns: the string according to the platform
    func plaf(_ ios: String, macos: String? = nil, android: String? = nil) -> String {
        precondition(ios != macos || macos?.isEmpty == true, "strings should differ for platform-specific values")
        precondition(ios != android || android?.isEmpty == true, "strings should differ for platform-specific values")
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

    func testColorBlackCompact() throws {
        XCTAssertEqual("0", try render(compact: true, view: Color.black.frame(width: 1.0, height: 1.0)))
    }

    func testColorWhiteCompact() throws {
        XCTAssertEqual("F", try render(compact: true, view: Color.white.frame(width: 1.0, height: 1.0)))
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
        XCTAssertEqual(plaf("8E8E93", macos: "98989D"), try render(darkMode: true, view: Color.gray.frame(width: 1.0, height: 1.0)))
    }

    func testColorGrayLight() throws {
        XCTAssertEqual(plaf("8E8E93"), try render(view: Color.gray.frame(width: 1.0, height: 1.0)))
    }

    func testColorRedDark() throws {
        XCTAssertEqual(plaf("FF453A", android: "FF3B30"), try render(darkMode: true, view: Color.red.frame(width: 1.0, height: 1.0)))
    }

    func testColorRedLight() throws {
        XCTAssertEqual(plaf("FF3B30"), try render(view: Color.red.frame(width: 1.0, height: 1.0)))
    }

    func testColorOrangeDark() throws {
        XCTAssertEqual(plaf("FF9F0A", android: "FF9500"), try render(darkMode: true, view: Color.orange.frame(width: 1.0, height: 1.0)))
    }

    func testColorOrangeLight() throws {
        XCTAssertEqual(plaf("FF9500"), try render(view: Color.orange.frame(width: 1.0, height: 1.0)))
    }

    func testColorYellowDark() throws {
        XCTAssertEqual(plaf("FFD60A", android: "FFCC00"), try render(darkMode: true, view: Color.yellow.frame(width: 1.0, height: 1.0)))
    }

    func testColorYellowLight() throws {
        XCTAssertEqual(plaf("FFCC00"), try render(view: Color.yellow.frame(width: 1.0, height: 1.0)))
    }

    func testColorGreenDark() throws {
        XCTAssertEqual(plaf("30D158", macos: "32D74B", android: "34C759"), try render(darkMode: true, view: Color.green.frame(width: 1.0, height: 1.0)))
    }

    func testColorGreenLight() throws {
        XCTAssertEqual(plaf("34C759", macos: "28CD41"), try render(view: Color.green.frame(width: 1.0, height: 1.0)))
    }

    func testColorMintDark() throws {
        XCTAssertEqual(plaf("63E6E2", android: "00C7BE"), try render(darkMode: true, view: Color.mint.frame(width: 1.0, height: 1.0)))
    }

    func testColorMintLight() throws {
        XCTAssertEqual(plaf("00C7BE"), try render(view: Color.mint.frame(width: 1.0, height: 1.0)))
    }

    func testColortTealDark() throws {
        XCTAssertEqual(plaf("40C8E0", macos: "6AC4DC", android: "30B0C7"), try render(darkMode: true, view: Color.teal.frame(width: 1.0, height: 1.0)))
    }

    func testColorTealLight() throws {
        XCTAssertEqual(plaf("30B0C7", macos: "59ADC4"), try render(view: Color.teal.frame(width: 1.0, height: 1.0)))
    }

    func testColorCyanDark() throws {
        XCTAssertEqual(plaf("64D2FF", macos: "5AC8F5", android: "32ADE6"), try render(darkMode: true, view: Color.cyan.frame(width: 1.0, height: 1.0)))
    }

    func testColorCyanLight() throws {
        XCTAssertEqual(plaf("32ADE6", macos: "55BEF0"), try render(view: Color.cyan.frame(width: 1.0, height: 1.0)))
    }

    func testColorBlueDark() throws {
        XCTAssertEqual(plaf("0A84FF", android: "007AFF"), try render(darkMode: true, view: Color.blue.frame(width: 1.0, height: 1.0)))
    }

    func testColorBlueLight() throws {
        XCTAssertEqual(plaf("007AFF"), try render(view: Color.blue.frame(width: 1.0, height: 1.0)))
    }

    func testColorIndigoDark() throws {
        XCTAssertEqual(plaf("5E5CE6", android: "5856D6"), try render(darkMode: true, view: Color.indigo.frame(width: 1.0, height: 1.0)))
    }

    func testColorIndigoLight() throws {
        XCTAssertEqual(plaf("5856D6"), try render(view: Color.indigo.frame(width: 1.0, height: 1.0)))
    }

    func testColorPurpleDark() throws {
        XCTAssertEqual(plaf("BF5AF2", android: "AF52DE"), try render(darkMode: true, view: Color.purple.frame(width: 1.0, height: 1.0)))
    }

    func testColorPurpleLight() throws {
        XCTAssertEqual(plaf("AF52DE"), try render(view: Color.purple.frame(width: 1.0, height: 1.0)))
    }

    func testColorPinkDark() throws {
        XCTAssertEqual(plaf("FF375F", android: "FF2D55"), try render(darkMode: true, view: Color.pink.frame(width: 1.0, height: 1.0)))
    }

    func testColorPinkLight() throws {
        XCTAssertEqual(plaf("FF2D55"), try render(view: Color.pink.frame(width: 1.0, height: 1.0)))
    }

    func testColorBrownDark() throws {
        XCTAssertEqual(plaf("AC8E68", android: "A2845E"), try render(darkMode: true, view: Color.brown.frame(width: 1.0, height: 1.0)))
    }

    func testColorBrownLight() throws {
        XCTAssertEqual(plaf("A2845E"), try render(view: Color.brown.frame(width: 1.0, height: 1.0)))
    }

    func testRenderCustomShape() throws {
        #if !SKIP
        throw XCTSkip("Android-only function")
        #else
        XCTAssertEqual(try render(compact: true, view: ComposeView(content: { ctx in
            androidx.compose.foundation.layout.Box(modifier: Modifier.background(androidx.compose.ui.graphics.Color.White).size(12.dp), contentAlignment: androidx.compose.ui.Alignment.Center) {
                androidx.compose.foundation.layout.Box(modifier: Modifier.background(androidx.compose.ui.graphics.Color.Black).size(6.dp, 6.dp))
            }
        })),
        plaf("""
        F F F F F F F F F F F F
        F F F F F F F F F F F F
        F F F F F F F F F F F F
        F F F 0 0 0 0 0 0 F F F
        F F F 0 0 0 0 0 0 F F F
        F F F 0 0 0 0 0 0 F F F
        F F F 0 0 0 0 0 0 F F F
        F F F 0 0 0 0 0 0 F F F
        F F F 0 0 0 0 0 0 F F F
        F F F F F F F F F F F F
        F F F F F F F F F F F F
        F F F F F F F F F F F F
        """))
        #endif
    }

    func testRenderWhiteSquareTiny() throws {
        XCTAssertEqual(try render(compact: true, view: Color.white.frame(width: 2.0, height: 2.0)),
        plaf("""
        F F
        F F
        """))
    }

    func testRenderWhiteSquare() throws {
        XCTAssertEqual(try render(compact: true, view: Color.white.frame(width: 4.0, height: 4.0)),
        plaf("""
        F F F F
        F F F F
        F F F F
        F F F F
        """))
    }

    func testRenderWhiteSquareBig() throws {
        XCTAssertEqual(try render(compact: true, view: Color.white.frame(width: 12.0, height: 12.0)),
        plaf("""
        F F F F F F F F F F F F
        F F F F F F F F F F F F
        F F F F F F F F F F F F
        F F F F F F F F F F F F
        F F F F F F F F F F F F
        F F F F F F F F F F F F
        F F F F F F F F F F F F
        F F F F F F F F F F F F
        F F F F F F F F F F F F
        F F F F F F F F F F F F
        F F F F F F F F F F F F
        F F F F F F F F F F F F
        """))
    }

    func testZStackSquareCenter() throws {
        XCTAssertEqual(try render(compact: true, view: ZStack {
            Color.black.frame(width: 12.0, height: 12.0)
            Color.white.frame(width: 6.0, height: 6.0)
        }),
        plaf("""
        0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 F F F F F F 0 0 0
        0 0 0 F F F F F F 0 0 0
        0 0 0 F F F F F F 0 0 0
        0 0 0 F F F F F F 0 0 0
        0 0 0 F F F F F F 0 0 0
        0 0 0 F F F F F F 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0
        """))
    }

    func testRotatedSquareAliased() throws {
        // shadow effect of a rotated shape is slightly different on Android and iOS
        XCTAssertEqual(try render(compact: false, antiAlias: true, view: ZStack {
            Color.black.frame(width: 12.0, height: 12.0)
            Color.white.frame(width: 6.0, height: 6.0).rotationEffect(Angle.degrees(45.0))
        }),
        plaf("""
        000000 000000 000000 000000 000000 000000 000000 000000 000000 000000 000000 000000
        000000 000000 000000 000000 000000 070707 070707 000000 000000 000000 000000 000000
        000000 000000 000000 000000 070707 B6B6B6 B6B6B6 070707 000000 000000 000000 000000
        000000 000000 000000 070707 B6B6B6 FFFFFF FFFFFF B6B6B6 070707 000000 000000 000000
        000000 000000 070707 B6B6B6 FFFFFF FFFFFF FFFFFF FFFFFF B6B6B6 070707 000000 000000
        000000 070707 B6B6B6 FFFFFF FFFFFF FFFFFF FFFFFF FFFFFF FFFFFF B6B6B6 070707 000000
        000000 070707 B6B6B6 FFFFFF FFFFFF FFFFFF FFFFFF FFFFFF FFFFFF B6B6B6 070707 000000
        000000 000000 070707 B6B6B6 FFFFFF FFFFFF FFFFFF FFFFFF B6B6B6 070707 000000 000000
        000000 000000 000000 070707 B6B6B6 FFFFFF FFFFFF B6B6B6 070707 000000 000000 000000
        000000 000000 000000 000000 070707 B6B6B6 B6B6B6 070707 000000 000000 000000 000000
        000000 000000 000000 000000 000000 070707 070707 000000 000000 000000 000000 000000
        000000 000000 000000 000000 000000 000000 000000 000000 000000 000000 000000 000000
        """, android: """
        000000 000000 000000 000000 000000 000000 000000 000000 000000 000000 000000 000000
        000000 000000 000000 000000 000000 000000 000000 000000 000000 000000 000000 000000
        000000 000000 000000 000000 000000 A0A0A0 9F9F9F 000000 000000 000000 000000 000000
        000000 000000 000000 000000 A0A0A0 FFFFFF FFFFFF 9F9F9F 000000 000000 000000 000000
        000000 000000 000000 A0A0A0 FFFFFF FFFFFF FFFFFF FFFFFF 9F9F9F 000000 000000 000000
        000000 000000 A0A0A0 FFFFFF FFFFFF FFFFFF FFFFFF FFFFFF FFFFFF 9F9F9F 000000 000000
        000000 000000 A0A0A0 FFFFFF FFFFFF FFFFFF FFFFFF FFFFFF FFFFFF A0A0A0 000000 000000
        000000 000000 000000 A0A0A0 FFFFFF FFFFFF FFFFFF FFFFFF A0A0A0 000000 000000 000000
        000000 000000 000000 000000 A0A0A0 FFFFFF FFFFFF A0A0A0 000000 000000 000000 000000
        000000 000000 000000 000000 000000 A0A0A0 A0A0A0 000000 000000 000000 000000 000000
        000000 000000 000000 000000 000000 000000 000000 000000 000000 000000 000000 000000
        000000 000000 000000 000000 000000 000000 000000 000000 000000 000000 000000 000000
        """))
    }

    func testRotatedSquare() throws {
        // aliasing effect of a rotated shape is slightly different on Android and iOS so disable
        // TODO: anti-aliasing on Android doesn't yet work
        XCTAssertEqual(try render(compact: true, antiAlias: false, view: ZStack {
            Color.black.frame(width: 12.0, height: 12.0)
            Color.white.frame(width: 6.0, height: 6.0).rotationEffect(Angle.degrees(45.0))
        }),
        plaf("""
        0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 F F 0 0 0 0 0
        0 0 0 0 F F F F 0 0 0 0
        0 0 0 F F F F F F 0 0 0
        0 0 F F F F F F F F 0 0
        0 F F F F F F F F F F 0
        0 F F F F F F F F F F 0
        0 0 F F F F F F F F 0 0
        0 0 0 F F F F F F 0 0 0
        0 0 0 0 F F F F 0 0 0 0
        0 0 0 0 0 F F 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0
        """, android: """
        0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0A 9F 0 0 0 0 0
        0 0 0 0 0A F F 9F 0 0 0 0
        0 0 0 0A F F F F 9F 0 0 0
        0 0 0A F F F F F F 9F 0 0
        0 0 0A F F F F F F 0A 0 0
        0 0 0 0A F F F F 0A 0 0 0
        0 0 0 0 0A F F 0A 0 0 0 0
        0 0 0 0 0 0A 0A 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0
        """))
    }

    func testDrawCourierBar() throws {
        XCTAssertEqual(try render(compact: false, view: ZStack {
            Text("|").font(Font.custom("courier", size: CGFloat(8.0))).foregroundColor(Color.black)
        }.frame(width: 7.0, height: 8.0).background(Color.white)),
        plaf("""
        FFFFFF FFFFFF F5F5F5 9F9F9F FFFFFF FFFFFF FFFFFF
        FFFFFF FFFFFF F5F5F5 9F9F9F FFFFFF FFFFFF FFFFFF
        FFFFFF FFFFFF F5F5F5 9F9F9F FFFFFF FFFFFF FFFFFF
        FFFFFF FFFFFF F5F5F5 9F9F9F FFFFFF FFFFFF FFFFFF
        FFFFFF FFFFFF F5F5F5 9F9F9F FFFFFF FFFFFF FFFFFF
        FFFFFF FFFFFF F5F5F5 9F9F9F FFFFFF FFFFFF FFFFFF
        FFFFFF FFFFFF F5F5F5 9F9F9F FFFFFF FFFFFF FFFFFF
        FFFFFF FFFFFF F6F6F6 A5A5A5 FFFFFF FFFFFF FFFFFF
        """, macos: """
        FFFFFF FFFFFF FFFFFF 6F6F6F FFFFFF FFFFFF FFFFFF
        FFFFFF FFFFFF FFFFFF 6F6F6F FFFFFF FFFFFF FFFFFF
        FFFFFF FFFFFF FFFFFF 6F6F6F FFFFFF FFFFFF FFFFFF
        FFFFFF FFFFFF FFFFFF 6F6F6F FFFFFF FFFFFF FFFFFF
        FFFFFF FFFFFF FFFFFF 6F6F6F FFFFFF FFFFFF FFFFFF
        FFFFFF FFFFFF FFFFFF 6F6F6F FFFFFF FFFFFF FFFFFF
        FFFFFF FFFFFF FFFFFF 6F6F6F FFFFFF FFFFFF FFFFFF
        FFFFFF FFFFFF FFFFFF 747474 FFFFFF FFFFFF FFFFFF
        """, android: """
        FFFFFF FFFFFF FFFFFF FFFFFF FFFFFF FFFFFF FFFFFF
        FFFFFF FFFFFF FFFFFF FFFFFF FFFFFF FFFFFF FFFFFF
        FFFFFF FFFFFF FFFFFF A9A9A9 FFFFFF FFFFFF FFFFFF
        FFFFFF FFFFFF FFFFFF A1A1A1 FFFFFF FFFFFF FFFFFF
        FFFFFF FFFFFF FFFFFF A1A1A1 FFFFFF FFFFFF FFFFFF
        FFFFFF FFFFFF FFFFFF A1A1A1 FFFFFF FFFFFF FFFFFF
        FFFFFF FFFFFF FFFFFF AAAAAA FFFFFF FFFFFF FFFFFF
        FFFFFF FFFFFF FFFFFF FFFFFF FFFFFF FFFFFF FFFFFF
        """))
    }

    func testDrawTextDefaultFont() throws {
        XCTAssertEqual(try render(compact: false, view: ZStack {
            Text("T").foregroundColor(Color.white)
        }.background(Color.black)),
        plaf("""
        000000 000000 000000 000000 000000 000000 000000 000000 000000 000000 000000
        000000 000000 000000 000000 000000 000000 000000 000000 000000 000000 000000
        000000 000000 000000 000000 000000 000000 000000 000000 000000 000000 000000
        000000 000000 000000 000000 000000 000000 000000 000000 000000 000000 000000
        0A0A0A B1B1B1 CECECE CDCDCD C9C9C9 C2C2C2 CBCBCB CDCDCD CFCFCF 919191 000000
        070707 797979 8C8C8C 8A8A8A B3B3B3 FFFFFF 9F9F9F 8B8B8B 8D8D8D 646464 000000
        000000 000000 000000 000000 4A4A4A FCFCFC 1D1D1D 000000 000000 000000 000000
        000000 000000 000000 000000 515151 FCFCFC 262626 000000 000000 000000 000000
        000000 000000 000000 000000 515151 FCFCFC 262626 000000 000000 000000 000000
        000000 000000 000000 000000 515151 FCFCFC 262626 000000 000000 000000 000000
        000000 000000 000000 000000 515151 FCFCFC 262626 000000 000000 000000 000000
        000000 000000 000000 000000 515151 FCFCFC 262626 000000 000000 000000 000000
        000000 000000 000000 000000 515151 FCFCFC 262626 000000 000000 000000 000000
        000000 000000 000000 000000 515151 FCFCFC 262626 000000 000000 000000 000000
        000000 000000 000000 000000 535353 FFFFFF 272727 000000 000000 000000 000000
        000000 000000 000000 000000 414141 CBCBCB 1F1F1F 000000 000000 000000 000000
        000000 000000 000000 000000 000000 000000 000000 000000 000000 000000 000000
        000000 000000 000000 000000 000000 000000 000000 000000 000000 000000 000000
        000000 000000 000000 000000 000000 000000 000000 000000 000000 000000 000000
        000000 000000 000000 000000 000000 000000 000000 000000 000000 000000 000000
        000000 000000 000000 000000 000000 000000 000000 000000 000000 000000 000000
        """, macos: """
        000000 000000 000000 000000 000000 000000 000000 000000 000000
        000000 000000 000000 000000 000000 000000 000000 000000 000000
        000000 000000 000000 000000 000000 000000 000000 000000 000000
        535353 929292 929292 929292 929292 929292 929292 767676 000000
        8F8F8F F6F6F6 F6F6F6 FFFFFF FFFFFF F6F6F6 F6F6F6 C9C9C9 000000
        000000 000000 000000 A8A8A8 E5E5E5 000000 000000 000000 000000
        000000 000000 000000 A8A8A8 E5E5E5 000000 000000 000000 000000
        000000 000000 000000 A8A8A8 E5E5E5 000000 000000 000000 000000
        000000 000000 000000 A8A8A8 E5E5E5 000000 000000 000000 000000
        000000 000000 000000 A8A8A8 E5E5E5 000000 000000 000000 000000
        000000 000000 000000 A8A8A8 E5E5E5 000000 000000 000000 000000
        000000 000000 000000 A8A8A8 E5E5E5 000000 000000 000000 000000
        000000 000000 000000 A2A2A2 E0E0E0 000000 000000 000000 000000
        000000 000000 000000 000000 000000 000000 000000 000000 000000
        000000 000000 000000 000000 000000 000000 000000 000000 000000
        000000 000000 000000 000000 000000 000000 000000 000000 000000
        """, android: """
        000000 000000 000000 000000 000000 000000 000000 000000
        000000 000000 000000 000000 000000 000000 000000 000000
        000000 000000 000000 000000 000000 000000 000000 000000
        000000 000000 000000 000000 000000 000000 000000 000000
        000000 000000 000000 000000 000000 000000 000000 000000
        B6B6B6 F7F7F7 F7F7F7 F7F7F7 F7F7F7 F7F7F7 F7F7F7 F7F7F7
        2A2A2A 393939 393939 A3A3A3 E3E3E3 393939 393939 393939
        000000 000000 000000 949494 DFDFDF 000000 000000 000000
        000000 000000 000000 949494 DFDFDF 000000 000000 000000
        000000 000000 000000 949494 DFDFDF 000000 000000 000000
        000000 000000 000000 949494 DFDFDF 000000 000000 000000
        000000 000000 000000 949494 DFDFDF 000000 000000 000000
        000000 000000 000000 949494 DFDFDF 000000 000000 000000
        000000 000000 000000 949494 DFDFDF 000000 000000 000000
        000000 000000 000000 949494 DFDFDF 000000 000000 000000
        000000 000000 000000 000000 000000 000000 000000 000000
        000000 000000 000000 000000 000000 000000 000000 000000
        000000 000000 000000 000000 000000 000000 000000 000000
        000000 000000 000000 000000 000000 000000 000000 000000
        """))
    }

    func testDrawTextMonospacedFont() throws {
        XCTAssertEqual(try render(compact: false, antiAlias: false, view: ZStack {
            Text("T").font(Font.custom("courier", size: CGFloat(8.0))).foregroundColor(Color.black)
        }.frame(width: 8.0, height: 8.0).background(Color.white)),
        plaf("""
        FFFFFF FFFFFF FFFFFF FFFFFF FFFFFF FFFFFF FFFFFF FFFFFF
        FFFFFF FFFFFF E2E2E2 9C9C9C 9B9B9B A1A1A1 F0F0F0 FFFFFF
        FFFFFF FFFFFF A9A9A9 8D8D8D 737373 878787 C8C8C8 FFFFFF
        FFFFFF FFFFFF E0E0E0 E0E0E0 8E8E8E E5E5E5 E9E9E9 FFFFFF
        FFFFFF FFFFFF FFFFFF F4F4F4 828282 FFFFFF FFFFFF FFFFFF
        FFFFFF FFFFFF FFFFFF A8A8A8 5A5A5A BFBFBF FFFFFF FFFFFF
        FFFFFF FFFFFF FFFFFF FAFAFA FBFBFB FAFAFA FFFFFF FFFFFF
        FFFFFF FFFFFF FFFFFF FFFFFF FFFFFF FFFFFF FFFFFF FFFFFF
        """, macos: """
        FFFFFF FFFFFF FFFFFF FFFFFF FFFFFF FFFFFF FFFFFF FFFFFF
        FFFFFF FFFFFF 5F5F5F 505050 181818 404040 929292 FFFFFF
        FFFFFF FFFFFF 565656 FFFFFF 4D4D4D CFCFCF 878787 FFFFFF
        FFFFFF FFFFFF DFDFDF FFFFFF 4D4D4D F9F9F9 E5E5E5 FFFFFF
        FFFFFF FFFFFF FFFFFF FFFFFF 4D4D4D FFFFFF FFFFFF FFFFFF
        FFFFFF FFFFFF FFFFFF 5E5E5E 191919 7F7F7F FFFFFF FFFFFF
        FFFFFF FFFFFF FFFFFF FFFFFF FFFFFF FFFFFF FFFFFF FFFFFF
        FFFFFF FFFFFF FFFFFF FFFFFF FFFFFF FFFFFF FFFFFF FFFFFF
        """, android: """
        FFFFFF FFFFFF FFFFFF FFFFFF FFFFFF FFFFFF FFFFFF FFFFFF
        FFFFFF FFFFFF FFFFFF FFFFFF FFFFFF FFFFFF FFFFFF FFFFFF
        FFFFFF FFFFFF FFFFFF FFFFFF FFFFFF FFFFFF FFFFFF FFFFFF
        FFFFFF FFFFFF 979797 000000 000000 000000 B9B9B9 FFFFFF
        FFFFFF FFFFFF B6B6B6 FFFFFF B6B6B6 FEFEFE B7B7B7 FFFFFF
        FFFFFF FFFFFF F8F8F8 FFFFFF B6B6B6 FFFFFF F8F8F8 FFFFFF
        FFFFFF FFFFFF FFFFFF 404040 000000 707070 FFFFFF FFFFFF
        FFFFFF FFFFFF FFFFFF FFFFFF FFFFFF FFFFFF FFFFFF FFFFFF
        """))
    }


    func testZStackSquareCenterInset() throws {
        XCTAssertEqual(try render(compact: true, view: ZStack {
            Color.black.frame(width: 12.0, height: 12.0)
            Color.white.frame(width: 4.0, height: 4.0)
        }),
        plaf("""
        0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 F F F F 0 0 0 0
        0 0 0 0 F F F F 0 0 0 0
        0 0 0 0 F F F F 0 0 0 0
        0 0 0 0 F F F F 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0
        """))
    }

    func testZStackOpacityOverlay() throws {
        XCTAssertEqual(try render(compact: true, view: ZStack {
            Color.black.frame(width: 12.0, height: 12.0)
            Color.white.opacity(0.6).frame(width: 6.0, height: 6.0)
        }),
        plaf("""
        0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 9 9 9 9 9 9 0 0 0
        0 0 0 9 9 9 9 9 9 0 0 0
        0 0 0 9 9 9 9 9 9 0 0 0
        0 0 0 9 9 9 9 9 9 0 0 0
        0 0 0 9 9 9 9 9 9 0 0 0
        0 0 0 9 9 9 9 9 9 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0
        """))
    }

    func testZStackMultiOpacityOverlay() throws {
        XCTAssertEqual(try render(compact: true, view: ZStack {
            Color.black.frame(width: 12.0, height: 12.0)
            Color.white.opacity(0.8).frame(width: 8.0, height: 8.0)
            Color.black.opacity(0.5).frame(width: 4.0, height: 4.0)
            Color.white.opacity(0.22).frame(width: 2.0, height: 2.0)
        }),
        plaf("""
        0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0
        0 0 C C C C C C C C 0 0
        0 0 C C C C C C C C 0 0
        0 0 C C 6 6 6 6 C C 0 0
        0 0 C C 6 8 8 6 C C 0 0
        0 0 C C 6 8 8 6 C C 0 0
        0 0 C C 6 6 6 6 C C 0 0
        0 0 C C C C C C C C 0 0
        0 0 C C C C C C C C 0 0
        0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0
        """))
    }

    func testZStackSquareBottomTrailing() throws {
        XCTAssertEqual(try render(outputFile: "/tmp/SKipUITests-testZStackSquareBottomTrailing", compact: true, view: ZStack(alignment: .bottomTrailing) {
            Color.black.frame(width: 12.0, height: 12.0)
            Color.white.frame(width: 6.0, height: 6.0)
        }),
        plaf("""
        0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 F F F F F F
        0 0 0 0 0 0 F F F F F F
        0 0 0 0 0 0 F F F F F F
        0 0 0 0 0 0 F F F F F F
        0 0 0 0 0 0 F F F F F F
        0 0 0 0 0 0 F F F F F F
        """))
    }

    func testZStackSquareTopLeading() throws {
        XCTAssertEqual(try render(compact: true, view: ZStack(alignment: .topLeading) {
            Color.black.frame(width: 12.0, height: 12.0)
            Color.white.frame(width: 6.0, height: 6.0)
        }),
        plaf("""
        F F F F F F 0 0 0 0 0 0
        F F F F F F 0 0 0 0 0 0
        F F F F F F 0 0 0 0 0 0
        F F F F F F 0 0 0 0 0 0
        F F F F F F 0 0 0 0 0 0
        F F F F F F 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0
        """))
    }

    func testZStackSquareTop() throws {
        XCTAssertEqual(try render(compact: true, view: ZStack(alignment: .top) {
            Color.black.frame(width: 12.0, height: 12.0)
            Color.white.frame(width: 6.0, height: 6.0)
        }),
        plaf("""
        0 0 0 F F F F F F 0 0 0
        0 0 0 F F F F F F 0 0 0
        0 0 0 F F F F F F 0 0 0
        0 0 0 F F F F F F 0 0 0
        0 0 0 F F F F F F 0 0 0
        0 0 0 F F F F F F 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0
        """))
    }

    func testZStackSquareTrailing() throws {
        XCTAssertEqual(try render(compact: true, view: ZStack(alignment: .trailing) {
            Color.black.frame(width: 12.0, height: 12.0)
            Color.white.frame(width: 6.0, height: 6.0)
        }),
        plaf("""
        0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 F F F F F F
        0 0 0 0 0 0 F F F F F F
        0 0 0 0 0 0 F F F F F F
        0 0 0 0 0 0 F F F F F F
        0 0 0 0 0 0 F F F F F F
        0 0 0 0 0 0 F F F F F F
        0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0
        """))
    }

    func testRenderStacks() throws {
        XCTAssertEqual(try render(outputFile: "/tmp/SKipUITests-testRenderStacks", compact: true, view: VStack(spacing: 0.0) {
            HStack(spacing: 0.0) {
                VStack(spacing: 0.0) {
                    (Color.black).frame(width: 1.0, height: 2.0)
                    (Color.white).frame(width: 1.0, height: 1.0)
                }
                (Color.white).frame(width: 6.0, height: 3.0)
                (Color.black).frame(width: 5.0, height: 3.0)
            }
            HStack(spacing: 0.0) {
                (Color.black).frame(width: 3.0, height: 9.0)
                (Color.white).frame(width: 9.0, height: 9.0)
            }
        }
        .frame(width: 12.0, height: 12.0)), plaf("""
        0 F F F F F F 0 0 0 0 0
        0 F F F F F F 0 0 0 0 0
        F F F F F F F 0 0 0 0 0
        0 0 0 F F F F F F F F F
        0 0 0 F F F F F F F F F
        0 0 0 F F F F F F F F F
        0 0 0 F F F F F F F F F
        0 0 0 F F F F F F F F F
        0 0 0 F F F F F F F F F
        0 0 0 F F F F F F F F F
        0 0 0 F F F F F F F F F
        0 0 0 F F F F F F F F F
        """))
    }

    func testRenderCustomCanvas() throws {
        #if !SKIP
        throw XCTSkip("Android-only function")
        #else
        XCTAssertEqual(try render(outputFile: "/tmp/SKipUITests-testRenderCustomCanvas", compact: true, view: ComposeView(content: { ctx in
            androidx.compose.foundation.layout.Box(modifier: Modifier.size(12.dp).background(androidx.compose.ui.graphics.Color.White), contentAlignment: androidx.compose.ui.Alignment.Center) {
                androidx.compose.foundation.layout.Box(modifier: Modifier.size(6.dp, 6.dp).background(androidx.compose.ui.graphics.Color.Black))
            }
        })),
        plaf("""
        F F F F F F F F F F F F
        F F F F F F F F F F F F
        F F F F F F F F F F F F
        F F F 0 0 0 0 0 0 F F F
        F F F 0 0 0 0 0 0 F F F
        F F F 0 0 0 0 0 0 F F F
        F F F 0 0 0 0 0 0 F F F
        F F F 0 0 0 0 0 0 F F F
        F F F 0 0 0 0 0 0 F F F
        F F F F F F F F F F F F
        F F F F F F F F F F F F
        F F F F F F F F F F F F
        """))
        #endif
    }

    /// Renders the given SwiftUI view as an ASCII string representing the shapes and colors in the view.
    /// The optional `outputFile` can be specified to save a PNG form of the view to the given file.
    /// This function handles the three separate scenarios of iOS (UIKit), macOS (AppKit), and Android (SkipKit), which all have different mechanisms for converting a view into a bitmap image.
    func render<V: View>(outputFile: String? = nil, compact: Bool = false, darkMode: Bool = false, antiAlias: Bool? = false, view content: V) throws -> String {
        #if SKIP
        // SKIP INSERT: lateinit
        var renderView: android.view.View
        composeRule.setContent {
            // render the compose view to the canvas
            renderView = LocalView.current
            let ctx = ComposeContext()
            view.Compose(ctx)
        }

        // https://github.com/robolectric/robolectric/issues/8071 — cannot use captureToImage from Robolectric
        // androidx.compose.ui.test.ComposeTimeoutException: Condition still not satisfied after 2000 ms
        // runBlocking { onRoot().captureToImage().asAndroidBitmap() }

        let width = renderView.width
        let height = renderView.height

        // draw the view onto a canvas
        let bitmap = android.graphics.Bitmap.createBitmap(width, height, android.graphics.Bitmap.Config.ARGB_8888)
        let bitmapCanvas = android.graphics.Canvas(bitmap)

        let paint = androidx.compose.ui.graphics.Paint().asFrameworkPaint()
        if let antiAlias = antiAlias {
            // doesn't seem to work
            paint.isAntiAlias = antiAlias
            paint.isFilterBitmap = antiAlias
        }
        bitmapCanvas.drawPaint(paint)

        renderView.draw(bitmapCanvas) // perform the draw

        //bitmapCanvas.drawColor(android.graphics.Color.WHITE)

        // TODO: remove this debugging gray square overlay
        //bitmapCanvas.drawRect(Float(3.0), Float(3.0), Float(width) - Float(4.0), Float(height) - Float(4.0), android.graphics.Paint().apply {
        //    color = android.graphics.Color.GRAY
        //    style = android.graphics.Paint.Style.FILL
        //})

        if let outputFile = outputFile {
            // save to the specified output file base
            let out = java.io.FileOutputStream(outputFile + "-android.png")
            bitmap.compress(android.graphics.Bitmap.CompressFormat.PNG, 100, out)
            out.close()
        }

        var pixels = IntArray(width * height)
        bitmap.getPixels(pixels, 0, width, 0, 0, width, height)
        return createPixmap(pixels: Array(pixels.toList()), compact: compact, width: Int64(width))

        #else

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

        #if canImport(UIKit) // i.e., iOS

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
            if let antiAlias = antiAlias, let context = UIGraphicsGetCurrentContext() {
                context.setShouldAntialias(antiAlias)
                context.setAllowsAntialiasing(antiAlias)
            }
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
        let bytesPerRow = cgImage.bytesPerRow

        #elseif canImport(AppKit) // i.e., macOS

        view.needsDisplay = true
        view.needsLayout = true

        let scaledSize = bounds.size

        guard let bitmap = NSBitmapImageRep(bitmapDataPlanes: nil, pixelsWide: Int(scaledSize.width), pixelsHigh: Int(scaledSize.height), bitsPerSample: 8, samplesPerPixel: 4, hasAlpha: true, isPlanar: false, colorSpaceName: .deviceRGB, bytesPerRow: 0, bitsPerPixel: 0) else {
            throw RenderViewError(errorDescription: "cannot create bitmap")
        }

        //view.draw(bounds) // always just a white square

        // manually specifying antiAlias will wrap the view in a containing view
        if let antiAlias = antiAlias {
            AliasView(frame: view.bounds, containing: view, antiAlias: antiAlias).cacheDisplay(in: bounds, to: bitmap)
        } else {
            view.cacheDisplay(in: bounds, to: bitmap)
        }

        // save PNG to the output file base if specified
        if let outputFile = outputFile, let data = bitmap.representation(using: .png, properties: [:]) {
            try data.write(to: URL(fileURLWithPath: outputFile + "-macos.png", isDirectory: false))
        }

        let pixelData = bitmap.bitmapData
        let bytesPerPixel = bitmap.bitsPerPixel / bitmap.bitsPerSample
        let bytesPerRow = bitmap.bytesPerRow

        #endif // canImport(AppKit)

        return createPixmapFromColors(pixelData: UnsafePointer(pixelData), compact: compact, width: Int(viewSize.width), height: Int(viewSize.height), bytesPerRow: bytesPerRow, bytesPerPixel: bytesPerPixel)

        #endif
    }

    #if canImport(AppKit)
    /// A view that renders its subviews with anti-aliasing explicitly enabled or diabled.
    class AliasView : NSView {
        let antiAlias: Bool?

        init(frame: NSRect, containing subview: NSView, antiAlias: Bool?) {
            self.antiAlias = antiAlias
            super.init(frame: frame)
            addSubview(subview)
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) unavailable")
        }
        
        override func draw(_ dirtyRect: NSRect) {
            guard let ctx = NSGraphicsContext.current?.cgContext else { return }
            if let antiAlias = antiAlias {
                ctx.setShouldAntialias(antiAlias)
                ctx.setAllowsAntialiasing(antiAlias)
            }

            super.draw(dirtyRect)
        }
    }
    #endif

    /// Creates an ASCII representation of an array of pixels, averaging each color into one of 26 letters
    private func createPixmap(pixels: [Int], compact: Bool, width: Int64) -> String {
        func rgb(_ packedColor: Int) -> String {
            let red = (packedColor >> 16) & 0xFF
            let green = (packedColor >> 8) & 0xFF
            let blue = packedColor & 0xFF
            let fmt = "%02X%02X%02X"

            #if SKIP
            let rgb = fmt.format(red, green, blue)
            #else
            let rgb = String(format: fmt, red, green, blue)
            #endif

            if compact {
                #if SKIP
                return rgb.toCharArray().toSet().sorted().joinToString("")
                #else
                return String(Set(rgb).sorted())
                #endif
            } else {
                return rgb
            }
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

    struct CannotAccessCGImage : Error { }
    struct CannotCreateBitmap : Error { }

    public struct RenderViewError : LocalizedError {
        public var errorDescription: String?
    }

    #if !SKIP
    private func createPixmapFromColors(pixelData: UnsafePointer<UInt8>!, compact: Bool, width: Int, height: Int, bytesPerRow: Int, bytesPerPixel: Int) -> String {
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
                let rgb = String(format: "%02X%02X%02X", red, green, blue)
                if compact {
                    pdesc += String(Set(rgb).sorted())
                } else {
                    pdesc += rgb
                }
            }
        }
        return pdesc
    }
    #endif
}

extension Sequence where Element == UInt8 {
    /// Convert this sequence of bytes into a hex string
    func hex() -> String { map { String(format: "%02x", $0) }.joined() }
}
