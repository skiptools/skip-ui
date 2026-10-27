// Copyright 2023–2026 Skip
// SPDX-License-Identifier: MPL-2.0
#if !SKIP_BRIDGE
import Foundation
#if SKIP
import androidx.compose.foundation.BorderStroke
import androidx.compose.foundation.clickable
import androidx.compose.foundation.interaction.MutableInteractionSource
import androidx.compose.foundation.interaction.collectIsPressedAsState
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.PaddingValues
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.material.ContentAlpha
import androidx.compose.material.ripple.RippleAlpha
import androidx.compose.material3.ButtonColors
import androidx.compose.material3.ButtonDefaults
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.ButtonElevation
import androidx.compose.material3.FilledTonalButton
import androidx.compose.material3.TextButton
import androidx.compose.material3.LocalRippleConfiguration
import androidx.compose.material3.RippleConfiguration
import androidx.compose.runtime.Composable
import androidx.compose.runtime.remember
import androidx.compose.ui.Modifier
import androidx.compose.ui.unit.dp
#elseif canImport(CoreGraphics)
import struct CoreGraphics.CGFloat
import struct CoreGraphics.CGRect
#endif

// SKIP @bridge
public struct Button : View, Renderable {
    let action: () -> Void
    let label: ComposeBuilder
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

    public init(_ titleResource: LocalizedStringResource, action: @escaping () -> Void) {
        self.init(action: action, label: { Text(titleResource) })
    }

    public init(_ title: String, systemImage: String, role: ButtonRole? = nil, action: @escaping () -> Void) {
        self.init(role: role, action: action, label: { Label(title, systemImage: systemImage) })
    }

    public init(_ titleKey: LocalizedStringKey, systemImage: String, role: ButtonRole? = nil, action: @escaping () -> Void) {
        self.init(role: role, action: action, label: { Label(titleKey, systemImage: systemImage) })
    }

    public init(_ titleResource: LocalizedStringResource, systemImage: String, role: ButtonRole? = nil, action: @escaping () -> Void) {
        self.init(role: role, action: action, label: { Label(titleResource, systemImage: systemImage) })
    }

    public init(role: ButtonRole?, action: @escaping () -> Void, @ViewBuilder label: () -> any View) {
        self.role = role
        self.action = action
        self.label = ComposeBuilder.from(label)
    }

    public init(_ title: String, role: ButtonRole?, action: @escaping () -> Void) {
        self.init(role: role, action: action, label: { Text(verbatim: title) })
    }

    public init(_ titleKey: LocalizedStringKey, role: ButtonRole?, action: @escaping () -> Void) {
        self.init(role: role, action: action, label: { Text(titleKey) })
    }

    public init(_ titleResource: LocalizedStringResource, role: ButtonRole?, action: @escaping () -> Void) {
        self.init(role: role, action: action, label: { Text(titleResource) })
    }

    public init(role: ButtonRole, action: @escaping () -> Void) {
        self.init(role: role, action: action, label: { Self.defaultLabel(for: role) })
    }

    /// Create a button from a `PrimitiveButtonStyle` configuration, rendered in the style that the current style overrides.
    public init(_ configuration: PrimitiveButtonStyleConfiguration) {
        self.init(role: configuration.role, action: { configuration.trigger() }, label: { configuration.label })
    }

    // SKIP @bridge
    public init(bridgedRole: Int?, action: @escaping () -> Void, bridgedLabel: (any View)?) {
        self.role = bridgedRole == nil ? nil : ButtonRole(rawValue: bridgedRole!)
        self.action = action
        if let bridgedLabel {
            self.label = ComposeBuilder.from { bridgedLabel }
        } else if let role {
            self.label = ComposeBuilder.from { Self.defaultLabel(for: role) }
        } else {
            self.label = ComposeBuilder.from { EmptyView() }
        }
    }

    private static func defaultLabel(for role: ButtonRole) -> any View {
        switch role {
        case .cancel:
            return Text("Cancel")
        case .destructive:
            return Text("Delete")
        case .confirm:
            return SkipUI.Label("OK", systemImage: "checkmark")
        case .close:
            return SkipUI.Label("Close", systemImage: "xmark")
        }
    }

    #if SKIP
    @Composable override func Render(context: ComposeContext) {
        Self.RenderButton(label: label, context: context, role: role, action: action)
    }

    @Composable override func shouldRenderListItem(context: ComposeContext) -> (Bool, (() -> Void)?) {
        guard Self.isListItemStyle(EnvironmentValues.shared._buttonStyle) else {
            return (false, nil)
        }
        return (true, action)
    }

    @Composable override func RenderListItem(context: ComposeContext, modifiers: kotlin.collections.List<ModifierProtocol>) {
        ModifiedContent.RenderWithModifiers(modifiers, context: context) { context in
            let style = EnvironmentValues.shared._buttonStyle?.style
            Self.RenderTextButton(label: label, context: context, isPlain: style is PlainButtonStyle, role: role)
        }
    }

    /// Whether buttons in the given style render as list items when placed in a `List`.
    static func isListItemStyle(_ stackedStyle: StackedButtonStyle?) -> Bool {
        let style = stackedStyle?.style
        return style == nil || style is DefaultButtonStyle || style is PlainButtonStyle
    }

    /// Render a button in the current style.
    @Composable static func RenderButton(label: View, context: ComposeContext, role: ButtonRole? = nil, isEnabled: Bool = EnvironmentValues.shared.isEnabled, action: () -> Void) {
        let stackedStyle = EnvironmentValues.shared._buttonStyle
        let isHitTestingEnabled = EnvironmentValues.shared._isHitTestingEnabled
        if let stackedStyle, !stackedStyle.isBuiltin {
            RenderCustomStyleButton(stackedStyle: stackedStyle, label: label, context: context, role: role, isEnabled: isEnabled && isHitTestingEnabled, action: action)
            return
        }
        let buttonStyle = stackedStyle?.style
        ComposeContainer(modifier: context.modifier) { modifier in
            switch buttonStyle {
            case is BorderedButtonStyle:
                let tint = role == .destructive ? Color(colorImpl: { MaterialTheme.colorScheme.error }) : EnvironmentValues.shared._tint
                let colors: ButtonColors
                if let tint {
                    let tintColor = tint.colorImpl()
                    colors = ButtonDefaults.filledTonalButtonColors(containerColor: tintColor.copy(alpha: Float(0.15)), contentColor: tintColor, disabledContainerColor: tintColor.copy(alpha: Float(0.15)), disabledContentColor: tintColor.copy(alpha: ContentAlpha.medium))
                } else {
                    colors = ButtonDefaults.filledTonalButtonColors()
                }
                var options = Material3ButtonOptions(onClick: action, modifier: modifier, enabled: isEnabled && isHitTestingEnabled, shape: ButtonDefaults.filledTonalShape, colors: colors, elevation: ButtonDefaults.filledTonalButtonElevation())
                if let updateOptions = EnvironmentValues.shared._material3Button {
                    options = updateOptions(options)
                }
                let placement = EnvironmentValues.shared._placement
                let contentContext = context.content()
                EnvironmentValues.shared.setValues {
                    if let tint {
                        let foregroundStyle = isEnabled ? tint : tint.opacity(Double(ContentAlpha.disabled))
                        $0.set_foregroundStyle(foregroundStyle)
                    } else {
                        $0.set_placement(placement.union(ViewPlacement.systemTextColor))
                    }
                    return ComposeResult.ok
                } in: {
                    FilledTonalButton(onClick: options.onClick, modifier: options.modifier, enabled: options.enabled, shape: options.shape, colors: options.colors, elevation: options.elevation, border: options.border, contentPadding: options.contentPadding, interactionSource: options.interactionSource) {
                        label.Compose(context: contentContext)
                    }
                }
            case is BorderedProminentButtonStyle:
                let tint = role == .destructive ? Color(colorImpl: { MaterialTheme.colorScheme.error }) : EnvironmentValues.shared._tint
                let colors: ButtonColors
                if let tint {
                    let tintColor = tint.colorImpl()
                    if role == .destructive {
                        colors = ButtonDefaults
                            .buttonColors(
                                containerColor: MaterialTheme.colorScheme.error,
                                contentColor: MaterialTheme.colorScheme.onError,
                                disabledContainerColor: MaterialTheme.colorScheme.error.copy(alpha: ContentAlpha.disabled),
                                disabledContentColor: MaterialTheme.colorScheme.onError.copy(alpha: ContentAlpha.disabled)
                            )
                    } else {
                        colors = ButtonDefaults.buttonColors(containerColor: tintColor, disabledContainerColor: tintColor.copy(alpha: ContentAlpha.disabled))
                    }
                } else {
                    colors = ButtonDefaults.buttonColors()
                }
                var options = Material3ButtonOptions(onClick: action, modifier: modifier, enabled: isEnabled && isHitTestingEnabled, shape: ButtonDefaults.shape, colors: colors, elevation: ButtonDefaults.buttonElevation())
                if let updateOptions = EnvironmentValues.shared._material3Button {
                    options = updateOptions(options)
                }
                let placement = EnvironmentValues.shared._placement
                let contentContext = context.content()
                EnvironmentValues.shared.setValues {
                    $0.set_placement(placement.union(ViewPlacement.systemTextColor).union(ViewPlacement.onPrimaryColor))
                    return ComposeResult.ok
                } in: {
                    androidx.compose.material3.Button(onClick: options.onClick, modifier: options.modifier, enabled: options.enabled, shape: options.shape, colors: options.colors, elevation: options.elevation, border: options.border, contentPadding: options.contentPadding, interactionSource: options.interactionSource) {
                        label.Compose(context: contentContext)
                    }
                }
            case is PlainButtonStyle:
                RenderTextButton(label: label, context: context.content(modifier: modifier), role: role, isPlain: true, isEnabled: isEnabled, action: action)
            case is M3TextButtonStyle:
                RenderM3TextButton(label: label, context: context.content(modifier: modifier), role: role, isPlain: false, isEnabled: isEnabled, action: action)
            default:
                RenderTextButton(label: label, context: context.content(modifier: modifier), role: role, isEnabled: isEnabled, action: action)
            }
        }
    }

    /// Render a button whose appearance is created by a custom `ButtonStyle` or `PrimitiveButtonStyle`.
    ///
    /// The style body is composed with the style that this style overrides in the environment, so that any
    /// `Button(configuration)` it creates renders in the next style out, matching SwiftUI.
    ///
    /// - Parameters:
    ///   - isEnabled: Whether the button is both enabled and hit testable.
    @Composable static func RenderCustomStyleButton(stackedStyle: StackedButtonStyle, label: View, context: ComposeContext, role: ButtonRole?, isEnabled: Bool, action: () -> Void) {
        if let style = stackedStyle.style as? ButtonStyle {
            let interactionSource = remember { MutableInteractionSource() }
            let isPressed = interactionSource.collectIsPressedAsState()
            let configuration = ButtonStyleConfiguration(role: role, label: ButtonStyleConfiguration.Label(content: label), isPressed: isPressed.value)
            let body: any View
            if let bridgedStyle = style as? BridgedButtonStyle {
                body = bridgedStyle.makeBridgedBody(configuration: configuration)
            } else {
                body = style.makeBody(configuration: configuration)
            }
            ComposeContainer(modifier: context.modifier) { modifier in
                let buttonModifier = modifier.clickable(interactionSource: interactionSource, indication: nil, enabled: isEnabled, role: androidx.compose.ui.semantics.Role.Button, onClick: action)
                EnvironmentValues.shared.setValues {
                    $0.set_buttonStyle(stackedStyle.parent)
                    return ComposeResult.ok
                } in: {
                    body.Compose(context: context.content(modifier: buttonModifier))
                }
            }
        } else if let style = stackedStyle.style as? PrimitiveButtonStyle {
            let configuration = PrimitiveButtonStyleConfiguration(role: role, label: PrimitiveButtonStyleConfiguration.Label(content: label), action: {
                if isEnabled {
                    action()
                }
            })
            let body: any View
            if let bridgedStyle = style as? BridgedPrimitiveButtonStyle {
                body = bridgedStyle.makeBridgedBody(configuration: configuration)
            } else {
                body = style.makeBody(configuration: configuration)
            }
            EnvironmentValues.shared.setValues {
                $0.set_buttonStyle(stackedStyle.parent)
                return ComposeResult.ok
            } in: {
                body.Compose(context: context)
            }
        }
    }

    /// Render a plain-style button.
    ///
    /// - Parameters:
    ///   - action: Pass nil if the given modifier already includes `clickable`
    @Composable static func RenderTextButton(label: View, context: ComposeContext, role: ButtonRole? = nil, isPlain: Bool = false, isEnabled: Bool = EnvironmentValues.shared.isEnabled, action: (() -> Void)? = nil) {
        let isHitTestingEnabled = EnvironmentValues.shared._isHitTestingEnabled
        var foregroundStyle: ShapeStyle
        if role == .destructive {
            foregroundStyle = Color(colorImpl: { MaterialTheme.colorScheme.error })
        } else {
            foregroundStyle = EnvironmentValues.shared._foregroundStyle ?? (isPlain ? Color.primary : (EnvironmentValues.shared._tint ?? Color.accentColor))
        }
        if !isEnabled {
            let disabledAlpha = Double(ContentAlpha.disabled)
            foregroundStyle = AnyShapeStyle(foregroundStyle, opacity: disabledAlpha)
        }

        var modifier = context.modifier
        if let action, isHitTestingEnabled {
            modifier = modifier.clickable(onClick: action, enabled: isEnabled)
        }
        let contentContext = context.content(modifier: modifier)

        EnvironmentValues.shared.setValues {
            $0.set_foregroundStyle(foregroundStyle)
            return ComposeResult.ok
        } in: {
            label.Compose(context: contentContext)
        }
    }

    /// Render a Material3 text button style.
    ///
    /// - Parameters:
    ///   - action: Pass nil if the given modifier already includes `clickable`
    @Composable static func RenderM3TextButton(label: View, context: ComposeContext, role: ButtonRole? = nil, isPlain: Bool = false, isEnabled: Bool = EnvironmentValues.shared.isEnabled, action: (() -> Void)? = nil) {
        let isHitTestingEnabled = EnvironmentValues.shared._isHitTestingEnabled
        let baseForegroundStyle: ShapeStyle
        if role == .destructive {
            baseForegroundStyle = Color(colorImpl: { MaterialTheme.colorScheme.error })
        } else {
            baseForegroundStyle = EnvironmentValues.shared._foregroundStyle ?? (isPlain ? Color.primary : (EnvironmentValues.shared._tint ?? Color.accentColor))
        }
        var foregroundStyle = baseForegroundStyle
        if !isEnabled {
            let disabledAlpha = Double(ContentAlpha.disabled)
            foregroundStyle = AnyShapeStyle(baseForegroundStyle, opacity: disabledAlpha)
        }

        let hasAction = action != nil && isHitTestingEnabled
        let enabledContentColor = baseForegroundStyle.asColor(opacity: 1.0, animationContext: nil) ?? MaterialTheme.colorScheme.primary
        let disabledContentColor = baseForegroundStyle.asColor(opacity: Double(ContentAlpha.disabled), animationContext: nil) ?? enabledContentColor.copy(alpha: ContentAlpha.disabled)
        let colors = ButtonDefaults.textButtonColors(contentColor: enabledContentColor, disabledContentColor: disabledContentColor)
        var options = Material3ButtonOptions(onClick: action ?? {}, modifier: context.modifier, enabled: isEnabled && hasAction, shape: ButtonDefaults.textShape, colors: colors, elevation: nil, border: nil, contentPadding: ButtonDefaults.TextButtonContentPadding, interactionSource: nil)
        if let updateOptions = EnvironmentValues.shared._material3Button {
            options = updateOptions(options)
        }
        let contentContext = context.content()

        EnvironmentValues.shared.setValues {
            $0.set_foregroundStyle(foregroundStyle)
            return ComposeResult.ok
        } in: {
            TextButton(onClick: options.onClick, modifier: options.modifier, enabled: options.enabled, shape: options.shape, colors: options.colors, elevation: options.elevation, border: options.border, contentPadding: options.contentPadding, interactionSource: options.interactionSource) {
                label.Compose(context: contentContext)
            }
        }
    }
    #else
    public var body: some View {
        stubView()
    }
    #endif
}

/// A type that applies standard interaction behavior and a custom appearance to all buttons within a view hierarchy.
///
/// To configure the current button style for a view hierarchy, use the `buttonStyle(_:)` modifier.
public protocol ButtonStyle {
    typealias Configuration = ButtonStyleConfiguration

    #if SKIP
    @ViewBuilder @MainActor func makeBody(configuration: ButtonStyleConfiguration) -> any View
    #else
    func makeBody(configuration: ButtonStyleConfiguration) -> any View
    #endif
}

/// The properties of a button.
public struct ButtonStyleConfiguration {
    /// A type-erased label of a button.
    public struct Label : View {
        let content: any View

        init(content: any View) {
            self.content = content
        }

        #if SKIP
        @Composable override func Evaluate(context: ComposeContext, options: Int) -> kotlin.collections.List<Renderable> {
            return content.Evaluate(context: context, options: options)
        }
        #else
        public var body: some View {
            stubView()
        }
        #endif
    }

    public let role: ButtonRole?
    public let label: ButtonStyleConfiguration.Label
    public let isPressed: Bool

    init(role: ButtonRole?, label: ButtonStyleConfiguration.Label, isPressed: Bool) {
        self.role = role
        self.label = label
        self.isPressed = isPressed
    }
}

/// The properties of a button.
public struct PrimitiveButtonStyleConfiguration {
    /// A type-erased label of a button.
    public struct Label : View {
        let content: any View

        init(content: any View) {
            self.content = content
        }

        #if SKIP
        @Composable override func Evaluate(context: ComposeContext, options: Int) -> kotlin.collections.List<Renderable> {
            return content.Evaluate(context: context, options: options)
        }
        #else
        public var body: some View {
            stubView()
        }
        #endif
    }

    public let role: ButtonRole?
    public let label: PrimitiveButtonStyleConfiguration.Label
    let action: () -> Void

    init(role: ButtonRole?, label: PrimitiveButtonStyleConfiguration.Label, action: @escaping () -> Void) {
        self.role = role
        self.label = label
        self.action = action
    }

    public func trigger() {
        action()
    }
}

/// A type that applies custom interaction behavior and a custom appearance to all buttons within a view hierarchy.
///
/// The built-in styles such as `.bordered` conform to this protocol and render natively with Compose.
public protocol PrimitiveButtonStyle {
    typealias Configuration = PrimitiveButtonStyleConfiguration

    #if SKIP
    @ViewBuilder @MainActor func makeBody(configuration: PrimitiveButtonStyleConfiguration) -> any View
    #else
    func makeBody(configuration: PrimitiveButtonStyleConfiguration) -> any View
    #endif
}

public struct DefaultButtonStyle : PrimitiveButtonStyle {
    public init() {
    }

    public func makeBody(configuration: PrimitiveButtonStyleConfiguration) -> any View {
        return Button(configuration).buttonStyle(self)
    }
}

public struct PlainButtonStyle : PrimitiveButtonStyle {
    public init() {
    }

    public func makeBody(configuration: PrimitiveButtonStyleConfiguration) -> any View {
        return Button(configuration).buttonStyle(self)
    }
}

public struct BorderlessButtonStyle : PrimitiveButtonStyle {
    public init() {
    }

    public func makeBody(configuration: PrimitiveButtonStyleConfiguration) -> any View {
        return Button(configuration).buttonStyle(self)
    }
}

public struct BorderedButtonStyle : PrimitiveButtonStyle {
    public init() {
    }

    public func makeBody(configuration: PrimitiveButtonStyleConfiguration) -> any View {
        return Button(configuration).buttonStyle(self)
    }
}

public struct BorderedProminentButtonStyle : PrimitiveButtonStyle {
    public init() {
    }

    public func makeBody(configuration: PrimitiveButtonStyleConfiguration) -> any View {
        return Button(configuration).buttonStyle(self)
    }
}

public struct M3TextButtonStyle : PrimitiveButtonStyle {
    public init() {
    }

    public func makeBody(configuration: PrimitiveButtonStyleConfiguration) -> any View {
        return Button(configuration).buttonStyle(self)
    }
}

extension PrimitiveButtonStyle where Self == DefaultButtonStyle {
    public static var automatic: DefaultButtonStyle {
        return DefaultButtonStyle()
    }
}

extension PrimitiveButtonStyle where Self == PlainButtonStyle {
    public static var plain: PlainButtonStyle {
        return PlainButtonStyle()
    }
}

extension PrimitiveButtonStyle where Self == BorderlessButtonStyle {
    public static var borderless: BorderlessButtonStyle {
        return BorderlessButtonStyle()
    }
}

extension PrimitiveButtonStyle where Self == BorderedButtonStyle {
    public static var bordered: BorderedButtonStyle {
        return BorderedButtonStyle()
    }
}

extension PrimitiveButtonStyle where Self == BorderedProminentButtonStyle {
    public static var borderedProminent: BorderedProminentButtonStyle {
        return BorderedProminentButtonStyle()
    }
}

extension PrimitiveButtonStyle where Self == M3TextButtonStyle {
    public static var m3Text: M3TextButtonStyle {
        return M3TextButtonStyle()
    }
}

public enum ButtonRepeatBehavior : Hashable {
    case automatic
    case enabled
    case disabled
}

public enum ButtonRole : Int, Equatable {
    case destructive = 1 // For bridging
    case cancel = 2 // For bridging
    case confirm = 3 // For bridging
    case close = 4 // For bridging
}

public struct ButtonSizing : RawRepresentable, Hashable {
    public let rawValue: Int

    public init(rawValue: Int) {
        self.rawValue = rawValue
    }

    public static let automatic = ButtonSizing(rawValue: 0) // For bridging
    @available(*, unavailable)
    public static let flexible = ButtonSizing(rawValue: 1) // For bridging
    @available(*, unavailable)
    public static let fitted = ButtonSizing(rawValue: 2) // For bridging
}

/// The configuration of a button passed to a natively-compiled `ButtonStyle` or `PrimitiveButtonStyle`.
// SKIP @bridgeMembers
public struct ButtonStyleBridgedConfiguration {
    public let label: any View
    public let isPressed: Bool
    public let bridgedRole: Int?
    let action: () -> Void
    let environmentSupports: [String: EnvironmentSupport]

    init(label: any View, isPressed: Bool, bridgedRole: Int?, action: @escaping () -> Void, environmentSupports: [String: EnvironmentSupport]) {
        self.label = label
        self.isPressed = isPressed
        self.bridgedRole = bridgedRole
        self.action = action
        self.environmentSupports = environmentSupports
    }

    public func trigger() {
        action()
    }

    public func environmentSupport(forKey key: String) -> EnvironmentSupport? {
        return environmentSupports[key]
    }
}

extension View {
    public func buttonStyle(_ style: any PrimitiveButtonStyle) -> any View {
        #if SKIP
        return ModifiedContent(content: self, modifier: ButtonStyleModifier(style: style))
        #else
        return self
        #endif
    }

    public func buttonStyle(_ style: any ButtonStyle) -> any View {
        #if SKIP
        return ModifiedContent(content: self, modifier: ButtonStyleModifier(style: style))
        #else
        return self
        #endif
    }

    // SKIP @bridge
    public func buttonStyle(bridgedStyle: Int) -> any View {
        switch bridgedStyle {
        case 1:
            return buttonStyle(PlainButtonStyle())
        case 2:
            return buttonStyle(BorderlessButtonStyle())
        case 3:
            return buttonStyle(BorderedButtonStyle())
        case 4:
            return buttonStyle(BorderedProminentButtonStyle())
        case 7:
            return buttonStyle(M3TextButtonStyle())
        default:
            return buttonStyle(DefaultButtonStyle())
        }
    }

    @available(*, unavailable)
    public func buttonRepeatBehavior(_ behavior: ButtonRepeatBehavior) -> some View {
        return self
    }

    @available(*, unavailable)
    public func buttonBorderShape(_ shape: Any) -> some View {
        return self
    }

    public func buttonSizing(_ sizing: ButtonSizing) -> any View {
        // We only support .automatic
        return self
    }

    /// Apply a natively-compiled `ButtonStyle` or `PrimitiveButtonStyle`.
    ///
    /// - Parameters:
    ///   - isPrimitive: Whether the style is a `PrimitiveButtonStyle`, which handles its own interaction.
    ///   - environmentKeys: The keys of the style's `@Environment` properties, which are read at each button's position.
    ///   - bridgedMakeBody: Creates the style's body for a button configuration.
    // SKIP @bridge
    public func buttonStyle(isPrimitive: Bool, environmentKeys: [String], bridgedMakeBody: @escaping (ButtonStyleBridgedConfiguration) -> any View) -> any View {
        #if SKIP
        if isPrimitive {
            return buttonStyle(BridgedPrimitiveButtonStyle(environmentKeys: environmentKeys, bridgedMakeBody: bridgedMakeBody))
        } else {
            return buttonStyle(BridgedButtonStyle(environmentKeys: environmentKeys, bridgedMakeBody: bridgedMakeBody))
        }
        #else
        return self
        #endif
    }

    #if SKIP
    /// Compose button customization.
    public func material3Button(_ options: @Composable (Material3ButtonOptions) -> Material3ButtonOptions) -> View {
        return environment(\._material3Button, options, affectsEvaluate: false)
    }

    public func material3Ripple(_ options: @Composable (Material3RippleOptions?) -> Material3RippleOptions?) -> View {
        return ModifiedContent(content: self, modifier: RenderModifier { renderable, context in
            let rippleConfiguration = LocalRippleConfiguration.current
            let rippleOptions: Material3RippleOptions?
            if let rippleConfiguration {
                rippleOptions = options(Material3RippleOptions(rippleConfiguration))
            } else {
                rippleOptions = options(nil)
            }
            // SKIP INSERT: val provided = LocalRippleConfiguration provides rippleOptions?.asConfiguration()
            CompositionLocalProvider(provided) { renderable.Render(context: context) }
        })
    }
    #endif
}

#if SKIP
/// A button style set in the environment, along with the style that it overrides.
final class StackedButtonStyle {
    let style: Any
    let parent: StackedButtonStyle?
    let source: ButtonStyleModifier

    init(style: Any, parent: StackedButtonStyle?, source: ButtonStyleModifier) {
        self.style = style
        self.parent = parent
        self.source = source
    }

    /// Whether this is a built-in style, which renders natively rather than through `makeBody`.
    var isBuiltin: Bool {
        return style is DefaultButtonStyle || style is PlainButtonStyle || style is BorderlessButtonStyle || style is BorderedButtonStyle || style is BorderedProminentButtonStyle || style is M3TextButtonStyle
    }
}

final class ButtonStyleModifier: EnvironmentModifier {
    let style: Any

    init(style: Any) {
        self.style = style
        super.init()
        self.action = { environment in
            let parent = environment._buttonStyle
            // Re-applying this modifier within its own scope must not make the style its own parent
            if parent?.source !== self {
                environment.set_buttonStyle(StackedButtonStyle(style: style, parent: parent, source: self))
            }
            return ComposeResult.ok
        }
    }

    @Composable override func shouldRenderListItem(content: Renderable, context: ComposeContext) -> (Bool, (() -> Void)?) {
        // The button style matters when deciding whether to render buttons and navigation links as list items
        return EnvironmentValues.shared.setValuesWithReturn(action!, in: {
            return content.shouldRenderListItem(context: context)
        })
    }
}

/// A `ButtonStyle` whose body is created by natively-compiled Swift.
final class BridgedButtonStyle : ButtonStyle {
    let environmentKeys: [String]
    let bridgedMakeBody: (ButtonStyleBridgedConfiguration) -> any View

    init(environmentKeys: [String], bridgedMakeBody: @escaping (ButtonStyleBridgedConfiguration) -> any View) {
        self.environmentKeys = environmentKeys
        self.bridgedMakeBody = bridgedMakeBody
    }

    func makeBody(configuration: ButtonStyleConfiguration) -> any View {
        return bridgedMakeBody(bridgedConfiguration(for: configuration, environmentSupports: [:]))
    }

    @Composable func makeBridgedBody(configuration: ButtonStyleConfiguration) -> any View {
        let environmentSupports = bridgedEnvironmentSupports(forKeys: environmentKeys)
        return bridgedMakeBody(bridgedConfiguration(for: configuration, environmentSupports: environmentSupports))
    }

    private func bridgedConfiguration(for configuration: ButtonStyleConfiguration, environmentSupports: [String: EnvironmentSupport]) -> ButtonStyleBridgedConfiguration {
        return ButtonStyleBridgedConfiguration(label: configuration.label, isPressed: configuration.isPressed, bridgedRole: configuration.role?.rawValue, action: {}, environmentSupports: environmentSupports)
    }
}

/// A `PrimitiveButtonStyle` whose body is created by natively-compiled Swift.
final class BridgedPrimitiveButtonStyle : PrimitiveButtonStyle {
    let environmentKeys: [String]
    let bridgedMakeBody: (ButtonStyleBridgedConfiguration) -> any View

    init(environmentKeys: [String], bridgedMakeBody: @escaping (ButtonStyleBridgedConfiguration) -> any View) {
        self.environmentKeys = environmentKeys
        self.bridgedMakeBody = bridgedMakeBody
    }

    func makeBody(configuration: PrimitiveButtonStyleConfiguration) -> any View {
        return bridgedMakeBody(bridgedConfiguration(for: configuration, environmentSupports: [:]))
    }

    @Composable func makeBridgedBody(configuration: PrimitiveButtonStyleConfiguration) -> any View {
        let environmentSupports = bridgedEnvironmentSupports(forKeys: environmentKeys)
        return bridgedMakeBody(bridgedConfiguration(for: configuration, environmentSupports: environmentSupports))
    }

    private func bridgedConfiguration(for configuration: PrimitiveButtonStyleConfiguration, environmentSupports: [String: EnvironmentSupport]) -> ButtonStyleBridgedConfiguration {
        return ButtonStyleBridgedConfiguration(label: configuration.label, isPressed: false, bridgedRole: configuration.role?.rawValue, action: configuration.action, environmentSupports: environmentSupports)
    }
}

@Composable private func bridgedEnvironmentSupports(forKeys keys: [String]) -> [String: EnvironmentSupport] {
    var environmentSupports: [String: EnvironmentSupport] = [:]
    for key in keys {
        if let environmentSupport = EnvironmentValues.shared.bridged(key: key) {
            environmentSupports[key] = environmentSupport
        }
    }
    return environmentSupports
}

public struct Material3ButtonOptions {
    public var onClick: () -> Void
    public var modifier: Modifier = Modifier
    public var enabled = true
    public var shape: androidx.compose.ui.graphics.Shape
    public var colors: ButtonColors
    public var elevation: ButtonElevation? = nil
    public var border: BorderStroke? = nil
    public var contentPadding: PaddingValues = ButtonDefaults.ContentPadding
    public var interactionSource: MutableInteractionSource? = nil

    public func copy(
        onClick: () -> Void = self.onClick,
        modifier: Modifier = self.modifier,
        enabled: Bool = self.enabled,
        shape: androidx.compose.ui.graphics.Shape = self.shape,
        colors: ButtonColors = self.colors,
        elevation: ButtonElevation? = self.elevation,
        border: BorderStroke? = self.border,
        contentPadding: PaddingValues = self.contentPadding,
        interactionSource: MutableInteractionSource? = self.interactionSource
    ) -> Material3ButtonOptions {
        return Material3ButtonOptions(onClick: onClick, modifier: modifier, enabled: enabled, shape: shape, colors: colors, elevation: elevation, border: border, contentPadding: contentPadding, interactionSource: interactionSource)
    }
}

public struct Material3RippleOptions {
    public var color: androidx.compose.ui.graphics.Color
    public var rippleAlpha: RippleAlpha?

    public init(color: androidx.compose.ui.graphics.Color = androidx.compose.ui.graphics.Color.Unspecified, rippleAlpha: RippleAlpha? = nil) {
        self.color = color
        self.rippleAlpha = rippleAlpha
    }

    init(configuration: RippleConfiguration) {
        self.color = configuration.color
        self.rippleAlpha = configuration.rippleAlpha
    }

    public func copy(
        color: androidx.compose.ui.graphics.Color = self.color,
        rippleAlpha: RippleAlpha? = self.rippleAlpha
    ) -> Material3RippleOptions {
        return Material3RippleOptions(color: color, rippleAlpha: rippleAlpha)
    }

    func asConfiguration() -> RippleConfiguration {
        return RippleConfiguration(color: color, rippleAlpha: rippleAlpha)
    }
}
#endif

/*
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
*/
#endif
