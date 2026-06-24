// Copyright 2026 Skip
// SPDX-License-Identifier: MPL-2.0
package skip.ui

import android.content.Context
import android.view.View
import android.view.ViewGroup
import androidx.compose.runtime.Composable
import androidx.compose.runtime.Recomposer
import androidx.compose.ui.platform.AndroidUiDispatcher
import androidx.compose.ui.platform.ComposeView
import androidx.compose.ui.platform.ViewCompositionStrategy
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.SupervisorJob
import kotlinx.coroutines.cancel
import kotlinx.coroutines.launch

/**
 * Creates a ComposeView whose composition is driven by a private Recomposer.
 *
 * Android's default ComposeView path resolves a parent/view-tree/window composition context. This
 * helper is intentionally narrower: callers use it only for retained composition islands that
 * should not be invalidated by unrelated ancestor or sibling composition work.
 */
fun AndroidCompositionBoundaryComposeView(
    context: Context,
    content: @Composable () -> Unit
): ComposeView {
    val recomposerContext = AndroidUiDispatcher.Main
    val recomposer = Recomposer(recomposerContext)
    val scope = CoroutineScope(recomposerContext + SupervisorJob())
    val runner = scope.launch {
        recomposer.runRecomposeAndApplyChanges()
    }

    return ComposeView(context).apply {
        layoutParams = ViewGroup.LayoutParams(
            ViewGroup.LayoutParams.MATCH_PARENT,
            ViewGroup.LayoutParams.MATCH_PARENT
        )
        setParentCompositionContext(recomposer)
        setViewCompositionStrategy(ViewCompositionStrategy.DisposeOnDetachedFromWindow)
        setContent(content)
        addOnAttachStateChangeListener(object : View.OnAttachStateChangeListener {
            override fun onViewAttachedToWindow(v: View) = Unit

            override fun onViewDetachedFromWindow(v: View) {
                removeOnAttachStateChangeListener(this)
                disposeComposition()
                recomposer.close()
                runner.cancel()
                scope.cancel()
            }
        })
    }
}
