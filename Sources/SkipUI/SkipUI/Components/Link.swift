// Copyright 2023–2025 Skip
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception
#if !SKIP_BRIDGE
import Foundation
#if SKIP
import androidx.compose.runtime.Composable
#endif

// Use a class to be able to update our openURL action on compose by reference.
public final class Link : View {
    let content: Button
    var openURL = OpenURLAction.default

    public init(destination: URL, @ViewBuilder label: () -> any View) {
        #if SKIP
        content = Button(action: { self.openURL(destination) }, label: label)
        #else
        content = Button("", action: {})
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
        ComposeAction()
        content.Compose(context: context)
    }

    @Composable func ComposeAction() {
        openURL = EnvironmentValues.shared.openURL
    }
    #else
    public var body: some View {
        stubView()
    }
    #endif
}

#endif
