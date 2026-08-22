// Copyright 2026 Skip
// SPDX-License-Identifier: MPL-2.0
package skip.ui

import android.content.Context
import android.view.ViewGroup
import androidx.compose.runtime.Composable
import androidx.compose.runtime.CompositionContext
import androidx.compose.ui.platform.ComposeView
import androidx.compose.ui.platform.ViewCompositionStrategy

/**
 * Creates a ComposeView whose composition inherits from the current Compose tree.
 *
 * Android's default ComposeView path resolves a parent/view-tree/window composition context. This
 * helper is intentionally narrower: callers use it only for retained composition islands that
 * should inherit composition locals without being rebuilt for unrelated sibling composition work.
 * The host remains layout-transparent: parent constraints continue to measure this ComposeView and
 * its child without replacing the composition.
 */
fun AndroidCompositionBoundaryComposeView(
    context: Context,
    parentCompositionContext: CompositionContext,
    content: @Composable () -> Unit
): ComposeView {
    return ComposeView(context).apply {
        layoutParams = ViewGroup.LayoutParams(
            ViewGroup.LayoutParams.MATCH_PARENT,
            ViewGroup.LayoutParams.MATCH_PARENT
        )
        setParentCompositionContext(parentCompositionContext)
        setViewCompositionStrategy(ViewCompositionStrategy.DisposeOnDetachedFromWindow)
        setContent(content)
    }
}
