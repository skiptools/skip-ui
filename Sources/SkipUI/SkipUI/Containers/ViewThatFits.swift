// Copyright 2023–2026 Skip
// SPDX-License-Identifier: MPL-2.0
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
                // Compose remeasures any child whose maxIntrinsicWidth/Height was read, then
                // remeasures this Layout if that child is never measure()d, so measure queried losers too.
                var chosenIndex = measurables.size - 1
                var lastQueriedIndex = -1
                for i in 0..<measurables.size {
                    lastQueriedIndex = i
                    var idealWidth = 0
                    var idealHeight = 0
                    if axes.contains(.horizontal) {
                        idealWidth = measurables[i].maxIntrinsicWidth(maxHeight)
                    }
                    if axes.contains(.vertical) {
                        idealHeight = measurables[i].maxIntrinsicHeight(maxWidth)
                    }
                    if fits(measuredWidth: idealWidth, measuredHeight: idealHeight) {
                        chosenIndex = i
                        break
                    }
                }

                let placeable = measurables[chosenIndex].measure(constraints)
                if lastQueriedIndex >= 0 {
                    for i in 0...lastQueriedIndex {
                        if i != chosenIndex {
                            measurables[i].measure(constraints)
                        }
                    }
                }
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
