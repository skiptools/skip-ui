// Copyright 2023–2025 Skip
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception
#if SKIP
import androidx.compose.foundation.layout.IntrinsicSize
import androidx.compose.foundation.layout.fillMaxHeight
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.width
import androidx.compose.runtime.Composable
import androidx.compose.runtime.SideEffect
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.Modifier

/// Composable to handle sizing and layout in a SwiftUI-like way for containers that compose child content.
///
/// - Seealso: `ComposeFlexibleContainer(...)`
@Composable public func ComposeContainer(axis: Axis? = nil, eraseAxis: Bool = false, scrollAxes: Axis.Set = [], modifier: Modifier = Modifier, fixedWidth: Bool = false, fillWidth: Bool = false, fixedHeight: Bool = false, fillHeight: Bool = false, then: Modifier = Modifier, content: @Composable (Modifier) -> Void) {
    ComposeFlexibleContainer(axis: axis, eraseAxis: eraseAxis, scrollAxes: scrollAxes, modifier: modifier, fixedWidth: fixedWidth, flexibleWidthMax: fillWidth ? Float.flexibleFill : nil, fixedHeight: fixedHeight, flexibleHeightMax: fillHeight ? Float.flexibleFill : nil, then: then, content: content)
}

/// Composable to handle sizing and layout in a SwiftUI-like way for containers that compose child content.
///
/// In Compose, containers are not perfectly layout neutral. A container that wants to expand must use the proper
/// modifier, rather than relying on its content. Additionally, a single 'fillMaxWidth' child will consume all
/// remaining space, pushing subsequent children out.
///
/// Having to explicitly set a modifier in order to expand within a parent in Compose is problematic for containers that
/// want to fit content. The container only wants to expand if it has content that wants to expand. It can't know this
/// until it composes its content. The code in this function sets triggers on the environment values that we use in
/// flexible layout so that if the container content uses them, the container itself can recompose with the appropriate
/// expansion to match its content. Note that this generally only affects final layout when an expanding child is in a
/// container that is itself in a container, and it has to share space with other members of the parent container.
@Composable public func ComposeFlexibleContainer(axis: Axis? = nil, eraseAxis: Bool = false, scrollAxes: Axis.Set = [], modifier: Modifier = Modifier, fixedWidth: Bool = false, flexibleWidthIdeal: Float? = nil, flexibleWidthMin: Float? = nil, flexibleWidthMax: Float? = nil, fixedHeight: Bool = false, flexibleHeightIdeal: Float? = nil, flexibleHeightMin: Float? = nil, flexibleHeightMax: Float? = nil, then: Modifier = Modifier, content: @Composable (Modifier) -> Void) {
    // Use remembered flexible values to recompose on change
    let contentFlexibleWidthMax = remember { mutableStateOf(flexibleWidthMax) }
    let contentFlexibleHeightMax = remember { mutableStateOf(flexibleHeightMax) }

    // Create the correct modifier for the current values and content
    var modifier = modifier
    let inheritedLayoutScrollAxes = EnvironmentValues.shared._layoutScrollAxes
    var totalLayoutScrollAxes = inheritedLayoutScrollAxes
    if fixedWidth || flexibleWidthMax?.isFlexibleNonExpandingMax == true || flexibleWidthMin?.isFlexibleNonExpandingMin == true || axis == .vertical {
        totalLayoutScrollAxes.remove(Axis.Set.horizontal)
    }
    if !fixedWidth {
        if flexibleWidthMax?.isFlexibleExpanding != true && contentFlexibleWidthMax.value?.isFlexibleExpanding == true && inheritedLayoutScrollAxes.contains(Axis.Set.horizontal) {
            // We must use IntrinsicSize.Max for fills in a scroll direction because Compose's fillMax modifiers
            // have no effect in the scroll direction. Flexible values can influence intrinsic measurement
            let minValue = flexibleWidthMin?.isFlexibleNonExpandingMin == true ? flexibleWidthMin : nil
            let maxValue = flexibleWidthMax?.isFlexibleNonExpandingMax == true ? flexibleWidthMax : nil
            modifier = modifier.flexibleWidth(min: minValue, max: maxValue).width(IntrinsicSize.Max)
        } else {
            let max: Float? = flexibleWidthMax ?? contentFlexibleWidthMax.value
            if flexibleWidthIdeal != nil || flexibleWidthMin != nil || max != nil {
                modifier = modifier.flexibleWidth(ideal: flexibleWidthIdeal, min: flexibleWidthMin, max: max)
            }
        }
    }
    if fixedHeight || flexibleHeightMax?.isFlexibleNonExpandingMax == true || flexibleHeightMin?.isFlexibleNonExpandingMin == true || axis == .horizontal {
        totalLayoutScrollAxes.remove(Axis.Set.vertical)
    }
    if !fixedHeight {
        if flexibleHeightMax?.isFlexibleExpanding != true && contentFlexibleHeightMax.value?.isFlexibleExpanding == true && inheritedLayoutScrollAxes.contains(Axis.Set.vertical) {
            // We must use IntrinsicSize.Max for fills in a scroll direction because Compose's fillMax modifiers
            // have no effect in the scroll direction. Flexible values can influence intrinsic measurement
            let minValue = flexibleHeightMin?.isFlexibleNonExpandingMin == true ? flexibleHeightMin : nil
            let maxValue = flexibleHeightMax?.isFlexibleNonExpandingMax == true ? flexibleHeightMax : nil
            modifier = modifier.flexibleHeight(min: minValue, max: maxValue).height(IntrinsicSize.Max)
        } else {
            let max: Float? = flexibleHeightMax ?? contentFlexibleHeightMax.value
            if flexibleHeightIdeal != nil || flexibleHeightMin != nil || max != nil {
                modifier = modifier.flexibleHeight(ideal: flexibleHeightIdeal, min: flexibleHeightMin, max: max)
            }
        }
    }

    totalLayoutScrollAxes.formUnion(scrollAxes)
    let inheritedScrollAxes = EnvironmentValues.shared._scrollAxes
    let totalScrollAxes = inheritedScrollAxes.union(scrollAxes)

    modifier = modifier.then(then)
    EnvironmentValues.shared.setValues {
        // Setup the initial environment before rendering the container content
        if let axis {
            $0.set_layoutAxis(axis)
        } else if eraseAxis {
            $0.set_layoutAxis(nil)
        }
        if totalLayoutScrollAxes != inheritedLayoutScrollAxes {
            $0.set_layoutScrollAxes(totalLayoutScrollAxes)
        }
        if totalScrollAxes != inheritedScrollAxes {
            $0.set_scrollAxes(totalScrollAxes)
        }

        // Reset the container layout because this is a new container. A directional container like 'HStack' or 'VStack' will set
        // the correct layout before rendering in the content block below, so that its own children can distribute available space
        $0.set_flexibleWidthModifier(nil)
        $0.set_flexibleHeightModifier(nil)

        // Set the 'flexibleWidth' and 'flexibleHeight' blocks to trigger a side effect to update our container's expansion state, which
        // can cause it to recompose and recalculate its own modifier. We must use `SideEffect` or the recomposition never happens
        $0.set_flexibleWidth { ideal, min, max in
            var defaultModifier: Modifier = Modifier
            if max?.isFlexibleExpanding == true {
                if max == Float.flexibleFill {
                    SideEffect { contentFlexibleWidthMax.value = Float.flexibleFill }
                } else if contentFlexibleWidthMax.value != Float.flexibleFill {
                    // max must be flexibleSpace or flexibleUnknownWithSpace
                    SideEffect { contentFlexibleWidthMax.value = Float.flexibleUnknownWithSpace }
                }
                defaultModifier = Modifier.fillMaxWidth()
            } else if max != nil && contentFlexibleWidthMax.value == nil {
                SideEffect { contentFlexibleWidthMax.value = Float.flexibleUnknownNonExpanding }
            }
            return EnvironmentValues.shared._flexibleWidthModifier?(ideal, min, max)
                ?? defaultModifier.applyNonExpandingFlexibleWidth(ideal: ideal, min: min, max: max)
        }
        $0.set_flexibleHeight { ideal, min, max in
            var defaultModifier: Modifier = Modifier
            if max?.isFlexibleExpanding == true {
                if max == Float.flexibleFill {
                    SideEffect { contentFlexibleHeightMax.value = Float.flexibleFill }
                } else if contentFlexibleHeightMax.value != Float.flexibleFill {
                    // max must be flexibleSpace or flexibleUnknownWithSpace
                    SideEffect { contentFlexibleHeightMax.value = Float.flexibleUnknownWithSpace }
                }
                defaultModifier = Modifier.fillMaxHeight()
            } else if max != nil && contentFlexibleHeightMax.value == nil {
                SideEffect { contentFlexibleHeightMax.value = Float.flexibleUnknownNonExpanding }
            }
            return EnvironmentValues.shared._flexibleHeightModifier?(ideal, min, max)
                ?? defaultModifier.applyNonExpandingFlexibleHeight(ideal: ideal, min: min, max: max)
        }
        return ComposeResult.ok
    } in: {
        // Render the container content with the above environment setup
        content(modifier)
    }
}
#endif
