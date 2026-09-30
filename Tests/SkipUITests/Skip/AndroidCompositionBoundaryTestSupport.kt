// Copyright 2026 Skip
// SPDX-License-Identifier: MPL-2.0
package skip.ui

import android.view.View
import android.view.ViewGroup
import androidx.compose.ui.platform.ComposeView

/** Returns the deepest ComposeView, which is the boundary host in these single-boundary tests. */
internal fun androidCompositionBoundaryHostView(root: View): ComposeView {
    var deepestHost: ComposeView? = null
    var deepestLevel = -1

    fun visit(view: View, level: Int) {
        if (view is ComposeView && level > deepestLevel) {
            deepestHost = view
            deepestLevel = level
        }
        if (view is ViewGroup) {
            for (index in 0 until view.childCount) {
                visit(view.getChildAt(index), level + 1)
            }
        }
    }

    visit(root, 0)
    return requireNotNull(deepestHost) { "No ComposeView found in the activity hierarchy" }
}
