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

// SKIP INSERT:
// import androidx.compose.foundation.ExperimentalFoundationApi
// import androidx.compose.foundation.background
// import androidx.compose.foundation.border
// import androidx.compose.foundation.interaction.FocusInteraction
// import androidx.compose.foundation.interaction.Interaction
// import androidx.compose.foundation.interaction.MutableInteractionSource
// import androidx.compose.foundation.layout.Box
// import androidx.compose.foundation.layout.Column
// import androidx.compose.foundation.layout.IntrinsicSize
// import androidx.compose.foundation.layout.Row
// import androidx.compose.foundation.layout.Spacer
// import androidx.compose.foundation.layout.fillMaxHeight
// import androidx.compose.foundation.layout.fillMaxSize
// import androidx.compose.foundation.layout.fillMaxWidth
// import androidx.compose.foundation.layout.height
// import androidx.compose.foundation.layout.padding
// import androidx.compose.foundation.layout.requiredHeight
// import androidx.compose.foundation.layout.size
// import androidx.compose.foundation.layout.width
// import androidx.compose.foundation.layout.wrapContentSize

// SKIP INSERT:
// import androidx.compose.material3.Text
// import androidx.compose.material3.Button

// SKIP INSERT:
// import androidx.compose.runtime.Composable
// import androidx.compose.runtime.CompositionLocalProvider
// import androidx.compose.runtime.MutableState
// import androidx.compose.runtime.getValue
// import androidx.compose.runtime.mutableStateOf
// import androidx.compose.runtime.remember
// import androidx.compose.runtime.rememberCoroutineScope
// import androidx.compose.runtime.saveable.rememberSaveable
// import androidx.compose.runtime.setValue

// SKIP INSERT:
// import androidx.compose.ui.Modifier
// import androidx.compose.ui.draw.drawBehind
// import androidx.compose.ui.focus.onFocusChanged
// import androidx.compose.ui.geometry.Offset
// import androidx.compose.ui.geometry.Rect
// import androidx.compose.ui.graphics.ImageBitmap
// import androidx.compose.ui.graphics.RectangleShape
// import androidx.compose.ui.graphics.Shadow
// import androidx.compose.ui.graphics.SolidColor
// import androidx.compose.ui.graphics.toPixelMap
// import androidx.compose.ui.graphics.drawscope.drawIntoCanvas
// import androidx.compose.ui.graphics.nativeCanvas
// import androidx.compose.ui.graphics.drawscope.drawIntoCanvas

// SKIP INSERT:
// import androidx.compose.ui.input.key.KeyEvent
// import androidx.compose.ui.input.key.NativeKeyEvent
// import androidx.compose.ui.layout.onGloballyPositioned

// SKIP INSERT:
// import androidx.compose.ui.text.AnnotatedString
// import androidx.compose.ui.text.ExperimentalTextApi
// import androidx.compose.ui.text.ParagraphStyle
// import androidx.compose.ui.text.SpanStyle
// import androidx.compose.ui.text.TextLayoutResult
// import androidx.compose.ui.text.TextRange
// import androidx.compose.ui.text.TextStyle
// import androidx.compose.ui.text.UrlAnnotation
// import androidx.compose.ui.text.VerbatimTtsAnnotation
// import androidx.compose.ui.text.buildAnnotatedString

// DO NOT IMPORT! conflicts with SwiftUI.Font
// SKIP INSERT: //import androidx.compose.ui.text.font.Font

// SKIP INSERT:
// import androidx.compose.ui.text.font.FontStyle
// import androidx.compose.ui.text.font.FontSynthesis
// import androidx.compose.ui.text.font.FontWeight
// import androidx.compose.ui.text.font.toFontFamily
// import androidx.compose.ui.text.input.CommitTextCommand
// import androidx.compose.ui.text.input.EditCommand
// import androidx.compose.ui.text.input.ImeAction
// import androidx.compose.ui.text.input.OffsetMapping
// import androidx.compose.ui.text.input.PasswordVisualTransformation
// import androidx.compose.ui.text.input.PlatformTextInputService
// import androidx.compose.ui.text.input.TextFieldValue
// import androidx.compose.ui.text.input.TextFieldValue.Companion.Saver
// import androidx.compose.ui.text.input.TextInputService
// import androidx.compose.ui.text.input.TransformedText
// import androidx.compose.ui.text.intl.Locale
// import androidx.compose.ui.text.intl.LocaleList
// import androidx.compose.ui.text.style.BaselineShift
// import androidx.compose.ui.text.style.TextAlign
// import androidx.compose.ui.text.style.TextDecoration
// import androidx.compose.ui.text.style.TextDirection
// import androidx.compose.ui.text.style.TextGeometricTransform
// import androidx.compose.ui.text.style.TextIndent
// import androidx.compose.ui.text.toUpperCase
// import androidx.compose.ui.text.withAnnotation
// import androidx.compose.ui.text.withStyle

// SKIP INSERT:
// import androidx.compose.ui.unit.Density
// import androidx.compose.ui.unit.IntSize
// import androidx.compose.ui.unit.toSize
// import androidx.compose.ui.unit.dp
// import androidx.compose.ui.unit.em
// import androidx.compose.ui.unit.sp

// SKIP INSERT:
// import androidx.compose.ui.platform.ComposeView
// import androidx.compose.ui.platform.LocalDensity
// import androidx.compose.ui.platform.LocalFocusManager
// import androidx.compose.ui.platform.LocalFontFamilyResolver
// import androidx.compose.ui.platform.LocalTextInputService
// import androidx.compose.ui.platform.LocalTextToolbar
// import androidx.compose.ui.platform.LocalView
// import androidx.compose.ui.platform.TextToolbar
// import androidx.compose.ui.platform.TextToolbarStatus
// import androidx.compose.ui.platform.testTag
// import androidx.compose.ui.semantics.SemanticsActions
// import androidx.compose.ui.semantics.SemanticsNode
// import androidx.compose.ui.semantics.SemanticsConfiguration
// import androidx.compose.ui.semantics.SemanticsProperties
// import androidx.compose.ui.semantics.getOrNull
// import androidx.compose.ui.test.ExperimentalTestApi
// import androidx.compose.ui.test.SemanticsMatcher
// import androidx.compose.ui.test.SemanticsNodeInteraction
// import androidx.compose.ui.test.assert
// import androidx.compose.ui.test.assertHasClickAction
// import androidx.compose.ui.test.assertIsFocused
// import androidx.compose.ui.test.assertTextEquals
// import androidx.compose.ui.test.captureToImage
// import androidx.compose.ui.test.click
// import androidx.compose.ui.test.hasText
// import androidx.compose.ui.test.hasImeAction
// import androidx.compose.ui.test.hasSetTextAction
// import androidx.compose.ui.test.isFocused
// import androidx.compose.ui.test.isNotFocused
// import androidx.compose.ui.test.junit4.StateRestorationTester
// import androidx.compose.ui.test.junit4.createComposeRule
// import androidx.compose.ui.test.junit4.ComposeContentTestRule
// import androidx.compose.ui.test.longClick
// import androidx.compose.ui.test.assertIsDisplayed
// import androidx.compose.ui.test.onNodeWithTag
// import androidx.compose.ui.test.onNodeWithText
// import androidx.compose.ui.test.performClick
// import androidx.compose.ui.test.onRoot
// import androidx.compose.ui.test.printToLog
// import androidx.compose.ui.test.performImeAction
// import androidx.compose.ui.test.performKeyPress
// import androidx.compose.ui.test.performSemanticsAction
// import androidx.compose.ui.test.performTextClearance
// import androidx.compose.ui.test.performTextInput
// import androidx.compose.ui.test.performTextInputSelection
// import androidx.compose.ui.test.performTouchInput
// import androidx.compose.ui.test.performGesture
// import androidx.compose.ui.test.*

// SKIP INSERT:
// import androidx.compose.ui.graphics.asAndroidBitmap
// import androidx.test.ext.junit.runners.AndroidJUnit4

// SKIP INSERT:
// import kotlin.test.assertFailsWith
// import kotlinx.coroutines.CoroutineScope
// import kotlinx.coroutines.launch

// SKIP INSERT:
// import org.junit.Ignore
// import org.junit.Rule
// import org.junit.Test

// SKIP INSERT:
// import kotlinx.coroutines.runBlocking

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
        XCTAssertEqual("0", try render(compact: 1, view: Color.black.frame(width: 1.0, height: 1.0)))
    }

    func testColorWhiteCompact() throws {
        XCTAssertEqual("F", try render(compact: 1, view: Color.white.frame(width: 1.0, height: 1.0)))
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
        XCTAssertEqual(try render(compact: 1, view: ComposeView(content: { ctx in
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
        XCTAssertEqual(try render(compact: 1, view: Color.white.frame(width: 2.0, height: 2.0)),
        plaf("""
        F F
        F F
        """))
    }

    func testRenderWhiteSquare() throws {
        XCTAssertEqual(try render(compact: 1, view: Color.white.frame(width: 4.0, height: 4.0)),
        plaf("""
        F F F F
        F F F F
        F F F F
        F F F F
        """))
    }

    func testRenderWhiteSquareBig() throws {
        XCTAssertEqual(try render(compact: 1, view: Color.white.frame(width: 12.0, height: 12.0)),
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
        XCTAssertEqual(try render(compact: 1, view: ZStack {
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
        XCTAssertEqual(try render(compact: 2, antiAlias: true, view: ZStack {
            Color.black.frame(width: 12.0, height: 12.0)
            Color.white.frame(width: 6.0, height: 6.0).rotationEffect(Angle.degrees(45.0))
        }),
        plaf("""
        00 00 00 00 00 00 00 00 00 00 00 00
        00 00 00 00 00 07 07 00 00 00 00 00
        00 00 00 00 07 B6 B6 07 00 00 00 00
        00 00 00 07 B6 FF FF B6 07 00 00 00
        00 00 07 B6 FF FF FF FF B6 07 00 00
        00 07 B6 FF FF FF FF FF FF B6 07 00
        00 07 B6 FF FF FF FF FF FF B6 07 00
        00 00 07 B6 FF FF FF FF B6 07 00 00
        00 00 00 07 B6 FF FF B6 07 00 00 00
        00 00 00 00 07 B6 B6 07 00 00 00 00
        00 00 00 00 00 07 07 00 00 00 00 00
        00 00 00 00 00 00 00 00 00 00 00 00
        """, android: """
        00 00 00 00 00 00 00 00 00 00 00 00
        00 00 00 00 00 00 00 00 00 00 00 00
        00 00 00 00 00 A0 9F 00 00 00 00 00
        00 00 00 00 A0 FF FF 9F 00 00 00 00
        00 00 00 A0 FF FF FF FF 9F 00 00 00
        00 00 A0 FF FF FF FF FF FF 9F 00 00
        00 00 A0 FF FF FF FF FF FF A0 00 00
        00 00 00 A0 FF FF FF FF A0 00 00 00
        00 00 00 00 A0 FF FF A0 00 00 00 00
        00 00 00 00 00 A0 A0 00 00 00 00 00
        00 00 00 00 00 00 00 00 00 00 00 00
        00 00 00 00 00 00 00 00 00 00 00 00
        """))
    }

    func testRotatedSquare() throws {
        // aliasing effect of a rotated shape is slightly different on Android and iOS so disable
        // TODO: anti-aliasing on Android doesn't yet work
        XCTAssertEqual(try render(compact: 2, antiAlias: false, view: ZStack {
            Color.black.frame(width: 12.0, height: 12.0)
            Color.white.frame(width: 6.0, height: 6.0).rotationEffect(Angle.degrees(45.0))
        }),
        plaf("""
        00 00 00 00 00 00 00 00 00 00 00 00
        00 00 00 00 00 FF FF 00 00 00 00 00
        00 00 00 00 FF FF FF FF 00 00 00 00
        00 00 00 FF FF FF FF FF FF 00 00 00
        00 00 FF FF FF FF FF FF FF FF 00 00
        00 FF FF FF FF FF FF FF FF FF FF 00
        00 FF FF FF FF FF FF FF FF FF FF 00
        00 00 FF FF FF FF FF FF FF FF 00 00
        00 00 00 FF FF FF FF FF FF 00 00 00
        00 00 00 00 FF FF FF FF 00 00 00 00
        00 00 00 00 00 FF FF 00 00 00 00 00
        00 00 00 00 00 00 00 00 00 00 00 00
        """, android: """
        00 00 00 00 00 00 00 00 00 00 00 00
        00 00 00 00 00 00 00 00 00 00 00 00
        00 00 00 00 00 A0 9F 00 00 00 00 00
        00 00 00 00 A0 FF FF 9F 00 00 00 00
        00 00 00 A0 FF FF FF FF 9F 00 00 00
        00 00 A0 FF FF FF FF FF FF 9F 00 00
        00 00 A0 FF FF FF FF FF FF A0 00 00
        00 00 00 A0 FF FF FF FF A0 00 00 00
        00 00 00 00 A0 FF FF A0 00 00 00 00
        00 00 00 00 00 A0 A0 00 00 00 00 00
        00 00 00 00 00 00 00 00 00 00 00 00
        00 00 00 00 00 00 00 00 00 00 00 00
        """))
    }

    func testDrawCourierBar() throws {
        XCTAssertEqual(try render(compact: 2, view: ZStack {
            Text("|").font(Font.custom("courier", size: CGFloat(8.0))).foregroundColor(Color.black)
        }.frame(width: 7.0, height: 8.0).background(Color.white)),
        plaf("""
        FF FF F5 9F FF FF FF
        FF FF F5 9F FF FF FF
        FF FF F5 9F FF FF FF
        FF FF F5 9F FF FF FF
        FF FF F5 9F FF FF FF
        FF FF F5 9F FF FF FF
        FF FF F5 9F FF FF FF
        FF FF F6 A5 FF FF FF
        """, macos: """
        FF FF FF 6F FF FF FF
        FF FF FF 6F FF FF FF
        FF FF FF 6F FF FF FF
        FF FF FF 6F FF FF FF
        FF FF FF 6F FF FF FF
        FF FF FF 6F FF FF FF
        FF FF FF 6F FF FF FF
        FF FF FF 74 FF FF FF
        """, android: """
        FF FF FF FF FF FF FF
        FF FF FF FF FF FF FF
        FF FF FF A9 FF FF FF
        FF FF FF A1 FF FF FF
        FF FF FF A1 FF FF FF
        FF FF FF A1 FF FF FF
        FF FF FF AA FF FF FF
        FF FF FF FF FF FF FF
        """))
    }

    func testDrawTextDefaultFont() throws {
        XCTAssertEqual(try render(compact: 2, view: ZStack {
            Text("T").foregroundColor(Color.white)
        }.background(Color.black)),
        plaf("""
        00 00 00 00 00 00 00 00 00 00 00
        00 00 00 00 00 00 00 00 00 00 00
        00 00 00 00 00 00 00 00 00 00 00
        00 00 00 00 00 00 00 00 00 00 00
        0A B1 CE CD C9 C2 CB CD CF 91 00
        07 79 8C 8A B3 FF 9F 8B 8D 64 00
        00 00 00 00 4A FC 1D 00 00 00 00
        00 00 00 00 51 FC 26 00 00 00 00
        00 00 00 00 51 FC 26 00 00 00 00
        00 00 00 00 51 FC 26 00 00 00 00
        00 00 00 00 51 FC 26 00 00 00 00
        00 00 00 00 51 FC 26 00 00 00 00
        00 00 00 00 51 FC 26 00 00 00 00
        00 00 00 00 51 FC 26 00 00 00 00
        00 00 00 00 53 FF 27 00 00 00 00
        00 00 00 00 41 CB 1F 00 00 00 00
        00 00 00 00 00 00 00 00 00 00 00
        00 00 00 00 00 00 00 00 00 00 00
        00 00 00 00 00 00 00 00 00 00 00
        00 00 00 00 00 00 00 00 00 00 00
        00 00 00 00 00 00 00 00 00 00 00
        """, macos: """
        00 00 00 00 00 00 00 00 00
        00 00 00 00 00 00 00 00 00
        00 00 00 00 00 00 00 00 00
        53 92 92 92 92 92 92 76 00
        8F F6 F6 FF FF F6 F6 C9 00
        00 00 00 A8 E5 00 00 00 00
        00 00 00 A8 E5 00 00 00 00
        00 00 00 A8 E5 00 00 00 00
        00 00 00 A8 E5 00 00 00 00
        00 00 00 A8 E5 00 00 00 00
        00 00 00 A8 E5 00 00 00 00
        00 00 00 A8 E5 00 00 00 00
        00 00 00 A2 E0 00 00 00 00
        00 00 00 00 00 00 00 00 00
        00 00 00 00 00 00 00 00 00
        00 00 00 00 00 00 00 00 00
        """, android: """
        00 00 00 00 00 00 00 00
        00 00 00 00 00 00 00 00
        00 00 00 00 00 00 00 00
        00 00 00 00 00 00 00 00
        00 00 00 00 00 00 00 00
        B6 F7 F7 F7 F7 F7 F7 F7
        2A 39 39 A3 E3 39 39 39
        00 00 00 94 DF 00 00 00
        00 00 00 94 DF 00 00 00
        00 00 00 94 DF 00 00 00
        00 00 00 94 DF 00 00 00
        00 00 00 94 DF 00 00 00
        00 00 00 94 DF 00 00 00
        00 00 00 94 DF 00 00 00
        00 00 00 94 DF 00 00 00
        00 00 00 00 00 00 00 00
        00 00 00 00 00 00 00 00
        00 00 00 00 00 00 00 00
        00 00 00 00 00 00 00 00
        """))
    }

    func testDrawTextMonospacedFont() throws {
        XCTAssertEqual(try render(compact: 2, antiAlias: false, view: ZStack {
            Text("T").font(Font.custom("courier", size: CGFloat(8.0))).foregroundColor(Color.black)
        }.frame(width: 8.0, height: 8.0).background(Color.white)),
        plaf("""
        FF FF FF FF FF FF FF FF
        FF FF E2 9C 9B A1 F0 FF
        FF FF A9 8D 73 87 C8 FF
        FF FF E0 E0 8E E5 E9 FF
        FF FF FF F4 82 FF FF FF
        FF FF FF A8 5A BF FF FF
        FF FF FF FA FB FA FF FF
        FF FF FF FF FF FF FF FF
        """, macos: """
        FF FF FF FF FF FF FF FF
        FF FF 5F 50 18 40 92 FF
        FF FF 56 FF 4D CF 87 FF
        FF FF DF FF 4D F9 E5 FF
        FF FF FF FF 4D FF FF FF
        FF FF FF 5E 19 7F FF FF
        FF FF FF FF FF FF FF FF
        FF FF FF FF FF FF FF FF
        """, android: """
        FF FF FF FF FF FF FF FF
        FF FF FF FF FF FF FF FF
        FF FF FF FF FF FF FF FF
        FF FF 97 00 00 00 B9 FF
        FF FF B6 FF B6 FE B7 FF
        FF FF F8 FF B6 FF F8 FF
        FF FF FF 40 00 70 FF FF
        FF FF FF FF FF FF FF FF
        """))
    }


    func testZStackSquareCenterInset() throws {
        XCTAssertEqual(try render(compact: 1, view: ZStack {
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
        XCTAssertEqual(try render(compact: 1, view: ZStack {
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
        XCTAssertEqual(try render(compact: 1, view: ZStack {
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
        XCTAssertEqual(try render(outputFile: "/tmp/SKipUITests-testZStackSquareBottomTrailing", compact: 1, view: ZStack(alignment: .bottomTrailing) {
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
        XCTAssertEqual(try render(compact: 1, view: ZStack(alignment: .topLeading) {
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
        XCTAssertEqual(try render(compact: 1, view: ZStack(alignment: .top) {
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
        XCTAssertEqual(try render(compact: 1, view: ZStack(alignment: .trailing) {
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
        XCTAssertEqual(try render(outputFile: "/tmp/SKipUITests-testRenderStacks", compact: 1, view: VStack(spacing: 0.0) {
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

    func testHStackAlignment() throws {
        // TODO: Android HStack Color elements do not seem to expand to fill the space
        XCTAssertEqual(try render(compact: 2, view: HStack(alignment: .bottom, spacing: 0.0) {
            Color.black.frame(height: 10.0)
            Color.white.opacity(0.8).frame(height: 12.0)
            Color.black.frame(height: 10.0)
        }.background(Color.white).frame(width: 12.0, height: 12.0)),
        plaf("""
        FF FF FF FF FF FF FF FF FF FF FF FF
        FF FF FF FF FF FF FF FF FF FF FF FF
        00 00 00 00 FF FF FF FF 00 00 00 00
        00 00 00 00 FF FF FF FF 00 00 00 00
        00 00 00 00 FF FF FF FF 00 00 00 00
        00 00 00 00 FF FF FF FF 00 00 00 00
        00 00 00 00 FF FF FF FF 00 00 00 00
        00 00 00 00 FF FF FF FF 00 00 00 00
        00 00 00 00 FF FF FF FF 00 00 00 00
        00 00 00 00 FF FF FF FF 00 00 00 00
        00 00 00 00 FF FF FF FF 00 00 00 00
        00 00 00 00 FF FF FF FF 00 00 00 00
        """, android: """
        FF FF FF FF FF FF FF FF FF FF FF FF
        FF FF FF FF FF FF FF FF FF FF FF FF
        FF FF FF FF FF FF FF FF FF FF FF FF
        FF FF FF FF FF FF FF FF FF FF FF FF
        FF FF FF FF FF FF FF FF FF FF FF FF
        FF FF FF FF FF FF FF FF FF FF FF FF
        FF FF FF FF FF FF FF FF FF FF FF FF
        FF FF FF FF FF FF FF FF FF FF FF FF
        FF FF FF FF FF FF FF FF FF FF FF FF
        FF FF FF FF FF FF FF FF FF FF FF FF
        FF FF FF FF FF FF FF FF FF FF FF FF
        FF FF FF FF FF FF FF FF FF FF FF FF
        """))
    }

    func testRenderCustomCanvas() throws {
        #if !SKIP
        throw XCTSkip("Android-only function")
        #else
        XCTAssertEqual(try render(outputFile: "/tmp/SKipUITests-testRenderCustomCanvas", compact: 1, view: ComposeView(content: { ctx in
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
    func render<V: View>(outputFile: String? = nil, compact: Int? = nil, darkMode: Bool = false, antiAlias: Bool? = false, view content: V) throws -> String {
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

    /// Creates an ASCII representation of an array of pixels
    private func createPixmap(pixels: [Int], compact: Int?, width: Int64) -> String {
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

            if let compact = compact {
                #if SKIP
                let parts = Set(rgb.toCharArray().toSet())
                #else
                let parts = Set(rgb)
                #endif
                if parts.count > compact {
                    return rgb // overflow will return the full string
                } else {
                    return rgb.dropLast(rgb.count - compact).description
                }
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
    private func createPixmapFromColors(pixelData: UnsafePointer<UInt8>!, compact: Int?, width: Int, height: Int, bytesPerRow: Int, bytesPerPixel: Int) -> String {
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
                if let compact = compact {
                    let parts = Set(rgb)
                    if parts.count > compact {
                        pdesc += rgb // overflow will return the full string
                    } else {
                        pdesc += String(rgb.dropLast(rgb.count - compact))
                    }
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
