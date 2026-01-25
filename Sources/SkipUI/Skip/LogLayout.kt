// Copyright 2025 Skip
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception
package skip.ui

import android.util.Log
import androidx.compose.ui.Modifier
import androidx.compose.ui.layout.IntrinsicMeasurable
import androidx.compose.ui.layout.IntrinsicMeasureScope
import androidx.compose.ui.layout.LayoutCoordinates
import androidx.compose.ui.layout.Measurable
import androidx.compose.ui.layout.MeasureResult
import androidx.compose.ui.layout.MeasureScope
import androidx.compose.ui.layout.boundsInWindow
import androidx.compose.ui.node.GlobalPositionAwareModifierNode
import androidx.compose.ui.node.LayoutModifierNode
import androidx.compose.ui.node.ModifierNodeElement
import androidx.compose.ui.platform.InspectorInfo
import androidx.compose.ui.unit.Constraints

/**
 * Creates a Modifier that logs layout constraints and bounds for debugging.
 * 
 * This modifier is a pass-through that doesn't affect layout behavior. It uses a stable
 * modifier element (with proper equals/hashCode based on the tag) to prevent remeasurement
 * loops that can occur when modifiers are recreated on every recomposition.
 */
public fun Modifier.logLayoutModifier(tag: String): Modifier {
    return this then LogLayoutElement(tag)
}

private class LogLayoutElement(private val tag: String) : ModifierNodeElement<LogLayoutModifierNode>() {
    override fun create(): LogLayoutModifierNode {
        return LogLayoutModifierNode(tag)
    }

    override fun update(node: LogLayoutModifierNode) {
        node.tag = tag
    }

    override fun InspectorInfo.inspectableProperties() {
        name = "logLayout"
        properties["tag"] = tag
    }

    override fun equals(other: Any?): Boolean {
        if (this === other) return true
        if (other !is LogLayoutElement) return false
        return tag == other.tag
    }

    override fun hashCode(): Int {
        return tag.hashCode()
    }
}

private class LogLayoutModifierNode(
    var tag: String
) : LayoutModifierNode, GlobalPositionAwareModifierNode, Modifier.Node() {
    override fun MeasureScope.measure(
        measurable: Measurable,
        constraints: Constraints
    ): MeasureResult {
        Log.d(
            tag,
            "Constraints: minWidth=${constraints.minWidth}, maxWidth=${constraints.maxWidth}, " +
                "minHeight=${constraints.minHeight}, maxHeight=${constraints.maxHeight}"
        )
        val placeable = measurable.measure(constraints)
        return layout(width = placeable.width, height = placeable.height) {
            placeable.placeRelative(x = 0, y = 0)
        }
    }

    override fun onGloballyPositioned(coordinates: LayoutCoordinates) {
        val bounds = coordinates.boundsInWindow()
        Log.d(
            tag,
            "Bounds: (top=${bounds.top}, left=${bounds.left}, bottom=${bounds.bottom}, " +
                "right=${bounds.right}, width=${bounds.width}, height=${bounds.height})"
        )
    }
}
