// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

#if false
import struct CoreGraphics.CGPoint

/// A value with a modifier applied to it.
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
@frozen public struct ModifiedContent<Content, Modifier> {

    public typealias Body = NeverView

    /// The content that the modifier transforms into a new view or new
    /// view modifier.
    public var content: Content { get { fatalError() } }

    /// The view modifier.
    public var modifier: Modifier { get { fatalError() } }

    /// A structure that the defines the content and modifier needed to produce
    /// a new view or view modifier.
    ///
    /// If `content` is a ``View`` and `modifier` is a ``ViewModifier``, the
    /// result is a ``View``. If `content` and `modifier` are both view
    /// modifiers, then the result is a new ``ViewModifier`` combining them.
    ///
    /// - Parameters:
    ///     - content: The content that the modifier changes.
    ///     - modifier: The modifier to apply to the content.
    @inlinable public init(content: Content, modifier: Modifier) { fatalError() }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension ModifiedContent where Modifier == AccessibilityAttachmentModifier {

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
    public func accessibilityAction(_ actionKind: AccessibilityActionKind = .default, _ handler: @escaping () -> Void) -> ModifiedContent<Content, Modifier> { fatalError() }

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
    public func accessibilityAction(named name: Text, _ handler: @escaping () -> Void) -> ModifiedContent<Content, Modifier> { fatalError() }
}

@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
extension ModifiedContent where Modifier == AccessibilityAttachmentModifier {

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
    public func accessibilityAction(named nameKey: LocalizedStringKey, _ handler: @escaping () -> Void) -> ModifiedContent<Content, Modifier> { fatalError() }

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
    public func accessibilityAction<S>(named name: S, _ handler: @escaping () -> Void) -> ModifiedContent<Content, Modifier> where S : StringProtocol { fatalError() }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension ModifiedContent : Equatable where Content : Equatable, Modifier : Equatable {

    
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension ModifiedContent : View where Content : View, Modifier : ViewModifier {

    @MainActor public var body: ModifiedContent<Content, Modifier>.Body { get { fatalError() } }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension ModifiedContent : ViewModifier where Content : ViewModifier, Modifier : ViewModifier {
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension ModifiedContent : DynamicViewContent where Content : DynamicViewContent, Modifier : ViewModifier {

    /// The collection of underlying data.
    public var data: Content.Data { get { fatalError() } }

    /// The type of the underlying collection of data.
    public typealias Data = Content.Data
}

@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
extension ModifiedContent where Modifier == AccessibilityAttachmentModifier {

    /// Uses the string you specify to identify the view.
    ///
    /// Use this value for testing. It isn't visible to the user.
    public func accessibilityIdentifier(_ identifier: String) -> ModifiedContent<Content, Modifier> { fatalError() }
}

@available(macOS 13.0, iOS 16.0, tvOS 16.0, watchOS 9.0, *)
extension ModifiedContent where Modifier == AccessibilityAttachmentModifier {

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
    public func accessibilityZoomAction(_ handler: @escaping (AccessibilityZoomGestureAction) -> Void) -> ModifiedContent<Content, Modifier> { fatalError() }
}

@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
extension ModifiedContent where Modifier == AccessibilityAttachmentModifier {

    /// Adds a label to the view that describes its contents.
    ///
    /// Use this method to provide an accessibility label for a view that doesn't display text, like an icon.
    /// For example, you could use this method to label a button that plays music with the text "Play".
    /// Don't include text in the label that repeats information that users already have. For example,
    /// don't use the label "Play button" because a button already has a trait that identifies it as a button.
    public func accessibilityLabel(_ label: Text) -> ModifiedContent<Content, Modifier> { fatalError() }

    /// Adds a label to the view that describes its contents.
    ///
    /// Use this method to provide an accessibility label for a view that doesn't display text, like an icon.
    /// For example, you could use this method to label a button that plays music with the text "Play".
    /// Don't include text in the label that repeats information that users already have. For example,
    /// don't use the label "Play button" because a button already has a trait that identifies it as a button.
    public func accessibilityLabel(_ labelKey: LocalizedStringKey) -> ModifiedContent<Content, Modifier> { fatalError() }

    /// Adds a label to the view that describes its contents.
    ///
    /// Use this method to provide an accessibility label for a view that doesn't display text, like an icon.
    /// For example, you could use this method to label a button that plays music with the text "Play".
    /// Don't include text in the label that repeats information that users already have. For example,
    /// don't use the label "Play button" because a button already has a trait that identifies it as a button.
    public func accessibilityLabel<S>(_ label: S) -> ModifiedContent<Content, Modifier> where S : StringProtocol { fatalError() }
}

@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
extension ModifiedContent where Modifier == AccessibilityAttachmentModifier {

    /// Specifies whether to hide this view from system accessibility features.
    public func accessibilityHidden(_ hidden: Bool) -> ModifiedContent<Content, Modifier> { fatalError() }
}

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension ModifiedContent where Modifier == AccessibilityAttachmentModifier {

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
    public func accessibilityDirectTouch(_ isDirectTouchArea: Bool = true, options: AccessibilityDirectTouchOptions = []) -> ModifiedContent<Content, Modifier> { fatalError() }
}

//@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
//extension ModifiedContent : Scene where Content : Scene, Modifier : _SceneModifier {
//
//    /// The content and behavior of the scene.
//    ///
//    /// For any scene that you create, provide a computed `body` property that
//    /// defines the scene as a composition of other scenes. You can assemble a
//    /// scene from built-in scenes that SkipUI provides, as well as other
//    /// scenes that you've defined.
//    ///
//    /// Swift infers the scene's ``SkipUI/Scene/Body-swift.associatedtype``
//    /// associated type based on the contents of the `body` property.
//    @MainActor public var body: ModifiedContent<Content, Modifier>.Body { get { fatalError() } }
//}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
extension ModifiedContent where Modifier == AccessibilityAttachmentModifier {

    /// Explicitly set whether this Accessibility element responds to user
    /// interaction and would thus be interacted with by technologies such as
    /// Switch Control, Voice Control or Full Keyboard Access.
    ///
    /// If this is not set, the value is inferred from the traits of the
    /// Accessibility element, the presence of Accessibility actions on the
    /// element, or the presence of gestures on the element or containing views.
    public func accessibilityRespondsToUserInteraction(_ respondsToUserInteraction: Bool = true) -> ModifiedContent<Content, Modifier> { fatalError() }
}

@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
extension ModifiedContent where Modifier == AccessibilityAttachmentModifier {

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
    public func accessibilityActivationPoint(_ activationPoint: CGPoint) -> ModifiedContent<Content, Modifier> { fatalError() }

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
    public func accessibilityActivationPoint(_ activationPoint: UnitPoint) -> ModifiedContent<Content, Modifier> { fatalError() }
}

@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
extension ModifiedContent where Modifier == AccessibilityAttachmentModifier {

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
    public func accessibilityHint(_ hint: Text) -> ModifiedContent<Content, Modifier> { fatalError() }

    /// Sets alternate input labels with which users identify a view.
    ///
    /// If you don't specify any input labels, the user can still refer to the view using the accessibility
    /// label that you add with the accessibilityLabel() modifier. Provide labels in descending order
    /// of importance. Voice Control and Full Keyboard Access use the input labels.
    public func accessibilityInputLabels(_ inputLabels: [Text]) -> ModifiedContent<Content, Modifier> { fatalError() }
}

@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
extension ModifiedContent where Modifier == AccessibilityAttachmentModifier {

    /// Communicates to the user what happens after performing the view's
    /// action.
    ///
    /// Provide a hint in the form of a brief phrase, like "Purchases the item" or
    /// "Downloads the attachment".
    public func accessibilityHint(_ hintKey: LocalizedStringKey) -> ModifiedContent<Content, Modifier> { fatalError() }

    /// Communicates to the user what happens after performing the view's
    /// action.
    ///
    /// Provide a hint in the form of a brief phrase, like "Purchases the item" or
    /// "Downloads the attachment".
    public func accessibilityHint<S>(_ hint: S) -> ModifiedContent<Content, Modifier> where S : StringProtocol { fatalError() }

    /// Sets alternate input labels with which users identify a view.
    ///
    /// Provide labels in descending order of importance. Voice Control
    /// and Full Keyboard Access use the input labels.
    ///
    /// > Note: If you don't specify any input labels, the user can still
    ///   refer to the view using the accessibility label that you add with the
    ///   `accessibilityLabel()` modifier.
    public func accessibilityInputLabels(_ inputLabelKeys: [LocalizedStringKey]) -> ModifiedContent<Content, Modifier> { fatalError() }

    /// Sets alternate input labels with which users identify a view.
    ///
    /// Provide labels in descending order of importance. Voice Control
    /// and Full Keyboard Access use the input labels.
    ///
    /// > Note: If you don't specify any input labels, the user can still
    ///   refer to the view using the accessibility label that you add with the
    ///   `accessibilityLabel()` modifier.
    public func accessibilityInputLabels<S>(_ inputLabels: [S]) -> ModifiedContent<Content, Modifier> where S : StringProtocol { fatalError() }
}

extension ModifiedContent where Modifier == AccessibilityAttachmentModifier {

    /// Specifies whether to hide this view from system accessibility features.
    @available(iOS, introduced: 13.0, deprecated: 100000.0, renamed: "accessibilityHidden(_:)")
    @available(macOS, introduced: 10.15, deprecated: 100000.0, renamed: "accessibilityHidden(_:)")
    @available(tvOS, introduced: 13.0, deprecated: 100000.0, renamed: "accessibilityHidden(_:)")
    @available(watchOS, introduced: 6, deprecated: 100000.0, renamed: "accessibilityHidden(_:)")
    public func accessibility(hidden: Bool) -> ModifiedContent<Content, Modifier> { fatalError() }

    /// Adds a label to the view that describes its contents.
    ///
    /// Use this method to provide an accessibility label for a view that doesn't display text, like an icon.
    /// For example, you could use this method to label a button that plays music with the text "Play".
    /// Don't include text in the label that repeats information that users already have. For example,
    /// don't use the label "Play button" because a button already has a trait that identifies it as a button.
    @available(iOS, introduced: 13.0, deprecated: 100000.0, renamed: "accessibilityLabel(_:)")
    @available(macOS, introduced: 10.15, deprecated: 100000.0, renamed: "accessibilityLabel(_:)")
    @available(tvOS, introduced: 13.0, deprecated: 100000.0, renamed: "accessibilityLabel(_:)")
    @available(watchOS, introduced: 6, deprecated: 100000.0, renamed: "accessibilityLabel(_:)")
    public func accessibility(label: Text) -> ModifiedContent<Content, Modifier> { fatalError() }

    /// Communicates to the user what happens after performing the view's
    /// action.
    ///
    /// Provide a hint in the form of a brief phrase, like "Purchases the item" or
    /// "Downloads the attachment".
    @available(iOS, introduced: 13.0, deprecated: 100000.0, renamed: "accessibilityHint(_:)")
    @available(macOS, introduced: 10.15, deprecated: 100000.0, renamed: "accessibilityHint(_:)")
    @available(tvOS, introduced: 13.0, deprecated: 100000.0, renamed: "accessibilityHint(_:)")
    @available(watchOS, introduced: 6, deprecated: 100000.0, renamed: "accessibilityHint(_:)")
    public func accessibility(hint: Text) -> ModifiedContent<Content, Modifier> { fatalError() }

    /// Sets alternate input labels with which users identify a view.
    ///
    /// If you don't specify any input labels, the user can still refer to the view using the accessibility
    /// label that you add with the accessibilityLabel() modifier. Provide labels in descending order
    /// of importance. Voice Control and Full Keyboard Access use the input labels.
    @available(iOS, introduced: 13.0, deprecated: 100000.0, renamed: "accessibilityInputLabels(_:)")
    @available(macOS, introduced: 10.15, deprecated: 100000.0, renamed: "accessibilityInputLabels(_:)")
    @available(tvOS, introduced: 13.0, deprecated: 100000.0, renamed: "accessibilityInputLabels(_:)")
    @available(watchOS, introduced: 6, deprecated: 100000.0, renamed: "accessibilityInputLabels(_:)")
    public func accessibility(inputLabels: [Text]) -> ModifiedContent<Content, Modifier> { fatalError() }

    /// Uses the specified string to identify the view.
    ///
    /// Use this value for testing. It isn't visible to the user.
    @available(iOS, introduced: 13.0, deprecated: 100000.0, renamed: "accessibilityIdentifier(_:)")
    @available(macOS, introduced: 10.15, deprecated: 100000.0, renamed: "accessibilityIdentifier(_:)")
    @available(tvOS, introduced: 13.0, deprecated: 100000.0, renamed: "accessibilityIdentifier(_:)")
    @available(watchOS, introduced: 6, deprecated: 100000.0, renamed: "accessibilityIdentifier(_:)")
    public func accessibility(identifier: String) -> ModifiedContent<Content, Modifier> { fatalError() }

    @available(iOS, deprecated, introduced: 13.0)
    @available(macOS, deprecated, introduced: 10.15)
    @available(tvOS, deprecated, introduced: 13.0)
    @available(watchOS, deprecated, introduced: 6)
    public func accessibility(selectionIdentifier: AnyHashable) -> ModifiedContent<Content, Modifier> { fatalError() }

    /// Sets the sort priority order for this view's accessibility
    /// element, relative to other elements at the same level.
    ///
    /// Higher numbers are sorted first. The default sort priority is zero.
    @available(iOS, introduced: 13.0, deprecated: 100000.0, renamed: "accessibilitySortPriority(_:)")
    @available(macOS, introduced: 10.15, deprecated: 100000.0, renamed: "accessibilitySortPriority(_:)")
    @available(tvOS, introduced: 13.0, deprecated: 100000.0, renamed: "accessibilitySortPriority(_:)")
    @available(watchOS, introduced: 6, deprecated: 100000.0, renamed: "accessibilitySortPriority(_:)")
    public func accessibility(sortPriority: Double) -> ModifiedContent<Content, Modifier> { fatalError() }

    /// Specifies the point where activations occur in the view.
    @available(iOS, introduced: 13.0, deprecated: 100000.0, renamed: "accessibilityActivationPoint(_:)")
    @available(macOS, introduced: 10.15, deprecated: 100000.0, renamed: "accessibilityActivationPoint(_:)")
    @available(tvOS, introduced: 13.0, deprecated: 100000.0, renamed: "accessibilityActivationPoint(_:)")
    @available(watchOS, introduced: 6, deprecated: 100000.0, renamed: "accessibilityActivationPoint(_:)")
    public func accessibility(activationPoint: CGPoint) -> ModifiedContent<Content, Modifier> { fatalError() }

    /// Specifies the unit point where activations occur in the view.
    @available(iOS, introduced: 13.0, deprecated: 100000.0, renamed: "accessibilityActivationPoint(_:)")
    @available(macOS, introduced: 10.15, deprecated: 100000.0, renamed: "accessibilityActivationPoint(_:)")
    @available(tvOS, introduced: 13.0, deprecated: 100000.0, renamed: "accessibilityActivationPoint(_:)")
    @available(watchOS, introduced: 6, deprecated: 100000.0, renamed: "accessibilityActivationPoint(_:)")
    public func accessibility(activationPoint: UnitPoint) -> ModifiedContent<Content, Modifier> { fatalError() }
}

@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
extension ModifiedContent where Modifier == AccessibilityAttachmentModifier {

    /// Sets the sort priority order for this view's accessibility
    /// element, relative to other elements at the same level.
    ///
    /// Higher numbers are sorted first. The default sort priority is zero.
    public func accessibilitySortPriority(_ sortPriority: Double) -> ModifiedContent<Content, Modifier> { fatalError() }
}

@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
extension ModifiedContent where Modifier == AccessibilityAttachmentModifier {

    /// Adds the given traits to the view.
    public func accessibilityAddTraits(_ traits: AccessibilityTraits) -> ModifiedContent<Content, Modifier> { fatalError() }

    /// Removes the given traits from this view.
    public func accessibilityRemoveTraits(_ traits: AccessibilityTraits) -> ModifiedContent<Content, Modifier> { fatalError() }
}

extension ModifiedContent where Modifier == AccessibilityAttachmentModifier {

    /// Adds the given traits to the view.
    @available(iOS, introduced: 13.0, deprecated: 100000.0, renamed: "accessibilityAddTraits(_:)")
    @available(macOS, introduced: 10.15, deprecated: 100000.0, renamed: "accessibilityAddTraits(_:)")
    @available(tvOS, introduced: 13.0, deprecated: 100000.0, renamed: "accessibilityAddTraits(_:)")
    @available(watchOS, introduced: 6, deprecated: 100000.0, renamed: "accessibilityAddTraits(_:)")
    public func accessibility(addTraits traits: AccessibilityTraits) -> ModifiedContent<Content, Modifier> { fatalError() }

    /// Removes the given traits from this view.
    @available(iOS, introduced: 13.0, deprecated: 100000.0, renamed: "accessibilityRemoveTraits(_:)")
    @available(macOS, introduced: 10.15, deprecated: 100000.0, renamed: "accessibilityRemoveTraits(_:)")
    @available(tvOS, introduced: 13.0, deprecated: 100000.0, renamed: "accessibilityRemoveTraits(_:)")
    @available(watchOS, introduced: 6, deprecated: 100000.0, renamed: "accessibilityRemoveTraits(_:)")
    public func accessibility(removeTraits traits: AccessibilityTraits) -> ModifiedContent<Content, Modifier> { fatalError() }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension ModifiedContent where Modifier == AccessibilityAttachmentModifier {

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
    public func accessibilityScrollAction(_ handler: @escaping (Edge) -> Void) -> ModifiedContent<Content, Modifier> { fatalError() }
}

//@available(iOS 16.0, macOS 12.0, *)
//@available(tvOS, unavailable)
//@available(watchOS, unavailable)
//extension ModifiedContent : TableRowContent where Content : TableRowContent, Modifier : _TableRowContentModifier {
//
//    /// The type of value represented by this table row content.
//    public typealias TableRowValue = Content.TableRowValue
//
//    /// The type of content representing the body of this table row content.
//    public typealias TableRowBody = NeverView
//
//    /// The composition of content that comprise the table row content.
//    public var tableRowBody: Never { get { fatalError() } }
//}

//@available(iOS 16.0, macOS 12.0, *)
//@available(tvOS, unavailable)
//@available(watchOS, unavailable)
//extension ModifiedContent : DynamicTableRowContent where Content : DynamicTableRowContent, Modifier : _TableRowContentModifier {
//
//    /// The collection of underlying data.
//    public var data: Content.Data { get { fatalError() } }
//
//    /// The type of the underlying collection of data.
//    public typealias Data = Content.Data
//}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension ModifiedContent where Modifier == AccessibilityAttachmentModifier {

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
    public func accessibilityAdjustableAction(_ handler: @escaping (AccessibilityAdjustmentDirection) -> Void) -> ModifiedContent<Content, Modifier> { fatalError() }
}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
extension ModifiedContent where Modifier == AccessibilityAttachmentModifier {

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
    public func accessibilityTextContentType(_ textContentType: AccessibilityTextContentType) -> ModifiedContent<Content, Modifier> { fatalError() }

    /// Set the level of this heading.
    ///
    /// Use this modifier to set the level of this heading in relation to other headings. The system speaks
    ///  the level number of levels ``AccessibilityHeadingLevel/h1``
    ///  through ``AccessibilityHeadingLevel/h6`` alongside the text.
    ///
    /// The default heading level if you don’t use this modifier
    /// is ``AccessibilityHeadingLevel/unspecified``.
    ///
    /// - Parameter level: The heading level to associate with this element
    ///   from the available ``AccessibilityHeadingLevel`` levels.
    public func accessibilityHeading(_ level: AccessibilityHeadingLevel) -> ModifiedContent<Content, Modifier> { fatalError() }
}

@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
extension ModifiedContent where Modifier == AccessibilityAttachmentModifier {

    /// Adds a textual description of the value that the view contains.
    ///
    /// Use this method to describe the value represented by a view, but only if that's different than the
    /// view's label. For example, for a slider that you label as "Volume" using accessibilityLabel(),
    /// you can provide the current volume setting, like "60%", using accessibilityValue().
    public func accessibilityValue(_ valueDescription: Text) -> ModifiedContent<Content, Modifier> { fatalError() }
}

@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
extension ModifiedContent where Modifier == AccessibilityAttachmentModifier {

    /// Adds a textual description of the value that the view contains.
    ///
    /// Use this method to describe the value represented by a view, but only if that's different than the
    /// view's label. For example, for a slider that you label as "Volume" using accessibilityLabel(),
    /// you can provide the current volume setting, like "60%", using accessibilityValue().
    public func accessibilityValue(_ valueKey: LocalizedStringKey) -> ModifiedContent<Content, Modifier> { fatalError() }

    /// Adds a textual description of the value that the view contains.
    ///
    /// Use this method to describe the value represented by a view, but only if that's different than the
    /// view's label. For example, for a slider that you label as "Volume" using accessibilityLabel(),
    /// you can provide the current volume setting, like "60%", using accessibilityValue().
    public func accessibilityValue<S>(_ value: S) -> ModifiedContent<Content, Modifier> where S : StringProtocol { fatalError() }
}

extension ModifiedContent where Modifier == AccessibilityAttachmentModifier {

    /// Adds a textual description of the value that the view contains.
    ///
    /// Use this method to describe the value represented by a view, but only if that's different than the
    /// view's label. For example, for a slider that you label as "Volume" using accessibility(label:),
    /// you can provide the current volume setting, like "60%", using accessibility(value:).
    @available(iOS, introduced: 13.0, deprecated: 100000.0, renamed: "accessibilityValue(_:)")
    @available(macOS, introduced: 10.15, deprecated: 100000.0, renamed: "accessibilityValue(_:)")
    @available(tvOS, introduced: 13.0, deprecated: 100000.0, renamed: "accessibilityValue(_:)")
    @available(watchOS, introduced: 6, deprecated: 100000.0, renamed: "accessibilityValue(_:)")
    public func accessibility(value: Text) -> ModifiedContent<Content, Modifier> { fatalError() }
}
#endif
