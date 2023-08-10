// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

/// A type that collects multiple instances of a content type --- like views,
/// scenes, or commands --- into a single unit.
///
/// Use a group to collect multiple views into a single instance, without
/// affecting the layout of those views, like an ``SkipUI/HStack``,
/// ``SkipUI/VStack``, or ``SkipUI/Section`` would. After creating a group,
/// any modifier you apply to the group affects all of that group's members.
/// For example, the following code applies the ``SkipUI/Font/headline``
/// font to three views in a group.
///
///     Group {
///         Text("SkipUI")
///         Text("Combine")
///         Text("Swift System")
///     }
///     .font(.headline)
///
/// Because you create a group of views with a ``SkipUI/ViewBuilder``, you can
/// use the group's initializer to produce different kinds of views from a
/// conditional, and then optionally apply modifiers to them. The following
/// example uses a `Group` to add a navigation bar title,
/// regardless of the type of view the conditional produces:
///
///     Group {
///         if isLoggedIn {
///             WelcomeView()
///         } else {
///             LoginView()
///         }
///     }
///     .navigationBarTitle("Start")
///
/// The modifier applies to all members of the group --- and not to the group
/// itself. For example, if you apply ``View/onAppear(perform:)`` to the above
/// group, it applies to all of the views produced by the `if isLoggedIn`
/// conditional, and it executes every time `isLoggedIn` changes.
///
/// Because a group of views itself is a view, you can compose a group within
/// other view builders, including nesting within other groups. This allows you
/// to add large numbers of views to different view builder containers. The
/// following example uses a `Group` to collect 10 ``SkipUI/Text`` instances,
/// meaning that the vertical stack's view builder returns only two views ---
/// the group, plus an additional ``SkipUI/Text``:
///
///     var body: some View {
///         VStack {
///             Group {
///                 Text("1")
///                 Text("2")
///                 Text("3")
///                 Text("4")
///                 Text("5")
///                 Text("6")
///                 Text("7")
///                 Text("8")
///                 Text("9")
///                 Text("10")
///             }
///             Text("11")
///         }
///     }
///
/// You can initialize groups with several types other than ``SkipUI/View``,
/// such as ``SkipUI/Scene`` and ``SkipUI/ToolbarContent``. The closure you
/// provide to the group initializer uses the corresponding builder type
/// (``SkipUI/SceneBuilder``, ``SkipUI/ToolbarContentBuilder``, and so on),
/// and the capabilities of these builders vary between types. For example,
/// you can use groups to return large numbers of scenes or toolbar content
/// instances, but not to return different scenes or toolbar content based
/// on conditionals.
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
@frozen public struct Group<Content> {

    /// The type for the internal content of this `AccessibilityRotorContent`.
    public typealias Body = Never
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension Group : PlatformView where Content : PlatformView {
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension Group : View where Content : View {

    /// Creates a group of views.
    /// - Parameter content: A ``SkipUI/ViewBuilder`` that produces the views
    /// to group.
    @inlinable public init(@ViewBuilder content: () -> Content) { fatalError() }
    public var body: Never { fatalError() }
}
