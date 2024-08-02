// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

#if SKIP
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.requiredHeight
import androidx.compose.foundation.layout.requiredHeightIn
import androidx.compose.foundation.layout.requiredWidth
import androidx.compose.foundation.layout.requiredWidthIn
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.geometry.Rect
import androidx.compose.ui.layout.Layout
import androidx.compose.ui.platform.LocalDensity
import androidx.compose.ui.platform.LocalLayoutDirection
import androidx.compose.ui.unit.Constraints
import androidx.compose.ui.unit.Dp
import androidx.compose.ui.unit.dp

/// Compose a view with the given frame.
@Composable func FrameLayout(view: View, context: ComposeContext, width: CGFloat?, height: CGFloat?, alignment: Alignment) {
    var modifier = context.modifier
    if let width {
        modifier = modifier.requiredWidth(width.dp)
    }
    if let height {
        modifier = modifier.requiredHeight(height.dp)
    }

    // If our content has a zIndex, we need to pull it into our modifiers so that it applies within the original
    // parent container. Otherwise the Box we use below would hide it
    if let zIndex = view.strippingModifiers(until: { $0 == .zIndex }, perform: { $0 as? ZIndexModifierView }) {
        modifier = zIndex.consume(with: modifier)
    }

    let isContainerView = view.strippingModifiers(perform: { $0 is HStack || $0 is VStack || $0 is ZStack })
    ComposeContainer(modifier: modifier, fixedWidth: width != nil, fixedHeight: height != nil) { modifier in
        // Apply the sizing modifier directly to containers, which would otherwise fit their size to their content instead
        if isContainerView {
            let contentContext = context.content(modifier: modifier)
            view.Compose(context: contentContext)
        } else {
            let contentContext = context.content()
            Box(modifier: modifier, contentAlignment: alignment.asComposeAlignment()) {
                view.Compose(context: contentContext)
            }
        }
    }
}

/// Compose a view with the given frame.
@Composable func FrameLayout(view: View, context: ComposeContext, minWidth: CGFloat?, idealWidth: CGFloat?, maxWidth: CGFloat?, minHeight: CGFloat?, idealHeight: CGFloat?, maxHeight: CGFloat?, alignment: Alignment) {
    let scrollAxes = EnvironmentValues.shared._scrollAxes
    var thenModifier: Modifier = Modifier
    if maxWidth == .infinity {
        if let minWidth, minWidth > 0.0 {
            thenModifier = thenModifier.requiredWidthIn(min: minWidth.dp)
        }
    } else if minWidth != nil || maxWidth != nil {
        thenModifier = thenModifier.requiredWidthIn(min: minWidth != nil ? minWidth!.dp : Dp.Unspecified, max: maxWidth != nil ? maxWidth!.dp : Dp.Unspecified)
    }
    if maxHeight == .infinity {
        if let minHeight, minHeight > 0.0 {
            thenModifier = thenModifier.requiredHeightIn(min: minHeight.dp)
        }
    } else if minHeight != nil || maxHeight != nil {
        thenModifier = thenModifier.requiredHeightIn(min: minHeight != nil ? minHeight!.dp : Dp.Unspecified, max: maxHeight != nil ? maxHeight!.dp : Dp.Unspecified)
    }
    let isContainerView = view.strippingModifiers(perform: { $0 is HStack || $0 is VStack || $0 is ZStack })
    ComposeContainer(modifier: context.modifier, fillWidth: maxWidth == Double.infinity, fixedWidth: maxWidth != nil && maxWidth != Double.infinity, fillHeight: maxHeight == Double.infinity, fixedHeight: maxHeight != nil && maxHeight != Double.infinity, then: thenModifier) { modifier in
        // Apply the sizing modifier directly to containers, which would otherwise fit their size to their content instead
        if isContainerView {
            let contentContext = context.content(modifier: modifier)
            view.Compose(context: contentContext)
        } else {
            let contentContext = context.content()
            Box(modifier: modifier, contentAlignment: alignment.asComposeAlignment()) {
                view.Compose(context: contentContext)
            }
        }
    }
}

/// Compose a view with the given background.
@Composable func BackgroundLayout(view: View, context: ComposeContext, background: View, alignment: Alignment) {
    TargetViewLayout(context: context, isOverlay: false, alignment: alignment, target: { view.Compose(context: $0) }, dependent: { background.Compose(context: $0) })
}

/// Compose a view with the given overlay.
@Composable func OverlayLayout(view: View, context: ComposeContext, overlay: View, alignment: Alignment) {
    TargetViewLayout(context: context, isOverlay: true, alignment: alignment, target: { view.Compose(context: $0) }, dependent: { overlay.Compose(context: $0) })
}

@Composable func TargetViewLayout(context: ComposeContext, isOverlay: Bool, alignment: Alignment, target: @Composable (ComposeContext) -> Void, dependent: @Composable (ComposeContext) -> Void) {
    let contentContext = context.content()
    Layout(modifier: context.modifier, content: {
        target(contentContext)
        // Dependent view lays out with fixed bounds dictated by the target view size
        ComposeContainer(fixedWidth: true, fixedHeight: true) { modifier in
            dependent(context.content(modifier: modifier))
        }
    }) { measurables, constraints in
        guard !measurables.isEmpty() else {
            return layout(width: 0, height: 0) {}
        }
        // Base layout entirely on the target view size
        let targetPlaceable = measurables[0].measure(constraints)
        let dependentConstraints = Constraints(maxWidth: targetPlaceable.width, maxHeight: targetPlaceable.height)
        let dependentPlaceables = measurables.drop(1).map { $0.measure(dependentConstraints) }
        layout(width: targetPlaceable.width, height: targetPlaceable.height) {
            if !isOverlay {
                for dependentPlaceable in dependentPlaceables {
                    let (x, y) = placeView(width: dependentPlaceable.width, height: dependentPlaceable.height, inWidth: targetPlaceable.width, inHeight: targetPlaceable.height, alignment: alignment)
                    dependentPlaceable.placeRelative(x: x, y: y)
                }
            }
            targetPlaceable.placeRelative(x: 0, y: 0)
            if isOverlay {
                for dependentPlaceable in dependentPlaceables {
                    let (x, y) = placeView(width: dependentPlaceable.width, height: dependentPlaceable.height, inWidth: targetPlaceable.width, inHeight: targetPlaceable.height, alignment: alignment)
                    dependentPlaceable.placeRelative(x: x, y: y)
                }
            }
        }
    }
}

/// Layout the given view to ignore the given safe areas.
@Composable func IgnoresSafeAreaLayout(view: View, edges: Edge.Set, context: ComposeContext) {
    IgnoresSafeAreaLayout(edges: edges, context: context) { view.Compose($0) }
}

@Composable func IgnoresSafeAreaLayout(edges: Edge.Set, context: ComposeContext, target: @Composable (ComposeContext) -> Void) {
    guard let safeArea = EnvironmentValues.shared._safeArea else {
        target(context)
        return
    }

    var (safeLeft, safeTop, safeRight, safeBottom) = safeArea.safeBoundsPx
    var topPx = 0
    if edges.contains(.top) {
        topPx = Int(safeArea.safeBoundsPx.top - safeArea.presentationBoundsPx.top)
        safeTop = safeArea.presentationBoundsPx.top
    }
    var bottomPx = 0
    if edges.contains(.bottom) {
        bottomPx = Int(safeArea.presentationBoundsPx.bottom - safeArea.safeBoundsPx.bottom)
        safeBottom = safeArea.presentationBoundsPx.bottom
    }
    var leadingPx = 0
    if edges.contains(.leading) {
        if LocalLayoutDirection.current == androidx.compose.ui.unit.LayoutDirection.Rtl {
            leadingPx = Int(safeArea.presentationBoundsPx.right - safeArea.safeBoundsPx.right)
            safeRight = safeArea.presentationBoundsPx.right
        } else {
            leadingPx = Int(safeArea.safeBoundsPx.left - safeArea.presentationBoundsPx.left)
            safeLeft = safeArea.presentationBoundsPx.left
        }
    }
    var trailingPx = 0
    if edges.contains(.trailing) {
        if LocalLayoutDirection.current == androidx.compose.ui.unit.LayoutDirection.Rtl {
            trailingPx = Int(safeArea.safeBoundsPx.left - safeArea.presentationBoundsPx.left)
            safeLeft = safeArea.presentationBoundsPx.left
        } else {
            trailingPx = Int(safeArea.presentationBoundsPx.right - safeArea.safeBoundsPx.right)
            safeRight = safeArea.presentationBoundsPx.right
        }
    }

    let contentSafeBounds = Rect(top: safeTop, left: safeLeft, bottom: safeBottom, right: safeRight)
    let contentSafeArea = SafeArea(presentation: safeArea.presentationBoundsPx, safe: contentSafeBounds, absoluteSystemBars: safeArea.absoluteSystemBarEdges)
    EnvironmentValues.shared.setValues {
        $0.set_safeArea(contentSafeArea)
    } in: {
        Layout(content: {
            target(context)
        }) { measurables, constraints in
            guard !measurables.isEmpty() else {
                return layout(width: 0, height: 0) {}
            }
            let updatedConstraints = constraints.copy(maxWidth: constraints.maxWidth + leadingPx + trailingPx, maxHeight: constraints.maxHeight + topPx + bottomPx)
            let targetPlaceables = measurables.map { $0.measure(updatedConstraints) }
            layout(width: targetPlaceables[0].width, height: targetPlaceables[0].height) {
                // Layout will center extra space by default
                let relativeTopPx = topPx - ((topPx + bottomPx) / 2)
                let relativeLeadingPx = leadingPx - ((leadingPx + trailingPx) / 2)
                for targetPlaceable in targetPlaceables {
                    targetPlaceable.placeRelative(x = -relativeLeadingPx, y = -relativeTopPx)
                }
            }
        }
    }
}

/// Layout the given view with the given padding.
@Composable func PaddingLayout(view: View, padding: EdgeInsets, context: ComposeContext) {
    PaddingLayout(padding: padding, context: context) { view.Compose($0) }
}

@Composable func PaddingLayout(padding: EdgeInsets, context: ComposeContext, target: @Composable (ComposeContext) -> Void) {
    let density = LocalDensity.current
    let topPx = with(density) { padding.top.dp.roundToPx() }
    let bottomPx = with(density) { padding.bottom.dp.roundToPx() }
    let leadingPx = with(density) { padding.leading.dp.roundToPx() }
    let trailingPx = with(density) { padding.trailing.dp.roundToPx() }
    Layout(modifier: context.modifier, content = {
        target(context.content())
    }) { measurables, constraints in
        guard !measurables.isEmpty() else {
            return layout(width: 0, height: 0) {}
        }
        let updatedConstraints = constraints.copy(minWidth: constraint(constraints.minWidth, subtracting: leadingPx + trailingPx), minHeight: constraint(constraints.minHeight, subtracting: topPx + bottomPx), maxWidth: constraint(constraints.maxWidth, subtracting: leadingPx + trailingPx), maxHeight: constraint(constraints.maxHeight, subtracting: topPx + bottomPx))
        let targetPlaceables = measurables.map { $0.measure(updatedConstraints) }
        layout(width: targetPlaceables[0].width + leadingPx + trailingPx, height: targetPlaceables[0].height + topPx + bottomPx) {
            for targetPlaceable in targetPlaceables {
                targetPlaceable.placeRelative(x: leadingPx, y: topPx)
            }
        }
    }
}

/// Layout the given view with the given position.
@Composable func PositionLayout(view: View, x: CGFloat, y: CGFloat, context: ComposeContext) {
    PositionLayout(x: x, y: y, context: context) { view.Compose($0) }
}

@Composable func PositionLayout(x: CGFloat, y: CGFloat, context: ComposeContext, target: @Composable (ComposeContext) -> Void) {
    // SwiftUI expands to fill the available space and places within that
    Box(modifier: context.modifier.fillSize()) {
        let density = LocalDensity.current
        let xPx = with(density) { x.dp.roundToPx() }
        let yPx = with(density) { y.dp.roundToPx() }
        Layout(content = {
            target(context.content())
        }) { measurables, constraints in
            guard !measurables.isEmpty() else {
                return layout(width: 0, height: 0) {}
            }
            let targetPlaceables = measurables.map { $0.measure(constraints) }
            layout(width: targetPlaceables[0].width, height: targetPlaceables[0].height) {
                for targetPlaceable in targetPlaceables {
                    targetPlaceable.placeRelative(x: xPx - targetPlaceable.width / 2, y: yPx - targetPlaceable.height / 2)
                }
            }
        }
    }
}

private func constraint(_ value: Int, subtracting: Int) -> Int {
    guard value != Int.MAX_VALUE else {
        return value
    }
    return max(0, value - subtracting)
}

private func placeView(width: Int, height: Int, inWidth: Int, inHeight: Int, alignment: Alignment) -> (Int, Int) {
    let centerX = (inWidth - width) / 2
    let centerY = (inHeight - height) / 2
    switch alignment {
    case .leading, .leadingFirstTextBaseline, .leadingLastTextBaseline:
        return (0, centerY)
    case .trailing, .trailingFirstTextBaseline, .trailingLastTextBaseline:
        return (inWidth - width, centerY)
    case .top:
        return (centerX, 0)
    case .bottom:
        return (centerX, inHeight - height)
    case .topLeading:
        return (0, 0)
    case .topTrailing:
        return (inWidth - width, 0)
    case .bottomLeading:
        return (0, inHeight - height)
    case .bottomTrailing:
        return (inWidth - width, inHeight - height)
    default:
        return (centerX, centerY)
    }
}

#endif
