// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

import Foundation
#if SKIP
import androidx.compose.animation.core.animateDpAsState
import androidx.compose.foundation.ExperimentalFoundationApi
import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.offset
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.requiredHeightIn
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.material3.DismissDirection
import androidx.compose.material3.DismissValue
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.Icon
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.SwipeToDismiss
import androidx.compose.material3.rememberDismissState
import androidx.compose.runtime.Composable
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.rememberCoroutineScope
import androidx.compose.runtime.rememberUpdatedState
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.shadow
import androidx.compose.ui.zIndex
import androidx.compose.ui.unit.dp
import kotlinx.coroutines.launch
import org.burnoutcrew.reorderable.ReorderableItem
import org.burnoutcrew.reorderable.ReorderableLazyListState
import org.burnoutcrew.reorderable.detectReorderAfterLongPress
import org.burnoutcrew.reorderable.rememberReorderableLazyListState
import org.burnoutcrew.reorderable.reorderable
#else
import struct CoreGraphics.CGFloat
#endif

// Erase the SelectionValue because it is currently unused in Kotlin, the compiler won't be able to calculate it
public class List<Content> : View where Content : View {
    let fixedContent: Content?
    let forEach: ForEach<Content>?

    init(fixedContent: Content? = nil, identifier: ((Any) -> AnyHashable)? = nil, indexRange: Range<Int>? = nil, indexedContent: ((Int) -> Content)? = nil, objects: (any RandomAccessCollection<Any>)? = nil, objectContent: ((Any) -> Content)? = nil, objectsBinding: Binding<any RandomAccessCollection<Any>>? = nil, objectsBindingContent: ((Binding<any RandomAccessCollection<Any>>, Int) -> Content)? = nil, editActions: EditActions = []) {
        self.fixedContent = fixedContent
        if let indexRange {
            self.forEach = ForEach(identifier: identifier, indexRange: indexRange, indexedContent: indexedContent)
        } else if let objects {
            self.forEach = ForEach(identifier: identifier, objects: objects, objectContent: objectContent)
        } else if let objectsBinding {
            self.forEach = ForEach(identifier: identifier, objectsBinding: objectsBinding, objectsBindingContent: objectsBindingContent, editActions: editActions)
        } else {
            self.forEach = nil
        }
    }

    public convenience init(@ViewBuilder content: () -> Content) {
        self.init(fixedContent: content())
    }

    @available(*, unavailable)
    public convenience init(selection: Binding<Any>, @ViewBuilder content: () -> Content) {
        self.init(fixedContent: content())
    }

    #if SKIP
    @Composable public override func ComposeContent(context: ComposeContext) {
        let style = EnvironmentValues.shared._listStyle ?? ListStyle.automatic
        let itemContext = context.content()
        ComposeContainer(modifier: context.modifier, fillWidth: true, fillHeight: true, then: Modifier.background(BackgroundColor(style: style))) { modifier in
            Box(modifier: modifier) {
                ComposeList(context: itemContext, style: style)
            }
        }
    }

    // SKIP INSERT: @OptIn(ExperimentalFoundationApi::class)
    @Composable private func ComposeList(context: ComposeContext, style: ListStyle) {
        // Collect all top-level views to compose. The LazyColumn itself is not a composable context, so we have to execute
        // our content's Compose function to collect its views before entering the LazyColumn body, then use LazyColumn's
        // LazyListScope functions to compose individual items
        let collectingComposer = ListItemCollectingComposer()
        let viewsCollector = context.content(composer: collectingComposer)
        if let forEach {
            forEach.appendListItemViews(to: collectingComposer.views, appendingContext: viewsCollector)
        } else if let fixedContent {
            fixedContent.Compose(context: viewsCollector)
        }

        var modifier: Modifier = Modifier
        if style != .plain {
            modifier = modifier.padding(start: Self.horizontalInset.dp, end: Self.horizontalInset.dp)
        }
        modifier = modifier.fillWidth()

        // Remember the factory because we use it in the remembered reorderable state
        let factoryContext = remember { mutableStateOf(ListItemFactoryContext()) }
        let moveTrigger = remember { mutableStateOf(0) }
        let reorderableState = rememberReorderableLazyListState(onMove: { from, to in
            // Trigger recompose on move, but don't read the trigger state until we're inside the list content to limit its scope
            factoryContext.value.move(from: from.index, to: to.index, trigger: { moveTrigger.value = $0 })
        }, onDragEnd: { _, _ in
            factoryContext.value.commitMove()
        }, canDragOver: { candidate, dragging in
            factoryContext.value.canMove(from: dragging.index, to: candidate.index)
        })
        modifier = modifier.reorderable(reorderableState)

        LazyColumn(state: reorderableState.listState, modifier: modifier) {
            let sectionHeaderContext = context.content(composer: ClosureComposer { view, context in
                ComposeSectionHeader(view: view, context: context(false), style: style, isTop: false)
            })
            let topSectionHeaderContext = context.content(composer: ClosureComposer { view, context in
                ComposeSectionHeader(view: view, context: context(false), style: style, isTop: true)
            })
            let sectionFooterContext = context.content(composer: ClosureComposer { view, context in
                ComposeSectionFooter(view: view, context: context(false), style: style)
            })

            // Read move trigger here so that a move will recompose list content
            let _ = moveTrigger.value
            // Animate list operations. If we're searching, however, we disable animation to prevent weird
            // animations during search filtering. This is ugly and not robust, but it works in most cases
            let shouldAnimateItems: @Composable () -> Bool = {
                guard let searchableState = EnvironmentValues.shared._searchableState, searchableState.isSearching.value else {
                    return true
                }
                guard searchableState.isOnNavigationStack else {
                    return false
                }
                // When the .searchable modifier is on the NavigationStack, assume we're the target if we're the root
                return LocalNavigator.current?.isRoot != true
            }

            // Initialize the factory context with closures that use the LazyListScope to generate items
            factoryContext.value.initialize(
                startItemIndex: 1, // List header item
                item: { view in
                    item {
                        let itemModifier: Modifier = shouldAnimateItems() ? Modifier.animateItemPlacement() : Modifier
                        let itemContext = context.content(composer: ClosureComposer { view, context in
                            ComposeItem(view: view, context: context(false), modifier: itemModifier, style: style)
                        })
                        view.Compose(context: itemContext)
                    }
                },
                indexedItems: { range, identifier, offset, onDelete, onMove, factory in
                    let count = range.endExclusive - range.start
                    let key: ((Int) -> String)? = identifier == nil ? nil : { composeBundleString(for: identifier!(factoryContext.value.remapIndex($0, from: offset))) }
                    items(count: count, key: key) { index in
                        let keyValue = key?(index) // Key closure already remaps index
                        let index = factoryContext.value.remapIndex(index, from: offset)
                        let itemModifier: Modifier = shouldAnimateItems() ? Modifier.animateItemPlacement() : Modifier
                        let editableItemContext = context.content(composer: ClosureComposer { view, context in
                            ComposeEditableItem(view: view, context: context(false), modifier: itemModifier, style: style, key: keyValue, index: index, onDelete: onDelete, onMove: onMove, reorderableState: reorderableState)
                        })
                        factory(index).Compose(context: editableItemContext)
                    }
                },
                objectItems: { objects, identifier, offset, onDelete, onMove, factory in
                    let key: (Int) -> String = { composeBundleString(for: identifier(objects[factoryContext.value.remapIndex($0, from: offset)])) }
                    items(count: objects.count, key: key) { index in
                        let keyValue = key(index) // Key closure already remaps index
                        let index = factoryContext.value.remapIndex(index, from: offset)
                        let itemModifier: Modifier = shouldAnimateItems() ? Modifier.animateItemPlacement() : Modifier
                        let editableItemContext = context.content(composer: ClosureComposer { view, context in
                            ComposeEditableItem(view: view, context: context(false), modifier: itemModifier, style: style, key: keyValue, index: index, onDelete: onDelete, onMove: onMove, reorderableState: reorderableState)
                        })
                        factory(objects[index]).Compose(context: editableItemContext)
                    }
                },
                objectBindingItems: { objectsBinding, identifier, offset, editActions, onDelete, onMove, factory in
                    let key: (Int) -> String = { composeBundleString(for: identifier(objectsBinding.wrappedValue[factoryContext.value.remapIndex($0, from: offset)])) }
                    items(count: objectsBinding.wrappedValue.count, key: key) { index in
                        let keyValue = key(index) // Key closure already remaps index
                        let index = factoryContext.value.remapIndex(index, from: offset)
                        let itemModifier: Modifier = shouldAnimateItems() ? Modifier.animateItemPlacement() : Modifier
                        let editableItemContext = context.content(composer: ClosureComposer { view, context in
                            ComposeEditableItem(view: view, context: context(false), modifier: itemModifier, style: style, objectsBinding: objectsBinding, key: keyValue, index: index, editActions: editActions, onDelete: onDelete, onMove: onMove, reorderableState: reorderableState)
                        })
                        factory(objectsBinding, index).Compose(context: editableItemContext)
                    }
                },
                sectionHeader: { view in
                    // Important to check the count immediately, outside the lazy list scope blocks
                    let context = factoryContext.value.count == 0 ? topSectionHeaderContext : sectionHeaderContext
                    if style == .plain {
                        stickyHeader {
                            view.Compose(context: context)
                        }
                    } else {
                        item {
                            view.Compose(context: context)
                        }
                    }
                },
                sectionFooter: { view in
                    item {
                        view.Compose(context: sectionFooterContext)
                    }
                }
            )

            item {
                ComposeHeader(style: style)
            }
            for view in collectingComposer.views {
                if let factory = view as? ListItemFactory {
                    factory.ComposeListItems(context: factoryContext.value)
                } else {
                    factoryContext.value.item(view)
                }
            }
            item {
                ComposeFooter(style: style)
            }
        }
    }

    private static let horizontalInset = 16.0
    private static let verticalInset = 32.0
    private static let minimumItemHeight = 44.0
    private static let horizontalItemInset = 16.0
    private static let verticalItemInset = 4.0

    @Composable private func ComposeItem(view: View, context: ComposeContext, modifier: Modifier = Modifier, style: ListStyle) {
        guard !view.isEmptyView else {
            return
        }
        // The given modifiers include elevation shadow for dragging, etc that need to go before the others
        let containerModifier = modifier.then(Modifier.background(BackgroundColor(style: .plain))).then(context.modifier)
        let contentModifier = Modifier.padding(horizontal: Self.horizontalItemInset.dp, vertical: Self.verticalItemInset.dp).fillWidth().requiredHeightIn(min: Self.minimumItemHeight.dp)
        Column(modifier: containerModifier) {
            // Note that we're calling the same view's Compose function again with a new context
            view.Compose(context: context.content(composer: ListItemComposer(contentModifier: contentModifier)))
            ComposeSeparator()
        }
    }

    // SKIP INSERT: @OptIn(ExperimentalMaterial3Api::class)
    @Composable private func ComposeEditableItem(view: View, context: ComposeContext, modifier: Modifier, style: ListStyle, objectsBinding: Binding<RandomAccessCollection<Any>>? = nil, key: String?, index: Int, editActions: EditActions = [], onDelete: ((IndexSet) -> Void)?, onMove: ((IndexSet, Int) -> Void)?, reorderableState: ReorderableLazyListState) {
        guard !view.isEmptyView else {
            return
        }
        guard let key else {
            ComposeItem(view: view, context: context, modifier: modifier, style: style)
            return
        }
        let editActionsModifiers = EditActionsModifierView.unwrap(view: view)
        let isDeleteEnabled = (editActions.contains(.delete) || onDelete != nil) && editActionsModifiers?.isDeleteDisabled != true
        let isMoveEnabled = (editActions.contains(.move) || onMove != nil) && editActionsModifiers?.isMoveDisabled != true
        guard isDeleteEnabled || isMoveEnabled else {
            ComposeItem(view: view, context: context, modifier: modifier, style: style)
            return
        }

        if isDeleteEnabled {
            let rememberedOnDelete = rememberUpdatedState({
                if let onDelete {
                    onDelete(IndexSet(integer: index))
                } else if let objectsBinding, objectsBinding.wrappedValue.count > index {
                    (objectsBinding.wrappedValue as? RangeReplaceableCollection<Any>)?.remove(at: index)
                }
            })
            let coroutineScope = rememberCoroutineScope()
            let dismissState = rememberDismissState(confirmValueChange: {
                if $0 == DismissValue.DismissedToStart {
                    coroutineScope.launch {
                        rememberedOnDelete.value()
                    }
                }
                return false
            }, positionalThreshold = { 164.dp.toPx() })

            let content: @Composable (Modifier) -> Void = {
                SwipeToDismiss(state: dismissState, directions: kotlin.collections.setOf(DismissDirection.EndToStart), modifier: $0, background: {
                    let trashVector = Image.composeImageVector(named: "trash")!
                    Box(modifier: Modifier.background(androidx.compose.ui.graphics.Color.Red).fillMaxSize(), contentAlignment: androidx.compose.ui.Alignment.CenterEnd) {
                        Icon(imageVector: trashVector, contentDescription: "Delete", modifier = Modifier.padding(end: 24.dp), tint: androidx.compose.ui.graphics.Color.White)
                    }
                }, dismissContent: {
                    ComposeItem(view: view, context: context, style: style)
                })
            }
            if isMoveEnabled {
                ComposeReorderableItem(reorderableState: reorderableState, key: key, modifier: modifier, content: content)
            } else {
                content(modifier)
            }
        } else {
            ComposeReorderableItem(reorderableState: reorderableState, key: key, modifier: modifier) {
                ComposeItem(view: view, context: context, modifier: $0, style: style)
            }
        }
    }

    @Composable private func ComposeReorderableItem(reorderableState: ReorderableLazyListState, key: String, modifier: Modifier, content: @Composable (Modifier) -> Void) {
        ReorderableItem(state: reorderableState, key: key, defaultDraggingModifier: modifier) { dragging in
            var itemModifier = Modifier.detectReorderAfterLongPress(reorderableState)
            if dragging {
                let elevation = animateDpAsState(8.dp)
                itemModifier = itemModifier.shadow(elevation.value)
            }
            content(itemModifier)
        }
    }

    @Composable private func ComposeSeparator() {
        Box(modifier: Modifier.padding(start: Self.horizontalItemInset.dp).fillWidth().height(1.dp).background(MaterialTheme.colorScheme.surfaceVariant))
    }

    @Composable private func ComposeSectionHeader(view: View, context: ComposeContext, style: ListStyle, isTop: Bool) {
        if !isTop {
            ComposeFooter(style: style)
        }
        var contentModifier = Modifier.fillWidth()
        if isTop && style != .plain {
            contentModifier = contentModifier.padding(start: Self.horizontalItemInset.dp, top: 0.dp, end: Self.horizontalItemInset.dp, bottom: Self.verticalItemInset.dp)
        } else {
            contentModifier = contentModifier.padding(horizontal: Self.horizontalItemInset.dp, vertical: Self.verticalItemInset.dp)
        }
        Column(modifier: Modifier.background(BackgroundColor(style: .automatic)).then(context.modifier)) {
            EnvironmentValues.shared.setValues {
                $0.set_listSectionHeaderStyle(style)
            } in: {
                view.Compose(context: context.content(modifier: contentModifier))
            }
        }
    }

    @Composable private func ComposeSectionFooter(view: View, context: ComposeContext, style: ListStyle) {
        if style == .plain {
            ComposeItem(view: view, context: context, style: style)
        } else {
            let modifier = Modifier.offset(y: -1.dp) // Cover last row's divider
                .zIndex(Float(0.5))
                .background(BackgroundColor(style: style))
                .then(context.modifier)
            let contentModifier = Modifier.fillWidth().padding(horizontal: Self.horizontalItemInset.dp, vertical: Self.verticalItemInset.dp)
            Column(modifier: modifier) {
                EnvironmentValues.shared.setValues {
                    $0.set_listSectionFooterStyle(style)
                } in: {
                    view.Compose(context: context.content(modifier: contentModifier))
                }
            }
        }
    }

    @Composable private func ComposeHeader(style: ListStyle) {
        guard style != .plain else {
            return
        }
        let modifier = Modifier.background(BackgroundColor(style: style))
            .fillWidth()
            .height(Self.verticalInset.dp)
        Box(modifier: modifier)
    }

    @Composable private func ComposeFooter(style: ListStyle) {
        guard style != .plain else {
            return
        }
        let modifier = Modifier.fillWidth()
            .height(Self.verticalInset.dp)
            .offset(y: -1.dp) // Cover last row's divider
            .zIndex(Float(0.5))
            .background(BackgroundColor(style: style))
        Box(modifier: modifier)
    }

    @Composable private func BackgroundColor(style: ListStyle) -> androidx.compose.ui.graphics.Color {
        if style == .plain {
            return MaterialTheme.colorScheme.surface
        } else {
            return Color.systemBackground.colorImpl()
        }
    }
    #else
    public var body: some View {
        stubView()
    }
    #endif
}

#if SKIP

// Kotlin does not support generic constructor parameters, so we have to model many List constructors as functions

//extension List {
//    public init<Data, RowContent>(_ data: Data, @ViewBuilder rowContent: @escaping (Data.Element) -> RowContent) where Content == ForEach<Data, Data.Element.ID, RowContent>, Data : RandomAccessCollection, RowContent : View, Data.Element : Identifiable
//}
public func List<ObjectType, Content>(_ data: any RandomAccessCollection<ObjectType>, @ViewBuilder rowContent: (ObjectType) -> Content) -> List<Content> where Content: View {
    return List(identifier: { ($0 as! Identifiable<Hashable>).id }, objects: data as! RandomAccessCollection<Any>, objectContent: { rowContent($0 as! ObjectType) })
}

//extension List {
//    public init<Data, ID, RowContent>(_ data: Data, id: KeyPath<Data.Element, ID>, @ViewBuilder rowContent: @escaping (Data.Element) -> RowContent) where Content == ForEach<Data, ID, RowContent>, Data : RandomAccessCollection, ID : Hashable, RowContent : View
//}
public func List<ObjectType, Content>(_ data: any RandomAccessCollection<ObjectType>, id: (ObjectType) -> AnyHashable, @ViewBuilder rowContent: (ObjectType) -> Content) -> List<Content> where ObjectType: Any, Content: View {
    return List(identifier: { id($0 as! ObjectType) }, objects: data as! RandomAccessCollection<Any>, objectContent: { rowContent($0 as! ObjectType) })
}
public func List<Content>(_ data: Range<Int>, id: ((Int) -> AnyHashable)? = nil, @ViewBuilder rowContent: (Int) -> Content) -> List<Content> where Content: View {
    return List(identifier: id == nil ? nil : { id!($0 as! Int) }, indexRange: data, indexedContent: rowContent)
}

//extension List {
//  public init<Data, RowContent>(_ data: Binding<Data>, editActions: EditActions /* <Data> */, @ViewBuilder rowContent: @escaping (Binding<Data.Element>) -> RowContent) where Content == ForEach<IndexedIdentifierCollection<Data, Data.Element.ID>, Data.Element.ID, EditableCollectionContent<RowContent, Data>>, Data : MutableCollection, Data : RandomAccessCollection, RowContent : View, Data.Element : Identifiable, Data.Index : Hashable
//}
public func List<Data, ObjectType, Content>(_ data: Binding<Data>, editActions: EditActions = [], @ViewBuilder rowContent: (Binding<ObjectType>) -> Content) -> List<Content> where Data: RandomAccessCollection<ObjectType>, Content: View {
    return List(identifier: { ($0 as! Identifiable<Hashable>).id }, objectsBinding: data as! Binding<RandomAccessCollection<Any>>, objectsBindingContent: { data, index in
        let binding = Binding<ObjectType>(get: { data.wrappedValue[index] as! ObjectType }, set: { (data.wrappedValue as! skip.lib.MutableCollection<ObjectType>)[index] = $0 })
        return rowContent(binding)
    }, editActions: editActions)
}

//extension List {
//  public init<Data, ID, RowContent>(_ data: Binding<Data>, id: KeyPath<Data.Element, ID>, editActions: EditActions /* <Data> */, @ViewBuilder rowContent: @escaping (Binding<Data.Element>) -> RowContent) where Content == ForEach<IndexedIdentifierCollection<Data, ID>, ID, EditableCollectionContent<RowContent, Data>>, Data : MutableCollection, Data : RandomAccessCollection, ID : Hashable, RowContent : View, Data.Index : Hashable
//}
public func List<Data, ObjectType, Content>(_ data: Binding<Data>, id: (ObjectType) -> AnyHashable, editActions: EditActions = [], @ViewBuilder rowContent: (Binding<ObjectType>) -> Content) -> List<Content> where Data: RandomAccessCollection<ObjectType>, Content: View {
    return List(identifier: { id($0 as! ObjectType) }, objectsBinding: data as! Binding<RandomAccessCollection<Any>>, objectsBindingContent: { data, index in
        let binding = Binding<ObjectType>(get: { data.wrappedValue[index] as! ObjectType }, set: { (data.wrappedValue as! skip.lib.MutableCollection<ObjectType>)[index] = $0 })
        return rowContent(binding)
    }, editActions: editActions)
}

#endif

/// Adopted by views that generate list items.
protocol ListItemFactory {
    #if SKIP
    /// Append views and view factories representing list itemsto the given mutable list.
    ///
    /// - Parameter appendingContext: Pass this context to the `Compose` function of a `ComposableView` to append all its child views.
    /// - Returns A `ComposeResult` to force the calling `List` to be fully re-evaluated on state change. Otherwise if only this
    ///   function were called again, it could continue appending to the given mutable list.
    @Composable func appendListItemViews(to views: MutableList<View>, appendingContext: ComposeContext) -> ComposeResult

    /// Use the given context to compose individual list items and ranges of items.
    func ComposeListItems(context: ListItemFactoryContext)
    #endif
}

/// Adopted by views that adapt when used as a list item.
protocol ListItemAdapting {
    #if SKIP
    /// Whether to compose this view as a list item or to use the standard compose pipeline.
    @Composable func shouldComposeListItem() -> Bool

    /// Compose this view as a list item.
    @Composable func ComposeListItem(context: ComposeContext, contentModifier: Modifier)
    #endif
}

#if SKIP
/// Allows `ListItemFactory` instances to define the content of the list.
public class ListItemFactoryContext {
    private(set) var item: (View) -> Void = { _ in }
    private(set) var indexedItems: (Range<Int>, ((Any) -> AnyHashable)?, ((IndexSet) -> Void)?, ((IndexSet, Int) -> Void)?, (Int) -> View) -> Void = { _, _, _, _, _ in  }
    private(set) var objectItems: (RandomAccessCollection<Any>, (Any) -> AnyHashable, ((IndexSet) -> Void)?, ((IndexSet, Int) -> Void)?, (Any) -> View) -> Void = { _, _, _, _, _ in }
    private(set) var objectBindingItems: (Binding<RandomAccessCollection<Any>>, (Any) -> AnyHashable, EditActions, ((IndexSet) -> Void)?, ((IndexSet, Int) -> Void)?, (Binding<RandomAccessCollection<Any>>, Int) -> View) -> Void = { _, _, _, _, _, _ in }
    private(set) var sectionHeader: (View) -> Void = { _ in }
    private(set) var sectionFooter: (View) -> Void = { _ in }
    private var startItemIndex = 0

    /// Initialize the content factories.
    func initialize(
        startItemIndex: Int,
        item: (View) -> Void,
        indexedItems: (Range<Int>, ((Any) -> AnyHashable)?, Int, ((IndexSet) -> Void)?, ((IndexSet, Int) -> Void)?, (Int) -> View) -> Void,
        objectItems: (RandomAccessCollection<Any>, (Any) -> AnyHashable, Int, ((IndexSet) -> Void)?, ((IndexSet, Int) -> Void)?, (Any) -> View) -> Void,
        objectBindingItems: (Binding<RandomAccessCollection<Any>>, (Any) -> AnyHashable, Int, EditActions, ((IndexSet) -> Void)?, ((IndexSet, Int) -> Void)?, (Binding<RandomAccessCollection<Any>>, Int) -> View) -> Void,
        sectionHeader: (View) -> Void,
        sectionFooter: (View) -> Void
    ) {
        self.startItemIndex = startItemIndex

        content.removeAll()
        self.item = { view in
            item(view)
            content.append(.items(1, nil))
        }
        self.indexedItems = { range, identifier, onDelete, onMove, factory in
            indexedItems(range, identifier, count, onDelete, onMove, factory)
            content.append(.items(range.endExclusive - range.start, onMove))
        }
        self.objectItems = { objects, identifier, onDelete, onMove, factory in
            objectItems(objects, identifier, count, onDelete, onMove, factory)
            content.append(.objectItems(objects, onMove))
        }
        self.objectBindingItems = { binding, identifier, editActions, onDelete, onMove, factory in
            objectBindingItems(binding, identifier, count, editActions, onDelete, onMove, factory)
            content.append(.objectBindingItems(binding, onMove))
        }
        self.sectionHeader = { view in
            sectionHeader(view)
            content.append(.items(1, nil))
        }
        self.sectionFooter = { view in
            sectionFooter(view)
            content.append(.items(1, nil))
        }
    }

    /// The current number of content items.
    var count: Int {
        var itemCount = 0
        for content in self.content {
            switch content {
            case .items(let count, _): itemCount += count
            case .objectItems(let objects, _): itemCount += objects.count
            case .objectBindingItems(let binding, _): itemCount += binding.wrappedValue.count
            }
        }
        return itemCount
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
            case .items(let count, let onMove):
                if performMove(fromIndex: fromIndex, toIndex: toIndex, itemIndex: &itemIndex, count: count, onMove: onMove) {
                    return
                }
            case .objectItems(let objects, let onMove):
                if performMove(fromIndex: fromIndex, toIndex: toIndex, itemIndex: &itemIndex, count: objects.count, onMove: onMove) {
                    return
                }
            case .objectBindingItems(let binding, let onMove):
                if performMove(fromIndex: fromIndex, toIndex: toIndex, itemIndex: &itemIndex, count: binding.wrappedValue.count, onMove: onMove, customMove: {
                    if let element = (binding.wrappedValue as? RangeReplaceableCollection<Any>)?.remove(at: fromIndex - itemIndex) {
                        (binding.wrappedValue as? RangeReplaceableCollection<Any>)?.insert(element, at: toIndex - itemIndex)
                    }
                }) {
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
            case .items(let count, _):
                if let ret = canMove(fromIndex: fromIndex, toIndex: toIndex, itemIndex: &itemIndex, count: count) {
                    return ret
                }
            case .objectItems(let objects, _):
                if let ret = canMove(fromIndex: fromIndex, toIndex: toIndex, itemIndex: &itemIndex, count: objects.count) {
                    return ret
                }
            case .objectBindingItems(let binding, _):
                if let ret = canMove(fromIndex: fromIndex, toIndex: toIndex, itemIndex: &itemIndex, count: binding.wrappedValue.count) {
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
        case items(Int, ((IndexSet, Int) -> Void)?)
        case objectItems(RandomAccessCollection<Any>, ((IndexSet, Int) -> Void)?)
        case objectBindingItems(Binding<RandomAccessCollection<Any>>, ((IndexSet, Int) -> Void)?)
    }
    private var content: [Content] = []
}

struct ListItemCollectingComposer: Composer {
    let views: MutableList<View> = mutableListOf() // Use MutableList to avoid copies

    @Composable override func Compose(view: View, context: (Bool) -> ComposeContext) {
        if let factory = view as? ListItemFactory {
            factory.appendListItemViews(to: views, appendingContext: context(true))
        } else {
            views.add(view)
        }
    }
}

struct ListItemComposer: Composer {
    let contentModifier: Modifier

    @Composable override func Compose(view: View, context: (Bool) -> ComposeContext) {
        if let listItemAdapting = view as? ListItemAdapting, listItemAdapting.shouldComposeListItem() {
            listItemAdapting.ComposeListItem(context: context(false), contentModifier: contentModifier)
        } else if view is ComposeModifierView {
            view.ComposeContent(context: context(true))
        } else {
            Box(modifier: contentModifier, contentAlignment: androidx.compose.ui.Alignment.CenterStart) {
                view.ComposeContent(context: context(false))
            }
        }
    }
}

/// Add to list items to render a section header.
struct ListSectionHeader: View, ListItemFactory {
    let content: View

    @Composable override func ComposeContent(context: ComposeContext) {
        let _ = content.Compose(context: context)
    }

    @Composable func appendListItemViews(to views: MutableList<View>, appendingContext: ComposeContext) -> ComposeResult {
        views.add(self)
        return ComposeResult.ok
    }

    func ComposeListItems(context: ListItemFactoryContext) {
        context.sectionHeader(content)
    }
}

/// Add to list items to render a section footer.
struct ListSectionFooter: View, ListItemFactory {
    let content: View

    @Composable override func ComposeContent(context: ComposeContext) {
        let _ = content.Compose(context: context)
    }

    @Composable func appendListItemViews(to views: MutableList<View>, appendingContext: ComposeContext) -> ComposeResult {
        views.add(self)
        return ComposeResult.ok
    }

    func ComposeListItems(context: ListItemFactoryContext) {
        context.sectionFooter(content)
    }
}
#endif

public struct ListStyle: RawRepresentable, Equatable {
    public let rawValue: Int

    public init(rawValue: Int) {
        self.rawValue = rawValue
    }

    public static let automatic = ListStyle(rawValue: 0)

    @available(*, unavailable)
    public static let sidebar = ListStyle(rawValue: 1)

    @available(*, unavailable)
    public static let insetGrouped = ListStyle(rawValue: 2)

    @available(*, unavailable)
    public static let grouped = ListStyle(rawValue: 3)

    @available(*, unavailable)
    public static let inset = ListStyle(rawValue: 4)

    public static let plain = ListStyle(rawValue: 5)
}

public enum ListItemTint : Sendable {
    case fixed(Color)
    case preferred(Color)
    case monochrome
}

public enum ListSectionSpacing : Sendable {
    case `default`
    case compact
    case custom(CGFloat)
}

extension View {
    @available(*, unavailable)
    public func listRowSeparator(_ visibility: Visibility, edges: VerticalEdge.Set = .all) -> some View {
        return self
    }

    @available(*, unavailable)
    public func listRowSeparatorTint(_ color: Color?, edges: VerticalEdge.Set = .all) -> some View {
        return self
    }

    @available(*, unavailable)
    public func listSectionSeparator(_ visibility: Visibility, edges: VerticalEdge.Set = .all) -> some View {
        return self
    }

    @available(*, unavailable)
    public func listSectionSeparatorTint(_ color: Color?, edges: VerticalEdge.Set = .all) -> some View {
        return self
    }

    public func listStyle(_ style: ListStyle) -> some View {
        #if SKIP
        return environment(\._listStyle, style)
        #else
        return self
        #endif
    }

    public func listItemTint(_ tint: Color?) -> some View {
        #if SKIP
        return environment(\._listItemTint, tint)
        #else
        return self
        #endif
    }

    @available(*, unavailable)
    public func listItemTint(_ tint: ListItemTint?) -> some View {
        return self
    }

    @available(*, unavailable)
    public func listRowInsets(_ insets: EdgeInsets?) -> some View {
        return self
    }

    @available(*, unavailable)
    public func listRowSpacing(_ spacing: CGFloat?) -> some View {
        return self
    }

    @available(*, unavailable)
    public func listSectionSpacing(_ spacing: ListSectionSpacing) -> some View {
        return self
    }

    @available(*, unavailable)
    public func listSectionSpacing(_ spacing: CGFloat) -> some View {
        return self
    }

    @available(*, unavailable)
    public func swipeActions(edge: HorizontalEdge = .trailing, allowsFullSwipe: Bool = true, @ViewBuilder content: () -> any View) -> some View {
        return self
    }
}

#if !SKIP

// TODO: Process for use in SkipUI

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension List {

    /// Creates a list that computes its rows on demand from an underlying
    /// collection of identifiable data, optionally allowing users to select
    /// multiple rows.
    ///
    /// - Parameters:
    ///   - data: The identifiable data for computing the list.
    ///   - selection: A binding to a set that identifies selected rows.
    ///   - rowContent: A view builder that creates the view for a single row of
    ///     the list.
//    @available(watchOS, unavailable)
//    @MainActor public init<Data, RowContent>(_ data: Data, selection: Binding<Set<SelectionValue>>?, @ViewBuilder rowContent: @escaping (Data.Element) -> RowContent) where Content == ForEach<Data, Data.Element.ID, RowContent>, Data : RandomAccessCollection, RowContent : View, Data.Element : Identifiable { fatalError() }

    /// Creates a hierarchical list that computes its rows on demand from an
    /// underlying collection of identifiable data, optionally allowing users to
    /// select multiple rows.
    ///
    /// - Parameters:
    ///   - data: The identifiable data for computing the list.
    ///   - children: A key path to a property whose non-`nil` value gives the
    ///     children of `data`. A non-`nil` but empty value denotes an element
    ///     capable of having children that's currently childless, such as an
    ///     empty directory in a file system. On the other hand, if the property
    ///     at the key path is `nil`, then the outline group treats `data` as a
    ///     leaf in the tree, like a regular file in a file system.
    ///   - selection: A binding to a set that identifies selected rows.
    ///   - rowContent: A view builder that creates the view for a single row of
    ///     the list.
//    @available(iOS 14.0, macOS 11.0, *)
//    @available(tvOS, unavailable)
//    @available(watchOS, unavailable)
//    @MainActor public init<Data, RowContent>(_ data: Data, children: KeyPath<Data.Element, Data?>, selection: Binding<Set<SelectionValue>>?, @ViewBuilder rowContent: @escaping (Data.Element) -> RowContent) where Content == OutlineGroup<Data, Data.Element.ID, RowContent, RowContent, DisclosureGroup<RowContent, OutlineSubgroupChildren>>, Data : RandomAccessCollection, RowContent : View, Data.Element : Identifiable { fatalError() }

    /// Creates a list that identifies its rows based on a key path to the
    /// identifier of the underlying data, optionally allowing users to select
    /// multiple rows.
    ///
    /// - Parameters:
    ///   - data: The data for populating the list.
    ///   - id: The key path to the data model's identifier.
    ///   - selection: A binding to a set that identifies selected rows.
    ///   - rowContent: A view builder that creates the view for a single row of
    ///     the list.
//    @available(watchOS, unavailable)
//    @MainActor public init<Data, ID, RowContent>(_ data: Data, id: KeyPath<Data.Element, ID>, selection: Binding<Set<SelectionValue>>?, @ViewBuilder rowContent: @escaping (Data.Element) -> RowContent) where Content == ForEach<Data, ID, RowContent>, Data : RandomAccessCollection, ID : Hashable, RowContent : View { fatalError() }

    /// Creates a hierarchical list that identifies its rows based on a key path
    /// to the identifier of the underlying data, optionally allowing users to
    /// select multiple rows.
    ///
    /// - Parameters:
    ///   - data: The data for populating the list.
    ///   - id: The key path to the data model's identifier.
    ///   - children: A key path to a property whose non-`nil` value gives the
    ///     children of `data`. A non-`nil` but empty value denotes a node capable
    ///     of having children that is currently childless, such as an empty
    ///     directory in a file system. On the other hand, if the property at the
    ///     key path is `nil`, then `data` is treated as a leaf node in the tree,
    ///     like a regular file in a file system.
    ///   - selection: A binding to a set that identifies selected rows.
    ///   - rowContent: A view builder that creates the view for a single row of
    ///     the list.
//    @available(iOS 14.0, macOS 11.0, *)
//    @available(tvOS, unavailable)
//    @available(watchOS, unavailable)
//    @MainActor public init<Data, ID, RowContent>(_ data: Data, id: KeyPath<Data.Element, ID>, children: KeyPath<Data.Element, Data?>, selection: Binding<Set<SelectionValue>>?, @ViewBuilder rowContent: @escaping (Data.Element) -> RowContent) where Content == OutlineGroup<Data, ID, RowContent, RowContent, DisclosureGroup<RowContent, OutlineSubgroupChildren>>, Data : RandomAccessCollection, ID : Hashable, RowContent : View { fatalError() }

    /// Creates a list that computes its views on demand over a constant range,
    /// optionally allowing users to select multiple rows.
    ///
    /// This instance only reads the initial value of `data` and doesn't need to
    /// identify views across updates. To compute views on demand over a dynamic
    /// range, use ``List/init(_:id:selection:rowContent:)-9a28m``.
    ///
    /// - Parameters:
    ///   - data: A constant range of data to populate the list.
    ///   - selection: A binding to a set that identifies selected rows.
    ///   - rowContent: A view builder that creates the view for a single row of
    ///     the list.
//    @available(watchOS, unavailable)
//    @MainActor public init<RowContent>(_ data: Range<Int>, selection: Binding<Set<SelectionValue>>?, @ViewBuilder rowContent: @escaping (Int) -> RowContent) where Content == ForEach<Range<Int>, Int, HStack<RowContent>>, RowContent : View { fatalError() }

    /// Creates a list that computes its rows on demand from an underlying
    /// collection of identifiable data, optionally allowing users to select a
    /// single row.
    ///
    /// - Parameters:
    ///   - data: The identifiable data for computing the list.
    ///   - selection: A binding to a selected value.
    ///   - rowContent: A view builder that creates the view for a single row of
    ///     the list.
//    @available(watchOS 10.0, *)
//    @MainActor public init<Data, RowContent>(_ data: Data, selection: Binding<SelectionValue?>?, @ViewBuilder rowContent: @escaping (Data.Element) -> RowContent) where Content == ForEach<Data, Data.Element.ID, RowContent>, Data : RandomAccessCollection, RowContent : View, Data.Element : Identifiable { fatalError() }

    /// Creates a hierarchical list that computes its rows on demand from an
    /// underlying collection of identifiable data, optionally allowing users to
    /// select a single row.
    ///
    /// - Parameters:
    ///   - data: The identifiable data for computing the list.
    ///   - children: A key path to a property whose non-`nil` value gives the
    ///     children of `data`. A non-`nil` but empty value denotes a node capable
    ///     of having children that is currently childless, such as an empty
    ///     directory in a file system. On the other hand, if the property at the
    ///     key path is `nil`, then `data` is treated as a leaf node in the tree,
    ///     like a regular file in a file system.
    ///   - selection: A binding to a selected value.
    ///   - rowContent: A view builder that creates the view for a single row of
    ///     the list.
//    @available(iOS 14.0, macOS 11.0, *)
//    @available(tvOS, unavailable)
//    @available(watchOS, unavailable)
//    @MainActor public init<Data, RowContent>(_ data: Data, children: KeyPath<Data.Element, Data?>, selection: Binding<SelectionValue?>?, @ViewBuilder rowContent: @escaping (Data.Element) -> RowContent) where Content == OutlineGroup<Data, Data.Element.ID, RowContent, RowContent, DisclosureGroup<RowContent, OutlineSubgroupChildren>>, Data : RandomAccessCollection, RowContent : View, Data.Element : Identifiable { fatalError() }

    /// Creates a list that identifies its rows based on a key path to the
    /// identifier of the underlying data, optionally allowing users to select a
    /// single row.
    ///
    /// - Parameters:
    ///   - data: The data for populating the list.
    ///   - id: The key path to the data model's identifier.
    ///   - selection: A binding to a selected value.
    ///   - rowContent: A view builder that creates the view for a single row of
    ///     the list.
//    @available(watchOS 10.0, *)
//    @MainActor public init<Data, ID, RowContent>(_ data: Data, id: KeyPath<Data.Element, ID>, selection: Binding<SelectionValue?>?, @ViewBuilder rowContent: @escaping (Data.Element) -> RowContent) where Content == ForEach<Data, ID, RowContent>, Data : RandomAccessCollection, ID : Hashable, RowContent : View { fatalError() }

    /// Creates a hierarchical list that identifies its rows based on a key path
    /// to the identifier of the underlying data, optionally allowing users to
    /// select a single row.
    ///
    /// - Parameters:
    ///   - data: The data for populating the list.
    ///   - id: The key path to the data model's identifier.
    ///   - children: A key path to a property whose non-`nil` value gives the
    ///     children of `data`. A non-`nil` but empty value denotes a node capable
    ///     of having children that is currently childless, such as an empty
    ///     directory in a file system. On the other hand, if the property at the
    ///     key path is `nil`, then `data` is treated as a leaf node in the tree,
    ///     like a regular file in a file system.
    ///   - selection: A binding to a selected value.
    ///   - rowContent: A view builder that creates the view for a single row of
    ///     the list.
//    @available(iOS 14.0, macOS 11.0, *)
//    @available(tvOS, unavailable)
//    @available(watchOS, unavailable)
//    @MainActor public init<Data, ID, RowContent>(_ data: Data, id: KeyPath<Data.Element, ID>, children: KeyPath<Data.Element, Data?>, selection: Binding<SelectionValue?>?, @ViewBuilder rowContent: @escaping (Data.Element) -> RowContent) where Content == OutlineGroup<Data, ID, RowContent, RowContent, DisclosureGroup<RowContent, OutlineSubgroupChildren>>, Data : RandomAccessCollection, ID : Hashable, RowContent : View { fatalError() }

    /// Creates a list that computes its views on demand over a constant range,
    /// optionally allowing users to select a single row.
    ///
    /// This instance only reads the initial value of `data` and doesn't need to
    /// identify views across updates. To compute views on demand over a dynamic
    /// range, use ``List/init(_:id:selection:rowContent:)-2r2u9``.
    ///
    /// - Parameters:
    ///   - data: A constant range of data to populate the list.
    ///   - selection: A binding to a selected value.
    ///   - rowContent: A view builder that creates the view for a single row of
    ///     the list.
//    @available(watchOS, unavailable)
//    @MainActor public init<RowContent>(_ data: Range<Int>, selection: Binding<SelectionValue?>?, @ViewBuilder rowContent: @escaping (Int) -> RowContent) where Content == ForEach<Range<Int>, Int, RowContent>, RowContent : View { fatalError() }
}

//@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
//extension List where SelectionValue == Never {
    /// Creates a hierarchical list that computes its rows on demand from an
    /// underlying collection of identifiable data.
    ///
    /// - Parameters:
    ///   - data: A collection of identifiable data for computing the list.
    ///   - children: A key path to a property whose non-`nil` value gives the
    ///     children of `data`. A non-`nil` but empty value denotes a node capable
    ///     of having children that is currently childless, such as an empty
    ///     directory in a file system. On the other hand, if the property at the
    ///     key path is `nil`, then `data` is treated as a leaf node in the tree,
    ///     like a regular file in a file system.
    ///   - rowContent: A view builder that creates the view for a single row of
    ///     the list.
//    @available(iOS 14.0, macOS 11.0, *)
//    @available(tvOS, unavailable)
//    @available(watchOS, unavailable)
//    @MainActor public init<Data, RowContent>(_ data: Data, children: KeyPath<Data.Element, Data?>, @ViewBuilder rowContent: @escaping (Data.Element) -> RowContent) where Content == OutlineGroup<Data, Data.Element.ID, RowContent, RowContent, DisclosureGroup<RowContent, OutlineSubgroupChildren>>, Data : RandomAccessCollection, RowContent : View, Data.Element : Identifiable { fatalError() }

    /// Creates a hierarchical list that identifies its rows based on a key path
    /// to the identifier of the underlying data.
    ///
    /// - Parameters:
    ///   - data: The data for populating the list.
    ///   - id: The key path to the data model's identifier.
    ///   - children: A key path to a property whose non-`nil` value gives the
    ///     children of `data`. A non-`nil` but empty value denotes a node capable
    ///     of having children that is currently childless, such as an empty
    ///     directory in a file system. On the other hand, if the property at the
    ///     key path is `nil`, then `data` is treated as a leaf node in the tree,
    ///     like a regular file in a file system.
    ///   - rowContent: A view builder that creates the view for a single row of
    ///     the list.
//    @available(iOS 14.0, macOS 11.0, *)
//    @available(tvOS, unavailable)
//    @available(watchOS, unavailable)
//    @MainActor public init<Data, ID, RowContent>(_ data: Data, id: KeyPath<Data.Element, ID>, children: KeyPath<Data.Element, Data?>, @ViewBuilder rowContent: @escaping (Data.Element) -> RowContent) where Content == OutlineGroup<Data, ID, RowContent, RowContent, DisclosureGroup<RowContent, OutlineSubgroupChildren>>, Data : RandomAccessCollection, ID : Hashable, RowContent : View { fatalError() }
//}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension List {

    /// Creates a list that computes its rows on demand from an underlying
    /// collection of identifiable data, optionally allowing users to select
    /// multiple rows.
    ///
    /// - Parameters:
    ///   - data: The identifiable data for computing the list.
    ///   - selection: A binding to a set that identifies selected rows.
    ///   - rowContent: A view builder that creates the view for a single row of
    ///     the list.
//    @available(watchOS, unavailable)
//    @MainActor public init<Data, RowContent>(_ data: Binding<Data>, selection: Binding<Set<SelectionValue>>?, @ViewBuilder rowContent: @escaping (Binding<Data.Element>) -> RowContent) where Content == ForEach<LazyMapSequence<Data.Indices, (Data.Index, Data.Element.ID)>, Data.Element.ID, RowContent>, Data : MutableCollection, Data : RandomAccessCollection, RowContent : View, Data.Element : Identifiable, Data.Index : Hashable { fatalError() }

    /// Creates a list that identifies its rows based on a key path to the
    /// identifier of the underlying data, optionally allowing users to select
    /// multiple rows.
    ///
    /// - Parameters:
    ///   - data: The data for populating the list.
    ///   - id: The key path to the data model's identifier.
    ///   - selection: A binding to a set that identifies selected rows.
    ///   - rowContent: A view builder that creates the view for a single row of
    ///     the list.
//    @available(watchOS, unavailable)
//    @MainActor public init<Data, ID, RowContent>(_ data: Binding<Data>, id: KeyPath<Data.Element, ID>, selection: Binding<Set<SelectionValue>>?, @ViewBuilder rowContent: @escaping (Binding<Data.Element>) -> RowContent) where Content == ForEach<LazyMapSequence<Data.Indices, (Data.Index, ID)>, ID, RowContent>, Data : MutableCollection, Data : RandomAccessCollection, ID : Hashable, RowContent : View, Data.Index : Hashable { fatalError() }

    /// Creates a list that computes its rows on demand from an underlying
    /// collection of identifiable data, optionally allowing users to select a
    /// single row.
    ///
    /// - Parameters:
    ///   - data: The identifiable data for computing the list.
    ///   - selection: A binding to a selected value.
    ///   - rowContent: A view builder that creates the view for a single row of
    ///     the list.
//    @available(watchOS, unavailable)
//    @MainActor public init<Data, RowContent>(_ data: Binding<Data>, selection: Binding<SelectionValue?>?, @ViewBuilder rowContent: @escaping (Binding<Data.Element>) -> RowContent) where Content == ForEach<LazyMapSequence<Data.Indices, (Data.Index, Data.Element.ID)>, Data.Element.ID, RowContent>, Data : MutableCollection, Data : RandomAccessCollection, RowContent : View, Data.Element : Identifiable, Data.Index : Hashable { fatalError() }

    /// Creates a list that identifies its rows based on a key path to the
    /// identifier of the underlying data, optionally allowing users to select a
    /// single row.
    ///
    /// - Parameters:
    ///   - data: The data for populating the list.
    ///   - id: The key path to the data model's identifier.
    ///   - selection: A binding to a selected value.
    ///   - rowContent: A view builder that creates the view for a single row of
    ///     the list.
//    @available(watchOS, unavailable)
//    @MainActor public init<Data, ID, RowContent>(_ data: Binding<Data>, id: KeyPath<Data.Element, ID>, selection: Binding<SelectionValue?>?, @ViewBuilder rowContent: @escaping (Binding<Data.Element>) -> RowContent) where Content == ForEach<LazyMapSequence<Data.Indices, (Data.Index, ID)>, ID, RowContent>, Data : MutableCollection, Data : RandomAccessCollection, ID : Hashable, RowContent : View, Data.Index : Hashable { fatalError() }
}

@available(iOS 15.0, macOS 12.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension List {

    /// Creates a hierarchical list that computes its rows on demand from a
    /// binding to an underlying collection of identifiable data, optionally
    /// allowing users to select multiple rows.
    ///
    /// - Parameters:
    ///   - data: The identifiable data for computing the list.
    ///   - children: A key path to a property whose non-`nil` value gives the
    ///     children of `data`. A non-`nil` but empty value denotes an element
    ///     capable of having children that's currently childless, such as an
    ///     empty directory in a file system. On the other hand, if the property
    ///     at the key path is `nil`, then the outline group treats `data` as a
    ///     leaf in the tree, like a regular file in a file system.
    ///   - selection: A binding to a set that identifies selected rows.
    ///   - rowContent: A view builder that creates the view for a single row of
    ///     the list.
//    @MainActor public init<Data, RowContent>(_ data: Binding<Data>, children: WritableKeyPath<Data.Element, Data?>, selection: Binding<Set<SelectionValue>>?, @ViewBuilder rowContent: @escaping (Binding<Data.Element>) -> RowContent) where Content == OutlineGroup<Binding<Data>, Data.Element.ID, RowContent, RowContent, DisclosureGroup<RowContent, OutlineSubgroupChildren>>, Data : MutableCollection, Data : RandomAccessCollection, RowContent : View, Data.Element : Identifiable { fatalError() }

    /// Creates a hierarchical list that identifies its rows based on a key path
    /// to the identifier of the underlying data, optionally allowing users to
    /// select multiple rows.
    ///
    /// - Parameters:
    ///   - data: The data for populating the list.
    ///   - id: The key path to the data model's identifier.
    ///   - children: A key path to a property whose non-`nil` value gives the
    ///     children of `data`. A non-`nil` but empty value denotes a node capable
    ///     of having children that is currently childless, such as an empty
    ///     directory in a file system. On the other hand, if the property at the
    ///     key path is `nil`, then `data` is treated as a leaf node in the tree,
    ///     like a regular file in a file system.
    ///   - selection: A binding to a set that identifies selected rows.
    ///   - rowContent: A view builder that creates the view for a single row of
    ///     the list.
//    @MainActor public init<Data, ID, RowContent>(_ data: Binding<Data>, id: KeyPath<Data.Element, ID>, children: WritableKeyPath<Data.Element, Data?>, selection: Binding<Set<SelectionValue>>?, @ViewBuilder rowContent: @escaping (Binding<Data.Element>) -> RowContent) where Content == OutlineGroup<Binding<Data>, ID, RowContent, RowContent, DisclosureGroup<RowContent, OutlineSubgroupChildren>>, Data : MutableCollection, Data : RandomAccessCollection, ID : Hashable, RowContent : View { fatalError() }

    /// Creates a hierarchical list that computes its rows on demand from a
    /// binding to an underlying collection of identifiable data, optionally
    /// allowing users to select a single row.
    ///
    /// - Parameters:
    ///   - data: The identifiable data for computing the list.
    ///   - children: A key path to a property whose non-`nil` value gives the
    ///     children of `data`. A non-`nil` but empty value denotes a node capable
    ///     of having children that is currently childless, such as an empty
    ///     directory in a file system. On the other hand, if the property at the
    ///     key path is `nil`, then `data` is treated as a leaf node in the tree,
    ///     like a regular file in a file system.
    ///   - selection: A binding to a selected value.
    ///   - rowContent: A view builder that creates the view for a single row of
    ///     the list.
//    @MainActor public init<Data, RowContent>(_ data: Binding<Data>, children: WritableKeyPath<Data.Element, Data?>, selection: Binding<SelectionValue?>?, @ViewBuilder rowContent: @escaping (Binding<Data.Element>) -> RowContent) where Content == OutlineGroup<Binding<Data>, Data.Element.ID, RowContent, RowContent, DisclosureGroup<RowContent, OutlineSubgroupChildren>>, Data : MutableCollection, Data : RandomAccessCollection, RowContent : View, Data.Element : Identifiable { fatalError() }

    /// Creates a hierarchical list that identifies its rows based on a key path
    /// to the identifier of the underlying data, optionally allowing users to
    /// select a single row.
    ///
    /// - Parameters:
    ///   - data: The data for populating the list.
    ///   - id: The key path to the data model's identifier.
    ///   - children: A key path to a property whose non-`nil` value gives the
    ///     children of `data`. A non-`nil` but empty value denotes a node capable
    ///     of having children that is currently childless, such as an empty
    ///     directory in a file system. On the other hand, if the property at the
    ///     key path is `nil`, then `data` is treated as a leaf node in the tree,
    ///     like a regular file in a file system.
    ///   - selection: A binding to a selected value.
    ///   - rowContent: A view builder that creates the view for a single row of
    ///     the list.
//    @MainActor public init<Data, ID, RowContent>(_ data: Binding<Data>, id: KeyPath<Data.Element, ID>, children: WritableKeyPath<Data.Element, Data?>, selection: Binding<SelectionValue?>?, @ViewBuilder rowContent: @escaping (Binding<Data.Element>) -> RowContent) where Content == OutlineGroup<Binding<Data>, ID, RowContent, RowContent, DisclosureGroup<RowContent, OutlineSubgroupChildren>>, Data : MutableCollection, Data : RandomAccessCollection, ID : Hashable, RowContent : View { fatalError() }
}

//@available(iOS 15.0, macOS 12.0, *)
//@available(tvOS, unavailable)
//@available(watchOS, unavailable)
//extension List where SelectionValue == Never {

    /// Creates a hierarchical list that computes its rows on demand from a
    /// binding to an underlying collection of identifiable data.
    ///
    /// - Parameters:
    ///   - data: A collection of identifiable data for computing the list.
    ///   - children: A key path to a property whose non-`nil` value gives the
    ///     children of `data`. A non-`nil` but empty value denotes a node capable
    ///     of having children that is currently childless, such as an empty
    ///     directory in a file system. On the other hand, if the property at the
    ///     key path is `nil`, then `data` is treated as a leaf node in the tree,
    ///     like a regular file in a file system.
    ///   - rowContent: A view builder that creates the view for a single row of
    ///     the list.
//    @MainActor public init<Data, RowContent>(_ data: Binding<Data>, children: WritableKeyPath<Data.Element, Data?>, @ViewBuilder rowContent: @escaping (Binding<Data.Element>) -> RowContent) where Content == OutlineGroup<Binding<Data>, Data.Element.ID, RowContent, RowContent, DisclosureGroup<RowContent, OutlineSubgroupChildren>>, Data : MutableCollection, Data : RandomAccessCollection, RowContent : View, Data.Element : Identifiable { fatalError() }

    /// Creates a hierarchical list that identifies its rows based on a key path
    /// to the identifier of the underlying data.
    ///
    /// - Parameters:
    ///   - data: The data for populating the list.
    ///   - id: The key path to the data model's identifier.
    ///   - children: A key path to a property whose non-`nil` value gives the
    ///     children of `data`. A non-`nil` but empty value denotes a node capable
    ///     of having children that is currently childless, such as an empty
    ///     directory in a file system. On the other hand, if the property at the
    ///     key path is `nil`, then `data` is treated as a leaf node in the tree,
    ///     like a regular file in a file system.
    ///   - rowContent: A view builder that creates the view for a single row of
    ///     the list.
//    @MainActor public init<Data, ID, RowContent>(_ data: Binding<Data>, id: KeyPath<Data.Element, ID>, children: WritableKeyPath<Data.Element, Data?>, @ViewBuilder rowContent: @escaping (Binding<Data.Element>) -> RowContent) where Content == OutlineGroup<Binding<Data>, ID, RowContent, RowContent, DisclosureGroup<RowContent, OutlineSubgroupChildren>>, Data : MutableCollection, Data : RandomAccessCollection, ID : Hashable, RowContent : View { fatalError() }
//}

@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
extension List {

    /// Creates a list that computes its rows on demand from an underlying
    /// collection of identifiable, allows to edit the collection, and
    /// optionally allows users to select multiple rows.
    ///
    /// The following example creates a list to display a collection of favorite
    /// foods allowing the user to delete or move elements from the
    /// collection, and select multiple elements.
    ///
    ///     List(
    ///         $foods,
    ///         editActions: [.delete, .move],
    ///         selection: $selectedFoods
    ///     ) { $food in
    ///        HStack {
    ///            Text(food.name)
    ///            Toggle("Favorite", isOn: $food.isFavorite)
    ///        }
    ///     }
    ///
    /// Use ``View/deleteDisabled(_:)`` and ``View/moveDisabled(_:)``
    /// to disable respectively delete or move actions on a per-row basis.
    ///
    /// Explicit ``DynamicViewContent.onDelete(perform:)``,
    /// ``DynamicViewContent.onMove(perform:)``, or
    /// ``View.swipeActions(edge:allowsFullSwipe:content:)``
    /// modifiers will override any synthesized action
    ///
    /// - Parameters:
    ///   - data: The identifiable data for computing and to be edited by
    ///     the list.
    ///   - editActions: The edit actions that are synthesized on `data`.
    ///   - selection: A binding to a set that identifies selected rows.
    ///   - rowContent: A view builder that creates the view for a single row of
    ///     the list.
//    @available(watchOS, unavailable)
//    @MainActor public init<Data, RowContent>(_ data: Binding<Data>, editActions: EditActions /* <Data> */, selection: Binding<Set<SelectionValue>>?, @ViewBuilder rowContent: @escaping (Binding<Data.Element>) -> RowContent) where Content == ForEach<IndexedIdentifierCollection<Data, Data.Element.ID>, Data.Element.ID, EditableCollectionContent<RowContent, Data>>, Data : MutableCollection, Data : RandomAccessCollection, RowContent : View, Data.Element : Identifiable, Data.Index : Hashable { fatalError() }

    /// Creates a list that computes its rows on demand from an underlying
    /// collection of identifiable, allows to edit the collection, and
    /// optionally allows users to select multiple rows.
    ///
    /// The following example creates a list to display a collection of favorite
    /// foods allowing the user to delete or move elements from the
    /// collection, and select multiple elements.
    ///
    ///     List(
    ///         $foods,
    ///         editActions: [.delete, .move],
    ///         selection: $selectedFoods
    ///     ) { $food in
    ///        HStack {
    ///            Text(food.name)
    ///            Toggle("Favorite", isOn: $food.isFavorite)
    ///        }
    ///     }
    ///
    /// Use ``View/deleteDisabled(_:)`` and ``View/moveDisabled(_:)``
    /// to disable respectively delete or move actions on a per-row basis.
    ///
    /// Explicit ``DynamicViewContent.onDelete(perform:)``,
    /// ``DynamicViewContent.onMove(perform:)``, or
    /// ``View.swipeActions(edge:allowsFullSwipe:content:)``
    /// modifiers will override any synthesized action
    ///
    /// - Parameters:
    ///   - data: The identifiable data for computing and to be edited by
    ///     the list.
    ///   - id: The key path to the data model's identifier.
    ///   - editActions: The edit actions that are synthesized on `data`.
    ///   - selection: A binding to a set that identifies selected rows.
    ///   - rowContent: A view builder that creates the view for a single row of
    ///
//    @available(watchOS, unavailable)
//    @MainActor public init<Data, ID, RowContent>(_ data: Binding<Data>, id: KeyPath<Data.Element, ID>, editActions: EditActions /* <Data> */, selection: Binding<Set<SelectionValue>>?, @ViewBuilder rowContent: @escaping (Binding<Data.Element>) -> RowContent) where Content == ForEach<IndexedIdentifierCollection<Data, ID>, ID, EditableCollectionContent<RowContent, Data>>, Data : MutableCollection, Data : RandomAccessCollection, ID : Hashable, RowContent : View, Data.Index : Hashable { fatalError() }
}

@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
extension List {

    /// Creates a list that computes its rows on demand from an underlying
    /// collection of identifiable data, allows to edit the collection, and
    /// optionally allowing users to select a single row.
    ///
    /// The following example creates a list to display a collection of favorite
    /// foods allowing the user to delete or move elements from the
    /// collection, and select a single elements.
    ///
    ///     List(
    ///         $foods,
    ///         editActions: [.delete, .move],
    ///         selection: $selectedFood
    ///     ) { $food in
    ///        HStack {
    ///            Text(food.name)
    ///            Toggle("Favorite", isOn: $food.isFavorite)
    ///        }
    ///     }
    ///
    /// Use ``View/deleteDisabled(_:)`` and ``View/moveDisabled(_:)``
    /// to disable respectively delete or move actions on a per-row basis.
    ///
    /// Explicit ``DynamicViewContent.onDelete(perform:)``,
    /// ``DynamicViewContent.onMove(perform:)``, or
    /// ``View.swipeActions(edge:allowsFullSwipe:content:)``
    /// modifiers will override any synthesized action
    ///
    /// - Parameters:
    ///   - data: The identifiable data for computing the list.
    ///   - editActions: The edit actions that are synthesized on `data`.
    ///   - selection: A binding to a selected value.
    ///   - rowContent: A view builder that creates the view for a single row of
    ///     the list.
//    @available(watchOS, unavailable)
//    @MainActor public init<Data, RowContent>(_ data: Binding<Data>, editActions: EditActions /* <Data> */, selection: Binding<SelectionValue?>?, @ViewBuilder rowContent: @escaping (Binding<Data.Element>) -> RowContent) where Content == ForEach<IndexedIdentifierCollection<Data, Data.Element.ID>, Data.Element.ID, EditableCollectionContent<RowContent, Data>>, Data : MutableCollection, Data : RandomAccessCollection, RowContent : View, Data.Element : Identifiable, Data.Index : Hashable { fatalError() }

    /// Creates a list that computes its rows on demand from an underlying
    /// collection of identifiable data, allows to edit the collection, and
    /// optionally allowing users to select a single row.
    ///
    /// The following example creates a list to display a collection of favorite
    /// foods allowing the user to delete or move elements from the
    /// collection, and select a single elements.
    ///
    ///     List(
    ///         $foods,
    ///         editActions: [.delete, .move],
    ///         selection: $selectedFood
    ///     ) { $food in
    ///        HStack {
    ///            Text(food.name)
    ///            Toggle("Favorite", isOn: $food.isFavorite)
    ///        }
    ///     }
    ///
    /// Use ``View/deleteDisabled(_:)`` and ``View/moveDisabled(_:)``
    /// to disable respectively delete or move actions on a per-row basis.
    ///
    /// Explicit ``DynamicViewContent.onDelete(perform:)``,
    /// ``DynamicViewContent.onMove(perform:)``, or
    /// ``View.swipeActions(edge:allowsFullSwipe:content:)``
    /// modifiers will override any synthesized action
    ///
    /// - Parameters:
    ///   - data: The identifiable data for computing the list.
    ///   - id: The key path to the data model's identifier.
    ///   - editActions: The edit actions that are synthesized on `data`.
    ///   - selection: A binding to a selected value.
    ///   - rowContent: A view builder that creates the view for a single row of
    ///     the list.
//    @available(watchOS, unavailable)
//    @MainActor public init<Data, ID, RowContent>(_ data: Binding<Data>, id: KeyPath<Data.Element, ID>, editActions: EditActions /* <Data> */, selection: Binding<SelectionValue?>?, @ViewBuilder rowContent: @escaping (Binding<Data.Element>) -> RowContent) where Content == ForEach<IndexedIdentifierCollection<Data, ID>, ID, EditableCollectionContent<RowContent, Data>>, Data : MutableCollection, Data : RandomAccessCollection, ID : Hashable, RowContent : View, Data.Index : Hashable { fatalError() }
}

#endif
