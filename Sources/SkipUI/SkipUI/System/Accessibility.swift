// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

extension View {
    public func accessibilityIdentifier(_ identifier: String) -> some View {
        #if SKIP
        return ComposeContextView(self) {
            $0.modifier = $0.modifier.testTag(identifier)
        }
        #else
        return self
        #endif
    }
}

extension View {
    public func accessibilityLabel(_ label: Text) -> some View {
        #if SKIP
        return ComposeContextView(self) {
            $0.modifier = $0.modifier.semantics { contentDescription = label.text }
        }
        #else
        return self
        #endif
    }

    public func accessibilityLabel(_ label: String) -> some View {
        #if SKIP
        return ComposeContextView(self) {
            $0.modifier = $0.modifier.semantics { contentDescription = label }
        }
        #else
        return self
        #endif
    }
}

#if !SKIP

// TODO: Process for use in SkipUI

import class Accessibility.AXCustomContent
import class Accessibility.AXChartDescriptor

/// No-op
@usableFromInline func stubAccessibilityRotorContent() -> some AccessibilityRotorContent {
    return never()
}

/// The structure that defines the kinds of available accessibility actions.
///
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
public struct AccessibilityActionKind : Equatable, Sendable {

    /// The value that represents the default accessibility action.
    public static let `default`: AccessibilityActionKind = { fatalError() }()

    /// The value that represents an action that cancels a pending accessibility action.
    public static let escape: AccessibilityActionKind = { fatalError() }()

    @available(iOS 13.0, tvOS 13.0, watchOS 6.0, *)
    @available(macOS, unavailable)
    public static let magicTap: AccessibilityActionKind = { fatalError() }()

    public init(named name: Text) { fatalError() }

    
}

/// A directional indicator you use when making an accessibility adjustment.
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
public enum AccessibilityAdjustmentDirection : Sendable {

    case increment

    case decrement

    


}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension AccessibilityAdjustmentDirection : Equatable {
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension AccessibilityAdjustmentDirection : Hashable {
}

/// A view modifier that adds accessibility properties to the view
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
public struct AccessibilityAttachmentModifier : ViewModifier {
    /// The type of view representing the body.
    public typealias Body = NeverView
    public var body: Body { fatalError() }
    public typealias Content = Never
}

/// Defines the behavior for the child elements of the new parent element.
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
public struct AccessibilityChildBehavior : Hashable {


}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension AccessibilityChildBehavior {

    /// Any child accessibility elements become hidden.
    ///
    /// Use this behavior when you want a view represented by
    /// a single accessibility element. The new accessibility element
    /// has no initial properties. So you will need to use other
    /// accessibility modifiers, such as ``View/accessibilityLabel(_:)-5f0zj``,
    /// to begin making it accessible.
    ///
    ///     var body: some View {
    ///         VStack {
    ///             Button("Previous Page", action: goBack)
    ///             Text("\(pageNumber)")
    ///             Button("Next Page", action: goForward)
    ///         }
    ///         .accessibilityElement(children: .ignore)
    ///         .accessibilityValue("Page \(pageNumber) of \(pages.count)")
    ///         .accessibilityAdjustableAction { action in
    ///             if action == .increment {
    ///                 goForward()
    ///             } else {
    ///                 goBack()
    ///             }
    ///         }
    ///     }
    ///
    /// Before using the  ``AccessibilityChildBehavior/ignore``behavior, consider
    /// using the ``AccessibilityChildBehavior/combine`` behavior.
    ///
    /// - Note: A new accessibility element is always created.
    public static let ignore: AccessibilityChildBehavior = { fatalError() }()

    /// Any child accessibility elements become children of the new
    /// accessibility element.
    ///
    /// Use this behavior when you want a view to be an accessibility
    /// container. An accessibility container groups child accessibility
    /// elements which improves navigation. For example, all children
    /// of an accessibility container are navigated in order before
    /// navigating through the next accessibility container.
    ///
    ///     var body: some View {
    ///         ScrollView {
    ///             VStack {
    ///                 HStack {
    ///                     ForEach(users) { user in
    ///                         UserCell(user)
    ///                     }
    ///                 }
    ///                 .accessibilityElement(children: .contain)
    ///                 .accessibilityLabel("Users")
    ///
    ///                 VStack {
    ///                     ForEach(messages) { message in
    ///                         MessageCell(message)
    ///                     }
    ///                 }
    ///                 .accessibilityElement(children: .contain)
    ///                 .accessibilityLabel("Messages")
    ///             }
    ///         }
    ///     }
    ///
    /// A new accessibility element is created when:
    /// * The view contains multiple or zero accessibility elements
    /// * The view contains a single accessibility element with no children
    ///
    /// - Note: If an accessibility element is not created, the
    ///         ``AccessibilityChildBehavior`` of the existing
    ///         accessibility element is modified.
    public static let contain: AccessibilityChildBehavior = { fatalError() }()

    /// Any child accessibility element's properties are merged
    /// into the new accessibility element.
    ///
    /// Use this behavior when you want a view represented by
    /// a single accessibility element. The new accessibility element
    /// merges properties from all non-hidden children. Some
    /// properties may be transformed or ignored to achieve the
    /// ideal combined result. For example, not all of ``AccessibilityTraits``
    /// are merged and a ``AccessibilityActionKind/default`` action
    /// may become a named action (``AccessibilityActionKind/init(named:)``).
    ///
    ///     struct UserCell: View {
    ///         var user: User
    ///
    ///         var body: some View {
    ///             VStack {
    ///                 Image(user.image)
    ///                 Text(user.name)
    ///                 Button("Options", action: showOptions)
    ///             }
    ///             .accessibilityElement(children: .combine)
    ///         }
    ///     }
    ///
    /// A new accessibility element is created when:
    /// * The view contains multiple or zero accessibility elements
    /// * The view wraps a ``UIViewRepresentable``/``NSViewRepresentable``.
    ///
    /// - Note: If an accessibility element is not created, the
    ///         ``AccessibilityChildBehavior`` of the existing
    ///         accessibility element is modified.
    public static let combine: AccessibilityChildBehavior = { fatalError() }()
}

/// Key used to specify the identifier and label associated with
/// an entry of additional accessibility information.
///
/// Use `AccessibilityCustomContentKey` and the associated modifiers taking
/// this value as a parameter in order to simplify clearing or replacing
/// entries of additional information that are manipulated from multiple places
/// in your code.
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public struct AccessibilityCustomContentKey {

    /// Create an `AccessibilityCustomContentKey` with the specified label and
    /// identifier.
    ///
    /// - Parameter label: Localized text describing to the user what
    ///   is contained in this additional information entry. For example:
    ///   "orientation".
    /// - Parameter id: String used to identify the additional information entry
    ///   to SkipUI. Adding an entry will replace any previous value with the
    ///   same identifier.
    public init(_ label: Text, id: String) { fatalError() }

    /// Create an `AccessibilityCustomContentKey` with the specified label and
    /// identifier.
    ///
    /// - Parameter labelKey: Localized text describing to the user what
    ///   is contained in this additional information entry. For example:
    ///   "orientation".
    /// - Parameter id: String used to identify the additional
    ///   information entry to SkipUI. Adding an entry will replace any previous
    ///   value with the same identifier.
    public init(_ labelKey: LocalizedStringKey, id: String) { fatalError() }

    /// Create an `AccessibilityCustomContentKey` with the specified label.
    ///
    /// - Parameter labelKey: Localized text describing to the user what
    ///   is contained in this additional information entry. For example:
    ///   "orientation". This will also be used as the identifier.
    public init(_ labelKey: LocalizedStringKey) { fatalError() }
}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
extension AccessibilityCustomContentKey : Equatable {

    
}

/// An option set that defines the functionality of a view's direct touch area.
@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
public struct AccessibilityDirectTouchOptions : OptionSet, Sendable {

    /// The raw type that can be used to represent all values of the conforming
    /// type.
    ///
    /// Every distinct value of the conforming type has a corresponding unique
    /// value of the `RawValue` type, but there may be values of the `RawValue`
    /// type that don't have a corresponding value of the conforming type.
    public typealias RawValue = UInt

    /// The corresponding value of the raw type.
    ///
    /// A new instance initialized with `rawValue` will be equivalent to this
    /// instance. For example:
    ///
    ///     enum PaperSize: String {
    ///         case A4, A5, Letter, Legal
    ///     }
    ///
    ///     let selectedSize = PaperSize.Letter
    ///     print(selectedSize.rawValue)
    ///     // Prints "Letter"
    ///
    ///     print(selectedSize == PaperSize(rawValue: selectedSize.rawValue)!)
    ///     // Prints "true"
    public let rawValue: AccessibilityDirectTouchOptions.RawValue = { fatalError() }()

    /// Create a set of direct touch options
    public init(rawValue: AccessibilityDirectTouchOptions.RawValue) { fatalError() }

    /// Allows a direct touch area to immediately receive touch events without
    /// an assitive technology, such as VoiceOver, speaking. Appropriate for
    /// apps that provide direct audio feedback on touch that would conflict
    /// with speech feedback.
    public static let silentOnTouch: AccessibilityDirectTouchOptions = { fatalError() }()

    /// Prevents touch passthrough with the direct touch area until an
    /// assistive technology, such as VoiceOver, has activated the direct
    /// touch area through a user action, for example a double tap.
    public static let requiresActivation: AccessibilityDirectTouchOptions = { fatalError() }()

    /// The type of the elements of an array literal.
    public typealias ArrayLiteralElement = AccessibilityDirectTouchOptions

    /// The element type of the option set.
    ///
    /// To inherit all the default implementations from the `OptionSet` protocol,
    /// the `Element` type must be `Self`, the default.
    public typealias Element = AccessibilityDirectTouchOptions
}

/// A property wrapper type that can read and write a value that SkipUI updates
/// as the focus of any active accessibility technology, such as VoiceOver,
/// changes.
///
/// Use this capability to request that VoiceOver or other accessibility
/// technologies programmatically focus on a specific element, or to determine
/// whether VoiceOver or other accessibility technologies are focused on
/// particular elements. Use ``View/accessibilityFocused(_:equals:)`` or
/// ``View/accessibilityFocused(_:)`` in conjunction with this property
/// wrapper to identify accessibility elements for which you want to get
/// or set accessibility focus. When accessibility focus enters the modified accessibility element,
/// the framework updates the wrapped value of this property to match a given
/// prototype value. When accessibility focus leaves, SkipUI resets the wrapped value
/// of an optional property to `nil` or the wrapped value of a Boolean property to `false`.
/// Setting the property's value programmatically has the reverse effect, causing
/// accessibility focus to move to whichever accessibility element is associated with the updated value.
///
///  In the example below, when `notification` changes, and its  `isPriority` property
///  is `true`, the accessibility focus moves to the notification `Text` element above the rest of the
///  view's content:
///
///     struct CustomNotification: Equatable {
///         var text: String
///         var isPriority: Bool
///     }
///
///     struct ContentView: View {
///         @Binding var notification: CustomNotification?
///         @AccessibilityFocusState var isNotificationFocused: Bool
///
///         var body: some View {
///             VStack {
///                 if let notification = self.notification {
///                     Text(notification.text)
///                         .accessibilityFocused($isNotificationFocused)
///                 }
///                 Text("The main content for this view.")
///             }
///             .onChange(of: notification) { notification in
///                 if (notification?.isPriority == true)  {
///                     isNotificationFocused = true
///                 }
///             }
///
///         }
///     }
///
/// To allow for cases where accessibility focus is completely absent from the
/// tree of accessibility elements, or accessibility technologies are not
/// active, the wrapped value must be either optional or Boolean.
///
/// Some initializers of `AccessibilityFocusState` also allow specifying
/// accessibility technologies, determining to which types of accessibility
/// focus this binding applies. If you specify no accessibility technologies,
/// SkipUI uses an aggregate of any and all active accessibility technologies.
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
@propertyWrapper @frozen public struct AccessibilityFocusState<Value> : DynamicProperty where Value : Hashable {

    @propertyWrapper @frozen public struct Binding {

        /// The underlying value referenced by the bound property.
        public var wrappedValue: Value { get { fatalError() } nonmutating set { fatalError() } }

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
    public var wrappedValue: Value { get { fatalError() } nonmutating set { fatalError() } }

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

/// The hierarchy of a heading in relation other headings.
///
/// Assistive technologies can use this to improve a users navigation
/// through multiple headings. When users navigate through top level
/// headings they expect the content for each heading to be unrelated.
///
/// For example, you can categorize a list of available products into sections,
/// like Fruits and Vegetables. With only top level headings, this list requires no
/// heading hierarchy, and you use the ``unspecified`` heading level. On the other hand, if sections
/// contain subsections, like if the Fruits section has subsections for varieties of Apples,
/// Pears, and so on, you apply the ``h1`` level to Fruits and Vegetables, and the ``h2``
/// level to Apples and Pears.
///
/// Except for ``h1``, be sure to precede all leveled headings by another heading with a level
/// that's one less.
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
@frozen public enum AccessibilityHeadingLevel : UInt {

    /// A heading without a hierarchy.
    case unspecified

    /// Level 1 heading.
    case h1

    /// Level 2 heading.
    case h2

    /// Level 3 heading.
    case h3

    /// Level 4 heading.
    case h4

    /// Level 5 heading.
    case h5

    /// Level 6 heading.
    case h6

    /// Creates a new instance with the specified raw value.
    ///
    /// If there is no value of the type that corresponds with the specified raw
    /// value, this initializer returns `nil`. For example:
    ///
    ///     enum PaperSize: String {
    ///         case A4, A5, Letter, Legal
    ///     }
    ///
    ///     print(PaperSize(rawValue: "Legal"))
    ///     // Prints "Optional("PaperSize.Legal")"
    ///
    ///     print(PaperSize(rawValue: "Tabloid"))
    ///     // Prints "nil"
    ///
    /// - Parameter rawValue: The raw value to use for the new instance.
    public init?(rawValue: UInt) { fatalError() }

    /// The raw type that can be used to represent all values of the conforming
    /// type.
    ///
    /// Every distinct value of the conforming type has a corresponding unique
    /// value of the `RawValue` type, but there may be values of the `RawValue`
    /// type that don't have a corresponding value of the conforming type.
    public typealias RawValue = UInt

    /// The corresponding value of the raw type.
    ///
    /// A new instance initialized with `rawValue` will be equivalent to this
    /// instance. For example:
    ///
    ///     enum PaperSize: String {
    ///         case A4, A5, Letter, Legal
    ///     }
    ///
    ///     let selectedSize = PaperSize.Letter
    ///     print(selectedSize.rawValue)
    ///     // Prints "Letter"
    ///
    ///     print(selectedSize == PaperSize(rawValue: selectedSize.rawValue)!)
    ///     // Prints "true"
    public var rawValue: UInt { get { fatalError() } }
}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
extension AccessibilityHeadingLevel : Equatable {
}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
extension AccessibilityHeadingLevel : Hashable {
}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
extension AccessibilityHeadingLevel : RawRepresentable {
}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
extension AccessibilityHeadingLevel : Sendable {
}

/// The role of an accessibility element in a label / content pair.
@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
@frozen public enum AccessibilityLabeledPairRole {

    /// This element represents the label part of the label / content pair.
    ///
    /// For example, it might be the explanatory text to the left of a control,
    /// describing what the control does.
    case label

    /// This element represents the content part of the label / content pair.
    ///
    /// For example, it might be the custom control itself.
    case content

    
}

@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
extension AccessibilityLabeledPairRole : Hashable {


}

@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
extension AccessibilityLabeledPairRole : Sendable {
}

/// Content within an accessibility rotor.
///
/// Generally generated from control flow constructs like `ForEach` and `if`, and
/// `AccessibilityRotorEntry`.
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public protocol AccessibilityRotorContent {

    /// The type for the internal content of this `AccessibilityRotorContent`.
    associatedtype Body : AccessibilityRotorContent

    /// The internal content of this `AccessibilityRotorContent`.
    //@AccessibilityRotorContentBuilder var body: Body { get { return fatalError() as Body } }
}

/// Result builder you use to generate rotor entry content.
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
@resultBuilder public struct AccessibilityRotorContentBuilder {

    /// Builds an expression within the builder.
    public static func buildExpression<Content>(_ content: Content) -> Content where Content : AccessibilityRotorContent { fatalError() }

    public static func buildBlock<Content>(_ content: Content) -> some AccessibilityRotorContent where Content : AccessibilityRotorContent { return stubAccessibilityRotorContent() }


    public static func buildIf<Content>(_ content: Content?) -> some AccessibilityRotorContent where Content : AccessibilityRotorContent { return stubAccessibilityRotorContent() }

}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
extension AccessibilityRotorContentBuilder {

    public static func buildBlock<C0, C1>(_ c0: C0, _ c1: C1) -> some AccessibilityRotorContent where C0 : AccessibilityRotorContent, C1 : AccessibilityRotorContent { return stubAccessibilityRotorContent() }

}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
extension AccessibilityRotorContentBuilder {

    public static func buildBlock<C0, C1, C2>(_ c0: C0, _ c1: C1, _ c2: C2) -> some AccessibilityRotorContent where C0 : AccessibilityRotorContent, C1 : AccessibilityRotorContent, C2 : AccessibilityRotorContent { return stubAccessibilityRotorContent() }

}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
extension AccessibilityRotorContentBuilder {

    public static func buildBlock<C0, C1, C2, C3>(_ c0: C0, _ c1: C1, _ c2: C2, _ c3: C3) -> some AccessibilityRotorContent where C0 : AccessibilityRotorContent, C1 : AccessibilityRotorContent, C2 : AccessibilityRotorContent, C3 : AccessibilityRotorContent { return stubAccessibilityRotorContent() }

}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
extension AccessibilityRotorContentBuilder {

    public static func buildBlock<C0, C1, C2, C3, C4>(_ c0: C0, _ c1: C1, _ c2: C2, _ c3: C3, _ c4: C4) -> some AccessibilityRotorContent where C0 : AccessibilityRotorContent, C1 : AccessibilityRotorContent, C2 : AccessibilityRotorContent, C3 : AccessibilityRotorContent, C4 : AccessibilityRotorContent { return stubAccessibilityRotorContent() }

}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
extension AccessibilityRotorContentBuilder {

    public static func buildBlock<C0, C1, C2, C3, C4, C5>(_ c0: C0, _ c1: C1, _ c2: C2, _ c3: C3, _ c4: C4, _ c5: C5) -> some AccessibilityRotorContent where C0 : AccessibilityRotorContent, C1 : AccessibilityRotorContent, C2 : AccessibilityRotorContent, C3 : AccessibilityRotorContent, C4 : AccessibilityRotorContent, C5 : AccessibilityRotorContent { return stubAccessibilityRotorContent() }

}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
extension AccessibilityRotorContentBuilder {

    public static func buildBlock<C0, C1, C2, C3, C4, C5, C6>(_ c0: C0, _ c1: C1, _ c2: C2, _ c3: C3, _ c4: C4, _ c5: C5, _ c6: C6) -> some AccessibilityRotorContent where C0 : AccessibilityRotorContent, C1 : AccessibilityRotorContent, C2 : AccessibilityRotorContent, C3 : AccessibilityRotorContent, C4 : AccessibilityRotorContent, C5 : AccessibilityRotorContent, C6 : AccessibilityRotorContent { return stubAccessibilityRotorContent() }

}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
extension AccessibilityRotorContentBuilder {

    public static func buildBlock<C0, C1, C2, C3, C4, C5, C6, C7>(_ c0: C0, _ c1: C1, _ c2: C2, _ c3: C3, _ c4: C4, _ c5: C5, _ c6: C6, _ c7: C7) -> some AccessibilityRotorContent where C0 : AccessibilityRotorContent, C1 : AccessibilityRotorContent, C2 : AccessibilityRotorContent, C3 : AccessibilityRotorContent, C4 : AccessibilityRotorContent, C5 : AccessibilityRotorContent, C6 : AccessibilityRotorContent, C7 : AccessibilityRotorContent { return stubAccessibilityRotorContent() }

}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
extension AccessibilityRotorContentBuilder {

    public static func buildBlock<C0, C1, C2, C3, C4, C5, C6, C7, C8>(_ c0: C0, _ c1: C1, _ c2: C2, _ c3: C3, _ c4: C4, _ c5: C5, _ c6: C6, _ c7: C7, _ c8: C8) -> some AccessibilityRotorContent where C0 : AccessibilityRotorContent, C1 : AccessibilityRotorContent, C2 : AccessibilityRotorContent, C3 : AccessibilityRotorContent, C4 : AccessibilityRotorContent, C5 : AccessibilityRotorContent, C6 : AccessibilityRotorContent, C7 : AccessibilityRotorContent, C8 : AccessibilityRotorContent { return stubAccessibilityRotorContent() }

}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
extension AccessibilityRotorContentBuilder {

    public static func buildBlock<C0, C1, C2, C3, C4, C5, C6, C7, C8, C9>(_ c0: C0, _ c1: C1, _ c2: C2, _ c3: C3, _ c4: C4, _ c5: C5, _ c6: C6, _ c7: C7, _ c8: C8, _ c9: C9) -> some AccessibilityRotorContent where C0 : AccessibilityRotorContent, C1 : AccessibilityRotorContent, C2 : AccessibilityRotorContent, C3 : AccessibilityRotorContent, C4 : AccessibilityRotorContent, C5 : AccessibilityRotorContent, C6 : AccessibilityRotorContent, C7 : AccessibilityRotorContent, C8 : AccessibilityRotorContent, C9 : AccessibilityRotorContent { return stubAccessibilityRotorContent() }

}

/// A struct representing an entry in an Accessibility Rotor.
///
/// An Accessibility Rotor is a shortcut for Accessibility users to
/// quickly navigate to specific elements of the user interface,
/// and optionally specific ranges of text within those elements.
///
/// An entry in a Rotor may contain a label to identify the entry to the user,
/// and identifier used to determine which Accessibility element the Rotor entry
/// should navigate to, as well as an optional range used for entries that
/// navigate to a specific position in the text of their associated
/// Accessibility element. An entry can also specify a handler to be
/// called before the entry is navigated to, to do any manual work needed to
/// bring the Accessibility element on-screen.
///
/// In the following example, a Message application creates a Rotor
/// allowing users to navigate to specifically the messages originating from
/// VIPs.
///
///     // `messages` is a list of `Identifiable` `Message`s.
///
///     ScrollView {
///         LazyVStack {
///             ForEach(messages) { message in
///                 MessageView(message)
///             }
///         }
///     }
///     .accessibilityElement(children: .contain)
///     .accessibilityRotor("VIPs") {
///         // Not all the `MessageView`s are generated at once, but the model
///         // knows about all the messages.
///         ForEach(messages) { message in
///             // If the Message is from a VIP, make a Rotor entry for it.
///             if message.isVIP {
///                 AccessibilityRotorEntry(message.subject, id: message.id)
///             }
///         }
///     }
///
/// An entry may also be created using an optional namespace, for situations
/// where there are multiple Accessibility elements within a ForEach iteration
/// or where a `ScrollView` is not present. In this case, the `prepare` closure
/// may be needed in order to scroll the element into position using
/// `ScrollViewReader`. The same namespace should be passed to calls to
/// `accessibilityRotorEntry(id:in:)` to tag the Accessibility elements
/// associated with this entry.
///
/// In the following example, a Message application creates a Rotor
/// allowing users to navigate to specifically the messages originating from
/// VIPs. The Rotor entries are associated with the content text of the message,
/// which is one of the two views within the ForEach that generate Accessibility
/// elements. That view is tagged with `accessibilityRotorEntry(id:in:)` so that
/// it can be found by the `AccessibilityRotorEntry`, and `ScrollViewReader` is
/// used with the `prepare` closure to scroll it into position.
///
///     struct MessageListView: View {
///         @Namespace var namespace
///
///         var body: some View {
///             ScrollViewReader { scroller in
///                  ScrollView {
///                     LazyVStack {
///                         ForEach(allMessages) { message in
///                             VStack {
///                                 Text(message.subject)
///                                 // Tag this `Text` as an element associated
///                                 // with a Rotor entry.
///                                 Text(message.content)
///                                     .accessibilityRotorEntry(
///                                         "\(message.id)_content",
///                                         in: namespace
///                                     )
///                             }
///                         }
///                     }
///                 }
///                 .accessibilityElement(children: .contain)
///                 .accessibilityRotor("VIP Messages") {
///                     ForEach(vipMessages) { vipMessage in
///                         // The Rotor entry points to a specific ID we
///                         // defined within a given `ForEach` iteration,
///                         // not to the entire `ForEach` iteration.
///                         AccessibilityRotorEntry(vipMessage.subject,
///                             id: "\(vipMessage.id)_content", in: namespace)
///                         {
///                             // But the ID we give to `ScrollViewReader`
///                             // matches the one used in the `ForEach`, which
///                             // is the identifier for the whole iteration
///                             // and what `ScrollViewReader` requires.
///                             scroller.scrollTo(vipMessage.id)
///                         }
///                     }
///                 }
///             }
///         }
///     }
///
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public struct AccessibilityRotorEntry<ID> where ID : Hashable {

    /// Create a Rotor entry with a specific label and identifier, with an
    /// optional range.
    /// - Parameters:
    ///   - label: Localized string used to show this Rotor entry
    ///     to users.
    ///   - id: Used to find the UI element associated with this
    ///     Rotor entry. This identifier should be used within a `scrollView`,
    ///     either in a `ForEach` or using an `id` call.
    ///   - textRange: Optional range of text associated with this Rotor
    ///     entry. This should be a range within text that is set as the
    ///     either label or accessibility value of the associated element.
    ///   - prepare: Optional closure to run before a Rotor entry
    ///     is navigated to, to prepare the UI as needed. This can be used to
    ///     bring the UI element on-screen if it isn't already, and SkipUI
    ///     is not able to automatically scroll to it.
    public init(_ label: Text, id: ID, textRange: Range<String.Index>? = nil, prepare: @escaping (() -> Void) = {}) { fatalError() }

    /// Create a Rotor entry with a specific label, identifier and namespace,
    /// and with an optional range.
    /// - Parameters:
    ///   - label: Localized string used to show this Rotor entry
    ///     to users.
    ///   - id: Used to find the UI element associated with this
    ///     Rotor entry. This identifier and namespace should match a call to
    ///     `accessibilityRotorEntry(id:in)`.
    ///   - namespace: Namespace for this identifier. Should match a call
    ///     to `accessibilityRotorEntry(id:in)`.
    ///   - textRange: Optional range of text associated with this Rotor
    ///     entry. This should be a range within text that is set as the
    ///     accessibility label or accessibility value of the associated
    ///     element.
    ///   - prepare: Optional closure to run before a Rotor entry
    ///     is navigated to, to prepare the UI as needed. This should be used to
    ///     bring the Accessibility element on-screen, if scrolling is needed to
    ///     get to it.
    public init(_ label: Text, id: ID, in namespace: Namespace.ID, textRange: Range<String.Index>? = nil, prepare: @escaping (() -> Void) = {}) { fatalError() }

    /// Create a Rotor entry with a specific label and range. This Rotor entry
    /// will be associated with the Accessibility element that owns the Rotor.
    /// - Parameters:
    ///   - label: Optional localized string used to show this Rotor entry
    ///     to users. If no label is specified, the Rotor entry will be labeled
    ///     based on the text at that range.
    ///   - range: Range of text associated with this Rotor
    ///     entry.
    ///   - prepare: Optional closure to run before a Rotor entry
    ///     is navigated to, to prepare the UI as needed. This can be used to
    ///     bring the UI element or text on-screen if it isn't already,
    ///     and SkipUI not able to automatically scroll to it.
    public init(_ label: Text? = nil, textRange: Range<String.Index>, prepare: @escaping (() -> Void) = {}) where ID == Never { fatalError() }

    /// Create a Rotor entry with a specific label and identifier, with an
    /// optional range.
    /// - Parameters:
    ///   - id: Used to find the UI element associated with this
    ///     Rotor entry. This identifier should be used within a `scrollView`,
    ///     either in a `ForEach` or using an `id` call.
    ///   - label: Localized string used to show this Rotor entry
    ///     to users.
    ///   - textRange: Optional range of text associated with this Rotor
    ///     entry. This should be a range within text that is set as the
    ///     accessibility label or accessibility value of the associated
    ///     element.
    ///   - prepare: Optional closure to run before a Rotor entry
    ///     is navigated to, to prepare the UI as needed. This can be used to
    ///     bring the UI element on-screen if it isn't already, and SkipUI
    ///     is not able to automatically scroll to it.
    public init(_ labelKey: LocalizedStringKey, id: ID, textRange: Range<String.Index>? = nil, prepare: @escaping (() -> Void) = {}) { fatalError() }

    /// Create a Rotor entry with a specific label and identifier, with an
    /// optional range.
    /// - Parameters:
    ///   - label: Localized string used to show this Rotor entry
    ///     to users.
    ///   - id: Used to find the UI element associated with this
    ///     Rotor entry. This identifier should be used within a `scrollView`,
    ///     either in a `ForEach` or using an `id` call.
    ///   - textRange: Optional range of text associated with this Rotor
    ///     entry. This should be a range within text that is set as the
    ///     accessibility label or accessibility value of the associated
    ///     element.
    ///   - prepare: Optional closure to run before a Rotor entry
    ///     is navigated to, to prepare the UI as needed. This can be used to
    ///     bring the UI element on-screen if it isn't already, and SkipUI
    ///     is not able to automatically scroll to it.
    public init<L>(_ label: L, id: ID, textRange: Range<String.Index>? = nil, prepare: @escaping (() -> Void) = {}) where L : StringProtocol { fatalError() }

    /// Create a Rotor entry with a specific label, identifier and namespace,
    /// and with an optional range.
    /// - Parameters:
    ///   - labelKey: Localized string used to show this Rotor entry
    ///     to users.
    ///   - id: Used to find the UI element associated with this
    ///     Rotor entry. This identifier and namespace should match a call to
    ///     `accessibilityRotorEntry(id:in)`.
    ///   - namespace: Namespace for this identifier. Should match a call
    ///     to `accessibilityRotorEntry(id:in)`.
    ///   - textRange: Optional range of text associated with this Rotor
    ///     entry. This should be a range within text that is set as the
    ///     accessibility label or accessibility value of the associated
    ///     element.
    ///   - prepare: Optional closure to run before a Rotor entry
    ///     is navigated to, to prepare the UI as needed. This should be used to
    ///     bring the Accessibility element on-screen, if scrolling is needed to
    ///     get to it.
    public init(_ labelKey: LocalizedStringKey, id: ID, in namespace: Namespace.ID, textRange: Range<String.Index>? = nil, prepare: @escaping (() -> Void) = {}) { fatalError() }

    /// Create a Rotor entry with a specific label, identifier and namespace,
    /// and with an optional range.
    /// - Parameters:
    ///   - label: Localized string used to show this Rotor entry
    ///     to users.
    ///   - id: Used to find the UI element associated with this
    ///     Rotor entry. This identifier and namespace should match a call to
    ///     `accessibilityRotorEntry(id:in)`.
    ///   - namespace: Namespace for this identifier. Should match a call
    ///     to `accessibilityRotorEntry(id:in)`.
    ///   - textRange: Optional range of text associated with this Rotor
    ///     entry. This should be a range within text that is set as the
    ///     accessibility label or accessibility value of the associated
    ///     element.
    ///   - prepare: Optional closure to run before a Rotor entry
    ///     is navigated to, to prepare the UI as needed. This should be used to
    ///     bring the Accessibility element on-screen, if scrolling is needed to
    ///     get to it.
    public init<L>(_ label: L, _ id: ID, in namespace: Namespace.ID, textRange: Range<String.Index>? = nil, prepare: @escaping (() -> Void) = {}) where L : StringProtocol { fatalError() }

    /// Create a Rotor entry with a specific label and range. This Rotor entry
    /// will be associated with the Accessibility element that owns the Rotor.
    /// - Parameters:
    ///   - labelKey: Localized string used to show this Rotor entry
    ///     to users. If no label is specified, the Rotor entry will be labeled
    ///     based on the text at that range.
    ///   - range: Range of text associated with this Rotor
    ///     entry.
    ///   - prepare: Optional closure to run before a Rotor entry
    ///     is navigated to, to prepare the UI as needed. This can be used to
    ///     bring the UI element or text on-screen if it isn't already,
    ///     and SkipUI not able to automatically scroll to it.
    public init(_ labelKey: LocalizedStringKey, textRange: Range<String.Index>, prepare: @escaping (() -> Void) = {}) { fatalError() }

    /// Create a Rotor entry with a specific label and range. This Rotor entry
    /// will be associated with the Accessibility element that owns the Rotor.
    /// - Parameters:
    ///   - label: Localized string used to show this Rotor entry
    ///     to users. If no label is specified, the Rotor entry will be labeled
    ///     based on the text at that range.
    ///   - range: Range of text associated with this Rotor
    ///     entry.
    ///   - prepare: Optional closure to run before a Rotor entry
    ///     is navigated to, to prepare the UI as needed. This can be used to
    ///     bring the UI element or text on-screen if it isn't already,
    ///     and SkipUI not able to automatically scroll to it.
    public init<L>(_ label: L, textRange: Range<String.Index>, prepare: @escaping (() -> Void) = {}) where ID == Never, L : StringProtocol { fatalError() }
}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
extension AccessibilityRotorEntry : AccessibilityRotorContent {
    public typealias Body = NeverView
    public var body: some AccessibilityRotorContent { get { return stubAccessibilityRotorContent() } }
}

/// Designates a Rotor that replaces one of the automatic, system-provided
/// Rotors with a developer-provided Rotor.
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public struct AccessibilitySystemRotor : Sendable {

    /// System Rotors allowing users to iterate through links or visited links.
    public static func links(visited: Bool) -> AccessibilitySystemRotor { fatalError() }

    /// System Rotor allowing users to iterate through all links.
    public static var links: AccessibilitySystemRotor { get { fatalError() } }

    /// System Rotors allowing users to iterate through all headings, of various
    /// heading levels.
    public static func headings(level: AccessibilityHeadingLevel) -> AccessibilitySystemRotor { fatalError() }

    /// System Rotor allowing users to iterate through all headings.
    public static var headings: AccessibilitySystemRotor { get { fatalError() } }

    /// System Rotor allowing users to iterate through all the ranges of
    /// bolded text.
    public static var boldText: AccessibilitySystemRotor { get { fatalError() } }

    /// System Rotor allowing users to iterate through all the ranges of
    /// italicized text.
    public static var italicText: AccessibilitySystemRotor { get { fatalError() } }

    /// System Rotor allowing users to iterate through all the ranges of
    /// underlined text.
    public static var underlineText: AccessibilitySystemRotor { get { fatalError() } }

    /// System Rotor allowing users to iterate through all the ranges of
    /// mis-spelled words.
    public static var misspelledWords: AccessibilitySystemRotor { get { fatalError() } }

    /// System Rotor allowing users to iterate through all images.
    public static var images: AccessibilitySystemRotor { get { fatalError() } }

    /// System Rotor allowing users to iterate through all text fields.
    public static var textFields: AccessibilitySystemRotor { get { fatalError() } }

    /// System Rotor allowing users to iterate through all tables.
    public static var tables: AccessibilitySystemRotor { get { fatalError() } }

    /// System Rotor allowing users to iterate through all lists.
    public static var lists: AccessibilitySystemRotor { get { fatalError() } }

    /// System Rotor allowing users to iterate through all landmarks.
    public static var landmarks: AccessibilitySystemRotor { get { fatalError() } }
}

/// Accessibility technologies available to the system.
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public struct AccessibilityTechnologies : SetAlgebra, Sendable {

    /// The value that represents the VoiceOver screen reader, allowing use
    /// of the system without seeing the screen visually.
    public static var voiceOver: AccessibilityTechnologies { get { fatalError() } }

    /// The value that represents a Switch Control, allowing the use of the
    /// entire system using controller buttons, a breath-controlled switch or similar hardware.
    public static var switchControl: AccessibilityTechnologies { get { fatalError() } }

    /// Creates a new accessibility technologies structure with an empy accessibility technology set.
    public init() { fatalError() }

    /// Returns a new set with the elements of both this and the given set.
    ///
    /// In the following example, the `attendeesAndVisitors` set is made up
    /// of the elements of the `attendees` and `visitors` sets:
    ///
    ///     let attendees: Set = ["Alicia", "Bethany", "Diana"]
    ///     let visitors = ["Marcia", "Nathaniel"]
    ///     let attendeesAndVisitors = attendees.union(visitors)
    ///     print(attendeesAndVisitors)
    ///     // Prints "["Diana", "Nathaniel", "Bethany", "Alicia", "Marcia"]"
    ///
    /// If the set already contains one or more elements that are also in
    /// `other`, the existing members are kept.
    ///
    ///     let initialIndices = Set(0..<5)
    ///     let expandedIndices = initialIndices.union([2, 3, 6, 7])
    ///     print(expandedIndices)
    ///     // Prints "[2, 4, 6, 7, 0, 1, 3]"
    ///
    /// - Parameter other: A set of the same type as the current set.
    /// - Returns: A new set with the unique elements of this set and `other`.
    ///
    /// - Note: if this set and `other` contain elements that are equal but
    ///   distinguishable (e.g. via `===`), which of these elements is present
    ///   in the result is unspecified.
    public func union(_ other: AccessibilityTechnologies) -> AccessibilityTechnologies { fatalError() }

    /// Adds the elements of the given set to the set.
    ///
    /// In the following example, the elements of the `visitors` set are added to
    /// the `attendees` set:
    ///
    ///     var attendees: Set = ["Alicia", "Bethany", "Diana"]
    ///     let visitors: Set = ["Diana", "Marcia", "Nathaniel"]
    ///     attendees.formUnion(visitors)
    ///     print(attendees)
    ///     // Prints "["Diana", "Nathaniel", "Bethany", "Alicia", "Marcia"]"
    ///
    /// If the set already contains one or more elements that are also in
    /// `other`, the existing members are kept.
    ///
    ///     var initialIndices = Set(0..<5)
    ///     initialIndices.formUnion([2, 3, 6, 7])
    ///     print(initialIndices)
    ///     // Prints "[2, 4, 6, 7, 0, 1, 3]"
    ///
    /// - Parameter other: A set of the same type as the current set.
    public mutating func formUnion(_ other: AccessibilityTechnologies) { fatalError() }

    /// Returns a new set with the elements that are common to both this set and
    /// the given set.
    ///
    /// In the following example, the `bothNeighborsAndEmployees` set is made up
    /// of the elements that are in *both* the `employees` and `neighbors` sets.
    /// Elements that are in only one or the other are left out of the result of
    /// the intersection.
    ///
    ///     let employees: Set = ["Alicia", "Bethany", "Chris", "Diana", "Eric"]
    ///     let neighbors: Set = ["Bethany", "Eric", "Forlani", "Greta"]
    ///     let bothNeighborsAndEmployees = employees.intersection(neighbors)
    ///     print(bothNeighborsAndEmployees)
    ///     // Prints "["Bethany", "Eric"]"
    ///
    /// - Parameter other: A set of the same type as the current set.
    /// - Returns: A new set.
    ///
    /// - Note: if this set and `other` contain elements that are equal but
    ///   distinguishable (e.g. via `===`), which of these elements is present
    ///   in the result is unspecified.
    public func intersection(_ other: AccessibilityTechnologies) -> AccessibilityTechnologies { fatalError() }

    /// Removes the elements of this set that aren't also in the given set.
    ///
    /// In the following example, the elements of the `employees` set that are
    /// not also members of the `neighbors` set are removed. In particular, the
    /// names `"Alicia"`, `"Chris"`, and `"Diana"` are removed.
    ///
    ///     var employees: Set = ["Alicia", "Bethany", "Chris", "Diana", "Eric"]
    ///     let neighbors: Set = ["Bethany", "Eric", "Forlani", "Greta"]
    ///     employees.formIntersection(neighbors)
    ///     print(employees)
    ///     // Prints "["Bethany", "Eric"]"
    ///
    /// - Parameter other: A set of the same type as the current set.
    public mutating func formIntersection(_ other: AccessibilityTechnologies) { fatalError() }

    /// Returns a new set with the elements that are either in this set or in the
    /// given set, but not in both.
    ///
    /// In the following example, the `eitherNeighborsOrEmployees` set is made up
    /// of the elements of the `employees` and `neighbors` sets that are not in
    /// both `employees` *and* `neighbors`. In particular, the names `"Bethany"`
    /// and `"Eric"` do not appear in `eitherNeighborsOrEmployees`.
    ///
    ///     let employees: Set = ["Alicia", "Bethany", "Diana", "Eric"]
    ///     let neighbors: Set = ["Bethany", "Eric", "Forlani"]
    ///     let eitherNeighborsOrEmployees = employees.symmetricDifference(neighbors)
    ///     print(eitherNeighborsOrEmployees)
    ///     // Prints "["Diana", "Forlani", "Alicia"]"
    ///
    /// - Parameter other: A set of the same type as the current set.
    /// - Returns: A new set.
    public func symmetricDifference(_ other: AccessibilityTechnologies) -> AccessibilityTechnologies { fatalError() }

    /// Removes the elements of the set that are also in the given set and adds
    /// the members of the given set that are not already in the set.
    ///
    /// In the following example, the elements of the `employees` set that are
    /// also members of `neighbors` are removed from `employees`, while the
    /// elements of `neighbors` that are not members of `employees` are added to
    /// `employees`. In particular, the names `"Bethany"` and `"Eric"` are
    /// removed from `employees` while the name `"Forlani"` is added.
    ///
    ///     var employees: Set = ["Alicia", "Bethany", "Diana", "Eric"]
    ///     let neighbors: Set = ["Bethany", "Eric", "Forlani"]
    ///     employees.formSymmetricDifference(neighbors)
    ///     print(employees)
    ///     // Prints "["Diana", "Forlani", "Alicia"]"
    ///
    /// - Parameter other: A set of the same type.
    public mutating func formSymmetricDifference(_ other: AccessibilityTechnologies) { fatalError() }

    /// Returns a Boolean value that indicates whether the given element exists
    /// in the set.
    ///
    /// This example uses the `contains(_:)` method to test whether an integer is
    /// a member of a set of prime numbers.
    ///
    ///     let primes: Set = [2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37]
    ///     let x = 5
    ///     if primes.contains(x) {
    ///         print("\(x) is prime!")
    ///     } else {
    ///         print("\(x). Not prime.")
    ///     }
    ///     // Prints "5 is prime!"
    ///
    /// - Parameter member: An element to look for in the set.
    /// - Returns: `true` if `member` exists in the set; otherwise, `false`.
    public func contains(_ member: AccessibilityTechnologies) -> Bool { fatalError() }

    /// Inserts the given element in the set if it is not already present.
    ///
    /// If an element equal to `newMember` is already contained in the set, this
    /// method has no effect. In this example, a new element is inserted into
    /// `classDays`, a set of days of the week. When an existing element is
    /// inserted, the `classDays` set does not change.
    ///
    ///     enum DayOfTheWeek: Int {
    ///         case sunday, monday, tuesday, wednesday, thursday,
    ///             friday, saturday
    ///     }
    ///
    ///     var classDays: Set<DayOfTheWeek> = [.wednesday, .friday]
    ///     print(classDays.insert(.monday))
    ///     // Prints "(true, .monday)"
    ///     print(classDays)
    ///     // Prints "[.friday, .wednesday, .monday]"
    ///
    ///     print(classDays.insert(.friday))
    ///     // Prints "(false, .friday)"
    ///     print(classDays)
    ///     // Prints "[.friday, .wednesday, .monday]"
    ///
    /// - Parameter newMember: An element to insert into the set.
    /// - Returns: `(true, newMember)` if `newMember` was not contained in the
    ///   set. If an element equal to `newMember` was already contained in the
    ///   set, the method returns `(false, oldMember)`, where `oldMember` is the
    ///   element that was equal to `newMember`. In some cases, `oldMember` may
    ///   be distinguishable from `newMember` by identity comparison or some
    ///   other means.
    public mutating func insert(_ newMember: AccessibilityTechnologies) -> (inserted: Bool, memberAfterInsert: AccessibilityTechnologies) { fatalError() }

    /// Removes the given element and any elements subsumed by the given element.
    ///
    /// - Parameter member: The element of the set to remove.
    /// - Returns: For ordinary sets, an element equal to `member` if `member` is
    ///   contained in the set; otherwise, `nil`. In some cases, a returned
    ///   element may be distinguishable from `member` by identity comparison
    ///   or some other means.
    ///
    ///   For sets where the set type and element type are the same, like
    ///   `OptionSet` types, this method returns any intersection between the set
    ///   and `[member]`, or `nil` if the intersection is empty.
    public mutating func remove(_ member: AccessibilityTechnologies) -> AccessibilityTechnologies? { fatalError() }

    /// Inserts the given element into the set unconditionally.
    ///
    /// If an element equal to `newMember` is already contained in the set,
    /// `newMember` replaces the existing element. In this example, an existing
    /// element is inserted into `classDays`, a set of days of the week.
    ///
    ///     enum DayOfTheWeek: Int {
    ///         case sunday, monday, tuesday, wednesday, thursday,
    ///             friday, saturday
    ///     }
    ///
    ///     var classDays: Set<DayOfTheWeek> = [.monday, .wednesday, .friday]
    ///     print(classDays.update(with: .monday))
    ///     // Prints "Optional(.monday)"
    ///
    /// - Parameter newMember: An element to insert into the set.
    /// - Returns: For ordinary sets, an element equal to `newMember` if the set
    ///   already contained such a member; otherwise, `nil`. In some cases, the
    ///   returned element may be distinguishable from `newMember` by identity
    ///   comparison or some other means.
    ///
    ///   For sets where the set type and element type are the same, like
    ///   `OptionSet` types, this method returns any intersection between the
    ///   set and `[newMember]`, or `nil` if the intersection is empty.
    public mutating func update(with newMember: AccessibilityTechnologies) -> AccessibilityTechnologies? { fatalError() }

    

    /// The type of the elements of an array literal.
    public typealias ArrayLiteralElement = AccessibilityTechnologies

    /// A type for which the conforming type provides a containment test.
    public typealias Element = AccessibilityTechnologies
}

/// Textual context that assistive technologies can use to improve the
/// presentation of spoken text.
///
/// Use an `AccessibilityTextContentType` value when setting the accessibility text content
/// type of a view using the ``View/accessibilityTextContentType(_:)`` modifier.
///
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public struct AccessibilityTextContentType : Sendable {

    /// A type that represents generic text that has no specific type.
    public static let plain: AccessibilityTextContentType = { fatalError() }()

    /// A type that represents text used for input, like in the Terminal app.
    public static let console: AccessibilityTextContentType = { fatalError() }()

    /// A type that represents text used by a file browser, like in the Finder app in macOS.
    public static let fileSystem: AccessibilityTextContentType = { fatalError() }()

    /// A type that represents text used in a message, like in the Messages app.
    public static let messaging: AccessibilityTextContentType = { fatalError() }()

    /// A type that represents text used in a story or poem, like in the Books app.
    public static let narrative: AccessibilityTextContentType = { fatalError() }()

    /// A type that represents text used in source code, like in Swift Playgrounds.
    public static let sourceCode: AccessibilityTextContentType = { fatalError() }()

    /// A type that represents text used in a grid of data, like in the Numbers app.
    public static let spreadsheet: AccessibilityTextContentType = { fatalError() }()

    /// A type that represents text used in a document, like in the Pages app.
    public static let wordProcessing: AccessibilityTextContentType = { fatalError() }()
}

/// A set of accessibility traits that describe how an element behaves.
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
public struct AccessibilityTraits : SetAlgebra, Sendable {

    /// The accessibility element is a button.
    public static let isButton: AccessibilityTraits = { fatalError() }()

    /// The accessibility element is a header that divides content into
    /// sections, like the title of a navigation bar.
    public static let isHeader: AccessibilityTraits = { fatalError() }()

    /// The accessibility element is currently selected.
    public static let isSelected: AccessibilityTraits = { fatalError() }()

    /// The accessibility element is a link.
    public static let isLink: AccessibilityTraits = { fatalError() }()

    /// The accessibility element is a search field.
    public static let isSearchField: AccessibilityTraits = { fatalError() }()

    /// The accessibility element is an image.
    public static let isImage: AccessibilityTraits = { fatalError() }()

    /// The accessibility element plays its own sound when activated.
    public static let playsSound: AccessibilityTraits = { fatalError() }()

    /// The accessibility element behaves as a keyboard key.
    public static let isKeyboardKey: AccessibilityTraits = { fatalError() }()

    /// The accessibility element is a static text that cannot be
    /// modified by the user.
    public static let isStaticText: AccessibilityTraits = { fatalError() }()

    /// The accessibility element provides summary information when the
    /// application starts.
    ///
    /// Use this trait to characterize an accessibility element that provides
    /// a summary of current conditions, settings, or state, like the
    /// temperature in the Weather app.
    public static let isSummaryElement: AccessibilityTraits = { fatalError() }()

    /// The accessibility element frequently updates its label or value.
    ///
    /// Use this trait when you want an assistive technology to poll for
    /// changes when it needs updated information. For example, you might use
    /// this trait to characterize the readout of a stopwatch.
    public static let updatesFrequently: AccessibilityTraits = { fatalError() }()

    /// The accessibility element starts a media session when it is activated.
    ///
    /// Use this trait to silence the audio output of an assistive technology,
    /// such as VoiceOver, during a media session that should not be interrupted.
    /// For example, you might use this trait to silence VoiceOver speech while
    /// the user is recording audio.
    public static let startsMediaSession: AccessibilityTraits = { fatalError() }()

    /// The accessibility element allows direct touch interaction for
    /// VoiceOver users.
    public static let allowsDirectInteraction: AccessibilityTraits = { fatalError() }()

    /// The accessibility element causes an automatic page turn when VoiceOver
    /// finishes reading the text within it.
    public static let causesPageTurn: AccessibilityTraits = { fatalError() }()

    /// The accessibility element is modal.
    ///
    /// Use this trait to restrict which accessibility elements an assistive
    /// technology can navigate. When a modal accessibility element is visible,
    /// sibling accessibility elements that are not modal are ignored.
    public static let isModal: AccessibilityTraits = { fatalError() }()

    /// The accessibility element is a toggle.
    @available(macOS 14.0, iOS 17.0, tvOS 17.0, watchOS 10.0, *)
    public static let isToggle: AccessibilityTraits = { fatalError() }()

    /// Creates an empty set.
    ///
    /// This initializer is equivalent to initializing with an empty array
    /// literal. For example, you create an empty `Set` instance with either
    /// this initializer or with an empty array literal.
    ///
    ///     var emptySet = Set<Int>()
    ///     print(emptySet.isEmpty)
    ///     // Prints "true"
    ///
    ///     emptySet = []
    ///     print(emptySet.isEmpty)
    ///     // Prints "true"
    public init() { fatalError() }

    /// Returns a new set with the elements of both this and the given set.
    ///
    /// In the following example, the `attendeesAndVisitors` set is made up
    /// of the elements of the `attendees` and `visitors` sets:
    ///
    ///     let attendees: Set = ["Alicia", "Bethany", "Diana"]
    ///     let visitors = ["Marcia", "Nathaniel"]
    ///     let attendeesAndVisitors = attendees.union(visitors)
    ///     print(attendeesAndVisitors)
    ///     // Prints "["Diana", "Nathaniel", "Bethany", "Alicia", "Marcia"]"
    ///
    /// If the set already contains one or more elements that are also in
    /// `other`, the existing members are kept.
    ///
    ///     let initialIndices = Set(0..<5)
    ///     let expandedIndices = initialIndices.union([2, 3, 6, 7])
    ///     print(expandedIndices)
    ///     // Prints "[2, 4, 6, 7, 0, 1, 3]"
    ///
    /// - Parameter other: A set of the same type as the current set.
    /// - Returns: A new set with the unique elements of this set and `other`.
    ///
    /// - Note: if this set and `other` contain elements that are equal but
    ///   distinguishable (e.g. via `===`), which of these elements is present
    ///   in the result is unspecified.
    public func union(_ other: AccessibilityTraits) -> AccessibilityTraits { fatalError() }

    /// Adds the elements of the given set to the set.
    ///
    /// In the following example, the elements of the `visitors` set are added to
    /// the `attendees` set:
    ///
    ///     var attendees: Set = ["Alicia", "Bethany", "Diana"]
    ///     let visitors: Set = ["Diana", "Marcia", "Nathaniel"]
    ///     attendees.formUnion(visitors)
    ///     print(attendees)
    ///     // Prints "["Diana", "Nathaniel", "Bethany", "Alicia", "Marcia"]"
    ///
    /// If the set already contains one or more elements that are also in
    /// `other`, the existing members are kept.
    ///
    ///     var initialIndices = Set(0..<5)
    ///     initialIndices.formUnion([2, 3, 6, 7])
    ///     print(initialIndices)
    ///     // Prints "[2, 4, 6, 7, 0, 1, 3]"
    ///
    /// - Parameter other: A set of the same type as the current set.
    public mutating func formUnion(_ other: AccessibilityTraits) { fatalError() }

    /// Returns a new set with the elements that are common to both this set and
    /// the given set.
    ///
    /// In the following example, the `bothNeighborsAndEmployees` set is made up
    /// of the elements that are in *both* the `employees` and `neighbors` sets.
    /// Elements that are in only one or the other are left out of the result of
    /// the intersection.
    ///
    ///     let employees: Set = ["Alicia", "Bethany", "Chris", "Diana", "Eric"]
    ///     let neighbors: Set = ["Bethany", "Eric", "Forlani", "Greta"]
    ///     let bothNeighborsAndEmployees = employees.intersection(neighbors)
    ///     print(bothNeighborsAndEmployees)
    ///     // Prints "["Bethany", "Eric"]"
    ///
    /// - Parameter other: A set of the same type as the current set.
    /// - Returns: A new set.
    ///
    /// - Note: if this set and `other` contain elements that are equal but
    ///   distinguishable (e.g. via `===`), which of these elements is present
    ///   in the result is unspecified.
    public func intersection(_ other: AccessibilityTraits) -> AccessibilityTraits { fatalError() }

    /// Removes the elements of this set that aren't also in the given set.
    ///
    /// In the following example, the elements of the `employees` set that are
    /// not also members of the `neighbors` set are removed. In particular, the
    /// names `"Alicia"`, `"Chris"`, and `"Diana"` are removed.
    ///
    ///     var employees: Set = ["Alicia", "Bethany", "Chris", "Diana", "Eric"]
    ///     let neighbors: Set = ["Bethany", "Eric", "Forlani", "Greta"]
    ///     employees.formIntersection(neighbors)
    ///     print(employees)
    ///     // Prints "["Bethany", "Eric"]"
    ///
    /// - Parameter other: A set of the same type as the current set.
    public mutating func formIntersection(_ other: AccessibilityTraits) { fatalError() }

    /// Returns a new set with the elements that are either in this set or in the
    /// given set, but not in both.
    ///
    /// In the following example, the `eitherNeighborsOrEmployees` set is made up
    /// of the elements of the `employees` and `neighbors` sets that are not in
    /// both `employees` *and* `neighbors`. In particular, the names `"Bethany"`
    /// and `"Eric"` do not appear in `eitherNeighborsOrEmployees`.
    ///
    ///     let employees: Set = ["Alicia", "Bethany", "Diana", "Eric"]
    ///     let neighbors: Set = ["Bethany", "Eric", "Forlani"]
    ///     let eitherNeighborsOrEmployees = employees.symmetricDifference(neighbors)
    ///     print(eitherNeighborsOrEmployees)
    ///     // Prints "["Diana", "Forlani", "Alicia"]"
    ///
    /// - Parameter other: A set of the same type as the current set.
    /// - Returns: A new set.
    public func symmetricDifference(_ other: AccessibilityTraits) -> AccessibilityTraits { fatalError() }

    /// Removes the elements of the set that are also in the given set and adds
    /// the members of the given set that are not already in the set.
    ///
    /// In the following example, the elements of the `employees` set that are
    /// also members of `neighbors` are removed from `employees`, while the
    /// elements of `neighbors` that are not members of `employees` are added to
    /// `employees`. In particular, the names `"Bethany"` and `"Eric"` are
    /// removed from `employees` while the name `"Forlani"` is added.
    ///
    ///     var employees: Set = ["Alicia", "Bethany", "Diana", "Eric"]
    ///     let neighbors: Set = ["Bethany", "Eric", "Forlani"]
    ///     employees.formSymmetricDifference(neighbors)
    ///     print(employees)
    ///     // Prints "["Diana", "Forlani", "Alicia"]"
    ///
    /// - Parameter other: A set of the same type.
    public mutating func formSymmetricDifference(_ other: AccessibilityTraits) { fatalError() }

    /// Returns a Boolean value that indicates whether the given element exists
    /// in the set.
    ///
    /// This example uses the `contains(_:)` method to test whether an integer is
    /// a member of a set of prime numbers.
    ///
    ///     let primes: Set = [2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37]
    ///     let x = 5
    ///     if primes.contains(x) {
    ///         print("\(x) is prime!")
    ///     } else {
    ///         print("\(x). Not prime.")
    ///     }
    ///     // Prints "5 is prime!"
    ///
    /// - Parameter member: An element to look for in the set.
    /// - Returns: `true` if `member` exists in the set; otherwise, `false`.
    public func contains(_ member: AccessibilityTraits) -> Bool { fatalError() }

    /// Inserts the given element in the set if it is not already present.
    ///
    /// If an element equal to `newMember` is already contained in the set, this
    /// method has no effect. In this example, a new element is inserted into
    /// `classDays`, a set of days of the week. When an existing element is
    /// inserted, the `classDays` set does not change.
    ///
    ///     enum DayOfTheWeek: Int {
    ///         case sunday, monday, tuesday, wednesday, thursday,
    ///             friday, saturday
    ///     }
    ///
    ///     var classDays: Set<DayOfTheWeek> = [.wednesday, .friday]
    ///     print(classDays.insert(.monday))
    ///     // Prints "(true, .monday)"
    ///     print(classDays)
    ///     // Prints "[.friday, .wednesday, .monday]"
    ///
    ///     print(classDays.insert(.friday))
    ///     // Prints "(false, .friday)"
    ///     print(classDays)
    ///     // Prints "[.friday, .wednesday, .monday]"
    ///
    /// - Parameter newMember: An element to insert into the set.
    /// - Returns: `(true, newMember)` if `newMember` was not contained in the
    ///   set. If an element equal to `newMember` was already contained in the
    ///   set, the method returns `(false, oldMember)`, where `oldMember` is the
    ///   element that was equal to `newMember`. In some cases, `oldMember` may
    ///   be distinguishable from `newMember` by identity comparison or some
    ///   other means.
    public mutating func insert(_ newMember: AccessibilityTraits) -> (inserted: Bool, memberAfterInsert: AccessibilityTraits) { fatalError() }

    /// Removes the given element and any elements subsumed by the given element.
    ///
    /// - Parameter member: The element of the set to remove.
    /// - Returns: For ordinary sets, an element equal to `member` if `member` is
    ///   contained in the set; otherwise, `nil`. In some cases, a returned
    ///   element may be distinguishable from `member` by identity comparison
    ///   or some other means.
    ///
    ///   For sets where the set type and element type are the same, like
    ///   `OptionSet` types, this method returns any intersection between the set
    ///   and `[member]`, or `nil` if the intersection is empty.
    public mutating func remove(_ member: AccessibilityTraits) -> AccessibilityTraits? { fatalError() }

    /// Inserts the given element into the set unconditionally.
    ///
    /// If an element equal to `newMember` is already contained in the set,
    /// `newMember` replaces the existing element. In this example, an existing
    /// element is inserted into `classDays`, a set of days of the week.
    ///
    ///     enum DayOfTheWeek: Int {
    ///         case sunday, monday, tuesday, wednesday, thursday,
    ///             friday, saturday
    ///     }
    ///
    ///     var classDays: Set<DayOfTheWeek> = [.monday, .wednesday, .friday]
    ///     print(classDays.update(with: .monday))
    ///     // Prints "Optional(.monday)"
    ///
    /// - Parameter newMember: An element to insert into the set.
    /// - Returns: For ordinary sets, an element equal to `newMember` if the set
    ///   already contained such a member; otherwise, `nil`. In some cases, the
    ///   returned element may be distinguishable from `newMember` by identity
    ///   comparison or some other means.
    ///
    ///   For sets where the set type and element type are the same, like
    ///   `OptionSet` types, this method returns any intersection between the
    ///   set and `[newMember]`, or `nil` if the intersection is empty.
    public mutating func update(with newMember: AccessibilityTraits) -> AccessibilityTraits? { fatalError() }

    

    /// The type of the elements of an array literal.
    public typealias ArrayLiteralElement = AccessibilityTraits

    /// A type for which the conforming type provides a containment test.
    public typealias Element = AccessibilityTraits
}

/// Position and direction information of a zoom gesture that someone performs
/// with an assistive technology like VoiceOver.
@available(macOS 13.0, iOS 16.0, tvOS 16.0, watchOS 9.0, *)
public struct AccessibilityZoomGestureAction {

    /// A direction that matches the movement of a zoom gesture performed
    /// by an assistive technology, such as a swipe up and down in Voiceover's
    /// zoom rotor.
    @frozen public enum Direction {

        /// The gesture direction that represents zooming in.
        case zoomIn

        /// The gesture direction that represents zooming out.
        case zoomOut

        

    
        }

    /// The zoom gesture's direction.
    public let direction: AccessibilityZoomGestureAction.Direction = { fatalError() }()

    /// The zoom gesture's activation point, normalized to the accessibility
    /// element's frame.
    public let location: UnitPoint = { fatalError() }()

    /// The zoom gesture's activation point within the window's coordinate
    /// space.
    public let point: CGPoint = { fatalError() }()
}

@available(macOS 13.0, iOS 16.0, tvOS 16.0, watchOS 9.0, *)
extension AccessibilityZoomGestureAction.Direction : Equatable {
}

@available(macOS 13.0, iOS 16.0, tvOS 16.0, watchOS 9.0, *)
extension AccessibilityZoomGestureAction.Direction : Hashable {
}

@available(macOS 13.0, iOS 16.0, tvOS 16.0, watchOS 9.0, *)
extension AccessibilityZoomGestureAction.Direction : Sendable {
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

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
extension View {

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
    public func accessibilityCustomContent(_ key: AccessibilityCustomContentKey, _ value: Text?, importance: AXCustomContent.Importance = .default) -> ModifiedContent<Self, AccessibilityAttachmentModifier> { fatalError() }

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
    public func accessibilityCustomContent(_ key: AccessibilityCustomContentKey, _ valueKey: LocalizedStringKey, importance: AXCustomContent.Importance = .default) -> ModifiedContent<Self, AccessibilityAttachmentModifier> { fatalError() }

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
    public func accessibilityCustomContent<V>(_ key: AccessibilityCustomContentKey, _ value: V, importance: AXCustomContent.Importance = .default) -> ModifiedContent<Self, AccessibilityAttachmentModifier> where V : StringProtocol { fatalError() }
}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
extension View {

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
    public func accessibilityCustomContent(_ label: Text, _ value: Text, importance: AXCustomContent.Importance = .default) -> ModifiedContent<Self, AccessibilityAttachmentModifier> { fatalError() }

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
    public func accessibilityCustomContent(_ labelKey: LocalizedStringKey, _ value: Text, importance: AXCustomContent.Importance = .default) -> ModifiedContent<Self, AccessibilityAttachmentModifier> { fatalError() }

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
    public func accessibilityCustomContent(_ labelKey: LocalizedStringKey, _ valueKey: LocalizedStringKey, importance: AXCustomContent.Importance = .default) -> ModifiedContent<Self, AccessibilityAttachmentModifier> { fatalError() }

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
    public func accessibilityCustomContent<V>(_ labelKey: LocalizedStringKey, _ value: V, importance: AXCustomContent.Importance = .default) -> ModifiedContent<Self, AccessibilityAttachmentModifier> where V : StringProtocol { fatalError() }
}


@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
extension View {

    /// Communicates to the user what happens after performing the view's
    /// action.
    ///
    /// Provide a hint in the form of a brief phrase, like "Purchases the item" or
    /// "Downloads the attachment".
    ///
    /// > Note: On macOS, if the view does not have an action and it has been
    ///   made into a container with ``accessibilityElement(children: .contain)``,
    ///   this will be used to describe the container. For example, if the container is
    ///   for a graph, the hint could be "graph".
    public func accessibilityHint(_ hint: Text) -> ModifiedContent<Self, AccessibilityAttachmentModifier> { fatalError() }

    /// Sets alternate input labels with which users identify a view.
    ///
    /// Provide labels in descending order of importance. Voice Control
    /// and Full Keyboard Access use the input labels.
    ///
    /// > Note: If you don't specify any input labels, the user can still
    ///   refer to the view using the accessibility label that you add with the
    ///   `accessibilityLabel()` modifier.
    ///
    /// - Parameter inputLabels: An array of Text elements to use as input labels.
    public func accessibilityInputLabels(_ inputLabels: [Text]) -> ModifiedContent<Self, AccessibilityAttachmentModifier> { fatalError() }
}

@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
extension View {

    /// Communicates to the user what happens after performing the view's
    /// action.
    ///
    /// Provide a hint in the form of a brief phrase, like "Purchases the item" or
    /// "Downloads the attachment".
    public func accessibilityHint(_ hintKey: LocalizedStringKey) -> ModifiedContent<Self, AccessibilityAttachmentModifier> { fatalError() }

    /// Communicates to the user what happens after performing the view's
    /// action.
    ///
    /// Provide a hint in the form of a brief phrase, like "Purchases the item" or
    /// "Downloads the attachment".
    public func accessibilityHint<S>(_ hint: S) -> ModifiedContent<Self, AccessibilityAttachmentModifier> where S : StringProtocol { fatalError() }

    /// Sets alternate input labels with which users identify a view.
    ///
    /// Provide labels in descending order of importance. Voice Control
    /// and Full Keyboard Access use the input labels.
    ///
    /// > Note: If you don't specify any input labels, the user can still
    ///   refer to the view using the accessibility label that you add with the
    ///   `accessibilityLabel()` modifier.
    public func accessibilityInputLabels(_ inputLabelKeys: [LocalizedStringKey]) -> ModifiedContent<Self, AccessibilityAttachmentModifier> { fatalError() }

    /// Sets alternate input labels with which users identify a view.
    ///
    /// Provide labels in descending order of importance. Voice Control
    /// and Full Keyboard Access use the input labels.
    ///
    /// > Note: If you don't specify any input labels, the user can still
    ///   refer to the view using the accessibility label that you add with the
    ///   `accessibilityLabel()` modifier.
    public func accessibilityInputLabels<S>(_ inputLabels: [S]) -> ModifiedContent<Self, AccessibilityAttachmentModifier> where S : StringProtocol { fatalError() }
}

extension View {

    /// Specifies whether to hide this view from system accessibility features.
    @available(iOS, introduced: 13.0, deprecated: 100000.0, renamed: "accessibilityHidden(_:)")
    @available(macOS, introduced: 10.15, deprecated: 100000.0, renamed: "accessibilityHidden(_:)")
    @available(tvOS, introduced: 13.0, deprecated: 100000.0, renamed: "accessibilityHidden(_:)")
    @available(watchOS, introduced: 6, deprecated: 100000.0, renamed: "accessibilityHidden(_:)")
    @available(xrOS, introduced: 1.0, deprecated: 100000.0, renamed: "accessibilityHidden(_:)")
    public func accessibility(hidden: Bool) -> ModifiedContent<Self, AccessibilityAttachmentModifier> { fatalError() }

    /// Communicates to the user what happens after performing the view's
    /// action.
    ///
    /// Provide a hint in the form of a brief phrase, like "Purchases the item" or
    /// "Downloads the attachment".
    @available(iOS, introduced: 13.0, deprecated: 100000.0, renamed: "accessibilityHint(_:)")
    @available(macOS, introduced: 10.15, deprecated: 100000.0, renamed: "accessibilityHint(_:)")
    @available(tvOS, introduced: 13.0, deprecated: 100000.0, renamed: "accessibilityHint(_:)")
    @available(watchOS, introduced: 6, deprecated: 100000.0, renamed: "accessibilityHint(_:)")
    @available(xrOS, introduced: 1.0, deprecated: 100000.0, renamed: "accessibilityHint(_:)")
    public func accessibility(hint: Text) -> ModifiedContent<Self, AccessibilityAttachmentModifier> { fatalError() }

    /// Sets alternate input labels with which users identify a view.
    ///
    /// Provide labels in descending order of importance. Voice Control
    /// and Full Keyboard Access use the input labels.
    ///
    /// > Note: If you don't specify any input labels, the user can still
    ///   refer to the view using the accessibility label that you add with the
    ///   ``accessibility(label:)`` modifier.
    ///
    /// - Parameter inputLabels: An array of Text elements to use as input labels.
    @available(iOS, introduced: 13.0, deprecated: 100000.0, renamed: "accessibilityInputLabels(_:)")
    @available(macOS, introduced: 10.15, deprecated: 100000.0, renamed: "accessibilityInputLabels(_:)")
    @available(tvOS, introduced: 13.0, deprecated: 100000.0, renamed: "accessibilityInputLabels(_:)")
    @available(watchOS, introduced: 6, deprecated: 100000.0, renamed: "accessibilityInputLabels(_:)")
    @available(xrOS, introduced: 1.0, deprecated: 100000.0, renamed: "accessibilityInputLabels(_:)")
    public func accessibility(inputLabels: [Text]) -> ModifiedContent<Self, AccessibilityAttachmentModifier> { fatalError() }

    /// Sets a selection identifier for this view's accessibility element.
    ///
    /// Picker uses the value to determine what node to use for the
    /// accessibility value.
    @available(iOS, deprecated, introduced: 13.0)
    @available(macOS, deprecated, introduced: 10.15)
    @available(tvOS, deprecated, introduced: 13.0)
    @available(watchOS, deprecated, introduced: 6)
    @available(xrOS, introduced: 1.0, deprecated: 1.0)
    public func accessibility(selectionIdentifier: AnyHashable) -> ModifiedContent<Self, AccessibilityAttachmentModifier> { fatalError() }

    /// Sets the sort priority order for this view's accessibility element,
    /// relative to other elements at the same level.
    ///
    /// Higher numbers are sorted first. The default sort priority is zero.
    @available(iOS, introduced: 13.0, deprecated: 100000.0, renamed: "accessibilitySortPriority(_:)")
    @available(macOS, introduced: 10.15, deprecated: 100000.0, renamed: "accessibilitySortPriority(_:)")
    @available(tvOS, introduced: 13.0, deprecated: 100000.0, renamed: "accessibilitySortPriority(_:)")
    @available(watchOS, introduced: 6, deprecated: 100000.0, renamed: "accessibilitySortPriority(_:)")
    @available(xrOS, introduced: 1.0, deprecated: 100000.0, renamed: "accessibilitySortPriority(_:)")
    public func accessibility(sortPriority: Double) -> ModifiedContent<Self, AccessibilityAttachmentModifier> { fatalError() }

    /// Specifies the point where activations occur in the view.
    @available(iOS, introduced: 13.0, deprecated: 100000.0, renamed: "accessibilityActivationPoint(_:)")
    @available(macOS, introduced: 10.15, deprecated: 100000.0, renamed: "accessibilityActivationPoint(_:)")
    @available(tvOS, introduced: 13.0, deprecated: 100000.0, renamed: "accessibilityActivationPoint(_:)")
    @available(watchOS, introduced: 6, deprecated: 100000.0, renamed: "accessibilityActivationPoint(_:)")
    @available(xrOS, introduced: 1.0, deprecated: 100000.0, renamed: "accessibilityActivationPoint(_:)")
    public func accessibility(activationPoint: CGPoint) -> ModifiedContent<Self, AccessibilityAttachmentModifier> { fatalError() }

    /// Specifies the unit point where activations occur in the view.
    @available(iOS, introduced: 13.0, deprecated: 100000.0, renamed: "accessibilityActivationPoint(_:)")
    @available(macOS, introduced: 10.15, deprecated: 100000.0, renamed: "accessibilityActivationPoint(_:)")
    @available(tvOS, introduced: 13.0, deprecated: 100000.0, renamed: "accessibilityActivationPoint(_:)")
    @available(watchOS, introduced: 6, deprecated: 100000.0, renamed: "accessibilityActivationPoint(_:)")
    @available(xrOS, introduced: 1.0, deprecated: 100000.0, renamed: "accessibilityActivationPoint(_:)")
    public func accessibility(activationPoint: UnitPoint) -> ModifiedContent<Self, AccessibilityAttachmentModifier> { fatalError() }
}


@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension View {

    /// Adds an accessibility action to the view. Actions allow assistive technologies,
    /// such as the VoiceOver, to interact with the view by invoking the action.
    ///
    /// For example, this is how a `.default` action to compose
    /// a new email could be added to a view.
    ///
    ///     var body: some View {
    ///         ContentView()
    ///             .accessibilityAction {
    ///                 // Handle action
    ///             }
    ///     }
    ///
    public func accessibilityAction(_ actionKind: AccessibilityActionKind = .default, _ handler: @escaping () -> Void) -> ModifiedContent<Self, AccessibilityAttachmentModifier> { fatalError() }

    /// Adds an accessibility action to the view. Actions allow assistive technologies,
    /// such as the VoiceOver, to interact with the view by invoking the action.
    ///
    /// For example, this is how a custom action to compose
    /// a new email could be added to a view.
    ///
    ///     var body: some View {
    ///         ContentView()
    ///             .accessibilityAction(named: Text("New Message")) {
    ///                 // Handle action
    ///             }
    ///     }
    ///
    public func accessibilityAction(named name: Text, _ handler: @escaping () -> Void) -> ModifiedContent<Self, AccessibilityAttachmentModifier> { fatalError() }
}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
extension View {

    /// Adds an accessibility action to the view. Actions allow assistive technologies,
    /// such as the VoiceOver, to interact with the view by invoking the action.
    ///
    /// For example, this is how a custom action to compose
    /// a new email could be added to a view.
    ///
    ///     var body: some View {
    ///         ContentView()
    ///             .accessibilityAction {
    ///                 // Handle action
    ///             } label: {
    ///                 Label("New Message", systemImage: "plus")
    ///             }
    ///     }
    ///
    public func accessibilityAction<Label>(action: @escaping () -> Void, @ViewBuilder label: () -> Label) -> some View where Label : View { return stubView() }

}

@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
extension View {

    /// Adds multiple accessibility actions to the view.
    ///
    /// Actions allow assistive technologies,
    /// such as the VoiceOver, to interact with the view by invoking the action.
    /// For example, this is how a dynamic number of custom action could
    /// be added to a view.
    ///
    ///     var isDraft: Bool
    ///
    ///     var body: some View {
    ///         ContentView()
    ///             .accessibilityActions {
    ///                 ForEach(actions) { action in
    ///                     Button {
    ///                         action()
    ///                     } label: {
    ///                         Text(action.title)
    ///                     }
    ///                 }
    ///
    ///                 if isDraft {
    ///                     Button {
    ///                         // Handle Delete
    ///                     } label: {
    ///                         Text("Delete")
    ///                     }
    ///                 }
    ///             }
    ///
    public func accessibilityActions<Content>(@ViewBuilder _ content: () -> Content) -> some View where Content : View { return stubView() }

}

@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
extension View {

    /// Adds an accessibility action to the view. Actions allow assistive technologies,
    /// such as the VoiceOver, to interact with the view by invoking the action.
    ///
    /// For example, this is how a custom action to compose
    /// a new email could be added to a view.
    ///
    ///     var body: some View {
    ///         ContentView()
    ///             .accessibilityAction(named: "New Message") {
    ///                 // Handle action
    ///             }
    ///     }
    ///
    public func accessibilityAction(named nameKey: LocalizedStringKey, _ handler: @escaping () -> Void) -> ModifiedContent<Self, AccessibilityAttachmentModifier> { fatalError() }

    /// Adds an accessibility action to the view. Actions allow assistive technologies,
    /// such as the VoiceOver, to interact with the view by invoking the action.
    ///
    /// For example, this is how a custom action to compose
    /// a new email could be added to a view.
    ///
    ///     var body: some View {
    ///         ContentView()
    ///             .accessibilityAction(named: "New Message") {
    ///                 // Handle action
    ///             }
    ///     }
    ///
    public func accessibilityAction<S>(named name: S, _ handler: @escaping () -> Void) -> ModifiedContent<Self, AccessibilityAttachmentModifier> where S : StringProtocol { fatalError() }
}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
extension View {

    /// Create an Accessibility Rotor with the specified user-visible label,
    /// and entries generated from the content closure.
    ///
    /// An Accessibility Rotor is a shortcut for Accessibility users to
    /// quickly navigate to specific elements of the user interface,
    /// and optionally specific ranges of text within those elements.
    ///
    /// In the following example, a Message application creates a Rotor
    /// allowing users to navigate to specifically the messages originating from
    /// VIPs.
    ///
    ///     // `messages` is a list of `Identifiable` `Message`s.
    ///
    ///     ScrollView {
    ///         LazyVStack {
    ///             ForEach(messages) { message in
    ///                 MessageView(message)
    ///             }
    ///         }
    ///     }
    ///     .accessibilityElement(children: .contain)
    ///     .accessibilityRotor("VIPs") {
    ///         // Not all the MessageViews are generated at once, the model knows
    ///         // about all the messages.
    ///         ForEach(messages) { message in
    ///             // If the Message is from a VIP, make a Rotor entry for it.
    ///             if message.isVIP {
    ///                 AccessibilityRotorEntry(message.subject, id: message.id)
    ///             }
    ///         }
    ///     }
    ///
    /// - Parameters:
    ///   - label: Localized label identifying this Rotor to the user.
    ///   - entries: Content used to generate Rotor entries. This can
    ///     include AccessibilityRotorEntry structs, as well as constructs such
    ///     as if and ForEach.
    public func accessibilityRotor<Content>(_ label: Text, @AccessibilityRotorContentBuilder entries: @escaping () -> Content) -> some View where Content : AccessibilityRotorContent { return stubView() }


    /// Create an Accessibility Rotor replacing the specified system-provided
    /// Rotor.
    ///
    /// An Accessibility Rotor is a shortcut for Accessibility users to
    /// quickly navigate to specific elements of the user interface,
    /// and optionally specific ranges of text within those elements.
    /// Replacing system Rotors this way is useful when the System Rotor
    /// does not automatically pick up elements that aren't on-screen,
    /// such as elements far down in a `LazyVStack` or `List`.
    ///
    /// In the following example, a Message application adds a Rotor allowing
    /// the user to navigate through all the ranges of text containing
    /// headings.
    ///
    ///     extension Message {
    ///         // Ranges of special areas in the `content` text. Calculated
    ///         // when `content` is set and then cached so that we don't have
    ///         // to re-compute them.
    ///         var contentHeadingRanges: [Range<String.Index>]
    ///     }
    ///
    ///     struct MessageContentView: View {
    ///         TextEditor(.constant(message.content))
    ///             .accessibilityRotor(.heading) {
    ///                 ForEach(range in message.contentHeadingRanges) {
    ///                     AccessibilityRotorEntry(textRange: range)
    ///                 }
    ///             }
    ///     }
    ///
    /// - Parameters:
    ///   - systemRotor: The system-provided Rotor that will be overridden
    ///     by this custom Rotor.
    ///   - entries: Content used to generate Rotor entries. This can
    ///     include AccessibilityRotorEntry structs, as well as constructs such
    ///     as if and ForEach.
    public func accessibilityRotor<Content>(_ systemRotor: AccessibilitySystemRotor, @AccessibilityRotorContentBuilder entries: @escaping () -> Content) -> some View where Content : AccessibilityRotorContent { return stubView() }


    /// Create an Accessibility Rotor with the specified user-visible label
    /// and entries.
    ///
    /// An Accessibility Rotor is a shortcut for Accessibility users to
    /// quickly navigate to specific elements of the user interface,
    /// and optionally specific ranges of text within those elements.
    ///
    /// Using this modifier requires
    /// that the Rotor be attached to a `ScrollView`, or an Accessibility
    /// Element directly within a `ScrollView`, such as a `ForEach`.
    ///
    /// In the following example, a Message application creates a Rotor
    /// allowing users to navigate to specifically the messages originating from
    /// VIPs.
    ///
    ///     // `messages` is a list of `Identifiable` `Message`s that have a
    ///     // `subject`.
    ///     // `vipMessages` is a filtered version of that list containing only
    ///     // messages from VIPs.
    ///
    ///     ScrollView {
    ///         LazyVStack {
    ///             ForEach(messages) { message in
    ///                 MessageView(message)
    ///             }
    ///         }
    ///     }
    ///     .accessibilityElement(children: .contain)
    ///     .accessibilityRotor("VIPs", entries: vipMessages, label: \.subject)
    ///
    /// - Parameters:
    ///   - rotorLabel: Localized label identifying this Rotor to the user.
    ///   - entries: An array of identifiable values that will be
    ///     used to generate the entries of the Rotor. The identifiers
    ///     of the `Identifiable` values must match up with identifiers in a
    ///     `ForEach` or explicit `id` calls within the `ScrollView`.
    ///     When the user navigates to entries from this Rotor, SkipUI will
    ///     automatically scroll them into place as needed.
    ///   - entryLabel: Key path on the `Identifiable` type that can be
    ///     used to get a user-visible label for every Rotor entry. This is used
    ///     on macOS when the user opens the list of entries for the Rotor.
    public func accessibilityRotor<EntryModel>(_ rotorLabel: Text, entries: [EntryModel], entryLabel: KeyPath<EntryModel, String>) -> some View where EntryModel : Identifiable { return stubView() }


    /// Create an Accessibility Rotor with the specified user-visible label
    /// and entries.
    ///
    /// An Accessibility Rotor is a shortcut for Accessibility users to
    /// quickly navigate to specific elements of the user interface,
    /// and optionally specific ranges of text within those elements.
    ///
    /// Using this modifier requires
    /// that the Rotor be attached to a `ScrollView`, or an Accessibility
    /// Element directly within a `ScrollView`, such as a `ForEach`.
    /// When the user navigates to entries from this Rotor, SkipUI will
    /// automatically scroll them into place as needed.
    ///
    /// In the following example, a Message application creates a Rotor
    /// allowing users to navigate to specifically the messages originating from
    /// VIPs.
    ///
    ///     // `messages` is a list of `Message`s that have a `subject` and a
    ///     // `uuid`. `vipMessages` is a filtered version of that list
    ///     // containing only messages from VIPs.
    ///     ScrollView {
    ///         LazyVStack {
    ///             ForEach(messages) { message in
    ///                 MessageView(message)
    ///             }
    ///         }
    ///     }
    ///     .accessibilityElement(children: .contain)
    ///     .accessibilityRotor("VIPs", entries: vipMessages,
    ///         id: \.uuid, label: \.subject)
    ///
    /// - Parameters:
    ///   - rotorLabel: Localized label identifying this Rotor to the user.
    ///   - entries: An array of values that will be used to generate
    ///     the entries of the Rotor.
    ///   - entryID: Key path on the entry type that can be used
    ///     to generate an identifier for the Entry. The identifiers
    ///     must match up with identifiers in `ForEach` or explicit `id` calls
    ///     within the `ScrollView`.
    ///   - entryLabel: Key path on the entry type that can be
    ///     used to get a user-visible label for every Rotor entry. This is used
    ///     on macOS when the user opens the list of entries for the Rotor.
    public func accessibilityRotor<EntryModel, ID>(_ rotorLabel: Text, entries: [EntryModel], entryID: KeyPath<EntryModel, ID>, entryLabel: KeyPath<EntryModel, String>) -> some View where ID : Hashable { return stubView() }


    /// Create an Accessibility Rotor replacing the specified system-provided
    /// Rotor.
    ///
    /// An Accessibility Rotor is a shortcut for Accessibility users to
    /// quickly navigate to specific elements of the user interface,
    /// and optionally specific ranges of text within those elements.
    ///
    /// Using this modifier requires
    /// that the Rotor be attached to a `ScrollView`, or an Accessibility
    /// Element directly within a `ScrollView`, such as a `ForEach`.
    ///
    /// In the following example, a Message application creates a Rotor
    /// allowing users to navigate to the headings in its vertical stack of
    /// messages.
    ///
    ///     // `messageListItems` is a list of `Identifiable` `MessageListItem`s
    ///     // that are either a `Message` or a heading, containing a `subject`.
    ///     // `headingMessageListItems` is a filtered list of
    ///     // `messageListItems` containing just the headings.
    ///     ScrollView {
    ///         LazyVStack {
    ///             ForEach(messageListItems) { messageListItem in
    ///                 switch messageListItem {
    ///                     case .heading(let subject):
    ///                         Text(subject)
    ///                     case .message(let message):
    ///                         MessageView(message)
    ///                 }
    ///             }
    ///         }
    ///     }
    ///     .accessibilityElement(children: .contain)
    ///     .accessibilityRotor(
    ///         .heading, entries: headingMessageListItems, label: \.subject)
    ///
    /// - Parameters:
    ///   - systemRotor: The system-provided Rotor that will be overridden
    ///     by this custom Rotor.
    ///   - entries: An array of identifiable values that will be
    ///     used to generate the entries of the Rotor. The identifiers
    ///     of the `Identifiable` values must match up with identifiers in a
    ///     `ForEach` or explicit `id` calls within the `ScrollView`.
    ///     When the user navigates to entries from this Rotor, SkipUI will
    ///     automatically scroll them into place as needed.
    ///   - entryLabel: Key path on the `Identifiable` type that can be
    ///     used to get a user-visible label for every Rotor entry. This is used
    ///     on macOS when the user opens the list of entries for the Rotor.
    public func accessibilityRotor<EntryModel>(_ systemRotor: AccessibilitySystemRotor, entries: [EntryModel], entryLabel: KeyPath<EntryModel, String>) -> some View where EntryModel : Identifiable { return stubView() }


    /// Create an Accessibility Rotor replacing the specified system-provided
    /// Rotor.
    ///
    /// An Accessibility Rotor is a shortcut for Accessibility users to
    /// quickly navigate to specific elements of the user interface,
    /// and optionally specific ranges of text within those elements.
    ///
    /// Using this modifier requires
    /// that the Rotor be attached to a `ScrollView`, or an Accessibility
    /// Element directly within a `ScrollView`, such as a `ForEach`.
    /// When the user navigates to entries from this Rotor, SkipUI will
    /// automatically scroll them into place as needed.
    ///
    /// In the following example, a Message application creates a Rotor
    /// allowing users to navigate to the headings in its vertical stack of
    /// messages.
    ///
    ///     // `messageListItems` is a list of `MessageListItem`s
    ///     // that are either a `Message` or a heading, containing a `subject`
    ///     // and a `uuid`.
    ///     // `headingMessageListItems` is a filtered list of
    ///     // `messageListItems` containing just the headings.
    ///     ScrollView {
    ///         LazyVStack {
    ///             ForEach(messageListItems) { messageListItem in
    ///                 switch messageListItem {
    ///                     case .heading(let subject):
    ///                         Text(subject)
    ///                     case .message(let message):
    ///                         MessageView(message)
    ///                 }
    ///             }
    ///         }
    ///     }
    ///     .accessibilityElement(children: .contain)
    ///     .accessibilityRotor(
    ///         .heading, entries: headingMessageListItems,
    ///         entryID: \.uuid, label: \.subject
    ///     )
    ///
    /// - Parameters:
    ///   - systemRotor: The system-provided Rotor that will be overridden
    ///     by this custom Rotor.
    ///   - entries: An array of values that will be used to generate
    ///     the entries of the Rotor.
    ///   - entryID: Key path on the entry type that can be used
    ///     to generate an identifier for the Entry. The identifiers
    ///     must match up with identifiers in `ForEach` or explicit `id` calls
    ///     within the `ScrollView`.
    ///   - entryLabel: Key path on the entry type that can be
    ///     used to get a user-visible label for every Rotor entry. This is used
    ///     on macOS when the user opens the list of entries for the Rotor.
    public func accessibilityRotor<EntryModel, ID>(_ systemRotor: AccessibilitySystemRotor, entries: [EntryModel], entryID: KeyPath<EntryModel, ID>, entryLabel: KeyPath<EntryModel, String>) -> some View where ID : Hashable { return stubView() }


    /// Create an Accessibility Rotor with the specified user-visible label
    /// and entries for each of the specified ranges. The Rotor will be attached
    /// to the current Accessibility element, and each entry will go the
    /// specified range of that element.
    ///
    /// An Accessibility Rotor is a shortcut for Accessibility users to
    /// quickly navigate to specific elements of the user interface,
    /// and optionally specific ranges of text within those elements.
    ///
    /// In the following example, a Message application adds a Rotor allowing
    /// the user to navigate through all the ranges of text containing
    /// email addresses.
    ///
    ///     extension Message {
    ///         // Ranges of special areas in the `content` text. Calculated
    ///         // when `content` is set and then cached so that we don't have
    ///         // to re-compute them.
    ///         var emailAddressRanges: [Range<String.Index>]
    ///     }
    ///
    ///     struct MessageContentView: View {
    ///         TextEditor(.constant(message.content))
    ///             .accessibilityRotor("Email Addresses",
    ///                 textRanges: message.emailAddressRanges)
    ///     }
    ///
    /// - Parameters:
    ///   - label: Localized label identifying this Rotor to the user.
    ///   - textRanges: An array of ranges that will be used to generate
    ///     the entries of the Rotor.
    public func accessibilityRotor(_ label: Text, textRanges: [Range<String.Index>]) -> some View { return stubView() }


    /// Create an Accessibility Rotor replacing the specified system-provided
    /// Rotor. The Rotor will be attached to the current Accessibility element,
    /// and each entry will go the specified range of that element.
    ///
    /// An Accessibility Rotor is a shortcut for Accessibility users to
    /// quickly navigate to specific elements of the user interface,
    /// and optionally specific ranges of text within those elements.
    ///
    /// In the following example, a Message application adds a Rotor allowing
    /// the user to navigate through all the ranges of text containing headings.
    ///
    ///     extension Message {
    ///         // Ranges of special areas in the `content` text. Calculated when
    ///         // `content` is set and then cached so that we don't have to
    ///         // re-compute them.
    ///         var headingRanges: [Range<String.Index>]
    ///     }
    ///
    ///     struct MessageContentView: View {
    ///         TextEditor(.constant(message.content))
    ///             .accessibilityRotor(
    ///                 .heading,
    ///                 textRanges: message.headingRanges
    ///             )
    ///     }
    ///
    /// - Parameters:
    ///   - systemRotor: The system-provided Rotor that will be overridden
    ///     by this custom Rotor.
    ///   - textRanges: An array of ranges that will be used to generate
    ///     the entries of the Rotor.
    public func accessibilityRotor(_ systemRotor: AccessibilitySystemRotor, textRanges: [Range<String.Index>]) -> some View { return stubView() }

}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
extension View {

    /// Create an Accessibility Rotor with the specified user-visible label,
    /// and entries generated from the content closure.
    ///
    /// An Accessibility Rotor is a shortcut for Accessibility users to
    /// quickly navigate to specific elements of the user interface,
    /// and optionally specific ranges of text within those elements.
    ///
    /// In the following example, a Message application creates a Rotor
    /// allowing users to navigate to specifically the messages originating from
    /// VIPs.
    ///
    ///     // `messages` is a list of `Identifiable` `Message`s.
    ///
    ///     ScrollView {
    ///         LazyVStack {
    ///             ForEach(messages) { message in
    ///                 MessageView(message)
    ///             }
    ///         }
    ///     }
    ///     .accessibilityElement(children: .contain)
    ///     .accessibilityRotor("VIPs") {
    ///         // Not all the MessageViews are generated at once, the model
    ///         // knows about all the messages.
    ///         ForEach(messages) { message in
    ///             // If the Message is from a VIP, make a Rotor entry for it.
    ///             if message.isVIP {
    ///                 AccessibilityRotorEntry(message.subject, id: message.id)
    ///             }
    ///         }
    ///     }
    ///
    /// - Parameters:
    ///   - labelKey: Localized label identifying this Rotor to the user.
    ///   - entries: Content used to generate Rotor entries. This can
    ///     include AccessibilityRotorEntry structs, as well as constructs such
    ///     as if and ForEach.
    public func accessibilityRotor<Content>(_ labelKey: LocalizedStringKey, @AccessibilityRotorContentBuilder entries: @escaping () -> Content) -> some View where Content : AccessibilityRotorContent { return stubView() }


    /// Create an Accessibility Rotor with the specified user-visible label,
    /// and entries generated from the content closure.
    ///
    /// An Accessibility Rotor is a shortcut for Accessibility users to
    /// quickly navigate to specific elements of the user interface,
    /// and optionally specific ranges of text within those elements.
    ///
    /// In the following example, a Message application creates a Rotor
    /// allowing users to navigate to specifically the messages originating from
    /// VIPs.
    ///
    ///     // `messages` is a list of `Identifiable` `Message`s.
    ///
    ///     ScrollView {
    ///         LazyVStack {
    ///             ForEach(messages) { message in
    ///                 MessageView(message)
    ///             }
    ///         }
    ///     }
    ///     .accessibilityElement(children: .contain)
    ///     .accessibilityRotor("VIPs") {
    ///         // Not all the MessageViews are generated at once, the model
    ///         // knows about all the messages.
    ///         ForEach(messages) { message in
    ///             // If the Message is from a VIP, make a Rotor entry for it.
    ///             if message.isVIP {
    ///                 AccessibilityRotorEntry(message.subject, id: message.id)
    ///             }
    ///         }
    ///     }
    ///
    /// - Parameters:
    ///   - label: Localized label identifying this Rotor to the user.
    ///   - entries: Content used to generate Rotor entries. This can
    ///     include AccessibilityRotorEntry structs, as well as constructs such
    ///     as if and ForEach.
    public func accessibilityRotor<L, Content>(_ label: L, @AccessibilityRotorContentBuilder entries: @escaping () -> Content) -> some View where L : StringProtocol, Content : AccessibilityRotorContent { return stubView() }


    /// Create an Accessibility Rotor with the specified user-visible label
    /// and entries.
    ///
    /// An Accessibility Rotor is a shortcut for Accessibility users to
    /// quickly navigate to specific elements of the user interface,
    /// and optionally specific ranges of text within those elements.
    ///
    /// Using this modifier requires
    /// that the Rotor be attached to a `ScrollView`, or an Accessibility
    /// Element directly within a `ScrollView`, such as a `ForEach`.
    ///
    /// In the following example, a Message application creates a Rotor
    /// allowing users to navigate to specifically the messages originating from
    /// VIPs.
    ///
    ///     // `messages` is a list of `Identifiable` `Message`s that have a
    ///     // `subject`.
    ///     // `vipMessages` is a filtered version of that list containing only
    ///     // messages from VIPs.
    ///
    ///     ScrollView {
    ///         LazyVStack {
    ///             ForEach(messages) { message in
    ///                 MessageView(message)
    ///             }
    ///         }
    ///     }
    ///     .accessibilityElement(children: .contain)
    ///     .accessibilityRotor("VIPs", entries: vipMessages,
    ///         entryLabel: \.subject)
    ///
    /// - Parameters:
    ///   - rotorLabelKey: Localized label identifying this Rotor to the user.
    ///   - entries: An array of identifiable values that will be
    ///     used to generate the entries of the Rotor. The identifiers
    ///     of the `Identifiable` values must match up with identifiers in a
    ///     `ForEach` or explicit `id` calls within the `ScrollView`.
    ///     When the user navigates to entries from this Rotor, SkipUI will
    ///     automatically scroll them into place as needed.
    ///   - entryLabel: Key path on the `Identifiable` type that can be
    ///     used to get a user-visible label for every Rotor entry. This is used
    ///     on macOS when the user opens the list of entries for the Rotor.
    public func accessibilityRotor<EntryModel>(_ rotorLabelKey: LocalizedStringKey, entries: [EntryModel], entryLabel: KeyPath<EntryModel, String>) -> some View where EntryModel : Identifiable { return stubView() }


    /// Create an Accessibility Rotor with the specified user-visible label
    /// and entries.
    ///
    /// An Accessibility Rotor is a shortcut for Accessibility users to
    /// quickly navigate to specific elements of the user interface,
    /// and optionally specific ranges of text within those elements.
    ///
    /// Using this modifier requires
    /// that the Rotor be attached to a `ScrollView`, or an Accessibility
    /// Element directly within a `ScrollView`, such as a `ForEach`.
    ///
    /// In the following example, a Message application creates a Rotor
    /// allowing users to navigate to specifically the messages originating from
    /// VIPs.
    ///
    ///     // `messages` is a list of `Identifiable` `Message`s that have a
    ///     // `subject`.
    ///     // `vipMesages` is a filtered version of that list containing only
    ///     // messages from VIPs.
    ///
    ///     ScrollView {
    ///         LazyVStack {
    ///             ForEach(messages) { message in
    ///                 MessageView(message)
    ///             }
    ///         }
    ///     }
    ///     .accessibilityElement(children: .contain)
    ///     .accessibilityRotor("VIPs", entries: vipMessages, label: \.subject)
    ///
    /// - Parameters:
    ///   - rotorLabel: Localized label identifying this Rotor to the user.
    ///   - entries: An array of identifiable values that will be
    ///     used to generate the entries of the Rotor. The identifiers
    ///     of the `Identifiable` values must match up with identifiers in a
    ///     `ForEach` or explicit `id` calls within the `ScrollView`.
    ///     When the user navigates to entries from this Rotor, SkipUI will
    ///     automatically scroll them into place as needed.
    ///   - entry: Key path on the `Identifiable` type that can be
    ///     used to get a user-visible label for every Rotor entry. This is used
    ///     on macOS when the user opens the list of entries for the Rotor.
    public func accessibilityRotor<L, EntryModel>(_ rotorLabel: L, entries: [EntryModel], entryLabel: KeyPath<EntryModel, String>) -> some View where L : StringProtocol, EntryModel : Identifiable { return stubView() }


    /// Create an Accessibility Rotor with the specified user-visible label
    /// and entries.
    ///
    /// An Accessibility Rotor is a shortcut for Accessibility users to
    /// quickly navigate to specific elements of the user interface,
    /// and optionally specific ranges of text within those elements.
    ///
    /// Using this modifier requires that the Rotor be attached to a
    /// `ScrollView`, or an Accessibility Element directly within a
    /// `ScrollView`, such as a `ForEach`. When the user navigates to entries
    /// from this Rotor, SkipUI will automatically scroll them into place as
    /// needed.
    ///
    /// In the following example, a Message application creates a Rotor
    /// allowing users to navigate to specifically the messages originating from
    /// VIPs.
    ///
    ///     // `messages` is a list of `Message`s that have a `subject` and a
    ///     // `uuid`. `vipMesages` is a filtered version of that list
    ///     // containing only messages from VIPs.
    ///     ScrollView {
    ///         LazyVStack {
    ///             ForEach(messages) { message in
    ///                 MessageView(message)
    ///             }
    ///         }
    ///     }
    ///     .accessibilityElement(children: .contain)
    ///     .accessibilityRotor("VIPs", entries: vipMessages,
    ///         entryID: \.uuid, entryLabel: \.subject)
    ///
    /// - Parameters:
    ///   - labelKey: Localized label identifying this Rotor to the user.
    ///   - entries: An array of values that will be used to generate
    ///     the entries of the Rotor.
    ///   - entryID: Key path on the entry type that can be used
    ///     to generate an identifier for the Entry. The identifiers
    ///     must match up with identifiers in `ForEach` or explicit `id` calls
    ///     within the `ScrollView`.
    ///   - entryLabel: Key path on the entry type that can be
    ///     used to get a user-visible label for every Rotor entry. This is used
    ///     on macOS when the user opens the list of entries for the Rotor.
    public func accessibilityRotor<EntryModel, ID>(_ rotorLabelKey: LocalizedStringKey, entries: [EntryModel], entryID: KeyPath<EntryModel, ID>, entryLabel: KeyPath<EntryModel, String>) -> some View where ID : Hashable { return stubView() }


    /// Create an Accessibility Rotor with the specified user-visible label
    /// and entries.
    ///
    /// An Accessibility Rotor is a shortcut for Accessibility users to
    /// quickly navigate to specific elements of the user interface,
    /// and optionally specific ranges of text within those elements.
    ///
    /// Using this modifier requires
    /// that the Rotor be attached to a `ScrollView`, or an Accessibility
    /// Element directly within a `ScrollView`, such as a `ForEach`.
    /// When the user navigates to entries from this Rotor, SkipUI will
    /// automatically scroll them into place as needed.
    ///
    /// In the following example, a Message application creates a Rotor
    /// allowing users to navigate to specifically the messages originating from
    /// VIPs.
    ///     // `messages` is a list of `Message`s that have a `subject` and a
    ///     // `uuid`. `vipMessages` is a filtered version of that list
    ///     // containing only messages from VIPs.
    ///     ScrollView {
    ///         LazyVStack {
    ///             ForEach(messages) { message in
    ///                 MessageView(message)
    ///             }
    ///         }
    ///     }
    ///     .accessibilityElement(children: .contain)
    ///     .accessibilityRotor("VIPs", entries: vipMessages,
    ///         id: \.uuid, label: \.subject)
    ///
    /// - Parameters:
    ///   - rotorLabel: Localized label identifying this Rotor to the user.
    ///   - entries: An array of values that will be used to generate
    ///     the entries of the Rotor.
    ///   - entryID: Key path on the entry type that can be used
    ///     to generate an identifier for the Entry. The identifiers
    ///     must match up with identifiers in `ForEach` or explicit `id` calls
    ///     within the `ScrollView`.
    ///   - entryLabel: Key path on the entry type that can be
    ///     used to get a user-visible label for every Rotor entry. This is used
    ///     on macOS when the user opens the list of entries for the Rotor.
    public func accessibilityRotor<L, EntryModel, ID>(_ rotorLabel: L, entries: [EntryModel], entryID: KeyPath<EntryModel, ID>, entryLabel: KeyPath<EntryModel, String>) -> some View where L : StringProtocol, ID : Hashable { return stubView() }


    /// Create an Accessibility Rotor with the specified user-visible label
    /// and entries for each of the specified ranges. The Rotor will be attached
    /// to the current Accessibility element, and each entry will go the
    /// specified range of that element.
    ///
    /// An Accessibility Rotor is a shortcut for Accessibility users to
    /// quickly navigate to specific elements of the user interface,
    /// and optionally specific ranges of text within those elements.
    ///
    /// In the following example, a Message application adds a Rotor allowing
    /// the user to navigate through all the ranges of text containing
    /// email addresses.
    ///
    ///     extension Message {
    ///         // Ranges of special areas in the `content` text. Calculated
    ///         // when `content` is set and then cached so that we don't have
    ///         // to re-compute them.
    ///         var emailAddressRanges: [Range<String.Index>]
    ///     }
    ///
    ///     struct MessageContentView: View {
    ///         TextEditor(.constant(message.content))
    ///             .accessibilityRotor("Email Addresses",
    ///                 textRanges: message.emailAddressRanges)
    ///     }
    ///
    /// - Parameters:
    ///   - labelKey: Localized label identifying this Rotor to the user.
    ///   - textRanges: An array of ranges that will be used to generate
    ///     the entries of the Rotor.
    public func accessibilityRotor(_ labelKey: LocalizedStringKey, textRanges: [Range<String.Index>]) -> some View { return stubView() }


    /// Create an Accessibility Rotor with the specified user-visible label
    /// and entries for each of the specified ranges. The Rotor will be attached
    /// to the current Accessibility element, and each entry will go the
    /// specified range of that element.
    ///
    /// An Accessibility Rotor is a shortcut for Accessibility users to
    /// quickly navigate to specific elements of the user interface,
    /// and optionally specific ranges of text within those elements.
    ///
    /// In the following example, a Message application adds a Rotor allowing
    /// the user to navigate through all the ranges of text containing
    /// email addresses.
    ///
    ///     extension Message {
    ///         // Ranges of special areas in the `content` text. Calculated
    ///         // when `content` is set and then cached so that we don't have
    ///         // to re-compute them.
    ///         var emailAddressRanges: [Range<String.Index>]
    ///     }
    ///
    ///     struct MessageContentView: View {
    ///         TextEditor(.constant(message.content))
    ///             .accessibilityRotor("Email Addresses",
    ///                 textRanges: message.emailAddressRanges)
    ///     }
    ///
    /// - Parameters:
    ///   - label: Localized label identifying this Rotor to the user.
    ///   - textRanges: An array of ranges that will be used to generate
    ///     the entries of the Rotor.
    public func accessibilityRotor<L>(_ label: L, textRanges: [Range<String.Index>]) -> some View where L : StringProtocol { return stubView() }

}

@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
extension View {

    /// Sets whether this view should ignore the system Smart Invert setting.
    ///
    /// Use this modifier to suppress Smart Invert in a view that shouldn't
    /// be inverted. Or pass an `active` argument of `false` to begin following
    /// the Smart Invert setting again when it was previously disabled.
    ///
    /// - Parameter active: A true value ignores the system Smart Invert
    ///   setting. A false value follows the system setting.
    @inlinable public func accessibilityIgnoresInvertColors(_ active: Bool = true) -> some View { return stubView() }

}



@available(macOS 13.0, iOS 16.0, tvOS 16.0, watchOS 9.0, *)
extension View {

    /// Adds an accessibility zoom action to the view. Actions allow
    /// assistive technologies, such as VoiceOver, to interact with the
    /// view by invoking the action.
    ///
    /// For example, this is how a zoom action is used to transform the scale
    /// of a shape which has a `MagnificationGesture`.
    ///
    ///     var body: some View {
    ///         Circle()
    ///             .scaleEffect(magnifyBy)
    ///             .gesture(magnification)
    ///             .accessibilityLabel("Circle Magnifier")
    ///             .accessibilityZoomAction { action in
    ///                 switch action.direction {
    ///                 case .zoomIn:
    ///                     magnifyBy += 0.5
    ///                 case .zoomOut:
    ///                      magnifyBy -= 0.5
    ///                 }
    ///             }
    ///     }
    ///
    public func accessibilityZoomAction(_ handler: @escaping (AccessibilityZoomGestureAction) -> Void) -> ModifiedContent<Self, AccessibilityAttachmentModifier> { fatalError() }
}

@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
extension View {

    /// Specifies whether to hide this view from system accessibility features.
    public func accessibilityHidden(_ hidden: Bool) -> ModifiedContent<Self, AccessibilityAttachmentModifier> { fatalError() }
}

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension View {

    /// Explicitly set whether this accessibility element is a direct touch
    /// area. Direct touch areas passthrough touch events to the app rather
    /// than being handled through an assistive technology, such as VoiceOver.
    /// The modifier accepts an optional `AccessibilityDirectTouchOptions`
    /// option set to customize the functionality of the direct touch area.
    ///
    /// For example, this is how a direct touch area would allow a VoiceOver
    /// user to interact with a view with a `rotationEffect` controlled by a
    /// `RotationGesture`. The direct touch area would require a user to
    /// activate the area before using the direct touch area.
    ///
    ///     var body: some View {
    ///         Rectangle()
    ///             .frame(width: 200, height: 200, alignment: .center)
    ///             .rotationEffect(angle)
    ///             .gesture(rotation)
    ///             .accessibilityDirectTouch(options: .requiresActivation)
    ///     }
    ///
    public func accessibilityDirectTouch(_ isDirectTouchArea: Bool = true, options: AccessibilityDirectTouchOptions = []) -> ModifiedContent<Self, AccessibilityAttachmentModifier> { fatalError() }
}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
extension View {

    /// Defines an explicit identifier tying an Accessibility element for this
    /// view to an entry in an Accessibility Rotor.
    ///
    /// Use this when creating an AccessibilityRotorEntry without a namespace
    /// does not allow SkipUI to automatically find and reveal the element,
    /// or when the Rotor entry should be associated with a sub-element of
    /// a complex view generated in a ForEach, for example.
    ///
    /// - Parameter id: An arbitrary hashable identifier. Pass this same value
    /// when initializing an AccessibilityRotorEntry.
    /// - Parameter namespace: A namespace created with `@Namespace()`. Pass this
    /// same namespace when initializing an `AccessibilityRotorEntry`.
    public func accessibilityRotorEntry<ID>(id: ID, in namespace: Namespace.ID) -> some View where ID : Hashable { return stubView() }

}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
extension View {

    /// Adds a descriptor to a View that represents a chart to make
    /// the chart's contents accessible to all users.
    ///
    /// Use this method to provide information about your chart view
    /// to allow VoiceOver and other assistive technology users to
    /// perceive and interact with your chart and its data.
    ///
    /// This may be applied to any View that represents a chart,
    /// including Image and custom-rendered chart views.
    ///
    /// The `accessibilityChartDescriptor` modifier can be applied to -any-
    /// view representing a chart, the simplest case being just an image of
    /// a chart. The implementation details of the view aren't important,
    /// only the fact that it represents a chart, and that the provided
    /// chart descriptor accurately describes the content of the chart.
    ///
    /// - Parameter chartDescriptor: The ``AXChartDescriptorRepresentable``
    ///  used to describe your chart and its data.
    ///
    /// Example usage:
    ///
    /// First define your `AXChartDescriptorRepresentable` type.
    ///
    ///     struct MyChartDescriptorRepresentable:
    ///     AXChartDescriptorRepresentable {
    ///         func makeChartDescriptor() -> AXChartDescriptor {
    ///             // Build and return your `AXChartDescriptor` here.
    ///         }
    ///
    ///         func updateChartDescriptor(_ descriptor: AXChartDescriptor) {
    ///             // Update your chart descriptor with any new values, or
    ///             // don't override if your chart doesn't have changing
    ///             // values.
    ///         }
    ///     }
    ///
    /// Then use the `accessibilityChartDescriptor` modifier to provide an
    /// instance of your `AXChartDescriptorRepresentable` type to the view
    /// representing your chart:
    ///
    ///     SomeChartView()
    ///         .accessibilityChartDescriptor(MyChartDescriptorRepresentable())
    public func accessibilityChartDescriptor<R>(_ representable: R) -> some View where R : AXChartDescriptorRepresentable { return stubView() }

}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
extension View {

    /// Modifies this view by binding its accessibility element's focus state to
    /// the given state value.
    ///
    /// - Parameters:
    ///   - binding: The state binding to register. When accessibility focus moves to the
    ///     accessibility element of the modified view, SkipUI sets the bound value to the corresponding
    ///     match value. If you set the state value programmatically to the matching value, then
    ///     accessibility focus moves to the accessibility element of the modified view. SkipUI sets
    ///     the value to `nil` if accessibility focus leaves the accessibility element associated with the
    ///     modified view, and programmatically setting the value to `nil` dismisses focus automatically.
    ///   - value: The value to match against when determining whether the
    ///     binding should change.
    /// - Returns: The modified view.
    public func accessibilityFocused<Value>(_ binding: AccessibilityFocusState<Value>.Binding, equals value: Value) -> some View where Value : Hashable { return stubView() }


    /// Modifies this view by binding its accessibility element's focus state
    /// to the given boolean state value.
    ///
    /// - Parameter condition: The accessibility focus state to bind. When
    ///     accessibility focus moves to the accessibility element of the
    ///     modified view, the focus value is set to `true`.
    ///     If the value is set to `true` programmatically, then accessibility
    ///     focus will move to accessibility element of the modified view.
    ///     The value will be set to `false` if accessibility focus leaves
    ///     the accessibility element of the modified view,
    ///     and accessibility focus will be dismissed automatically if the
    ///     value is set to `false` programmatically.
    ///
    /// - Returns: The modified view.
    public func accessibilityFocused(_ condition: AccessibilityFocusState<Bool>.Binding) -> some View { return stubView() }

}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
extension View {

    /// Explicitly set whether this Accessibility element responds to user
    /// interaction and would thus be interacted with by technologies such as
    /// Switch Control, Voice Control or Full Keyboard Access.
    ///
    /// If this is not set, the value is inferred from the traits of the
    /// Accessibility element, the presence of Accessibility actions on the
    /// element, or the presence of gestures on the element or containing views.
    public func accessibilityRespondsToUserInteraction(_ respondsToUserInteraction: Bool = true) -> ModifiedContent<Self, AccessibilityAttachmentModifier> { fatalError() }
}

@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
extension View {

    /// The activation point for an element is the location
    /// assistive technologies use to initiate gestures.
    ///
    /// Use this modifier to ensure that the activation point for a
    /// small element remains accurate even if you present a larger
    /// version of the element to VoiceOver.
    ///
    /// If an activation point is not provided, an activation point
    /// will be derrived from one of the accessibility elements
    /// decendents or from the center of the accessibility frame.
    public func accessibilityActivationPoint(_ activationPoint: CGPoint) -> ModifiedContent<Self, AccessibilityAttachmentModifier> { fatalError() }

    /// The activation point for an element is the location
    /// assistive technologies use to initiate gestures.
    ///
    /// Use this modifier to ensure that the activation point for a
    /// small element remains accurate even if you present a larger
    /// version of the element to VoiceOver.
    ///
    /// If an activation point is not provided, an activation point
    /// will be derrived from one of the accessibility elements
    /// decendents or from the center of the accessibility frame.
    public func accessibilityActivationPoint(_ activationPoint: UnitPoint) -> ModifiedContent<Self, AccessibilityAttachmentModifier> { fatalError() }
}

@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
extension View {

    /// Sets the sort priority order for this view's accessibility element,
    /// relative to other elements at the same level.
    ///
    /// Higher numbers are sorted first. The default sort priority is zero.
    public func accessibilitySortPriority(_ sortPriority: Double) -> ModifiedContent<Self, AccessibilityAttachmentModifier> { fatalError() }
}

extension View {

    /// Adds a custom large content view to be shown by
    /// the large content viewer.
    ///
    /// Rely on the large content viewer only in situations
    /// where items must remain small due to unavoidable
    /// design constraints. For example, buttons in a tab bar
    /// remain small to leave more room for the main app content.
    ///
    /// The following example shows how to add a custom large
    /// content view:
    ///
    ///     var body: some View {
    ///         Button(action: newMessage) {
    ///             Image(systemName: "plus")
    ///         }
    ///         .accessibilityShowsLargeContentViewer {
    ///             Label("New Message", systemImage: "plus")
    ///         }
    ///     }
    ///
    /// Don’t use the large content viewer as a replacement for proper
    /// Dynamic Type support. For example, Dynamic Type allows items
    /// in a list to grow or shrink vertically to accommodate the user’s preferred
    /// font size. Rely on the large content viewer only in situations where
    /// items must remain small due to unavoidable design constraints.
    ///
    /// For example, views that have their Dynamic Type size constrained
    /// with ``View/dynamicTypeSize(_:)-26aj0`` or
    /// ``View/dynamicTypeSize(_:)-26aj0`` may require a
    /// large content view.
    @available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
    public func accessibilityShowsLargeContentViewer<V>(@ViewBuilder _ largeContentView: () -> V) -> some View where V : View { return stubView() }


    /// Adds a default large content view to be shown by
    /// the large content viewer.
    ///
    /// Rely on the large content viewer only in situations
    /// where items must remain small due to unavoidable
    /// design constraints. For example, buttons in a tab bar
    /// remain small to leave more room for the main app content.
    ///
    /// The following example shows how to add a custom large
    /// content view:
    ///
    ///     var body: some View {
    ///         Button("New Message", action: newMessage)
    ///             .accessibilityShowsLargeContentViewer()
    ///     }
    ///
    /// Don’t use the large content viewer as a replacement for proper
    /// Dynamic Type support. For example, Dynamic Type allows items
    /// in a list to grow or shrink vertically to accommodate the user’s preferred
    /// font size. Rely on the large content viewer only in situations where
    /// items must remain small due to unavoidable design constraints.
    ///
    /// For example, views that have their Dynamic Type size constrained
    /// with ``View/dynamicTypeSize(_:)-26aj0`` or
    /// ``View/dynamicTypeSize(_:)-26aj0`` may require a
    /// large content view.
    @available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
    public func accessibilityShowsLargeContentViewer() -> some View { return stubView() }

}

@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
extension View {

    /// Adds the given traits to the view.
    public func accessibilityAddTraits(_ traits: AccessibilityTraits) -> ModifiedContent<Self, AccessibilityAttachmentModifier> { fatalError() }

    /// Removes the given traits from this view.
    public func accessibilityRemoveTraits(_ traits: AccessibilityTraits) -> ModifiedContent<Self, AccessibilityAttachmentModifier> { fatalError() }
}

extension View {

    /// Adds the given traits to the view.
    @available(iOS, introduced: 13.0, deprecated: 100000.0, renamed: "accessibilityAddTraits(_:)")
    @available(macOS, introduced: 10.15, deprecated: 100000.0, renamed: "accessibilityAddTraits(_:)")
    @available(tvOS, introduced: 13.0, deprecated: 100000.0, renamed: "accessibilityAddTraits(_:)")
    @available(watchOS, introduced: 6, deprecated: 100000.0, renamed: "accessibilityAddTraits(_:)")
    @available(xrOS, introduced: 1.0, deprecated: 100000.0, renamed: "accessibilityAddTraits(_:)")
    public func accessibility(addTraits traits: AccessibilityTraits) -> ModifiedContent<Self, AccessibilityAttachmentModifier> { fatalError() }

    /// Removes the given traits from this view.
    @available(iOS, introduced: 13.0, deprecated: 100000.0, renamed: "accessibilityRemoveTraits(_:)")
    @available(macOS, introduced: 10.15, deprecated: 100000.0, renamed: "accessibilityRemoveTraits(_:)")
    @available(tvOS, introduced: 13.0, deprecated: 100000.0, renamed: "accessibilityRemoveTraits(_:)")
    @available(watchOS, introduced: 6, deprecated: 100000.0, renamed: "accessibilityRemoveTraits(_:)")
    @available(xrOS, introduced: 1.0, deprecated: 100000.0, renamed: "accessibilityRemoveTraits(_:)")
    public func accessibility(removeTraits traits: AccessibilityTraits) -> ModifiedContent<Self, AccessibilityAttachmentModifier> { fatalError() }
}

@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
extension View {

    /// Links multiple accessibility elements so that the user can quickly
    /// navigate from one element to another, even when the elements are not near
    /// each other in the accessibility hierarchy.
    ///
    /// This can be useful to allow quickly jumping between content in a list and
    /// the same content shown in a detail view, for example. All elements marked
    /// with `accessibilityLinkedGroup` with the same namespace and identifier will be
    /// linked together.
    ///
    /// - Parameters:
    ///   - id: A hashable identifier used to separate sets of linked elements
    ///     within the same namespace. Elements with matching `namespace` and `id`
    ///     will be linked together.
    ///   - namespace: The namespace to use to organize linked accessibility
    ///     elements. All elements marked with `accessibilityLink` in this
    ///     namespace and with the specified `id` will be linked together.
    public func accessibilityLinkedGroup<ID>(id: ID, in namespace: Namespace.ID) -> some View where ID : Hashable { return stubView() }


    /// Pairs an accessibility element representing a label with the element
    /// for the matching content.
    ///
    /// Use `accessibilityLabeledPair` with a role of `AccessibilityLabeledPairRole.label`
    /// to identify the label, and a role of `AccessibilityLabeledPairRole.content`
    /// to identify the content.
    /// This improves the behavior of accessibility features such as VoiceOver
    /// when navigating such elements, allowing users to better understand the
    /// relationship between them.
    ///
    /// - Parameters:
    ///   - role: Determines whether this element should be used as the label
    ///     in the pair, or the content in the pair.
    ///   - id: The identifier for the label / content pair. Elements with
    ///     matching identifiers within the same namespace will be paired
    ///     together.
    ///   - namespace: The namespace used to organize label and content. Label
    ///     and content under the same namespace with matching identifiers will
    ///     be paired together.
    public func accessibilityLabeledPair<ID>(role: AccessibilityLabeledPairRole, id: ID, in namespace: Namespace.ID) -> some View where ID : Hashable { return stubView() }

}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
extension View {

    /// Replaces one or more accessibility elements for this view with new
    /// accessibility elements.
    ///
    /// You can make controls accessible by using a custom style. For example, a custom
    /// ``ToggleStyle`` that you create inherits the accessibility features of ``Toggle``
    /// automatically. When you can't use the parent view's accessibility elements, use the
    /// `accessibilityRepresentation(representation:)`
    /// modifier instead. This modifier replaces default accessibility elements with different accessibility
    /// elements that you provide. You use synthetic, non-visual accessibility elements to represent
    /// what the view displays.
    ///
    /// The example below makes a custom adjustable control accessible by explicitly
    /// defining the representation of its step increments using a ``Slider``:
    ///
    ///     var body: some View {
    ///         VStack {
    ///             SliderTrack(...) // Custom slider implementation.
    ///         }
    ///         .accessibilityRepresentation {
    ///             Slider(value: $value, in: 0...100) {
    ///                 Text("Label")
    ///             }
    ///         }
    ///     }
    ///
    /// SkipUI hides the view that you provide in the `representation` closure
    /// and makes it non-interactive. The framework uses it only to
    /// generate accessibility elements.
    ///
    /// - Parameter representation: A hidden view that the accessibility
    ///   system uses to generate accessibility elements.
    ///
    public func accessibilityRepresentation<V>(@ViewBuilder representation: () -> V) -> some View where V : View { return stubView() }


    /// Replaces the existing accessibility element's children with one or
    /// more new synthetic accessibility elements.
    ///
    /// Use this modifier to replace an existing element's children with one
    /// or more new synthetic accessibility elements you provide. This allows
    /// for synthetic, non-visual accessibility elements to be set as children
    /// of a visual accessibility element.
    ///
    /// SkipUI creates an accessibility container implicitly when needed.
    /// If an accessibility element already exists, the framework converts it
    /// into an accessibility container.
    ///
    /// In the  example below, a ``Canvas`` displays a graph of vertical bars that don't have any
    /// inherent accessibility elements. You make the view accessible by adding
    /// the ``accessibilityChildren(children:)`` modifier with views whose accessibility
    /// elements represent the values of each bar drawn in the canvas:
    ///
    ///     var body: some View {
    ///         Canvas { context, size in
    ///             // Draw Graph
    ///             for data in dataSet {
    ///                 let path = Path(
    ///                     roundedRect: CGRect(
    ///                         x: (size.width / CGFloat(dataSet.count))
    ///                         * CGFloat(data.week),
    ///                         y: 0,
    ///                         width: size.width / CGFloat(dataSet.count),
    ///                         height: CGFloat(data.lines),
    ///                     cornerRadius: 5)
    ///                 context.fill(path, with: .color(.blue))
    ///             }
    ///             // Draw Axis and Labels
    ///             ...
    ///         }
    ///         .accessibilityLabel("Lines of Code per Week")
    ///         .accessibilityChildren {
    ///             HStack {
    ///                 ForEach(dataSet) { data in
    ///                     RoundedRectangle(cornerRadius: 5)
    ///                         .accessibilityLabel("Week \(data.week)")
    ///                         .accessibilityValue("\(data.lines) lines")
    ///                 }
    ///             }
    ///         }
    ///     }
    ///
    /// SkipUI hides any views that you provide with the `children` parameter,
    /// then the framework uses the views to generate the accessibility elements.
    ///
    /// - Parameter children: A ``ViewBuilder`` that represents the replacement
    ///   child views the framework uses to generate accessibility elements.
    public func accessibilityChildren<V>(@ViewBuilder children: () -> V) -> some View where V : View { return stubView() }

}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
extension View {

    /// Sets an accessibility text content type.
    ///
    /// Use this modifier to set the content type of this accessibility
    /// element. Assistive technologies can use this property to choose
    /// an appropriate way to output the text. For example, when
    /// encountering a source coding context, VoiceOver could
    /// choose to speak all punctuation.
    ///
    /// The default content type ``AccessibilityTextContentType/plain``.
    ///
    /// - Parameter value: The accessibility content type from the available
    /// ``AccessibilityTextContentType`` options.
    public func accessibilityTextContentType(_ value: AccessibilityTextContentType) -> ModifiedContent<Self, AccessibilityAttachmentModifier> { fatalError() }

    /// Sets the accessibility level of this heading.
    ///
    /// Use this modifier to set the level of this heading in relation to other headings. The system speaks
    /// the level number of levels ``AccessibilityHeadingLevel/h1`` through
    ///  ``AccessibilityHeadingLevel/h6`` alongside the text.
    ///
    /// The default heading level if you don’t use this modifier
    /// is ``AccessibilityHeadingLevel/unspecified``.
    ///
    /// - Parameter level: The heading level to associate with this element
    ///   from the available ``AccessibilityHeadingLevel`` levels.
    public func accessibilityHeading(_ level: AccessibilityHeadingLevel) -> ModifiedContent<Self, AccessibilityAttachmentModifier> { fatalError() }
}


@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
extension View {

    /// Adds a textual description of the value that the view contains.
    ///
    /// Use this method to describe the value represented by a view, but only if that's different than the
    /// view's label. For example, for a slider that you label as "Volume" using accessibilityLabel(),
    /// you can provide the current volume setting, like "60%", using accessibilityValue().
    public func accessibilityValue(_ valueDescription: Text) -> ModifiedContent<Self, AccessibilityAttachmentModifier> { fatalError() }

    /// Adds a textual description of the value that the view contains.
    ///
    /// Use this method to describe the value represented by a view, but only if that's different than the
    /// view's label. For example, for a slider that you label as "Volume" using accessibilityLabel(),
    /// you can provide the current volume setting, like "60%", using accessibilityValue().
    public func accessibilityValue(_ valueKey: LocalizedStringKey) -> ModifiedContent<Self, AccessibilityAttachmentModifier> { fatalError() }

    /// Adds a textual description of the value that the view contains.
    ///
    /// Use this method to describe the value represented by a view, but only if that's different than the
    /// view's label. For example, for a slider that you label as "Volume" using accessibilityLabel(),
    /// you can provide the current volume setting, like "60%", using accessibilityValue().
    public func accessibilityValue<S>(_ value: S) -> ModifiedContent<Self, AccessibilityAttachmentModifier> where S : StringProtocol { fatalError() }
}

extension View {

    /// Adds a textual description of the value that the view contains.
    ///
    /// Use this method to describe the value represented by a view, but only if that's different than the
    /// view's label. For example, for a slider that you label as "Volume" using accessibility(label:),
    /// you can provide the current volume setting, like "60%", using accessibility(value:).
    @available(iOS, introduced: 13.0, deprecated: 100000.0, renamed: "accessibilityValue(_:)")
    @available(macOS, introduced: 10.15, deprecated: 100000.0, renamed: "accessibilityValue(_:)")
    @available(tvOS, introduced: 13.0, deprecated: 100000.0, renamed: "accessibilityValue(_:)")
    @available(watchOS, introduced: 6, deprecated: 100000.0, renamed: "accessibilityValue(_:)")
    @available(xrOS, introduced: 1.0, deprecated: 100000.0, renamed: "accessibilityValue(_:)")
    public func accessibility(value: Text) -> ModifiedContent<Self, AccessibilityAttachmentModifier> { fatalError() }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension View {

    /// Adds an accessibility scroll action to the view. Actions allow
    /// assistive technologies, such as the VoiceOver, to interact with the
    /// view by invoking the action.
    ///
    /// For example, this is how a scroll action to trigger
    /// a refresh could be added to a view.
    ///
    ///     var body: some View {
    ///         ScrollView {
    ///             ContentView()
    ///         }
    ///         .accessibilityScrollAction { edge in
    ///             if edge == .top {
    ///                 // Refresh content
    ///             }
    ///         }
    ///     }
    ///
    public func accessibilityScrollAction(_ handler: @escaping (Edge) -> Void) -> ModifiedContent<Self, AccessibilityAttachmentModifier> { fatalError() }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension View {

    /// Creates a new accessibility element, or modifies the
    /// ``AccessibilityChildBehavior`` of the existing accessibility element.
    ///
    /// See also:
    /// - ``AccessibilityChildBehavior/ignore``
    /// - ``AccessibilityChildBehavior/combine``
    /// - ``AccessibilityChildBehavior/contain``
    ///
    /// - Parameters:
    ///     -   children: The behavior to use when creating or
    ///     transforming an accessibility element.
    ///     The default is ``AccessibilityChildBehavior/ignore``
    public func accessibilityElement(children: AccessibilityChildBehavior = .ignore) -> some View { return stubView() }

}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension View {

    /// Adds an accessibility adjustable action to the view. Actions allow
    /// assistive technologies, such as the VoiceOver, to interact with the
    /// view by invoking the action.
    ///
    /// For example, this is how an adjustable action to navigate
    /// through pages could be added to a view.
    ///
    ///     var body: some View {
    ///         PageControl()
    ///             .accessibilityAdjustableAction { direction in
    ///                 switch direction {
    ///                 case .increment:
    ///                     // Go to next page
    ///                 case .decrement:
    ///                     // Go to previous page
    ///                 }
    ///             }
    ///     }
    ///
    public func accessibilityAdjustableAction(_ handler: @escaping (AccessibilityAdjustmentDirection) -> Void) -> ModifiedContent<Self, AccessibilityAttachmentModifier> { fatalError() }
}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
extension Never : AccessibilityRotorContent {
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension Never {

    /// The type for the internal content of this `AccessibilityRotorContent`.
    public typealias Body = NeverView

    /// The internal content of this `AccessibilityRotorContent`.
    public var body: Never { get { fatalError() } }
}

#endif
