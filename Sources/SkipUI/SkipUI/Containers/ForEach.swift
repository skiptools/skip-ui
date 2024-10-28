// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

import Foundation
#if SKIP
import androidx.compose.runtime.Composable
#endif

public final class ForEach : View, LazyItemFactory {
    let identifier: ((Any) -> AnyHashable?)?
    let indexRange: Range<Int>?
    let indexedContent: ((Int) -> any View)?
    let objects: (any RandomAccessCollection<Any>)?
    let objectContent: ((Any) -> any View)?
    let objectsBinding: Binding<any RandomAccessCollection<Any>>?
    let objectsBindingContent: ((Binding<any RandomAccessCollection<Any>>, Int) -> any View)?
    let editActions: EditActions
    var onDeleteAction: ((IndexSet) -> Void)?
    var onMoveAction: ((IndexSet, Int) -> Void)?

    init(identifier: ((Any) -> AnyHashable?)? = nil, indexRange: Range<Int>? = nil, indexedContent: ((Int) -> any View)? = nil, objects: (any RandomAccessCollection<Any>)? = nil, objectContent: ((Any) -> any View)? = nil, objectsBinding: Binding<any RandomAccessCollection<Any>>? = nil, objectsBindingContent: ((Binding<any RandomAccessCollection<Any>>, Int) -> any View)? = nil, editActions: EditActions = []) {
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
        // to act as a lazy item factory
        if context.composer is ForEachComposer {
            return super.Compose(context: context)
        } else {
            return ComposeUnrolled(context: context)
        }
    }

    @Composable public override func ComposeContent(context: ComposeContext) {
        ComposeUnrolled(context: context)
    }

    @Composable private func ComposeUnrolled(context: ComposeContext) -> ComposeResult {
        // This function returns a value, so we can ensure that when the ForEach body reads state and
        // is recomposed, it escapes and is reflected in the broader composition. Otherwise state reads
        // with an unrolled ForEach do not cause the composition to update
        let isTagging = EnvironmentValues.shared._placement.contains(ViewPlacement.tagged)
        if let indexRange {
            for index in indexRange {
                var views = collectViews(from: indexedContent!(index), context: context)
                if isTagging {
                    views = taggedViews(for: views, defaultTag: index, context: context)
                }
                views.forEach { $0.Compose(context: context) }
            }
        } else if let objects {
            for object in objects {
                var views = collectViews(from: objectContent!(object), context: context)
                if isTagging, let identifier {
                    views = taggedViews(for: views, defaultTag: identifier(object), context: context)
                }
                views.forEach { $0.Compose(context: context) }
            }
        } else if let objectsBinding {
            let objects = objectsBinding.wrappedValue
            for i in 0..<objects.count {
                var views = collectViews(from: objectsBindingContent!(objectsBinding, i), context: context)
                if isTagging, let identifier {
                    views = taggedViews(for: views, defaultTag: identifier(objects[i]), context: context)
                }
                views.forEach { $0.Compose(context: context) }
            }
        }
        return ComposeResult.ok
    }

    @Composable func appendLazyItemViews(to composer: LazyItemCollectingComposer, appendingContext: ComposeContext) -> ComposeResult {
        // ForEach views might contain nested lazy item factories such as Sections or other ForEach instances. They also
        // might contain more than one view per iteration, which isn't supported by Compose lazy processing. We execute
        // our content closure for the first item in the ForEach and examine its content to see if it should be unrolled
        // If it should, we perform the full ForEach to append all items. If not, we append ourselves instead so that we
        // can take advantage of Compose's ability to specify ranges of items
        let isTagging = EnvironmentValues.shared._placement.contains(ViewPlacement.tagged)
        var isFirstView = true
        if let indexRange {
            for index in indexRange {
                var contentViews = collectViews(from: indexedContent!(index), context: appendingContext)
                if !isUnrollRequired(contentViews: contentViews, isFirstView: isFirstView, context: appendingContext) {
                    composer.append(self)
                    return ComposeResult.ok
                } else {
                    isFirstView = false
                }
                if isTagging {
                    contentViews = taggedViews(for: contentViews, defaultTag: index, context: appendingContext)
                }
                contentViews.forEach { $0.Compose(appendingContext) }
            }
        } else if let objects {
            for object in objects {
                var contentViews = collectViews(from: objectContent!(object), context: appendingContext)
                if !isUnrollRequired(contentViews: contentViews, isFirstView: isFirstView, context: appendingContext) {
                    composer.append(self)
                    return ComposeResult.ok
                } else {
                    isFirstView = false
                }
                if isTagging, let identifier {
                    contentViews = taggedViews(for: contentViews, defaultTag: identifier(object), context: appendingContext)
                }
                contentViews.forEach { $0.Compose(appendingContext) }
            }
        } else if let objectsBinding {
            let objects = objectsBinding.wrappedValue
            for i in 0..<objects.count {
                var contentViews = collectViews(from: objectsBindingContent!(objectsBinding, i), context: appendingContext)
                if !isUnrollRequired(contentViews: contentViews, isFirstView: isFirstView, context: appendingContext) {
                    composer.append(self)
                    return ComposeResult.ok
                } else {
                    isFirstView = false
                }
                if isTagging, let identifier {
                    contentViews = taggedViews(for: contentViews, defaultTag: identifier(objects[i]), context: appendingContext)
                }
                contentViews.forEach { $0.Compose(appendingContext) }
            }
        }
        return ComposeResult.ok
    }

    /// If there aren't explicit `.tag` modifiers on `ForEach` content, we can potentially find the matching view for a tag
    /// without having to unroll the entire loop.
    ///
    /// - Seealso: `Picker`
    @Composable func untaggedView(forTag tag: Any?, context: ComposeContext) -> View? {
        // Evaluate the view generated by the first item to see if our body produces tagged views
        var firstView: View? = nil
        if let indexRange, let first = indexRange.first {
            firstView = indexedContent!(first)
        } else if let objects, let first = objects.first {
            firstView = objectContent!(first)
        } else if let objectsBinding {
            let objects = objectsBinding.wrappedValue
            if !objects.isEmpty {
                firstView = objectsBindingContent!(objectsBinding, 0)
            }
        }
        guard let firstView else {
            return nil
        }
        let firstViews = collectViews(from: firstView, context: context)
        guard !firstViews.contains(where: { TagModifierView.strip(from: $0, role: .tag) != nil }) else {
            return nil
        }

        // If we do not produce tagged views, then we can match the supplied tag against our id function
        if let indexRange, let index = tag as? Int, indexRange.contains(index) {
            return indexedContent!(index)
        } else if let objects, let identifier {
            for object in objects {
                let id = identifier(object)
                if id == tag {
                    return objectContent!(object)
                }
            }
        } else if let objectsBinding, let identifier {
            let objects = objectsBinding.wrappedValue
            for i in 0..<objects.count {
                let id = identifier(objects[i])
                if id == tag {
                    return objectsBindingContent!(objectsBinding, i)
                }
            }
        }
        return nil
    }

    @Composable private func isUnrollRequired(contentViews: [View], isFirstView: Bool, context: ComposeContext) -> Bool {
        // If we're past the first view where we make the unroll decision, we must be unrolling
        guard isFirstView else {
            return true
        }
        // We have to unroll if the ForEach body contains multiple views. We also unroll if this is
        // e.g. a ForEach of Sections which each append lazy items
        return contentViews.count > 1 || contentViews.first is LazyItemFactory
    }

    override func composeLazyItems(context: LazyItemFactoryContext, level: Int) {
        if let indexRange {
            let factory: (Int) -> View = context.isTagging ? { index in
                return TagModifierView(view: indexedContent!(index), value: index, role: ComposeModifierRole.tag)
            } : indexedContent!
            context.indexedItems(indexRange, identifier, onDeleteAction, onMoveAction, level, factory)
        } else if let objects {
            let factory: (Any) -> View = context.isTagging ? { object in
                let view = objectContent!(object)
                guard let tag = identifier!(object) else {
                    return view
                }
                return TagModifierView(view: view, value: tag, role: ComposeModifierRole.tag)
            } : objectContent!
            context.objectItems(objects, identifier!, onDeleteAction, onMoveAction, level, factory)
        } else if let objectsBinding {
            let factory: (Binding<any RandomAccessCollection<Any>>, Int) -> View = context.isTagging ? { objects, index in
                let view = objectsBindingContent!(objects, index)
                guard let tag = identifier!(objects.wrappedValue[index]) else {
                    return view
                }
                return TagModifierView(view: view, value: tag, role: ComposeModifierRole.tag)
            } : objectsBindingContent!
            context.objectBindingItems(objectsBinding, identifier!, editActions, onDeleteAction, onMoveAction, level, factory)
        }
    }

    @Composable private func collectViews(from view: any View, context: ComposeContext) -> [View] {
        return (view as? ComposeBuilder)?.collectViews(context: context) ?? [view]
    }

    @Composable private func taggedViews(for views: [View], defaultTag: Any?, context: ComposeContext) -> [View] {
        return views.map { view in
            if let taggedView = TagModifierView.strip(from: view, role: ComposeModifierRole.tag) {
                return taggedView
            } else if let defaultTag {
                return TagModifierView(view: view, value: defaultTag, role: ComposeModifierRole.tag)
            } else {
                return view
            }
        }
    }
    #else
    public var body: some View {
        stubView()
    }
    #endif
}

#if SKIP
/// Mark composers that should not unroll `ForEach` views.
public protocol ForEachComposer {
}

// Kotlin does not support generic constructor parameters, so we have to model many ForEach constructors as functions

//extension ForEach where ID == Data.Element.ID, Content : AccessibilityRotorContent, Data.Element : Identifiable {
//    public init(_ data: Data, @AccessibilityRotorContentBuilder content: @escaping (Data.Element) -> Content) { fatalError() }
//}
public func ForEach<D>(_ data: any RandomAccessCollection<D>, @ViewBuilder content: @escaping (D) -> any View) -> ForEach {
    return ForEach(identifier: { ($0 as! Identifiable<Hashable>).id }, objects: data as! RandomAccessCollection<Any>, objectContent: { content($0 as! D) })
}

//extension ForEach where Content : AccessibilityRotorContent {
//    public init(_ data: Data, id: KeyPath<Data.Element, ID>, @AccessibilityRotorContentBuilder content: @escaping (Data.Element) -> Content) { fatalError() }
//}
public func ForEach<D>(_ data: any RandomAccessCollection<D>, id: (D) -> AnyHashable?, @ViewBuilder content: @escaping (D) -> any View) -> ForEach {
    return ForEach(identifier: { id($0 as! D) }, objects: data as! RandomAccessCollection<Any>, objectContent: { content($0 as! D) })
}
public func ForEach(_ data: Range<Int>, id: ((Int) -> AnyHashable?)? = nil, @ViewBuilder content: @escaping (Int) -> any View) -> ForEach {
    return ForEach(identifier: id == nil ? nil : { id!($0 as! Int) }, indexRange: data, indexedContent: content)
}

//extension ForEach {
//  public init<C, R>(_ data: Binding<C>, editActions: EditActions /* <C> */, @ViewBuilder content: @escaping (Binding<C.Element>) -> R) where Data == IndexedIdentifierCollection<C, ID>, ID == C.Element.ID, Content == EditableCollectionContent<R, C>, C : MutableCollection, C : RandomAccessCollection, R : View, C.Element : Identifiable, C.Index : Hashable
//}
public func ForEach<C, E>(_ data: Binding<C>, editActions: EditActions = [], @ViewBuilder content: @escaping (Binding<E>) -> any View) -> ForEach where C: any RandomAccessCollection<E> {
    return ForEach(identifier: { ($0 as! Identifiable<Hashable>).id }, objectsBinding: data as! Binding<RandomAccessCollection<Any>>, objectsBindingContent: { data, index in
        let binding = Binding<E>(get: { data.wrappedValue[index] as! E }, set: { (data.wrappedValue as! skip.lib.MutableCollection<E>)[index] = $0 })
        return content(binding)
    }, editActions: editActions)
}

//extension ForEach {
//    public init<C, R>(_ data: Binding<C>, id: KeyPath<C.Element, ID>, editActions: EditActions /* <C> */, @ViewBuilder content: @escaping (Binding<C.Element>) -> R) where Data == IndexedIdentifierCollection<C, ID>, Content == EditableCollectionContent<R, C>, C : MutableCollection, C : RandomAccessCollection, R : View, C.Index : Hashable { fatalError() }
//}
public func ForEach<C, E>(_ data: Binding<C>, id: (E) -> AnyHashable?, editActions: EditActions = [], @ViewBuilder content: @escaping (Binding<E>) -> any View) -> ForEach where C: RandomAccessCollection<E> {
    return ForEach(identifier: { id($0 as! E) }, objectsBinding: data as! Binding<RandomAccessCollection<Any>>, objectsBindingContent: { data, index in
        let binding = Binding<E>(get: { data.wrappedValue[index] as! E }, set: { (data.wrappedValue as! skip.lib.MutableCollection<E>)[index] = $0 })
        return content(binding)
    }, editActions: editActions)
}

#endif
