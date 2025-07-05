// Copyright 2023–2025 Skip
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception
#if !SKIP_BRIDGE
import Foundation
#if SKIP
import androidx.compose.runtime.Composable
#endif

// Erase generics to facilitate specialized constructor support.
// SKIP @bridge
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

    public init(_ titleResource: LocalizedStringResource, @ViewBuilder content: () -> any View) {
        self.init(content: content, header: { Text(titleResource) })
    }

    public init(_ title: String, @ViewBuilder content: () -> any View) {
        self.init(content: content, header: { Text(verbatim: title) })
    }

    @available(*, unavailable)
    public init(_ titleKey: LocalizedStringKey, isExpanded: Binding<Bool>, @ViewBuilder content: () -> any View) {
        self.init(titleKey, content: content)
    }

    @available(*, unavailable)
    public init(_ titleResource: LocalizedStringResource, isExpanded: Binding<Bool>, @ViewBuilder content: () -> any View) {
        self.init(titleResource, content: content)
    }

    @available(*, unavailable)
    public init(_ title: String, isExpanded: Binding<Bool>, @ViewBuilder content: () -> any View) {
        self.init(title, content: content)
    }

    @available(*, unavailable)
    public init(isExpanded: Binding<Bool>, @ViewBuilder content: () -> any View, @ViewBuilder header: () -> any View) {
        self.init(content: content, header: header)
    }

    // SKIP @bridge
    public init(bridgedContent: any View, bridgedHeader: (any View)?, bridgedFooter: (any View)?) {
        self.content = ComposeBuilder.from { bridgedContent }
        self.header = bridgedHeader == nil ? nil : ComposeBuilder.from { bridgedHeader! }
        self.footer = bridgedFooter == nil ? nil : ComposeBuilder.from { bridgedFooter! }
    }

    #if SKIP
    @Composable override func ComposeContent(context: ComposeContext) {
        if let header {
            header.Compose(context: context)
        }
        content.Compose(context: context)
        if let footer {
            footer.Compose(context: context)
        }
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

extension View {
    @available(*, unavailable)
    public func sectionIndexLabel(_ label: Text?) -> some View {
        return self
    }

    @available(*, unavailable)
    public func sectionIndexLabel(_ label: String?) -> some View {
        return self
    }
}

#endif
