// Copyright 2023–2025 Skip
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception
#if SKIP
import androidx.compose.foundation.layout.PaddingValues
import androidx.compose.foundation.layout.WindowInsets
import androidx.compose.foundation.layout.fillMaxHeight
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.ime
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.requiredHeightIn
import androidx.compose.foundation.layout.requiredWidthIn
import androidx.compose.runtime.Composable
import androidx.compose.runtime.remember
import androidx.compose.runtime.rememberUpdatedState
import androidx.compose.ui.Modifier
import androidx.compose.ui.geometry.Rect
import androidx.compose.ui.layout.boundsInRoot
import androidx.compose.ui.layout.boundsInWindow
import androidx.compose.ui.layout.onGloballyPositioned
import androidx.compose.ui.input.nestedscroll.nestedScroll
import androidx.compose.ui.platform.LocalDensity
import androidx.compose.ui.platform.LocalFocusManager
import androidx.compose.ui.platform.LocalLayoutDirection
import androidx.compose.ui.platform.LocalSoftwareKeyboardController
import androidx.compose.ui.unit.dp

extension Modifier {
    /// Fill available width similar to `.frame(maxWidth: .infinity)`.
    ///
    /// - Seealso: `flexibleWidth(ideal:min:max:)`
    @Composable public func fillWidth() -> Modifier {
        return flexibleWidth(max: Float.flexibleFill)
    }

    /// Fill available height similar to `.frame(maxHeight: .infinity)`.
    ///
    /// - Seealso: `flexibleHeight(ideal:min:max:)`
    @Composable public func fillHeight() -> Modifier {
        return flexibleHeight(max: Float.flexibleFill)
    }

    /// Fill available size similar to `.frame(maxWidth: .infinity, maxHeight: .infinity)`.
    ///
    /// - Seealso: `flexibleWidth(ideal:min:max:)`
    /// - Seealso: `flexibleHeight(ideal:min:max:)`
    @Composable public func fillSize() -> Modifier {
        return fillWidth().fillHeight()
    }

    /// SwiftUI-like flexible layout.
    ///
    /// - Seealso: `.frame(minWidth:idealWidth:maxWidth:)`
    /// - Warning: Containers with child content should use the `ComposeContainer` composable instead.
    @Composable public func flexibleWidth(ideal: Float? = nil, min: Float? = nil, max: Float? = nil) -> Modifier {
        if let flexible = EnvironmentValues.shared._flexibleWidth {
            return then(flexible(ideal, min, max))
        } else {
            let modifier = max == Float.flexibleFill ? fillMaxWidth() : self
            return modifier.applyNonExpandingFlexibleWidth(ideal: ideal, min: min, max: max)
        }
    }

    /// SwiftUI-like flexible layout.
    ///
    ///
    /// - Seealso: `.frame(minHeight:idealHeight:maxHeight:)`
    /// - Warning: Containers with child content should use the `ComposeContainer` composable instead.
    @Composable public func flexibleHeight(ideal: Float? = nil, min: Float? = nil, max: Float? = nil) -> Modifier {
        if let flexible = EnvironmentValues.shared._flexibleHeight {
            return then(flexible(ideal, min, max))
        } else {
            let modifier = max == Float.flexibleFill ? fillMaxHeight() : self
            return modifier.applyNonExpandingFlexibleHeight(ideal: ideal, min: min, max: max)
        }
    }

    /// For internal use.
    func applyNonExpandingFlexibleWidth(ideal: Float? = nil, min: Float? = nil, max: Float? = nil) -> Modifier {
        if let min, min! > Float(0), let max, max! >= Float(0) {
            return requiredWidthIn(min: min!.dp, max: max!.dp)
        } else if let min, min! > Float(0) {
            return requiredWidthIn(min: min!.dp)
        } else if let max, max! >= Float(0) {
            return requiredWidthIn(max: max!.dp)
        } else {
            return self
        }
    }

    /// For internal use.
    func applyNonExpandingFlexibleHeight(ideal: Float? = nil, min: Float? = nil, max: Float? = nil) -> Modifier {
        if let min, min! > Float(0), let max, max! >= Float(0) {
            return requiredHeightIn(min: min!.dp, max: max!.dp)
        } else if let min, min! > Float(0) {
            return requiredHeightIn(min: min!.dp)
        } else if let max, max! >= Float(0) {
            return requiredHeightIn(max: max!.dp)
        } else {
            return self
        }
    }

    /// Add padding equivalent to the given safe area.
    @Composable func padding(safeArea: SafeArea) -> Modifier {
        let density = LocalDensity.current
        let layoutDirection = LocalLayoutDirection.current
        let top = with(density) { (safeArea.safeBoundsPx.top - safeArea.presentationBoundsPx.top).toDp() }
        let left = with(density) { (safeArea.safeBoundsPx.left - safeArea.presentationBoundsPx.left).toDp() }
        let bottom = with(density) { (safeArea.presentationBoundsPx.bottom - safeArea.safeBoundsPx.bottom).toDp() }
        let right = with(density) { (safeArea.presentationBoundsPx.right - safeArea.safeBoundsPx.right).toDp() }
        let start = layoutDirection == androidx.compose.ui.unit.LayoutDirection.Rtl ? right : left
        let end = layoutDirection == androidx.compose.ui.unit.LayoutDirection.Rtl ? left : right
        return self.padding(top: top, start: start, bottom: bottom, end: end)
    }

    /// Invoke the given closure with the modified view's root bounds.
    @Composable func onGloballyPositionedInRoot(perform: (Rect) -> Void) -> Modifier {
        return self.onGloballyPositioned {
            let bounds = $0.boundsInRoot()
            if bounds != Rect.Zero {
                perform(bounds)
            }
        }
    }

    /// Invoke the given closure with the modified view's window bounds.
    @Composable func onGloballyPositionedInWindow(perform: (Rect) -> Void) -> Modifier {
        return self.onGloballyPositioned {
            let bounds = $0.boundsInWindow()
            if bounds != Rect.Zero {
                perform(bounds)
            }
        }
    }

    @Composable func scrollDismissesKeyboardMode(_ mode: ScrollDismissesKeyboardMode) -> Modifier {
        guard mode == .immediately || mode == .interactively else {
            return self
        }
        let keyboardController = rememberUpdatedState(LocalSoftwareKeyboardController.current)
        let focusManager = rememberUpdatedState(LocalFocusManager.current)
        let imeInsets = WindowInsets.ime
        let density = LocalDensity.current
        let nestedScrollConnection = remember {
            KeyboardDismissingNestedScrollConnection(keyboardController: keyboardController, focusManager: focusManager, imeInsets: imeInsets, density: density)
        }
        return self.nestedScroll(nestedScrollConnection)
    }
}

extension PaddingValues {
    /// Convert padding values to edge insets in `dp` units.
    @Composable public func asEdgeInsets() -> EdgeInsets {
        let layoutDirection = EnvironmentValues.shared.layoutDirection == .rightToLeft ?     androidx.compose.ui.unit.LayoutDirection.Rtl : androidx.compose.ui.unit.LayoutDirection.Ltr
        let top = Double(calculateTopPadding().value)
        let left = Double(calculateLeftPadding(layoutDirection).value)
        let bottom = Double(calculateBottomPadding().value)
        let right = Double(calculateRightPadding(layoutDirection).value)
        return EdgeInsets(top: top, leading: left, bottom: bottom, trailing: right)
    }
}

#endif
