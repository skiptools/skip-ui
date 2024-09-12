// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

import Foundation
#if SKIP
import androidx.compose.runtime.Composable
#endif

/// Adopted by views that generate lazy items.
protocol LazyItemFactory {
    #if SKIP
    /// Append views and view factories representing lazy items to the given composer.
    ///
    /// - Parameter appendingContext: Pass this context to the `Compose` function of a `ComposableView` to append all its child views.
    /// - Returns A `ComposeResult` to force the calling container to be fully re-evaluated on state change. Otherwise if only this
    ///   function were called again, it could continue appending to the given mutable list.
    @Composable func appendLazyItemViews(to composer: LazyItemCollectingComposer, appendingContext: ComposeContext) -> ComposeResult

    /// Use the given context to compose individual lazy items and ranges of items.
    func composeLazyItems(context: LazyItemFactoryContext, level: Int)
    #endif
}

#if SKIP
/// Allows `LazyItemFactory` instances to define the lazy content.
public final class LazyItemFactoryContext {
    private(set) var item: (View, Int) -> Void = { _, _ in }
    private(set) var indexedItems: (Range<Int>, ((Any) -> AnyHashable?)?, ((IndexSet) -> Void)?, ((IndexSet, Int) -> Void)?, Int, (Int) -> View) -> Void = { _, _, _, _, _, _ in  }
    private(set) var objectItems: (RandomAccessCollection<Any>, (Any) -> AnyHashable?, ((IndexSet) -> Void)?, ((IndexSet, Int) -> Void)?, Int, (Any) -> View) -> Void = { _, _, _, _, _, _ in }
    private(set) var objectBindingItems: (Binding<RandomAccessCollection<Any>>, (Any) -> AnyHashable?, EditActions, ((IndexSet) -> Void)?, ((IndexSet, Int) -> Void)?, Int, (Binding<RandomAccessCollection<Any>>, Int) -> View) -> Void = { _, _, _, _, _, _, _ in }
    private(set) var sectionHeader: (View) -> Void = { _ in }
    private(set) var sectionFooter: (View) -> Void = { _ in }
    private var startItemIndex = 0

    /// Initialize the content factories.
    func initialize(
        isTagging: Bool = false,
        startItemIndex: Int,
        item: (View, Int) -> Void,
        indexedItems: (Range<Int>, ((Any) -> AnyHashable?)?, Int, ((IndexSet) -> Void)?, ((IndexSet, Int) -> Void)?, Int, (Int) -> View) -> Void,
        objectItems: (RandomAccessCollection<Any>, (Any) -> AnyHashable?, Int, ((IndexSet) -> Void)?, ((IndexSet, Int) -> Void)?, Int, (Any) -> View) -> Void,
        objectBindingItems: (Binding<RandomAccessCollection<Any>>, (Any) -> AnyHashable?, Int, EditActions, ((IndexSet) -> Void)?, ((IndexSet, Int) -> Void)?, Int, (Binding<RandomAccessCollection<Any>>, Int) -> View) -> Void,
        sectionHeader: (View) -> Void,
        sectionFooter: (View) -> Void
    ) {
        self.isTagging = isTagging
        self.startItemIndex = startItemIndex

        content.removeAll()
        self.item = { view, level in
            // If this is an item after a section, add a header before it
            if case .sectionFooter = content.last {
                self.sectionHeader(EmptyView())
            }
            item(view, level)
            let id = TagModifierView.strip(from: view, role: .id)?.value
            content.append(.items(0, 1, { _ in id }, nil))
        }
        self.indexedItems = { range, identifier, onDelete, onMove, level, factory in
            if case .sectionFooter = content.last {
                self.sectionHeader(EmptyView())
            }
            indexedItems(range, identifier, count, onDelete, onMove, level, factory)
            content.append(.items(range.start, range.endExclusive - range.start, identifier, onMove))
        }
        self.objectItems = { objects, identifier, onDelete, onMove, level, factory in
            if case .sectionFooter = content.last {
                self.sectionHeader(EmptyView())
            }
            objectItems(objects, identifier, count, onDelete, onMove, level, factory)
            content.append(.objectItems(objects, identifier, onMove))
        }
        self.objectBindingItems = { binding, identifier, editActions, onDelete, onMove, level, factory in
            if case .sectionFooter = content.last {
                self.sectionHeader(EmptyView())
            }
            objectBindingItems(binding, identifier, count, editActions, onDelete, onMove, level, factory)
            content.append(.objectBindingItems(binding, identifier, onMove))
        }
        self.sectionHeader = { view in
            // If this is a header after an item, add a section footer before it
            switch content.last {
            case .sectionFooter, nil:
                break
            default:
                self.sectionFooter(EmptyView())
            }
            sectionHeader(view)
            content.append(.sectionHeader)
        }
        self.sectionFooter = { view in
            sectionFooter(view)
            content.append(.sectionFooter)
        }
    }

    /// Whether we're in a tagging view placement.
    private(set) var isTagging = false

    /// The current number of content items.
    var count: Int {
        var itemCount = 0
        for content in self.content {
            switch content {
            case .items(_, let count, _, _): itemCount += count
            case .objectItems(let objects, _, _): itemCount += objects.count
            case .objectBindingItems(let binding, _, _): itemCount += binding.wrappedValue.count
            case .sectionHeader, .sectionFooter: itemCount += 1
            }
        }
        return itemCount
    }

    /// Return the list index for the given item ID, or nil.
    func index(for id: Any) -> Int? {
        var index = startItemIndex
        for content in self.content {
            switch content {
            case .items(let start, let count, let idMap, _):
                for i in start..<(start + count) {
                    let itemID: Any?
                    if let idMap {
                        itemID = idMap(i)
                    } else {
                        itemID = i
                    }
                    if itemID == id {
                        return index
                    }
                    index += 1
                }
            case .objectItems(let objects, let idMap, _):
                for object in objects {
                    let itemID = idMap(object)
                    if itemID == id {
                        return index
                    }
                    index += 1
                }
            case .objectBindingItems(let binding, let idMap, _):
                for object in binding.wrappedValue {
                    let itemID = idMap(object)
                    if itemID == id {
                        return index
                    }
                    index += 1
                }
            case .sectionHeader, .sectionFooter: index += 1
            }
        }
        return nil
    }

    private var moving: (fromIndex: Int, toIndex: Int)?
    private var moveTrigger = 0

    /// Re-map indexes for any in-progress operations.
    func remapIndex(_ index: Int, from offset: Int) -> Int {
        guard let moving else {
            return index
        }
        // While a move is in progress we have to make the list appear reordered even though we don't change
        // the underlying data until the user ends the drag
        let offsetIndex = index + offset + startItemIndex
        if offsetIndex == moving.toIndex {
            return moving.fromIndex - offset - startItemIndex
        }
        if moving.fromIndex < moving.toIndex && offsetIndex >= moving.fromIndex && offsetIndex < moving.toIndex {
            return index + 1
        } else if moving.fromIndex > moving.toIndex && offsetIndex > moving.toIndex && offsetIndex <= moving.fromIndex {
            return index - 1
        } else {
            return index
        }
    }

    /// Commit the current active move operation, if any.
    func commitMove() {
        guard let moving else {
            return
        }
        let fromIndex = moving.fromIndex
        let toIndex = moving.toIndex
        self.moving = nil
        performMove(fromIndex: fromIndex, toIndex: toIndex)
    }

    /// Call this function during an active move operation with the current move progress.
    func move(from fromIndex: Int, to toIndex: Int, trigger: (Int) -> Void) {
        if moving == nil {
            if fromIndex != toIndex {
                moving = (fromIndex, toIndex)
                trigger(++moveTrigger) // Trigger recompose to see change
            }
        } else {
            // Keep the original fromIndex, not the in-progress one. The framework assumes we move one position at a time
            if moving!.fromIndex == toIndex {
                moving = nil
            } else {
                moving = (moving!.fromIndex, toIndex)
            }
            trigger(++moveTrigger) // Trigger recompose to see change
        }
    }

    private func performMove(fromIndex: Int, toIndex: Int) {
        var itemIndex = startItemIndex
        for content in self.content {
            switch content {
            case .items(_, let count, _, let onMove):
                if performMove(fromIndex: fromIndex, toIndex: toIndex, itemIndex: &itemIndex, count: count, onMove: onMove) {
                    return
                }
            case .objectItems(let objects, _, let onMove):
                if performMove(fromIndex: fromIndex, toIndex: toIndex, itemIndex: &itemIndex, count: objects.count, onMove: onMove) {
                    return
                }
            case .objectBindingItems(let binding, _, let onMove):
                if performMove(fromIndex: fromIndex, toIndex: toIndex, itemIndex: &itemIndex, count: binding.wrappedValue.count, onMove: onMove, customMove: {
                    if let element = (binding.wrappedValue as? RangeReplaceableCollection<Any>)?.remove(at: fromIndex - itemIndex) {
                        (binding.wrappedValue as? RangeReplaceableCollection<Any>)?.insert(element, at: toIndex - itemIndex)
                    }
                }) {
                    return
                }
            case .sectionHeader, .sectionFooter:
                if performMove(fromIndex: fromIndex, toIndex: toIndex, itemIndex: &itemIndex, count: 1, onMove: nil) {
                    return
                }
            }
        }
    }

    private func performMove(fromIndex: Int, toIndex: Int, itemIndex: inout Int, count: Int, onMove: ((IndexSet, Int) -> Void)?, customMove: (() -> Void)? = nil) -> Bool {
        guard min(fromIndex, toIndex) >= itemIndex && max(fromIndex, toIndex) < itemIndex + count else {
            itemIndex += count
            return false
        }
        if let onMove {
            let indexSet = IndexSet(integer: fromIndex - itemIndex)
            onMove(indexSet, fromIndex < toIndex ? toIndex - itemIndex + 1 : toIndex - itemIndex)
        } else if let customMove {
            customMove()
        }
        return true
    }

    /// Whether a given move would be permitted.
    func canMove(from fromIndex: Int, to toIndex: Int) -> Bool {
        if fromIndex == toIndex {
            return true
        }
        var itemIndex = startItemIndex
        for content in self.content {
            switch content {
            case .items(_, let count, _, _):
                if let ret = canMove(fromIndex: fromIndex, toIndex: toIndex, itemIndex: &itemIndex, count: count) {
                    return ret
                }
            case .objectItems(let objects, _, _):
                if let ret = canMove(fromIndex: fromIndex, toIndex: toIndex, itemIndex: &itemIndex, count: objects.count) {
                    return ret
                }
            case .objectBindingItems(let binding, _, _):
                if let ret = canMove(fromIndex: fromIndex, toIndex: toIndex, itemIndex: &itemIndex, count: binding.wrappedValue.count) {
                    return ret
                }
            case .sectionHeader, .sectionFooter:
                if let ret = canMove(fromIndex: fromIndex, toIndex: toIndex, itemIndex: &itemIndex, count: 1) {
                    return ret
                }
            }
        }
        return false
    }

    private func canMove(fromIndex: Int, toIndex: Int, itemIndex: inout Int, count: Int) -> Bool? {
        if fromIndex >= itemIndex && fromIndex < itemIndex + count {
            return toIndex >= itemIndex && toIndex < itemIndex + count
        } else {
            itemIndex += count
            return nil
        }
    }

    private enum Content {
        case items(Int, Int, ((Int) -> AnyHashable?)?, ((IndexSet, Int) -> Void)?)
        case objectItems(RandomAccessCollection<Any>, (Any) -> AnyHashable?, ((IndexSet, Int) -> Void)?)
        case objectBindingItems(Binding<RandomAccessCollection<Any>>, (Any) -> AnyHashable?, ((IndexSet, Int) -> Void)?)
        case sectionHeader
        case sectionFooter
    }
    private var content: [Content] = []
}

/// Used to collect lazy items.
public final class LazyItemCollectingComposer: SideEffectComposer, ForEachComposer {
    let views: MutableList<Tuple2<View, Int>> = mutableListOf() // Use MutableList to avoid copies
    var level = 0

    @Composable override func Compose(view: View, context: (Bool) -> ComposeContext) -> ComposeResult {
        if let factory = view as? LazyItemFactory {
            factory.appendLazyItemViews(to: self, appendingContext: context(true))
        } else {
            views.add(Tuple2(view, level))
        }
        return ComposeResult.ok
    }

    /// Add a lazy item.
    func append(_ view: View) {
        let _ = views.add(Tuple2(view, level))
    }

    /// Increase the nesting level, which creates indentation in the presented views.
    func pushLevel() {
        level += 1
    }

    /// Decrease the nesting level, which removes indentation in the presented views.
    func popLevel() {
        level -= 1
    }
}

/// Add to lazy items to render a section header.
struct LazySectionHeader: View, LazyItemFactory {
    let content: View

    @Composable override func ComposeContent(context: ComposeContext) {
        content.Compose(context: context)
    }

    @Composable func appendLazyItemViews(to composer: LazyItemCollectingComposer, appendingContext: ComposeContext) -> ComposeResult {
        composer.append(self)
        return ComposeResult.ok
    }

    override func composeLazyItems(context: LazyItemFactoryContext, level: Int) {
        context.sectionHeader(content)
    }
}

/// Add to lazy items to render a section footer.
struct LazySectionFooter: View, LazyItemFactory {
    let content: View

    @Composable override func ComposeContent(context: ComposeContext) {
        content.Compose(context: context)
    }

    @Composable func appendLazyItemViews(to composer: LazyItemCollectingComposer, appendingContext: ComposeContext) -> ComposeResult {
        composer.append(self)
        return ComposeResult.ok
    }

    override func composeLazyItems(context: LazyItemFactoryContext, level: Int) {
        context.sectionFooter(content)
    }
}

#endif
