// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

#if !SKIP_BRIDGE
#if SKIP
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Row
import androidx.compose.material.ContentAlpha
import androidx.compose.material3.Switch
import androidx.compose.material3.SwitchColors
import androidx.compose.material3.SwitchDefaults
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
#endif

public struct Toggle : View {
    let isOn: Binding<Bool>
    let label: any View

    public init(isOn: Binding<Bool>, @ViewBuilder label: () -> any View) {
        self.isOn = isOn
        self.label = label()
    }

    @available(*, unavailable)
    public init(sources: Any, isOn: (Any) -> Binding<Bool>, @ViewBuilder label: () -> any View) {
        self.init(isOn: isOn(0), label: label)
    }

    @available(*, unavailable)
    public init(_ titleKey: LocalizedStringKey, sources: Any, isOn: (Any) -> Binding<Bool>) {
        self.init(isOn: isOn(0), label: { Text(titleKey) })
    }

    @available(*, unavailable)
    public init(_ title: String, sources: Any, isOn: (Any) -> Binding<Bool>) {
        self.init(isOn: isOn(0), label: { Text(verbatim: title) })
    }

    #if SKIP
    public init(_ titleKey: LocalizedStringKey, isOn: Binding<Bool>) {
        self.init(isOn: isOn, label: { Text(titleKey) })
    }

    public init(_ title: String, isOn: Binding<Bool>) {
        self.init(isOn: isOn, label: { Text(verbatim: title) })
    }
    
    @Composable public override func ComposeContent(context: ComposeContext) {
        let colors: SwitchColors
        if let tint = EnvironmentValues.shared._tint {
            let tintColor = tint.colorImpl()
            colors = SwitchDefaults.colors(checkedTrackColor: tintColor, disabledCheckedTrackColor: tintColor.copy(alpha: ContentAlpha.disabled))
        } else {
            colors = SwitchDefaults.colors()
        }
        if EnvironmentValues.shared._labelsHidden {
            PaddingLayout(padding: EdgeInsets(top: -6.0, leading: 0.0, bottom: -6.0, trailing: 0.0), context: context) { context in
                Switch(modifier: context.modifier, checked: isOn.wrappedValue, onCheckedChange: { isOn.wrappedValue = $0 }, enabled: EnvironmentValues.shared.isEnabled, colors: colors)
            }
        } else {
            let contentContext = context.content()
            ComposeContainer(modifier: context.modifier, fillWidth: true) { modifier in
                Row(modifier: modifier, verticalAlignment: androidx.compose.ui.Alignment.CenterVertically) {
                    Box(modifier: Modifier.weight(Float(1.0))) {
                        label.Compose(context: contentContext)
                    }
                    PaddingLayout(padding: EdgeInsets(top: -6.0, leading: 0.0, bottom: -6.0, trailing: 0.0), context: context) { context in
                        Switch(checked: isOn.wrappedValue, onCheckedChange: { isOn.wrappedValue = $0 }, enabled: EnvironmentValues.shared.isEnabled, colors: colors)
                    }
                }
            }
        }
    }
    #else
    public var body: some View {
        stubView()
    }
    #endif
}

public struct ToggleStyle: RawRepresentable, Equatable {
    public let rawValue: Int

    public init(rawValue: Int) {
        self.rawValue = rawValue
    }

    public static let automatic = ButtonStyle(rawValue: 0)

    @available(*, unavailable)
    public static let button = ButtonStyle(rawValue: 1)

    public static let `switch` = ButtonStyle(rawValue: 2)
}

extension View {
    public func toggleStyle(_ style: ToggleStyle) -> some View {
        // We only support Android's Switch control
        return self
    }
}

#if false
//@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
//extension Toggle where Label == ToggleStyleConfiguration.Label {

    /// Creates a toggle based on a toggle style configuration.
    ///
    /// You can use this initializer within the
    /// ``ToggleStyle/makeBody(configuration:)`` method of a ``ToggleStyle`` to
    /// create an instance of the styled toggle. This is useful for custom
    /// toggle styles that only modify the current toggle style, as opposed to
    /// implementing a brand new style.
    ///
    /// For example, the following style adds a red border around the toggle,
    /// but otherwise preserves the toggle's current style:
    ///
    ///     struct RedBorderToggleStyle: ToggleStyle {
    ///         func makeBody(configuration: Configuration) -> some View {
    ///             Toggle(configuration)
    ///                 .padding()
    ///                 .border(.red)
    ///         }
    ///     }
    ///
    /// - Parameter configuration: The properties of the toggle, including a
    ///   label and a binding to the toggle's state.
//    @available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
//    public init(_ configuration: ToggleStyleConfiguration) { fatalError() }
//}

/// The properties of a toggle instance.
///
/// When you define a custom toggle style by creating a type that conforms to
/// the ``ToggleStyle`` protocol, you implement the
/// ``ToggleStyle/makeBody(configuration:)`` method. That method takes a
/// `ToggleStyleConfiguration` input that has the information you need
/// to define the behavior and appearance of a ``Toggle``.
///
/// The configuration structure's ``label-swift.property`` reflects the
/// toggle's content, which might be the value that you supply to the
/// `label` parameter of the ``Toggle/init(isOn:label:)`` initializer.
/// Alternatively, it could be another view that SkipUI builds from an
/// initializer that takes a string input, like ``Toggle/init(_:isOn:)-8qx3l``.
/// In either case, incorporate the label into the toggle's view to help
/// the user understand what the toggle does. For example, the built-in
/// ``ToggleStyle/switch`` style horizontally stacks the label with the
/// control element.
///
/// The structure's ``isOn`` property provides a ``Binding`` to the state
/// of the toggle. Adjust the appearance of the toggle based on this value.
/// For example, the built-in ``ToggleStyle/button`` style fills the button's
/// background when the property is `true`, but leaves the background empty
/// when the property is `false`. Change the value when the user performs
/// an action that's meant to change the toggle, like the button does when
/// tapped or clicked by the user.
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
public struct ToggleStyleConfiguration {

    /// A type-erased label of a toggle.
    ///
    /// SkipUI provides a value of this type --- which is a ``View`` type ---
    /// as the ``label-swift.property`` to your custom toggle style
    /// implementation. Use the label to help define the appearance of the
    /// toggle.
    public struct Label : View {

        /// The type of view representing the body of this view.
        ///
        /// When you create a custom view, Swift infers this type from your
        /// implementation of the required ``View/body-swift.property`` property.
        public typealias Body = NeverView
        public var body: Body { fatalError() }
    }

    /// A view that describes the effect of switching the toggle between states.
    ///
    /// Use this value in your implementation of the
    /// ``ToggleStyle/makeBody(configuration:)`` method when defining a custom
    /// ``ToggleStyle``. Access it through the that method's `configuration`
    /// parameter.
    ///
    /// Because the label is a ``View``, you can incorporate it into the
    /// view hierarchy that you return from your style definition. For example,
    /// you can combine the label with a circle image in an ``HStack``:
    ///
    ///     HStack {
    ///         Image(systemName: configuration.isOn
    ///             ? "checkmark.circle.fill"
    ///             : "circle")
    ///         configuration.label
    ///     }
    ///
    public let label: ToggleStyleConfiguration.Label = { fatalError() }()

    /// A binding to a state property that indicates whether the toggle is on.
    ///
    /// Because this value is a ``Binding``, you can both read and write it
    /// in your implementation of the ``ToggleStyle/makeBody(configuration:)``
    /// method when defining a custom ``ToggleStyle``. Access it through
    /// that method's `configuration` parameter.
    ///
    /// Read this value to set the appearance of the toggle. For example, you
    /// can choose between empty and filled circles based on the `isOn` value:
    ///
    ///     Image(systemName: configuration.isOn
    ///         ? "checkmark.circle.fill"
    ///         : "circle")
    ///
    /// Write this value when the user takes an action that's meant to change
    /// the state of the toggle. For example, you can toggle it inside the
    /// `action` closure of a ``Button`` instance:
    ///
    ///     Button {
    ///         configuration.isOn.toggle()
    ///     } label: {
    ///         // Draw the toggle.
    ///     }
    ///
//    @Binding public var isOn: Bool { get { fatalError() } nonmutating set { } }

//    public var $isOn: Binding<Bool> { get { fatalError() } }

    /// Whether the ``Toggle`` is currently in a mixed state.
    ///
    /// Use this property to determine whether the toggle style should render
    /// a mixed state presentation. A mixed state corresponds to an underlying
    /// collection with a mix of true and false Bindings.
    /// To toggle the state, use the ``Bool.toggle()`` method on the ``isOn``
    /// binding.
    ///
    /// In the following example, a custom style uses the `isMixed` property
    /// to render the correct toggle state using symbols:
    ///
    ///     struct SymbolToggleStyle: ToggleStyle {
    ///         func makeBody(configuration: Configuration) -> some View {
    ///             Button {
    ///                 configuration.isOn.toggle()
    ///             } label: {
    ///                 Image(
    ///                     systemName: configuration.isMixed
    ///                     ? "minus.circle.fill" : configuration.isOn
    ///                     ? "checkmark.circle.fill" : "circle.fill")
    ///                 configuration.label
    ///             }
    ///         }
    ///     }
    @available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
    public var isMixed: Bool { get { fatalError() } }
}

#endif
#endif
