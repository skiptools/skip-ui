// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

#if !SKIP

/// A structure that computes views on demand from an underlying collection of
/// identified data.
///
/// Use `ForEach` to provide views based on a
///
/// of some data type. Either the collection's elements must conform to
///  or you
/// need to provide an `id` parameter to the `ForEach` initializer.
///
/// The following example creates a `NamedFont` type that conforms to
/// , and an
/// array of this type called `namedFonts`. A `ForEach` instance iterates
/// over the array, producing new ``Text`` instances that display examples
/// of each SkipUI ``Font`` style provided in the array.
///
///     private struct NamedFont: Identifiable {
///         let name: String
///         let font: Font
///         var id: String { name }
///     }
///
///     private let namedFonts: [NamedFont] = [
///         NamedFont(name: "Large Title", font: .largeTitle),
///         NamedFont(name: "Title", font: .title),
///         NamedFont(name: "Headline", font: .headline),
///         NamedFont(name: "Body", font: .body),
///         NamedFont(name: "Caption", font: .caption)
///     ]
///
///     var body: some View {
///         ForEach(namedFonts) { namedFont in
///             Text(namedFont.name)
///                 .font(namedFont.font)
///         }
///     }
///
/// ![A vertically arranged stack of labels showing various standard fonts,
/// such as Large Title and Headline.](SkipUI-ForEach-fonts.png)
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
public struct ForEach<Data, ID, Content> where Data : RandomAccessCollection, ID : Hashable {

    /// The collection of underlying identified data that SkipUI uses to create
    /// views dynamically.
    public var data: Data { get { fatalError() } }

    /// A function to create content on demand using the underlying data.
    public var content: (Data.Element) -> Content { get { fatalError() } }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension ForEach : DynamicViewContent where Content : View {
}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
extension ForEach : AccessibilityRotorContent where Content : AccessibilityRotorContent {

    /// The internal content of this `AccessibilityRotorContent`.
    public var body: Never { get { fatalError() } }

    /// The type for the internal content of this `AccessibilityRotorContent`.
    public typealias Body = Never
}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
extension ForEach where ID == Data.Element.ID, Content : AccessibilityRotorContent, Data.Element : Identifiable {

    /// Creates an instance that generates Rotor content by combining, in order,
    /// individual Rotor content for each element in the data given to this
    /// `ForEach`.
    ///
    /// It's important that the `id` of a data element doesn't change unless you
    /// replace the data element with a new data element that has a new
    /// identity.
    ///
    /// - Parameters:
    ///   - data: The identified data that the ``ForEach`` instance uses to
    ///     create views dynamically.
    ///   - content: The result builder that generates Rotor content for each
    ///     data element.
    public init(_ data: Data, @AccessibilityRotorContentBuilder content: @escaping (Data.Element) -> Content) { fatalError() }
}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
extension ForEach where Content : AccessibilityRotorContent {

    /// Creates an instance that generates Rotor content by combining, in order,
    /// individual Rotor content for each element in the data given to this
    /// `ForEach`.
    ///
    /// It's important that the `id` of a data element doesn't change, unless
    /// SkipUI considers the data element to have been replaced with a new data
    /// element that has a new identity.
    ///
    /// - Parameters:
    ///   - data: The data that the ``ForEach`` instance uses to create views
    ///     dynamically.
    ///   - id: The key path to the provided data's identifier.
    ///   - content: The result builder that generates Rotor content for each
    ///     data element.
    public init(_ data: Data, id: KeyPath<Data.Element, ID>, @AccessibilityRotorContentBuilder content: @escaping (Data.Element) -> Content) { fatalError() }
}

@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
extension ForEach {

    /// Creates an instance that uniquely identifies and creates views across
    /// updates based on the identity of the underlying data.
    ///
    /// It's important that the `id` of a data element doesn't change unless you
    /// replace the data element with a new data element that has a new
    /// identity. If the `id` of a data element changes, the content view
    /// generated from that data element loses any current state and animations.
    ///
    /// When placed inside a `List` the edit actions (like delete or move)
    /// can be automatically synthesized by specifying an appropriate
    /// `EditActions`.
    ///
    /// The following example shows a list of recipes whose elements can be
    /// deleted and reordered:
    ///
    ///     List {
    ///         ForEach($recipes, editActions: [.delete, .move]) { $recipe in
    ///             RecipeCell($recipe)
    ///         }
    ///     }
    ///
    /// Use ``View/deleteDisabled(_:)`` and ``View/moveDisabled(_:)``
    /// to disable respectively delete or move actions on a per-row basis.
    ///
    /// The following example shows a list of recipes whose elements can be
    /// deleted only if they satisfy a condition:
    ///
    ///     List {
    ///         ForEach($recipes, editActions: .delete) { $recipe in
    ///             RecipeCell($recipe)
    ///                 .deleteDisabled(recipe.isFromMom)
    ///         }
    ///     }
    ///
    /// Explicit ``DynamicViewContent.onDelete(perform:)``,
    /// ``DynamicViewContent.onMove(perform:)``, or
    /// ``View.swipeActions(edge:allowsFullSwipe:content:)``
    /// modifiers will override any synthesized actions.
    /// Use this modifier if you need fine-grain control on how mutations are
    /// applied to the data driving the `ForEach`. For example, if you need to
    /// execute side effects or call into your existing model code.
    ///
    /// - Parameters:
    ///   - data: The identified data that the ``ForEach`` instance uses to
    ///     create views dynamically and can be edited by the user.
    ///   - editActions: The edit actions that are synthesized on `data`.
    ///   - content: The view builder that creates views dynamically.
    public init<C, R>(_ data: Binding<C>, editActions: EditActions<C>, @ViewBuilder content: @escaping (Binding<C.Element>) -> R) where Data == IndexedIdentifierCollection<C, ID>, ID == C.Element.ID, Content == EditableCollectionContent<R, C>, C : MutableCollection, C : RandomAccessCollection, R : View, C.Element : Identifiable, C.Index : Hashable { fatalError() }

    /// Creates an instance that uniquely identifies and creates views across
    /// updates based on the identity of the underlying data.
    ///
    /// It's important that the `id` of a data element doesn't change unless you
    /// replace the data element with a new data element that has a new
    /// identity. If the `id` of a data element changes, the content view
    /// generated from that data element loses any current state and animations.
    ///
    /// When placed inside a `List` the edit actions (like delete or move)
    /// can be automatically synthesized by specifying an appropriate
    /// `EditActions`.
    ///
    /// The following example shows a list of recipes whose elements can be
    /// deleted and reordered:
    ///
    ///     List {
    ///         ForEach($recipes, editActions: [.delete, .move]) { $recipe in
    ///             RecipeCell($recipe)
    ///         }
    ///     }
    ///
    /// Use ``View/deleteDisabled(_:)`` and ``View/moveDisabled(_:)``
    /// to disable respectively delete or move actions on a per-row basis.
    ///
    /// The following example shows a list of recipes whose elements can be
    /// deleted only if they satisfy a condition:
    ///
    ///     List {
    ///         ForEach($recipes, editActions: .delete) { $recipe in
    ///             RecipeCell($recipe)
    ///                 .deleteDisabled(recipe.isFromMom)
    ///         }
    ///     }
    ///
    /// Explicit ``DynamicViewContent.onDelete(perform:)``,
    /// ``DynamicViewContent.onMove(perform:)``, or
    /// ``View.swipeActions(edge:allowsFullSwipe:content:)``
    /// modifiers will override any synthesized actions.
    /// Use this modifier if you need fine-grain control on how mutations are
    /// applied to the data driving the `ForEach`. For example, if you need to
    /// execute side effects or call into your existing model code.
    ///
    /// - Parameters:
    ///   - data: The identified data that the ``ForEach`` instance uses to
    ///     create views dynamically and can be edited by the user.
    ///   - id: The key path to the provided data's identifier.
    ///   - editActions: The edit actions that are synthesized on `data`.
    ///   - content: The view builder that creates views dynamically.
    public init<C, R>(_ data: Binding<C>, id: KeyPath<C.Element, ID>, editActions: EditActions<C>, @ViewBuilder content: @escaping (Binding<C.Element>) -> R) where Data == IndexedIdentifierCollection<C, ID>, Content == EditableCollectionContent<R, C>, C : MutableCollection, C : RandomAccessCollection, R : View, C.Index : Hashable { fatalError() }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension ForEach : PlatformView where Content : PlatformView {
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension ForEach : View where Content : View {

    public typealias Body = Never
    public var body: Never { fatalError() }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension ForEach where ID == Data.Element.ID, Content : View, Data.Element : Identifiable {

    /// Creates an instance that uniquely identifies and creates views across
    /// updates based on the identity of the underlying data.
    ///
    /// It's important that the `id` of a data element doesn't change unless you
    /// replace the data element with a new data element that has a new
    /// identity. If the `id` of a data element changes, the content view
    /// generated from that data element loses any current state and animations.
    ///
    /// - Parameters:
    ///   - data: The identified data that the ``ForEach`` instance uses to
    ///     create views dynamically.
    ///   - content: The view builder that creates views dynamically.
    public init(_ data: Data, @ViewBuilder content: @escaping (Data.Element) -> Content) { fatalError() }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension ForEach where Content : View {

    /// Creates an instance that uniquely identifies and creates views across
    /// updates based on the provided key path to the underlying data's
    /// identifier.
    ///
    /// It's important that the `id` of a data element doesn't change, unless
    /// SkipUI considers the data element to have been replaced with a new data
    /// element that has a new identity. If the `id` of a data element changes,
    /// then the content view generated from that data element will lose any
    /// current state and animations.
    ///
    /// - Parameters:
    ///   - data: The data that the ``ForEach`` instance uses to create views
    ///     dynamically.
    ///   - id: The key path to the provided data's identifier.
    ///   - content: The view builder that creates views dynamically.
    public init(_ data: Data, id: KeyPath<Data.Element, ID>, @ViewBuilder content: @escaping (Data.Element) -> Content) { fatalError() }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension ForEach where Content : View {

    /// Creates an instance that uniquely identifies and creates views across
    /// updates based on the identity of the underlying data.
    ///
    /// It's important that the `id` of a data element doesn't change unless you
    /// replace the data element with a new data element that has a new
    /// identity. If the `id` of a data element changes, the content view
    /// generated from that data element loses any current state and animations.
    ///
    /// - Parameters:
    ///   - data: The identified data that the ``ForEach`` instance uses to
    ///     create views dynamically.
    ///   - content: The view builder that creates views dynamically.
    public init<C>(_ data: Binding<C>, @ViewBuilder content: @escaping (Binding<C.Element>) -> Content) where Data == LazyMapSequence<C.Indices, (C.Index, ID)>, ID == C.Element.ID, C : MutableCollection, C : RandomAccessCollection, C.Element : Identifiable, C.Index : Hashable { fatalError() }

    /// Creates an instance that uniquely identifies and creates views across
    /// updates based on the identity of the underlying data.
    ///
    /// It's important that the `id` of a data element doesn't change unless you
    /// replace the data element with a new data element that has a new
    /// identity. If the `id` of a data element changes, the content view
    /// generated from that data element loses any current state and animations.
    ///
    /// - Parameters:
    ///   - data: The identified data that the ``ForEach`` instance uses to
    ///     create views dynamically.
    ///   - id: The key path to the provided data's identifier.
    ///   - content: The view builder that creates views dynamically.
    public init<C>(_ data: Binding<C>, id: KeyPath<C.Element, ID>, @ViewBuilder content: @escaping (Binding<C.Element>) -> Content) where Data == LazyMapSequence<C.Indices, (C.Index, ID)>, C : MutableCollection, C : RandomAccessCollection, C.Index : Hashable { fatalError() }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension ForEach where Data == Range<Int>, ID == Int, Content : View {

    /// Creates an instance that computes views on demand over a given constant
    /// range.
    ///
    /// The instance only reads the initial value of the provided `data` and
    /// doesn't need to identify views across updates. To compute views on
    /// demand over a dynamic range, use ``ForEach/init(_:id:content:)``.
    ///
    /// - Parameters:
    ///   - data: A constant range.
    ///   - content: The view builder that creates views dynamically.
    public init(_ data: Range<Int>, @ViewBuilder content: @escaping (Int) -> Content) { fatalError() }
}

#endif
