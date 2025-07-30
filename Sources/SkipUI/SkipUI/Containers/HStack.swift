// Copyright 2023–2025 Skip
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception
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
import androidx.compose.foundation.layout.width
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
public struct HStack : View, Renderable {
    let alignment: VerticalAlignment
    let spacing: CGFloat?
    let content: ComposeBuilder
    let isBridged: Bool

    private static let defaultSpacing = 8.0

    public init(alignment: VerticalAlignment = .center, spacing: CGFloat? = nil, @ViewBuilder content: () -> any View) {
        self.alignment = alignment
        self.spacing = spacing
        self.content = ComposeBuilder.from(content)
        self.isBridged = false
    }

    // SKIP @bridge
    public init(alignmentKey: String, spacing: CGFloat?, bridgedContent: any View) {
        self.alignment = VerticalAlignment(key: alignmentKey)
        self.spacing = spacing == nil ? nil : spacing!
        self.content = ComposeBuilder.from { bridgedContent }
        self.isBridged = true
    }

    #if SKIP
    @Composable override func Render(context: ComposeContext) {
        let renderables = content.Evaluate(context: context, options: 0).filter { !$0.isSwiftUIEmptyView }
        let layoutImplementationVersion = EnvironmentValues.shared._layoutImplementationVersion

        var hasSpacers = false
        if layoutImplementationVersion > 0 {
            // Assign positional default spacing to any Spacer between non-Spacers
            let firstNonSpacerIndex = renderables.indexOfFirst { !($0.strip() is Spacer) }
            let lastNonSpacerIndex = renderables.indexOfLast { !($0.strip() is Spacer) }
            for i in (firstNonSpacerIndex + 1)..<lastNonSpacerIndex {
                if let spacer = renderables[i].strip() as? Spacer {
                    hasSpacers = true
                    spacer.positionalMinLength = Self.defaultSpacing
                }
            }
            hasSpacers = hasSpacers || firstNonSpacerIndex > 0 || (lastNonSpacerIndex > 0 && lastNonSpacerIndex < renderables.size - 1)
        }

        let rowAlignment = alignment.asComposeAlignment()
        let rowArrangement: Arrangement.Horizontal
        // Compose's internal arrangement code puts space between all elements, but we do not want to add space
        // around `Spacers`. So we arrange with no spacing and add our own spacing elements
        let adaptiveSpacing = spacing != 0.0 && hasSpacers
        if adaptiveSpacing {
            rowArrangement = Arrangement.spacedBy(0.dp, alignment: androidx.compose.ui.Alignment.CenterHorizontally)
        } else {
            rowArrangement = Arrangement.spacedBy((spacing ?? Self.defaultSpacing).dp, alignment: androidx.compose.ui.Alignment.CenterHorizontally)
        }

        let idMap: (Renderable) -> Any? = { TagModifier.on(content: $0, role: .id)?.value }
        let ids = renderables.mapNotNull(idMap)
        let rememberedIds = remember { mutableSetOf<Any>() }
        let newIds = ids.filter { !rememberedIds.contains($0) }
        let rememberedNewIds = remember { mutableSetOf<Any>() }

        rememberedNewIds.addAll(newIds)
        rememberedIds.clear()
        rememberedIds.addAll(ids)

        if ids.size < renderables.size {
            rememberedNewIds.clear()
            let contentContext = context.content()
            ComposeContainer(axis: .horizontal, modifier: context.modifier) { modifier in
                if layoutImplementationVersion == 0 {
                    // Maintain previous layout behavior for users who opt in
                    Row(modifier: modifier, horizontalArrangement: rowArrangement, verticalAlignment: rowAlignment) {
                        let flexibleWidthModifier: (Float?, Float?, Float?) -> Modifier = { ideal, min, max in
                            var modifier: Modifier = Modifier
                            if max?.isFlexibleExpanding == true {
                                modifier = modifier.weight(Float(1)) // Only available in Row context
                            }
                            return modifier.applyNonExpandingFlexibleWidth(ideal: ideal, min: min, max: max)
                        }
                        EnvironmentValues.shared.setValues {
                            $0.set_flexibleWidthModifier(flexibleWidthModifier)
                            return ComposeResult.ok
                        } in: {
                            var lastWasSpacer: Bool? = nil
                            for renderable in renderables {
                                lastWasSpacer = RenderSpaced(renderable: renderable, adaptiveSpacing: adaptiveSpacing, lastWasSpacer: lastWasSpacer, layoutImplementationVersion: layoutImplementationVersion, context: contentContext)
                            }
                        }
                    }
                } else {
                    HStackRow(modifier: modifier, horizontalArrangement: rowArrangement, verticalAlignment: rowAlignment) {
                        let flexibleWidthModifier: (Float?, Float?, Float?) -> Modifier = {
                            return Modifier.flexible($0, $1, $2) // Only available in HStackRow context
                        }
                        EnvironmentValues.shared.setValues {
                            $0.set_flexibleWidthModifier(flexibleWidthModifier)
                            return ComposeResult.ok
                        } in: {
                            var lastWasSpacer: Bool? = nil
                            for renderable in renderables {
                                lastWasSpacer = RenderSpaced(renderable: renderable, adaptiveSpacing: adaptiveSpacing, lastWasSpacer: lastWasSpacer, layoutImplementationVersion: layoutImplementationVersion, context: contentContext)
                            }
                        }
                    }
                }
            }
        } else {
            ComposeContainer(axis: .horizontal, modifier: context.modifier) { modifier in
                let arguments = AnimatedContentArguments(renderables: renderables, idMap: idMap, ids: ids, rememberedIds: rememberedIds, newIds: newIds, rememberedNewIds: rememberedNewIds, isBridged: isBridged)
                RenderAnimatedContent(context: context, modifier: modifier, arguments: arguments, rowAlignment: rowAlignment, rowArrangement: rowArrangement, adaptiveSpacing: adaptiveSpacing, layoutImplementationVersion: layoutImplementationVersion)
            }
        }
    }

    // SKIP INSERT: @OptIn(ExperimentalAnimationApi::class)
    @Composable private func RenderAnimatedContent(context: ComposeContext, modifier: Modifier, arguments: AnimatedContentArguments, rowAlignment: androidx.compose.ui.Alignment.Vertical, rowArrangement: Arrangement.Horizontal, adaptiveSpacing: Bool, layoutImplementationVersion: Int) {
        AnimatedContent(modifier: modifier, targetState: arguments.renderables, transitionSpec: {
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
            if layoutImplementationVersion == 0 {
                // Maintain previous layout behavior for users who opt in
                Row(horizontalArrangement: rowArrangement, verticalAlignment: rowAlignment) {
                    let flexibleWidthModifier: (Float?, Float?, Float?) -> Modifier = { ideal, min, max in
                        var modifier: Modifier = Modifier
                        if max?.isFlexibleExpanding == true {
                            modifier = modifier.weight(Float(1)) // Only available in Row context
                        }
                        return modifier.applyNonExpandingFlexibleWidth(ideal: ideal, min: min, max: max)
                    }
                    EnvironmentValues.shared.setValues {
                        $0.set_flexibleWidthModifier(flexibleWidthModifier)
                        return ComposeResult.ok
                    } in: {
                        var lastWasSpacer: Bool? = nil
                        for renderable in state {
                            let id = arguments.idMap(renderable)
                            var modifier: Modifier = Modifier
                            if let animation, arguments.newIds.contains(id) || arguments.rememberedNewIds.contains(id) || !arguments.ids.contains(id) {
                                let transition = TransitionModifier.transition(for: renderable) ?? OpacityTransition.shared
                                let spec = animation.asAnimationSpec()
                                let enter = transition.asEnterTransition(spec: spec)
                                let exit = transition.asExitTransition(spec: spec)
                                modifier = modifier.animateEnterExit(enter: enter, exit: exit)
                            }
                            let contentContext = context.content(modifier: modifier)
                            lastWasSpacer = RenderSpaced(renderable: renderable, adaptiveSpacing: adaptiveSpacing, lastWasSpacer: lastWasSpacer, layoutImplementationVersion: layoutImplementationVersion, context: contentContext)
                        }
                    }
                }
            } else {
                HStackRow(horizontalArrangement: rowArrangement, verticalAlignment: rowAlignment) {
                    let flexibleWidthModifier: (Float?, Float?, Float?) -> Modifier = {
                        return Modifier.flexible($0, $1, $2) // Only available in HStackRow context
                    }
                    EnvironmentValues.shared.setValues {
                        $0.set_flexibleWidthModifier(flexibleWidthModifier)
                        return ComposeResult.ok
                    } in: {
                        var lastWasSpacer: Bool? = nil
                        for renderable in state {
                            let id = arguments.idMap(renderable)
                            var modifier: Modifier = Modifier
                            if let animation, arguments.newIds.contains(id) || arguments.rememberedNewIds.contains(id) || !arguments.ids.contains(id) {
                                let transition = TransitionModifier.transition(for: renderable) ?? OpacityTransition.shared
                                let spec = animation.asAnimationSpec()
                                let enter = transition.asEnterTransition(spec: spec)
                                let exit = transition.asExitTransition(spec: spec)
                                modifier = modifier.animateEnterExit(enter: enter, exit: exit)
                            }
                            let contentContext = context.content(modifier: modifier)
                            lastWasSpacer = RenderSpaced(renderable: renderable, adaptiveSpacing: adaptiveSpacing, lastWasSpacer: lastWasSpacer, layoutImplementationVersion: layoutImplementationVersion, context: contentContext)
                        }
                    }
                }
            }
        }, label: "HStack")
    }

    @Composable private func RenderSpaced(renderable: Renderable, adaptiveSpacing: Bool, lastWasSpacer: Bool?, layoutImplementationVersion: Int, context: ComposeContext) -> Bool? {
        guard adaptiveSpacing else {
            renderable.Render(context: context)
            return nil
        }

        // Add spacing before any non-Spacer
        let isSpacer = renderable.strip() is Spacer
        if let lastWasSpacer, !lastWasSpacer && !isSpacer {
            androidx.compose.foundation.layout.Spacer(modifier: Modifier.width((spacing ?? Self.defaultSpacing).dp))
        }
        renderable.Render(context: context)
        return isSpacer
    }
    #else
    public var body: some View {
        stubView()
    }
    #endif
}

/*
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
*/
#endif
