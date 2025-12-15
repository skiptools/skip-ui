// Copyright 2023–2025 Skip
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception
#if !SKIP_BRIDGE

#if SKIP
import androidx.compose.runtime.Composable
import androidx.compose.ui.layout.Layout
import androidx.compose.ui.unit.Constraints
#elseif canImport(CoreGraphics)
import struct CoreGraphics.CGFloat
#endif

#if SKIP
// SKIP @bridge
public struct ViewThatFits : View, Renderable {
    let axes: Axis.Set
    let content: ComposeBuilder

    public init(in axes: Axis.Set = [.horizontal, .vertical], @ViewBuilder content: () -> any View) {
        self.axes = axes
        self.content = ComposeBuilder.from(content)
    }

    // SKIP @bridge
    public init(bridgedAxes: Int, bridgedContent: any View) {
        self.axes = Axis.Set(rawValue: bridgedAxes)
        self.content = ComposeBuilder.from { bridgedContent }
    }

    @Composable override func Render(context: ComposeContext) {
        let candidates = content.Evaluate(context: context, options: 0).filter { !$0.isSwiftUIEmptyView }
        guard !candidates.isEmpty() else {
            return
        }

        let contentContext = context.content()
        ComposeContainer(modifier: context.modifier) { modifier in
            Layout(modifier: modifier, content: {
                for candidate in candidates {
                    candidate.Render(context: contentContext)
                }
            }) { measurables, constraints in
                guard !measurables.isEmpty() else {
                    return layout(width: 0, height: 0) { }
                }

                let maxWidth = constraints.maxWidth
                let maxHeight = constraints.maxHeight

                func fits(measuredWidth: Int, measuredHeight: Int) -> Bool {
                    if axes.contains(.horizontal) && maxWidth != Constraints.Infinity && measuredWidth > maxWidth {
                        return false
                    }
                    if axes.contains(.vertical) && maxHeight != Constraints.Infinity && measuredHeight > maxHeight {
                        return false
                    }
                    return true
                }

                // Determine each candidate's ideal size using intrinsics with an unconstrained cross-axis,
                // then pick the first that fits within the parent constraints in the specified axes.
                var chosenIndex = measurables.size - 1
                for i in 0..<measurables.size {
                    let idealWidth = measurables[i].maxIntrinsicWidth(Constraints.Infinity)
                    let idealHeight = measurables[i].maxIntrinsicHeight(Constraints.Infinity)
                    if fits(measuredWidth: idealWidth, measuredHeight: idealHeight) {
                        chosenIndex = i
                        break
                    }
                }

                let placeable = measurables[chosenIndex].measure(constraints)
                let layoutWidth = max(constraints.minWidth, placeable.width)
                let layoutHeight = max(constraints.minHeight, placeable.height)
                return layout(width: layoutWidth, height: layoutHeight) {
                    placeable.placeRelative(x: 0, y: 0)
                }
            }
        }
    }
}
#else
public struct ViewThatFits : View {
    public init(in axes: Axis.Set = [.horizontal, .vertical], @ViewBuilder content: () -> any View) {
    }

    public init(bridgedAxes: Int, bridgedContent: any View) {
    }

    public var body: some View {
        stubView()
    }
}
#endif

#endif
