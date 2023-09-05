// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

// SKIP INSERT: import androidx.compose.runtime.Composable
// SKIP INSERT: import androidx.compose.foundation.layout.fillMaxWidth

// Erase the generic Label to facilitate specialized constructor support.
//
// SKIP DECLARE: class TextField: View
public struct TextField<Label> : View where Label : View {
    let text: Binding<String>
    let label: any View
    let prompt: Text?

    public init(text: Binding<String>, prompt: Text? = nil, @ViewBuilder label: () -> any View) {
        self.text = text
        self.label = label()
        self.prompt = prompt
    }

    public init(_ title: String, text: Binding<String>, prompt: Text? = nil) {
        self.init(text: text, prompt: prompt, label: { Text(title) })
    }

    #if SKIP
    /*
     https://cs.android.com/androidx/platform/frameworks/support/+/androidx-main:compose/material3/material3/src/commonMain/kotlin/androidx/compose/material3/TextField.kt
     @Composable
     fun TextField(
         value: String,
         onValueChange: (String) -> Unit,
         modifier: Modifier = Modifier,
         enabled: Boolean = true,
         readOnly: Boolean = false,
         textStyle: TextStyle = LocalTextStyle.current,
         label: @Composable (() -> Unit)? = null,
         placeholder: @Composable (() -> Unit)? = null,
         leadingIcon: @Composable (() -> Unit)? = null,
         trailingIcon: @Composable (() -> Unit)? = null,
         prefix: @Composable (() -> Unit)? = null,
         suffix: @Composable (() -> Unit)? = null,
         supportingText: @Composable (() -> Unit)? = null,
         isError: Boolean = false,
         visualTransformation: VisualTransformation = VisualTransformation.None,
         keyboardOptions: KeyboardOptions = KeyboardOptions.Default,
         keyboardActions: KeyboardActions = KeyboardActions.Default,
         singleLine: Boolean = false,
         maxLines: Int = if (singleLine) 1 else Int.MAX_VALUE,
         minLines: Int = 1,
         interactionSource: MutableInteractionSource = remember { MutableInteractionSource() },
         shape: Shape = TextFieldDefaults.shape,
         colors: TextFieldColors = TextFieldDefaults.colors()
     )
     */
    @Composable public override func ComposeContent(context: ComposeContext) {
        // TODO: Form styling support
        let contentContext = context.content()
        androidx.compose.material3.TextField(value: text.wrappedValue, onValueChange: { text.wrappedValue = $0 }, modifier: context.modifier.fillMaxWidth(), placeholder: { Placeholder(context: contentContext) }, singleLine: true)
    }

    @Composable private func Placeholder(context: ComposeContext) {
        if let prompt {
            prompt.Compose(context: context)
        } else {
            label.Compose(context: context)
        }
    }
    #else
    public var body: some View {
        stubView()
    }
    #endif
}

#if !SKIP

// TODO: Process for use in SkipUI

import class Foundation.Formatter
import protocol Foundation.ParseableFormatStyle

extension TextField where Label == Text {

    /// Creates a text field with a preferred axis and a text label generated
    /// from a localized title string.
    ///
    /// Specify a preferred axis in which the text field should scroll
    /// its content when it does not fit in the available space. Depending
    /// on the style of the field, this axis may not be respected.
    ///
    /// Use the ``View/onSubmit(of:_:)`` modifier to invoke an action
    /// whenever the user submits this text field.
    ///
    /// - Parameters:
    ///   - titleKey: The key for the localized title of the text field,
    ///     describing its purpose.
    ///   - text: The text to display and edit.
    ///   - axis: The axis in which to scroll text when it doesn't fit
    ///     in the available space.
    @available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
    public init(_ titleKey: LocalizedStringKey, text: Binding<String>, axis: Axis) { fatalError() }

    /// Creates a text field with a preferred axis and a text label generated
    /// from a localized title string.
    ///
    /// Specify a preferred axis in which the text field should scroll
    /// its content when it does not fit in the available space. Depending
    /// on the style of the field, this axis may not be respected.
    ///
    /// Use the ``View/onSubmit(of:_:)`` modifier to invoke an action
    /// whenever the user submits this text field.
    ///
    /// - Parameters:
    ///   - titleKey: The key for the localized title of the text field,
    ///     describing its purpose.
    ///   - text: The text to display and edit.
    ///   - prompt: A `Text` representing the prompt of the text field
    ///     which provides users with guidance on what to type into the text
    ///     field.
    ///   - axis: The axis in which to scroll text when it doesn't fit
    ///     in the available space.
    @available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
    public init(_ titleKey: LocalizedStringKey, text: Binding<String>, prompt: Text?, axis: Axis) { fatalError() }

    /// Creates a text field with a preferred axis and a text label generated
    /// from a title string.
    ///
    /// Specify a preferred axis in which the text field should scroll
    /// its content when it does not fit in the available space. Depending
    /// on the style of the field, this axis may not be respected.
    ///
    /// Use the ``View/onSubmit(of:_:)`` modifier to invoke an action
    /// whenever the user submits this text field.
    ///
    /// - Parameters:
    ///   - title: The title of the text view, describing its purpose.
    ///   - text: The text to display and edit.
    ///   - axis: The axis in which to scroll text when it doesn't fit
    ///     in the available space.
    @available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
    public init<S>(_ title: S, text: Binding<String>, axis: Axis) where S : StringProtocol { fatalError() }

    /// Creates a text field with a text label generated from a title string.
    ///
    /// Specify a preferred axis in which the text field should scroll
    /// its content when it does not fit in the available space. Depending
    /// on the style of the field, this axis may not be respected.
    ///
    /// Use the ``View/onSubmit(of:_:)`` modifier to invoke an action
    /// whenever the user submits this text field.
    ///
    /// - Parameters:
    ///   - title: The title of the text view, describing its purpose.
    ///   - text: The text to display and edit.
    ///   - prompt: A `Text` representing the prompt of the text field
    ///     which provides users with guidance on what to type into the text
    ///     field.
    ///   - axis: The axis in which to scroll text when it doesn't fit
    ///     in the available space.
    @available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
    public init<S>(_ title: S, text: Binding<String>, prompt: Text?, axis: Axis) where S : StringProtocol { fatalError() }
}

extension TextField {

    /// Creates a text field with a preferred axis and a prompt generated from
    /// a `Text`.
    ///
    /// Specify a preferred axis in which the text field should scroll
    /// its content when it does not fit in the available space. Depending
    /// on the style of the field, this axis may not be respected.
    ///
    /// Use the ``View/onSubmit(of:_:)`` modifier to invoke an action
    /// whenever the user submits this text field.
    ///
    /// - Parameters:
    ///   - text: The text to display and edit.
    ///   - prompt: A `Text` representing the prompt of the text field
    ///     which provides users with guidance on what to type into the text
    ///     field.
    ///   - axis: The axis in which to scroll text when it doesn't fit
    ///     in the available space.
    ///   - label: A view that describes the purpose of the text field.
    @available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
    public init(text: Binding<String>, prompt: Text? = nil, axis: Axis, @ViewBuilder label: () -> Label) { fatalError() }
}

extension TextField where Label == Text {

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
    @available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
    public init<F>(_ titleKey: LocalizedStringKey, value: Binding<F.FormatInput?>, format: F, prompt: Text? = nil) where F : ParseableFormatStyle, F.FormatOutput == String { fatalError() }

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
    @available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
    public init<S, F>(_ title: S, value: Binding<F.FormatInput?>, format: F, prompt: Text? = nil) where S : StringProtocol, F : ParseableFormatStyle, F.FormatOutput == String { fatalError() }

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
    @available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
    public init<F>(_ titleKey: LocalizedStringKey, value: Binding<F.FormatInput>, format: F, prompt: Text? = nil) where F : ParseableFormatStyle, F.FormatOutput == String { fatalError() }

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
    @available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
    public init<S, F>(_ title: S, value: Binding<F.FormatInput>, format: F, prompt: Text? = nil) where S : StringProtocol, F : ParseableFormatStyle, F.FormatOutput == String { fatalError() }
}

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
    @available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
    public init<F>(value: Binding<F.FormatInput?>, format: F, prompt: Text? = nil, @ViewBuilder label: () -> Label) where F : ParseableFormatStyle, F.FormatOutput == String { fatalError() }

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
    @available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
    public init<F>(value: Binding<F.FormatInput>, format: F, prompt: Text? = nil, @ViewBuilder label: () -> Label) where F : ParseableFormatStyle, F.FormatOutput == String { fatalError() }
}

extension TextField where Label == Text {

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
    @available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
    public init<V>(_ titleKey: LocalizedStringKey, value: Binding<V>, formatter: Formatter, prompt: Text?) { fatalError() }

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
    @available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
    public init<S, V>(_ title: S, value: Binding<V>, formatter: Formatter, prompt: Text?) where S : StringProtocol { fatalError() }
}

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
    @available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
    public init<V>(value: Binding<V>, formatter: Formatter, prompt: Text? = nil, @ViewBuilder label: () -> Label) { fatalError() }
}

extension TextField where Label == Text {

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
    @available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
    public init<V>(_ titleKey: LocalizedStringKey, value: Binding<V>, formatter: Formatter) { fatalError() }

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
    @available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
    public init<S, V>(_ title: S, value: Binding<V>, formatter: Formatter) where S : StringProtocol { fatalError() }
}

/// A specification for the appearance and interaction of a text field.
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
public protocol TextFieldStyle {
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension TextFieldStyle where Self == DefaultTextFieldStyle {

    /// The default text field style, based on the text field's context.
    ///
    /// The default style represents the recommended style based on the
    /// current platform and the text field's context within the view hierarchy.
    public static var automatic: DefaultTextFieldStyle { get { fatalError() } }
}

@available(iOS 13.0, macOS 10.15, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension TextFieldStyle where Self == RoundedBorderTextFieldStyle {

    /// A text field style with a system-defined rounded border.
    public static var roundedBorder: RoundedBorderTextFieldStyle { get { fatalError() } }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension TextFieldStyle where Self == PlainTextFieldStyle {

    /// A text field style with no decoration.
    public static var plain: PlainTextFieldStyle { get { fatalError() } }
}

/// A text field style with no decoration.
///
/// You can also use ``TextFieldStyle/plain`` to construct this style.
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
public struct PlainTextFieldStyle : TextFieldStyle {

    public init() { fatalError() }
}

/// A text field style with a system-defined rounded border.
///
/// You can also use ``TextFieldStyle/roundedBorder`` to construct this style.
@available(iOS 13.0, macOS 10.15, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
public struct RoundedBorderTextFieldStyle : TextFieldStyle {

    public init() { fatalError() }
}


/// The default text field style, based on the text field's context.
///
/// You can also use ``TextFieldStyle/automatic`` to construct this style.
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
public struct DefaultTextFieldStyle : TextFieldStyle {

    public init() { fatalError() }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension View {

    /// Sets the style for text fields within this view.
    public func textFieldStyle<S>(_ style: S) -> some View where S : TextFieldStyle { return stubView() }

}

#endif
