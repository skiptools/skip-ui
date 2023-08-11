// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

#if !SKIP

/// A mode that indicates whether the user can edit a view's content.
///
/// You receive an optional binding to the edit mode state when you
/// read the ``EnvironmentValues/editMode`` environment value. The binding
/// contains an `EditMode` value that indicates whether edit mode is active,
/// and that you can use to change the mode. To learn how to read an environment
/// value, see ``EnvironmentValues``.
///
/// Certain built-in views automatically alter their appearance and behavior
/// in edit mode. For example, a ``List`` with a ``ForEach`` that's
/// configured with the ``DynamicViewContent/onDelete(perform:)`` or
/// ``DynamicViewContent/onMove(perform:)`` modifier provides controls to
/// delete or move list items while in edit mode. On devices without an attached
/// keyboard and mouse or trackpad, people can make multiple selections in lists
/// only when edit mode is active.
///
/// You can also customize your own views to react to edit mode.
/// The following example replaces a read-only ``Text`` view with
/// an editable ``TextField``, checking for edit mode by
/// testing the wrapped value's ``EditMode/isEditing`` property:
///
///     @Environment(\.editMode) private var editMode
///     @State private var name = "Maria Ruiz"
///
///     var body: some View {
///         Form {
///             if editMode?.wrappedValue.isEditing == true {
///                 TextField("Name", text: $name)
///             } else {
///                 Text(name)
///             }
///         }
///         .animation(nil, value: editMode?.wrappedValue)
///         .toolbar { // Assumes embedding this view in a NavigationView.
///             EditButton()
///         }
///     }
///
/// You can set the edit mode through the binding, or you can
/// rely on an ``EditButton`` to do that for you, as the example above
/// demonstrates. The button activates edit mode when the user
/// taps it, and disables the mode when the user taps again.
@available(iOS 13.0, tvOS 13.0, *)
@available(macOS, unavailable)
@available(watchOS, unavailable)
public enum EditMode : Sendable {

    /// The user can't edit the view content.
    ///
    /// The ``isEditing`` property is `false` in this state.
    case inactive

    /// The view is in a temporary edit mode.
    ///
    /// The use of this state varies by platform and for different
    /// controls. As an example, SkipUI might engage temporary edit mode
    /// over the duration of a swipe gesture.
    ///
    /// The ``isEditing`` property is `true` in this state.
    case transient

    /// The user can edit the view content.
    ///
    /// The ``isEditing`` property is `true` in this state.
    case active

    /// Indicates whether a view is being edited.
    ///
    /// This property returns `true` if the mode is something other than
    /// inactive.
    public var isEditing: Bool { get { fatalError() } }

    


}

@available(iOS 13.0, tvOS 13.0, *)
@available(macOS, unavailable)
@available(watchOS, unavailable)
extension EditMode : Equatable {
}

@available(iOS 13.0, tvOS 13.0, *)
@available(macOS, unavailable)
@available(watchOS, unavailable)
extension EditMode : Hashable {
}



#endif
