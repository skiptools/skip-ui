// Copyright 2026 Skip
// SPDX-License-Identifier: MPL-2.0
import XCTest
import SwiftUI

#if SKIP
import androidx.compose.foundation.layout.MutableWindowInsets
import androidx.compose.foundation.layout.WindowInsets
import androidx.compose.ui.unit.Density
import androidx.compose.ui.unit.LayoutDirection

// SKIP INSERT: @OptIn(androidx.compose.foundation.layout.ExperimentalLayoutApi::class)
final class WindowKeyboardInsetsTests: XCTestCase {

    func testNewReaderAfterFocusLossSharesRetainedWindowInsets() {
        // Arrange
        let window = java.lang.Object()
        var isFocused = true
        let source = MutableWindowInsets(WindowInsets(bottom: 400))
        let existingReader = WindowKeyboardInsets(
            source: source,
            state: WindowKeyboardInsetsState.forWindow(window),
            isWindowFocused: { isFocused },
            isKeyboardVisible: { true }
        )
        let density = Density(density: Float(1.0))
        _ = existingReader.getBottom(density)

        // Act
        isFocused = false
        let newReader = WindowKeyboardInsets(
            source: source,
            state: WindowKeyboardInsetsState.forWindow(window),
            isWindowFocused: { isFocused },
            isKeyboardVisible: { true }
        )
        let retained = existingReader.getBottom(density)
        let newlyComposed = newReader.getBottom(density)

        // Assert
        XCTAssertEqual(retained, 400)
        XCTAssertEqual(newlyComposed, retained)
    }

    func testSharedReadersFollowKeyboardDismissalAfterFocusLoss() {
        // Arrange
        let window = java.lang.Object()
        var isFocused = true
        let source = MutableWindowInsets(WindowInsets(bottom: 400))
        let existingReader = WindowKeyboardInsets(
            source: source,
            state: WindowKeyboardInsetsState.forWindow(window),
            isWindowFocused: { isFocused },
            isKeyboardVisible: { false }
        )
        let density = Density(density: Float(1.0))
        _ = existingReader.getBottom(density)
        isFocused = false
        let newReader = WindowKeyboardInsets(
            source: source,
            state: WindowKeyboardInsetsState.forWindow(window),
            isWindowFocused: { isFocused },
            isKeyboardVisible: { false }
        )

        // Act
        source.insets = WindowInsets(bottom: 200)
        let newIntermediate = newReader.getBottom(density)
        let existingIntermediate = existingReader.getBottom(density)
        source.insets = WindowInsets(bottom: 0)
        let existingCollapsed = existingReader.getBottom(density)
        let newCollapsed = newReader.getBottom(density)

        // Assert
        XCTAssertEqual(newIntermediate, 200)
        XCTAssertEqual(existingIntermediate, newIntermediate)
        XCTAssertEqual(existingCollapsed, 0)
        XCTAssertEqual(newCollapsed, existingCollapsed)
    }

    func testSeparateWindowsDoNotShareRetainedInsets() {
        // Arrange
        let firstWindow = java.lang.Object()
        let secondWindow = java.lang.Object()
        let source = MutableWindowInsets(WindowInsets(bottom: 400))
        let focusedReader = WindowKeyboardInsets(
            source: source,
            state: WindowKeyboardInsetsState.forWindow(firstWindow),
            isWindowFocused: { true },
            isKeyboardVisible: { true }
        )
        let unfocusedReader = WindowKeyboardInsets(
            source: source,
            state: WindowKeyboardInsetsState.forWindow(secondWindow),
            isWindowFocused: { false },
            isKeyboardVisible: { true }
        )
        let density = Density(density: Float(1.0))

        // Act
        let focused = focusedReader.getBottom(density)
        let unfocused = unfocusedReader.getBottom(density)

        // Assert
        XCTAssertEqual(focused, 400)
        XCTAssertEqual(unfocused, 0)
    }

    func testUnfocusedWindowIgnoresAnotherWindowsKeyboard() {
        // Arrange
        let source = MutableWindowInsets(WindowInsets(left: 10, top: 20, right: 30, bottom: 400))
        let insets = WindowKeyboardInsets(
            source: source,
            state: WindowKeyboardInsetsState(),
            isWindowFocused: { false },
            isKeyboardVisible: { true }
        )
        let density = Density(density: Float(1.0))

        // Act
        let left = insets.getLeft(density, LayoutDirection.Ltr)
        let top = insets.getTop(density)
        let right = insets.getRight(density, LayoutDirection.Ltr)
        let bottom = insets.getBottom(density)

        // Assert
        XCTAssertEqual(left, 0)
        XCTAssertEqual(top, 0)
        XCTAssertEqual(right, 0)
        XCTAssertEqual(bottom, 0)
    }

    func testFocusedWindowFollowsEveryKeyboardAnimationValue() {
        // Arrange
        let source = MutableWindowInsets(WindowInsets(bottom: 400))
        let insets = WindowKeyboardInsets(
            source: source,
            state: WindowKeyboardInsetsState(),
            isWindowFocused: { true },
            isKeyboardVisible: { true }
        )
        let density = Density(density: Float(1.0))

        // Act
        let expanded = insets.getBottom(density)
        source.insets = WindowInsets(bottom: 200)
        let intermediate = insets.getBottom(density)
        source.insets = WindowInsets(bottom: 0)
        let collapsed = insets.getBottom(density)

        // Assert
        XCTAssertEqual(expanded, 400)
        XCTAssertEqual(intermediate, 200)
        XCTAssertEqual(collapsed, 0)
    }

    func testUnfocusedWindowDoesNotAdoptALargerKeyboard() {
        // Arrange
        var isFocused = true
        let source = MutableWindowInsets(WindowInsets(left: 10, top: 20, right: 30, bottom: 400))
        let insets = WindowKeyboardInsets(
            source: source,
            state: WindowKeyboardInsetsState(),
            isWindowFocused: { isFocused },
            isKeyboardVisible: { true }
        )
        let density = Density(density: Float(1.0))
        _ = insets.getLeft(density, LayoutDirection.Rtl)
        _ = insets.getTop(density)
        _ = insets.getRight(density, LayoutDirection.Rtl)
        _ = insets.getBottom(density)

        // Act
        isFocused = false
        source.insets = WindowInsets(left: 20, top: 30, right: 40, bottom: 600)
        let retainedLeft = insets.getLeft(density, LayoutDirection.Rtl)
        let retainedTop = insets.getTop(density)
        let retainedRight = insets.getRight(density, LayoutDirection.Rtl)
        let retainedBottom = insets.getBottom(density)
        isFocused = true
        let restoredBottom = insets.getBottom(density)

        // Assert
        XCTAssertEqual(retainedLeft, 10)
        XCTAssertEqual(retainedTop, 20)
        XCTAssertEqual(retainedRight, 30)
        XCTAssertEqual(retainedBottom, 400)
        XCTAssertEqual(restoredBottom, 600)
    }

    func testUnfocusedWindowAllowsItsKeyboardToFinishHiding() {
        // Arrange
        var isFocused = true
        let source = MutableWindowInsets(WindowInsets(bottom: 400))
        let insets = WindowKeyboardInsets(
            source: source,
            state: WindowKeyboardInsetsState(),
            isWindowFocused: { isFocused },
            isKeyboardVisible: { false }
        )
        let density = Density(density: Float(1.0))
        _ = insets.getBottom(density)

        // Act
        isFocused = false
        source.insets = WindowInsets(bottom: 200)
        let intermediate = insets.getBottom(density)
        source.insets = WindowInsets(bottom: 0)
        let collapsed = insets.getBottom(density)
        source.insets = WindowInsets(bottom: 600)
        let anotherWindowKeyboard = insets.getBottom(density)

        // Assert
        XCTAssertEqual(intermediate, 200)
        XCTAssertEqual(collapsed, 0)
        XCTAssertEqual(anotherWindowKeyboard, 0)
    }
}
#endif
