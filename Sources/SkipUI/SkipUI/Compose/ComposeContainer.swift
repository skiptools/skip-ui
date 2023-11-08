// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

#if SKIP
import androidx.compose.foundation.layout.IntrinsicSize
import androidx.compose.foundation.layout.fillMaxHeight
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
/// Compose's behavior differs from SwiftUI's when dealing with filling space. A SwiftUI container will give each child the
/// space it needs to display, then automatically divide the remainder between children that want to expand. In Compose, on
/// the other hand, a single 'fillMaxWidth' child will consume all remaining space, pushing subsequent children out. To get
/// SwiftUI's behavior, all children that want to expand must use the `weight` modifier, which is only available in a Row or
/// Column scope. We've abstracted the fact that 'weight' for a given dimension may or may not be available depending on scope
/// behind our `Modifier.fillWidth` and `Modifier.fillHeight` extension functions.
///
/// Having to explicitly set a certain modifier in order to expand within a parent is problematic for containers that want to
/// fit content. The container only wants to expand if it has content that wants to expand. It cant't know this until it composes
/// its content. The code in this function sets triggers on the environment values that we use in 'fillWidth' and 'fillHeight' so
/// that if the container content uses them, the container itself can recompose with the appropriate expansion to match its
/// content. Note that this generally only affects final layout when an expanding child is in a container that is itself in a
/// container, and it has to share space with other members of the parent container.
@Composable public func ComposeContainer(axis: Axis? = nil, eraseAxis: Bool = false, modifier: Modifier = Modifier, fillWidth: Bool = false, fixedWidth: Bool = false, fillHeight: Bool = false, fixedHeight: Bool = false, then: Modifier = Modifier, content: @Composable (Modifier) -> Void) {
    // Use remembered expansion values to recompose on change
    let isFillWidth = remember { mutableStateOf(fillWidth) }
    let isNonExpandingFillWidth = remember { mutableStateOf(false) }
    let isFillHeight = remember { mutableStateOf(fillHeight) }
    let isNonExpandingFillHeight = remember { mutableStateOf(false) }

    // Create the correct modifier for the current values. We use IntrinsicSize.Max for non-expanding fills so that child views who
    // want to take up available space without expanding this container can do so by calling `fillMaxWidth/Height`
    //
    // We have a special case when our content is framed, meaning at least one dimension is fixed. If a non-fixed dimension wants
    // a non-expanding fill, we do not set IntrinsicSize.Max and use an expanding fill instead
    // TODO: This special case works in practice thus far, but I do not fully understand it
    var modifier = modifier
    if !fixedWidth {
        if isFillWidth.value {
            modifier = modifier.fillWidth()
        } else if isNonExpandingFillWidth.value {
            if !fixedHeight {
                modifier = modifier.width(IntrinsicSize.Max)
            } else {
                modifier = modifier.fillWidth()
            }
        }
    }
    if !fixedHeight {
        if isFillHeight.value {
            modifier = modifier.fillHeight()
        } else if isNonExpandingFillHeight.value {
            if !fixedWidth {
                modifier = modifier.height(IntrinsicSize.Max)
            } else {
                modifier = modifier.fillHeight()
            }
        }
    }
    modifier = modifier.then(then)

    EnvironmentValues.shared.setValues {
        // Setup the initial environment before rendering the container content
        if let axis {
            $0.set_layoutAxis(axis)
        } else if eraseAxis {
            $0.set_layoutAxis(nil)
        }

        // Reset the container layout because this is a new container. A directional container like 'HStack' or 'VStack' will set
        // the correct layout before rendering in the content block below, so that its own children can distribute available space
        $0.set_fillWidthModifier(nil)
        $0.set_fillHeightModifier(nil)

        // Set the 'fillWidth' and 'fillHeight' blocks to trigger a side effect to update our container's expansion state, which can
        // cause it to recompose and recalculate its own modifier. We must use `SideEffect` or the recomposition never happens
        $0.set_fillWidth { expandContainer in
            let fillModifier = EnvironmentValues.shared._fillWidthModifier
            let isExpanding = expandContainer || fillModifier != nil
            if isExpanding && !isFillWidth.value {
                SideEffect {
                    isFillWidth.value = true
                }
            }
            if !isExpanding && !isNonExpandingFillWidth.value {
                SideEffect {
                    isNonExpandingFillWidth.value = true
                }
            }
            return fillModifier ?? Modifier.fillMaxWidth()
        }
        $0.set_fillHeight { expandContainer in
            let fillModifier = EnvironmentValues.shared._fillHeightModifier
            let isExpanding = expandContainer || fillModifier != nil
            if isExpanding && !isFillHeight.value {
                SideEffect {
                    isFillHeight.value = true
                }
            }
            if !isExpanding && !isNonExpandingFillHeight.value {
                SideEffect {
                    isNonExpandingFillHeight.value = true
                }
            }
            return fillModifier ?? Modifier.fillMaxHeight()
        }
    } in: {
        // Render the container content with the above environment setup
        content(modifier)
    }
}
#endif
