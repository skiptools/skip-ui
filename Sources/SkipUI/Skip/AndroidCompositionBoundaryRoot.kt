// Copyright 2026 Skip
package skip.ui

import android.content.Context
import android.view.ViewGroup
import androidx.compose.foundation.layout.Box
import androidx.compose.runtime.Composable
import androidx.compose.runtime.CompositionContext
import androidx.compose.ui.Modifier
import androidx.compose.ui.input.nestedscroll.nestedScroll
import androidx.compose.ui.platform.ComposeView
import androidx.compose.ui.platform.ViewCompositionStrategy
import androidx.compose.ui.platform.rememberNestedScrollInteropConnection
import androidx.core.view.ViewCompat

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
            ViewGroup.LayoutParams.WRAP_CONTENT,
            ViewGroup.LayoutParams.WRAP_CONTENT
        )
        setParentCompositionContext(parentCompositionContext)
        setViewCompositionStrategy(ViewCompositionStrategy.DisposeOnDetachedFromWindow)
        ViewCompat.setNestedScrollingEnabled(this, true)
        AndroidCompositionBoundarySetContent(this, content)
    }
}

/** Keeps child scroll/fling handoff connected to AndroidView's parent on every content update. */
internal fun AndroidCompositionBoundarySetContent(view: ComposeView, content: @Composable () -> Unit) {
    view.setContent {
        // Preserve the host's constraints, including minimum sizes, without forcing it to fill.
        Box(Modifier.nestedScroll(rememberNestedScrollInteropConnection()), propagateMinConstraints = true) {
            content()
        }
    }
}
