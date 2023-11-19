// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

#if SKIP
import androidx.compose.runtime.Composable
#endif

// Erase the Data and ID because they are currently unused in Kotlin, the compiler won't be able to calculate them
public struct ForEach</* Data, ID, */ Content> : View, ListItemFactory where /* Data : RandomAccessCollection, ID : Hashable, */ Content : View {
    let identifier: ((Any) -> AnyHashable)?
    let indexRange: Range<Int>?
    let indexedContent: ((Int) -> Content)?
    let objects: (any RandomAccessCollection<Any>)?
    let objectContent: ((Any) -> Content)?
    let objectsBinding: Binding<any RandomAccessCollection<Any>>?
    let objectsBindingContent: ((Binding<any RandomAccessCollection<Any>>, Int) -> Content)?
    let editActions: EditActions

    init(identifier: ((Any) -> AnyHashable)? = nil, indexRange: Range<Int>? = nil, indexedContent: ((Int) -> Content)? = nil, objects: (any RandomAccessCollection<Any>)? = nil, objectContent: ((Any) -> Content)? = nil, objectsBinding: Binding<any RandomAccessCollection<Any>>? = nil, objectsBindingContent: ((Binding<any RandomAccessCollection<Any>>, Int) -> Content)? = nil, editActions: EditActions = []) {
        self.identifier = identifier
        self.indexRange = indexRange
        self.indexedContent = indexedContent
        self.objects = objects
        self.objectContent = objectContent
        self.objectsBinding = objectsBinding
        self.objectsBindingContent = objectsBindingContent
        self.editActions = editActions
    }

    #if SKIP
    @Composable public override func Compose(context: ComposeContext) -> ComposeResult {
        // We typically want to be transparent and act as though our loop were unrolled. The exception is when we need
        // to act as a list item factory
        if context.composer is ListItemCollectingComposer {
            return super.Compose(context: context)
        } else {
            ComposeContent(context: context)
            return .ok
        }
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
        } else if let objectsBinding {
            for i in 0..<objectsBinding.wrappedValue.count {
                objectsBindingContent!(objectsBinding, i).Compose(context: context)
            }
        }
    }

    @Composable func appendListItemViews(to views: MutableList<View>, appendingContext: ComposeContext) -> ComposeResult {
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
                    return ComposeResult.ok
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
                    return ComposeResult.ok
                } else {
                    isFirstView = false
                }
                contentView.Compose(appendingContext)
            }
        } else if let objectsBinding {
            for i in 0..<objectsBinding.wrappedValue.count {
                let contentView = objectsBindingContent!(objectsBinding, i)
                if !appendContentAsListItemViewFactories(contentView: contentView, isFirstView: isFirstView, context: appendingContext) {
                    views.add(self)
                    return ComposeResult.ok
                } else {
                    isFirstView = false
                }
                contentView.Compose(appendingContext)
            }
        }
        return ComposeResult.ok
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
            context.indexedItems(indexRange, identifier, indexedContent!)
        } else if let objects {
            context.objectItems(objects, identifier!, objectContent!)
        } else if let objectsBinding {
            context.objectBindingItems(objectsBinding, identifier!, editActions, objectsBindingContent!)
        }
    }
    #else
    public var body: some View {
        stubView()
    }
    #endif
}

#if SKIP

// Kotlin does not support generic constructor parameters, so we have to model many ForEach constructors as functions

//extension ForEach where ID == Data.Element.ID, Content : AccessibilityRotorContent, Data.Element : Identifiable {
//    public init(_ data: Data, @AccessibilityRotorContentBuilder content: @escaping (Data.Element) -> Content) { fatalError() }
//}
public func ForEach<D, Content>(_ data: any RandomAccessCollection<D>, @ViewBuilder content: @escaping (D) -> Content) -> ForEach<Content> where D: Identifiable<Hashable>, Content: View {
    return ForEach(identifier: { ($0 as! D).id }, objects: data as! RandomAccessCollection<Any>, objectContent: { content($0 as! D) })
}

//extension ForEach where Content : AccessibilityRotorContent {
//    public init(_ data: Data, id: KeyPath<Data.Element, ID>, @AccessibilityRotorContentBuilder content: @escaping (Data.Element) -> Content) { fatalError() }
//}
public func ForEach<D, Content>(_ data: any RandomAccessCollection<D>, id: (D) -> AnyHashable, @ViewBuilder content: @escaping (D) -> Content) -> ForEach<Content> where Content: View {
    return ForEach(identifier: { id($0 as! D) }, objects: data as! RandomAccessCollection<Any>, objectContent: { content($0 as! D) })
}
public func ForEach<Content>(_ data: Range<Int>, id: ((Int) -> AnyHashable)? = nil, @ViewBuilder content: @escaping (Int) -> Content) -> ForEach<Content> where Content: View {
    return ForEach(identifier: id == nil ? nil : { id!($0 as! Int) }, indexRange: data, indexedContent: content)
}

//extension ForEach {
//  public init<C, R>(_ data: Binding<C>, editActions: EditActions /* <C> */, @ViewBuilder content: @escaping (Binding<C.Element>) -> R) where Data == IndexedIdentifierCollection<C, ID>, ID == C.Element.ID, Content == EditableCollectionContent<R, C>, C : MutableCollection, C : RandomAccessCollection, R : View, C.Element : Identifiable, C.Index : Hashable
//}
public func ForEach<C, E, Content>(_ data: Binding<C>, editActions: EditActions = [], @ViewBuilder content: @escaping (Binding<E>) -> Content) -> ForEach<Content> where C: any RandomAccessCollection<E>, E: Identifiable<Hashable>, Content: View {
    return ForEach(identifier: { ($0 as! E).id }, objectsBinding: data as! Binding<RandomAccessCollection<Any>>, objectsBindingContent: { data, index in
        let binding = Binding<E>(get: { data.wrappedValue[index] as! E }, set: { (data.wrappedValue as! skip.lib.MutableCollection<E>)[index] = $0 })
        return content(binding)
    }, editActions: editActions)
}

//extension ForEach {
//    public init<C, R>(_ data: Binding<C>, id: KeyPath<C.Element, ID>, editActions: EditActions /* <C> */, @ViewBuilder content: @escaping (Binding<C.Element>) -> R) where Data == IndexedIdentifierCollection<C, ID>, Content == EditableCollectionContent<R, C>, C : MutableCollection, C : RandomAccessCollection, R : View, C.Index : Hashable { fatalError() }
//}
public func ForEach<C, E, Content>(_ data: Binding<C>, id: (E) -> AnyHashable, editActions: EditActions = [], @ViewBuilder content: @escaping (Binding<E>) -> Content) -> ForEach<Content> where C: RandomAccessCollection<E>, Content: View {
    return ForEach(identifier: { id($0 as! E) }, objectsBinding: data as! Binding<RandomAccessCollection<Any>>, objectsBindingContent: { data, index in
        let binding = Binding<E>(get: { data.wrappedValue[index] as! E }, set: { (data.wrappedValue as! skip.lib.MutableCollection<E>)[index] = $0 })
        return content(binding)
    }, editActions: editActions)
}

#endif
