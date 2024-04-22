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
    // We translate 0,.infinity to a non-expanding fill in either dimension. If the min is not zero, we can't use a fill
    // because it could set a weight on the view in an HStack or VStack, which will only give the view space after all
    // other views and potentially give it less than its minimum. We use a max of Double.MAX_VALUE instead
    var modifier = context.modifier
    if maxWidth == .infinity {
        if let minWidth, minWidth > 0.0 {
            modifier = modifier.requiredWidthIn(min: minWidth.dp, max: Double.MAX_VALUE.dp)
        } else {
            modifier = modifier.fillWidth(expandContainer: false)
        }
    } else if minWidth != nil || maxWidth != nil {
        modifier = modifier.requiredWidthIn(min: minWidth != nil ? minWidth!.dp : Dp.Unspecified, max: maxWidth != nil ? maxWidth!.dp : Dp.Unspecified)
    }
    if maxHeight == .infinity {
        if let minHeight, minHeight > 0.0 {
            modifier = modifier.requiredHeightIn(min: minHeight.dp, max: Double.MAX_VALUE.dp)
        } else {
            modifier = modifier.fillHeight(expandContainer: false)
        }
    } else if minHeight != nil || maxHeight != nil {
        modifier = modifier.requiredHeightIn(min: minHeight != nil ? minHeight!.dp : Dp.Unspecified, max: maxHeight != nil ? maxHeight!.dp : Dp.Unspecified)
    }
    let isContainerView = view.strippingModifiers(perform: { $0 is HStack || $0 is VStack || $0 is ZStack })
    ComposeContainer(modifier: modifier, fixedWidth: maxWidth != nil && maxWidth != Double.infinity, fixedHeight: maxHeight != nil && maxHeight != Double.infinity) { modifier in
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
        // Base layout entirely on the target view size
        let targetPlaceable = measurables[0].measure(constraints)
        let dependentPlaceable = measurables[1].measure(Constraints(maxWidth: targetPlaceable.width, maxHeight: targetPlaceable.height))
        layout(width: targetPlaceable.width, height: targetPlaceable.height) {
            let (x, y) = placeView(width: dependentPlaceable.width, height: dependentPlaceable.height, inWidth: targetPlaceable.width, inHeight: targetPlaceable.height, alignment: alignment)
            if !isOverlay {
                dependentPlaceable.placeRelative(x: x, y: y)
            }
            targetPlaceable.placeRelative(x: 0, y: 0)
            if isOverlay {
                dependentPlaceable.placeRelative(x: x, y: y)
            }
        }
    }
}

/// Layout the given view to ignore the given safe areas.
@Composable func IgnoresSafeAreaLayout(view: View, edges: Edge.Set, context: ComposeContext) {
    IgnoresSafeAreaLayout(edges: edges, context: context) { view.Compose($0) }
}

@Composable func IgnoresSafeAreaLayout(edges: Edge.Set, context: ComposeContext, target: @Composable (ComposeContext) -> Void) {
    guard !edges.isEmpty, let safeArea = EnvironmentValues.shared._safeArea else {
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
    var leftPx = 0
    var rightPx = 0
    if edges.contains(.leading) {
        if LocalLayoutDirection.current == androidx.compose.ui.unit.LayoutDirection.Rtl {
            rightPx = Int(safeArea.presentationBoundsPx.right - safeArea.safeBoundsPx.right)
            safeRight = safeArea.presentationBoundsPx.right
        } else {
            leftPx = Int(safeArea.safeBoundsPx.left - safeArea.presentationBoundsPx.left)
            safeLeft = safeArea.presentationBoundsPx.left
        }
    }
    if edges.contains(.trailing) {
        if LocalLayoutDirection.current == androidx.compose.ui.unit.LayoutDirection.Rtl {
            leftPx = Int(safeArea.safeBoundsPx.left - safeArea.presentationBoundsPx.left)
            safeLeft = safeArea.presentationBoundsPx.left
        } else {
            rightPx = Int(safeArea.presentationBoundsPx.right - safeArea.safeBoundsPx.right)
            safeRight = safeArea.presentationBoundsPx.right
        }
    }
    if topPx == 0 && bottomPx == 0 && leftPx == 0 && rightPx == 0 {
        target(context)
        return
    }

    let contentContext = context.content()
    let contentSafeBounds = Rect(top: safeTop, left: safeLeft, bottom: safeBottom, right: safeRight)
    let contentSafeArea = SafeArea(presentation: safeArea.presentationBoundsPx, safe: contentSafeBounds, absoluteSystemBars: safeArea.absoluteSystemBarEdges)
    EnvironmentValues.shared.setValues {
        $0.set_safeArea(contentSafeArea)
    } in: {
        Layout(modifier: context.modifier, content: {
            target(contentContext)
        }) { measurables, constraints in
            let updatedConstraints = constraints.copy(maxWidth: constraints.maxWidth + leftPx + rightPx, maxHeight: constraints.maxHeight + topPx + bottomPx)
            let targetPlaceable = measurables[0].measure(updatedConstraints)
            layout(width: targetPlaceable.width, height: targetPlaceable.height) {
                // Layout will center extra space by default
                let relativeTopPx = topPx - ((topPx + bottomPx) / 2)
                let relativeLeftPx = leftPx - ((leftPx + rightPx) / 2)
                targetPlaceable.placeRelative(x = -relativeLeftPx, y = -relativeTopPx)
            }
        }
    }
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
