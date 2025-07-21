// Copyright 2023–2025 Skip
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception
#if !SKIP_BRIDGE
#if SKIP
import androidx.compose.runtime.Composable
#endif

/// Used to wrap the content of SwiftUI `@ViewBuilders` for rendering by Compose.
// SKIP @bridge
public struct ComposeBuilder: View {
    #if SKIP
    private let content: @Composable (ComposeContext) -> ComposeResult
    #endif

    /// If the result of the given block is a `ComposeBuilder` return it, else create a `ComposeBuilder` whose content is the
    /// resulting view.
    public static func from(_ content: () -> any View) -> ComposeBuilder {
        let view = content()
        return view as? ComposeBuilder ?? ComposeBuilder(view: view)
    }

    /// Construct with static content.
    ///
    /// Used primarily when manually constructing views for internal use.
    public init(view: any View) {
        #if SKIP
        self.content = { context in
            return view.Compose(context: context)
        }
        #endif
    }

    // SKIP @bridge
    public init(bridgedViews: [any View]) {
        #if SKIP
        self.content = { context in
            bridgedViews.forEach { $0.Compose(context: context) }
            return ComposeResult.ok
        }
        #endif
    }

    #if SKIP
    /// Constructor.
    ///
    /// The supplied `content` is the content to compose. When transpiling SwiftUI code, this is the logic embedded in the user's `body` and within each container view in
    /// that `body`, as well as within other `@ViewBuilders`.
    ///
    /// - Note: Returning a result from `content` is important. This prevents Compose from recomposing `content` on its own. Instead, a change that would recompose
    ///   `content` elevates to our void `Renderable.Render`. This allows us to prepare for recompositions, e.g. making the proper callbacks to the context's `composer`.
    public init(content: @Composable (ComposeContext) -> ComposeResult) {
        self.content = content
    }

    @Composable public override func Compose(context: ComposeContext) -> ComposeResult {
        return content(context)
    }

    @Composable public override func Evaluate(context: ComposeContext, options: Int) -> kotlin.collections.List<Renderable> {
        let renderables: kotlin.collections.MutableList<Renderable> = mutableListOf()
        let isKeepNonModified = EvaluateOptions(options).isKeepNonModified
        let evalContext = context.content(composer: Composer { view, context in
            // This logic is also in `ModifiedContent`, but we need to check here as well in case no modifiers are used
            if isKeepNonModified && !(view is ModifiedContent) {
                renderables.add(view.asRenderable())
            } else {
                renderables.addAll(view.Evaluate(context: context(false), options: options))
            }
            return ComposeResult.ok
        })
        content(evalContext)
        return renderables
    }
    #else
    public var body: some View {
        stubView()
    }
    #endif
}
#endif
