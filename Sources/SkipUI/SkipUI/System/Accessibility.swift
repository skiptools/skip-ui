// Copyright 2023–2025 Skip
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception
#if !SKIP_BRIDGE
#if SKIP
import androidx.compose.ui.ExperimentalComposeUiApi
import androidx.compose.ui.semantics.contentDescription
import androidx.compose.ui.semantics.heading
import androidx.compose.ui.semantics.invisibleToUser
import androidx.compose.ui.semantics.popup
import androidx.compose.ui.semantics.role
import androidx.compose.ui.semantics.selected
import androidx.compose.ui.semantics.semantics
import androidx.compose.ui.semantics.stateDescription
import androidx.compose.ui.semantics.testTagsAsResourceId
#elseif canImport(CoreGraphics)
import class Accessibility.AXCustomContent
import class Accessibility.AXChartDescriptor
import struct CoreGraphics.CGPoint
#endif

extension View {
    // SKIP @bridge
    // SKIP INSERT: @OptIn(ExperimentalComposeUiApi::class)
    public func accessibilityIdentifier(_ identifier: String, isEnabled: Bool = true) -> any View {
        #if SKIP
        return ComposeModifierView(targetView: self, role: .accessibility) {
            if isEnabled {
                $0.modifier = $0.modifier.semantics { testTagsAsResourceId = true }.testTag(identifier)
            }
            return ComposeResult.ok
        }
        #else
        return self
        #endif
    }

    // SKIP @bridge
    public func accessibilityLabel(_ label: Text, isEnabled: Bool = true) -> any View {
        #if SKIP
        return ComposeModifierView(targetView: self, role: .accessibility) {
            if isEnabled {
                let description = label.localizedTextString()
                $0.modifier = $0.modifier.semantics { contentDescription = description }
            }
            return ComposeResult.ok
        }
        #else
        return self
        #endif
    }

    public func accessibilityLabel(_ label: String, isEnabled: Bool = true) -> any View {
        #if SKIP
        return ComposeModifierView(targetView: self, role: .accessibility) {
            if isEnabled {
                $0.modifier = $0.modifier.semantics { contentDescription = label }
            }
            return ComposeResult.ok
        }
        #else
        return self
        #endif
    }

    public func accessibilityLabel(_ key: LocalizedStringKey, isEnabled: Bool = true) -> any View {
        return accessibilityLabel(Text(key), isEnabled: isEnabled)
    }

    @available(*, unavailable)
    public func accessibilityCustomContent(_ key: AccessibilityCustomContentKey, _ value: Text?, importance: Any? = nil /*AXCustomContent.Importance = .default*/) -> some View {
        return self
    }

    @available(*, unavailable)
    public func accessibilityCustomContent(_ key: AccessibilityCustomContentKey, _ valueKey: LocalizedStringKey, importance: Any? = nil /*AXCustomContent.Importance = .default*/) -> some View {
        return self
    }

    @available(*, unavailable)
    public func accessibilityCustomContent(_ key: AccessibilityCustomContentKey, _ value: String, importance: Any? = nil /*AXCustomContent.Importance = .default*/) -> some View {
        return self
    }

    @available(*, unavailable)
    public func accessibilityCustomContent(_ label: Text, _ value: Text, importance: Any? = nil /*AXCustomContent.Importance = .default*/) -> some View {
        return self
    }

    @available(*, unavailable)
    public func accessibilityCustomContent(_ labelKey: LocalizedStringKey, _ value: Text, importance: Any? = nil /*AXCustomContent.Importance = .default*/) -> some View {
        return self
    }

    @available(*, unavailable)
    public func accessibilityCustomContent(_ labelKey: LocalizedStringKey, _ valueKey: LocalizedStringKey, importance: Any? = nil /*AXCustomContent.Importance = .default*/) -> some View {
        return self
    }

    @available(*, unavailable)
    public func accessibilityCustomContent(_ labelKey: LocalizedStringKey, _ value: String, importance: Any? = nil /*AXCustomContent.Importance = .default*/) -> some View {
        return self
    }

    @available(*, unavailable)
    public func accessibilityInputLabels(_ inputLabels: Any) -> some View {
        // Accepts [Text], [LocalizedStringKey], or [String]
        return self
    }

    @available(*, unavailable)
    public func accessibilityHint(_ hint: Text) -> some View {
        return self
    }

    @available(*, unavailable)
    public func accessibilityHint(_ hintKey: LocalizedStringKey) -> some View {
        return self
    }

    @available(*, unavailable)
    public func accessibilityHint(_ hint: String) -> some View {
        return self
    }

    @available(*, unavailable)
    public func accessibilityAction(_ actionKind: AccessibilityActionKind = .default, _ handler: @escaping () -> Void) -> some View {
        return self
    }

    @available(*, unavailable)
    public func accessibilityAction(named name: Text, _ handler: @escaping () -> Void) -> some View {
        return self
    }

    @available(*, unavailable)
    public func accessibilityAction(action: @escaping () -> Void, @ViewBuilder label: () -> any View) -> some View {
        return self
    }

    @available(*, unavailable)
    public func accessibilityActions(@ViewBuilder _ content: () -> any View) -> some View {
        return self
    }

    @available(*, unavailable)
    public func accessibilityAction(named nameKey: LocalizedStringKey, _ handler: @escaping () -> Void) -> some View {
        return self
    }

    @available(*, unavailable)
    public func accessibilityAction(named name: String, _ handler: @escaping () -> Void) -> some View {
        return self
    }

    @available(*, unavailable)
    public func accessibilityRotor(_ label: Text, entries: @escaping () -> any AccessibilityRotorContent) -> some View {
        return self
    }

    @available(*, unavailable)
    public func accessibilityRotor(_ systemRotor: AccessibilitySystemRotor, entries: @escaping () -> any AccessibilityRotorContent) -> some View {
        return self
    }

    @available(*, unavailable)
    public func accessibilityRotor<EntryModel>(_ rotorLabel: Text, entries: [EntryModel], entryLabel: Any /* KeyPath<EntryModel, String> */) -> some View where EntryModel : Identifiable {
        return self
    }

    @available(*, unavailable)
    public func accessibilityRotor<EntryModel, ID>(_ rotorLabel: Text, entries: [EntryModel], entryID: Any /* KeyPath<EntryModel, ID> */, entryLabel: Any /* KeyPath<EntryModel, String> */) -> some View {
        return self
    }

    @available(*, unavailable)
    public func accessibilityRotor<EntryModel>(_ systemRotor: AccessibilitySystemRotor, entries: [EntryModel], entryLabel: Any /* KeyPath<EntryModel, String> */) -> some View where EntryModel : Identifiable {
        return self
    }

    @available(*, unavailable)
    public func accessibilityRotor<EntryModel, ID>(_ systemRotor: AccessibilitySystemRotor, entries: [EntryModel], entryID: Any /* KeyPath<EntryModel, ID> */, entryLabel: Any /* KeyPath<EntryModel, String> */) -> some View where ID : Hashable {
        return self
    }

    @available(*, unavailable)
    public func accessibilityRotor(_ label: Text, textRanges: [Range<Int>]) -> some View {
        return self
    }

    @available(*, unavailable)
    public func accessibilityRotor(_ systemRotor: AccessibilitySystemRotor, textRanges: [Range<Int>]) -> some View {
        return self
    }

    @available(*, unavailable)
    public func accessibilityRotor(_ labelKey: LocalizedStringKey, entries: @escaping () -> any AccessibilityRotorContent) -> some View {
        return self
    }

    @available(*, unavailable)
    public func accessibilityRotor(_ label: String, entries: @escaping () -> any AccessibilityRotorContent) -> some View {
        return self
    }

    @available(*, unavailable)
    public func accessibilityRotor<EntryModel>(_ rotorLabelKey: LocalizedStringKey, entries: [EntryModel], entryLabel: Any /* KeyPath<EntryModel, String> */) -> some View {
        return self
    }

    @available(*, unavailable)
    public func accessibilityRotor<EntryModel>(_ rotorLabel: String, entries: [EntryModel], entryLabel: Any /* KeyPath<EntryModel, String> */) -> some View {
        return self
    }

    @available(*, unavailable)
    public func accessibilityRotor<EntryModel, ID>(_ rotorLabelKey: LocalizedStringKey, entries: [EntryModel], entryID: Any /* KeyPath<EntryModel, ID> */, entryLabel: Any /* KeyPath<EntryModel, String> */) -> some View where ID : Hashable {
        return self
    }

    @available(*, unavailable)
    public func accessibilityRotor<EntryModel, ID>(_ rotorLabel: String, entries: [EntryModel], entryID: Any /* KeyPath<EntryModel, ID> */, entryLabel: Any /* KeyPath<EntryModel, String> */) -> some View where ID : Hashable {
        return self
    }

    @available(*, unavailable)
    public func accessibilityRotor(_ labelKey: LocalizedStringKey, textRanges: [Range<Int>]) -> some View {
        return self
    }

    @available(*, unavailable)
    public func accessibilityRotor(_ label: String, textRanges: [Range<Int>]) -> some View {
        return self
    }

    @available(*, unavailable)
    public func accessibilityIgnoresInvertColors(_ active: Bool = true) -> some View {
        return self
    }

    @available(*, unavailable)
    public func accessibilityZoomAction(_ handler: @escaping (AccessibilityZoomGestureAction) -> Void) -> some View {
        return self
    }

    // SKIP @bridge
    // SKIP INSERT: @OptIn(ExperimentalComposeUiApi::class)
    public func accessibilityHidden(_ hidden: Bool, isEnabled: Bool = true) -> any View {
        #if SKIP
        return ComposeModifierView(targetView: self, role: .accessibility) {
            if isEnabled {
                $0.modifier = $0.modifier.semantics { if hidden { invisibleToUser() } }
            }
            return ComposeResult.ok
        }
        #else
        return self
        #endif
    }

    @available(*, unavailable)
    public func accessibilityDirectTouch(_ isDirectTouchArea: Bool = true, options: AccessibilityDirectTouchOptions = []) -> some View {
        return self
    }

    @available(*, unavailable)
    public func accessibilityRotorEntry(id: AnyHashable, in namespace: Namespace.ID) -> some View {
        return self
    }

    @available(*, unavailable)
    public func accessibilityChartDescriptor(_ representable: Any /* any AXChartDescriptorRepresentable */) -> some View {
        return self
    }

    @available(*, unavailable)
    public func accessibilityFocused<Value>(_ binding: Any /* AccessibilityFocusState<Value>.Binding */, equals value: Value) -> some View {
        return self
    }

    @available(*, unavailable)
    public func accessibilityFocused(_ condition: Any /* AccessibilityFocusState<Bool>.Binding */) -> some View {
        return self
    }

    @available(*, unavailable)
    public func accessibilityRespondsToUserInteraction(_ respondsToUserInteraction: Bool = true) -> some View {
        return self
    }

    @available(*, unavailable)
    public func accessibilityActivationPoint(_ activationPoint: CGPoint) -> some View {
        return self
    }

    @available(*, unavailable)
    public func accessibilityActivationPoint(_ activationPoint: UnitPoint) -> some View {
        return self
    }

    @available(*, unavailable)
    public func accessibilitySortPriority(_ sortPriority: Double) -> some View {
        return self
    }

    @available(*, unavailable)
    public func accessibilityShowsLargeContentViewer<V>(@ViewBuilder _ largeContentView: () -> any View) -> some View {
        return self
    }

    @available(*, unavailable)
    public func accessibilityShowsLargeContentViewer() -> some View {
        return self
    }

    public func accessibilityAddTraits(_ traits: AccessibilityTraits) -> any View {
        #if SKIP
        return ComposeModifierView(targetView: self, role: .accessibility) {
            if traits.contains(.isButton) {
                $0.modifier = $0.modifier.semantics { role = androidx.compose.ui.semantics.Role.Button }
            }
            if traits.contains(.isHeader) {
                $0.modifier = $0.modifier.semantics { heading() }
            }
            if traits.contains(.isSelected) {
                $0.modifier = $0.modifier.semantics { selected = true }
            }
            if traits.contains(.isImage) {
                $0.modifier = $0.modifier.semantics { role = androidx.compose.ui.semantics.Role.Image }
            }
            if traits.contains(.isModal) {
                $0.modifier = $0.modifier.semantics { popup() }
            }
            if traits.contains(.isToggle) {
                $0.modifier = $0.modifier.semantics { role = androidx.compose.ui.semantics.Role.Switch }
            }
            return ComposeResult.ok
        }
        #else
        return self
        #endif
    }

    // SKIP @bridge
    public func accessibilityAddTraits(bridgedTraits: Int) -> any View {
        return accessibilityAddTraits(AccessibilityTraits(rawValue: bridgedTraits))
    }

    @available(*, unavailable)
    public func accessibilityRemoveTraits(_ traits: AccessibilityTraits) -> some View {
        return self
    }

    @available(*, unavailable)
    public func accessibilityLinkedGroup(id: AnyHashable, in namespace: Namespace.ID) -> some View {
        return self
    }

    @available(*, unavailable)
    public func accessibilityLabeledPair(role: AccessibilityLabeledPairRole, id: AnyHashable, in namespace: Namespace.ID) -> some View {
        return self
    }

    @available(*, unavailable)
    public func accessibilityRepresentation(@ViewBuilder representation: () -> any View) -> some View {
        return self
    }

    @available(*, unavailable)
    public func accessibilityChildren(@ViewBuilder children: () -> any View) -> some View {
        return self
    }

    @available(*, unavailable)
    public func accessibilityTextContentType(_ value: AccessibilityTextContentType) -> some View {
        return self
    }

    public func accessibilityHeading(_ level: AccessibilityHeadingLevel) -> any View {
        #if SKIP
        return ComposeModifierView(targetView: self, role: .accessibility) {
            $0.modifier = $0.modifier.semantics { heading() }
            return ComposeResult.ok
        }
        #else
        return self
        #endif
    }

    // SKIP @bridge
    public func accessibilityHeading(bridgedLevel: Int) -> any View {
        return accessibilityHeading(AccessibilityHeadingLevel(rawValue: bridgedLevel) ?? .unspecified)
    }

    // SKIP @bridge
    public func accessibilityValue(_ value: Text, isEnabled: Bool = true) -> any View {
        #if SKIP
        return ComposeModifierView(targetView: self, role: .accessibility) {
            if isEnabled {
                let description = value.localizedTextString()
                $0.modifier = $0.modifier.semantics { stateDescription = description }
            }
            return ComposeResult.ok
        }
        #else
        return self
        #endif
    }

    public func accessibilityValue(_ value: String) -> any View {
        #if SKIP
        return ComposeModifierView(targetView: self, role: .accessibility) {
            $0.modifier = $0.modifier.semantics { stateDescription = value }
            return ComposeResult.ok
        }
        #else
        return self
        #endif
    }

    public func accessibilityValue(_ key: LocalizedStringKey) -> any View {
        return accessibilityValue(Text(key))
    }

    @available(*, unavailable)
    public func accessibilityScrollAction(_ handler: @escaping (Edge) -> Void) -> some View {
        return self
    }

    @available(*, unavailable)
    public func accessibilityElement(children: AccessibilityChildBehavior = .ignore) -> some View {
        return self
    }

    @available(*, unavailable)
    public func accessibilityAdjustableAction(_ handler: @escaping (AccessibilityAdjustmentDirection) -> Void) -> some View {
        return self
    }
}

public struct AccessibilityActionKind : Equatable {
    public static let `default` = AccessibilityActionKind()
    public static let escape = AccessibilityActionKind()
    public static let magicTap = AccessibilityActionKind()

    public init(named name: Text) {
    }

    private init() {
    }
}

public enum AccessibilityAdjustmentDirection : Hashable {
    case increment
    case decrement
}

public enum AccessibilityChildBehavior : Hashable {
    case ignore, contain, combine
}

public struct AccessibilityCustomContentKey : Equatable {
    public init(_ label: Text, id: String) {
    }

    public init(_ labelKey: LocalizedStringKey, id: String) {
    }

    public init(_ labelKey: LocalizedStringKey) {
    }
}

public struct AccessibilityDirectTouchOptions : OptionSet {
    public let rawValue: Int

    public init(rawValue: Int) {
        self.rawValue = rawValue
    }

    public static let silentOnTouch = AccessibilityDirectTouchOptions(rawValue: 1)
    public static let requiresActivation = AccessibilityDirectTouchOptions(rawValue: 2)
}

public enum AccessibilityHeadingLevel : Int {
    case unspecified = 0 // For bridging
    case h1 = 1 // For bridging
    case h2 = 2 // For bridging
    case h3 = 3 // For bridging
    case h4 = 4 // For bridging
    case h5 = 5 // For bridging
    case h6 = 6 // For bridging
}

public enum AccessibilityLabeledPairRole : Hashable {
    case label
    case content
}

public protocol AccessibilityRotorContent {
    #if false
    /// The type for the internal content of this `AccessibilityRotorContent`.
    associatedtype Body : AccessibilityRotorContent

    /// The internal content of this `AccessibilityRotorContent`.
    //@AccessibilityRotorContentBuilder var body: Body { get { return fatalError() as Body } }
    #endif
}

public struct AccessibilityRotorEntry<ID>: AccessibilityRotorContent where ID : Hashable {
    public init(_ label: Text, id: ID, textRange: Range<Int>? = nil, prepare: @escaping (() -> Void) = {}) {
    }

    public init(_ label: Text, id: ID, in namespace: Namespace.ID, textRange: Range<Int>? = nil, prepare: @escaping (() -> Void) = {}) {
    }

    public init(_ label: Text? = nil, textRange: Range<Int>, prepare: @escaping (() -> Void) = {}) {
    }

    public init(_ labelKey: LocalizedStringKey, id: ID, textRange: Range<Int>? = nil, prepare: @escaping (() -> Void) = {}) {
    }

    public init(_ label: String, id: ID, textRange: Range<Int>? = nil, prepare: @escaping (() -> Void) = {}) {
    }

    public init(_ labelKey: LocalizedStringKey, id: ID, in namespace: Namespace.ID, textRange: Range<Int>? = nil, prepare: @escaping (() -> Void) = {}) {
    }

    public init(_ labelKey: LocalizedStringKey, textRange: Range<Int>, prepare: @escaping (() -> Void) = {}) {
    }

    public init(_ label: String, textRange: Range<Int>, prepare: @escaping (() -> Void) = {}) {
    }
}

public struct AccessibilitySystemRotor {
    public static func links(visited: Bool) -> AccessibilitySystemRotor {
        return AccessibilitySystemRotor()
    }

    public static let links = AccessibilitySystemRotor()

    public static func headings(level: AccessibilityHeadingLevel) -> AccessibilitySystemRotor {
        return AccessibilitySystemRotor()
    }

    public static let headings = AccessibilitySystemRotor()
    public static let boldText = AccessibilitySystemRotor()
    public static let italicText = AccessibilitySystemRotor()
    public static let underlineText = AccessibilitySystemRotor()
    public static let misspelledWords = AccessibilitySystemRotor()
    public static let images = AccessibilitySystemRotor()
    public static let textFields = AccessibilitySystemRotor()
    public static let tables = AccessibilitySystemRotor()
    public static let lists = AccessibilitySystemRotor()
    public static let landmarks = AccessibilitySystemRotor()
}

public struct AccessibilityTechnologies : OptionSet {
    public let rawValue: Int

    public init(rawValue: Int) {
        self.rawValue = rawValue
    }

    public static let voiceOver = AccessibilityTechnologies(rawValue: 1)
    public static let switchControl = AccessibilityTechnologies(rawValue: 2)
}

public enum AccessibilityTextContentType {
    case plain, console, fileSystem, messaging, narrative, sourceCode, spreadsheet, wordProcessing
}

public struct AccessibilityTraits : OptionSet {
    public let rawValue: Int

    public init(rawValue: Int) {
        self.rawValue = rawValue
    }

    public static let isButton = AccessibilityTraits(rawValue: 1 << 0) // For bridging
    public static let isHeader = AccessibilityTraits(rawValue: 1 << 1) // For bridging
    public static let isSelected = AccessibilityTraits(rawValue: 1 << 2) // For bridging
    public static let isLink = AccessibilityTraits(rawValue: 1 << 3) // For bridging
    public static let isSearchField = AccessibilityTraits(rawValue: 1 << 4) // For bridging
    public static let isImage = AccessibilityTraits(rawValue: 1 << 5) // For bridging
    public static let playsSound = AccessibilityTraits(rawValue: 1 << 6) // For bridging
    public static let isKeyboardKey = AccessibilityTraits(rawValue: 1 << 7) // For bridging
    public static let isStaticText = AccessibilityTraits(rawValue: 1 << 8) // For bridging
    public static let isSummaryElement = AccessibilityTraits(rawValue: 1 << 9) // For bridging
    public static let updatesFrequently = AccessibilityTraits(rawValue: 1 << 10) // For bridging
    public static let startsMediaSession = AccessibilityTraits(rawValue: 1 << 11) // For bridging
    public static let allowsDirectInteraction = AccessibilityTraits(rawValue: 1 << 12) // For bridging
    public static let causesPageTurn = AccessibilityTraits(rawValue: 1 << 13) // For bridging
    public static let isModal = AccessibilityTraits(rawValue: 1 << 14) // For bridging
    public static let isToggle = AccessibilityTraits(rawValue: 1 << 15) // For bridging
    public static let isTabBar = AccessibilityTraits(rawValue: 1 << 16) // For bridging
}

public struct AccessibilityZoomGestureAction {
    public enum Direction: Hashable {
        case zoomIn
        case zoomOut
    }

    public let direction: Direction
    public let location: UnitPoint
    public let point: CGPoint

    public init(direction: Direction, location: UnitPoint, point: CGPoint) {
        self.direction = direction
        self.location = location
        self.point = point
    }
}

#if false
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
extension Never : AccessibilityRotorContent {
}

public struct AccessibilityAttachmentModifier : ViewModifier {
    func body(content: Content) -> some View {
        content
    }
}

public struct AccessibilityFocusState<Value> : DynamicProperty where Value : Hashable {

    @propertyWrapper @frozen public struct Binding {

        /// The underlying value referenced by the bound property.
        public var wrappedValue: Value { get { fatalError() } nonmutating set { } }

        /// The currently focused element.
        public var projectedValue: AccessibilityFocusState<Value>.Binding { get { fatalError() } }

        public init(wrappedValue: Value) { fatalError() }
    }

    /// The current state value, taking into account whatever bindings might be
    /// in effect due to the current location of focus.
    ///
    /// When focus is not in any view that is bound to this state, the wrapped
    /// value will be `nil` (for optional-typed state) or `false` (for `Bool`-
    /// typed state).
    public var wrappedValue: Value { get { fatalError() } nonmutating set { } }

    /// A projection of the state value that can be used to establish bindings between view content
    /// and accessibility focus placement.
    ///
    /// Use `projectedValue` in conjunction with
    /// ``SkipUI/View/accessibilityFocused(_:equals:)`` to establish
    /// bindings between view content and accessibility focus placement.
    public var projectedValue: AccessibilityFocusState<Value>.Binding { get { fatalError() } }

    /// Creates a new accessibility focus state for a Boolean value.
    public init() where Value == Bool { fatalError() }

    /// Creates a new accessibility focus state for a Boolean value, using the accessibility
    /// technologies you specify.
    ///
    /// - Parameters:
    ///   - technologies: One of the available ``AccessibilityTechnologies``.
    public init(for technologies: AccessibilityTechnologies) where Value == Bool { fatalError() }

    /// Creates a new accessibility focus state of the type you provide.
    public init<T>() where Value == T?, T : Hashable { fatalError() }

    /// Creates a new accessibility focus state of the type and
    /// using the accessibility technologies you specify.
    ///
    /// - Parameter technologies: One or more of the available
    ///  ``AccessibilityTechnologies``.
    public init<T>(for technologies: AccessibilityTechnologies) where Value == T?, T : Hashable { fatalError() }
}

/// A gauge style that displays a closed ring that's partially filled in to
/// indicate the gauge's current value.
///
/// Use ``GaugeStyle/accessoryCircularCapacity`` to construct this style.
@available(iOS 16.0, macOS 13.0, watchOS 9.0, *)
@available(tvOS, unavailable)
public struct AccessoryCircularCapacityGaugeStyle : GaugeStyle {

    /// Creates an accessory circular capacity gauge style.
    public init() { fatalError() }

    /// Creates a view representing the body of a gauge.
    ///
    /// The system calls this modifier on each instance of gauge within a view
    /// hierarchy where this style is the current gauge style.
    ///
    /// - Parameter configuration: The properties to apply to the gauge instance.
    public func makeBody(configuration: AccessoryCircularCapacityGaugeStyle.Configuration) -> some View { return stubView() }


    /// A view representing the body of a gauge.
//    public typealias Body = some View
}

/// A gauge style that displays an open ring with a marker that appears at a
/// point along the ring to indicate the gauge's current value.
///
/// Use ``GaugeStyle/accessoryCircular`` to construct this style.
@available(iOS 16.0, macOS 13.0, watchOS 9.0, *)
@available(tvOS, unavailable)
public struct AccessoryCircularGaugeStyle : GaugeStyle {

    /// Creates an accessory circular gauge style.
    public init() { fatalError() }

    /// Creates a view representing the body of a gauge.
    ///
    /// The system calls this modifier on each instance of gauge within a view
    /// hierarchy where this style is the current gauge style.
    ///
    /// - Parameter configuration: The properties to apply to the gauge instance.
    public func makeBody(configuration: AccessoryCircularGaugeStyle.Configuration) -> some View { return stubView() }


    /// A view representing the body of a gauge.
//    public typealias Body = some View
}

/// A gauge style that displays bar that fills from leading to trailing
/// edges as the gauge's current value increases.
///
/// Use ``GaugeStyle/accessoryLinearCapacity`` to construct this style.
@available(iOS 16.0, macOS 13.0, watchOS 9.0, *)
@available(tvOS, unavailable)
public struct AccessoryLinearCapacityGaugeStyle : GaugeStyle {

    /// Creates an accessory linear capacity gauge style.
    public init() { fatalError() }

    /// Creates a view representing the body of a gauge.
    ///
    /// The system calls this modifier on each instance of gauge within a view
    /// hierarchy where this style is the current gauge style.
    ///
    /// - Parameter configuration: The properties to apply to the gauge instance.
    public func makeBody(configuration: AccessoryLinearCapacityGaugeStyle.Configuration) -> some View { return stubView() }


    /// A view representing the body of a gauge.
//    public typealias Body = some View
}

/// A gauge style that displays bar with a marker that appears at a
/// point along the bar to indicate the gauge's current value.
///
/// Use ``GaugeStyle/accessoryLinear`` to construct this style.
@available(iOS 16.0, macOS 13.0, watchOS 9.0, *)
@available(tvOS, unavailable)
public struct AccessoryLinearGaugeStyle : GaugeStyle {

    /// Creates an accessory linear gauge style.
    public init() { fatalError() }

    /// Creates a view representing the body of a gauge.
    ///
    /// The system calls this modifier on each instance of gauge within a view
    /// hierarchy where this style is the current gauge style.
    ///
    /// - Parameter configuration: The properties to apply to the gauge instance.
    public func makeBody(configuration: AccessoryLinearGaugeStyle.Configuration) -> some View { return stubView() }


    /// A view representing the body of a gauge.
//    public typealias Body = some View
}

/// A type to generate an `AXChartDescriptor` object that you use to provide
/// information about a chart and its data for an accessible experience
/// in VoiceOver or other assistive technologies.
///
/// Note that you may use the `@Environment` property wrapper inside the
/// implementation of your `AXChartDescriptorRepresentable`, in which case you
/// should implement `updateChartDescriptor`, which will be called when the
/// `Environment` changes.
///
/// For example, to provide accessibility for a view that represents a chart,
/// you would first declare your chart descriptor representable type:
///
///     struct MyChartDescriptorRepresentable: AXChartDescriptorRepresentable {
///         func makeChartDescriptor() -> AXChartDescriptor {
///             // Build and return your `AXChartDescriptor` here.
///         }
///
///         func updateChartDescriptor(_ descriptor: AXChartDescriptor) {
///             // Update your chart descriptor with any new values.
///         }
///     }
///
/// Then, provide an instance of your `AXChartDescriptorRepresentable` type to
/// your view using the `accessibilityChartDescriptor` modifier:
///
///     var body: some View {
///         MyChartView()
///             .accessibilityChartDescriptor(MyChartDescriptorRepresentable())
///     }
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public protocol AXChartDescriptorRepresentable {

    /// Create the `AXChartDescriptor` for this view, and return it.
    ///
    /// This will be called once per identity of your `View`. It will not be run
    /// again unless the identity of your `View` changes. If you need to
    /// update the `AXChartDescriptor` based on changes in your `View`, or in
    /// the `Environment`, implement `updateChartDescriptor`.
    /// This method will only be called if / when accessibility needs the
    /// `AXChartDescriptor` of your view, for VoiceOver.
    func makeChartDescriptor() -> AXChartDescriptor

    /// Update the existing `AXChartDescriptor` for your view, based on changes
    /// in your view or in the `Environment`.
    ///
    /// This will be called as needed, when accessibility needs your
    /// `AXChartDescriptor` for VoiceOver. It will only be called if the inputs
    /// to your views, or a relevant part of the `Environment`, have changed.
    func updateChartDescriptor(_ descriptor: AXChartDescriptor)
}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
extension AXChartDescriptorRepresentable {

    /// Update the existing `AXChartDescriptor` for your view, based on changes
    /// in your view or in the `Environment`.
    ///
    /// This will be called as needed, when accessibility needs your
    /// `AXChartDescriptor` for VoiceOver. It will only be called if the inputs
    /// to your views, or a relevant part of the `Environment`, have changed.
    public func updateChartDescriptor(_ descriptor: AXChartDescriptor) { fatalError() }
}

//@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
//extension Group : AccessibilityRotorContent where Content : AccessibilityRotorContent {
//
//    /// The internal content of this `AccessibilityRotorContent`.
//    public var body: Never { get { fatalError() } }
//
//    /// Creates an instance that generates Rotor content by combining, in order,
//    /// all the Rotor content specified in the passed-in result builder.
//    ///
//    /// - Parameter content: The result builder that generates Rotor content for
//    ///   the group.
//    public init(@AccessibilityRotorContentBuilder content: () -> Content) { fatalError() }
//}



@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
extension ModifiedContent where Modifier == AccessibilityAttachmentModifier {

    /// Add additional accessibility information to the view.
    ///
    /// Use this method to add information you want accessibility users to be
    /// able to access about this element, beyond the basics of label, value,
    /// and hint. For example, `accessibilityCustomContent` can be used to add
    /// information about the orientation of a photograph, or the number of
    /// people found in the picture.
    ///
    /// - Parameter key: Key used to specify the identifier and label of the
    ///   of the additional accessibility information entry.
    /// - Parameter value: Text value for the additional accessibility
    ///   information. For example: "landscape." A value of `nil` will remove
    ///   any entry of additional information added earlier for any `key` with
    ///   the same identifier.
    /// - Note: Repeated calls of `accessibilityCustomContent` with `key`s
    ///   having different identifiers will create new entries of
    ///   additional information.
    ///   Calling `accessibilityAdditionalContent` repeatedly with `key`s
    ///   having matching identifiers will replace the previous entry.
    public func accessibilityCustomContent(_ key: AccessibilityCustomContentKey, _ value: Text?, importance: AXCustomContent.Importance = .default) -> ModifiedContent<Content, Modifier> { fatalError() }

    /// Add additional accessibility information to the view.
    ///
    /// Use this method to add information you want accessibility users to be
    /// able to access about this element, beyond the basics of label, value,
    /// and hint. For example, `accessibilityCustomContent` can be used to add
    /// information about the orientation of a photograph, or the number of
    /// people found in the picture.
    ///
    /// - Parameter key: Key used to specify the identifier and label of the
    ///   of the additional accessibility information entry.
    /// - Parameter valueKey: Text value for the additional accessibility
    ///   information. For example: "landscape." A value of `nil` will remove
    ///   any entry of additional information added earlier for any `key` with
    ///   the same identifier.
    /// - Parameter importance: Importance of the accessibility information.
    ///   High-importance information gets read out immediately, while
    ///   default-importance information must be explicitly asked for by the
    ///   user.
    /// - Note: Repeated calls of `accessibilityCustomContent` with `key`s
    ///   having different identifiers will create new entries of
    ///   additional information.
    ///   Calling `accessibilityAdditionalContent` repeatedly with `key`s
    ///   having matching identifiers will replace the previous entry.
    public func accessibilityCustomContent(_ key: AccessibilityCustomContentKey, _ valueKey: LocalizedStringKey, importance: AXCustomContent.Importance = .default) -> ModifiedContent<Content, Modifier> { fatalError() }

    /// Add additional accessibility information to the view.
    ///
    /// Use this method to add information you want accessibility users to be
    /// able to access about this element, beyond the basics of label, value,
    /// and hint. For example, `accessibilityCustomContent` can be used to add
    /// information about the orientation of a photograph, or the number of
    /// people found in the picture.
    ///
    /// - Parameter key: Key used to specify the identifier and label of the
    ///   of the additional accessibility information entry.
    /// - Parameter value: Text value for the additional accessibility
    ///   information. For example: "landscape." A value of `nil` will remove
    ///   any entry of additional information added earlier for any `key` with
    ///   the same identifier.
    /// - Parameter importance: Importance of the accessibility information.
    ///   High-importance information gets read out immediately, while
    ///   default-importance information must be explicitly asked for by the
    ///   user.
    /// - Note: Repeated calls of `accessibilityCustomContent` with `key`s
    ///   having different identifiers will create new entries of
    ///   additional information.
    ///   Calling `accessibilityAdditionalContent` repeatedly with `key`s
    ///   having matching identifiers will replace the previous entry.
    public func accessibilityCustomContent<V>(_ key: AccessibilityCustomContentKey, _ value: V, importance: AXCustomContent.Importance = .default) -> ModifiedContent<Content, Modifier> where V : StringProtocol { fatalError() }

    /// Add additional accessibility information to the view.
    ///
    /// Use this method to add information you want accessibility users to be
    /// able to access about this element, beyond the basics of label, value,
    /// and hint. For example: `accessibilityCustomContent` can be used to add
    /// information about the orientation of a photograph, or the number of
    /// people found in the picture.
    ///
    /// - Parameter label: Localized text describing to the user what
    ///   is contained in this additional information entry. For example:
    ///   "orientation".
    /// - Parameter value: Text value for the additional accessibility
    ///   information. For example: "landscape."
    /// - Parameter importance: Importance of the accessibility information.
    ///   High-importance information gets read out immediately, while
    ///   default-importance information must be explicitly asked for by the
    ///   user.
    /// - Note: Repeated calls of `accessibilityCustomContent` with different
    ///   labels will create new entries of additional information. Calling
    ///   `accessibilityAdditionalContent` repeatedly with the same label will
    ///   instead replace the previous value and importance.
    public func accessibilityCustomContent(_ label: Text, _ value: Text, importance: AXCustomContent.Importance = .default) -> ModifiedContent<Content, Modifier> { fatalError() }

    /// Add additional accessibility information to the view.
    ///
    /// Use this method to add information you want accessibility users to be
    /// able to access about this element, beyond the basics of label, value,
    /// and hint. For example: `accessibilityCustomContent` can be used to add
    /// information about the orientation of a photograph, or the number of
    /// people found in the picture.
    ///
    /// - Parameter label: Localized text describing to the user what
    ///   is contained in this additional information entry. For example:
    ///   "orientation".
    /// - Parameter value: Text value for the additional accessibility
    ///   information. For example: "landscape."
    /// - Parameter importance: Importance of the accessibility information.
    ///   High-importance information gets read out immediately, while
    ///   default-importance information must be explicitly asked for by the
    ///   user.
    /// - Note: Repeated calls of `accessibilityCustomContent` with different
    ///   labels will create new entries of additional information. Calling
    ///   `accessibilityAdditionalContent` repeatedly with the same label will
    ///   instead replace the previous value and importance.
    public func accessibilityCustomContent(_ labelKey: LocalizedStringKey, _ value: Text, importance: AXCustomContent.Importance = .default) -> ModifiedContent<Content, Modifier> { fatalError() }

    /// Add additional accessibility information to the view.
    ///
    /// Use this method to add information you want accessibility users to be
    /// able to access about this element, beyond the basics of label, value,
    /// and hint. For example, `accessibilityCustomContent` can be used to add
    /// information about the orientation of a photograph, or the number of
    /// people found in the picture.
    ///
    /// - Parameter labelKey: Localized text describing to the user what
    ///   is contained in this additional information entry. For example:
    ///   "orientation".
    /// - Parameter value: Text value for the additional accessibility
    ///   information. For example: "landscape."
    /// - Parameter importance: Importance of the accessibility information.
    ///   High-importance information gets read out immediately, while
    ///   default-importance information must be explicitly asked for by the
    ///   user.
    /// - Note: Repeated calls of `accessibilityCustomContent` with different
    ///   labels will create new entries of additional information. Calling
    ///   `accessibilityAdditionalContent` repeatedly with the same label will
    ///   instead replace the previous value and importance.
    public func accessibilityCustomContent(_ labelKey: LocalizedStringKey, _ valueKey: LocalizedStringKey, importance: AXCustomContent.Importance = .default) -> ModifiedContent<Content, Modifier> { fatalError() }

    /// Add additional accessibility information to the view.
    ///
    /// Use this method to add information you want accessibility users to be
    /// able to access about this element, beyond the basics of label, value,
    /// and hint. For example, `accessibilityCustomContent` can be used to add
    /// information about the orientation of a photograph, or the number of
    /// people found in the picture.
    ///
    /// - Parameter labelKey: Localized text describing to the user what
    ///   is contained in this additional information entry. For example:
    ///   "orientation".
    /// - Parameter value: Text value for the additional accessibility
    ///   information. For example: "landscape."
    /// - Parameter importance: Importance of the accessibility information.
    ///   High-importance information gets read out immediately, while
    ///   default-importance information must be explicitly asked for by the
    ///   user.
    /// - Note: Repeated calls of `accessibilityCustomContent` with different
    ///   labels will create new entries of additional information. Calling
    ///   `accessibilityAdditionalContent` repeatedly with the same label will
    ///   instead replace the previous value and importance.
    public func accessibilityCustomContent<V>(_ labelKey: LocalizedStringKey, _ value: V, importance: AXCustomContent.Importance = .default) -> ModifiedContent<Content, Modifier> where V : StringProtocol { fatalError() }
}

#endif
#endif
