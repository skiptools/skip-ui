// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

#if !SKIP
import struct CoreGraphics.CGFloat
import struct CoreGraphics.CGRect
#endif

// SKIP INSERT:
// import androidx.compose.foundation.clickable
// import androidx.compose.foundation.layout.Box
// import androidx.compose.runtime.Composable
// import androidx.compose.ui.Modifier

// Erase the generic Label to facilitate specialized constructor support.
//
// SKIP DECLARE: class Button: View, ListItemAdapting
public struct Button<Label> : View, ListItemAdapting where Label : View {
    let action: () -> Void
    let label: any View

    public init(action: @escaping () -> Void, @ViewBuilder label: () -> any View) {
        self.action = action
        self.label = label()
    }

    #if SKIP
    public init(_ title: String, action: @escaping () -> Void) {
        self.init(action: action, label: { Text(title) })
    }

    /*
     https://cs.android.com/androidx/platform/frameworks/support/+/androidx-main:compose/material3/material3/src/commonMain/kotlin/androidx/compose/material3/Button.kt
     @Composable
     fun Button(
        onClick: () -> Unit,
        modifier: Modifier = Modifier,
        enabled: Boolean = true,
        shape: Shape = ButtonDefaults.shape,
        colors: ButtonColors = ButtonDefaults.buttonColors(),
        elevation: ButtonElevation? = ButtonDefaults.buttonElevation(),
        border: BorderStroke? = null,
        contentPadding: PaddingValues = ButtonDefaults.ContentPadding,
        interactionSource: MutableInteractionSource = remember { MutableInteractionSource() },
        content: @Composable RowScope.() -> Unit
     )
     */
    @Composable public override func ComposeContent(context: ComposeContext) {
        let contentContext = context.content()
        androidx.compose.material3.Button(modifier: context.modifier, onClick: action, content: {
            label.Compose(context: contentContext)
        })
    }

    @Composable func ComposeListItem(context: ComposeContext, contentModifier: Modifier) {
        Box(modifier: Modifier.clickable(onClick: action)) {
            Box(modifier: contentModifier, contentAlignment: androidx.compose.ui.Alignment.CenterStart) {
                label.Compose(context)
            }
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

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension Button where Label == PrimitiveButtonStyleConfiguration.Label {

    /// Creates a button based on a configuration for a style with a custom
    /// appearance and custom interaction behavior.
    ///
    /// Use this initializer within the
    /// ``PrimitiveButtonStyle/makeBody(configuration:)`` method of a
    /// ``PrimitiveButtonStyle`` to create an instance of the button that you
    /// want to style. This is useful for custom button styles that modify the
    /// current button style, rather than implementing a brand new style.
    ///
    /// For example, the following style adds a red border around the button,
    /// but otherwise preserves the button's current style:
    ///
    ///     struct RedBorderedButtonStyle: PrimitiveButtonStyle {
    ///         func makeBody(configuration: Configuration) -> some View {
    ///             Button(configuration)
    ///                 .border(Color.red)
    ///         }
    ///     }
    ///
    /// - Parameter configuration: A configuration for a style with a custom
    ///   appearance and custom interaction behavior.
    @available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
    public init(_ configuration: PrimitiveButtonStyleConfiguration) { fatalError() }
}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
extension Button {

    /// Creates a button with a specified role that displays a custom label.
    ///
    /// - Parameters:
    ///   - role: An optional semantic role that describes the button. A value of
    ///     `nil` means that the button doesn't have an assigned role.
    ///   - action: The action to perform when the user interacts with the button.
    ///   - label: A view that describes the purpose of the button's `action`.
    public init(role: ButtonRole?, action: @escaping () -> Void, @ViewBuilder label: () -> Label) { fatalError() }
}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
extension Button where Label == Text {

    /// Creates a button with a specified role that generates its label from a
    /// localized string key.
    ///
    /// This initializer creates a ``Text`` view on your behalf, and treats the
    /// localized key similar to ``Text/init(_:tableName:bundle:comment:)``. See
    /// ``Text`` for more information about localizing strings.
    ///
    /// To initialize a button with a string variable, use
    /// ``init(_:role:action:)-8y5yk`` instead.
    ///
    /// - Parameters:
    ///   - titleKey: The key for the button's localized title, that describes
    ///     the purpose of the button's `action`.
    ///   - role: An optional semantic role describing the button. A value of
    ///     `nil` means that the button doesn't have an assigned role.
    ///   - action: The action to perform when the user triggers the button.
    public init(_ titleKey: LocalizedStringKey, role: ButtonRole?, action: @escaping () -> Void) { fatalError() }

    /// Creates a button with a specified role that generates its label from a
    /// string.
    ///
    /// This initializer creates a ``Text`` view on your behalf, and treats the
    /// title similar to ``Text/init(_:)-9d1g4``. See ``Text`` for more
    /// information about localizing strings.
    ///
    /// To initialize a button with a localized string key, use
    /// ``init(_:role:action:)-93ek6`` instead.
    ///
    /// - Parameters:
    ///   - title: A string that describes the purpose of the button's `action`.
    ///   - role: An optional semantic role describing the button. A value of
    ///     `nil` means that the button doesn't have an assigned role.
    ///   - action: The action to perform when the user interacts with the button.
    public init<S>(_ title: S, role: ButtonRole?, action: @escaping () -> Void) where S : StringProtocol { fatalError() }
}


/// A shape that is used to draw a button's border.
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public struct ButtonBorderShape : Equatable, Sendable {

    /// A shape that defers to the system to determine an appropriate shape
    /// for the given context and platform.
    public static let automatic: ButtonBorderShape = { fatalError() }()

    /// A capsule shape.
    ///
    /// - Note: This has no effect on non-widget system buttons on macOS.
    @available(macOS 14.0, tvOS 17.0, *)
    public static let capsule: ButtonBorderShape = { fatalError() }()

    /// A rounded rectangle shape.
    public static let roundedRectangle: ButtonBorderShape = { fatalError() }()

    /// A rounded rectangle shape.
    ///
    /// - Parameter radius: the corner radius of the rectangle.
    /// - Note: This has no effect on non-widget system buttons on macOS.
    @available(macOS 14.0, tvOS 17.0, *)
    public static func roundedRectangle(radius: CGFloat) -> ButtonBorderShape { fatalError() }

    @available(iOS 17.0, macOS 14.0, tvOS 16.4, watchOS 10.0, *)
    public static let circle: ButtonBorderShape = { fatalError() }()

    
}

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension ButtonBorderShape : InsettableShape {

    /// Returns `self` inset by `amount`.
    public func inset(by amount: CGFloat) -> InsetShape { fatalError() }


    /// The type of the inset shape.
    public typealias InsetShape = Never
}

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension ButtonBorderShape : Shape {

    /// Describes this shape as a path within a rectangular frame of reference.
    ///
    /// - Parameter rect: The frame of reference for describing this shape.
    ///
    /// - Returns: A path that describes this shape.
    public func path(in rect: CGRect) -> Path { fatalError() }

    /// The type defining the data to animate.
    public typealias AnimatableData = EmptyAnimatableData
    public var animatableData: AnimatableData { get { fatalError() } set { } }

    /// The type of view representing the body of this view.
    ///
    /// When you create a custom view, Swift infers this type from your
    /// implementation of the required ``View/body-swift.property`` property.
    public typealias Body = NeverView
    public var body: Body { fatalError() }
}

/// A button style that doesn't apply a border.
///
/// You can also use ``PrimitiveButtonStyle/borderless`` to construct this
/// style.
@available(iOS 13.0, macOS 10.15, tvOS 17.0, watchOS 8.0, *)
public struct BorderlessButtonStyle : PrimitiveButtonStyle {

    /// Creates a borderless button style.
    public init() { fatalError() }

    /// Creates a view that represents the body of a button.
    ///
    /// The system calls this method for each ``Button`` instance in a view
    /// hierarchy where this style is the current button style.
    ///
    /// - Parameter configuration : The properties of the button.
    public func makeBody(configuration: BorderlessButtonStyle.Configuration) -> some View { return stubView() }


    /// A view that represents the body of a button.
//    public typealias Body = some View
}

/// A type that applies standard interaction behavior and a custom appearance to
/// all buttons within a view hierarchy.
///
/// To configure the current button style for a view hierarchy, use the
/// ``View/buttonStyle(_:)-7qx1`` modifier. Specify a style that conforms to
/// `ButtonStyle` when creating a button that uses the standard button
/// interaction behavior defined for each platform. To create a button with
/// custom interaction behavior, use ``PrimitiveButtonStyle`` instead.
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
public protocol ButtonStyle {

    /// A view that represents the body of a button.
    associatedtype Body : View

    /// Creates a view that represents the body of a button.
    ///
    /// The system calls this method for each ``Button`` instance in a view
    /// hierarchy where this style is the current button style.
    ///
    /// - Parameter configuration : The properties of the button.
    @ViewBuilder func makeBody(configuration: Self.Configuration) -> Self.Body

    /// The properties of a button.
    typealias Configuration = ButtonStyleConfiguration
}

/// The properties of a button.
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
public struct ButtonStyleConfiguration {

    /// A type-erased label of a button.
    public struct Label : View {

        /// The type of view representing the body of this view.
        ///
        /// When you create a custom view, Swift infers this type from your
        /// implementation of the required ``View/body-swift.property`` property.
        public typealias Body = NeverView
        public var body: Body { fatalError() }
    }

    /// An optional semantic role that describes the button's purpose.
    ///
    /// A value of `nil` means that the Button doesn't have an assigned role. If
    /// the button does have a role, use it to make adjustments to the button's
    /// appearance. The following example shows a custom style that uses
    /// bold text when the role is ``ButtonRole/cancel``,
    /// ``ShapeStyle/red`` text when the role is ``ButtonRole/destructive``,
    /// and adds no special styling otherwise:
    ///
    ///     struct MyButtonStyle: ButtonStyle {
    ///         func makeBody(configuration: Configuration) -> some View {
    ///             configuration.label
    ///                 .font(
    ///                     configuration.role == .cancel ? .title2.bold() : .title2)
    ///                 .foregroundColor(
    ///                     configuration.role == .destructive ? Color.red : nil)
    ///         }
    ///     }
    ///
    /// You can create one of each button using this style to see the effect:
    ///
    ///     VStack(spacing: 20) {
    ///         Button("Cancel", role: .cancel) {}
    ///         Button("Delete", role: .destructive) {}
    ///         Button("Continue") {}
    ///     }
    ///     .buttonStyle(MyButtonStyle())
    ///
    /// ![A screenshot of three buttons stacked vertically. The first says
    /// Cancel in black, bold letters. The second says Delete in red, regular
    /// weight letters. The third says Continue in black, regular weight
    /// letters.](ButtonStyleConfiguration-role-1)
    @available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
    public let role: ButtonRole?

    /// A view that describes the effect of pressing the button.
    public let label: ButtonStyleConfiguration.Label = { fatalError() }()

    /// A Boolean that indicates whether the user is currently pressing the
    /// button.
    public let isPressed: Bool = { fatalError() }()
}

/// A button style that applies standard border artwork based on the button's
/// context.
///
/// You can also use ``PrimitiveButtonStyle/bordered`` to construct this style.
@available(iOS 15.0, macOS 10.15, tvOS 13.0, watchOS 7.0, *)
public struct BorderedButtonStyle : PrimitiveButtonStyle {

    /// Creates a bordered button style.
    public init() { fatalError() }

    /// Creates a view that represents the body of a button.
    ///
    /// The system calls this method for each ``Button`` instance in a view
    /// hierarchy where this style is the current button style.
    ///
    /// - Parameter configuration: The properties of the button.
    public func makeBody(configuration: BorderedButtonStyle.Configuration) -> some View { return stubView() }


    /// A view that represents the body of a button.
//    public typealias Body = some View
}

/// A button style that applies standard border prominent artwork based
/// on the button's context.
///
/// You can also use ``borderedProminent`` to construct this style.
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public struct BorderedProminentButtonStyle : PrimitiveButtonStyle {

    /// Creates a bordered prominent button style.
    public init() { fatalError() }

    /// Creates a view that represents the body of a button.
    ///
    /// The system calls this method for each ``Button`` instance in a view
    /// hierarchy where this style is the current button style.
    ///
    /// - Parameter configuration : The properties of the button.
    public func makeBody(configuration: BorderedProminentButtonStyle.Configuration) -> some View { return stubView() }


    /// A view that represents the body of a button.
//    public typealias Body = some View
}

/// The default button style, based on the button's context.
///
/// You can also use ``PrimitiveButtonStyle/automatic`` to construct this style.
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
public struct DefaultButtonStyle : PrimitiveButtonStyle {

    /// Creates a default button style.
    public init() { fatalError() }

    /// Creates a view that represents the body of a button.
    ///
    /// The system calls this method for each ``Button`` instance in a view
    /// hierarchy where this style is the current button style.
    ///
    /// - Parameter configuration : The properties of the button.
    public func makeBody(configuration: DefaultButtonStyle.Configuration) -> some View { return stubView() }


    /// A view that represents the body of a button.
//    public typealias Body = some View
}

/// A button style that doesn't style or decorate its content while idle, but
/// may apply a visual effect to indicate the pressed, focused, or enabled state
/// of the button.
///
/// You can also use ``PrimitiveButtonStyle/plain`` to construct this style.
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
public struct PlainButtonStyle : PrimitiveButtonStyle {

    /// Creates a plain button style.
    public init() { fatalError() }

    /// Creates a view that represents the body of a button.
    ///
    /// The system calls this method for each ``Button`` instance in a view
    /// hierarchy where this style is the current button style.
    ///
    /// - Parameter configuration : The properties of the button.
    public func makeBody(configuration: PlainButtonStyle.Configuration) -> some View { return stubView() }


    /// A view that represents the body of a button.
//    public typealias Body = some View
}

/// A type that applies custom interaction behavior and a custom appearance to
/// all buttons within a view hierarchy.
///
/// To configure the current button style for a view hierarchy, use the
/// ``View/buttonStyle(_:)-66fbx`` modifier. Specify a style that conforms to
/// `PrimitiveButtonStyle` to create a button with custom interaction
/// behavior. To create a button with the standard button interaction behavior
/// defined for each platform, use ``ButtonStyle`` instead.
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
public protocol PrimitiveButtonStyle {

    /// A view that represents the body of a button.
    associatedtype Body : View

    /// Creates a view that represents the body of a button.
    ///
    /// The system calls this method for each ``Button`` instance in a view
    /// hierarchy where this style is the current button style.
    ///
    /// - Parameter configuration : The properties of the button.
    @ViewBuilder func makeBody(configuration: Self.Configuration) -> Self.Body

    /// The properties of a button.
    typealias Configuration = PrimitiveButtonStyleConfiguration
}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
extension PrimitiveButtonStyle where Self == BorderedProminentButtonStyle {

    /// A button style that applies standard border prominent artwork based on
    /// the button's context.
    ///
    /// To apply this style to a button, or to a view that contains buttons, use
    /// the ``View/buttonStyle(_:)-66fbx`` modifier.
    public static var borderedProminent: BorderedProminentButtonStyle { get { fatalError() } }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension PrimitiveButtonStyle where Self == PlainButtonStyle {

    /// A button style that doesn't style or decorate its content while idle,
    /// but may apply a visual effect to indicate the pressed, focused, or
    /// enabled state of the button.
    ///
    /// To apply this style to a button, or to a view that contains buttons, use
    /// the ``View/buttonStyle(_:)-66fbx`` modifier.
    public static var plain: PlainButtonStyle { get { fatalError() } }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension PrimitiveButtonStyle where Self == DefaultButtonStyle {

    /// The default button style, based on the button's context.
    ///
    /// If you create a button directly on a blank canvas, the style varies by
    /// platform. iOS uses the borderless button style by default, whereas macOS,
    /// tvOS, and watchOS use the bordered button style.
    ///
    /// If you create a button inside a container, like a ``List``, the style
    /// resolves to the recommended style for buttons inside that container for
    /// that specific platform.
    ///
    /// You can override a button's style. To apply the default style to a
    /// button, or to a view that contains buttons, use the
    /// ``View/buttonStyle(_:)-66fbx`` modifier.
    public static var automatic: DefaultButtonStyle { get { fatalError() } }
}

@available(iOS 13.0, macOS 10.15, tvOS 17.0, watchOS 8.0, *)
extension PrimitiveButtonStyle where Self == BorderlessButtonStyle {

    /// A button style that doesn't apply a border.
    ///
    /// To apply this style to a button, or to a view that contains buttons, use
    /// the ``View/buttonStyle(_:)-66fbx`` modifier.
    ///
    /// On tvOS, this button style adds a default hover effect to the first
    /// image of the button's content, if one exists. You can supply a different
    /// hover effect by using the ``View/hoverEffect(_:)`` modifier in the
    /// button's label.
    public static var borderless: BorderlessButtonStyle { get { fatalError() } }
}

@available(iOS 15.0, macOS 10.15, tvOS 13.0, watchOS 7.0, *)
extension PrimitiveButtonStyle where Self == BorderedButtonStyle {

    /// A button style that applies standard border artwork based on the
    /// button's context.
    ///
    /// To apply this style to a button, or to a view that contains buttons, use
    /// the ``View/buttonStyle(_:)-66fbx`` modifier.
    public static var bordered: BorderedButtonStyle { get { fatalError() } }
}

/// The properties of a button.
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
public struct PrimitiveButtonStyleConfiguration {

    /// A type-erased label of a button.
    public struct Label : View {

        /// The type of view representing the body of this view.
        ///
        /// When you create a custom view, Swift infers this type from your
        /// implementation of the required ``View/body-swift.property`` property.
        public typealias Body = NeverView
        public var body: Body { fatalError() }
    }

    /// An optional semantic role describing the button's purpose.
    ///
    /// A value of `nil` means that the Button has no assigned role. If the
    /// button does have a role, use it to make adjustments to the button's
    /// appearance. The following example shows a custom style that uses
    /// bold text when the role is ``ButtonRole/cancel``,
    /// ``ShapeStyle/red`` text when the role is ``ButtonRole/destructive``,
    /// and adds no special styling otherwise:
    ///
    ///     struct MyButtonStyle: PrimitiveButtonStyle {
    ///         func makeBody(configuration: Configuration) -> some View {
    ///             configuration.label
    ///                 .onTapGesture {
    ///                     configuration.trigger()
    ///                 }
    ///                 .font(
    ///                     configuration.role == .cancel ? .title2.bold() : .title2)
    ///                 .foregroundColor(
    ///                     configuration.role == .destructive ? Color.red : nil)
    ///         }
    ///     }
    ///
    /// You can create one of each button using this style to see the effect:
    ///
    ///     VStack(spacing: 20) {
    ///         Button("Cancel", role: .cancel) {}
    ///         Button("Delete", role: .destructive) {}
    ///         Button("Continue") {}
    ///     }
    ///     .buttonStyle(MyButtonStyle())
    ///
    /// ![A screenshot of three buttons stacked vertically. The first says
    /// Cancel in black, bold letters. The second says Delete in red, regular
    /// weight letters. The third says Continue in black, regular weight
    /// letters.](PrimitiveButtonStyleConfiguration-role-1)
    @available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
    public let role: ButtonRole?

    /// A view that describes the effect of calling the button's action.
    public let label: PrimitiveButtonStyleConfiguration.Label = { fatalError() }()

    /// Performs the button's action.
    public func trigger() { fatalError() }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension View {

    /// Sets the style for buttons within this view to a button style with a
    /// custom appearance and custom interaction behavior.
    ///
    /// Use this modifier to set a specific style for button instances
    /// within a view:
    ///
    ///     HStack {
    ///         Button("Sign In", action: signIn)
    ///         Button("Register", action: register)
    ///     }
    ///     .buttonStyle(.bordered)
    ///
    public func buttonStyle<S>(_ style: S) -> some View where S : PrimitiveButtonStyle { return stubView() }

}

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension View {

    /// Sets whether buttons in this view should repeatedly trigger their
    /// actions on prolonged interactions.
    ///
    /// Apply this to buttons that increment or decrement a value or perform
    /// some other inherently iterative operation. Interactions such as
    /// pressing-and-holding on the button, holding the button's keyboard
    /// shortcut, or holding down the space key while the button is focused will
    /// trigger this repeat behavior.
    ///
    ///     Button {
    ///         playbackSpeed.advance(by: 1)
    ///     } label: {
    ///         Label("Speed up", systemImage: "hare")
    ///     }
    ///     .buttonRepeatBehavior(.enabled)
    ///
    /// This affects all system button styles, as well as automatically
    /// affects custom `ButtonStyle` conforming types. This does not
    /// automatically apply to custom `PrimitiveButtonStyle` conforming types,
    /// and the ``EnvironmentValues.buttonRepeatBehavior`` value should be used
    /// to adjust their custom gestures as appropriate.
    ///
    /// - Parameter behavior: A value of `enabled` means that buttons should
    ///   enable repeating behavior and a value of `disabled` means that buttons
    ///   should disallow repeating behavior.
    public func buttonRepeatBehavior(_ behavior: ButtonRepeatBehavior) -> some View { return stubView() }

}



@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension View {

    /// Sets the style for buttons within this view to a button style with a
    /// custom appearance and standard interaction behavior.
    ///
    /// Use this modifier to set a specific style for all button instances
    /// within a view:
    ///
    ///     HStack {
    ///         Button("Sign In", action: signIn)
    ///         Button("Register", action: register)
    ///     }
    ///     .buttonStyle(.bordered)
    ///
    /// You can also use this modifier to set the style for controls with a button
    /// style through composition:
    ///
    ///     VStack {
    ///         Menu("Terms and Conditions") {
    ///             Button("Open in Preview", action: openInPreview)
    ///             Button("Save as PDF", action: saveAsPDF)
    ///         }
    ///         Toggle("Remember Password", isOn: $isToggleOn)
    ///         Toggle("Flag", isOn: $flagged)
    ///         Button("Sign In", action: signIn)
    ///     }
    ///     .menuStyle(.button)
    ///     .toggleStyle(.button)
    ///     .buttonStyle(.bordered)
    ///
    /// In this example, `.menuStyle(.button)` says that the Terms and
    /// Conditions menu renders as a button, while
    /// `.toggleStyle(.button)` says that the two toggles also render as
    /// buttons. Finally, `.buttonStyle(.bordered)` says that the menu,
    /// both toggles, and the Sign In button all render with the
    /// bordered button style.```
    public func buttonStyle<S>(_ style: S) -> some View where S : ButtonStyle { return stubView() }

}


@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
extension View {

    /// Sets the border shape for buttons in this view.
    ///
    /// The border shape is used to draw the platter for a bordered button.
    /// On macOS, the specified border shape is only applied to bordered
    /// buttons in widgets.
    ///
    /// - Parameter shape: the shape to use.
    /// - Note:This will only reflect on explicitly-set `.bordered` or
    ///   `borderedProminent` styles. Setting a shape without
    ///   explicitly setting the above styles will have no effect.
    public func buttonBorderShape(_ shape: ButtonBorderShape) -> some View { return stubView() }

}

#endif
