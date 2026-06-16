// Copyright 2023–2026 Skip
// SPDX-License-Identifier: MPL-2.0
#if !SKIP_BRIDGE
#if SKIP
import androidx.compose.animation.AnimatedContent
import androidx.compose.animation.EnterTransition
import androidx.compose.animation.ExitTransition
import androidx.compose.animation.SizeTransform
import androidx.compose.animation.togetherWith
import androidx.compose.animation.core.snap
import androidx.compose.animation.core.tween
import androidx.compose.foundation.layout.Box
import androidx.compose.runtime.Composable
import androidx.compose.runtime.remember
import androidx.compose.ui.Modifier
#elseif canImport(CoreGraphics)
import struct CoreGraphics.CGRect
import struct CoreGraphics.CGSize
#endif

// SKIP @bridge
public struct ZStack : View, Renderable {
    let alignment: Alignment
    let content: ComposeBuilder
    let isBridged: Bool

    public init(alignment: Alignment = .center, @ViewBuilder content: () -> any View) {
        self.alignment = alignment
        self.content = ComposeBuilder.from(content)
        self.isBridged = false
    }

    // SKIP @bridge
    public init(horizontalAlignmentKey: String, verticalAlignmentKey: String, bridgedContent: any View) {
        self.alignment = Alignment(horizontal: HorizontalAlignment(key: horizontalAlignmentKey), vertical: VerticalAlignment(key: verticalAlignmentKey))
        self.content = ComposeBuilder.from { bridgedContent }
        self.isBridged = true
    }

    #if SKIP
    @Composable override func Render(context: ComposeContext) {
        let renderables = content.Evaluate(context: context, options: 0).filter { !$0.isSwiftUIEmptyView }
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
            ComposeContainer(eraseAxis: true, modifier: context.modifier) { modifier in
                Box(modifier: modifier, contentAlignment: alignment.asComposeAlignment()) {
                    // Key each child by its identity so per-child remembered state (e.g. the
                    // `Animatable`s behind `.position`/`.frame`/`.fill`) follows the child
                    // rather than its index in this Box. Without a key, composing children in
                    // a positional loop binds their `remember` slots to position, so mutating
                    // the child list (a middle child inserted/removed, a conditional child
                    // toggling) shifts every later child's slot and leaks one child's
                    // animation state into another — e.g. a view jumps to a sibling's animated
                    // position or briefly adopts its color. See `childKey`.
                    let occurrences = mutableMapOf<Any, Int>()
                    for index in 0..<renderables.size {
                        let renderable = renderables[index]
                        let key = childKey(for: renderable, index: index, occurrences: occurrences)
                        androidx.compose.runtime.key(key) {
                            renderable.Render(context: contentContext)
                        }
                    }
                }
            }
        } else {
            ComposeContainer(eraseAxis: true, modifier: context.modifier) { modifier in
                let arguments = AnimatedContentArguments(renderables: renderables, idMap: idMap, ids: ids, rememberedIds: rememberedIds, newIds: newIds, rememberedNewIds: rememberedNewIds, isBridged: isBridged)
                RenderAnimatedContent(context: context, modifier: modifier, arguments: arguments)
            }
        }
    }

    @Composable private func RenderAnimatedContent(context: ComposeContext, modifier: Modifier, arguments: AnimatedContentArguments) {
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
            Box(contentAlignment: alignment.asComposeAlignment()) {
                let occurrences = mutableMapOf<Any, Int>()
                for index in 0..<state.size {
                    let renderable = state[index]
                    let id = arguments.idMap(renderable)
                    var modifier: Modifier = Modifier
                    if let animation, arguments.newIds.contains(id) || arguments.rememberedNewIds.contains(id) || !arguments.ids.contains(id) {
                        let transition = TransitionModifier.transition(for: renderable) ?? OpacityTransition.shared
                        let spec = animation.asAnimationSpec()
                        let enter = transition.asEnterTransition(spec: spec)
                        let exit = transition.asExitTransition(spec: spec)
                        modifier = modifier.animateEnterExit(enter: enter, exit: exit)
                    }
                    // Key by identity so per-child remembered state follows the child rather
                    // than its index — see the matching note in `Render`.
                    let key = childKey(for: renderable, index: index, occurrences: occurrences)
                    androidx.compose.runtime.key(key) {
                        renderable.Render(context: context.content(modifier: modifier))
                    }
                }
            }
        }, label: "ZStack")
    }

    /// A stable, collision-free Compose key for a child of this stack.
    ///
    /// Identity is the child's explicit `.id()` or `ForEach` id when present, falling back to
    /// the child's index for untagged children (preserving the prior positional behavior for
    /// those). Duplicate identities — e.g. a nested `ForEach` whose inner ids repeat across
    /// outer iterations — are disambiguated by occurrence count, so the returned key is always
    /// unique within a single composition (no Compose "key already used" crash) yet stable
    /// across recompositions whenever the child set is stable.
    private func childKey(for renderable: Renderable, index: Int, occurrences: MutableMap<Any, Int>) -> Any {
        let identity: Any = TagModifier.on(content: renderable, role: .id)?.value
            ?? TagModifier.on(content: renderable, role: .tag)?.value
            ?? index
        let occurrence = occurrences[identity] ?? 0
        occurrences[identity] = occurrence + 1
        return listOf(identity, occurrence)
    }
    #else
    public var body: some View {
        stubView()
    }
    #endif
}

/*
/// An overlaying container that you can use in conditional layouts.
///
/// This layout container behaves like a ``ZStack``, but conforms to the
/// ``Layout`` protocol so you can use it in the conditional layouts that you
/// construct with ``AnyLayout``. If you don't need a conditional layout, use
/// ``ZStack`` instead.
@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
@frozen public struct ZStackLayout : Layout {
    /// The alignment of subviews.
    public var alignment: Alignment { get { fatalError() } }

    /// Creates a stack with the specified alignment.
    ///
    /// - Parameters:
    ///   - alignment: The guide for aligning the subviews in this stack
    ///     on both the x- and y-axes.
    @inlinable public init(alignment: Alignment = .center) { fatalError() }

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
    public typealias Cache = Void

    public func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout Void) -> CGSize {
        fatalError()
    }

    public func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout Void) {
        fatalError()
    }
}

@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
extension ZStackLayout : Sendable {
}
*/
#endif
