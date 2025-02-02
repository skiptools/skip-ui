// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

#if !SKIP_BRIDGE
#if SKIP
import androidx.compose.foundation.interaction.MutableInteractionSource
import androidx.compose.foundation.text.KeyboardActions
import androidx.compose.foundation.text.KeyboardOptions
import androidx.compose.material.ContentAlpha
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.LocalTextStyle
import androidx.compose.material3.OutlinedTextField
import androidx.compose.material3.OutlinedTextFieldDefaults
import androidx.compose.material3.TextFieldColors
import androidx.compose.runtime.Composable
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.ui.Modifier
import androidx.compose.ui.focus.FocusManager
import androidx.compose.ui.platform.LocalFocusManager
import androidx.compose.ui.text.TextRange
import androidx.compose.ui.text.TextStyle
import androidx.compose.ui.text.input.ImeAction
import androidx.compose.ui.text.input.PasswordVisualTransformation
import androidx.compose.ui.text.input.TextFieldValue
import androidx.compose.ui.text.input.VisualTransformation
#endif

public struct TextField : View {
    let text: Binding<String>
    let label: ComposeBuilder
    let prompt: Text?
    let isSecure: Bool

    public init(text: Binding<String>, prompt: Text? = nil, isSecure: Bool = false, @ViewBuilder label: () -> any View) {
        self.text = text
        self.label = ComposeBuilder.from(label)
        self.prompt = prompt
        self.isSecure = isSecure
    }

    public init(_ title: String, text: Binding<String>, prompt: Text? = nil) {
        self.init(text: text, prompt: prompt, label: { Text(verbatim: title) })
    }

    public init(_ titleKey: LocalizedStringKey, text: Binding<String>, prompt: Text? = nil) {
        self.init(text: text, prompt: prompt, label: { Text(titleKey) })
    }

    @available(*, unavailable)
    public init(_ titleKey: LocalizedStringKey, text: Binding<String>, axis: Axis) {
        self.init(titleKey, text: text)
    }

    @available(*, unavailable)
    public init(_ titleKey: LocalizedStringKey, text: Binding<String>, prompt: Text?, axis: Axis) {
        self.init(titleKey, text: text, prompt: prompt)
    }

    @available(*, unavailable)
    public init(_ title: String, text: Binding<String>, axis: Axis) {
        self.init(title, text: text)
    }

    @available(*, unavailable)
    public init(_ title: String, text: Binding<String>, prompt: Text?, axis: Axis) {
        self.init(title, text: text, prompt: prompt)
    }

    @available(*, unavailable)
    public init(text: Binding<String>, prompt: Text? = nil, axis: Axis, @ViewBuilder label: () -> any View) {
        self.init(text: text, prompt: prompt, label: label)
    }

    #if SKIP
    // SKIP INSERT: @OptIn(ExperimentalMaterial3Api::class)
    @Composable public override func ComposeContent(context: ComposeContext) {
        let contentContext = context.content()
        let textEnvironment = EnvironmentValues.shared._textEnvironment
        let redaction = EnvironmentValues.shared.redactionReasons
        let styleInfo = Text.styleInfo(textEnvironment: textEnvironment, redaction: redaction, context: context)
        let animatable = styleInfo.style.asAnimatable(context: context)
        let colors = Self.colors(styleInfo: styleInfo)
        let keyboardOptions = EnvironmentValues.shared._keyboardOptions ?? KeyboardOptions.Default
        let keyboardActions = KeyboardActions(EnvironmentValues.shared._onSubmitState, LocalFocusManager.current)

        let visualTransformation = isSecure ? PasswordVisualTransformation() : VisualTransformation.None
        let currentText = text.wrappedValue
        let defaultTextFieldValue = TextFieldValue(text: currentText, selection: TextRange(currentText.count))
        let textFieldValue = remember { mutableStateOf(defaultTextFieldValue) }
        var currentTextFieldValue = textFieldValue.value
        // If the text has been updated externally, use the default value for the current text,
        // which also places the cursor at the end. This mimics SwiftUI behavior for external modifications,
        // such as when applying formatting to the user input
        if currentTextFieldValue.text != currentText {
            currentTextFieldValue = defaultTextFieldValue
        }
        var options = Material3TextFieldOptions(value: currentTextFieldValue, onValueChange: {
            textFieldValue.value = $0
            text.wrappedValue = $0.text
        }, placeholder: {
            Self.Placeholder(prompt: prompt ?? label, context: contentContext)
        }, modifier: context.modifier.fillWidth(), textStyle: animatable.value, enabled: EnvironmentValues.shared.isEnabled, singleLine: true, visualTransformation: visualTransformation, keyboardOptions: keyboardOptions, keyboardActions: keyboardActions, maxLines: 1, shape: OutlinedTextFieldDefaults.shape, colors: colors)
        if let updateOptions = EnvironmentValues.shared._material3TextField {
            options = updateOptions(options)
        }
        OutlinedTextField(value: options.value, onValueChange: options.onValueChange, modifier: options.modifier, enabled: options.enabled, readOnly: options.readOnly, textStyle: options.textStyle, label: options.label, placeholder: options.placeholder, leadingIcon: options.leadingIcon, trailingIcon: options.trailingIcon, prefix: options.prefix, suffix: options.suffix, supportingText: options.supportingText, isError: options.isError, visualTransformation: options.visualTransformation, keyboardOptions: options.keyboardOptions, keyboardActions: options.keyboardActions, singleLine: options.singleLine, maxLines: options.maxLines, minLines: options.minLines, interactionSource: options.interactionSource, shape: options.shape, colors: options.colors)
    }

    @Composable static func textColor(styleInfo: TextStyleInfo, enabled: Bool) -> androidx.compose.ui.graphics.Color {
        guard let color = styleInfo.color else {
            return androidx.compose.ui.graphics.Color.Unspecified
        }
        return enabled ? color : color.copy(alpha: ContentAlpha.disabled)
    }

    // SKIP INSERT: @OptIn(ExperimentalMaterial3Api::class)
    @Composable static func colors(styleInfo: TextStyleInfo, outline: Color? = nil) -> TextFieldColors {
        let textColor = textColor(styleInfo: styleInfo, enabled: true)
        let disabledTextColor = textColor(styleInfo: styleInfo, enabled: false)
        let isPlainStyle = EnvironmentValues.shared._textFieldStyle == TextFieldStyle.plain
        if isPlainStyle {
            let clearColor = androidx.compose.ui.graphics.Color.Transparent
            if let tint = EnvironmentValues.shared._tint {
                let tintColor = tint.colorImpl()
                return OutlinedTextFieldDefaults.colors(focusedTextColor: textColor, unfocusedTextColor: textColor, disabledTextColor: disabledTextColor, cursorColor: tintColor, focusedBorderColor: clearColor, unfocusedBorderColor: clearColor, disabledBorderColor: clearColor, errorBorderColor: clearColor)
            } else {
                return OutlinedTextFieldDefaults.colors(focusedTextColor: textColor, unfocusedTextColor: textColor, disabledTextColor: disabledTextColor, focusedBorderColor: clearColor, unfocusedBorderColor: clearColor, disabledBorderColor: clearColor, errorBorderColor: clearColor)
            }
        } else {
            let borderColor = (outline ?? Color.primary.opacity(0.3)).colorImpl()
            if let tint = EnvironmentValues.shared._tint {
                let tintColor = tint.colorImpl()
                return OutlinedTextFieldDefaults.colors(focusedTextColor: textColor, unfocusedTextColor: textColor, disabledTextColor: disabledTextColor, cursorColor: tintColor, focusedBorderColor: tintColor, unfocusedBorderColor: borderColor, disabledBorderColor: Color.separator.colorImpl())
            } else {
                return OutlinedTextFieldDefaults.colors(focusedTextColor: textColor, unfocusedTextColor: textColor, disabledTextColor: disabledTextColor, unfocusedBorderColor: borderColor, disabledBorderColor: Color.separator.colorImpl())
            }
        }
    }

    @Composable static func Placeholder(prompt: View?, context: ComposeContext) {
        guard let prompt else {
            return
        }
        EnvironmentValues.shared.setValues {
            $0.set_foregroundStyle(Color(colorImpl: { Color.primary.colorImpl().copy(alpha: ContentAlpha.disabled) }))
        } in: {
            prompt.Compose(context: context)
        }
    }
    #else
    public var body: some View {
        stubView()
    }
    #endif
}

public struct TextFieldStyle: RawRepresentable, Equatable {
    public let rawValue: Int

    public init(rawValue: Int) {
        self.rawValue = rawValue
    }

    public static let automatic = TextFieldStyle(rawValue: 0)
    public static let roundedBorder = TextFieldStyle(rawValue: 1)
    public static let plain = TextFieldStyle(rawValue: 2)
}

extension View {
    public func autocorrectionDisabled(_ disable: Bool = true) -> some View {
        #if SKIP
        return keyboardOptionsModifierView { options in
            return options == nil ? KeyboardOptions(autoCorrectEnabled: !disable) : options.copy(autoCorrectEnabled: !disable)
        }
        #else
        return self
        #endif
    }

    public func keyboardType(_ type: UIKeyboardType) -> some View {
        #if SKIP
        let keyboardType = type.asComposeKeyboardType()
        return keyboardOptionsModifierView { options in
            return options == nil ? KeyboardOptions(keyboardType: keyboardType) : options.copy(keyboardType: keyboardType)
        }
        #else
        return self
        #endif
    }

    public func onSubmit(of triggers: SubmitTriggers = .text, _ action: @escaping (() -> Void)) -> some View {
        #if SKIP
        return ComposeModifierView(contentView: self) { view, context in
            let state = EnvironmentValues.shared._onSubmitState
            let updatedState = state == nil ? OnSubmitState(triggers: triggers, action: action) : state!.appending(triggers: triggers, action: action)
            EnvironmentValues.shared.setValues {
                $0.set_onSubmitState(updatedState)
            } in: {
                view.Compose(context: context)
            }
        }
        #else
        return self
        #endif
    }

    @available(*, unavailable)
    public func submitScope(_ isBlocking: Bool = true) -> some View {
        return self
    }

    public func submitLabel(_ submitLabel: SubmitLabel) -> some View {
        #if SKIP
        let imeAction = submitLabel.asImeAction()
        return keyboardOptionsModifierView { options in
            return options == nil ? KeyboardOptions(imeAction: imeAction) : options.copy(imeAction: imeAction)
        }
        #else
        return self
        #endif
    }

    @available(*, unavailable)
    public func textContentType(_ textContentType: UITextContentType?) -> some View {
        return self
    }

    public func textFieldStyle(_ style: TextFieldStyle) -> some View {
        #if SKIP
        return environment(\._textFieldStyle, style)
        #else
        return self
        #endif
    }

    public func textInputAutocapitalization(_ autocapitalization: TextInputAutocapitalization?) -> some View {
        #if SKIP
        let capitalization = (autocapitalization ?? TextInputAutocapitalization.sentences).asKeyboardCapitalization()
        return keyboardOptionsModifierView { options in
            return options == nil ? KeyboardOptions(capitalization: capitalization) : options.copy(capitalization: capitalization)
        }
        #else
        return self
        #endif
    }

    #if SKIP
    /// Return a modifier view that updates the environment's keyboard options.
    public func keyboardOptionsModifierView(update: (KeyboardOptions?) -> KeyboardOptions) -> View {
        return ComposeModifierView(contentView: self) { view, context in
            let options = EnvironmentValues.shared._keyboardOptions
            let updatedOptions = update(options)
            EnvironmentValues.shared.setValues {
                $0.set_keyboardOptions(updatedOptions)
            } in: {
                view.Compose(context: context)
            }
        }
    }

    /// Compose text field customization.
    public func material3TextField(_ options: @Composable (Material3TextFieldOptions) -> Material3TextFieldOptions) -> View {
        return environment(\._material3TextField, options)
    }
    #endif
}

#if SKIP
public struct Material3TextFieldOptions {
    public var value: TextFieldValue
    public var onValueChange: (TextFieldValue) -> Void
    public var modifier: Modifier = Modifier
    public var enabled = true
    public var readOnly = false
    public var textStyle: TextStyle
    public var label: (@Composable () -> Void)? = nil
    public var placeholder: (@Composable () -> Void)? = nil
    public var leadingIcon: (@Composable () -> Void)? = nil
    public var trailingIcon: (@Composable () -> Void)? = nil
    public var prefix: (@Composable () -> Void)? = nil
    public var suffix: (@Composable () -> Void)? = nil
    public var supportingText: (@Composable () -> Void)? = nil
    public var isError = false
    public var visualTransformation: VisualTransformation = VisualTransformation.None
    public var keyboardOptions: KeyboardOptions = KeyboardOptions.Default
    public var keyboardActions: KeyboardActions = KeyboardActions.Default
    public var singleLine = false
    public var maxLines = Int.max
    public var minLines = 1
    public var interactionSource: MutableInteractionSource? = nil
    public var shape: androidx.compose.ui.graphics.Shape
    public var colors: TextFieldColors

    public func copy(
        value: TextFieldValue = self.value,
        onValueChange: (TextFieldValue) -> Void = self.onValueChange,
        modifier: Modifier = self.modifier,
        enabled: Bool = self.enabled,
        readOnly: Bool = self.readOnly,
        textStyle: TextStyle = self.textStyle,
        label: (@Composable () -> Void)? = self.label,
        placeholder: (@Composable () -> Void)? = self.placeholder,
        leadingIcon: (@Composable () -> Void)? = self.leadingIcon,
        trailingIcon: (@Composable () -> Void)? = self.trailingIcon,
        prefix: (@Composable () -> Void)? = self.prefix,
        suffix: (@Composable () -> Void)? = self.suffix,
        supportingText: (@Composable () -> Void)? = self.supportingText,
        isError: Bool = self.isError,
        visualTransformation: VisualTransformation = self.visualTransformation,
        keyboardOptions: KeyboardOptions = self.keyboardOptions,
        keyboardActions: KeyboardActions = self.keyboardActions,
        singleLine: Bool = self.singleLine,
        maxLines: Int = Int.MAX_VALUE,
        minLines: Int = self.minLines,
        interactionSource: MutableInteractionSource? = self.interactionSource,
        shape: androidx.compose.ui.graphics.Shape = self.shape,
        colors: TextFieldColors = self.colors
    ) -> Material3TextFieldOptions {
        return Material3TextFieldOptions(value: value, onValueChange: onValueChange, modifier: modifier, enabled: enabled, readOnly: readOnly, textStyle: textStyle, label: label, placeholder: placeholder, leadingIcon: leadingIcon, trailingIcon: trailingIcon, prefix: prefix, suffix: suffix, supportingText: supportingText, isError: isError, visualTransformation: visualTransformation, keyboardOptions: keyboardOptions, keyboardActions: keyboardActions, singleLine: singleLine, maxLines: maxLines, minLines: minLines, interactionSource: interactionSource, shape: shape, colors: colors)
    }
}
#endif

/// State for `onSubmit` actions.
struct OnSubmitState {
    let actions: [(SubmitTriggers, () -> Void)]

    init(triggers: SubmitTriggers, action: @escaping () -> Void) {
        actions = [(triggers, action)]
    }

    private init(actions: [(SubmitTriggers, () -> Void)]) {
        self.actions = actions
    }

    func appending(triggers: SubmitTriggers, action: @escaping () -> Void) -> OnSubmitState {
        return OnSubmitState(actions: actions + [(triggers, action)])
    }

    func appending(_ state: OnSubmitState) -> OnSubmitState {
        return OnSubmitState(actions: actions + state.actions)
    }

    func onSubmit(trigger: SubmitTriggers) {
        for action in actions {
            if action.0.contains(trigger) {
                action.1()
            }
        }
    }
}

#if SKIP
/// Create keyboard actions that execute the given submit state.
func KeyboardActions(submitState: OnSubmitState?, clearFocusWith: FocusManager? = nil) -> KeyboardActions {
    return KeyboardActions(onDone: {
        clearFocusWith?.clearFocus()
        submitState?.onSubmit(trigger: .text)
    }, onGo: {
        clearFocusWith?.clearFocus()
        submitState?.onSubmit(trigger: .text)
    }, onNext: {
        clearFocusWith?.clearFocus()
        submitState?.onSubmit(trigger: .text)
    }, onPrevious: {
        clearFocusWith?.clearFocus()
        submitState?.onSubmit(trigger: .text)
    }, onSearch: {
        clearFocusWith?.clearFocus()
        submitState?.onSubmit(trigger: .search)
    }, onSend: {
        clearFocusWith?.clearFocus()
        submitState?.onSubmit(trigger: .text)
    })
}
#endif

#if false
import class Foundation.Formatter
import protocol Foundation.ParseableFormatStyle

//extension TextField where Label == Text {

    /// Creates a text field that applies a format style to a bound optional
    /// value, with a label generated from a localized title string.
    ///
    /// Use this initializer to create a text field that binds to a bound optional
    /// value, using a
    /// to convert to and from this type. Changes to the bound value update
    /// the string displayed by the text field. Editing the text field
    /// updates the bound value, as long as the format style can parse the
    /// text. If the format style can't parse the input, the text field
    /// sets the bound value to `nil`.
    ///
    /// Use the ``View/onSubmit(of:_:)`` modifier to invoke an action
    /// whenever the user submits this text field.
    ///
    /// The following example uses an optional
    /// as the bound currency value, and a
    /// instance to convert to and from a representation as U.S. dollars. As
    /// the user types, a `View.onChange(of:_:)` modifier logs the new value to
    /// the console. If the user enters an invalid currency value, like letters
    /// or emoji, the console output is `Optional(nil)`.
    ///
    ///     @State private var myMoney: Double? = 300.0
    ///     var body: some View {
    ///         TextField(
    ///             "Currency (USD)",
    ///             value: $myMoney,
    ///             format: .currency(code: "USD")
    ///         )
    ///         .onChange(of: myMoney) { newValue in
    ///             print ("myMoney: \(newValue)")
    ///         }
    ///     }
    ///
    /// - Parameters:
    ///   - titleKey: The title of the text field, describing its purpose.
    ///   - value: The underlying value to edit.
    ///   - format: A format style of type `F` to use when converting between
    ///     the string the user edits and the underlying value of type
    ///     `F.FormatInput`. If `format` can't perform the conversion, the text
    ///     field sets `binding.value` to `nil`.
    ///   - prompt: A `Text` which provides users with guidance on what to type
    ///     into the text field.
//    @available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
//    public init<F>(_ titleKey: LocalizedStringKey, value: Binding<F.FormatInput?>, format: F, prompt: Text? = nil) where F : ParseableFormatStyle, F.FormatOutput == String { fatalError() }

    /// Creates a text field that applies a format style to a bound optional
    /// value, with a label generated from a title string.
    ///
    /// Use this initializer to create a text field that binds to a bound optional
    /// value, using a
    /// to convert to and from this type. Changes to the bound value update
    /// the string displayed by the text field. Editing the text field
    /// updates the bound value, as long as the format style can parse the
    /// text. If the format style can't parse the input, the text field
    /// sets the bound value to `nil`.
    ///
    /// Use the ``View/onSubmit(of:_:)`` modifier to invoke an action
    /// whenever the user submits this text field.
    ///
    /// The following example uses an optional
    /// as the bound currency value, and a
    /// instance to convert to and from a representation as U.S. dollars. As
    /// the user types, a `View.onChange(of:_:)` modifier logs the new value to
    /// the console. If the user enters an invalid currency value, like letters
    /// or emoji, the console output is `Optional(nil)`.
    ///
    ///     @State private var label = "Currency (USD)"
    ///     @State private var myMoney: Double? = 300.0
    ///     var body: some View {
    ///         TextField(
    ///             label,
    ///             value: $myMoney,
    ///             format: .currency(code: "USD")
    ///         )
    ///         .onChange(of: myMoney) { newValue in
    ///             print ("myMoney: \(newValue)")
    ///         }
    ///     }
    ///
    /// - Parameters:
    ///   - title: The title of the text field, describing its purpose.
    ///   - value: The underlying value to edit.
    ///   - format: A format style of type `F` to use when converting between
    ///     the string the user edits and the underlying value of type
    ///     `F.FormatInput`. If `format` can't perform the conversion, the text
    ///     field sets `binding.value` to `nil`.
    ///   - prompt: A `Text` which provides users with guidance on what to type
    ///     into the text field.
//    @available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
//    public init<S, F>(_ title: S, value: Binding<F.FormatInput?>, format: F, prompt: Text? = nil) where S : StringProtocol, F : ParseableFormatStyle, F.FormatOutput == String { fatalError() }

    /// Creates a text field that applies a format style to a bound
    /// value, with a label generated from a localized title string.
    ///
    /// Use this initializer to create a text field that binds to a bound
    /// value, using a
    /// to convert to and from this type. Changes to the bound value update
    /// the string displayed by the text field. Editing the text field
    /// updates the bound value, as long as the format style can parse the
    /// text. If the format style can't parse the input, the bound value
    /// remains unchanged.
    ///
    /// Use the ``View/onSubmit(of:_:)`` modifier to invoke an action
    /// whenever the user submits this text field.
    ///
    ///
    /// The following example uses a
    /// as the bound value, and a
    /// instance to convert to and from a string representation. As the user types, the bound
    /// value updates, which in turn updates three ``Text`` views that use
    /// different format styles. If the user enters text that doesn't represent
    /// a valid `Double`, the bound value doesn't update.
    ///
    ///     @State private var myDouble: Double = 0.673
    ///     var body: some View {
    ///         VStack {
    ///             TextField(
    ///                 "Double",
    ///                 value: $myDouble,
    ///                 format: .number
    ///             )
    ///             Text(myDouble, format: .number)
    ///             Text(myDouble, format: .number.precision(.significantDigits(5)))
    ///             Text(myDouble, format: .number.notation(.scientific))
    ///         }
    ///     }
    ///
    /// ![A text field with the string 0.673. Below this, three text views
    /// showing the number with different styles: 0.673, 0.67300, and 6.73E-1.](TextField-init-format-1)
    ///
    /// - Parameters:
    ///   - titleKey: The title of the text field, describing its purpose.
    ///   - value: The underlying value to edit.
    ///   - format: A format style of type `F` to use when converting between
    ///     the string the user edits and the underlying value of type
    ///     `F.FormatInput`. If `format` can't perform the conversion, the text
    ///     field leaves `binding.value` unchanged. If the user stops editing
    ///     the text in an invalid state, the text field updates the field's
    ///     text to the last known valid value.
    ///   - prompt: A `Text` which provides users with guidance on what to type
    ///     into the text field.
//    @available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
//    public init<F>(_ titleKey: LocalizedStringKey, value: Binding<F.FormatInput>, format: F, prompt: Text? = nil) where F : ParseableFormatStyle, F.FormatOutput == String { fatalError() }

    /// Creates a text field that applies a format style to a bound
    /// value, with a label generated from a title string.
    ///
    /// Use this initializer to create a text field that binds to a bound
    /// value, using a
    /// to convert to and from this type. Changes to the bound value update
    /// the string displayed by the text field. Editing the text field
    /// updates the bound value, as long as the format style can parse the
    /// text. If the format style can't parse the input, the bound value
    /// remains unchanged.
    ///
    /// Use the ``View/onSubmit(of:_:)`` modifier to invoke an action
    /// whenever the user submits this text field.
    ///
    /// The following example uses a
    /// as the bound value, and a
    /// instance to convert to and from a string representation. As the user types, the bound
    /// value updates, which in turn updates three ``Text`` views that use
    /// different format styles. If the user enters text that doesn't represent
    /// a valid `Double`, the bound value doesn't update.
    ///
    ///     @State private var label = "Double"
    ///     @State private var myDouble: Double = 0.673
    ///     var body: some View {
    ///         VStack {
    ///             TextField(
    ///                 label,
    ///                 value: $myDouble,
    ///                 format: .number
    ///             )
    ///             Text(myDouble, format: .number)
    ///             Text(myDouble, format: .number.precision(.significantDigits(5)))
    ///             Text(myDouble, format: .number.notation(.scientific))
    ///         }
    ///     }
    ///
    /// ![A text field with the string 0.673. Below this, three text views
    /// showing the number with different styles: 0.673, 0.67300, and 6.73E-1.](TextField-init-format-1)
    /// - Parameters:
    ///   - title: The title of the text field, describing its purpose.
    ///   - value: The underlying value to edit.
    ///   - format: A format style of type `F` to use when converting between
    ///     the string the user edits and the underlying value of type
    ///     `F.FormatInput`. If `format` can't perform the conversion, the text
    ///     field leaves `binding.value` unchanged. If the user stops editing
    ///     the text in an invalid state, the text field updates the field's
    ///     text to the last known valid value.
    ///   - prompt: A `Text` which provides users with guidance on what to type
    ///     into the text field.
//    @available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
//    public init<S, F>(_ title: S, value: Binding<F.FormatInput>, format: F, prompt: Text? = nil) where S : StringProtocol, F : ParseableFormatStyle, F.FormatOutput == String { fatalError() }
//}

extension TextField {

    /// Creates a text field that applies a format style to a bound optional
    /// value, with a label generated from a view builder.
    ///
    /// Use this initializer to create a text field that binds to a bound optional
    /// value, using a
    /// to convert to and from this type. Changes to the bound value update
    /// the string displayed by the text field. Editing the text field
    /// updates the bound value, as long as the format style can parse the
    /// text. If the format style can't parse the input, the text field
    /// sets the bound value to `nil`.
    ///
    /// Use the ``View/onSubmit(of:_:)`` modifier to invoke an action
    /// whenever the user submits this text field.
    ///
    /// The following example uses an optional
    /// as the bound currency value, and a
    /// instance to convert to and from a representation as U.S. dollars. As
    /// the user types, a `View.onChange(of:_:)` modifier logs the new value to
    /// the console. If the user enters an invalid currency value, like letters
    /// or emoji, the console output is `Optional(nil)`.
    ///
    ///     @State private var myMoney: Double? = 300.0
    ///     var body: some View {
    ///         TextField(
    ///             value: $myMoney,
    ///             format: .currency(code: "USD")
    ///         ) {
    ///             Text("Currency (USD)")
    ///         }
    ///         .onChange(of: myMoney) { newValue in
    ///             print ("myMoney: \(newValue)")
    ///         }
    ///     }
    ///
    /// - Parameters:
    ///   - value: The underlying value to edit.
    ///   - format: A format style of type `F` to use when converting between
    ///     the string the user edits and the underlying value of type
    ///     `F.FormatInput`. If `format` can't perform the conversion, the text
    ///     field sets `binding.value` to `nil`.
    ///   - prompt: A `Text` which provides users with guidance on what to type
    ///     into the text field.
    ///   - label: A view builder that produces a label for the text field,
    ///     describing its purpose.
//    @available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
//    public init<F>(value: Binding<F.FormatInput?>, format: F, prompt: Text? = nil, @ViewBuilder label: () -> Label) where F : ParseableFormatStyle, F.FormatOutput == String { fatalError() }

    /// Creates a text field that applies a format style to a bound
    /// value, with a label generated from a view builder.
    ///
    /// Use this initializer to create a text field that binds to a bound
    /// value, using a
    /// to convert to and from this type. Changes to the bound value update
    /// the string displayed by the text field. Editing the text field
    /// updates the bound value, as long as the format style can parse the
    /// text. If the format style can't parse the input, the bound value
    /// remains unchanged.
    ///
    /// Use the ``View/onSubmit(of:_:)`` modifier to invoke an action
    /// whenever the user submits this text field.
    ///
    /// The following example uses a
    /// as the bound value, and a
    /// instance to convert to and from a string representation. As the user types, the bound
    /// value updates, which in turn updates three ``Text`` views that use
    /// different format styles. If the user enters text that doesn't represent
    /// a valid `Double`, the bound value doesn't update.
    ///
    ///     @State private var myDouble: Double = 0.673
    ///     var body: some View {
    ///         VStack {
    ///             TextField(
    ///                 value: $myDouble,
    ///                 format: .number
    ///             ) {
    ///                 Text("Double")
    ///             }
    ///             Text(myDouble, format: .number)
    ///             Text(myDouble, format: .number.precision(.significantDigits(5)))
    ///             Text(myDouble, format: .number.notation(.scientific))
    ///         }
    ///     }
    ///
    /// ![A text field with the string 0.673. Below this, three text views
    /// showing the number with different styles: 0.673, 0.67300, and 6.73E-1.](TextField-init-format-1)
    ///
    /// - Parameters:
    ///   - value: The underlying value to edit.
    ///   - format: A format style of type `F` to use when converting between
    ///     the string the user edits and the underlying value of type
    ///     `F.FormatInput`. If `format` can't perform the conversion, the text
    ///     field leaves the value unchanged. If the user stops editing
    ///     the text in an invalid state, the text field updates the field's
    ///     text to the last known valid value.
    ///   - prompt: A `Text` which provides users with guidance on what to type
    ///     into the text field.
    ///   - label: A view builder that produces a label for the text field,
    ///     describing its purpose.
//    @available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
//    public init<F>(value: Binding<F.FormatInput>, format: F, prompt: Text? = nil, @ViewBuilder label: () -> Label) where F : ParseableFormatStyle, F.FormatOutput == String { fatalError() }
}

//extension TextField where Label == Text {

    /// Creates a text field that applies a formatter to a bound
    /// value, with a label generated from a localized title string.
    ///
    /// Use this initializer to create a text field that binds to a bound
    /// value, using a
    /// to convert to and from this type. Changes to the bound value update
    /// the string displayed by the text field. Editing the text field
    /// updates the bound value, as long as the formatter can parse the
    /// text. If the format style can't parse the input, the bound value
    /// remains unchanged.
    ///
    /// Use the ``View/onSubmit(of:_:)`` modifier to invoke an action
    /// whenever the user submits this text field.
    ///
    /// The following example uses a
    /// as the bound value, and a
    /// instance to convert to and from a string representation. The formatter
    /// uses the
    /// style, to allow entering a fractional part. As the user types, the bound
    /// value updates, which in turn updates three ``Text`` views that use
    /// different format styles. If the user enters text that doesn't represent
    /// a valid `Double`, the bound value doesn't update.
    ///
    ///     @State private var myDouble: Double = 0.673
    ///     @State private var numberFormatter: NumberFormatter = {
    ///         var nf = NumberFormatter()
    ///         nf.numberStyle = .decimal
    ///         return nf
    ///     }()
    ///
    ///     var body: some View {
    ///         VStack {
    ///             TextField(
    ///                 "Double",
    ///                 value: $myDouble,
    ///                 formatter: numberFormatter
    ///             )
    ///             Text(myDouble, format: .number)
    ///             Text(myDouble, format: .number.precision(.significantDigits(5)))
    ///             Text(myDouble, format: .number.notation(.scientific))
    ///         }
    ///     }
    ///
    /// - Parameters:
    ///   - titleKey: The key for the localized title of the text field,
    ///     describing its purpose.
    ///   - value: The underlying value to edit.
    ///   - formatter: A formatter to use when converting between the
    ///     string the user edits and the underlying value of type `V`.
    ///     If `formatter` can't perform the conversion, the text field doesn't
    ///     modify `binding.value`.
    ///   - prompt: A `Text` which provides users with guidance on what to enter
    ///     into the text field.
//    @available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
//    public init<V>(_ titleKey: LocalizedStringKey, value: Binding<V>, formatter: Formatter, prompt: Text?) { fatalError() }

    /// Creates a text field that applies a formatter to a bound
    /// value, with a label generated from a title string.
    ///
    /// Use this initializer to create a text field that binds to a bound
    /// value, using a
    /// to convert to and from this type. Changes to the bound value update
    /// the string displayed by the text field. Editing the text field
    /// updates the bound value, as long as the formatter can parse the
    /// text. If the format style can't parse the input, the bound value
    /// remains unchanged.
    ///
    /// Use the ``View/onSubmit(of:_:)`` modifier to invoke an action
    /// whenever the user submits this text field.
    ///
    ///
    /// The following example uses a
    /// as the bound value, and a
    /// instance to convert to and from a string representation. The formatter
    /// uses the
    /// style, to allow entering a fractional part. As the user types, the bound
    /// value updates, which in turn updates three ``Text`` views that use
    /// different format styles. If the user enters text that doesn't represent
    /// a valid `Double`, the bound value doesn't update.
    ///
    ///     @State private var label = "Double"
    ///     @State private var myDouble: Double = 0.673
    ///     @State private var numberFormatter: NumberFormatter = {
    ///         var nf = NumberFormatter()
    ///         nf.numberStyle = .decimal
    ///         return nf
    ///     }()
    ///
    ///     var body: some View {
    ///         VStack {
    ///             TextField(
    ///                 label,
    ///                 value: $myDouble,
    ///                 formatter: numberFormatter
    ///             )
    ///             Text(myDouble, format: .number)
    ///             Text(myDouble, format: .number.precision(.significantDigits(5)))
    ///             Text(myDouble, format: .number.notation(.scientific))
    ///         }
    ///     }
    ///
    /// - Parameters:
    ///   - title: The title of the text field, describing its purpose.
    ///   - value: The underlying value to edit.
    ///   - formatter: A formatter to use when converting between the
    ///     string the user edits and the underlying value of type `V`.
    ///     If `formatter` can't perform the conversion, the text field doesn't
    ///     modify `binding.value`.
    ///   - prompt: A `Text` which provides users with guidance on what to enter
    ///     into the text field.
//    @available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
//    public init<S, V>(_ title: S, value: Binding<V>, formatter: Formatter, prompt: Text?) where S : StringProtocol { fatalError() }
//}

extension TextField {

    /// Creates a text field that applies a formatter to a bound optional
    /// value, with a label generated from a view builder.
    ///
    /// Use this initializer to create a text field that binds to a bound optional
    /// value, using a
    /// to convert to and from this type. Changes to the bound value update
    /// the string displayed by the text field. Editing the text field
    /// updates the bound value, as long as the formatter can parse the
    /// text. If the format style can't parse the input, the bound value
    /// remains unchanged.
    ///
    /// Use the ``View/onSubmit(of:_:)`` modifier to invoke an action
    /// whenever the user submits this text field.
    ///
    /// The following example uses a
    /// as the bound value, and a
    /// instance to convert to and from a string representation. The formatter
    /// uses the
    /// style, to allow entering a fractional part. As the user types, the bound
    /// value updates, which in turn updates three ``Text`` views that use
    /// different format styles. If the user enters text that doesn't represent
    /// a valid `Double`, the bound value doesn't update.
    ///
    ///     @State private var myDouble: Double = 0.673
    ///     @State private var numberFormatter: NumberFormatter = {
    ///         var nf = NumberFormatter()
    ///         nf.numberStyle = .decimal
    ///         return nf
    ///     }()
    ///
    ///     var body: some View {
    ///         VStack {
    ///             TextField(
    ///                 value: $myDouble,
    ///                 formatter: numberFormatter
    ///             ) {
    ///                 Text("Double")
    ///             }
    ///             Text(myDouble, format: .number)
    ///             Text(myDouble, format: .number.precision(.significantDigits(5)))
    ///             Text(myDouble, format: .number.notation(.scientific))
    ///         }
    ///     }
    ///
    /// - Parameters:
    ///   - value: The underlying value to edit.
    ///   - formatter: A formatter to use when converting between the
    ///     string the user edits and the underlying value of type `V`.
    ///     If `formatter` can't perform the conversion, the text field doesn't
    ///     modify `binding.value`.
    ///   - prompt: A `Text` which provides users with guidance on what to enter
    ///     into the text field.
    ///   - label: A view that describes the purpose of the text field.
//    @available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
//    public init<V>(value: Binding<V>, formatter: Formatter, prompt: Text? = nil, @ViewBuilder label: () -> Label) { fatalError() }
}

//extension TextField where Label == Text {

    /// Create an instance which binds over an arbitrary type, `V`.
    ///
    /// Use this initializer to create a text field that binds to a bound optional
    /// value, using a
    /// to convert to and from this type. Changes to the bound value update
    /// the string displayed by the text field. Editing the text field
    /// updates the bound value, as long as the formatter can parse the
    /// text. If the format style can't parse the input, the bound value
    /// remains unchanged.
    ///
    /// Use the ``View/onSubmit(of:_:)`` modifier to invoke an action
    /// whenever the user submits this text field.
    ///
    /// The following example uses a
    /// as the bound value, and a
    /// instance to convert to and from a string representation. The formatter
    /// uses the
    /// style, to allow entering a fractional part. As the user types, the bound
    /// value updates, which in turn updates three ``Text`` views that use
    /// different format styles. If the user enters text that doesn't represent
    /// a valid `Double`, the bound value doesn't update.
    ///
    ///     @State private var myDouble: Double = 0.673
    ///     @State private var numberFormatter: NumberFormatter = {
    ///         var nf = NumberFormatter()
    ///         nf.numberStyle = .decimal
    ///         return nf
    ///     }()
    ///
    ///     var body: some View {
    ///         VStack {
    ///             TextField(
    ///                 value: $myDouble,
    ///                 formatter: numberFormatter
    ///             ) {
    ///                 Text("Double")
    ///             }
    ///             Text(myDouble, format: .number)
    ///             Text(myDouble, format: .number.precision(.significantDigits(5)))
    ///             Text(myDouble, format: .number.notation(.scientific))
    ///         }
    ///     }
    ///
    /// - Parameters:
    ///   - titleKey: The key for the localized title of the text field,
    ///     describing its purpose.
    ///   - value: The underlying value to edit.
    ///   - formatter: A formatter to use when converting between the
    ///     string the user edits and the underlying value of type `V`.
    ///     If `formatter` can't perform the conversion, the text field doesn't
    ///     modify `binding.value`.
//    @available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
//    public init<V>(_ titleKey: LocalizedStringKey, value: Binding<V>, formatter: Formatter) { fatalError() }

    /// Create an instance which binds over an arbitrary type, `V`.
    ///
    /// Use this initializer to create a text field that binds to a bound optional
    /// value, using a
    /// to convert to and from this type. Changes to the bound value update
    /// the string displayed by the text field. Editing the text field
    /// updates the bound value, as long as the formatter can parse the
    /// text. If the format style can't parse the input, the bound value
    /// remains unchanged.
    ///
    /// Use the ``View/onSubmit(of:_:)`` modifier to invoke an action
    /// whenever the user submits this text field.
    ///
    /// The following example uses a
    /// as the bound value, and a
    /// instance to convert to and from a string representation. The formatter
    /// uses the
    /// style, to allow entering a fractional part. As the user types, the bound
    /// value updates, which in turn updates three ``Text`` views that use
    /// different format styles. If the user enters text that doesn't represent
    /// a valid `Double`, the bound value doesn't update.
    ///
    ///     @State private var myDouble: Double = 0.673
    ///     @State private var numberFormatter: NumberFormatter = {
    ///         var nf = NumberFormatter()
    ///         nf.numberStyle = .decimal
    ///         return nf
    ///     }()
    ///
    ///     var body: some View {
    ///         VStack {
    ///             TextField(
    ///                 value: $myDouble,
    ///                 formatter: numberFormatter
    ///             ) {
    ///                 Text("Double")
    ///             }
    ///             Text(myDouble, format: .number)
    ///             Text(myDouble, format: .number.precision(.significantDigits(5)))
    ///             Text(myDouble, format: .number.notation(.scientific))
    ///         }
    ///     }
    ///
    /// - Parameters:
    ///   - title: The title of the text view, describing its purpose.
    ///   - value: The underlying value to edit.
    ///   - formatter: A formatter to use when converting between the
    ///     string the user edits and the underlying value of type `V`.
    ///     If `formatter` can't perform the conversion, the text field doesn't
    ///     modify `binding.value`.
//    @available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
//    public init<S, V>(_ title: S, value: Binding<V>, formatter: Formatter) where S : StringProtocol { fatalError() }
//}

#endif
#endif
