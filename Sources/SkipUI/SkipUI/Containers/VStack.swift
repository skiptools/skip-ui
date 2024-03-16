// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

#if SKIP
import androidx.compose.animation.AnimatedContent
import androidx.compose.animation.EnterTransition
import androidx.compose.animation.ExitTransition
import androidx.compose.animation.ExperimentalAnimationApi
import androidx.compose.animation.togetherWith
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.height
import androidx.compose.runtime.Composable
import androidx.compose.runtime.remember
import androidx.compose.ui.Modifier
import androidx.compose.ui.unit.dp
#else
import struct CoreGraphics.CGFloat
import struct CoreGraphics.CGRect
import struct CoreGraphics.CGSize
#endif

public struct VStack : View {
    let alignment: HorizontalAlignment
    let spacing: CGFloat?
    let content: ComposeBuilder

    public init(alignment: HorizontalAlignment = .center, spacing: CGFloat? = nil, @ViewBuilder content: () -> any View) {
        self.alignment = alignment
        self.spacing = spacing
        self.content = ComposeBuilder.from(content)
    }

    #if SKIP
    // SKIP INSERT: @OptIn(ExperimentalAnimationApi::class)
    @Composable public override func ComposeContent(context: ComposeContext) {
        let columnAlignment: androidx.compose.ui.Alignment.Horizontal
        switch alignment {
        case .leading:
            columnAlignment = androidx.compose.ui.Alignment.Start
        case .trailing:
            columnAlignment = androidx.compose.ui.Alignment.End
        default:
            columnAlignment = androidx.compose.ui.Alignment.CenterHorizontally
        }

        let views = content.collectViews(context: context)
        let idMap: (View) -> Any? = { TagModifierView.strip(from = it, role = ComposeModifierRole.id)?.value }
        let ids = views.compactMap(idMap)
        let rememberedIds = remember { mutableSetOf<Any>() }
        let newIds = ids.filter { !rememberedIds.contains(it) }
        let rememberedNewIds = remember { mutableSetOf<Any>() }

        rememberedNewIds.addAll(newIds)
        rememberedIds.clear()
        rememberedIds.addAll(ids)

        let composer: VStackComposer?
        let columnArrangement: Arrangement.Vertical
        if let spacing {
            composer = nil
            columnArrangement = Arrangement.spacedBy(spacing.dp, alignment: androidx.compose.ui.Alignment.CenterVertically)
        } else {
            composer = VStackComposer()
            columnArrangement = Arrangement.spacedBy(0.dp, alignment: androidx.compose.ui.Alignment.CenterVertically)
        }

        if ids.count < views.count {
            rememberedNewIds.clear()
            let contentContext = context.content(composer: composer)
            ComposeContainer(axis: .vertical, modifier: context.modifier) { modifier in
                Column(modifier: modifier, verticalArrangement: columnArrangement, horizontalAlignment: columnAlignment) {
                    let fillHeightModifier = Modifier.weight(Float(1.0)) // Only available in Column context
                    EnvironmentValues.shared.setValues {
                        $0.set_fillHeightModifier(fillHeightModifier)
                    } in: {
                        composer?.willCompose()
                        views.forEach { $0.Compose(context: contentContext) }
                        composer?.didCompose(result: ComposeResult.ok)
                    }
                }
            }
        } else {
            ComposeContainer(axis: .horizontal, modifier: context.modifier) { modifier in
                AnimatedContent(modifier: modifier, targetState: views, transitionSpec: {
                    // SKIP INSERT: EnterTransition.None togetherWith ExitTransition.None
                }, contentKey: {
                    $0.map(idMap)
                }, content: { state in
                    let animation = Animation.current(isAnimating: self.transition.isRunning)
                    if animation == nil {
                        rememberedNewIds.clear()
                    }
                    Column(verticalArrangement: columnArrangement, horizontalAlignment: columnAlignment) {
                        let fillHeightModifier = Modifier.weight(Float(1.0)) // Only available in Column context
                        EnvironmentValues.shared.setValues {
                            $0.set_fillHeightModifier(fillHeightModifier)
                        } in: {
                            composer?.willCompose()
                            for view in state {
                                let id = idMap(view)
                                var modifier: Modifier = Modifier
                                if let animation, newIds.contains(id) || rememberedNewIds.contains(id) || !ids.contains(id) {
                                    let transition = TransitionModifierView.transition(for: view) ?? OpacityTransition.shared
                                    let spec = animation.asAnimationSpec()
                                    let enter = transition.asEnterTransition(spec: spec)
                                    let exit = transition.asExitTransition(spec: spec)
                                    modifier = modifier.animateEnterExit(enter: enter, exit: exit)
                                }
                                let contentContext = context.content(modifier: modifier, composer: composer)
                                view.Compose(context: contentContext)
                            }
                            composer?.didCompose(result: ComposeResult.ok)
                        }
                    }
                }, label: "VStack")
            }
        }
    }
    #else
    public var body: some View {
        stubView()
    }
    #endif
}

#if SKIP
final class VStackComposer: RenderingComposer {
    private static let defaultSpacing = 8.0
    // SwiftUI spaces adaptively based on font, etc, but this is at least closer to SwiftUI than our defaultSpacing
    private static let textSpacing = 1.0

    private var lastViewWasText: Bool? = nil

    override func willCompose() {
        lastViewWasText = nil
    }

    @Composable override func Compose(view: View, context: (Bool) -> ComposeContext) {
        guard !view.isSwiftUIEmptyView else {
            return
        }
        // If the Text has spacing modifiers, no longer special case its spacing
        let isText = view.strippingModifiers(until: { $0 == .spacing }) { $0 is Text }
        var contentContext = context(false)
        if let lastViewWasText {
            let spacing = lastViewWasText && isText ? Self.textSpacing : Self.defaultSpacing
            androidx.compose.foundation.layout.Spacer(modifier: Modifier.height(spacing.dp))
        }
        view.ComposeContent(context: contentContext)
        lastViewWasText = isText
    }
}
#endif

#if false

// TODO: Process for use in SkipUI

/// A vertical container that you can use in conditional layouts.
///
/// This layout container behaves like a ``VStack``, but conforms to the
/// ``Layout`` protocol so you can use it in the conditional layouts that you
/// construct with ``AnyLayout``. If you don't need a conditional layout, use
/// ``VStack`` instead.
@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
@frozen public struct VStackLayout : Layout {

    /// The horizontal alignment of subviews.
    public var alignment: HorizontalAlignment { get { fatalError() } }

    /// The distance between adjacent subviews.
    ///
    /// Set this value to `nil` to use default distances between subviews.
    public var spacing: CGFloat?

    /// Creates a vertical stack with the specified spacing and horizontal
    /// alignment.
    ///
    /// - Parameters:
    ///     - alignment: The guide for aligning the subviews in this stack. It
    ///       has the same horizontal screen coordinate for all subviews.
    ///     - spacing: The distance between adjacent subviews. Set this value
    ///       to `nil` to use default distances between subviews.
    @inlinable public init(alignment: HorizontalAlignment = .center, spacing: CGFloat? = nil) { }

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
extension VStackLayout : Sendable {
}

#endif
