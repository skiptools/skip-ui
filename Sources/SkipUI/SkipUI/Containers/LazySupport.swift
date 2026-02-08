// Copyright 2023–2025 Skip
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception
#if !SKIP_BRIDGE
import Foundation
#if SKIP
import androidx.compose.runtime.Composable
#endif

/// Adopted by `Renderables` that produce lazy items.
protocol LazyItemFactory {
    #if SKIP
    /// Whether to produce this factory's content as lazy items or to use the standard pipeline.
    func shouldProduceLazyItems() -> Bool

    /// Use the given collector to add individual lazy items and ranges of items.
    func produceLazyItems(collector: LazyItemCollector, modifiers: kotlin.collections.List<ModifierProtocol>, level: Int)
    #endif
}

#if SKIP
extension LazyItemFactory {
    func shouldProduceLazyItems() -> Bool {
        return true
    }
}

extension View {
    /// Expands views with the given lazy item level set in the environment.
    @Composable public final func EvaluateLazyItems(level: Int, context: ComposeContext) -> kotlin.collections.List<Renderable> {
        let renderables = Evaluate(context: context, options: EvaluateOptions(lazyItemLevel: level).value)
        guard level > 0 else {
            return renderables
        }
        return renderables.map { renderable in
            if !(renderable.strip() is LazyLevelRenderable) {
                return LazyLevelRenderable(content: renderable, level: level)
            } else {
                return renderable
            }
        }
    }
}

/// Use to render lazy items at the appropriate level.
final class LazyLevelRenderable: Renderable, LazyItemFactory {
    let content: Renderable
    let level: Int

    init(content: Renderable, level: Int) {
        // Do not copy view
        // SKIP REPLACE: this.content = content
        self.content = content
        self.level = level
    }

    @Composable override func Render(context: ComposeContext) {
        content.Render(context: context)
    }

    override func strip() -> Renderable {
        return content.strip()
    }

    override func forEachModifier<R>(perform action: (ModifierProtocol) -> R?) -> R? {
        return content.forEachModifier(perform: action)
    }

    override func produceLazyItems(collector: LazyItemCollector, modifiers: kotlin.collections.List<ModifierProtocol>, level: Int) {
        if let lazyItemFactory = content as? LazyItemFactory, lazyItemFactory.shouldProduceLazyItems() {
            lazyItemFactory.produceLazyItems(collector: collector, modifiers: modifiers, level: self.level)
        } else {
            collector.item(ModifiedContent.apply(modifiers: modifiers, to: content), self.level)
        }
    }
}

/// Add to lazy items to render a section header.
final class LazySectionHeader: Renderable, LazyItemFactory {
    let content: kotlin.collections.List<Renderable>

    init(content: kotlin.collections.List<Renderable>) {
        self.content = content
    }

    @Composable override func Render(context: ComposeContext) {
        content.forEach { $0.Render(context: context) }
    }

    override func produceLazyItems(collector: LazyItemCollector, modifiers: kotlin.collections.List<ModifierProtocol>, level: Int) {
        let modified = content.map { ModifiedContent.apply(modifiers: modifiers, to: $0) }
        collector.sectionHeader(modified)
    }
}

/// Add to lazy items to render a section footer.
final class LazySectionFooter: Renderable, LazyItemFactory {
    let content: kotlin.collections.List<Renderable>

    init(content: kotlin.collections.List<Renderable>) {
        self.content = content
    }

    @Composable override func Render(context: ComposeContext) {
        content.forEach { $0.Render(context: context) }
    }

    override func produceLazyItems(collector: LazyItemCollector, modifiers: kotlin.collections.List<ModifierProtocol>, level: Int) {
        let modified = content.map { ModifiedContent.apply(modifiers: modifiers, to: $0) }
        collector.sectionFooter(modified)
    }
}

extension ModifiedContent: LazyItemFactory {
    override func shouldProduceLazyItems() -> Bool {
        return (renderable as? LazyItemFactory)?.shouldProduceLazyItems() == true
    }

    override func produceLazyItems(collector: LazyItemCollector, modifiers: kotlin.collections.List<ModifierProtocol>, level: Int) {
        (renderable as? LazyItemFactory)?.produceLazyItems(collector: collector, modifiers: modifiers.plus(modifier), level: level)
    }
}

/// Collect lazy content added by `LazyItemFactory` instances.
public final class LazyItemCollector {
    private(set) var item: (Renderable, Int) -> Void = { _, _ in }
    private(set) var indexedItems: (Range<Int>, ((Any) -> AnyHashable?)?, ((IndexSet) -> Void)?, ((IndexSet, Int) -> Void)?, Int, @Composable (Int, ComposeContext) -> Renderable) -> Void = { _, _, _, _, _, _ in  }
    private(set) var objectItems: (RandomAccessCollection<Any>, (Any) -> AnyHashable?, ((IndexSet) -> Void)?, ((IndexSet, Int) -> Void)?, Int, @Composable (Any, ComposeContext) -> Renderable) -> Void = { _, _, _, _, _, _ in }
    private(set) var objectBindingItems: (Binding<RandomAccessCollection<Any>>, (Any) -> AnyHashable?, EditActions, ((IndexSet) -> Void)?, ((IndexSet, Int) -> Void)?, Int, @Composable (Binding<RandomAccessCollection<Any>>, Int, ComposeContext) -> Renderable) -> Void = { _, _, _, _, _, _, _ in }
    private(set) var sectionHeader: (kotlin.collections.List<Renderable>) -> Void = { _ in }
    private(set) var sectionFooter: (kotlin.collections.List<Renderable>) -> Void = { _ in }
    private var startItemIndex = 0

    /// Initialize the content factories.
    func initialize(
        startItemIndex: Int,
        item: (Renderable, Int) -> Void,
        indexedItems: (Range<Int>, ((Any) -> AnyHashable?)?, Int, ((IndexSet) -> Void)?, ((IndexSet, Int) -> Void)?, Int, @Composable (Int, ComposeContext) -> Renderable) -> Void,
        objectItems: (RandomAccessCollection<Any>, (Any) -> AnyHashable?, Int, ((IndexSet) -> Void)?, ((IndexSet, Int) -> Void)?, Int, @Composable (Any, ComposeContext) -> Renderable) -> Void,
        objectBindingItems: (Binding<RandomAccessCollection<Any>>, (Any) -> AnyHashable?, Int, EditActions, ((IndexSet) -> Void)?, ((IndexSet, Int) -> Void)?, Int, @Composable (Binding<RandomAccessCollection<Any>>, Int, ComposeContext) -> Renderable) -> Void,
        sectionHeader: (kotlin.collections.List<Renderable>) -> Void,
        sectionFooter: (kotlin.collections.List<Renderable>) -> Void
    ) {
        self.startItemIndex = startItemIndex

        content.removeAll()
        self.item = { renderable, level in
            // If this is an item after a section, add a header before it
            if case .sectionFooter = content.last {
                self.sectionHeader(listOf())
            }
            item(renderable, level)
            let id = TagModifier.on(content: renderable, role: .id)?.value
            content.append(.items(0, 1, { _ in id }, nil))
        }
        self.indexedItems = { range, identifier, onDelete, onMove, level, factory in
            if case .sectionFooter = content.last {
                self.sectionHeader(listOf())
            }
            indexedItems(range, identifier, count, onDelete, onMove, level, factory)
            content.append(.items(range.start, range.endExclusive - range.start, identifier, onMove))
        }
        self.objectItems = { objects, identifier, onDelete, onMove, level, factory in
            if case .sectionFooter = content.last {
                self.sectionHeader(listOf())
            }
            objectItems(objects, identifier, count, onDelete, onMove, level, factory)
            content.append(.objectItems(objects, identifier, onMove))
        }
        self.objectBindingItems = { binding, identifier, editActions, onDelete, onMove, level, factory in
            if case .sectionFooter = content.last {
                self.sectionHeader(listOf())
            }
            objectBindingItems(binding, identifier, count, editActions, onDelete, onMove, level, factory)
            content.append(.objectBindingItems(binding, identifier, onMove))
        }
        self.sectionHeader = { renderables in
            // If this is a header after an item, add a section footer before it
            switch content.last {
            case .sectionFooter, nil:
                break
            default:
                self.sectionFooter(listOf())
            }
            sectionHeader(renderables)
            content.append(.sectionHeader(max(1, renderables.size)))
        }
        self.sectionFooter = { renderables in
            sectionFooter(renderables)
            content.append(.sectionFooter(max(1, renderables.size)))
        }
    }

    /// The current number of content items.
    var count: Int {
        var itemCount = 0
        for content in self.content {
            switch content {
            case .items(_, let count, _, _): itemCount += count
            case .objectItems(let objects, _, _): itemCount += objects.count
            case .objectBindingItems(let binding, _, _): itemCount += binding.wrappedValue.count
            case .sectionHeader(let count): itemCount += count
            case .sectionFooter(let count): itemCount += count
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
            case .sectionHeader(let count): index += count
            case .sectionFooter(let count): index += count
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
            case .sectionHeader(let count):
                if performMove(fromIndex: fromIndex, toIndex: toIndex, itemIndex: &itemIndex, count: count, onMove: nil) {
                    return
                }
            case .sectionFooter(let count):
                if performMove(fromIndex: fromIndex, toIndex: toIndex, itemIndex: &itemIndex, count: count, onMove: nil) {
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
            case .sectionHeader(let count):
                if let ret = canMove(fromIndex: fromIndex, toIndex: toIndex, itemIndex: &itemIndex, count: count) {
                    return ret
                }
            case .sectionFooter(let count):
                if let ret = canMove(fromIndex: fromIndex, toIndex: toIndex, itemIndex: &itemIndex, count: count) {
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
        case sectionHeader(Int)
        case sectionFooter(Int)
    }
    private var content: [Content] = []
}

#endif
#endif
