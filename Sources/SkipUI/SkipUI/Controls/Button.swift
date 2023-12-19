// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

#if SKIP
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.material.ContentAlpha
import androidx.compose.material3.ButtonColors
import androidx.compose.material3.ButtonDefaults
import androidx.compose.material3.FilledTonalButton
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.unit.dp
#else
import struct CoreGraphics.CGFloat
import struct CoreGraphics.CGRect
#endif

// Erase the generic Label to facilitate specialized constructor support.
public struct Button : View, ListItemAdapting {
    let action: () -> Void
    let label: any View
    let role: ButtonRole?

    public init(action: @escaping () -> Void, @ViewBuilder label: () -> any View) {
        self.init(role: nil, action: action, label: label)
    }

    public init(_ title: String, action: @escaping () -> Void) {
        self.init(action: action, label: { Text(verbatim: title) })
    }

    public init(_ titleKey: LocalizedStringKey, action: @escaping () -> Void) {
        self.init(action: action, label: { Text(titleKey) })
    }

    public init(role: ButtonRole?, action: @escaping () -> Void, @ViewBuilder label: () -> any View) {
        self.role = role
        self.action = action
        self.label = label()
    }

    public init(_ title: String, role: ButtonRole?, action: @escaping () -> Void) {
        self.init(role: role, action: action, label: { Text(verbatim: title) })
    }

    public init(_ titleKey: LocalizedStringKey, role: ButtonRole?, action: @escaping () -> Void) {
        self.init(role: role, action: action, label: { Text(titleKey) })
    }

    #if SKIP
    @Composable public override func ComposeContent(context: ComposeContext) {
        let buttonStyle = EnvironmentValues.shared._buttonStyle
        ComposeContainer(modifier: context.modifier) { modifier in
            switch buttonStyle {
            case .bordered:
                let tint = role == .destructive ? Color.red : EnvironmentValues.shared._tint
                let colors: ButtonColors
                if let tint {
                    let tintColor = tint.colorImpl()
                    colors = ButtonDefaults.filledTonalButtonColors(containerColor: tintColor.copy(alpha: Float(0.15)), contentColor: tintColor, disabledContainerColor: tintColor.copy(alpha: Float(0.15)), disabledContentColor: tintColor.copy(alpha: ContentAlpha.medium))
                } else {
                    colors = ButtonDefaults.filledTonalButtonColors()
                }
                let contentContext = context.content()
                FilledTonalButton(onClick: action, modifier: modifier, enabled: EnvironmentValues.shared.isEnabled, colors: colors) {
                    label.Compose(context: contentContext)
                }
            case .borderedProminent:
                let tint = role == .destructive ? Color.red : EnvironmentValues.shared._tint
                let colors: ButtonColors
                if let tint {
                    let tintColor = tint.colorImpl()
                    colors = ButtonDefaults.buttonColors(containerColor: tintColor, disabledContainerColor: tintColor.copy(alpha: ContentAlpha.disabled))
                } else {
                    colors = ButtonDefaults.buttonColors()
                }
                let contentContext = context.content()
                androidx.compose.material3.Button(onClick: action, modifier: modifier, enabled: EnvironmentValues.shared.isEnabled, colors: colors) {
                    label.Compose(context: contentContext)
                }
            default:
                ComposePlainButton(label: label, context: context.content(modifier: modifier), role: role, action: action)
            }
        }
    }

    @Composable func shouldComposeListItem() -> Bool {
        let buttonStyle = EnvironmentValues.shared._buttonStyle
        return buttonStyle == nil || buttonStyle == .automatic
    }

    @Composable func ComposeListItem(context: ComposeContext, contentModifier: Modifier) {
        Box(modifier: Modifier.clickable(onClick: action, enabled: EnvironmentValues.shared.isEnabled).then(contentModifier), contentAlignment: androidx.compose.ui.Alignment.CenterStart) {
            ComposePlainButton(label: label, context: context, role: role)
        }
    }
    #else
    public var body: some View {
        stubView()
    }
    #endif
}

#if SKIP
/// Render a plain-style button.
@Composable func ComposePlainButton(label: View, context: ComposeContext, role: ButtonRole? = nil, action: (() -> Void)? = nil) {
    var foregroundStyle: ShapeStyle?
    if role == .destructive {
        foregroundStyle = Color.red
    } else {
        foregroundStyle = EnvironmentValues.shared._foregroundStyle ?? EnvironmentValues.shared._tint ?? Color.accentColor
    }
    let isEnabled = EnvironmentValues.shared.isEnabled
    if !isEnabled {
        let disabledAlpha = Double(ContentAlpha.disabled)
        foregroundStyle = AnyShapeStyle(foregroundStyle, opacity: disabledAlpha)
    }

    var modifier = context.modifier
    if let action {
        modifier = modifier.clickable(onClick: action, enabled: isEnabled)
    }
    let contentContext = context.content(modifier: modifier)

    EnvironmentValues.shared.setValues {
        $0.set_foregroundStyle(foregroundStyle)
    } in: {
        label.Compose(context: contentContext)
    }
}
#endif

public struct ButtonStyle: RawRepresentable, Equatable {
    public let rawValue: Int

    public init(rawValue: Int) {
        self.rawValue = rawValue
    }

    public static let automatic = ButtonStyle(rawValue: 0)
    public static let plain = ButtonStyle(rawValue: 1)
    public static let borderless = ButtonStyle(rawValue: 2)
    public static let bordered = ButtonStyle(rawValue: 3)
    public static let borderedProminent = ButtonStyle(rawValue: 4)
}

public enum ButtonRepeatBehavior : Hashable, Sendable {
    case automatic
    case enabled
    case disabled
}

public enum ButtonRole : Equatable, Sendable {
    case destructive
    case cancel
}

extension View {
    public func buttonStyle(_ style: ButtonStyle) -> some View {
        #if SKIP
        return environment(\._buttonStyle, style)
        #else
        return self
        #endif
    }

    @available(*, unavailable)
    public func buttonRepeatBehavior(_ behavior: ButtonRepeatBehavior) -> some View {
        return self
    }

    @available(*, unavailable)
    public func buttonBorderShape(_ shape: Any) -> some View {
        return self
    }
}

#if !SKIP

// TODO: Process for use in SkipUI

//@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
//extension Button where Label == PrimitiveButtonStyleConfiguration.Label {

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
//    @available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
//    public init(_ configuration: PrimitiveButtonStyleConfiguration) { fatalError() }
//}

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

    public typealias Body = NeverView
    public var body: Body { fatalError() }
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

#endif
