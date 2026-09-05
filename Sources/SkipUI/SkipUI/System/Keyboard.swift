// Copyright 2023–2026 Skip
// SPDX-License-Identifier: MPL-2.0
#if SKIP
import androidx.compose.foundation.layout.WindowInsets
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

#endif
