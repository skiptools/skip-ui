// Copyright 2023–2025 Skip
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception
#if !SKIP_BRIDGE
#if SKIP
import androidx.compose.animation.AnimatedContent
import androidx.compose.animation.EnterTransition
import androidx.compose.animation.ExitTransition
import androidx.compose.animation.ExperimentalAnimationApi
import androidx.compose.animation.togetherWith
import androidx.compose.runtime.Composable
import androidx.compose.runtime.remember
import androidx.compose.ui.Modifier
#endif

// SKIP @bridge
public struct Group : View {
    let content: ComposeBuilder
    let isBridged: Bool

    public init(@ViewBuilder content: () -> any View) {
        self.content = ComposeBuilder.from(content)
        self.isBridged = false
    }

    @available(*, unavailable)
    public init(subviews view: any View, @ViewBuilder transform: @escaping (Any /* SubviewsCollection */) -> any View) {
        self.content = ComposeBuilder(view: EmptyView())
        self.isBridged = false
    }

    // SKIP @bridge
    public init(bridgedContent: any View) {
        self.content = ComposeBuilder.from { bridgedContent }
        self.isBridged = true
    }

    #if SKIP
    @Composable public override func Compose(context: ComposeContext) -> ComposeResult {
        ComposeContent(context: context)
        return ComposeResult.ok
    }

    @Composable public override func ComposeContent(context: ComposeContext) {
        let views = content.collectViews(context: context).filter { !($0 is EmptyView) }
        let idMap: (View) -> Any? = { TagModifierView.strip(from = it, role = ComposeModifierRole.id)?.value }
        let ids = views.compactMap(transform = idMap)
        let rememberedIds = remember { mutableSetOf<Any>() }
        let newIds = ids.filter { !rememberedIds.contains($0) }
        let rememberedNewIds = remember { mutableSetOf<Any>() }

        rememberedNewIds.addAll(newIds)
        rememberedIds.clear()
        rememberedIds.addAll(ids)

        if ids.count < views.count {
            views.forEach { $0.Compose(context: context) }
        } else {
            let arguments = AnimatedContentArguments(views: views, idMap: idMap, ids: ids, rememberedIds: rememberedIds, newIds: newIds, rememberedNewIds: rememberedNewIds, composer: nil, isBridged: isBridged)
            ComposeAnimatedContent(context: context, arguments: arguments)
        }
    }

    // Use separate method to avoid recompositions. Recomposing `AnimatedContent` during keyboard animations causes glitches.
    // SKIP INSERT: @OptIn(ExperimentalAnimationApi::class)
    @Composable private func ComposeAnimatedContent(context: ComposeContext, arguments: AnimatedContentArguments) {
        AnimatedContent(targetState: arguments.views, contentAlignment: androidx.compose.ui.Alignment.Center, transitionSpec: {
            // SKIP INSERT: EnterTransition.None togetherWith ExitTransition.None
        }, contentKey: {
            $0.map(arguments.idMap)
        }, content: { state in
            let animation = Animation.current(isAnimating: transition.isRunning)
            if animation == nil {
                arguments.rememberedNewIds.clear()
            }
            for view in state {
                let id = arguments.idMap(view)
                var modifier = context.modifier
                if let animation, arguments.newIds.contains(id) || arguments.rememberedNewIds.contains(id) || !arguments.ids.contains(id) {
                    let transition = TransitionModifierView.transition(for: view) ?? OpacityTransition.shared
                    let spec = animation.asAnimationSpec()
                    let enter = transition.asEnterTransition(spec: spec)
                    let exit = transition.asExitTransition(spec: spec)
                    modifier = modifier.animateEnterExit(enter: enter, exit: exit)
                }
                view.Compose(context: context.content(modifier: modifier))
            }
        }, label: "Group")
    }
    #else
    public var body: some View {
        stubView()
    }
    #endif
}

#endif
