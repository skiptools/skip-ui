// Copyright 2025 Skip
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception
package skip.ui

import androidx.compose.ui.Modifier
import androidx.compose.ui.ExperimentalComposeUiApi
import androidx.compose.ui.input.pointer.PointerEvent
import androidx.compose.ui.input.pointer.PointerEventPass
import androidx.compose.ui.node.PointerInputModifierNode
import androidx.compose.ui.node.ModifierNodeElement
import androidx.compose.ui.platform.InspectorInfo
import androidx.compose.ui.unit.IntSize

public fun Modifier.skipHitTesting(enabled: Boolean): Modifier {
    return if (enabled) this else this then SkipHitTestingElement
}

private object SkipHitTestingElement : ModifierNodeElement<SkipHitTestingNode>() {
    override fun equals(other: Any?): Boolean {
        return other === this
    }

    override fun hashCode(): Int {
        return javaClass.hashCode()
    }

    override fun create(): SkipHitTestingNode {
        return SkipHitTestingNode()
    }

    override fun update(node: SkipHitTestingNode) {
    }

    override fun InspectorInfo.inspectableProperties() {
        name = "skipHitTesting"
        properties["enabled"] = false
    }
}

@OptIn(ExperimentalComposeUiApi::class)
private class SkipHitTestingNode : Modifier.Node(), PointerInputModifierNode {
    override fun onPointerEvent(pointerEvent: PointerEvent, pass: PointerEventPass, bounds: IntSize) {
        // Intentionally do nothing. Gesture handlers are disabled in SkipUI when
        // allowsHitTesting(false) is active.
        //android.util.Log.d("SkipUI-HitTesting", "skipHitTesting onPointerEvent pass=$pass pointers=${pointerEvent.changes.size}")
    }

    override fun onCancelPointerInput() {
        //android.util.Log.d("SkipUI-HitTesting", "skipHitTesting onCancelPointerInput")
    }

    override fun sharePointerInputWithSiblings(): Boolean {
        return true
    }
}
