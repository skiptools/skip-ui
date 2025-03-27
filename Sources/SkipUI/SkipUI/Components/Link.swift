// Copyright 2023–2025 Skip
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception
#if !SKIP_BRIDGE
import Foundation
#if SKIP
import androidx.compose.runtime.Composable
#endif

// Use a class to be able to update our openURL action on compose by reference.
// SKIP @bridge
public final class Link : View, ButtonRepresentable {
    var action: () -> Void
    let label: ComposeBuilder
    let role: ButtonRole? = nil

    var openURL = OpenURLAction.default

    public init(destination: URL, @ViewBuilder label: () -> any View) {
        #if SKIP
        self.action = { self.openURL(destination) }
        self.label = ComposeBuilder.from(label)
        #else
        self.action = {}
        self.label = ComposeBuilder(view: EmptyView())
        #endif
    }

    // SKIP @bridge
    public init(destination: URL, bridgedLabel: any View) {
        #if SKIP
        self.action = { self.openURL(destination) }
        self.label = ComposeBuilder.from { bridgedLabel }
        #else
        self.action = {}
        self.label = ComposeBuilder(view: EmptyView())
        #endif
    }

    public convenience init(_ titleKey: LocalizedStringKey, destination: URL) {
        self.init(destination: destination, label: { Text(titleKey) })
    }

    public convenience init(_ title: String, destination: URL) {
        self.init(destination: destination, label: { Text(verbatim: title) })
    }

    #if SKIP
    @Composable override func ComposeContent(context: ComposeContext) {
        let label = makeComposeLabel()
        Button(action: action, label: { label }).Compose(context: context)
    }

    @Composable func makeComposeLabel() -> ComposeBuilder {
        openURL = EnvironmentValues.shared.openURL
        return label
    }
    #else
    public var body: some View {
        stubView()
    }
    #endif
}

#endif
