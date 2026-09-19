// Copyright 2023–2026 Skip
// SPDX-License-Identifier: MPL-2.0
#if !SKIP_BRIDGE
import Foundation
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

// SKIP @bridge
public struct Toggle : View, Renderable {
    let isOn: Binding<Bool>
    let label: any View

    public init(isOn: Binding<Bool>, @ViewBuilder label: () -> any View) {
        self.isOn = isOn
        self.label = label()
    }

    // SKIP @bridge
    public init(getIsOn: @escaping () -> Bool, setIsOn: @escaping (Bool) -> Void, bridgedLabel: any View) {
        self.isOn = Binding(get: getIsOn, set: setIsOn)
        self.label = ComposeBuilder.from { bridgedLabel }
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
    public init(_ titleResource: LocalizedStringResource, sources: Any, isOn: (Any) -> Binding<Bool>) {
        self.init(isOn: isOn(0), label: { Text(titleResource) })
    }

    @available(*, unavailable)
    public init(_ title: String, sources: Any, isOn: (Any) -> Binding<Bool>) {
        self.init(isOn: isOn(0), label: { Text(verbatim: title) })
    }

    /// Create a toggle from a `ToggleStyleConfiguration`, rendered in the style that the current style overrides.
    public init(_ configuration: ToggleStyleConfiguration) {
        self.init(isOn: configuration.isOn, label: { configuration.label })
    }

    #if SKIP
    public init(_ titleKey: LocalizedStringKey, isOn: Binding<Bool>) {
        self.init(isOn: isOn, label: { Text(titleKey) })
    }

    public init(_ titleResource: LocalizedStringResource, isOn: Binding<Bool>) {
        self.init(isOn: isOn, label: { Text(titleResource) })
    }

    public init(_ title: String, isOn: Binding<Bool>) {
        self.init(isOn: isOn, label: { Text(verbatim: title) })
    }

    @Composable override func Render(context: ComposeContext) {
        let stackedStyle = EnvironmentValues.shared._toggleStyle
        if let stackedStyle, !stackedStyle.isBuiltin {
            Self.RenderCustomStyleToggle(stackedStyle: stackedStyle, isOn: isOn, label: label, context: context)
            return
        }
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

    /// Render a toggle whose appearance is created by a custom `ToggleStyle`.
    ///
    /// The style body is composed with the style that this style overrides in the environment, so that any
    /// `Toggle(configuration)` it creates renders in the next style out, matching SwiftUI.
    @Composable static func RenderCustomStyleToggle(stackedStyle: StackedToggleStyle, isOn: Binding<Bool>, label: any View, context: ComposeContext) {
        let style = stackedStyle.style as! ToggleStyle
        let configuration = ToggleStyleConfiguration(label: ToggleStyleConfiguration.Label(content: label), isOn: isOn)
        let body: any View
        if let bridgedStyle = style as? BridgedToggleStyle {
            body = bridgedStyle.makeBridgedBody(configuration: configuration)
        } else {
            body = style.makeBody(configuration: configuration)
        }
        EnvironmentValues.shared.setValues {
            $0.set_toggleStyle(stackedStyle.parent)
            return ComposeResult.ok
        } in: {
            body.Compose(context: context)
        }
    }
    #else
    public var body: some View {
        stubView()
    }
    #endif
}

/// A type that applies standard interaction behavior and a custom appearance to all toggles within a view hierarchy.
///
/// To configure the current toggle style for a view hierarchy, use the `toggleStyle(_:)` modifier.
public protocol ToggleStyle {
    typealias Configuration = ToggleStyleConfiguration

    #if SKIP
    /// Creates a view that represents the body of a toggle.
    @ViewBuilder @MainActor func makeBody(configuration: ToggleStyleConfiguration) -> any View
    #else
    func makeBody(configuration: ToggleStyleConfiguration) -> any View
    #endif
}

/// The properties of a toggle.
public struct ToggleStyleConfiguration {
    /// A type-erased label of a toggle.
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

    /// A view that describes the purpose of the toggle.
    public let label: ToggleStyleConfiguration.Label

    /// A binding to a state property that indicates whether the toggle is on.
    public let isOn: Binding<Bool>

    init(label: ToggleStyleConfiguration.Label, isOn: Binding<Bool>) {
        self.label = label
        self.isOn = isOn
    }
}

public struct DefaultToggleStyle : ToggleStyle {
    public init() {
    }

    public func makeBody(configuration: ToggleStyleConfiguration) -> any View {
        return Toggle(configuration).toggleStyle(self)
    }
}

public struct SwitchToggleStyle : ToggleStyle {
    public init() {
    }

    public func makeBody(configuration: ToggleStyleConfiguration) -> any View {
        return Toggle(configuration).toggleStyle(self)
    }
}

extension ToggleStyle where Self == DefaultToggleStyle {
    public static var automatic: DefaultToggleStyle {
        return DefaultToggleStyle()
    }
}

extension ToggleStyle where Self == SwitchToggleStyle {
    public static var `switch`: SwitchToggleStyle {
        return SwitchToggleStyle()
    }
}

/// The configuration of a toggle passed to a natively-compiled `ToggleStyle`.
// SKIP @bridgeMembers
public struct ToggleStyleBridgedConfiguration {
    public let label: any View
    private let _getIsOn: () -> Bool
    private let _setIsOn: (Bool) -> Void
    let environmentSupports: [String: EnvironmentSupport]

    init(label: any View, getIsOn: @escaping () -> Bool, setIsOn: @escaping (Bool) -> Void, environmentSupports: [String: EnvironmentSupport]) {
        self.label = label
        self._getIsOn = getIsOn
        self._setIsOn = setIsOn
        self.environmentSupports = environmentSupports
    }

    public func getIsOn() -> Bool {
        return _getIsOn()
    }

    public func setIsOn(_ value: Bool) {
        _setIsOn(value)
    }

    /// The environment value for the given key at the toggle's position, used to sync the style's `@Environment` properties.
    public func environmentSupport(forKey key: String) -> EnvironmentSupport? {
        return environmentSupports[key]
    }
}

extension View {
    public func toggleStyle(_ style: any ToggleStyle) -> any View {
        #if SKIP
        return ModifiedContent(content: self, modifier: ToggleStyleModifier(style: style))
        #else
        return self
        #endif
    }

    // SKIP @bridge
    public func toggleStyle(bridgedStyle: Int) -> any View {
        // Built-in toggle styles all render natively as the default switch
        return self
    }

    /// Apply a natively-compiled `ToggleStyle`.
    ///
    /// - Parameters:
    ///   - environmentKeys: The keys of the style's `@Environment` properties, which are read at each toggle's position.
    ///   - bridgedMakeBody: Creates the style's body for a toggle configuration.
    // SKIP @bridge
    public func toggleStyle(environmentKeys: [String], bridgedMakeBody: @escaping (ToggleStyleBridgedConfiguration) -> any View) -> any View {
        #if SKIP
        return toggleStyle(BridgedToggleStyle(environmentKeys: environmentKeys, bridgedMakeBody: bridgedMakeBody))
        #else
        return self
        #endif
    }
}

#if SKIP
/// A toggle style set in the environment, along with the style that it overrides.
final class StackedToggleStyle {
    let style: Any
    let parent: StackedToggleStyle?
    let source: ToggleStyleModifier

    init(style: Any, parent: StackedToggleStyle?, source: ToggleStyleModifier) {
        self.style = style
        self.parent = parent
        self.source = source
    }

    /// Whether this is a built-in style, which renders natively rather than through `makeBody`.
    var isBuiltin: Bool {
        return style is DefaultToggleStyle || style is SwitchToggleStyle
    }
}

final class ToggleStyleModifier: EnvironmentModifier {
    let style: Any

    init(style: Any) {
        self.style = style
        super.init()
        self.action = { environment in
            let parent = environment._toggleStyle
            // Re-applying this modifier within its own scope must not make the style its own parent
            if parent?.source !== self {
                environment.set_toggleStyle(StackedToggleStyle(style: style, parent: parent, source: self))
            }
            return ComposeResult.ok
        }
    }
}

/// A `ToggleStyle` whose body is created by natively-compiled Swift.
final class BridgedToggleStyle : ToggleStyle {
    let environmentKeys: [String]
    let bridgedMakeBody: (ToggleStyleBridgedConfiguration) -> any View

    init(environmentKeys: [String], bridgedMakeBody: @escaping (ToggleStyleBridgedConfiguration) -> any View) {
        self.environmentKeys = environmentKeys
        self.bridgedMakeBody = bridgedMakeBody
    }

    func makeBody(configuration: ToggleStyleConfiguration) -> any View {
        return bridgedMakeBody(bridgedConfiguration(for: configuration, environmentSupports: [:]))
    }

    /// Create the body with the style's `@Environment` values read at the current composition position.
    @Composable func makeBridgedBody(configuration: ToggleStyleConfiguration) -> any View {
        let environmentSupports = bridgedEnvironmentSupports(forKeys: environmentKeys)
        return bridgedMakeBody(bridgedConfiguration(for: configuration, environmentSupports: environmentSupports))
    }

    private func bridgedConfiguration(for configuration: ToggleStyleConfiguration, environmentSupports: [String: EnvironmentSupport]) -> ToggleStyleBridgedConfiguration {
        return ToggleStyleBridgedConfiguration(label: configuration.label, getIsOn: { configuration.isOn.wrappedValue }, setIsOn: { configuration.isOn.wrappedValue = $0 }, environmentSupports: environmentSupports)
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
#endif
#endif
