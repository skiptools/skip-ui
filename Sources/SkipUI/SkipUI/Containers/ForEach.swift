// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

// Erase the Data and ID because they are currently unused in Kotlin, the compiler won't be able to calculate them
//
// SKIP DECLARE: class ForEach<Content>: View where Content: View
public struct ForEach<Data, ID, Content> : View where Data : RandomAccessCollection, ID : Hashable, Content : View {
    #if !SKIP
    public var body: some View {
        stubView()
    }
    #endif
}

// Kotlin does not support generic constructor parameters, so we have to model many List constructors as functions

#if SKIP

//extension ForEach where ID == Data.Element.ID, Content : AccessibilityRotorContent, Data.Element : Identifiable {
//    public init(_ data: Data, @AccessibilityRotorContentBuilder content: @escaping (Data.Element) -> Content) { fatalError() }
//}
@available(*, unavailable)
public func ForEach<D, Content>(_ data: any RandomAccessCollection<D>, @ViewBuilder content: @escaping (D) -> Content) -> ForEach<Content> where D: Identifiable<Hashable>, Content: View {
    fatalError()
}

//extension ForEach where Content : AccessibilityRotorContent {
//    public init(_ data: Data, id: KeyPath<Data.Element, ID>, @AccessibilityRotorContentBuilder content: @escaping (Data.Element) -> Content) { fatalError() }
//}
@available(*, unavailable)
public func ForEach<D, Content>(_ data: any RandomAccessCollection<D>, id: (D) -> AnyHashable, @ViewBuilder content: @escaping (D) -> Content) -> ForEach<Content> where D: Identifiable<Hashable>, Content: View {
    fatalError()
}

@available(*, unavailable)
public func ForEach(_ data: Range<Int>, @ViewBuilder content: @escaping (Int) -> Content) -> ForEach<Content> where Content: View {
    fatalError()
}

#endif

// TODO: Process for use in SkipUI

#if !SKIP

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
    public init<C, R>(_ data: Binding<C>, editActions: EditActions /* <C> */, @ViewBuilder content: @escaping (Binding<C.Element>) -> R) where Data == IndexedIdentifierCollection<C, ID>, ID == C.Element.ID, Content == EditableCollectionContent<R, C>, C : MutableCollection, C : RandomAccessCollection, R : View, C.Element : Identifiable, C.Index : Hashable { fatalError() }

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
    public init<C, R>(_ data: Binding<C>, id: KeyPath<C.Element, ID>, editActions: EditActions /* <C> */, @ViewBuilder content: @escaping (Binding<C.Element>) -> R) where Data == IndexedIdentifierCollection<C, ID>, Content == EditableCollectionContent<R, C>, C : MutableCollection, C : RandomAccessCollection, R : View, C.Index : Hashable { fatalError() }
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

#endif
