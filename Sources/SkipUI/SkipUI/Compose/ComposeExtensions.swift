// Copyright 2023–2025 Skip
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception
#if SKIP
import androidx.compose.foundation.layout.PaddingValues
import androidx.compose.foundation.layout.fillMaxHeight
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.geometry.Rect
import androidx.compose.ui.layout.boundsInRoot
import androidx.compose.ui.layout.boundsInWindow
import androidx.compose.ui.layout.onGloballyPositioned
import androidx.compose.ui.platform.LocalDensity
import androidx.compose.ui.platform.LocalLayoutDirection

extension Modifier {
    /// Fill available remaining width.
    ///
    /// This is a replacement for `fillMaxWidth` designed for situations when the composable may be in an `HStack` and does not want to push other items out.
    ///
    /// - Warning: Containers with child content should use the `ComposeContainer` composable instead.
    @Composable public func fillWidth() -> Modifier {
        guard let fill = EnvironmentValues.shared._fillWidth else {
            return fillMaxWidth()
        }
        return then(fill())
    }

    /// Fill available remaining height.
    ///
    /// This is a replacement for `fillMaxHeight` designed for situations when the composable may be in an `VStack` and does not want to push other items out.
    ///
    /// - Warning: Containers with child content should use the `ComposeContainer` composable instead.
    @Composable public func fillHeight() -> Modifier {
        guard let fill = EnvironmentValues.shared._fillHeight else {
            return fillMaxHeight()
        }
        return then(fill())
    }

    /// Fill available remaining size.
    ///
    /// This is a replacement for `fillMaxSize` designed for situations when the composable may be in an `HStack` or `VStack` and does not want to push other items out.
    ///
    /// - Warning: Containers with child content should use the `ComposeContainer` composable instead.
    @Composable public func fillSize() -> Modifier {
        return fillWidth().fillHeight()
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
