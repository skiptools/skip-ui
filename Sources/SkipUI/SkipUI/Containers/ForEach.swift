// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

#if SKIP
import androidx.compose.runtime.Composable
#endif

// Erase the Data and ID because they are currently unused in Kotlin, the compiler won't be able to calculate them
public struct ForEach</* Data, ID, */ Content> : View, ListItemFactory where /* Data : RandomAccessCollection, ID : Hashable, */ Content : View {
    let indexedContent: ((Int) -> Content)?
    let indexRange: Range<Int>?
    let objectContent: ((Any) -> Content)?
    let objects: (any RandomAccessCollection<Any>)?
    let identifier: ((Any) -> AnyHashable)?

    init(indexRange: Range<Int>? = nil, indexedContent: ((Int) -> Content)? = nil, objects: (any RandomAccessCollection<Any>)? = nil, identifier: ((Any) -> AnyHashable)? = nil, objectContent: ((Any) -> Content)? = nil) {
        self.indexRange = indexRange
        self.indexedContent = indexedContent
        self.objects = objects
        self.identifier = identifier
        self.objectContent = objectContent
    }

    public init(_ data: Range<Int>, @ViewBuilder content: @escaping (Int) -> Content) {
        self.init(indexRange: data, indexedContent: content)
    }

    #if SKIP
    @Composable public override func Compose(context: ComposeContext) -> ComposeResult {
        ComposeContent(context: context)
        return .ok
    }
    
    @Composable public override func ComposeContent(context: ComposeContext) {
        if let indexRange {
            for index in indexRange {
                indexedContent!(index).Compose(context: context)
            }
        } else if let objects {
            for object in objects {
                objectContent!(object).Compose(context: context)
            }
        }
    }

    @Composable func appendListItemViews(to views: MutableList<View>, appendingContext: ComposeContext) {
        // ForEach views might or might not contain nested list item factories such as Sections or other ForEach instances.
        // We execute our content closure for the first item in the ForEach and examine its content to see if it contains
        // list item factories. If it does, we perform the full ForEach to append all items so that they can be expanded.
        // If not, we append ourselves instead so that we can take advantage of Compose's ability to specify ranges of items
        var isFirstView = true
        if let indexRange {
            for index in indexRange {
                let contentView = indexedContent!(index)
                if !appendContentAsListItemViewFactories(contentView: contentView, isFirstView: isFirstView, context: appendingContext) {
                    views.add(self)
                    return
                } else {
                    isFirstView = false
                }
                contentView.Compose(appendingContext)
            }
        } else if let objects {
            for object in objects {
                let contentView = objectContent!(object)
                if !appendContentAsListItemViewFactories(contentView: contentView, isFirstView: isFirstView, context: appendingContext) {
                    views.add(self)
                    return
                } else {
                    isFirstView = false
                }
                contentView.Compose(appendingContext)
            }
        }
    }

    @Composable private func appendContentAsListItemViewFactories(contentView: View, isFirstView: Bool, context: ComposeContext) -> Bool {
        guard isFirstView else {
            return true
        }
        var hasViewFactory = false
        let factoryChecker = context.content(composer: ClosureComposer { view, _ in
            hasViewFactory = hasViewFactory || view is ListItemFactory
        })
        let _ = contentView.Compose(factoryChecker)
        return hasViewFactory
    }

    func ComposeListItems(context: ListItemFactoryContext) {
        if let indexRange {
            context.indexedItems(indexRange, indexedContent!)
        } else if let objects {
            context.objectItems(objects, identifier!, objectContent!)
        }
    }
    #else
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
public func ForEach<D, Content>(_ data: any RandomAccessCollection<D>, @ViewBuilder content: @escaping (D) -> Content) -> ForEach<Content> where D: Identifiable<Hashable>, Content: View {
    return ForEach(objects: data as! RandomAccessCollection<Any>, identifier: { ($0 as! D).id }, objectContent: { content($0 as! D) })
}

//extension ForEach where Content : AccessibilityRotorContent {
//    public init(_ data: Data, id: KeyPath<Data.Element, ID>, @AccessibilityRotorContentBuilder content: @escaping (Data.Element) -> Content) { fatalError() }
//}
public func ForEach<D, Content>(_ data: any RandomAccessCollection<D>, id: (D) -> AnyHashable, @ViewBuilder content: @escaping (D) -> Content) -> ForEach<Content> where Content: View {
    return ForEach(objects: data as! RandomAccessCollection<Any>, identifier: { id($0 as! D) }, objectContent: { content($0 as! D) })
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
//    public init<C, R>(_ data: Binding<C>, editActions: EditActions /* <C> */, @ViewBuilder content: @escaping (Binding<C.Element>) -> R) where Data == IndexedIdentifierCollection<C, ID>, ID == C.Element.ID, Content == EditableCollectionContent<R, C>, C : MutableCollection, C : RandomAccessCollection, R : View, C.Element : Identifiable, C.Index : Hashable { fatalError() }

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
//    public init<C, R>(_ data: Binding<C>, id: KeyPath<C.Element, ID>, editActions: EditActions /* <C> */, @ViewBuilder content: @escaping (Binding<C.Element>) -> R) where Data == IndexedIdentifierCollection<C, ID>, Content == EditableCollectionContent<R, C>, C : MutableCollection, C : RandomAccessCollection, R : View, C.Index : Hashable { fatalError() }
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
//    public init<C>(_ data: Binding<C>, @ViewBuilder content: @escaping (Binding<C.Element>) -> Content) where Data == LazyMapSequence<C.Indices, (C.Index, ID)>, ID == C.Element.ID, C : MutableCollection, C : RandomAccessCollection, C.Element : Identifiable, C.Index : Hashable { fatalError() }

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
//    public init<C>(_ data: Binding<C>, id: KeyPath<C.Element, ID>, @ViewBuilder content: @escaping (Binding<C.Element>) -> Content) where Data == LazyMapSequence<C.Indices, (C.Index, ID)>, C : MutableCollection, C : RandomAccessCollection, C.Index : Hashable { fatalError() }
}

#endif
