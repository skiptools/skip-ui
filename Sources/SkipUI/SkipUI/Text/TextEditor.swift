// Copyright 2023–2025 Skip
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception
#if !SKIP_BRIDGE
#if SKIP
import androidx.compose.foundation.text.KeyboardActions
import androidx.compose.foundation.text.KeyboardOptions
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.OutlinedTextField
import androidx.compose.runtime.Composable
import androidx.compose.ui.platform.LocalFocusManager
import androidx.compose.ui.text.input.VisualTransformation
#endif

// SKIP @bridge
public struct TextEditor : View {
    let text: Binding<String>

    public init(text: Binding<String>) {
        self.text = text
    }

    // SKIP @bridge
    public init(getText: @escaping () -> String, setText: @escaping (String) -> Void) {
        self.text = Binding(get: getText, set: setText)
    }

    #if SKIP
    // SKIP INSERT: @OptIn(ExperimentalMaterial3Api::class)
    @Composable public override func ComposeContent(context: ComposeContext) {
        let contentContext = context.content()
        let textEnvironment = EnvironmentValues.shared._textEnvironment
        let redaction = EnvironmentValues.shared.redactionReasons
        let styleInfo = Text.styleInfo(textEnvironment: textEnvironment, redaction: redaction, context: context)
        let animatable = styleInfo.style.asAnimatable(context: context)
        let keyboardOptions = EnvironmentValues.shared._keyboardOptions ?? KeyboardOptions.Default
        let keyboardActions = KeyboardActions(EnvironmentValues.shared._onSubmitState, LocalFocusManager.current)
        let colors = TextField.colors(styleInfo: styleInfo, outline: Color.clear)
        let visualTransformation = VisualTransformation.None
        OutlinedTextField(value: text.wrappedValue, onValueChange: {
            text.wrappedValue = $0
        }, modifier: context.modifier.fillSize(), textStyle: animatable.value, enabled: EnvironmentValues.shared.isEnabled, singleLine: false, keyboardOptions: keyboardOptions, keyboardActions: keyboardActions, colors: colors, visualTransformation: visualTransformation)
    }
    #else
    public var body: some View {
        stubView()
    }
    #endif
}

public struct TextEditorStyle: RawRepresentable, Equatable {
    public let rawValue: Int

    public init(rawValue: Int) {
        self.rawValue = rawValue
    }

    public static let automatic = TextEditorStyle(rawValue: 0) // For bridging
    public static let plain = TextEditorStyle(rawValue: 1) // For bridging
}

extension View {
    public func textEditorStyle(_ style: TextEditorStyle) -> any View {
        return self
    }

    // SKIP @bridge
    public func textEditorStyle(bridgedStyle: Int) -> any View {
        return textEditorStyle(TextEditorStyle(rawValue: bridgedStyle))
    }

    @available(*, unavailable)
    public func findNavigator(isPresented: Binding<Bool>) -> some View {
        return self
    }

    @available(*, unavailable)
    public func findDisabled(_ isDisabled: Bool = true) -> some View {
        return self
    }

    @available(*, unavailable)
    public func replaceDisabled(_ isDisabled: Bool = true) -> some View {
        return self
    }
}

#if false
/// The properties of a text editor.
@available(iOS 17.0, macOS 14.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
public struct TextEditorStyleConfiguration {
}

#endif
#endif
