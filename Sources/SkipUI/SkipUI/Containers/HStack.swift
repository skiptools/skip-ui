// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

#if !SKIP_BRIDGE
#if SKIP
import androidx.compose.animation.AnimatedContent
import androidx.compose.animation.EnterTransition
import androidx.compose.animation.ExitTransition
import androidx.compose.animation.ExperimentalAnimationApi
import androidx.compose.animation.SizeTransform
import androidx.compose.animation.togetherWith
import androidx.compose.animation.core.snap
import androidx.compose.animation.core.tween
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Row
import androidx.compose.runtime.Composable
import androidx.compose.runtime.remember
import androidx.compose.ui.Modifier
import androidx.compose.ui.unit.dp
#elseif canImport(CoreGraphics)
import struct CoreGraphics.CGFloat
import struct CoreGraphics.CGRect
import struct CoreGraphics.CGSize
#endif

// SKIP @bridge
public struct HStack : View {
    let alignment: VerticalAlignment
    let spacing: CGFloat?
    let content: ComposeBuilder

    public init(alignment: VerticalAlignment = .center, spacing: CGFloat? = nil, @ViewBuilder content: () -> any View) {
        self.alignment = alignment
        self.spacing = spacing
        self.content = ComposeBuilder.from(content)
    }

    // SKIP @bridge
    public init(alignmentKey: String, spacing: CGFloat?, anyContent: Any?) {
        self.alignment = VerticalAlignment(key: alignmentKey)
        self.spacing = spacing
        self.content = ComposeBuilder.from { (anyContent as? any View) ?? EmptyView() }
    }

    #if SKIP
    @Composable public override func ComposeContent(context: ComposeContext) {
        let rowAlignment = alignment.asComposeAlignment()
        let rowArrangement = Arrangement.spacedBy((spacing ?? 8.0).dp, alignment: androidx.compose.ui.Alignment.CenterHorizontally)

        let views = content.collectViews(context: context)
        let idMap: (View) -> Any? = { TagModifierView.strip(from: $0, role: ComposeModifierRole.id)?.value }
        let ids = views.compactMap(idMap)
        let rememberedIds = remember { mutableSetOf<Any>() }
        let newIds = ids.filter { !rememberedIds.contains(it) }
        let rememberedNewIds = remember { mutableSetOf<Any>() }

        rememberedNewIds.addAll(newIds)
        rememberedIds.clear()
        rememberedIds.addAll(ids)

        if ids.count < views.count {
            rememberedNewIds.clear()
            let contentContext = context.content()
            ComposeContainer(axis: .horizontal, modifier: context.modifier) { modifier in
                Row(modifier: modifier, horizontalArrangement: rowArrangement, verticalAlignment: rowAlignment) {
                    let fillWidthModifier = Modifier.weight(Float(1.0)) // Only available in Row context
                    EnvironmentValues.shared.setValues {
                        $0.set_fillWidthModifier(fillWidthModifier)
                    } in: {
                        views.forEach { $0.Compose(context: contentContext) }
                    }
                }
            }
        } else {
            ComposeContainer(axis: .horizontal, modifier: context.modifier) { modifier in
                let arguments = AnimatedContentArguments(views: views, idMap: idMap, ids: ids, rememberedIds: rememberedIds, newIds: newIds, rememberedNewIds: rememberedNewIds, composer: nil)
                ComposeAnimatedContent(context: context, modifier: modifier, arguments: arguments, rowAlignment: rowAlignment, rowArrangement: rowArrangement)
            }
        }
    }

    // SKIP INSERT: @OptIn(ExperimentalAnimationApi::class)
    @Composable private func ComposeAnimatedContent(context: ComposeContext, modifier: Modifier, arguments: AnimatedContentArguments, rowAlignment: androidx.compose.ui.Alignment.Vertical, rowArrangement: Arrangement.Horizontal) {
        AnimatedContent(modifier: modifier, targetState: arguments.views, transitionSpec: {
            EnterTransition.None.togetherWith(ExitTransition.None).using(SizeTransform(clip: false) { initialSize, targetSize in
                 if initialSize.width <= 0 || initialSize.height <= 0 {
                     // When starting at zero size, immediately go to target size so views animate into proper place
                     snap()
                 } else if targetSize.width > initialSize.width || targetSize.height > initialSize.height {
                     // Animate expansion so views slide into place
                     tween()
                 } else {
                     // Delay contraction to give old view time to leave
                     snap(delayMillis: Int(defaultAnimationDuration * 1000))
                 }
             })
        }, contentKey: {
            $0.map(arguments.idMap)
        }, content: { state in
            let animation = Animation.current(isAnimating: transition.isRunning)
            if animation == nil {
                arguments.rememberedNewIds.clear()
            }
            Row(horizontalArrangement: rowArrangement, verticalAlignment: rowAlignment) {
                let fillWidthModifier = Modifier.weight(Float(1.0)) // Only available in Row context
                EnvironmentValues.shared.setValues {
                    $0.set_fillWidthModifier(fillWidthModifier)
                } in: {
                    for view in state {
                        let id = arguments.idMap(view)
                        var modifier: Modifier = Modifier
                        if let animation, arguments.newIds.contains(id) || arguments.rememberedNewIds.contains(id) || !arguments.ids.contains(id) {
                            let transition = TransitionModifierView.transition(for: view) ?? OpacityTransition.shared
                            let spec = animation.asAnimationSpec()
                            let enter = transition.asEnterTransition(spec: spec)
                            let exit = transition.asExitTransition(spec: spec)
                            modifier = modifier.animateEnterExit(enter: enter, exit: exit)
                        }
                        view.Compose(context: context.content(modifier: modifier))
                    }
                }
            }
        }, label: "HStack")
    }
    #else
    public var body: some View {
        stubView()
    }
    #endif
}

#if false
/// A horizontal container that you can use in conditional layouts.
///
/// This layout container behaves like an ``HStack``, but conforms to the
/// ``Layout`` protocol so you can use it in the conditional layouts that you
/// construct with ``AnyLayout``. If you don't need a conditional layout, use
/// ``HStack`` instead.
@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
@frozen public struct HStackLayout : Layout {
    /// The vertical alignment of subviews.
    public var alignment: VerticalAlignment { get { fatalError() } }

    /// The distance between adjacent subviews.
    ///
    /// Set this value to `nil` to use default distances between subviews.
    public var spacing: CGFloat?

    /// Creates a horizontal stack with the specified spacing and vertical
    /// alignment.
    ///
    /// - Parameters:
    ///     - alignment: The guide for aligning the subviews in this stack. It
    ///       has the same vertical screen coordinate for all subviews.
    ///     - spacing: The distance between adjacent subviews. Set this value
    ///       to `nil` to use default distances between subviews.
    @inlinable public init(alignment: VerticalAlignment = .center, spacing: CGFloat? = nil) { fatalError() }

    /// The type defining the data to animate.
    public typealias AnimatableData = EmptyAnimatableData
    public var animatableData: AnimatableData { get { fatalError() } set { } }

    /// Cached values associated with the layout instance.
    ///
    /// If you create a cache for your custom layout, you can use
    /// a type alias to define this type as your data storage type.
    /// Alternatively, you can refer to the data storage type directly in all
    /// the places where you work with the cache.
    ///
    /// See ``makeCache(subviews:)-23agy`` for more information.
    public typealias Cache = Any

    public func makeCache(subviews: Subviews) -> Cache {
        fatalError()
    }

    public func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout Cache) -> CGSize {
        fatalError()
    }

    public func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout Cache) {
    }
}

@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
extension HStackLayout : Sendable {
}
#endif
#endif
