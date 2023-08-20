// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

#if !SKIP

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

        @MainActor public var body: some View { get { return stubView() } }

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

        @MainActor public var body: some View { get { return stubView() } }

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

        @MainActor public var body: some View { get { return stubView() } }

        /// The type of view representing the body of this view.
        ///
        /// When you create a custom view, Swift infers this type from your
        /// implementation of the required ``View/body-swift.property`` property.
//        public typealias Body = some View
    }
}


extension View {

    /// Configures the search scopes for this view.
    ///
    /// To enable people to narrow the scope of their searches, you can
    /// create a type that represents the possible scopes, and then create a
    /// state variable to hold the current selection. For example, you can
    /// scope the product search to just fruits or just vegetables:
    ///
    ///     enum ProductScope {
    ///         case fruit
    ///         case vegetable
    ///     }
    ///
    ///     @State private var scope: ProductScope = .fruit
    ///
    /// Provide a binding to the scope, as well as a view that represents each
    /// scope:
    ///
    ///     ProductList()
    ///         .searchable(text: $text, tokens: $tokens) { token in
    ///             switch token {
    ///             case .apple: Text("Apple")
    ///             case .pear: Text("Pear")
    ///             case .banana: Text("Banana")
    ///             }
    ///         }
    ///         .searchScopes($scope) {
    ///             Text("Fruit").tag(ProductScope.fruit)
    ///             Text("Vegetable").tag(ProductScope.vegetable)
    ///         }
    ///
    /// SkipUI uses this binding and view to add a ``Picker`` with the search
    /// field. In iOS, iPadOS, macOS, and tvOS, the picker appears below the
    /// search field when search is active. To ensure that the picker operates
    /// correctly, match the type of the scope binding with the type of each
    /// view's tag. Then modify your search to account for the current value of
    /// the `scope` state property.
    ///
    /// For more information about using searchable modifiers, see
    /// <doc:Adding-a-search-interface-to-your-app>.
    ///
    /// - Parameters:
    ///   - scope: The active scope of the search field.
    ///   - scopes: A view builder that represents the scoping options
    ///     SkipUI uses to populate a ``Picker``.
    @available(iOS 16.0, macOS 13.0, tvOS 16.4, *)
    @available(watchOS, unavailable)
    public func searchScopes<V, S>(_ scope: Binding<V>, @ViewBuilder scopes: () -> S) -> some View where V : Hashable, S : View { return stubView() }

}

extension View {

    /// Configures the search scopes for this view with the specified
    /// activation strategy.
    ///
    /// To enable people to narrow the scope of their searches, you can
    /// create a type that represents the possible scopes, and then create a
    /// state variable to hold the current selection. For example, you can
    /// scope the product search to just fruits or just vegetables:
    ///
    ///     enum ProductScope {
    ///         case fruit
    ///         case vegetable
    ///     }
    ///
    ///     @State private var scope: ProductScope = .fruit
    ///
    /// Provide a binding to the scope, as well as a view that represents each
    /// scope:
    ///
    ///     ProductList()
    ///         .searchable(text: $text, tokens: $tokens) { token in
    ///             switch token {
    ///             case .apple: Text("Apple")
    ///             case .pear: Text("Pear")
    ///             case .banana: Text("Banana")
    ///             }
    ///         }
    ///         .searchScopes($scope) {
    ///             Text("Fruit").tag(ProductScope.fruit)
    ///             Text("Vegetable").tag(ProductScope.vegetable)
    ///         }
    ///
    /// SkipUI uses this binding and view to add a ``Picker`` below the search
    /// field. In iOS, macOS, and tvOS, the picker appears below the search
    /// field when search is active. To ensure that the picker operates
    /// correctly, match the type of the scope binding with the type of each
    /// view's tag. Then condition your search on the current value of the
    /// `scope` state property.
    ///
    /// By default, the appearance of scopes varies by platform:
    ///   - In iOS and iPadOS, search scopes appear when someone enters text
    ///     into the search field and disappear when someone cancels the search.
    ///   - In macOS, search scopes appear when SkipUI presents search and
    ///     disappear when someone cancels the search.
    ///
    /// However, you can use the `activation` parameter with a value of
    /// ``SearchScopeActivation/onTextEntry`` or
    /// ``SearchScopeActivation/onSearchPresentation`` to configure this
    /// behavior:
    ///
    ///     .searchScopes($scope, activation: .onSearchPresentation) {
    ///         Text("Fruit").tag(ProductScope.fruit)
    ///         Text("Vegetable").tag(ProductScope.vegetable)
    ///     }
    ///
    /// For more information about using searchable modifiers, see
    /// <doc:Adding-a-search-interface-to-your-app>.
    ///
    /// - Parameters:
    ///   - scope: The active scope of the search field.
    ///   - activation: The activation style of the search field's scopes.
    ///   - scopes: A view builder that represents the scoping options
    ///     SkipUI uses to populate a ``Picker``.
    @available(iOS 16.4, macOS 13.3, tvOS 16.4, *)
    @available(watchOS, unavailable)
    public func searchScopes<V, S>(_ scope: Binding<V>, activation: SearchScopeActivation, @ViewBuilder _ scopes: () -> S) -> some View where V : Hashable, S : View { return stubView() }

}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
extension View {

    /// Associates a fully formed string with the value of this view.
    ///
    /// Use this method to associate a fully formed string with a
    /// view that is within a search suggestion list context. The system
    /// uses this value when the view is selected to replace the
    /// partial text being currently edited of the associated search field.
    ///
    /// On tvOS, the string that you provide to the this modifier is
    /// used when displaying the associated suggestion and when
    /// replacing the partial text of the search field.
    ///
    ///     SearchPlaceholderView()
    ///         .searchable(text: $text) {
    ///             Text("🍎").searchCompletion("apple")
    ///             Text("🍐").searchCompletion("pear")
    ///             Text("🍌").searchCompletion("banana")
    ///         }
    ///
    /// - Parameters:
    ///   - text: A string to use as the view’s completion.
    public func searchCompletion(_ completion: String) -> some View { return stubView() }

}

extension View {

    /// Associates a search token with the value of this view.
    ///
    /// Use this method to associate a search token with a view that is
    /// within a search suggestion list context. The system uses this value
    /// when the view is selected to replace the partial text being currently
    /// edited of the associated search field.
    ///
    ///     enum FruitToken: Hashable, Identifiable, CaseIterable {
    ///         case apple
    ///         case pear
    ///         case banana
    ///
    ///         var id: Self { self }
    ///     }
    ///
    ///     @State private var text = ""
    ///     @State private var tokens: [FruitToken] = []
    ///
    ///     SearchPlaceholderView()
    ///         .searchable(text: $text, tokens: $tokens) { token in
    ///             switch token {
    ///             case .apple: Text("Apple")
    ///             case .pear: Text("Pear")
    ///             case .banana: Text("Banana")
    ///             }
    ///         }
    ///         .searchSuggestions {
    ///             Text("🍎").searchCompletion(FruitToken.apple)
    ///             Text("🍐").searchCompletion(FruitToken.pear)
    ///             Text("🍌").searchCompletion(FruitToken.banana)
    ///         }
    ///
    /// - Parameters:
    ///   - token: Data to use as the view’s completion.
    @available(iOS 16.0, macOS 13.0, *)
    @available(tvOS, unavailable)
    @available(watchOS, unavailable)
    public func searchCompletion<T>(_ token: T) -> some View where T : Identifiable { return stubView() }


    /// Configures how to display search suggestions within this view.
    ///
    /// SkipUI presents search suggestions differently depending on several
    /// factors, like the platform, the position of the search field, and the
    /// size class. Use this modifier when you want to only display suggestions
    /// in certain ways under certain conditions. For example, you might choose
    /// to display suggestions in a menu when possible, but directly filter
    /// your data source otherwise.
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
    ///                 ForEach(suggestions) { suggestion
    ///                     Text(suggestion.rawValue)
    ///                         .searchCompletion(suggestion.rawValue)
    ///                 }
    ///                 .searchSuggestions(.hidden, for: .content)
    ///             }
    ///     }
    ///
    /// - Parameters:
    ///   - visibility: The visibility of the search suggestions
    ///     for the specified locations.
    ///   - placements: The set of locations in which to set the visibility of
    ///     search suggestions.
    @available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
    public func searchSuggestions(_ visibility: Visibility, for placements: SearchSuggestionsPlacement.Set) -> some View { return stubView() }

}

extension View {

    /// Configures the search suggestions for this view.
    ///
    /// You can suggest search terms during a search operation by providing a
    /// collection of view to this modifier. The interface presents the
    /// suggestion views as a list of choices when someone activates the
    /// search interface. Associate a string with each suggestion
    /// view by adding the ``View/searchCompletion(_:)-2uaf3`` modifier to
    /// the view. For example, you can suggest fruit types by displaying their
    /// emoji, and provide the corresponding search string as a search
    /// completion in each case:
    ///
    ///     ProductList()
    ///         .searchable(text: $text)
    ///         .searchSuggestions {
    ///             Text("🍎").searchCompletion("apple")
    ///             Text("🍐").searchCompletion("pear")
    ///             Text("🍌").searchCompletion("banana")
    ///         }
    ///
    /// When someone chooses a suggestion, SkipUI replaces the text in the
    /// search field with the search completion string. If you omit the search
    /// completion modifier for a particular suggestion view, SkipUI displays
    /// the suggestion, but the suggestion view doesn't react to taps or clicks.
    ///
    /// > Important: In tvOS, searchable modifiers only support suggestion views
    /// of type ``Text``, like in the above example. Other platforms can use any
    /// view for the suggestions, including custom views.
    ///
    /// You can update the suggestions that you provide as conditions change.
    ///
    /// For example, you can specify an array of suggestions that you store
    /// in a model:
    ///
    ///     ProductList()
    ///         .searchable(text: $text)
    ///         .searchSuggestions {
    ///             ForEach(model.suggestedSearches) { suggestion in
    ///                 Label(suggestion.title,  image: suggestion.image)
    ///                     .searchCompletion(suggestion.text)
    ///             }
    ///         }
    ///
    /// If the model's `suggestedSearches` begins as an empty array, the
    /// interface doesn't display any suggestions to start. You can then provide
    /// logic that updates the array based on some condition. For example, you
    /// might update the completions based on the current search text. Note that
    /// certain events or actions, like when someone moves a macOS window, might
    /// dismiss the suggestion view.
    ///
    /// For more information about using search modifiers, see
    /// <doc:Adding-a-search-interface-to-your-app>.
    ///
    /// - Parameters:
    ///   - suggestions: A view builder that produces content that
    ///     populates a list of suggestions.
    @available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
    public func searchSuggestions<S>(@ViewBuilder _ suggestions: () -> S) -> some View where S : View { return stubView() }

}

extension View {

    /// Marks this view as searchable, which configures the display of a
    /// search field.
    ///
    /// For more information about using searchable modifiers, see
    /// <doc:Adding-a-search-interface-to-your-app>.
    ///
    /// - Parameters:
    ///   - text: The text to display and edit in the search field.
    ///   - placement: Where the search field should attempt to be
    ///     placed based on the containing view hierarchy.
    ///   - prompt: A ``Text`` view representing the prompt of the search field
    ///     which provides users with guidance on what to search for.
    ///   - suggestions: A view builder that produces content that
    ///     populates a list of suggestions.
    @available(iOS, introduced: 15.0, deprecated: 100000.0, message: "Use the searchable modifier with the searchSuggestions modifier")
    @available(macOS, introduced: 12.0, deprecated: 100000.0, message: "Use the searchable modifier with the searchSuggestions modifier")
    @available(tvOS, introduced: 15.0, deprecated: 100000.0, message: "Use the searchable modifier with the searchSuggestions modifier")
    @available(watchOS, introduced: 8.0, deprecated: 100000.0, message: "Use the searchable modifier with the searchSuggestions modifier")
    public func searchable<S>(text: Binding<String>, placement: SearchFieldPlacement = .automatic, prompt: Text? = nil, @ViewBuilder suggestions: () -> S) -> some View where S : View { return stubView() }


    /// Marks this view as searchable, which configures the display of a
    /// search field.
    ///
    /// For more information about using searchable modifiers, see
    /// <doc:Adding-a-search-interface-to-your-app>.
    ///
    /// - Parameters:
    ///   - text: The text to display and edit in the search field.
    ///   - placement: Where the search field should attempt to be
    ///     placed based on the containing view hierarchy.
    ///   - prompt: A key for the localized prompt of the search field
    ///     which provides users with guidance on what to search for.
    ///   - suggestions: A view builder that produces content that
    ///     populates a list of suggestions.
    @available(iOS, introduced: 15.0, deprecated: 100000.0, message: "Use the searchable modifier with the searchSuggestions modifier")
    @available(macOS, introduced: 12.0, deprecated: 100000.0, message: "Use the searchable modifier with the searchSuggestions modifier")
    @available(tvOS, introduced: 15.0, deprecated: 100000.0, message: "Use the searchable modifier with the searchSuggestions modifier")
    @available(watchOS, introduced: 8.0, deprecated: 100000.0, message: "Use the searchable modifier with the searchSuggestions modifier")
    public func searchable<S>(text: Binding<String>, placement: SearchFieldPlacement = .automatic, prompt: LocalizedStringKey, @ViewBuilder suggestions: () -> S) -> some View where S : View { return stubView() }


    /// Marks this view as searchable, which configures the display of a
    /// search field.
    ///
    /// For more information about using searchable modifiers, see
    /// <doc:Adding-a-search-interface-to-your-app>.
    ///
    /// - Parameters:
    ///   - text: The text to display and edit in the search field.
    ///   - placement: Where the search field should attempt to be
    ///     placed based on the containing view hierarchy.
    ///   - prompt: A string representing the prompt of the search field
    ///     which provides users with guidance on what to search for.
    ///   - suggestions: A view builder that produces content that
    ///     populates a list of suggestions.
    @available(iOS, introduced: 15.0, deprecated: 100000.0, message: "Use the searchable modifier with the searchSuggestions modifier")
    @available(macOS, introduced: 12.0, deprecated: 100000.0, message: "Use the searchable modifier with the searchSuggestions modifier")
    @available(tvOS, introduced: 15.0, deprecated: 100000.0, message: "Use the searchable modifier with the searchSuggestions modifier")
    @available(watchOS, introduced: 8.0, deprecated: 100000.0, message: "Use the searchable modifier with the searchSuggestions modifier")
    public func searchable<V, S>(text: Binding<String>, placement: SearchFieldPlacement = .automatic, prompt: S, @ViewBuilder suggestions: () -> V) -> some View where V : View, S : StringProtocol { return stubView() }

}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
extension View {

    /// Marks this view as searchable, which configures the display of a
    /// search field.
    ///
    /// For more information about using searchable modifiers, see
    /// <doc:Adding-a-search-interface-to-your-app>.
    ///
    /// - Parameters:
    ///   - text: The text to display and edit in the search field.
    ///   - placement: The preferred placement of the search field within the
    ///     containing view hierarchy.
    ///   - prompt: A ``Text`` view representing the prompt of the search field
    ///     which provides users with guidance on what to search for.
    public func searchable(text: Binding<String>, placement: SearchFieldPlacement = .automatic, prompt: Text? = nil) -> some View { return stubView() }


    /// Marks this view as searchable, which configures the display of a
    /// search field.
    ///
    /// For more information about using searchable modifiers, see
    /// <doc:Adding-a-search-interface-to-your-app>.
    ///
    /// - Parameters:
    ///   - text: The text to display and edit in the search field.
    ///   - placement: The preferred placement of the search field within the
    ///     containing view hierarchy.
    ///   - prompt: The key for the localized prompt of the search field
    ///     which provides users with guidance on what to search for.
    public func searchable(text: Binding<String>, placement: SearchFieldPlacement = .automatic, prompt: LocalizedStringKey) -> some View { return stubView() }


    /// Marks this view as searchable, which configures the display of a
    /// search field.
    ///
    /// For more information about using searchable modifiers, see
    /// <doc:Adding-a-search-interface-to-your-app>.
    ///
    /// - Parameters:
    ///   - text: The text to display and edit in the search field.
    ///   - placement: The preferred placement of the search field within the
    ///     containing view hierarchy.
    ///   - prompt: A string representing the prompt of the search field
    ///     which provides users with guidance on what to search for.
    public func searchable<S>(text: Binding<String>, placement: SearchFieldPlacement = .automatic, prompt: S) -> some View where S : StringProtocol { return stubView() }

}

extension View {

    /// Marks this view as searchable with programmatic presentation of the
    /// search field.
    ///
    /// For more information about using searchable modifiers, see
    /// <doc:Adding-a-search-interface-to-your-app>.
    /// For information about presenting a search field programmatically, see
    /// <doc:Managing-search-interface-activation>.
    ///
    /// - Parameters:
    ///   - text: The text to display and edit in the search field.
    ///   - isPresenting: A ``Binding`` that controls the presented state
    ///     of search.
    ///   - placement: The preferred placement of the search field within the
    ///     containing view hierarchy.
    ///   - prompt: A ``Text`` view representing the prompt of the search field
    ///     which provides users with guidance on what to search for.
    @available(iOS 17.0, macOS 14.0, *)
    @available(tvOS, unavailable)
    @available(watchOS, unavailable)
    public func searchable(text: Binding<String>, isPresented: Binding<Bool>, placement: SearchFieldPlacement = .automatic, prompt: Text? = nil) -> some View { return stubView() }


    /// Marks this view as searchable with programmatic presentation of the
    /// search field.
    ///
    /// For more information about using searchable modifiers, see
    /// <doc:Adding-a-search-interface-to-your-app>.
    /// For information about presenting a search field programmatically, see
    /// <doc:Managing-search-interface-activation>.
    ///
    /// - Parameters:
    ///   - text: The text to display and edit in the search field.
    ///   - isPresenting: A ``Binding`` that controls the presented state
    ///     of search.
    ///   - placement: The preferred placement of the search field within the
    ///     containing view hierarchy.
    ///   - prompt: The key for the localized prompt of the search field
    ///     which provides users with guidance on what to search for.
    @available(iOS 17.0, macOS 14.0, *)
    @available(tvOS, unavailable)
    @available(watchOS, unavailable)
    public func searchable(text: Binding<String>, isPresented: Binding<Bool>, placement: SearchFieldPlacement = .automatic, prompt: LocalizedStringKey) -> some View { return stubView() }


    /// Marks this view as searchable with programmatic presentation of the
    /// search field.
    ///
    /// For more information about using searchable modifiers, see
    /// <doc:Adding-a-search-interface-to-your-app>.
    /// For information about presenting a search field programmatically, see
    /// <doc:Managing-search-interface-activation>.
    ///
    /// - Parameters:
    ///   - text: The text to display and edit in the search field.
    ///   - isPresenting: A ``Binding`` that controls the presented state
    ///     of search.
    ///   - placement: The preferred placement of the search field within the
    ///     containing view hierarchy.
    ///   - prompt: A string representing the prompt of the search field
    ///     which provides users with guidance on what to search for.
    @available(iOS 17.0, macOS 14.0, *)
    @available(tvOS, unavailable)
    @available(watchOS, unavailable)
    public func searchable<S>(text: Binding<String>, isPresented: Binding<Bool>, placement: SearchFieldPlacement = .automatic, prompt: S) -> some View where S : StringProtocol { return stubView() }

}

extension View {

    /// Marks this view as searchable with text and tokens.
    ///
    /// For more information about using searchable modifiers, see
    /// <doc:Adding-a-search-interface-to-your-app>.
    ///
    /// - Parameters:
    ///   - text: The text to display and edit in the search field.
    ///   - tokens: A collection of tokens to display and edit in the
    ///     search field.
    ///   - placement: The preferred placement of the search field within the
    ///     containing view hierarchy.
    ///   - prompt: A ``Text`` view representing the prompt of the search field
    ///     which provides users with guidance on what to search for.
    ///   - token: A view builder that creates a view given an element in
    ///     tokens.
    @available(iOS 16.0, macOS 13.0, *)
    @available(tvOS, unavailable)
    @available(watchOS, unavailable)
    public func searchable<C, T>(text: Binding<String>, tokens: Binding<C>, placement: SearchFieldPlacement = .automatic, prompt: Text? = nil, @ViewBuilder token: @escaping (C.Element) -> T) -> some View where C : RandomAccessCollection, C : RangeReplaceableCollection, T : View, C.Element : Identifiable { return stubView() }


    /// Marks this view as searchable, which configures the display of a
    /// search field.
    ///
    /// For more information about using searchable modifiers, see
    /// <doc:Adding-a-search-interface-to-your-app>.
    ///
    /// - Parameters:
    ///   - text: The text to display and edit in the search field.
    ///   - editableTokens: A collection of tokens to display and edit in the
    ///     search field.
    ///   - placement: The preferred placement of the search field within the
    ///     containing view hierarchy.
    ///   - prompt: A ``Text`` view representing the prompt of the search field
    ///     which provides users with guidance on what to search for.
    ///   - token: A view builder that creates a view given an element in
    ///     tokens.
    @available(iOS 17.0, macOS 14.0, *)
    @available(tvOS, unavailable)
    @available(watchOS, unavailable)
    public func searchable<C>(text: Binding<String>, editableTokens: Binding<C>, placement: SearchFieldPlacement = .automatic, prompt: Text? = nil, @ViewBuilder token: @escaping (Binding<C.Element>) -> some View) -> some View where C : RandomAccessCollection, C : RangeReplaceableCollection, C.Element : Identifiable { return stubView() }


    /// Marks this view as searchable with text and tokens.
    ///
    /// For more information about using searchable modifiers, see
    /// <doc:Adding-a-search-interface-to-your-app>.
    ///
    /// - Parameters:
    ///   - text: The text to display and edit in the search field.
    ///   - tokens: A collection of tokens to display and edit in the
    ///     search field.
    ///   - placement: The preferred placement of the search field within the
    ///     containing view hierarchy.
    ///   - prompt: The key for the localized prompt of the search field
    ///     which provides users with guidance on what to search for.
    ///   - token: A view builder that creates a view given an element in
    ///     tokens.
    @available(iOS 16.0, macOS 13.0, *)
    @available(tvOS, unavailable)
    @available(watchOS, unavailable)
    public func searchable<C, T>(text: Binding<String>, tokens: Binding<C>, placement: SearchFieldPlacement = .automatic, prompt: LocalizedStringKey, @ViewBuilder token: @escaping (C.Element) -> T) -> some View where C : RandomAccessCollection, C : RangeReplaceableCollection, T : View, C.Element : Identifiable { return stubView() }


    /// Marks this view as searchable, which configures the display of a
    /// search field.
    ///
    /// For more information about using searchable modifiers, see
    /// <doc:Adding-a-search-interface-to-your-app>.
    ///
    /// - Parameters:
    ///   - text: The text to display and edit in the search field.
    ///   - editableTokens: A collection of tokens to display and edit in the
    ///     search field.
    ///   - placement: The preferred placement of the search field within the
    ///     containing view hierarchy.
    ///   - prompt: The key for the localized prompt of the search field
    ///     which provides users with guidance on what to search for.
    ///   - token: A view builder that creates a view given an element in
    ///     tokens.
    @available(iOS 17.0, macOS 14.0, *)
    @available(tvOS, unavailable)
    @available(watchOS, unavailable)
    public func searchable<C>(text: Binding<String>, editableTokens: Binding<C>, placement: SearchFieldPlacement = .automatic, prompt: LocalizedStringKey, @ViewBuilder token: @escaping (Binding<C.Element>) -> some View) -> some View where C : RandomAccessCollection, C : RangeReplaceableCollection, C.Element : Identifiable { return stubView() }


    /// Marks this view as searchable with text and tokens.
    ///
    /// For more information about using searchable modifiers, see
    /// <doc:Adding-a-search-interface-to-your-app>.
    ///
    /// - Parameters:
    ///   - text: The text to display and edit in the search field.
    ///   - tokens: A collection of tokens to display and edit in the
    ///     search field.
    ///   - placement: The preferred placement of the search field within the
    ///     containing view hierarchy.
    ///   - prompt: A string representing the prompt of the search field
    ///     which provides users with guidance on what to search for.
    ///   - token: A view builder that creates a view given an element in
    ///     tokens.
    @available(iOS 16.0, macOS 13.0, *)
    @available(tvOS, unavailable)
    @available(watchOS, unavailable)
    public func searchable<C, T, S>(text: Binding<String>, tokens: Binding<C>, placement: SearchFieldPlacement = .automatic, prompt: S, @ViewBuilder token: @escaping (C.Element) -> T) -> some View where C : RandomAccessCollection, C : RangeReplaceableCollection, T : View, S : StringProtocol, C.Element : Identifiable { return stubView() }


    /// Marks this view as searchable, which configures the display of a
    /// search field.
    ///
    /// For more information about using searchable modifiers, see
    /// <doc:Adding-a-search-interface-to-your-app>.
    ///
    /// - Parameters:
    ///   - text: The text to display and edit in the search field.
    ///   - editableTokens: A collection of tokens to display and edit in the
    ///     search field.
    ///   - placement: The preferred placement of the search field within the
    ///     containing view hierarchy.
    ///   - prompt: A string representing the prompt of the search field
    ///     which provides users with guidance on what to search for.
    ///   - token: A view builder that creates a view given an element in
    ///     tokens.
    @available(iOS 17.0, macOS 14.0, *)
    @available(tvOS, unavailable)
    @available(watchOS, unavailable)
    public func searchable<C>(text: Binding<String>, editableTokens: Binding<C>, placement: SearchFieldPlacement = .automatic, prompt: some StringProtocol, @ViewBuilder token: @escaping (Binding<C.Element>) -> some View) -> some View where C : RandomAccessCollection, C : RangeReplaceableCollection, C.Element : Identifiable { return stubView() }

}

extension View {

    /// Marks this view as searchable with text and tokens, as well as
    /// programmatic presentation.
    ///
    /// For more information about using searchable modifiers, see
    /// <doc:Adding-a-search-interface-to-your-app>.
    /// For information about presenting a search field programmatically, see
    /// <doc:Managing-search-interface-activation>.
    ///
    /// - Parameters:
    ///   - text: The text to display and edit in the search field.
    ///   - tokens: A collection of tokens to display and edit in the
    ///     search field.
    ///   - isPresenting: A ``Binding`` that controls the presented state
    ///     of search.
    ///   - placement: The preferred placement of the search field within the
    ///     containing view hierarchy.
    ///   - prompt: A ``Text`` view representing the prompt of the search field
    ///     which provides users with guidance on what to search for.
    ///   - token: A view builder that creates a view given an element in
    ///     tokens.
    @available(iOS 17.0, macOS 14.0, *)
    @available(tvOS, unavailable)
    @available(watchOS, unavailable)
    public func searchable<C, T>(text: Binding<String>, tokens: Binding<C>, isPresented: Binding<Bool>, placement: SearchFieldPlacement = .automatic, prompt: Text? = nil, @ViewBuilder token: @escaping (C.Element) -> T) -> some View where C : RandomAccessCollection, C : RangeReplaceableCollection, T : View, C.Element : Identifiable { return stubView() }


    /// Marks this view as searchable, which configures the display of a
    /// search field.
    ///
    /// For more information about using searchable modifiers, see
    /// <doc:Adding-a-search-interface-to-your-app>.
    ///
    /// - Parameters:
    ///   - text: The text to display and edit in the search field.
    ///   - editableTokens: A collection of tokens to display and edit in the
    ///     search field.
    ///   - isPresenting: A ``Binding`` which controls the presented state
    ///     of search.
    ///   - placement: The preferred placement of the search field within the
    ///     containing view hierarchy.
    ///   - prompt: A ``Text`` view representing the prompt of the search field
    ///     which provides users with guidance on what to search for.
    ///   - token: A view builder that creates a view given an element in
    ///     tokens.
    @available(iOS 17.0, macOS 14.0, *)
    @available(tvOS, unavailable)
    @available(watchOS, unavailable)
    public func searchable<C>(text: Binding<String>, editableTokens: Binding<C>, isPresented: Binding<Bool>, placement: SearchFieldPlacement = .automatic, prompt: Text? = nil, @ViewBuilder token: @escaping (Binding<C.Element>) -> some View) -> some View where C : RandomAccessCollection, C : RangeReplaceableCollection, C.Element : Identifiable { return stubView() }


    /// Marks this view as searchable with text and tokens, as well as
    /// programmatic presentation.
    ///
    /// For more information about using searchable modifiers, see
    /// <doc:Adding-a-search-interface-to-your-app>.
    /// For information about presenting a search field programmatically, see
    /// <doc:Managing-search-interface-activation>.
    ///
    /// - Parameters:
    ///   - text: The text to display and edit in the search field.
    ///   - tokens: A collection of tokens to display and edit in the
    ///     search field.
    ///   - isPresenting: A ``Binding`` that controls the presented state
    ///     of search.
    ///   - placement: The preferred placement of the search field within the
    ///     containing view hierarchy.
    ///   - prompt: The key for the localized prompt of the search field
    ///     which provides users with guidance on what to search for.
    ///   - token: A view builder that creates a view given an element in
    ///     tokens.
    @available(iOS 17.0, macOS 14.0, *)
    @available(tvOS, unavailable)
    @available(watchOS, unavailable)
    public func searchable<C, T>(text: Binding<String>, tokens: Binding<C>, isPresented: Binding<Bool>, placement: SearchFieldPlacement = .automatic, prompt: LocalizedStringKey, @ViewBuilder token: @escaping (C.Element) -> T) -> some View where C : RandomAccessCollection, C : RangeReplaceableCollection, T : View, C.Element : Identifiable { return stubView() }


    /// Marks this view as searchable, which configures the display of a
    /// search field.
    ///
    /// For more information about using searchable modifiers, see
    /// <doc:Adding-a-search-interface-to-your-app>.
    ///
    /// - Parameters:
    ///   - text: The text to display and edit in the search field.
    ///   - editableTokens: A collection of tokens to display and edit in the
    ///     search field.
    ///   - isPresenting: A ``Binding`` which controls the presented state
    ///     of search.
    ///   - placement: The preferred placement of the search field within the
    ///     containing view hierarchy.
    ///   - prompt: The key for the localized prompt of the search field
    ///     which provides users with guidance on what to search for.
    ///   - token: A view builder that creates a view given an element in
    ///     tokens.
    @available(iOS 17.0, macOS 14.0, *)
    @available(tvOS, unavailable)
    @available(watchOS, unavailable)
    public func searchable<C>(text: Binding<String>, editableTokens: Binding<C>, isPresented: Binding<Bool>, placement: SearchFieldPlacement = .automatic, prompt: LocalizedStringKey, @ViewBuilder token: @escaping (Binding<C.Element>) -> some View) -> some View where C : RandomAccessCollection, C : RangeReplaceableCollection, C.Element : Identifiable { return stubView() }


    /// Marks this view as searchable with text and tokens, as well as
    /// programmatic presentation.
    ///
    /// For more information about using searchable modifiers, see
    /// <doc:Adding-a-search-interface-to-your-app>.
    /// For information about presenting a search field programmatically, see
    /// <doc:Managing-search-interface-activation>.
    ///
    /// - Parameters:
    ///   - text: The text to display and edit in the search field.
    ///   - tokens: A collection of tokens to display and edit in the
    ///     search field.
    ///   - isPresenting: A ``Binding`` that controls the presented state
    ///     of search.
    ///   - placement: The preferred placement of the search field within the
    ///     containing view hierarchy.
    ///   - prompt: A string representing the prompt of the search field
    ///     which provides users with guidance on what to search for.
    ///   - token: A view builder that creates a view given an element in
    ///     tokens.
    @available(iOS 17.0, macOS 14.0, *)
    @available(tvOS, unavailable)
    @available(watchOS, unavailable)
    public func searchable<C, T, S>(text: Binding<String>, tokens: Binding<C>, isPresented: Binding<Bool>, placement: SearchFieldPlacement = .automatic, prompt: S, @ViewBuilder token: @escaping (C.Element) -> T) -> some View where C : RandomAccessCollection, C : RangeReplaceableCollection, T : View, S : StringProtocol, C.Element : Identifiable { return stubView() }


    /// Marks this view as searchable, which configures the display of a
    /// search field.
    ///
    /// For more information about using searchable modifiers, see
    /// <doc:Adding-a-search-interface-to-your-app>.
    ///
    /// - Parameters:
    ///   - text: The text to display and edit in the search field.
    ///   - editableTokens: A collection of tokens to display and edit in the
    ///     search field.
    ///   - isPresenting: A ``Binding`` which controls the presented state
    ///     of search.
    ///   - placement: The preferred placement of the search field within the
    ///     containing view hierarchy.
    ///   - prompt: A string representing the prompt of the search field
    ///     which provides users with guidance on what to search for.
    ///   - token: A view builder that creates a view given an element in
    ///     tokens.
    @available(iOS 17.0, macOS 14.0, *)
    @available(tvOS, unavailable)
    @available(watchOS, unavailable)
    public func searchable<C>(text: Binding<String>, editableTokens: Binding<C>, isPresented: Binding<Bool>, placement: SearchFieldPlacement = .automatic, prompt: some StringProtocol, @ViewBuilder token: @escaping (Binding<C.Element>) -> some View) -> some View where C : RandomAccessCollection, C : RangeReplaceableCollection, C.Element : Identifiable { return stubView() }

}

extension View {

    /// Marks this view as searchable with text, tokens, and suggestions.
    ///
    /// For more information about using searchable modifiers, see
    /// <doc:Adding-a-search-interface-to-your-app>.
    ///
    /// - Parameters:
    ///   - text: The text to display and edit in the search field.
    ///   - tokens: A collection of tokens to display and edit in the
    ///     search field.
    ///   - suggestedTokens: A collection of tokens to display as suggestions.
    ///   - placement: The preferred placement of the search field within the
    ///     containing view hierarchy.
    ///   - prompt: A ``Text`` view representing the prompt of the search field
    ///     which provides users with guidance on what to search for.
    ///   - token: A view builder that creates a view given an element in
    ///     tokens.
    @available(iOS 16.0, macOS 13.0, *)
    @available(tvOS, unavailable)
    @available(watchOS, unavailable)
    public func searchable<C, T>(text: Binding<String>, tokens: Binding<C>, suggestedTokens: Binding<C>, placement: SearchFieldPlacement = .automatic, prompt: Text? = nil, @ViewBuilder token: @escaping (C.Element) -> T) -> some View where C : MutableCollection, C : RandomAccessCollection, C : RangeReplaceableCollection, T : View, C.Element : Identifiable { return stubView() }


    /// Marks this view as searchable with text, tokens, and suggestions.
    ///
    /// For more information about using searchable modifiers, see
    /// <doc:Adding-a-search-interface-to-your-app>.
    ///
    /// - Parameters:
    ///   - text: The text to display and edit in the search field.
    ///   - tokens: A collection of tokens to display and edit in the
    ///     search field.
    ///   - suggestedTokens: A collection of tokens to display as suggestions.
    ///   - placement: The preferred placement of the search field within the
    ///     containing view hierarchy.
    ///   - prompt: The key for the localized prompt of the search field
    ///     which provides users with guidance on what to search for.
    ///   - token: A view builder that creates a view given an element in
    ///     tokens.
    @available(iOS 16.0, macOS 13.0, *)
    @available(tvOS, unavailable)
    @available(watchOS, unavailable)
    public func searchable<C, T>(text: Binding<String>, tokens: Binding<C>, suggestedTokens: Binding<C>, placement: SearchFieldPlacement = .automatic, prompt: LocalizedStringKey, @ViewBuilder token: @escaping (C.Element) -> T) -> some View where C : MutableCollection, C : RandomAccessCollection, C : RangeReplaceableCollection, T : View, C.Element : Identifiable { return stubView() }


    /// Marks this view as searchable with text, tokens, and suggestions.
    ///
    /// For more information about using searchable modifiers, see
    /// <doc:Adding-a-search-interface-to-your-app>.
    ///
    /// - Parameters:
    ///   - text: The text to display and edit in the search field.
    ///   - tokens: A collection of tokens to display and edit in the
    ///     search field.
    ///   - suggestedTokens: A collection of tokens to display as suggestions.
    ///   - placement: The preferred placement of the search field within the
    ///     containing view hierarchy.
    ///   - prompt: A string representing the prompt of the search field
    ///     which provides users with guidance on what to search for.
    ///   - token: A view builder that creates a view given an element in
    ///     tokens.
    @available(iOS 16.0, macOS 13.0, *)
    @available(tvOS, unavailable)
    @available(watchOS, unavailable)
    public func searchable<C, T, S>(text: Binding<String>, tokens: Binding<C>, suggestedTokens: Binding<C>, placement: SearchFieldPlacement = .automatic, prompt: S, @ViewBuilder token: @escaping (C.Element) -> T) -> some View where C : MutableCollection, C : RandomAccessCollection, C : RangeReplaceableCollection, T : View, S : StringProtocol, C.Element : Identifiable { return stubView() }


    /// Marks this view as searchable with text, tokens, and suggestions, as
    /// well as programmatic presentation.
    ///
    /// For more information about using searchable modifiers, see
    /// <doc:Adding-a-search-interface-to-your-app>.
    /// For information about presenting a search field programmatically, see
    /// <doc:Managing-search-interface-activation>.
    ///
    /// - Parameters:
    ///   - text: The text to display and edit in the search field.
    ///   - tokens: A collection of tokens to display and edit in the
    ///     search field.
    ///   - suggestedTokens: A collection of tokens to display as suggestions.
    ///   - isPresenting: A ``Binding`` that controls the presented state
    ///     of search.
    ///   - placement: The preferred placement of the search field within the
    ///     containing view hierarchy.
    ///   - prompt: A ``Text`` view representing the prompt of the search field
    ///     which provides users with guidance on what to search for.
    ///   - token: A view builder that creates a view given an element in
    ///     tokens.
    @available(iOS 17.0, macOS 14.0, *)
    @available(tvOS, unavailable)
    @available(watchOS, unavailable)
    public func searchable<C, T>(text: Binding<String>, tokens: Binding<C>, suggestedTokens: Binding<C>, isPresented: Binding<Bool>, placement: SearchFieldPlacement = .automatic, prompt: Text? = nil, @ViewBuilder token: @escaping (C.Element) -> T) -> some View where C : RandomAccessCollection, C : RangeReplaceableCollection, T : View, C.Element : Identifiable { return stubView() }


    /// Marks this view as searchable with text, tokens, and suggestions, as
    /// well as programmatic presentation.
    ///
    /// For more information about using searchable modifiers, see
    /// <doc:Adding-a-search-interface-to-your-app>.
    /// For information about presenting a search field programmatically, see
    /// <doc:Managing-search-interface-activation>.
    ///
    /// - Parameters:
    ///   - text: The text to display and edit in the search field.
    ///   - tokens: A collection of tokens to display and edit in the
    ///     search field.
    ///   - suggestedTokens: A collection of tokens to display as suggestions.
    ///   - isPresenting: A ``Binding`` that controls the presented state
    ///     of search.
    ///   - placement: The preferred placement of the search field within the
    ///     containing view hierarchy.
    ///   - prompt: The key for the localized prompt of the search field
    ///     which provides users with guidance on what to search for.
    ///   - token: A view builder that creates a view given an element in
    ///     tokens.
    @available(iOS 17.0, macOS 14.0, *)
    @available(tvOS, unavailable)
    @available(watchOS, unavailable)
    public func searchable<C, T>(text: Binding<String>, tokens: Binding<C>, suggestedTokens: Binding<C>, isPresented: Binding<Bool>, placement: SearchFieldPlacement = .automatic, prompt: LocalizedStringKey, @ViewBuilder token: @escaping (C.Element) -> T) -> some View where C : RandomAccessCollection, C : RangeReplaceableCollection, T : View, C.Element : Identifiable { return stubView() }


    /// Marks this view as searchable with text, tokens, and suggestions, as
    /// well as programmatic presentation.
    ///
    /// For more information about using searchable modifiers, see
    /// <doc:Adding-a-search-interface-to-your-app>.
    /// For information about presenting a search field programmatically, see
    /// <doc:Managing-search-interface-activation>.
    ///
    /// - Parameters:
    ///   - text: The text to display and edit in the search field.
    ///   - tokens: A collection of tokens to display and edit in the
    ///     search field.
    ///   - suggestedTokens: A collection of tokens to display as suggestions.
    ///   - isPresenting: A ``Binding`` that controls the presented state
    ///     of search.
    ///   - placement: The preferred placement of the search field within the
    ///     containing view hierarchy.
    ///   - prompt: A string representing the prompt of the search field
    ///     which provides users with guidance on what to search for.
    ///   - token: A view builder that creates a view given an element in
    ///     tokens.
    @available(iOS 17.0, macOS 14.0, *)
    @available(tvOS, unavailable)
    @available(watchOS, unavailable)
    public func searchable<C, T, S>(text: Binding<String>, tokens: Binding<C>, suggestedTokens: Binding<C>, isPresented: Binding<Bool>, placement: SearchFieldPlacement = .automatic, prompt: S, @ViewBuilder token: @escaping (C.Element) -> T) -> some View where C : MutableCollection, C : RandomAccessCollection, C : RangeReplaceableCollection, T : View, S : StringProtocol, C.Element : Identifiable { return stubView() }

}

extension View {

    @available(iOS 17.0, xrOS 1.0, *)
    @available(macOS, unavailable)
    @available(watchOS, unavailable)
    @available(tvOS, unavailable)
    public func searchDictationBehavior(_ dictationBehavior: TextInputDictationBehavior) -> some View { return stubView() }

}

#endif
