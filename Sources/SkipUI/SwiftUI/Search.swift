// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

/// The placement of a search field in a view hierarchy.
///
/// You can give a preferred placement to any of the searchable modifiers, like
/// ``View/searchable(text:placement:prompt:)-co5e``:
///
///     var body: some View {
///         NavigationView {
///             PrimaryView()
///             SecondaryView()
///             Text("Select a primary and secondary item")
///         }
///         .searchable(text: $text, placement: .sidebar)
///     }
///
/// Depending on the containing view hierachy, SkipUI might not be able to
/// fulfill your request.
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public struct SearchFieldPlacement : Sendable {

    /// SkipUI places the search field automatically.
    ///
    /// Placement of the search field depends on the platform:
    /// * In iOS, iPadOS, and macOS, the search field appears in the toolbar.
    /// * In tvOS and watchOS, the search field appears inline with its
    ///   content.
    public static let automatic: SearchFieldPlacement = { fatalError() }()

    /// The search field appears in the toolbar.
    ///
    /// The precise placement depends on the platform:
    /// * In iOS and watchOS, the search field appears below the
    ///   navigation bar and is revealed by scrolling.
    /// * In iPadOS, the search field appears in the trailing
    ///   navigation bar.
    /// * In macOS, the search field appears in the trailing toolbar.
    @available(tvOS, unavailable)
    public static let toolbar: SearchFieldPlacement = { fatalError() }()

    /// The search field appears in the sidebar of a navigation view.
    ///
    /// The precise placement depends on the platform:
    /// * In iOS and iPadOS the search field appears in the section of
    ///   the navigation bar associated with the sidebar.
    /// * In macOS, the search field appears inline with the sidebar's content.
    ///
    /// If a sidebar isn't available, like when you apply the searchable
    /// modifier to a view other than a navigation split view, SkipUI uses
    /// automatic placement instead.
    @available(tvOS, unavailable)
    @available(watchOS, unavailable)
    public static let sidebar: SearchFieldPlacement = { fatalError() }()

    /// The search field appears in the navigation bar.
    ///
    /// The field appears below any navigation bar title and uses the
    /// ``NavigationBarDrawerDisplayMode/automatic`` display mode to configure
    /// when to hide the search field. To choose a different display mode,
    /// use ``navigationBarDrawer(displayMode:)`` instead.
    @available(iOS 15.0, watchOS 8.0, *)
    @available(macOS, unavailable)
    @available(tvOS, unavailable)
    public static let navigationBarDrawer: SearchFieldPlacement = { fatalError() }()

    /// The search field appears in the navigation bar using the specified
    /// display mode.
    ///
    /// The field appears below any navigation bar title. The system can
    /// hide the field in response to scrolling, depending on the `displayMode`
    /// that you set.
    ///
    /// - Parameter displayMode: A control that indicates whether to hide
    ///   the search field in response to scrolling.
    @available(iOS 15.0, *)
    @available(macOS, unavailable)
    @available(tvOS, unavailable)
    @available(watchOS, unavailable)
    public static func navigationBarDrawer(displayMode: SearchFieldPlacement.NavigationBarDrawerDisplayMode) -> SearchFieldPlacement { fatalError() }
}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
extension SearchFieldPlacement {

    /// A mode that determines when to display a search field that appears in a
    /// navigation bar.
    @available(iOS 15.0, *)
    @available(macOS, unavailable)
    @available(tvOS, unavailable)
    @available(watchOS, unavailable)
    public struct NavigationBarDrawerDisplayMode : Sendable {

        /// Enable hiding the search field in response to scrolling.
        public static let automatic: SearchFieldPlacement.NavigationBarDrawerDisplayMode = { fatalError() }()

        /// Always display the search field regardless of the scroll activity.
        public static let always: SearchFieldPlacement.NavigationBarDrawerDisplayMode = { fatalError() }()
    }
}

/// The ways that searchable modifiers can show or hide search scopes.
@available(iOS 16.4, macOS 13.3, tvOS 16.4, watchOS 9.4, *)
public struct SearchScopeActivation {

    /// The automatic activation of the scope bar.
    ///
    /// By default, this is ``SearchScopeActivation/onTextEntry``
    /// in iOS and ``SearchScopeActivation/onSearchPresentation``
    /// in macOS.
    public static var automatic: SearchScopeActivation { get { fatalError() } }

    /// An activation where the system shows search scopes
    /// when typing begins in the search field and hides
    /// search scopes after search cancellation.
    @available(tvOS, unavailable)
    public static var onTextEntry: SearchScopeActivation { get { fatalError() } }

    /// An activation where the system shows search scopes after
    /// presenting search and hides search scopes after search
    /// cancellation.
    @available(tvOS, unavailable)
    public static var onSearchPresentation: SearchScopeActivation { get { fatalError() } }
}

/// The ways that SkipUI displays search suggestions.
///
/// You can influence which modes SkipUI displays search suggestions for by
/// using the ``View/searchSuggestions(_:for:)`` modifier:
///
///     enum FruitSuggestion: String, Identifiable {
///         case apple, banana, orange
///         var id: Self { self }
///     }
///
///     @State private var text = ""
///     @State private var suggestions: [FruitSuggestion] = []
///
///     var body: some View {
///         MainContent()
///             .searchable(text: $text) {
///                 ForEach(suggestions) { suggestion in
///                     Text(suggestion.rawValue)
///                         .searchCompletion(suggestion.rawValue)
///                 }
///                 .searchSuggestions(.hidden, for: .content)
///             }
///     }
///
/// In the above example, SkipUI only displays search suggestions in
/// a suggestions menu. You might want to do this when you want to
/// render search suggestions in a container, like inline with
/// your own set of search results.
///
/// You can get the current search suggestion placement by querying the
/// ``EnvironmentValues/searchSuggestionsPlacement`` environment value in your
/// search suggestions.
@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
public struct SearchSuggestionsPlacement : Equatable, Sendable {

    /// Search suggestions render automatically based on the surrounding
    /// context.
    ///
    /// The behavior varies by platform:
    /// * In iOS and iPadOS, suggestions render as a list overlaying the main
    ///   content of the app.
    /// * In macOS, suggestions render in a menu.
    /// * In tvOS, suggestions render as a row underneath the search field.
    /// * In watchOS, suggestions render in a list pushed onto the containing
    ///   navigation stack.
    public static var automatic: SearchSuggestionsPlacement { get { fatalError() } }

    /// Search suggestions render inside of a menu attached to the search field.
    public static var menu: SearchSuggestionsPlacement { get { fatalError() } }

    /// Search suggestions render in the main content of the app.
    public static var content: SearchSuggestionsPlacement { get { fatalError() } }

    /// An efficient set of search suggestion display modes.
    public struct Set : OptionSet, Sendable {

        /// A type for the elements of the set.
        public typealias Element = SearchSuggestionsPlacement.Set

        /// The raw value that records the search suggestion display modes.
        public var rawValue: Int { get { fatalError() } }

        /// A set containing the menu display mode.
        public static var menu: SearchSuggestionsPlacement.Set { get { fatalError() } }

        /// A set containing placements with the apps main content, excluding
        /// the menu placement.
        public static var content: SearchSuggestionsPlacement.Set { get { fatalError() } }

        /// Creates a set of search suggestions from an integer.
        public init(rawValue: Int) { fatalError() }

        /// The type of the elements of an array literal.
        public typealias ArrayLiteralElement = SearchSuggestionsPlacement.Set.Element

        /// The raw type that can be used to represent all values of the conforming
        /// type.
        ///
        /// Every distinct value of the conforming type has a corresponding unique
        /// value of the `RawValue` type, but there may be values of the `RawValue`
        /// type that don't have a corresponding value of the conforming type.
        public typealias RawValue = Int
    }

    /// Returns a Boolean value indicating whether two values are equal.
    ///
    /// Equality is the inverse of inequality. For any values `a` and `b`,
    /// `a == b` implies that `a != b` is `false`.
    ///
    /// - Parameters:
    ///   - lhs: A value to compare.
    ///   - rhs: Another value to compare.
    public static func == (a: SearchSuggestionsPlacement, b: SearchSuggestionsPlacement) -> Bool { fatalError() }
}

/// A structure that represents the body of a static placeholder search view.
///
/// You don't create this type directly. SkipUI creates it when you build
/// a search``ContentUnavailableView``.
@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
public struct SearchUnavailableContent {

    /// A view that represents the label of a static placeholder search view.
    ///
    /// You don't create this type directly. SkipUI creates it when you build
    /// a search``ContentUnavailableView``.
    public struct Label : View {

        /// The content and behavior of the view.
        ///
        /// When you implement a custom view, you must implement a computed
        /// `body` property to provide the content for your view. Return a view
        /// that's composed of built-in views that SkipUI provides, plus other
        /// composite views that you've already defined:
        ///
        ///     struct MyView: View {
        ///         var body: some View {
        ///             Text("Hello, World!")
        ///         }
        ///     }
        ///
        /// For more information about composing views and a view hierarchy,
        /// see <doc:Declaring-a-Custom-View>.
        @MainActor public var body: some View { get { return never() } }

        /// The type of view representing the body of this view.
        ///
        /// When you create a custom view, Swift infers this type from your
        /// implementation of the required ``View/body-swift.property`` property.
//        public typealias Body = some View
    }

    /// A view that represents the description of a static `ContentUnavailableView.search` view.
    ///
    /// You don't create this type directly. SkipUI creates it when you build
    /// a search``ContentUnavailableView`.
    public struct Description : View {

        /// The content and behavior of the view.
        ///
        /// When you implement a custom view, you must implement a computed
        /// `body` property to provide the content for your view. Return a view
        /// that's composed of built-in views that SkipUI provides, plus other
        /// composite views that you've already defined:
        ///
        ///     struct MyView: View {
        ///         var body: some View {
        ///             Text("Hello, World!")
        ///         }
        ///     }
        ///
        /// For more information about composing views and a view hierarchy,
        /// see <doc:Declaring-a-Custom-View>.
        @MainActor public var body: some View { get { return never() } }

        /// The type of view representing the body of this view.
        ///
        /// When you create a custom view, Swift infers this type from your
        /// implementation of the required ``View/body-swift.property`` property.
//        public typealias Body = some View
    }

    /// A view that represents the actions of a static `ContentUnavailableView.search` view.
    ///
    /// You don't create this type directly. SkipUI creates it when you build
    /// a search``ContentUnavailableView``.
    public struct Actions : View {

        /// The content and behavior of the view.
        ///
        /// When you implement a custom view, you must implement a computed
        /// `body` property to provide the content for your view. Return a view
        /// that's composed of built-in views that SkipUI provides, plus other
        /// composite views that you've already defined:
        ///
        ///     struct MyView: View {
        ///         var body: some View {
        ///             Text("Hello, World!")
        ///         }
        ///     }
        ///
        /// For more information about composing views and a view hierarchy,
        /// see <doc:Declaring-a-Custom-View>.
        @MainActor public var body: some View { get { return never() } }

        /// The type of view representing the body of this view.
        ///
        /// When you create a custom view, Swift infers this type from your
        /// implementation of the required ``View/body-swift.property`` property.
//        public typealias Body = some View
    }
}
