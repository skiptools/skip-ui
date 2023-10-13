// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

#if SKIP
import androidx.compose.runtime.Composable
#endif

// Erase generics to facilitate specialized constructor support.
public struct Section : View, ListItemFactory {
    let header: (any View)?
    let footer: (any View)?
    let content: any View

    public init(@ViewBuilder content: () -> any View, @ViewBuilder header: () -> any View, @ViewBuilder footer: () -> any View) {
        self.header = header()
        self.footer = footer()
        self.content = content()
    }

    public init(@ViewBuilder content: () -> any View, @ViewBuilder footer: () -> any View) {
        self.header = nil
        self.footer = footer()
        self.content = content()
    }

    public init(@ViewBuilder content: () -> any View, @ViewBuilder header: () -> any View) {
        self.header = header()
        self.footer = nil
        self.content = content()
    }

    public init(@ViewBuilder content: () -> any View) {
        self.header = nil
        self.footer = nil
        self.content = content()
    }

    public init(_ titleKey: LocalizedStringKey, @ViewBuilder content: () -> any View) {
        self.init(titleKey.value, content: content)
    }

    public init(_ title: String, @ViewBuilder content: () -> any View) {
        self.init(content: content, header: { Text(title) })
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
    @Composable func appendListItemViews(to views: MutableList<View>, appendingContext: ComposeContext) {
        if let header {
            views.add(ListHeaderView(content: header))
        }
        content.Compose(context: appendingContext)
        if let footer {
            views.add(ListFooterView(content: footer))
        }
    }

    func ComposeListItems(context: ListItemFactoryContext) {
    }
    #else
    public var body: some View {
        stubView()
    }
    #endif
}
