// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

#if SKIP
import androidx.compose.runtime.Composable
#endif

// Erase generics to facilitate specialized constructor support.
public struct Section : View, ListItemFactory {
    let header: ComposeView?
    let footer: ComposeView?
    let content: ComposeView

    public init(@ViewBuilder content: () -> ComposeView, @ViewBuilder header: () -> ComposeView, @ViewBuilder footer: () -> ComposeView) {
        self.header = header()
        self.footer = footer()
        self.content = content()
    }

    public init(@ViewBuilder content: () -> ComposeView, @ViewBuilder footer: () -> ComposeView) {
        self.header = nil
        self.footer = footer()
        self.content = content()
    }

    public init(@ViewBuilder content: () -> ComposeView, @ViewBuilder header: () -> ComposeView) {
        self.header = header()
        self.footer = nil
        self.content = content()
    }

    public init(@ViewBuilder content: () -> ComposeView) {
        self.header = nil
        self.footer = nil
        self.content = content()
    }

    public init(_ titleKey: LocalizedStringKey, @ViewBuilder content: () -> ComposeView) {
        self.init(content: content, header: { ComposeView(view: Text(titleKey)) })
    }

    public init(_ title: String, @ViewBuilder content: () -> ComposeView) {
        self.init(content: content, header: { ComposeView(view: Text(verbatim: title)) })
    }

    @available(*, unavailable)
    public init(_ titleKey: LocalizedStringKey, isExpanded: Binding<Bool>, @ViewBuilder content: () -> ComposeView) {
        self.init(titleKey, content: content)
    }

    @available(*, unavailable)
    public init(_ title: String, isExpanded: Binding<Bool>, @ViewBuilder content: () -> ComposeView) {
        self.init(title, content: content)
    }

    @available(*, unavailable)
    public init(isExpanded: Binding<Bool>, @ViewBuilder content: () -> ComposeView, @ViewBuilder header: () -> ComposeView) {
        self.init(content: content, header: header)
    }

    #if SKIP
    @Composable func appendListItemViews(to views: MutableList<View>, appendingContext: ComposeContext) -> ComposeResult {
        if let header {
            views.add(ListSectionHeader(content: header))
        }
        content.Compose(context: appendingContext)
        if let footer {
            views.add(ListSectionFooter(content: footer))
        }
        return ComposeResult.ok
    }

    override func composeListItems(context: ListItemFactoryContext) {
        // Not called because the section does not append itself as a list item view
    }
    #else
    public var body: some View {
        stubView()
    }
    #endif
}
