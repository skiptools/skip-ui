// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

// TODO: Process for use in SkipUI

#if !SKIP

/// A type that defines various triggers that result in the firing of a
/// submission action.
///
/// These triggers may be provided to the ``View/onSubmit(of:_:)``
/// modifier to alter which types of user behaviors trigger a provided
/// submission action.
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public struct SubmitTriggers : OptionSet, Sendable {

    /// The raw type that can be used to represent all values of the conforming
    /// type.
    ///
    /// Every distinct value of the conforming type has a corresponding unique
    /// value of the `RawValue` type, but there may be values of the `RawValue`
    /// type that don't have a corresponding value of the conforming type.
    public typealias RawValue = Int

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
    public let rawValue: SubmitTriggers.RawValue = { fatalError() }()

    /// Creates a set of submit triggers.
    public init(rawValue: SubmitTriggers.RawValue) { fatalError() }

    /// Defines triggers originating from text input controls like `TextField`
    /// and `SecureField`.
    public static let text: SubmitTriggers = { fatalError() }()

    /// Defines triggers originating from search fields constructed from
    /// searchable modifiers.
    ///
    /// In the example below, only the search field or search completions
    /// placed by the searchable modifier will trigger the view model to submit
    /// its current search query.
    ///
    ///     @StateObject private var viewModel = ViewModel()
    ///
    ///     NavigationView {
    ///         SidebarView()
    ///         DetailView()
    ///     }
    ///     .searchable(
    ///         text: $viewModel.searchText,
    ///         placement: .sidebar
    ///     ) {
    ///         SuggestionsView()
    ///     }
    ///     .onSubmit(of: .search) {
    ///         viewModel.submitCurrentSearchQuery()
    ///     }
    ///
    public static let search: SubmitTriggers = { fatalError() }()

    /// The type of the elements of an array literal.
    public typealias ArrayLiteralElement = SubmitTriggers

    /// The element type of the option set.
    ///
    /// To inherit all the default implementations from the `OptionSet` protocol,
    /// the `Element` type must be `Self`, the default.
    public typealias Element = SubmitTriggers
}

#endif
