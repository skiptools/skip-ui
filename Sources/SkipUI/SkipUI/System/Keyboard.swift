// Copyright 2023–2026 Skip
// SPDX-License-Identifier: MPL-2.0
#if SKIP
import androidx.compose.foundation.layout.WindowInsets
import androidx.compose.foundation.layout.displayCutout
import androidx.compose.foundation.layout.ime
import androidx.compose.foundation.layout.systemBars
import androidx.compose.foundation.layout.union
import androidx.compose.runtime.Composable
import androidx.compose.runtime.remember
import androidx.compose.ui.platform.LocalWindowInfo
import androidx.compose.ui.platform.LocalView
import androidx.core.view.ViewCompat
import androidx.core.view.WindowInsetsCompat
import androidx.compose.ui.unit.LayoutDirection
import androidx.compose.runtime.State
import androidx.compose.ui.focus.FocusManager
import androidx.compose.ui.geometry.Offset
import androidx.compose.ui.input.nestedscroll.NestedScrollConnection
import androidx.compose.ui.input.nestedscroll.NestedScrollSource
import androidx.compose.ui.platform.SoftwareKeyboardController
import androidx.compose.ui.unit.Density

/// Use to dismiss the keyboard on scroll.
///
/// - Seealso: `Modifier.scrollDismissesKeyboardMode(_:)`
struct KeyboardDismissingNestedScrollConnection: NestedScrollConnection {
    let keyboardController: State<SoftwareKeyboardController?>
    let focusManager: State<FocusManager?>
    let imeInsets: WindowInsets
    let density: Density
    let isUserScrollActive: State<Bool>

    override func onPreScroll(available: Offset, source: NestedScrollSource) -> Offset {
        guard source == NestedScrollSource.Drag,
              imeInsets.getBottom(density) > 0,
              isUserScrollActive.value else {
            return Offset.Zero
        }

        keyboardController.value?.hide()
        focusManager.value?.clearFocus()
        return Offset.Zero
    }
}

/// Returns keyboard insets owned by the current window.
///
/// - Returns: Insets that follow this window's keyboard without adopting another window's keyboard.
@Composable func windowKeyboardInsets() -> WindowInsets {
    let windowInfo = LocalWindowInfo.current
    let view = LocalView.current
    let keyboardInsets = WindowInsets.ime
    // SKIP INSERT: val isKeyboardVisible = { ViewCompat.getRootWindowInsets(view)?.isVisible(WindowInsetsCompat.Type.ime()) ?: false }
    return remember(windowInfo, view, keyboardInsets) {
        WindowKeyboardInsets(
            source: keyboardInsets,
            isWindowFocused: { windowInfo.isWindowFocused },
            isKeyboardVisible: isKeyboardVisible
        )
    }
}

/// Returns safe drawing insets without inheriting another window's keyboard animation.
///
/// - Returns: The union of system bars, display cutouts and this window's keyboard insets.
@Composable func windowSafeDrawingInsets() -> WindowInsets {
    WindowInsets.systemBars.union(windowKeyboardInsets()).union(WindowInsets.displayCutout)
}

/// Keeps keyboard geometry local to its window while allowing its keyboard to finish disappearing.
final class WindowKeyboardInsets: WindowInsets {

    private let source: WindowInsets
    private let isWindowFocused: () -> Bool
    private let isKeyboardVisible: () -> Bool

    private var left = 0
    private var top = 0
    private var right = 0
    private var bottom = 0

    /// Creates window-scoped keyboard insets.
    ///
    /// - Parameters:
    ///   - source: The keyboard insets supplied by Android.
    ///   - isWindowFocused: Returns whether this window currently owns input focus.
    ///   - isKeyboardVisible: Returns whether Android is still showing the keyboard.
    init(
        source: WindowInsets,
        isWindowFocused: @escaping () -> Bool,
        isKeyboardVisible: @escaping () -> Bool
    ) {
        self.source = source
        self.isWindowFocused = isWindowFocused
        self.isKeyboardVisible = isKeyboardVisible
    }

    /// Returns the left keyboard inset in pixels.
    ///
    /// - Parameters:
    ///   - density: The current display density.
    ///   - layoutDirection: The current layout direction.
    /// - Returns: This window's left inset.
    override func getLeft(density: Density, layoutDirection: LayoutDirection) -> Int {
        if self.isWindowFocused() {
            self.left = self.source.getLeft(density, layoutDirection)
        } else if self.left > 0 {
            let current = self.source.getLeft(density, layoutDirection)
            if !self.isKeyboardVisible() {
                self.left = min(self.left, current)
            }
        }

        return self.left
    }

    /// Returns the top keyboard inset in pixels.
    ///
    /// - Parameter density: The current display density.
    /// - Returns: This window's top inset.
    override func getTop(density: Density) -> Int {
        if self.isWindowFocused() {
            self.top = self.source.getTop(density)
        } else if self.top > 0 {
            let current = self.source.getTop(density)
            if !self.isKeyboardVisible() {
                self.top = min(self.top, current)
            }
        }

        return self.top
    }

    /// Returns the right keyboard inset in pixels.
    ///
    /// - Parameters:
    ///   - density: The current display density.
    ///   - layoutDirection: The current layout direction.
    /// - Returns: This window's right inset.
    override func getRight(density: Density, layoutDirection: LayoutDirection) -> Int {
        if self.isWindowFocused() {
            self.right = self.source.getRight(density, layoutDirection)
        } else if self.right > 0 {
            let current = self.source.getRight(density, layoutDirection)
            if !self.isKeyboardVisible() {
                self.right = min(self.right, current)
            }
        }

        return self.right
    }

    /// Returns the bottom keyboard inset in pixels.
    ///
    /// - Parameter density: The current display density.
    /// - Returns: This window's bottom inset.
    override func getBottom(density: Density) -> Int {
        if self.isWindowFocused() {
            self.bottom = self.source.getBottom(density)
        } else if self.bottom > 0 {
            let current = self.source.getBottom(density)
            if !self.isKeyboardVisible() {
                self.bottom = min(self.bottom, current)
            }
        }

        return self.bottom
    }
}

#endif
