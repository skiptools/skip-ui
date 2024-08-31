// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

#if SKIP
import androidx.compose.foundation.text.KeyboardActions
import androidx.compose.foundation.text.KeyboardOptions
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.OutlinedTextField
import androidx.compose.runtime.Composable
import androidx.compose.ui.platform.LocalFocusManager
import androidx.compose.ui.text.input.VisualTransformation
#endif

public struct TextEditor : View {
    let text: Binding<String>

    public init(text: Binding<String>) {
        self.text = text
    }

    #if SKIP
    // SKIP INSERT: @OptIn(ExperimentalMaterial3Api::class)
    @Composable public override func ComposeContent(context: ComposeContext) {
        let contentContext = context.content()
        let keyboardOptions = EnvironmentValues.shared._keyboardOptions ?? KeyboardOptions.Default
        let keyboardActions = KeyboardActions(EnvironmentValues.shared._onSubmitState, LocalFocusManager.current)
        let colors = TextField.colors(outline: Color.clear, context: context)
        let visualTransformation = VisualTransformation.None
        OutlinedTextField(value: text.wrappedValue, onValueChange: {
            text.wrappedValue = $0
        }, modifier: context.modifier.fillSize(), enabled: EnvironmentValues.shared.isEnabled, singleLine: false, keyboardOptions: keyboardOptions, keyboardActions: keyboardActions, colors: colors, visualTransformation: visualTransformation)
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

    public static let automatic = TextEditorStyle(rawValue: 0)
    public static let plain = TextEditorStyle(rawValue: 1)
}

extension View {
    public func textEditorStyle(_ style: TextEditorStyle) -> some View {
        return self
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

// TODO: Process for use in SkipUI

/// The properties of a text editor.
@available(iOS 17.0, macOS 14.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
public struct TextEditorStyleConfiguration {
}

#endif
