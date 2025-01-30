// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

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
    public init(anyViews: [Any?]) {
        #if SKIP
        self.content = { context in
            anyViews.forEach { ($0 as? View)?.Compose(context: context) }
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
    ///   `content` elevates to our void `ComposeContent` function. This allows us to prepare for recompositions, e.g. making the proper callbacks to the context's `composer`.
    public init(content: @Composable (ComposeContext) -> ComposeResult) {
        self.content = content
    }

    @Composable public override func Compose(context: ComposeContext) -> ComposeResult {
        // If there is a composer that should recompose its caller, we execute it here so that its result escapes.
        // Otherwise we wait for ComposeContent where recomposes don't affect the caller
        if let composer = context.composer as? SideEffectComposer {
            return content(context)
        } else {
            ComposeContent(context)
            return ComposeResult.ok
        }
    }

    @Composable public override func ComposeContent(context: ComposeContext) {
        if let composer = context.composer as? RenderingComposer {
            composer.willCompose()
            let result = content(context)
            composer.didCompose(result: result)
        } else {
            content(context)
        }
    }

    /// Use a custom composer to collect the views composed within this view.
    @Composable public func collectViews(context: ComposeContext) -> [View] {
        var views: [View] = []
        let viewCollectingContext = context.content(composer: SideEffectComposer { view, _ in
            views.append(view)
            return ComposeResult.ok
        })
        content(viewCollectingContext)
        return views
    }
    #else
    public var body: some View {
        stubView()
    }
    #endif
}

#endif
