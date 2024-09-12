// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

#if SKIP
import androidx.compose.runtime.Composable
#endif

// Erase generics to facilitate specialized constructor support.
public struct Section : View, LazyItemFactory {
    let header: ComposeBuilder?
    let footer: ComposeBuilder?
    let content: ComposeBuilder

    public init(@ViewBuilder content: () -> any View, @ViewBuilder header: () -> any View, @ViewBuilder footer: () -> any View) {
        self.header = ComposeBuilder.from(header)
        self.footer = ComposeBuilder.from(footer)
        self.content = ComposeBuilder.from(content)
    }

    public init(@ViewBuilder content: () -> any View, @ViewBuilder footer: () -> any View) {
        self.header = nil
        self.footer = ComposeBuilder.from(footer)
        self.content = ComposeBuilder.from(content)
    }

    public init(@ViewBuilder content: () -> any View, @ViewBuilder header: () -> any View) {
        self.header = ComposeBuilder.from(header)
        self.footer = nil
        self.content = ComposeBuilder.from(content)
    }

    public init(header: any View, @ViewBuilder content: () -> any View) {
        self.header = ComposeBuilder.from({ header })
        self.footer = nil
        self.content = ComposeBuilder.from(content)
    }

    public init(@ViewBuilder content: () -> any View) {
        self.header = nil
        self.footer = nil
        self.content = ComposeBuilder.from(content)
    }

    public init(_ titleKey: LocalizedStringKey, @ViewBuilder content: () -> any View) {
        self.init(content: content, header: { Text(titleKey) })
    }

    public init(_ title: String, @ViewBuilder content: () -> any View) {
        self.init(content: content, header: { Text(verbatim: title) })
    }

    @available(*, unavailable)
    public init(_ titleKey: LocalizedStringKey, isExpanded: Binding<Bool>, @ViewBuilder content: () -> any View) {
        self.init(titleKey, content: content)
    }

    @available(*, unavailable)
    public init(_ title: String, isExpanded: Binding<Bool>, @ViewBuilder content: () -> any View) {
        self.init(title, content: content)
    }

    @available(*, unavailable)
    public init(isExpanded: Binding<Bool>, @ViewBuilder content: () -> any View, @ViewBuilder header: () -> any View) {
        self.init(content: content, header: header)
    }

    #if SKIP
    @Composable override func ComposeContent(context: ComposeContext) {
        content.Compose(context: context)
    }

    @Composable func appendLazyItemViews(to composer: LazyItemCollectingComposer, appendingContext: ComposeContext) -> ComposeResult {
        composer.append(LazySectionHeader(content: header ?? EmptyView()))
        content.Compose(context: appendingContext)
        composer.append(LazySectionFooter(content: footer ?? EmptyView()))
        return ComposeResult.ok
    }

    override func composeLazyItems(context: LazyItemFactoryContext, level: Int) {
        // Not called because the section does not append itself as a list item view
    }
    #else
    public var body: some View {
        stubView()
    }
    #endif
}
