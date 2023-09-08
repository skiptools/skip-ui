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
final class CanvasTests: XCSnapshotTestCase {
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
}
