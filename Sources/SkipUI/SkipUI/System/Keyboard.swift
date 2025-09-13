// Copyright 2023–2025 Skip
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception
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

    override func onPreScroll(available: Offset, source: NestedScrollSource) -> Offset {
        if source == NestedScrollSource.Drag {
            let keyboardIsVisible = imeInsets.getBottom(density) > 0
            android.util.Log.e("", "KEYBOARD IS VISIBLE: \(keyboardIsVisible)") //~~~
            if keyboardIsVisible {
                keyboardController.value?.hide()
                focusManager.value?.clearFocus()
            }
        } else {
            android.util.Log.e("", "NOT A DRAG") //~~~
        }
        return Offset.Zero
    }
}

#endif
