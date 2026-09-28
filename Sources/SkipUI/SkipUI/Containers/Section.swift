// Copyright 2023–2026 Skip
// SPDX-License-Identifier: MPL-2.0
#if !SKIP_BRIDGE
import Foundation
#if SKIP
import androidx.compose.runtime.Composable
#endif

// SKIP @bridge
public struct Section : View {
    let header: ComposeBuilder?
    let footer: ComposeBuilder?
    let content: ComposeBuilder
    /// Collapses the section's content when false.
    var isExpanded: Binding<Bool>? = nil

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

    public init(_ titleKey: LocalizedStringKey, isExpanded: Binding<Bool>, @ViewBuilder content: () -> any View) {
        self.init(titleKey, content: content)
        self.isExpanded = isExpanded
    }

    public init(_ titleResource: LocalizedStringResource, isExpanded: Binding<Bool>, @ViewBuilder content: () -> any View) {
        self.init(titleResource, content: content)
        self.isExpanded = isExpanded
    }

    public init(_ title: String, isExpanded: Binding<Bool>, @ViewBuilder content: () -> any View) {
        self.init(title, content: content)
        self.isExpanded = isExpanded
    }

    public init(isExpanded: Binding<Bool>, @ViewBuilder content: () -> any View, @ViewBuilder header: () -> any View) {
        self.init(content: content, header: header)
        self.isExpanded = isExpanded
    }

    // SKIP @bridge
    public init(bridgedContent: any View, bridgedHeader: (any View)?, bridgedFooter: (any View)?) {
        self.content = ComposeBuilder.from { bridgedContent }
        self.header = bridgedHeader == nil ? nil : ComposeBuilder.from { bridgedHeader! }
        self.footer = bridgedFooter == nil ? nil : ComposeBuilder.from { bridgedFooter! }
    }

    #if SKIP
    @Composable override func Evaluate(context: ComposeContext, options: Int) -> kotlin.collections.List<Renderable> {
        let isLazy = EvaluateOptions(options).lazyItemLevel != nil
        var renderables: kotlin.collections.MutableList<Renderable> = mutableListOf()
        let headerRenderables = header?.Evaluate(context: context, options: 0)
        if isLazy {
            renderables.add(LazySectionHeader(content: headerRenderables ?? listOf(), isExpanded: isExpanded))
            renderables.addAll(content.Evaluate(context: context, options: options))
        } else {
            if let headerRenderables {
                renderables.addAll(headerRenderables)
            }
            // Outside lazy containers there is no header to toggle, so honor the binding directly
            if isExpanded?.wrappedValue != false {
                renderables.addAll(content.Evaluate(context: context, options: options))
            }
        }
        let footerRenderables = footer?.Evaluate(context: context, options: 0)
        if isLazy {
            renderables.add(LazySectionFooter(content: footerRenderables ?? listOf()))
        } else if let footerRenderables {
            renderables.addAll(footerRenderables)
        }
        return renderables
    }
    #else
    public var body: some View {
        stubView()
    }
    #endif
}

extension View {
    /// Labels this section in its list's trailing section index.
    public func sectionIndexLabel(_ label: Text?) -> any View {
        #if SKIP
        guard let label else {
            return self
        }
        return ModifiedContent(content: self, modifier: SectionIndexLabelModifier(label: label))
        #else
        return self
        #endif
    }

    public func sectionIndexLabel(_ label: String?) -> any View {
        return sectionIndexLabel(label == nil ? nil : Text(verbatim: label!))
    }
}

#endif
