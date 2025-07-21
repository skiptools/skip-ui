// Copyright 2023–2025 Skip
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception
#if !SKIP_BRIDGE
import Foundation
#if SKIP
import androidx.compose.runtime.Composable
#endif

// SKIP @bridge
public final class ForEach : View, Renderable, LazyItemFactory {
    let identifier: ((Any) -> AnyHashable?)?
    let indexRange: (() -> Range<Int>)?
    let indexedContent: ((Int) -> any View)?
    let objects: (any RandomAccessCollection<Any>)?
    let objectContent: ((Any) -> any View)?
    let objectsBinding: Binding<any RandomAccessCollection<Any>>?
    let objectsBindingContent: ((Binding<any RandomAccessCollection<Any>>, Int) -> any View)?
    let editActions: EditActions
    var onDeleteAction: ((IndexSet) -> Void)?
    var onMoveAction: ((IndexSet, Int) -> Void)?

    init(identifier: ((Any) -> AnyHashable?)? = nil, indexRange: (() -> Range<Int>)? = nil, indexedContent: ((Int) -> any View)? = nil, objects: (any RandomAccessCollection<Any>)? = nil, objectContent: ((Any) -> any View)? = nil, objectsBinding: Binding<any RandomAccessCollection<Any>>? = nil, objectsBindingContent: ((Binding<any RandomAccessCollection<Any>>, Int) -> any View)? = nil, editActions: EditActions = []) {
        self.identifier = identifier
        self.indexRange = indexRange
        self.indexedContent = indexedContent
        self.objects = objects
        self.objectContent = objectContent
        self.objectsBinding = objectsBinding
        self.objectsBindingContent = objectsBindingContent
        self.editActions = editActions
    }

    // SKIP @bridge
    public init(startIndex: @escaping () -> Int, endIndex: @escaping () -> Int, identifier: ((Int) -> AnyHashable)?, bridgedContent: @escaping (Int) -> any View) {
        self.identifier = identifier == nil ? nil : { identifier!($0 as! Int) }
        // We use start and end index closures so that the values are up to date if the data is mutated. When
        // bridging we perform the mutations by assigning delete/move actions rather than passing `EditActions`
        self.indexRange = { startIndex()..<endIndex() }
        self.indexedContent = bridgedContent
        self.objects = nil
        self.objectContent = nil
        self.objectsBinding = nil
        self.objectsBindingContent = nil
        self.editActions = []
    }

    public func onDelete(perform action: ((IndexSet) -> Void)?) -> ForEach {
        onDeleteAction = action
        return self
    }

    // SKIP @bridge
    public func onDeleteArray(bridgedAction: (([Int]) -> Void)?) -> ForEach {
        let action: ((IndexSet) -> Void)?
        if let bridgedAction {
            action = { bridgedAction(Array($0)) }
        } else {
            action = nil
        }
        return onDelete(perform: action)
    }

    public func onMove(perform action: ((IndexSet, Int) -> Void)?) -> ForEach {
        onMoveAction = action
        return self
    }

    // SKIP @bridge
    public func onMoveArray(bridgedAction: (([Int], Int) -> Void)?) -> ForEach {
        let action: ((IndexSet, Int) -> Void)?
        if let bridgedAction {
            action = { bridgedAction(Array($0), $1) }
        } else {
            action = nil
        }
        return onMove(perform: action)
    }

    #if SKIP
    @Composable override func Evaluate(context: ComposeContext, options: Int) -> kotlin.collections.List<Renderable> {
        guard !EvaluateOptions(options).isKeepForEach else {
            return listOf(self)
        }
        let isLazy = EvaluateOptions(options).lazyItemLevel != nil

        // ForEach views might contain nested lazy item factories such as Sections or other ForEach instances. They also
        // might contain more than one view per iteration, which isn't supported by Compose lazy processing. We execute
        // our content closure for the first item in the ForEach and examine its content to see if it should be unrolled
        // If it should, we perform the full ForEach to append all items. If not, we append ourselves instead so that we
        // can take advantage of Compose's ability to specify ranges of items
        var isFirst = true
        var collected: kotlin.collections.MutableList<Renderable> = mutableListOf()
        if let indexRange {
            for index in indexRange() {
                var renderables = indexedContent!(index).Evaluate(context: context, options: options)
                if isLazy, !isUnrollRequired(renderables: renderables, isFirst: isFirst, context: context) {
                    collected.add(self)
                    break
                } else {
                    isFirst = false
                }
                let defaultTag: Any?
                if let identifier {
                    defaultTag = identifier(index)
                } else {
                    defaultTag = index
                }
                renderables = renderables.map { taggedRenderable(for: $0, defaultTag: defaultTag) }
                collected.addAll(renderables)
            }
        } else if let objects {
            for object in objects {
                var renderables = objectContent!(object).Evaluate(context: context, options: options)
                if isLazy, !isUnrollRequired(renderables: renderables, isFirst: isFirst, context: context) {
                    collected.add(self)
                    break
                } else {
                    isFirst = false
                }
                if let identifier {
                    renderables = renderables.map { taggedRenderable(for: $0, defaultTag: identifier(object)) }
                }
                collected.addAll(renderables)
            }
        } else if let objectsBinding {
            let objects = objectsBinding.wrappedValue
            for i in 0..<objects.count {
                var renderables = objectsBindingContent!(objectsBinding, i).Evaluate(context: context, options: options)
                if isLazy, !isUnrollRequired(renderables: renderables, isFirst: isFirst, context: context) {
                    collected.add(self)
                    break
                } else {
                    isFirst = false
                }
                if let identifier {
                    renderables = renderables.map { taggedRenderable(for: $0, defaultTag: identifier(objects[i])) }
                }
                collected.addAll(renderables)
            }
        }
        return collected
    }

    @Composable override func Render(context: ComposeContext) {
        fatalError()
    }

    /// If there aren't explicit `.tag` modifiers on `ForEach` content, we can potentially find the matching
    /// renderable for a tag without having to unroll.
    ///
    /// - Seealso: `Picker`
    @Composable func untaggedRenderable(forTag tag: Any?, context: ComposeContext) -> Renderable? {
        // Evaluate the view generated by the first item to see if our body produces tagged views
        var firstView: View? = nil
        if let indexRange, let first = indexRange().first {
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
        let renderables = firstView.Evaluate(context: context)
        guard !renderables.any({ TagModifier.on(content: $0, role: .tag) != nil }) else {
            return nil
        }

        // If we do not produce tagged views, then we can match the supplied tag against our id function
        if let indexRange, let index = tag as? Int, indexRange().contains(index) {
            return indexedContent!(index).Evaluate(context: context).firstOrNull()
        } else if let objects, let identifier {
            for object in objects {
                let id = identifier(object)
                if id == tag {
                    return objectContent!(object).Evaluate(context: context).firstOrNull()
                }
            }
        } else if let objectsBinding, let identifier {
            let objects = objectsBinding.wrappedValue
            for i in 0..<objects.count {
                let id = identifier(objects[i])
                if id == tag {
                    return objectsBindingContent!(objectsBinding, i).Evaluate(context: context).firstOrNull()
                }
            }
        }
        return nil
    }

    @Composable private func isUnrollRequired(renderables: kotlin.collections.List<Renderable>, isFirst: Bool, context: ComposeContext) -> Bool {
        // If we're past the first view where we make the unroll decision, we must be unrolling
        guard isFirst else {
            return true
        }
        // We have to unroll if the ForEach body contains multiple views. We also unroll if this is
        // e.g. a ForEach of Sections which each append lazy items
        return renderables.size > 1 || (renderables.firstOrNull() as? LazyItemFactory)?.shouldProduceLazyItems() == true
    }

    override func produceLazyItems(collector: LazyItemCollector, modifiers: kotlin.collections.List<ModifierProtocol>, level: Int) {
        if let indexRange {
            let factory: @Composable (Int, ComposeContext) -> Renderable = { index, context in
                let renderables = ModifiedContent.apply(modifiers: modifiers, to: indexedContent!(index)).Evaluate(context: context)
                let renderable = renderables.firstOrNull() ?? EmptyView()
                let tag: Any?
                if let identifier {
                    tag = identifier!(index)
                } else {
                    tag = index
                }
                return taggedRenderable(for: renderable, defaultTag: tag)
            }
            collector.indexedItems(indexRange(), identifier, onDeleteAction, onMoveAction, level, factory)
        } else if let objects {
            let factory: @Composable (Any, ComposeContext) -> Renderable = { object, context in
                let renderables = ModifiedContent.apply(modifiers: modifiers, to: objectContent!(object)).Evaluate(context: context)
                let renderable = renderables.firstOrNull() ?? EmptyView()
                guard let tag = identifier!(object) else {
                    return renderable
                }
                return taggedRenderable(for: renderable, defaultTag: tag)
            }
            collector.objectItems(objects, identifier!, onDeleteAction, onMoveAction, level, factory)
        } else if let objectsBinding {
            let factory: @Composable (Binding<any RandomAccessCollection<Any>>, Int, ComposeContext) -> Renderable = { objects, index, context in
                let renderables = ModifiedContent.apply(modifiers: modifiers, to: objectsBindingContent!(objects, index)).Evaluate(context: context)
                let renderable = renderables.firstOrNull() ?? EmptyView()
                guard let tag = identifier!(objects.wrappedValue[index]) else {
                    return renderable
                }
                return taggedRenderable(for: renderable, defaultTag: tag)
            }
            collector.objectBindingItems(objectsBinding, identifier!, editActions, onDeleteAction, onMoveAction, level, factory)
        }
    }

    private func taggedRenderable(for renderable: Renderable, defaultTag: Any?) -> Renderable {
        if let defaultTag, TagModifier.on(content: renderable, role: .tag) == nil {
            return ModifiedContent(content: renderable, modifier: TagModifier(value: defaultTag, role: .tag))
        } else {
            return renderable
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
    return ForEach(identifier: id == nil ? nil : { id!($0 as! Int) }, indexRange: { data }, indexedContent: content)
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

@available(*, unavailable)
public func ForEach(sections view: any View, @ViewBuilder content: @escaping (Any /* SectionConfiguration */) -> any View) -> ForEach {
    fatalError()
}

@available(*, unavailable)
public func ForEach(subviews view: any View, unusedp: Nothing? = nil, @ViewBuilder content: @escaping (Any /* Subview */) -> any View) -> ForEach {
    fatalError()
}

#endif
#endif
