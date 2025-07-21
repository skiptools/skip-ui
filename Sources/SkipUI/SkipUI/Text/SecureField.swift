// Copyright 2023–2025 Skip
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception
#if !SKIP_BRIDGE
import Foundation
#if SKIP
import androidx.compose.runtime.Composable
#endif

public struct SecureField : View, Renderable {
    let textField: TextField

    public init(text: Binding<String>, prompt: Text? = nil, @ViewBuilder label: () -> any View) {
        textField = TextField(text: text, prompt: prompt, isSecure: true, label: label)
    }

    public init(_ title: String, text: Binding<String>, prompt: Text? = nil) {
        self.init(text: text, prompt: prompt, label: { Text(verbatim: title) })
    }

    public init(_ titleKey: LocalizedStringKey, text: Binding<String>, prompt: Text? = nil) {
        self.init(text: text, prompt: prompt, label: { Text(titleKey) })
    }

    public init(_ titleResource: LocalizedStringResource, text: Binding<String>, prompt: Text? = nil) {
        self.init(text: text, prompt: prompt, label: { Text(titleResource) })
    }

    #if SKIP
    @Composable override func Render(context: ComposeContext) {
        textField.Compose(context: context)
    }
    #else
    public var body: some View {
        stubView()
    }
    #endif
}

#endif
