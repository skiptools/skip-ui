// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

#if !SKIP

// TODO: Process for use in SkipUI. Move extensions to the appropriate specific file (e.g. .buttonStyle is in Button.swift) or to View.swift

import struct CoreGraphics.CGAffineTransform
import struct CoreGraphics.CGFloat
import struct CoreGraphics.CGPoint
import struct CoreGraphics.CGSize
import struct Foundation.URL
import struct Foundation.Locale

import class Foundation.FileWrapper

import protocol Combine.ObservableObject

@available(iOS 17.0, macOS 14.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
@available(xrOS, unavailable)
extension View {

    /// Inserts an inspector at the applied position in the view hierarchy.
    ///
    /// Apply this modifier to declare an inspector with a context-dependent
    /// presentation. For example, an inspector can present as a trailing
    /// column in a horizontally regular size class, but adapt to a sheet in a
    /// horizontally compact size class.
    ///
    ///     struct ShapeEditor: View {
    ///         @State var presented: Bool = false
    ///         var body: some View {
    ///             MyEditorView()
    ///                 .inspector(isPresented: $presented) {
    ///                     TextTraitsInspectorView()
    ///                 }
    ///         }
    ///     }
    ///
    /// - Parameters:
    ///   - isPresented: A binding to `Bool` controlling the presented state.
    ///   - content: The inspector content.
    ///
    /// - Note: Trailing column inspectors have their presentation state
    /// restored by the framework.
    public func inspector<V>(isPresented: Binding<Bool>, @ViewBuilder content: () -> V) -> some View where V : View { return stubView() }


    /// Sets a flexible, preferred width for the inspector in a trailing-column
    /// presentation.
    ///
    /// Apply this modifier on the content of a
    /// ``View/inspector(isPresented:content:)`` to specify a preferred flexible
    /// width for the column. Use ``View/inspectorColumnWidth(_:)`` if you need
    /// to specify a fixed width.
    ///
    /// The following example shows an editor interface with an inspector, which
    /// when presented as a trailing-column, has a preferred width of 225
    /// points, maximum of 400, and a minimum of 150 at which point it will
    /// collapse, if allowed.
    ///
    ///     MyEditorView()
    ///         .inspector {
    ///             TextTraitsInspectorView()
    ///                 .inspectorColumnWidth(min: 150, ideal: 225, max: 400)
    ///         }
    ///
    /// Only some platforms enable flexible inspector columns. If
    /// you specify a width that the current presentation environment doesn't
    /// support, SkipUI may use a different width for your column.
    /// - Parameters:
    ///   - min: The minimum allowed width for the trailing column inspector
    ///   - ideal: The initial width of the inspector in the absence of state
    ///   restoration. `ideal` influences the resulting width on macOS when a
    ///   user double-clicks the divider on the leading edge of the inspector.
    ///   clicks a divider to readjust
    ///   - max: The maximum allowed width for the trailing column inspector
    public func inspectorColumnWidth(min: CGFloat? = nil, ideal: CGFloat, max: CGFloat? = nil) -> some View { return stubView() }


    /// Sets a fixed, preferred width for the inspector containing this view
    /// when presented as a trailing column.
    ///
    /// Apply this modifier on the content of a
    /// ``View/inspector(isPresented:content:)`` to specify a fixed preferred
    /// width for the trailing column. Use
    /// ``View/navigationSplitViewColumnWidth(min:ideal:max:)`` if
    /// you need to specify a flexible width.
    ///
    /// The following example shows an editor interface with an inspector, which
    /// when presented as a trailing-column, has a fixed width of 225
    /// points. The example also uses ``View/interactiveDismissDisabled(_:)`` to
    /// prevent the inspector from being collapsed by user action like dragging
    /// a divider.
    ///
    ///     MyEditorView()
    ///         .inspector {
    ///             TextTraitsInspectorView()
    ///                 .inspectorColumnWidth(225)
    ///                 .interactiveDismissDisabled()
    ///         }
    ///
    /// - Parameter width: The preferred fixed width for the inspector if
    /// presented as a trailing column.
    /// - Note: A fixed width does not prevent the user collapsing the
    /// inspector on macOS. See ``View/interactiveDismissDisabled(_:)``.
    public func inspectorColumnWidth(_ width: CGFloat) -> some View { return stubView() }

}

extension View {

    /// Sets the rename action in the environment to update focus state.
    ///
    /// Use this modifier in conjunction with the ``RenameButton`` to implement
    /// standard rename interactions. A rename button receives its action
    /// from the environment. Use this modifier to customize the action
    /// provided to the rename button.
    ///
    ///     struct RowView: View {
    ///         @State private var text = ""
    ///         @FocusState private var isFocused: Bool
    ///
    ///         var body: some View {
    ///             TextField(text: $item.name) {
    ///                 Text("Prompt")
    ///             }
    ///             .focused($isFocused)
    ///             .contextMenu {
    ///                 RenameButton()
    ///                 // ... your own custom actions
    ///             }
    ///             .renameAction($isFocused)
    ///     }
    ///
    /// When someone taps the rename button in the context menu, the rename
    /// action focuses the text field by setting the `isFocused`
    /// property to true.
    ///
    /// - Parameter isFocused: The focus binding to update when
    ///   activating the rename action.
    ///
    /// - Returns: A view that has the specified rename action.
    @available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
    public func renameAction(_ isFocused: FocusState<Bool>.Binding) -> some View { return stubView() }


    /// Sets a closure to run for the rename action.
    ///
    /// Use this modifier in conjunction with the ``RenameButton`` to implement
    /// standard rename interactions. A rename button receives its action
    /// from the environment. Use this modifier to customize the action
    /// provided to the rename button.
    ///
    ///     struct RowView: View {
    ///         @State private var text = ""
    ///         @FocusState private var isFocused: Bool
    ///
    ///         var body: some View {
    ///             TextField(text: $item.name) {
    ///                 Text("Prompt")
    ///             }
    ///             .focused($isFocused)
    ///             .contextMenu {
    ///                 RenameButton()
    ///                 // ... your own custom actions
    ///             }
    ///             .renameAction { isFocused = true }
    ///     }
    ///
    /// When the user taps the rename button in the context menu, the rename
    /// action focuses the text field by setting the `isFocused`
    /// property to true.
    ///
    /// - Parameter action: A closure to run when renaming.
    ///
    /// - Returns: A view that has the specified rename action.
    @available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
    public func renameAction(_ action: @escaping () -> Void) -> some View { return stubView() }

}

@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
extension View {

    /// Defines a group of views with synchronized geometry using an
    /// identifier and namespace that you provide.
    ///
    /// This method sets the geometry of each view in the group from the
    /// inserted view with `isSource = true` (known as the "source" view),
    /// updating the values marked by `properties`.
    ///
    /// If inserting a view in the same transaction that another view
    /// with the same key is removed, the system will interpolate their
    /// frame rectangles in window space to make it appear that there
    /// is a single view moving from its old position to its new
    /// position. The usual transition mechanisms define how each of
    /// the two views is rendered during the transition (e.g. fade
    /// in/out, scale, etc), the `matchedGeometryEffect()` modifier
    /// only arranges for the geometry of the views to be linked, not
    /// their rendering.
    ///
    /// If the number of currently-inserted views in the group with
    /// `isSource = true` is not exactly one results are undefined, due
    /// to it not being clear which is the source view.
    ///
    /// - Parameters:
    ///   - id: The identifier, often derived from the identifier of
    ///     the data being displayed by the view.
    ///   - namespace: The namespace in which defines the `id`. New
    ///     namespaces are created by adding an `@Namespace` variable
    ///     to a ``View`` type and reading its value in the view's body
    ///     method.
    ///   - properties: The properties to copy from the source view.
    ///   - anchor: The relative location in the view used to produce
    ///     its shared position value.
    ///   - isSource: True if the view should be used as the source of
    ///     geometry for other views in the group.
    ///
    /// - Returns: A new view that defines an entry in the global
    ///   database of views synchronizing their geometry.
    ///
    public func matchedGeometryEffect<ID>(id: ID, in namespace: Namespace.ID, properties: MatchedGeometryProperties = .frame, anchor: UnitPoint = .center, isSource: Bool = true) -> some View where ID : Hashable { return stubView() }

}



@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
extension View {

    /// Sets whether VoiceOver should always speak all punctuation in the text view.
    ///
    /// Use this modifier to control whether the system speaks punctuation characters
    /// in the text. You might use this for code or other text where the punctuation is relevant, or where
    /// you want VoiceOver to speak a verbatim transcription of the text you provide. For example,
    /// given the text:
    ///
    ///     Text("All the world's a stage, " +
    ///          "And all the men and women merely players;")
    ///          .speechAlwaysIncludesPunctuation()
    ///
    /// VoiceOver would speak "All the world apostrophe s a stage comma and all the men
    /// and women merely players semicolon".
    ///
    /// By default, VoiceOver voices punctuation based on surrounding context.
    ///
    /// - Parameter value: A Boolean value that you set to `true` if
    ///   VoiceOver should speak all punctuation in the text. Defaults to `true`.
    public func speechAlwaysIncludesPunctuation(_ value: Bool = true) -> some View { return stubView() }


    /// Sets whether VoiceOver should speak the contents of the text view character by character.
    ///
    /// Use this modifier when you want VoiceOver to speak text as individual letters,
    /// character by character. This is important for text that is not meant to be spoken together, like:
    /// - An acronym that isn't a word, like APPL, spoken as "A-P-P-L".
    /// - A number representing a series of digits, like 25, spoken as "two-five" rather than "twenty-five".
    ///
    /// - Parameter value: A Boolean value that when `true` indicates
    ///    VoiceOver should speak text as individual characters. Defaults
    ///    to `true`.
    public func speechSpellsOutCharacters(_ value: Bool = true) -> some View { return stubView() }


    /// Raises or lowers the pitch of spoken text.
    ///
    /// Use this modifier when you want to change the pitch of spoken text.
    /// The value indicates how much higher or lower to change the pitch.
    ///
    /// - Parameter value: The amount to raise or lower the pitch.
    ///   Values between `-1` and `0` result in a lower pitch while
    ///   values between `0` and `1` result in a higher pitch.
    ///   The method clamps values to the range `-1` to `1`.
    public func speechAdjustedPitch(_ value: Double) -> some View { return stubView() }


    /// Controls whether to queue pending announcements behind existing speech rather than
    /// interrupting speech in progress.
    ///
    /// Use this modifier when you want affect the order in which the
    /// accessibility system delivers spoken text. Announcements can
    /// occur automatically when the label or value of an accessibility
    /// element changes.
    ///
    /// - Parameter value: A Boolean value that determines if VoiceOver speaks
    ///   changes to text immediately or enqueues them behind existing speech.
    ///   Defaults to `true`.
    public func speechAnnouncementsQueued(_ value: Bool = true) -> some View { return stubView() }

}

@available(iOS 16.0, *)
@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension View {

    /// Programmatically presents the find and replace interface for text
    /// editor views.
    ///
    /// Add this modifier to a ``TextEditor``, or to a view hierarchy that
    /// contains at least one text editor, to control the presentation of
    /// the find and replace interface. When you set the `isPresented` binding
    /// to `true`, the system shows the interface, and when you set it to
    /// `false`, the system hides the interface. The following example shows
    /// and hides the interface based on the state of a toolbar button:
    ///
    ///     TextEditor(text: $text)
    ///         .findNavigator(isPresented: $isPresented)
    ///         .toolbar {
    ///             Toggle(isOn: $isPresented) {
    ///                 Label("Find", systemImage: "magnifyingglass")
    ///             }
    ///         }
    ///
    /// The find and replace interface allows people to search for instances
    /// of a specified string in the text editor, and optionally to replace
    /// instances of the search string with another string. They can also
    /// show and hide the interface using built-in controls, like menus and
    /// keyboard shortcuts. SkipUI updates `isPresented` to reflect the
    /// users's actions.
    ///
    /// If the text editor view isn't currently in focus, the system still
    /// presents the find and replace interface when you set `isPresented`
    /// to `true`. If the view hierarchy contains multiple editors, the one
    /// that shows the find and replace interface is nondeterministic.
    ///
    /// You can disable the find and replace interface for a text editor by
    /// applying the ``View/findDisabled(_:)`` modifier to the editor. If you
    /// do that, setting this modifier's `isPresented` binding to `true` has
    /// no effect, but only if the disabling modifier appears closer to the
    /// text editor, like this:
    ///
    ///     TextEditor(text: $text)
    ///         .findDisabled(isDisabled)
    ///         .findNavigator(isPresented: $isPresented)
    ///
    /// - Parameter isPresented: A binding to a Boolean value that controls the
    ///   presentation of the find and replace interface.
    ///
    /// - Returns: A view that presents the find and replace interface when
    ///   `isPresented` is `true`.
    public func findNavigator(isPresented: Binding<Bool>) -> some View { return stubView() }


    /// Prevents find and replace operations in a text editor.
    ///
    /// Add this modifier to ensure that people can't activate the find
    /// and replace interface for a ``TextEditor``:
    ///
    ///     TextEditor(text: $text)
    ///         .findDisabled()
    ///
    /// When you disable the find operation, you also implicitly disable the
    /// replace operation. If you want to only disable replace, use
    /// ``View/replaceDisabled(_:)`` instead.
    ///
    /// Using this modifer also prevents programmatic find and replace
    /// interface presentation using the ``View/findNavigator(isPresented:)``
    /// method. Be sure to place the disabling modifier closer to the text
    /// editor for this to work:
    ///
    ///     TextEditor(text: $text)
    ///         .findDisabled(isDisabled)
    ///         .findNavigator(isPresented: $isPresented)
    ///
    /// If you apply this modifer at multiple levels of a view hierarchy,
    /// the call closest to the text editor takes precedence. For example,
    /// people can activate find and replace for the first text editor
    /// in the following example, but not the second:
    ///
    ///     VStack {
    ///         TextEditor(text: $text1)
    ///             .findDisabled(false)
    ///         TextEditor(text: $text2)
    ///     }
    ///     .findDisabled(true)
    ///
    /// - Parameter isDisabled: A Boolean value that indicates whether to
    ///   disable the find and replace interface for a text editor.
    ///
    /// - Returns: A view that disables the find and replace interface.
    public func findDisabled(_ isDisabled: Bool = true) -> some View { return stubView() }


    /// Prevents replace operations in a text editor.
    ///
    /// Add this modifier to ensure that people can't activate the replace
    /// feature of a find and replace interface for a ``TextEditor``:
    ///
    ///     TextEditor(text: $text)
    ///         .replaceDisabled()
    ///
    /// If you want to disable both find and replace, use the
    /// ``View/findDisabled(_:)`` modifier instead.
    ///
    /// Using this modifer also disables the replace feature of a find and
    /// replace interface that you present programmatically using the
    /// ``View/findNavigator(isPresented:)`` method. Be sure to place the
    /// disabling modifier closer to the text editor for this to work:
    ///
    ///     TextEditor(text: $text)
    ///         .replaceDisabled(isDisabled)
    ///         .findNavigator(isPresented: $isPresented)
    ///
    /// If you apply this modifer at multiple levels of a view hierarchy,
    /// the call closest to the text editor takes precedence. For example,
    /// people can activate find and replace for the first text editor
    /// in the following example, but only find for the second:
    ///
    ///     VStack {
    ///         TextEditor(text: $text1)
    ///             .replaceDisabled(false)
    ///         TextEditor(text: $text2)
    ///     }
    ///     .replaceDisabled(true)
    ///
    /// - Parameter isDisabled: A Boolean value that indicates whether text
    ///   replacement in the find and replace interface is disabled.
    ///
    /// - Returns: A view that disables the replace feature of a find and
    ///   replace interface.
    public func replaceDisabled(_ isDisabled: Bool = true) -> some View { return stubView() }

}

@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
extension View {

    /// Sets an explicit type select equivalent text in a collection, such as
    /// a list or table.
    ///
    /// By default, a type select equivalent is automatically derived from any
    /// `Text` or `TextField` content in a list or table. In the below example,
    /// type select can be used to select a person, even though no explicit
    /// value has been set.
    ///
    ///     List(people, selection: $selectedPersonID) { person in
    ///         Label {
    ///             Text(person.name)
    ///         } icon: {
    ///             person.avatar
    ///         }
    ///     }
    ///
    /// An explicit type select value should be set when there is no textual
    /// content or when a different value is desired compared to what's
    /// displayed in the view. Explicit values also provide a more performant
    /// for complex view types. In the below example, type select is explicitly
    /// set to allow selection of views that otherwise only display an image.
    ///
    ///     List(people, selection: $selectedPersonID) { person in
    ///         person.avatar
    ///             .accessibilityLabel(person.name)
    ///             .typeSelectEquivalent(person.name)
    ///     }
    ///
    /// Setting an empty string value disables text selection for the view,
    /// and a value of `nil` results in the view using its default value.
    ///
    /// - Parameter text: The explicit text value to use as a type select
    /// equivalent for a view in a collection.
    public func typeSelectEquivalent(_ text: Text?) -> some View { return stubView() }


    /// Sets an explicit type select equivalent text in a collection, such as
    /// a list or table.
    ///
    /// By default, a type select equivalent is automatically derived from any
    /// `Text` or `TextField` content in a list or table. In the below example,
    /// type select can be used to select a person, even though no explicit
    /// value has been set.
    ///
    ///     List(people, selection: $selectedPersonID) { person in
    ///         Label {
    ///             Text(person.name)
    ///         } icon: {
    ///             person.avatar
    ///         }
    ///     }
    ///
    /// An explicit type select value should be set when there is no textual
    /// content or when a different value is desired compared to what's
    /// displayed in the view. Explicit values also provide a more performant
    /// for complex view types. In the below example, type select is explicitly
    /// set to allow selection of views that otherwise only display an image.
    ///
    ///     List(people, selection: $selectedPersonID) { person in
    ///         person.avatar
    ///             .accessibilityLabel(person.name)
    ///             .typeSelectEquivalent(person.name)
    ///     }
    ///
    /// Setting an empty string value disables text selection for the view,
    /// and a value of `nil` results in the view using its default value.
    ///
    /// - Parameter stringKey: The localized string key to use as a type select
    /// equivalent for a view in a collection.
    //@_backDeploy(before: iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0)
    public func typeSelectEquivalent(_ stringKey: LocalizedStringKey) -> some View { return stubView() }


    /// Sets an explicit type select equivalent text in a collection, such as
    /// a list or table.
    ///
    /// By default, a type select equivalent is automatically derived from any
    /// `Text` or `TextField` content in a list or table. In the below example,
    /// type select can be used to select a person, even though no explicit
    /// value has been set.
    ///
    ///     List(people, selection: $selectedPersonID) { person in
    ///         Label {
    ///             Text(person.name)
    ///         } icon: {
    ///             person.avatar
    ///         }
    ///     }
    ///
    /// An explicit type select value should be set when there is no textual
    /// content or when a different value is desired compared to what's
    /// displayed in the view. Explicit values also provide a more performant
    /// for complex view types. In the below example, type select is explicitly
    /// set to allow selection of views that otherwise only display an image.
    ///
    ///     List(people, selection: $selectedPersonID) { person in
    ///         person.avatar
    ///             .accessibilityLabel(person.name)
    ///             .typeSelectEquivalent(person.name)
    ///     }
    ///
    /// Setting an empty string value disables text selection for the view,
    /// and a value of `nil` results in the view using its default value.
    ///
    /// - Parameter string: The string to use as a type select equivalent for a
    /// view in a collection.
    //@_backDeploy(before: iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0)
    public func typeSelectEquivalent<S>(_ string: S) -> some View where S : StringProtocol { return stubView() }

}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
extension View {

    /// Sets the content shape for this view.
    ///
    /// The content shape has a variety of uses. You can control the kind of the
    /// content shape by specifying one in `kind`. For example, the
    /// following example only sets the focus ring shape of the view, without
    /// affecting its shape for hit-testing:
    ///
    ///     MyFocusableView()
    ///         .contentShape(.focusEffect, Circle())
    ///
    /// - Parameters:
    ///   - kind: The kinds to apply to this content shape.
    ///   - shape: The shape to use.
    ///   - eoFill: A Boolean that indicates whether the shape is interpreted
    ///     with the even-odd winding number rule.
    ///
    /// - Returns: A view that uses the given shape for the specified kind.
    public func contentShape<S>(_ kind: ContentShapeKinds, _ shape: S, eoFill: Bool = false) -> some View where S : Shape { return stubView() }

}

@available(iOS 15.0, macOS 12.0, tvOS 17.0, *)
@available(watchOS, unavailable)
extension View {

    /// Sets the style for control groups within this view.
    ///
    /// - Parameter style: The style to apply to controls within this view.
    public func controlGroupStyle<S>(_ style: S) -> some View where S : ControlGroupStyle { return stubView() }

}

@available(iOS 14.0, macOS 11.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension View {

    /// Defines a keyboard shortcut and assigns it to the modified control.
    ///
    /// Pressing the control's shortcut while the control is anywhere in the
    /// frontmost window or scene, or anywhere in the macOS main menu, is
    /// equivalent to direct interaction with the control to perform its primary
    /// action.
    ///
    /// The target of a keyboard shortcut is resolved in a leading-to-trailing,
    /// depth-first traversal of one or more view hierarchies. On macOS, the
    /// system looks in the key window first, then the main window, and then the
    /// command groups; on other platforms, the system looks in the active
    /// scene, and then the command groups.
    ///
    /// If multiple controls are associated with the same shortcut, the first
    /// one found is used.
    ///
    /// The default localization configuration is set to ``KeyboardShortcut/Localization-swift.struct/automatic``.
    public func keyboardShortcut(_ key: KeyEquivalent, modifiers: EventModifiers = .command) -> some View { return stubView() }


    /// Assigns a keyboard shortcut to the modified control.
    ///
    /// Pressing the control's shortcut while the control is anywhere in the
    /// frontmost window or scene, or anywhere in the macOS main menu, is
    /// equivalent to direct interaction with the control to perform its primary
    /// action.
    ///
    /// The target of a keyboard shortcut is resolved in a leading-to-trailing
    /// traversal of one or more view hierarchies. On macOS, the system looks in
    /// the key window first, then the main window, and then the command groups;
    /// on other platforms, the system looks in the active scene, and then the
    /// command groups.
    ///
    /// If multiple controls are associated with the same shortcut, the first
    /// one found is used.
    public func keyboardShortcut(_ shortcut: KeyboardShortcut) -> some View { return stubView() }


    /// Assigns an optional keyboard shortcut to the modified control.
    ///
    /// Pressing the control's shortcut while the control is anywhere in the
    /// frontmost window or scene, or anywhere in the macOS main menu, is
    /// equivalent to direct interaction with the control to perform its primary
    /// action.
    ///
    /// The target of a keyboard shortcut is resolved in a leading-to-trailing
    /// traversal of one or more view hierarchies. On macOS, the system looks in
    /// the key window first, then the main window, and then the command groups;
    /// on other platforms, the system looks in the active scene, and then the
    /// command groups.
    ///
    /// If multiple controls are associated with the same shortcut, the first
    /// one found is used. If the provided shortcut is `nil`, the modifier will
    /// have no effect.
    @available(iOS 15.4, macOS 12.3, *)
    @available(tvOS, unavailable)
    @available(watchOS, unavailable)
    public func keyboardShortcut(_ shortcut: KeyboardShortcut?) -> some View { return stubView() }

}

@available(iOS 15.0, macOS 12.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension View {

    /// Defines a keyboard shortcut and assigns it to the modified control.
    ///
    /// Pressing the control's shortcut while the control is anywhere in the
    /// frontmost window or scene, or anywhere in the macOS main menu, is
    /// equivalent to direct interaction with the control to perform its primary
    /// action.
    ///
    /// The target of a keyboard shortcut is resolved in a leading-to-trailing,
    /// depth-first traversal of one or more view hierarchies. On macOS, the
    /// system looks in the key window first, then the main window, and then the
    /// command groups; on other platforms, the system looks in the active
    /// scene, and then the command groups.
    ///
    /// If multiple controls are associated with the same shortcut, the first
    /// one found is used.
    ///
    /// ### Localization
    ///
    /// Provide a `localization` value to specify how this shortcut
    /// should be localized.
    /// Given that `key` is always defined in relation to the US-English
    /// keyboard layout, it might be hard to reach on different international
    /// layouts. For example the shortcut `⌘[` works well for the
    /// US layout but is hard to reach for German users, where
    /// `[` is available by pressing `⌥5`, making users type `⌥⌘5`.
    /// The automatic keyboard shortcut remapping re-assigns the shortcut to
    /// an appropriate replacement, `⌘Ö` in this case.
    ///
    /// Certain shortcuts carry information about directionality. For instance,
    /// `⌘[` can reveal a previous view. Following the layout direction of
    /// the UI, this shortcut will be automatically mirrored to `⌘]`.
    /// However, this does not apply to items such as "Align Left `⌘{`",
    /// which will be "left" independently of the layout direction.
    /// When the shortcut shouldn't follow the directionality of the UI, but rather
    /// be the same in both right-to-left and left-to-right directions, using
    /// ``KeyboardShortcut/Localization-swift.struct/withoutMirroring``
    /// will prevent the system from flipping it.
    ///
    ///     var body: some Commands {
    ///         CommandMenu("Card") {
    ///             Button("Align Left") { ... }
    ///                 .keyboardShortcut("{",
    ///                      modifiers: .option,
    ///                      localization: .withoutMirroring)
    ///             Button("Align Right") { ... }
    ///                 .keyboardShortcut("}",
    ///                      modifiers: .option,
    ///                      localization: .withoutMirroring)
    ///         }
    ///     }
    ///
    /// Lastly, providing the option
    /// ``KeyboardShortcut/Localization-swift.struct/custom``
    /// disables
    /// the automatic localization for this shortcut to tell the system that
    /// internationalization is taken care of in a different way.
    public func keyboardShortcut(_ key: KeyEquivalent, modifiers: EventModifiers = .command, localization: KeyboardShortcut.Localization) -> some View { return stubView() }

}

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension View {

    /// Returns a new view with its inherited symbol image effects
    /// either removed or left unchanged.
    ///
    /// The following example adds a repeating pulse effect to two
    /// symbol images, but then disables the effect on one of them:
    ///
    ///     VStack {
    ///         Image(systemName: "bolt.slash.fill") // does not pulse
    ///             .symbolEffectsRemoved()
    ///         Image(systemName: "folder.fill.badge.person.crop") // pulses
    ///     }
    ///     .symbolEffect(.pulse)
    ///
    /// - Parameter isEnabled: Whether to remove inherited symbol
    ///   effects or not.
    ///
    /// - Returns: a copy of the view with its symbol effects either
    ///   removed or left unchanged.
    public func symbolEffectsRemoved(_ isEnabled: Bool = true) -> some View { return stubView() }

}

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
@available(xrOS, unavailable)
extension View {

    /// Plays the specified `feedback` when the provided `trigger` value
    /// changes.
    ///
    /// For example, you could play feedback when a state value changes:
    ///
    ///     struct MyView: View {
    ///         @State private var showAccessory = false
    ///
    ///         var body: some View {
    ///             ContentView()
    ///                 .sensoryFeedback(.selection, trigger: showAccessory)
    ///                 .onLongPressGesture {
    ///                     showAccessory.toggle()
    ///                 }
    ///
    ///             if showAccessory {
    ///                 AccessoryView()
    ///             }
    ///         }
    ///     }
    ///
    /// - Parameters:
    ///   - feedback: Which type of feedback to play.
    ///   - trigger: A value to monitor for changes to determine when to play.
    public func sensoryFeedback<T>(_ feedback: SensoryFeedback, trigger: T) -> some View where T : Equatable { return stubView() }


    /// Plays the specified `feedback` when the provided `trigger` value changes
    /// and the `condition` closure returns `true`.
    ///
    /// For example, you could play feedback for certain state transitions:
    ///
    ///     struct MyView: View {
    ///         @State private var phase = Phase.inactive
    ///
    ///         var body: some View {
    ///             ContentView(phase: $phase)
    ///                 .sensoryFeedback(.selection, trigger: phase) { old, new in
    ///                     old == .inactive || new == .expanded
    ///                 }
    ///         }
    ///
    ///         enum Phase {
    ///             case inactive
    ///             case preparing
    ///             case active
    ///             case expanded
    ///         }
    ///     }
    ///
    /// - Parameters:
    ///   - feedback: Which type of feedback to play.
    ///   - trigger: A value to monitor for changes to determine when to play.
    ///   - condition: A closure to determine whether to play the feedback when
    ///     `trigger` changes.
    public func sensoryFeedback<T>(_ feedback: SensoryFeedback, trigger: T, condition: @escaping (_ oldValue: T, _ newValue: T) -> Bool) -> some View where T : Equatable { return stubView() }


    /// Plays feedback when returned from the `feedback` closure after the
    /// provided `trigger` value changes.
    ///
    /// For example, you could play different feedback for different state
    /// transitions:
    ///
    ///     struct MyView: View {
    ///         @State private var phase = Phase.inactive
    ///
    ///         var body: some View {
    ///             ContentView(phase: $phase)
    ///                 .sensoryFeedback(trigger: phase) { old, new in
    ///                     switch (old, new) {
    ///                         case (.inactive, _): return .success
    ///                         case (_, .expanded): return .impact
    ///                         default: return nil
    ///                     }
    ///                 }
    ///         }
    ///
    ///         enum Phase {
    ///             case inactive
    ///             case preparing
    ///             case active
    ///             case expanded
    ///         }
    ///     }
    ///
    /// - Parameters:
    ///   - trigger: A value to monitor for changes to determine when to play.
    ///   - feedback: A closure to determine whether to play the feedback and
    ///     what type of feedback to play when `trigger` changes.
    public func sensoryFeedback<T>(trigger: T, _ feedback: @escaping (_ oldValue: T, _ newValue: T) -> SensoryFeedback?) -> some View where T : Equatable { return stubView() }

}

extension View {

    /// Configures the content margin for a provided placement.
    ///
    /// Use this modifier to customize the content margins of different
    /// kinds of views. For example, you can use this modifier to customize
    /// the margins of scrollable views like ``ScrollView``. In the
    /// following example, the scroll view will automatically inset
    /// its content by the safe area plus an additional 20 points
    /// on the leading and trailing edge.
    ///
    ///     ScrollView(.horizontal) {
    ///         // ...
    ///     }
    ///     .contentMargins(.horizontal, 20.0)
    ///
    /// You can provide a ``ContentMarginPlacement`` to target specific
    /// parts of a view to customize. For example, provide a
    /// ``ContentMargingPlacement/scrollContent`` placement to
    /// inset the content of a ``TextEditor`` without affecting the
    /// insets of its scroll indicators.
    ///
    ///     TextEditor(text: $text)
    ///         .contentMargins(.horizontal, 20.0, for: .scrollContent)
    ///
    /// Similarly, you can customize the insets of scroll indicators
    /// separately from scroll content. Consider doing this when applying
    /// a custom clip shape that may clip the indicators.
    ///
    ///     ScrollView {
    ///         // ...
    ///     }
    ///     .clipShape(.rect(cornerRadius: 20.0))
    ///     .contentMargins(10.0, for: .scrollIndicators)
    ///
    /// When applying multiple contentMargins modifiers, modifiers with
    /// the same placement will override modifiers higher up in the view
    /// hierarchy.
    ///
    /// - Parameters:
    ///   - edges: The edges to add the margins to.
    ///   - insets: The amount of margins to add.
    ///   - placement: Where the margins should be added.
    @available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
    public func contentMargins(_ edges: Edge.Set = .all, _ insets: EdgeInsets, for placement: ContentMarginPlacement = .automatic) -> some View { return stubView() }


    /// Configures the content margin for a provided placement.
    ///
    /// Use this modifier to customize the content margins of different
    /// kinds of views. For example, you can use this modifier to customize
    /// the margins of scrollable views like ``ScrollView``. In the
    /// following example, the scroll view will automatically inset
    /// its content by the safe area plus an additional 20 points
    /// on the leading and trailing edge.
    ///
    ///     ScrollView(.horizontal) {
    ///         // ...
    ///     }
    ///     .contentMargins(.horizontal, 20.0)
    ///
    /// You can provide a ``ContentMarginPlacement`` to target specific
    /// parts of a view to customize. For example, provide a
    /// ``ContentMargingPlacement/scrollContent`` placement to
    /// inset the content of a ``TextEditor`` without affecting the
    /// insets of its scroll indicators.
    ///
    ///     TextEditor(text: $text)
    ///         .contentMargins(.horizontal, 20.0, for: .scrollContent)
    ///
    /// Similarly, you can customize the insets of scroll indicators
    /// separately from scroll content. Consider doing this when applying
    /// a custom clip shape that may clip the indicators.
    ///
    ///     ScrollView {
    ///         // ...
    ///     }
    ///     .clipShape(.rect(cornerRadius: 20.0))
    ///     .contentMargins(10.0, for: .scrollIndicators)
    ///
    /// When applying multiple contentMargins modifiers, modifiers with
    /// the same placement will override modifiers higher up in the view
    /// hierarchy.
    ///
    /// - Parameters:
    ///   - edges: The edges to add the margins to.
    ///   - length: The amount of margins to add.
    ///   - placement: Where the margins should be added.
    @available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
    public func contentMargins(_ edges: Edge.Set = .all, _ length: CGFloat?, for placement: ContentMarginPlacement = .automatic) -> some View { return stubView() }


    /// Configures the content margin for a provided placement.
    ///
    /// Use this modifier to customize the content margins of different
    /// kinds of views. For example, you can use this modifier to customize
    /// the margins of scrollable views like ``ScrollView``. In the
    /// following example, the scroll view will automatically inset
    /// its content by the safe area plus an additional 20 points
    /// on the leading and trailing edge.
    ///
    ///     ScrollView(.horizontal) {
    ///         // ...
    ///     }
    ///     .contentMargins(.horizontal, 20.0)
    ///
    /// You can provide a ``ContentMarginPlacement`` to target specific
    /// parts of a view to customize. For example, provide a
    /// ``ContentMargingPlacement/scrollContent`` placement to
    /// inset the content of a ``TextEditor`` without affecting the
    /// insets of its scroll indicators.
    ///
    ///     TextEditor(text: $text)
    ///         .contentMargins(.horizontal, 20.0, for: .scrollContent)
    ///
    /// Similarly, you can customize the insets of scroll indicators
    /// separately from scroll content. Consider doing this when applying
    /// a custom clip shape that may clip the indicators.
    ///
    ///     ScrollView {
    ///         // ...
    ///     }
    ///     .clipShape(.rect(cornerRadius: 20.0))
    ///     .contentMargins(10.0, for: .scrollIndicators)
    ///
    /// When applying multiple contentMargins modifiers, modifiers with
    /// the same placement will override modifiers higher up in the view
    /// hierarchy.
    ///
    /// - Parameters:
    ///   - length: The amount of margins to add on all edges.
    ///   - placement: Where the margins should be added.
    @available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
    public func contentMargins(_ length: CGFloat, for placement: ContentMarginPlacement = .automatic) -> some View { return stubView() }

}

@available(iOS 16.4, macOS 13.3, tvOS 16.4, watchOS 9.4, *)
extension View {

    /// Sets the presentation background of the enclosing sheet using a shape
    /// style.
    ///
    /// The following example uses the ``Material/thick`` material as the sheet
    /// background:
    ///
    ///     struct ContentView: View {
    ///         @State private var showSettings = false
    ///
    ///         var body: some View {
    ///             Button("View Settings") {
    ///                 showSettings = true
    ///             }
    ///             .sheet(isPresented: $showSettings) {
    ///                 SettingsView()
    ///                     .presentationBackground(.thickMaterial)
    ///             }
    ///         }
    ///     }
    ///
    /// The `presentationBackground(_:)` modifier differs from the
    /// ``View/background(_:ignoresSafeAreaEdges:)`` modifier in several key
    /// ways. A presentation background:
    ///
    /// * Automatically fills the entire presentation.
    /// * Allows views behind the presentation to show through translucent
    ///   styles.
    ///
    /// - Parameter style: The shape style to use as the presentation
    ///   background.
    public func presentationBackground<S>(_ style: S) -> some View where S : ShapeStyle { return stubView() }


    /// Sets the presentation background of the enclosing sheet to a custom
    /// view.
    ///
    /// The following example uses a yellow view as the sheet background:
    ///
    ///     struct ContentView: View {
    ///         @State private var showSettings = false
    ///
    ///         var body: some View {
    ///             Button("View Settings") {
    ///                 showSettings = true
    ///             }
    ///             .sheet(isPresented: $showSettings) {
    ///                 SettingsView()
    ///                     .presentationBackground {
    ///                         Color.yellow
    ///                     }
    ///             }
    ///         }
    ///     }
    ///
    /// The `presentationBackground(alignment:content:)` modifier differs from
    /// the ``View/background(alignment:content:)`` modifier in several key
    /// ways. A presentation background:
    ///
    /// * Automatically fills the entire presentation.
    /// * Allows views behind the presentation to show through translucent
    ///   areas of the `content`.
    ///
    /// - Parameters:
    ///   - alignment: The alignment that the modifier uses to position the
    ///     implicit ``ZStack`` that groups the background views. The default is
    ///     ``Alignment/center``.
    ///   - content: The view to use as the background of the presentation.
    public func presentationBackground<V>(alignment: Alignment = .center, @ViewBuilder content: () -> V) -> some View where V : View { return stubView() }

}

@available(iOS 15.0, macOS 10.15, watchOS 9.0, *)
@available(tvOS, unavailable)
extension View {

    /// Sets the size for controls within this view.
    ///
    /// Use `controlSize(_:)` to override the system default size for controls
    /// in this view. In this example, a view displays several typical controls
    /// at `.mini`, `.small` and `.regular` sizes.
    ///
    ///     struct ControlSize: View {
    ///         var body: some View {
    ///             VStack {
    ///                 MyControls(label: "Mini")
    ///                     .controlSize(.mini)
    ///                 MyControls(label: "Small")
    ///                     .controlSize(.small)
    ///                 MyControls(label: "Regular")
    ///                     .controlSize(.regular)
    ///             }
    ///             .padding()
    ///             .frame(width: 450)
    ///             .border(Color.gray)
    ///         }
    ///     }
    ///
    ///     struct MyControls: View {
    ///         var label: String
    ///         @State private var value = 3.0
    ///         @State private var selected = 1
    ///         var body: some View {
    ///             HStack {
    ///                 Text(label + ":")
    ///                 Picker("Selection", selection: $selected) {
    ///                     Text("option 1").tag(1)
    ///                     Text("option 2").tag(2)
    ///                     Text("option 3").tag(3)
    ///                 }
    ///                 Slider(value: $value, in: 1...10)
    ///                 Button("OK") { }
    ///             }
    ///         }
    ///     }
    ///
    /// ![A screenshot showing several controls of various
    /// sizes.](SkipUI-View-controlSize.png)
    ///
    /// - Parameter controlSize: One of the control sizes specified in the
    ///   ``ControlSize`` enumeration.
    @available(tvOS, unavailable)
    public func controlSize(_ controlSize: ControlSize) -> some View { return stubView() }

}

@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
extension View {

    /// Modifies the view to use a given transition as its method of animating
    /// changes to the contents of its views.
    ///
    /// This modifier allows you to perform a transition that animates a change
    /// within a single view. The provided ``ContentTransition`` can present an
    /// opacity animation for content changes, an interpolated animation of
    /// the content's paths as they change, or perform no animation at all.
    ///
    /// > Tip: The `contentTransition(_:)` modifier only has an effect within
    /// the context of an ``Animation``.
    ///
    /// In the following example, a ``Button`` changes the color and font size
    /// of a ``Text`` view. Since both of these properties apply to the paths of
    /// the text, the ``ContentTransition/interpolate`` transition can animate a
    /// gradual change to these properties through the entire transition. By
    /// contrast, the ``ContentTransition/opacity`` transition would simply fade
    /// between the start and end states.
    ///
    ///     private static let font1 = Font.system(size: 20)
    ///     private static let font2 = Font.system(size: 45)
    ///
    ///     @State private var color = Color.red
    ///     @State private var currentFont = font1
    ///
    ///     var body: some View {
    ///         VStack {
    ///             Text("Content transition")
    ///                 .foregroundColor(color)
    ///                 .font(currentFont)
    ///                 .contentTransition(.interpolate)
    ///             Spacer()
    ///             Button("Change") {
    ///                 withAnimation(Animation.easeInOut(duration: 5.0)) {
    ///                     color = (color == .red) ? .green : .red
    ///                     currentFont = (currentFont == font1) ? font2 : font1
    ///                 }
    ///             }
    ///         }
    ///     }
    ///
    /// This example uses an ease-in–ease-out animation with a five-second
    /// duration to make it easier to see the effect of the interpolation. The
    /// figure below shows the `Text` at the beginning of the animation,
    /// halfway through, and at the end.
    ///
    /// | Time    | Display |
    /// | ------- | ------- |
    /// | Start   | ![The text Content transition in a small red font.](ContentTransition-1) |
    /// | Middle  | ![The text Content transition in a medium brown font.](ContentTransition-2) |
    /// | End     | ![The text Content transition in a large green font.](ContentTransition-3) |
    ///
    /// To control whether content transitions use GPU-accelerated rendering,
    /// set the value of the
    /// ``EnvironmentValues/contentTransitionAddsDrawingGroup`` environment
    /// variable.
    ///
    /// - parameter transition: The transition to apply when animating the
    ///   content change.
    public func contentTransition(_ transition: ContentTransition) -> some View { return stubView() }

}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
extension View {

    /// Shows the specified content above or below the modified view.
    ///
    /// The `content` view is anchored to the specified
    /// vertical edge in the parent view, aligning its horizontal axis
    /// to the specified alignment guide. The modified view is inset by
    /// the height of `content`, from `edge`, with its safe area
    /// increased by the same amount.
    ///
    ///     struct ScrollableViewWithBottomBar: View {
    ///         var body: some View {
    ///             ScrollView {
    ///                 ScrolledContent()
    ///             }
    ///             .safeAreaInset(edge: .bottom, spacing: 0) {
    ///                 BottomBarContent()
    ///             }
    ///         }
    ///     }
    ///
    /// - Parameters:
    ///   - edge: The vertical edge of the view to inset by the height of
    ///    `content`, to make space for `content`.
    ///   - spacing: Extra distance placed between the two views, or
    ///     nil to use the default amount of spacing.
    ///   - alignment: The alignment guide used to position `content`
    ///     horizontally.
    ///   - content: A view builder function providing the view to
    ///     display in the inset space of the modified view.
    ///
    /// - Returns: A new view that displays both `content` above or below the
    ///   modified view,
    ///   making space for the `content` view by vertically insetting
    ///   the modified view, adjusting the safe area of the result to match.
    public func safeAreaInset<V>(edge: VerticalEdge, alignment: HorizontalAlignment = .center, spacing: CGFloat? = nil, @ViewBuilder content: () -> V) -> some View where V : View { return stubView() }


    /// Shows the specified content beside the modified view.
    ///
    /// The `content` view is anchored to the specified
    /// horizontal edge in the parent view, aligning its vertical axis
    /// to the specified alignment guide. The modified view is inset by
    /// the width of `content`, from `edge`, with its safe area
    /// increased by the same amount.
    ///
    ///     struct ScrollableViewWithSideBar: View {
    ///         var body: some View {
    ///             ScrollView {
    ///                 ScrolledContent()
    ///             }
    ///             .safeAreaInset(edge: .leading, spacing: 0) {
    ///                 SideBarContent()
    ///             }
    ///         }
    ///     }
    ///
    /// - Parameters:
    ///   - edge: The horizontal edge of the view to inset by the width of
    ///    `content`, to make space for `content`.
    ///   - spacing: Extra distance placed between the two views, or
    ///     nil to use the default amount of spacing.
    ///   - alignment: The alignment guide used to position `content`
    ///     vertically.
    ///   - content: A view builder function providing the view to
    ///     display in the inset space of the modified view.
    ///
    /// - Returns: A new view that displays `content` beside the modified view,
    ///   making space for the `content` view by horizontally insetting
    ///   the modified view.
    public func safeAreaInset<V>(edge: HorizontalEdge, alignment: VerticalAlignment = .center, spacing: CGFloat? = nil, @ViewBuilder content: () -> V) -> some View where V : View { return stubView() }

}

extension View {

    /// Adds the provided insets into the safe area of this view.
    ///
    /// Use this modifier when you would like to add a fixed amount
    /// of space to the safe area a view sees.
    ///
    ///     ScrollView(.horizontal) {
    ///         HStack(spacing: 10.0) {
    ///             ForEach(items) { item in
    ///                 ItemView(item)
    ///             }
    ///         }
    ///     }
    ///     .safeAreaPadding(.horizontal, 20.0)
    ///
    /// See the ``View/safeAreaInset(edge:alignment:spacing:content)``
    /// modifier for adding to the safe area based on the size of a
    /// view.
    @available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
    public func safeAreaPadding(_ insets: EdgeInsets) -> some View { return stubView() }


    /// Adds the provided insets into the safe area of this view.
    ///
    /// Use this modifier when you would like to add a fixed amount
    /// of space to the safe area a view sees.
    ///
    ///     ScrollView(.horizontal) {
    ///         HStack(spacing: 10.0) {
    ///             ForEach(items) { item in
    ///                 ItemView(item)
    ///             }
    ///         }
    ///     }
    ///     .safeAreaPadding(.horizontal, 20.0)
    ///
    /// See the ``View/safeAreaInset(edge:alignment:spacing:content)``
    /// modifier for adding to the safe area based on the size of a
    /// view.
    @available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
    public func safeAreaPadding(_ edges: Edge.Set = .all, _ length: CGFloat? = nil) -> some View { return stubView() }


    /// Adds the provided insets into the safe area of this view.
    ///
    /// Use this modifier when you would like to add a fixed amount
    /// of space to the safe area a view sees.
    ///
    ///     ScrollView(.horizontal) {
    ///         HStack(spacing: 10.0) {
    ///             ForEach(items) { item in
    ///                 ItemView(item)
    ///             }
    ///         }
    ///     }
    ///     .safeAreaPadding(.horizontal, 20.0)
    ///
    /// See the ``View/safeAreaInset(edge:alignment:spacing:content)``
    /// modifier for adding to the safe area based on the size of a
    /// view.
    @available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
    public func safeAreaPadding(_ length: CGFloat) -> some View { return stubView() }

}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension View {

    /// Sets the specified style to render backgrounds within the view.
    ///
    /// The following example uses this modifier to set the
    /// ``EnvironmentValues/backgroundStyle`` environment value to a
    /// ``ShapeStyle/blue`` color that includes a subtle ``Color/gradient``.
    /// SkipUI fills the ``Circle`` shape that acts as a background element
    /// with this style:
    ///
    ///     Image(systemName: "swift")
    ///         .padding()
    ///         .background(in: Circle())
    ///         .backgroundStyle(.blue.gradient)
    ///
    /// ![An image of the Swift logo inside a circle that's blue with a slight
    /// linear gradient. The blue color is slightly lighter at the top of the
    /// circle and slightly darker at the bottom.](View-backgroundStyle-1-iOS)
    ///
    /// To restore the default background style, set the
    /// ``EnvironmentValues/backgroundStyle`` environment value to
    /// `nil` using the ``View/environment(_:_:)`` modifer:
    ///
    ///     .environment(\.backgroundStyle, nil)
    ///
    @available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
    public func backgroundStyle<S>(_ style: S) -> some View where S : ShapeStyle { return stubView() }

}

extension View {

    /// Adds an action to perform when the pointer enters, moves within, and
    /// exits the view's bounds.
    ///
    /// Call this method to define a region for detecting pointer movement with
    /// the size and position of this view.
    /// The following example updates `hoverLocation` and `isHovering` to be
    /// based on the phase provided to the closure:
    ///
    ///     @State private var hoverLocation: CGPoint = .zero
    ///     @State private var isHovering = false
    ///
    ///     var body: some View {
    ///         VStack {
    ///             Color.red
    ///                 .frame(width: 400, height: 400)
    ///                 .onContinuousHover { phase in
    ///                     switch phase {
    ///                     case .active(let location):
    ///                         hoverLocation = location
    ///                         isHovering = true
    ///                     case .ended:
    ///                         isHovering = false
    ///                     }
    ///                 }
    ///                 .overlay {
    ///                     Rectangle()
    ///                         .frame(width: 50, height: 50)
    ///                         .foregroundColor(isHovering ? .green : .blue)
    ///                         .offset(x: hoverLocation.x, y: hoverLocation.y)
    ///                 }
    ///         }
    ///     }
    ///
    /// - Parameters:
    ///    - coordinateSpace: The coordinate space for the
    ///    location values. Defaults to ``CoordinateSpace/local``.
    ///    - action: The action to perform whenever the pointer enters,
    ///    moves within, or exits the view's bounds. The `action` closure
    ///    passes the ``HoverPhase/active(_:)`` phase with the pointer's
    ///    coordinates if the pointer is in the view's bounds; otherwise, it
    ///    passes ``HoverPhase/ended``.
    ///
    /// - Returns: A view that calls `action` when the pointer enters,
    ///   moves within, or exits the view's bounds.
    @available(iOS 17.0, macOS 14.0, tvOS 17.0, *)
    @available(watchOS, unavailable)
    public func onContinuousHover(coordinateSpace: some CoordinateSpaceProtocol = .local, perform action: @escaping (HoverPhase) -> Void) -> some View { return stubView() }

}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension View {

    /// Binds a view's identity to the given proxy value.
    ///
    /// When the proxy value specified by the `id` parameter changes, the
    /// identity of the view — for example, its state — is reset.
    public func id<ID>(_ id: ID) -> some View where ID : Hashable { return stubView() }

}

@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
extension View {

    /// Performs an action when a specified value changes.
    ///
    /// Use this modifier to run a closure when a value like
    /// an ``Environment`` value or a ``Binding`` changes.
    /// For example, you can clear a cache when you notice
    /// that the view's scene moves to the background:
    ///
    ///     struct ContentView: View {
    ///         @Environment(\.scenePhase) private var scenePhase
    ///         @StateObject private var cache = DataCache()
    ///
    ///         var body: some View {
    ///             MyView()
    ///                 .onChange(of: scenePhase) { newScenePhase in
    ///                     if newScenePhase == .background {
    ///                         cache.empty()
    ///                     }
    ///                 }
    ///         }
    ///     }
    ///
    /// SkipUI passes the new value into the closure. You can also capture the
    /// previous value to compare it to the new value. For example, in
    /// the following code example, `PlayerView` passes both the old and new
    /// values to the model.
    ///
    ///     struct PlayerView: View {
    ///         var episode: Episode
    ///         @State private var playState: PlayState = .paused
    ///
    ///         var body: some View {
    ///             VStack {
    ///                 Text(episode.title)
    ///                 Text(episode.showTitle)
    ///                 PlayButton(playState: $playState)
    ///             }
    ///             .onChange(of: playState) { [playState] newState in
    ///                 model.playStateDidChange(from: playState, to: newState)
    ///             }
    ///         }
    ///     }
    ///
    /// The system may call the action closure on the main actor, so avoid
    /// long-running tasks in the closure. If you need to perform such tasks,
    /// detach an asynchronous background task.
    ///
    /// Important: This modifier is deprecated and has been replaced with new
    /// versions that include either zero or two parameters within the closure,
    /// unlike this version that includes one parameter. This deprecated version
    /// and the new versions behave differently with respect to how they execute
    /// the action closure, specifically when the closure captures other values.
    /// Using the deprecated API, the closure is run with captured values that
    /// represent the "old" state. With the replacement API, the closure is run
    /// with captured values that represent the "new" state, which makes it
    /// easier to correctly perform updates that rely on supplementary values
    /// (that may or may not have changed) in addition to the changed value that
    /// triggered the action.
    ///
    /// - Important: This modifier is deprecated and has been replaced with new
    ///   versions that include either zero or two parameters within the
    ///   closure, unlike this version that includes one parameter. This
    ///   deprecated version and the new versions behave differently with
    ///   respect to how they execute the action closure, specifically when the
    ///   closure captures other values. Using the deprecated API, the closure
    ///   is run with captured values that represent the "old" state. With the
    ///   replacement API, the closure is run with captured values that
    ///   represent the "new" state, which makes it easier to correctly perform
    ///   updates that rely on supplementary values (that may or may not have
    ///   changed) in addition to the changed value that triggered the action.
    ///
    /// - Parameters:
    ///   - value: The value to check when determining whether to run the
    ///     closure. The value must conform to the
    ///
    ///     protocol.
    ///   - action: A closure to run when the value changes. The closure
    ///     takes a `newValue` parameter that indicates the updated
    ///     value.
    ///
    /// - Returns: A view that runs an action when the specified value changes.
    @available(iOS, deprecated: 17.0, message: "Use `onChange` with a two or zero parameter action closure instead.")
    @available(macOS, deprecated: 14.0, message: "Use `onChange` with a two or zero parameter action closure instead.")
    @available(tvOS, deprecated: 17.0, message: "Use `onChange` with a two or zero parameter action closure instead.")
    @available(watchOS, deprecated: 10.0, message: "Use `onChange` with a two or zero parameter action closure instead.")
    @available(xrOS, deprecated: 1.0, message: "Use `onChange` with a two or zero parameter action closure instead.")
    public func onChange<V>(of value: V, perform action: @escaping (_ newValue: V) -> Void) -> some View where V : Equatable { return stubView() }

}

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension View {

    /// Adds a modifier for this view that fires an action when a specific
    /// value changes.
    ///
    /// You can use `onChange` to trigger a side effect as the result of a
    /// value changing, such as an `Environment` key or a `Binding`.
    ///
    /// The system may call the action closure on the main actor, so avoid
    /// long-running tasks in the closure. If you need to perform such tasks,
    /// detach an asynchronous background task.
    ///
    /// When the value changes, the new version of the closure will be called,
    /// so any captured values will have their values from the time that the
    /// observed value has its new value. The old and new observed values are
    /// passed into the closure. In the following code example, `PlayerView`
    /// passes both the old and new values to the model.
    ///
    ///     struct PlayerView: View {
    ///         var episode: Episode
    ///         @State private var playState: PlayState = .paused
    ///
    ///         var body: some View {
    ///             VStack {
    ///                 Text(episode.title)
    ///                 Text(episode.showTitle)
    ///                 PlayButton(playState: $playState)
    ///             }
    ///             .onChange(of: playState) { oldState, newState in
    ///                 model.playStateDidChange(from: oldState, to: newState)
    ///             }
    ///         }
    ///     }
    ///
    /// - Parameters:
    ///   - value: The value to check against when determining whether
    ///     to run the closure.
    ///   - initial: Whether the action should be run when this view initially
    ///     appears.
    ///   - action: A closure to run when the value changes.
    ///   - oldValue: The old value that failed the comparison check (or the
    ///     initial value when requested).
    ///   - newValue: The new value that failed the comparison check.
    ///
    /// - Returns: A view that fires an action when the specified value changes.
    public func onChange<V>(of value: V, initial: Bool = false, _ action: @escaping (_ oldValue: V, _ newValue: V) -> Void) -> some View where V : Equatable { return stubView() }


    /// Adds a modifier for this view that fires an action when a specific
    /// value changes.
    ///
    /// You can use `onChange` to trigger a side effect as the result of a
    /// value changing, such as an `Environment` key or a `Binding`.
    ///
    /// The system may call the action closure on the main actor, so avoid
    /// long-running tasks in the closure. If you need to perform such tasks,
    /// detach an asynchronous background task.
    ///
    /// When the value changes, the new version of the closure will be called,
    /// so any captured values will have their values from the time that the
    /// observed value has its new value. In the following code example,
    /// `PlayerView` calls into its model when `playState` changes model.
    ///
    ///     struct PlayerView: View {
    ///         var episode: Episode
    ///         @State private var playState: PlayState = .paused
    ///
    ///         var body: some View {
    ///             VStack {
    ///                 Text(episode.title)
    ///                 Text(episode.showTitle)
    ///                 PlayButton(playState: $playState)
    ///             }
    ///             .onChange(of: playState) {
    ///                 model.playStateDidChange(state: playState)
    ///             }
    ///         }
    ///     }
    ///
    /// - Parameters:
    ///   - value: The value to check against when determining whether
    ///     to run the closure.
    ///   - initial: Whether the action should be run when this view initially
    ///     appears.
    ///   - action: A closure to run when the value changes.
    ///
    /// - Returns: A view that fires an action when the specified value changes.
    public func onChange<V>(of value: V, initial: Bool = false, _ action: @escaping () -> Void) -> some View where V : Equatable { return stubView() }

}

extension View {

    /// Sets the container background of the enclosing container using a view.
    ///
    /// The following example uses a ``LinearGradient`` as a background:
    ///
    ///     struct ContentView: View {
    ///         var body: some View {
    ///             NavigationStack {
    ///                 List {
    ///                     NavigationLink("Blue") {
    ///                         Text("Blue")
    ///                         .containerBackground(.blue.gradient, for: .navigation)
    ///                     }
    ///                     NavigationLink("Red") {
    ///                         Text("Red")
    ///                         .containerBackground(.red.gradient, for: .navigation)
    ///                     }
    ///                 }
    ///             }
    ///         }
    ///     }
    ///
    /// The `.containerBackground(_:for:)` modifier differs from the
    /// ``View/background(_:ignoresSafeAreaEdges:)`` modifier by automatically
    /// filling an entire parent container. ``ContainerBackgroundPlacement``
    /// describes the available containers.
    ///
    /// - Parameters
    ///   - style: The shape style to use as the container background.
    ///   - container: The container that will use the background.
    @available(iOS 17.0, tvOS 17.0, macOS 14.0, watchOS 10.0, *)
    public func containerBackground<S>(_ style: S, for container: ContainerBackgroundPlacement) -> some View where S : ShapeStyle { return stubView() }


    /// Sets the container background of the enclosing container using a view.
    ///
    /// The following example uses a custom ``View`` as a background:
    ///
    ///     struct ContentView: View {
    ///         var body: some View {
    ///             NavigationStack {
    ///                 List {
    ///                     NavigationLink("Image") {
    ///                         Text("Image")
    ///                         .containerBackground(for: .navigation) {
    ///                             Image(name: "ImageAsset")
    ///                         }
    ///                     }
    ///                 }
    ///             }
    ///         }
    ///     }
    ///
    /// The `.containerBackground(for:alignment:content:)` modifier differs from
    /// the ``View/background(_:ignoresSafeAreaEdges:)`` modifier by
    /// automatically filling an entire parent container.
    /// ``ContainerBackgroundPlacement`` describes the available containers.
    ///
    /// - Parameters:
    ///   - alignment: The alignment that the modifier uses to position the
    ///     implicit ``ZStack`` that groups the background views. The default is
    ///     ``Alignment/center``.
    ///   - container: The container that will use the background.
    ///   - content: The view to use as the background of the container.
    @available(iOS 17.0, tvOS 17.0, macOS 14.0, watchOS 10.0, *)
    public func containerBackground<V>(for container: ContainerBackgroundPlacement, alignment: Alignment = .center, @ViewBuilder content: () -> V) -> some View where V : View { return stubView() }
}

extension View {

    /// Sets the scroll behavior of views scrollable in the provided axes.
    ///
    /// A scrollable view calculates where scroll gestures should end using its
    /// deceleration rate and the state of its scroll gesture by default. A
    /// scroll behavior allows for customizing this logic. You can provide
    /// your own ``ScrollTargetBehavior`` or use one of the built in behaviors
    /// provided by SkipUI.
    ///
    /// ### Paging Behavior
    ///
    /// SkipUI offers a ``PagingScrollTargetBehavior`` behavior which uses the
    /// geometry of the scroll view to decide where to allow scrolls to end.
    ///
    /// In the following example, every view in the lazy stack is flexible
    /// in both directions and the scroll view will settle to container aligned
    /// boundaries.
    ///
    ///     ScrollView {
    ///         LazyVStack(spacing: 0.0) {
    ///             ForEach(items) { item in
    ///                 FullScreenItem(item)
    ///             }
    ///         }
    ///     }
    ///     .scrollTargetBehavior(.paging)
    ///
    /// ### View Aligned Behavior
    ///
    /// SkipUI offers a ``ViewAlignedScrollTargetBehavior`` scroll behavior
    /// that will always settle on the geometry of individual views.
    ///
    ///     ScrollView(.horizontal) {
    ///         LazyHStack(spacing: 10.0) {
    ///             ForEach(items) { item in
    ///                 ItemView(item)
    ///             }
    ///         }
    ///         .scrollTargetLayout()
    ///     }
    ///     .scrollTargetBehavior(.viewAligned)
    ///     .safeAreaPadding(.horizontal, 20.0)
    ///
    /// You configure which views should be used for settling using the
    /// ``View/scrollTargetLayout()`` modifier. Apply this modifier to a
    /// layout container like ``LazyVStack`` or ``HStack`` and each individual
    /// view in that layout will be considered for alignment.
    ///
    /// You can also associate invidiual views for alignment using the
    /// ``View/scrollTarget()`` modifier.
    ///
    ///     ScrollView(.horizontal) {
    ///         HeaderView()
    ///             .scrollTarget()
    ///         LazyVStack {
    ///             // other content...
    ///         }
    ///         .scrollTargetLayout()
    ///     }
    ///     .scrollTargetBehavior(.viewAligned)
    ///
    @available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
    public func scrollTargetBehavior(_ behavior: some ScrollTargetBehavior) -> some View { return stubView() }

}

extension View {

    /// Configures the outermost layout as a scroll target layout.
    ///
    /// This modifier works together with the
    /// ``ViewAlignedScrollTargetBehavior`` to ensure that scroll views align
    /// to view based content.
    ///
    /// Apply this modifier to layout containers like ``LazyHStack`` or
    /// ``VStack`` within a ``ScrollView`` that contain the main repeating
    /// content of your ``ScrollView``.
    ///
    ///     ScrollView(.horizontal) {
    ///         LazyHStack(spacing: 10.0) {
    ///             ForEach(items) { item in
    ///                 ItemView(item)
    ///             }
    ///         }
    ///         .scrollTargetLayout()
    ///     }
    ///     .scrollTargetBehavior(.viewAligned)
    ///
    /// Scroll target layouts act as a convenience for applying a
    /// ``View/scrollTarget(isEnabled:)`` modifier to each views in
    /// the layout.
    ///
    /// A scroll target layout will ensure that any target layout
    /// nested within the primary one will not also become a scroll
    /// target layout.
    ///
    ///     LazyHStack { // a scroll target layout
    ///         VStack { ... } // not a scroll target layout
    ///         LazyHStack { ... } // also not a scroll target layout
    ///     }
    ///     .scrollTargetLayout()
    ///
    @available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
    public func scrollTargetLayout(isEnabled: Bool = true) -> some View { return stubView() }

}

extension View {

    /// Configures this view as a scroll target.
    ///
    /// Apply this modifier to individual views like ``Button`` or
    /// ``Text`` within a ``ScrollView`` that represent distinct pieces of
    /// content that a scroll view may wish to align to.
    ///
    ///     ScrollView {
    ///         Text("Header")
    ///             .font(.title2)
    ///             .scrollTarget()
    ///
    ///         LazyVStack {
    ///             ForEach(items) { item in
    ///                 ItemView(item)
    ///             }
    ///         }
    ///         .scrollTargetLayout()
    ///     }
    ///     .scrollTargetBehavior(.viewAligned)
    ///
    /// A scroll target layout act as a convenience for applying a
    /// ``View/scrollTarget(isEnabled:)`` modifier to each views in
    /// the layout.
    ///
    @available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
    public func scrollTarget(isEnabled: Bool = true) -> some View { return stubView() }

}

@available(iOS 14.0, macOS 11.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension View {

    /// Presents a system interface for allowing the user to move an existing
    /// file to a new location.
    ///
    /// - Note: This interface provides security-scoped URLs.
    ///   Call the ``startAccessingSecurityScopedResource`` method to access or bookmark
    ///   the URLs, and the ``stopAccessingSecurityScopedResource`` method
    ///   to release the access.
    ///
    /// In order for the interface to appear, both `isPresented` must be `true`
    /// and `file` must not be `nil`. When the operation is finished,
    /// `isPresented` will be set to `false` before `onCompletion` is called. If
    /// the user cancels the operation, `isPresented` will be set to `false` and
    /// `onCompletion` will not be called.
    ///
    /// - Parameters:
    ///   - isPresented: A binding to whether the interface should be shown.
    ///   - file: The `URL` of the file to be moved.
    ///   - onCompletion: A callback that will be invoked when the operation has
    ///     has succeeded or failed. To access the received URLs, call `startAccessingSecurityScopedResource`.
    ///     When the access is no longer required, call `stopAccessingSecurityScopedResource`.
    ///   - result: A `Result` indicating whether the operation succeeded or
    ///     failed.
    public func fileMover(isPresented: Binding<Bool>, file: URL?, onCompletion: @escaping (_ result: Result<URL, Error>) -> Void) -> some View { return stubView() }


    /// Presents a system interface for allowing the user to move a collection
    /// of existing files to a new location.
    ///
    /// - Note: This interface provides security-scoped URLs.
    ///   Call the ``startAccessingSecurityScopedResource`` method to access or bookmark
    ///   the URLs, and the ``stopAccessingSecurityScopedResource`` method
    ///   to release the access.
    ///
    /// In order for the interface to appear, both `isPresented` must be `true`
    /// and `files` must not be empty. When the operation is finished,
    /// `isPresented` will be set to `false` before `onCompletion` is called. If
    /// the user cancels the operation, `isPresented` will be set to `false` and
    /// `onCompletion` will not be called.
    ///
    /// - Parameters:
    ///   - isPresented: A binding to whether the interface should be shown.
    ///   - files: A collection of `URL`s for the files to be moved.
    ///   - onCompletion: A callback that will be invoked when the operation has
    ///     has succeeded or failed. To access the received URLs, call `startAccessingSecurityScopedResource`.
    ///     When the access is no longer required, call `stopAccessingSecurityScopedResource`.
    ///   - result: A `Result` indicating whether the operation succeeded or
    ///     failed.
    public func fileMover<C>(isPresented: Binding<Bool>, files: C, onCompletion: @escaping (_ result: Result<[URL], Error>) -> Void) -> some View where C : Collection, C.Element == URL { return stubView() }

}

@available(iOS 17.0, macOS 14.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension View {

    /// Presents a system dialog for allowing the user to move
    /// an existing file to a new location.
    ///
    /// - Note: This dialog provides security-scoped URLs.
    ///   Call the ``startAccessingSecurityScopedResource`` method to access or bookmark
    ///   the URLs, and the ``stopAccessingSecurityScopedResource`` method
    ///   to release the access.
    ///
    /// For example, a button that allows the user to move a file might look like this:
    ///
    ///       struct MoveFileButton: View {
    ///           @State private var showFileMover = false
    ///           var file: URL
    ///           var onCompletion: (URL) -> Void
    ///           var onCancellation: (() -> Void)?
    ///
    ///           var body: some View {
    ///               Button {
    ///                   showFileMover = true
    ///               } label: {
    ///                   Label("Choose destination", systemImage: "folder.circle")
    ///               }
    ///               .fileMover(isPresented: $showFileMover, file: file) { result in
    ///                   switch result {
    ///                   case .success(let url):
    ///                       guard url.startAccessingSecurityScopedResource() else {
    ///                           return
    ///                       }
    ///                       onCompletion(url)
    ///                       url.stopAccessingSecurityScopedResource()
    ///                   case .failure(let error):
    ///                       print(error)
    ///                       // handle error
    ///                   }
    ///               } onCancellation: {
    ///                   onCancellation?()
    ///               }
    ///           }
    ///       }
    ///
    /// - Parameters:
    ///   - isPresented: A binding to whether the dialog should be shown.
    ///   - file: The URL of the file to be moved.
    ///   - onCompletion: A callback that will be invoked when the operation has
    ///     succeeded or failed. The `result` indicates whether
    ///     the operation succeeded or failed. To access the received URLs, call
    ///     `startAccessingSecurityScopedResource`.
    ///     When the access is no longer required, call `stopAccessingSecurityScopedResource`.
    ///   - onCancellation: A callback that will be invoked
    ///     if the user cancels the operation.
    public func fileMover(isPresented: Binding<Bool>, file: URL?, onCompletion: @escaping (Result<URL, Error>) -> Void, onCancellation: @escaping () -> Void) -> some View { return stubView() }


    /// Presents a system dialog for allowing the user to move
    /// a collection of existing files to a new location.
    ///
    /// - Note: This dialog provides security-scoped URLs.
    ///   Call the ``startAccessingSecurityScopedResource`` method to access or bookmark
    ///   the URLs, and the ``stopAccessingSecurityScopedResource`` method
    ///   to release the access.
    ///
    /// For example, a button that allows the user to move files might look like this:
    ///
    ///       struct MoveFilesButton: View {
    ///           @Binding var files: [URL]
    ///           @State private var showFileMover = false
    ///           var onCompletion: (URL) -> Void
    ///           var onCancellation: (() -> Void)?
    ///
    ///           var body: some View {
    ///               Button {
    ///                   showFileMover = true
    ///               } label: {
    ///                   Label("Choose destination", systemImage: "folder.circle")
    ///               }
    ///               .fileMover(isPresented: $showFileMover, files: files) { result in
    ///                   switch result {
    ///                   case .success(let urls):
    ///                       urls.forEach { url in
    ///                           guard url.startAccessingSecurityScopedResource() else {
    ///                               return
    ///                           }
    ///                           onCompletion(url)
    ///                           url.stopAccessingSecurityScopedResource()
    ///                       }
    ///                   case .failure(let error):
    ///                       print(error)
    ///                       // handle error
    ///                   }
    ///               } onCancellation: {
    ///                   onCancellation?()
    ///               }
    ///           }
    ///       }
    ///
    /// - Parameters:
    ///   - isPresented: A binding to whether the dialog should be shown.
    ///   - files: A collection of URLs for the files to be moved.
    ///   - onCompletion: A callback that will be invoked when the operation has
    ///     succeeded or failed. The `result` indicates whether
    ///     the operation succeeded or failed.
    ///     To access the received URLs, call `startAccessingSecurityScopedResource`.
    ///     When the access is no longer required, call `stopAccessingSecurityScopedResource`.
    ///   - onCancellation: A callback that will be invoked
    ///     if the user cancels the operation.
    public func fileMover<C>(isPresented: Binding<Bool>, files: C, onCompletion: @escaping (Result<[URL], Error>) -> Void, onCancellation: @escaping () -> Void) -> some View where C : Collection, C.Element == URL { return stubView() }

}

@available(iOS 16.0, macOS 13.0, watchOS 7.0, *)
@available(tvOS, unavailable)
extension View {

    /// Sets the style for gauges within this view.
    public func gaugeStyle<S>(_ style: S) -> some View where S : GaugeStyle { return stubView() }

}

@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension View {

    /// Sets the style for disclosure groups within this view.
    @available(iOS 16.0, macOS 13.0, *)
    @available(tvOS, unavailable)
    @available(watchOS, unavailable)
    public func disclosureGroupStyle<S>(_ style: S) -> some View where S : DisclosureGroupStyle { return stubView() }

}

@available(iOS 17.0, macOS 14.0, *)
@available(watchOS, unavailable)
@available(tvOS, unavailable)
extension View {

    /// Controls the visibility of a `Table`'s column header views.
    ///
    /// By default, `Table` will display a global header view with the labels
    /// of each table column. This area is also where users can sort, resize,
    /// and rearrange the columns. For simple cases that don't require those
    /// features, this header can be hidden.
    ///
    /// This will not affect the header of any `Section`s in a table.
    ///
    ///     Table(article.authors) {
    ///         TableColumn("Name", value: \.name)
    ///         TableColumn("Title", value: \.title)
    ///     }
    ///     .tableColumnHeaders(.hidden)
    ///
    /// - Parameter visibility: A value of `visible` will show table columns,
    ///   `hidden` will remove them, and `automatic` will defer to default
    ///   behavior.
    public func tableColumnHeaders(_ visibility: Visibility) -> some View { return stubView() }

}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension View {

    /// Rotates this view's rendered output in three dimensions around the given
    /// axis of rotation.
    ///
    /// Use `rotation3DEffect(_:axis:anchor:anchorZ:perspective:)` to rotate the
    /// view in three dimensions around the given axis of rotation, and
    /// optionally, position the view at a custom display order and perspective.
    ///
    /// In the example below, the text is rotated 45˚ about the `y` axis,
    /// front-most (the default `zIndex`) and default `perspective` (`1`):
    ///
    ///     Text("Rotation by passing an angle in degrees")
    ///         .rotation3DEffect(.degrees(45), axis: (x: 0.0, y: 1.0, z: 0.0))
    ///         .border(Color.gray)
    ///
    /// ![A screenshot showing the rotation of text 45 degrees about the
    /// y-axis.](SkipUI-View-rotation3DEffect.png)
    ///
    /// - Parameters:
    ///   - angle: The angle at which to rotate the view.
    ///   - axis: The `x`, `y` and `z` elements that specify the axis of
    ///     rotation.
    ///   - anchor: The location with a default of ``UnitPoint/center`` that
    ///     defines a point in 3D space about which the rotation is anchored.
    ///   - anchorZ: The location with a default of `0` that defines a point in
    ///     3D space about which the rotation is anchored.
    ///   - perspective: The relative vanishing point with a default of `1` for
    ///     this rotation.
    public func rotation3DEffect(_ angle: Angle, axis: (x: CGFloat, y: CGFloat, z: CGFloat), anchor: UnitPoint = .center, anchorZ: CGFloat = 0, perspective: CGFloat = 1) -> some View { return stubView() }

}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension View {

    /// Transforms the environment value of the specified key path with the
    /// given function.
    public func transformEnvironment<V>(_ keyPath: WritableKeyPath<EnvironmentValues, V>, transform: @escaping (inout V) -> Void) -> some View { return stubView() }

}

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension View {

    /// Assigns a name to the view's coordinate space, so other code can operate
    /// on dimensions like points and sizes relative to the named space.
    ///
    /// Use `coordinateSpace(_:)` to allow another function to find and
    /// operate on a view and operate on dimensions relative to that view.
    ///
    /// The example below demonstrates how a nested view can find and operate on
    /// its enclosing view's coordinate space:
    ///
    ///     struct ContentView: View {
    ///         @State private var location = CGPoint.zero
    ///
    ///         var body: some View {
    ///             VStack {
    ///                 Color.red.frame(width: 100, height: 100)
    ///                     .overlay(circle)
    ///                 Text("Location: \(Int(location.x)), \(Int(location.y))")
    ///             }
    ///             .coordinateSpace(.named("stack"))
    ///         }
    ///
    ///         var circle: some View {
    ///             Circle()
    ///                 .frame(width: 25, height: 25)
    ///                 .gesture(drag)
    ///                 .padding(5)
    ///         }
    ///
    ///         var drag: some Gesture {
    ///             DragGesture(coordinateSpace: .named("stack"))
    ///                 .onChanged { info in location = info.location }
    ///         }
    ///     }
    ///
    /// Here, the ``VStack`` in the `ContentView` named “stack” is composed of a
    /// red frame with a custom ``Circle`` view ``View/overlay(_:alignment:)``
    /// at its center.
    ///
    /// The `circle` view has an attached ``DragGesture`` that targets the
    /// enclosing VStack's coordinate space. As the gesture recognizer's closure
    /// registers events inside `circle` it stores them in the shared `location`
    /// state variable and the ``VStack`` displays the coordinates in a ``Text``
    /// view.
    ///
    /// ![A screenshot showing an example of finding a named view and tracking
    /// relative locations in that view.](SkipUI-View-coordinateSpace.png)
    ///
    /// - Parameter name: A name used to identify this coordinate space.
    public func coordinateSpace(_ name: NamedCoordinateSpace) -> some View { return stubView() }

}

@available(iOS 14.0, macOS 11.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension View {

    /// Specifies a modifier indicating the Scene this View
    /// is in can handle matching incoming External Events.
    ///
    /// If no modifier is set in any Views within a Scene, the behavior
    /// is platform dependent. On macOS, a new Scene will be created to
    /// use for the External Event. On iOS, the system will choose an
    /// existing Scene to use.
    ///
    /// On platforms that only allow a single Window/Scene, this method is
    /// ignored, and incoming External Events are always routed to the
    /// existing single Scene.
    ///
    /// - Parameter preferring: A Set of Strings that are checked to see
    /// if they are contained in the targetContentIdenfifier to see if
    /// the Scene this View is in prefers to handle the Exernal Event.
    /// The empty Set and empty Strings never match. The String value
    /// "*" always matches. The String comparisons are case/diacritic
    /// insensitive
    ///
    /// - Parameter allowing: A Set of Strings that are checked to see
    /// if they are contained in the targetContentIdenfifier to see if
    /// the Scene this View is in allows handling the External Event.
    /// The empty Set and empty Strings never match. The String value
    /// "*" always matches.
    public func handlesExternalEvents(preferring: Set<String>, allowing: Set<String>) -> some View { return stubView() }

}

#endif
