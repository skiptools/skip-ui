// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

import Foundation
#if SKIP
import androidx.compose.runtime.Composable
#endif

public class ForEach : View, ListItemFactory {
    let identifier: ((Any) -> AnyHashable)?
    let indexRange: Range<Int>?
    let indexedContent: ((Int) -> ComposeView)?
    let objects: (any RandomAccessCollection<Any>)?
    let objectContent: ((Any) -> ComposeView)?
    let objectsBinding: Binding<any RandomAccessCollection<Any>>?
    let objectsBindingContent: ((Binding<any RandomAccessCollection<Any>>, Int) -> ComposeView)?
    let editActions: EditActions
    var onDeleteAction: ((IndexSet) -> Void)?
    var onMoveAction: ((IndexSet, Int) -> Void)?

    init(identifier: ((Any) -> AnyHashable)? = nil, indexRange: Range<Int>? = nil, indexedContent: ((Int) -> ComposeView)? = nil, objects: (any RandomAccessCollection<Any>)? = nil, objectContent: ((Any) -> ComposeView)? = nil, objectsBinding: Binding<any RandomAccessCollection<Any>>? = nil, objectsBindingContent: ((Binding<any RandomAccessCollection<Any>>, Int) -> ComposeView)? = nil, editActions: EditActions = []) {
        self.identifier = identifier
        self.indexRange = indexRange
        self.indexedContent = indexedContent
        self.objects = objects
        self.objectContent = objectContent
        self.objectsBinding = objectsBinding
        self.objectsBindingContent = objectsBindingContent
        self.editActions = editActions
    }

    public func onDelete(perform action: ((IndexSet) -> Void)?) -> ForEach {
        onDeleteAction = action
        return self
    }

    public func onMove(perform action: ((IndexSet, Int) -> Void)?) -> ForEach {
        onMoveAction = action
        return self
    }

    #if SKIP
    @Composable public override func Compose(context: ComposeContext) -> ComposeResult {
        // We typically want to be transparent and act as though our loop were unrolled. The exception is when we need
        // to act as a list item factory
        if context.composer is ListItemCollectingComposer {
            return super.Compose(context: context)
        } else {
            ComposeContent(context: context)
            return ComposeResult.ok
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

    @Composable private func appendContentAsListItemViewFactories(contentView: ComposeView, isFirstView: Bool, context: ComposeContext) -> Bool {
        guard isFirstView else {
            return true
        }
        return contentView.collectViews(context: context).contains { $0 is ListItemFactory }
    }

    override func composeListItems(context: ListItemFactoryContext) {
        if let indexRange {
            context.indexedItems(indexRange, identifier, onDeleteAction, onMoveAction, indexedContent!)
        } else if let objects {
            context.objectItems(objects, identifier!, onDeleteAction, onMoveAction, objectContent!)
        } else if let objectsBinding {
            context.objectBindingItems(objectsBinding, identifier!, editActions, onDeleteAction, onMoveAction, objectsBindingContent!)
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
public func ForEach<D>(_ data: any RandomAccessCollection<D>, @ViewBuilder content: @escaping (D) -> ComposeView) -> ForEach {
    return ForEach(identifier: { ($0 as! Identifiable<Hashable>).id }, objects: data as! RandomAccessCollection<Any>, objectContent: { content($0 as! D) })
}

//extension ForEach where Content : AccessibilityRotorContent {
//    public init(_ data: Data, id: KeyPath<Data.Element, ID>, @AccessibilityRotorContentBuilder content: @escaping (Data.Element) -> Content) { fatalError() }
//}
public func ForEach<D>(_ data: any RandomAccessCollection<D>, id: (D) -> AnyHashable, @ViewBuilder content: @escaping (D) -> ComposeView) -> ForEach {
    return ForEach(identifier: { id($0 as! D) }, objects: data as! RandomAccessCollection<Any>, objectContent: { content($0 as! D) })
}
public func ForEach(_ data: Range<Int>, id: ((Int) -> AnyHashable)? = nil, @ViewBuilder content: @escaping (Int) -> ComposeView) -> ForEach {
    return ForEach(identifier: id == nil ? nil : { id!($0 as! Int) }, indexRange: data, indexedContent: content)
}

//extension ForEach {
//  public init<C, R>(_ data: Binding<C>, editActions: EditActions /* <C> */, @ViewBuilder content: @escaping (Binding<C.Element>) -> R) where Data == IndexedIdentifierCollection<C, ID>, ID == C.Element.ID, Content == EditableCollectionContent<R, C>, C : MutableCollection, C : RandomAccessCollection, R : View, C.Element : Identifiable, C.Index : Hashable
//}
public func ForEach<C, E>(_ data: Binding<C>, editActions: EditActions = [], @ViewBuilder content: @escaping (Binding<E>) -> ComposeView) -> ForEach where C: any RandomAccessCollection<E> {
    return ForEach(identifier: { ($0 as! Identifiable<Hashable>).id }, objectsBinding: data as! Binding<RandomAccessCollection<Any>>, objectsBindingContent: { data, index in
        let binding = Binding<E>(get: { data.wrappedValue[index] as! E }, set: { (data.wrappedValue as! skip.lib.MutableCollection<E>)[index] = $0 })
        return content(binding)
    }, editActions: editActions)
}

//extension ForEach {
//    public init<C, R>(_ data: Binding<C>, id: KeyPath<C.Element, ID>, editActions: EditActions /* <C> */, @ViewBuilder content: @escaping (Binding<C.Element>) -> R) where Data == IndexedIdentifierCollection<C, ID>, Content == EditableCollectionContent<R, C>, C : MutableCollection, C : RandomAccessCollection, R : View, C.Index : Hashable { fatalError() }
//}
public func ForEach<C, E>(_ data: Binding<C>, id: (E) -> AnyHashable, editActions: EditActions = [], @ViewBuilder content: @escaping (Binding<E>) -> ComposeView) -> ForEach where C: RandomAccessCollection<E> {
    return ForEach(identifier: { id($0 as! E) }, objectsBinding: data as! Binding<RandomAccessCollection<Any>>, objectsBindingContent: { data, index in
        let binding = Binding<E>(get: { data.wrappedValue[index] as! E }, set: { (data.wrappedValue as! skip.lib.MutableCollection<E>)[index] = $0 })
        return content(binding)
    }, editActions: editActions)
}

#endif
