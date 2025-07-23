// Copyright 2023–2025 Skip
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception
#if !SKIP_BRIDGE
#if SKIP
import androidx.compose.runtime.Composable
#endif

// SKIP @bridge
public struct Group : View {
    let content: ComposeBuilder

    public init(@ViewBuilder content: () -> any View) {
        self.content = ComposeBuilder.from(content)
    }

    @available(*, unavailable)
    public init(subviews view: any View, @ViewBuilder transform: @escaping (Any /* SubviewsCollection */) -> any View) {
        self.content = ComposeBuilder(view: EmptyView())
    }

    @available(*, unavailable)
    public init(sections view: any View, @ViewBuilder transform: @escaping (Any /* SectionCollection */) -> any View) {
        self.content = ComposeBuilder(view: EmptyView())
    }

    // SKIP @bridge
    public init(bridgedContent: any View) {
        self.content = ComposeBuilder.from { bridgedContent }
    }

    #if SKIP
    @Composable override func Evaluate(context: ComposeContext, options: Int) -> kotlin.collections.List<Renderable> {
        return content.Evaluate(context: context, options: options)
    }
    #else
    public var body: some View {
        stubView()
    }
    #endif
}

#endif
