// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

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
import androidx.compose.runtime.rememberUpdatedState
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.shadow
import androidx.compose.ui.zIndex
import androidx.compose.ui.unit.dp
import org.burnoutcrew.reorderable.ReorderableItem
import org.burnoutcrew.reorderable.ReorderableLazyListState
import org.burnoutcrew.reorderable.detectReorderAfterLongPress
import org.burnoutcrew.reorderable.rememberReorderableLazyListState
import org.burnoutcrew.reorderable.reorderable
#else
import struct CoreGraphics.CGFloat
#endif

// Erase the SelectionValue because it is currently unused in Kotlin, the compiler won't be able to calculate it
//
// SKIP DECLARE: class List<Content>: View where Content: View
public struct List<SelectionValue, Content> : View where SelectionValue: Hashable, Content : View {
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

    public init(@ViewBuilder content: () -> Content) {
        self.init(fixedContent: content())
    }

    @available(*, unavailable)
    public init(selection: Binding<Any>, @ViewBuilder content: () -> Content) {
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
        let factoryContext = ListItemFactoryContext()
        let remberedFactoryContext = rememberUpdatedState(factoryContext)
        let reorderableState = rememberReorderableLazyListState(onMove: { from, to in
            remberedFactoryContext.value.move(from: from.index, to: to.index)
        }, canDragOver: { candidate, dragging in
            remberedFactoryContext.value.canMove(from: dragging.index, to: candidate.index)
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

            factoryContext.initialize(
                item: { view in
                    item {
                        view.Compose(context: itemContext(for: context, modifier: Modifier.animateItemPlacement(), style: style))
                    }
                },
                indexedItems: { range, identifier, factory in
                    let count = range.endExclusive - range.start
                    items(count: count, key: identifier == nil ? nil : { composeBundleString(for: identifier!($0)) }) { index in
                        factory(index).Compose(context: itemContext(for: context, modifier: Modifier.animateItemPlacement(), style: style))
                    }
                },
                objectItems: { objects, identifier, factory in
                    items(count: objects.count, key: { composeBundleString(for: identifier(objects[$0])) }) { index in
                        factory(objects[index]).Compose(context: itemContext(for: context, modifier: Modifier.animateItemPlacement(), style: style))
                    }
                },
                objectBindingItems: { objectsBinding, identifier, editActions, factory in
                    items(count: objectsBinding.wrappedValue.count, key: { composeBundleString(for: identifier(objectsBinding.wrappedValue[$0])) }) { index in
                        let editableItemContext = context.content(composer: ClosureComposer { view, context in
                            ComposeEditableItem(view: view, context: context(false), modifier: Modifier.animateItemPlacement(), style: style, objectsBinding: objectsBinding, identifier: identifier, index: index, editActions: editActions, reorderableState: reorderableState)
                        })
                        factory(objectsBinding, index).Compose(context: editableItemContext)
                    }
                },
                sectionHeader: { view in
                    // Important to check the count immediately, outside the lazy list scope blocks
                    let context = factoryContext.count == 0 ? topSectionHeaderContext : sectionHeaderContext
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
                    factory.ComposeListItems(context: factoryContext)
                } else {
                    factoryContext.item(view)
                }
            }
            item {
                ComposeFooter(style: style)
            }
        }
    }

    /// Create a list item-rendering compose context for item views.
    private func itemContext(for context: ComposeContext, modifier: Modifier, style: ListStyle) -> ComposeContext {
        return context.content(composer: ClosureComposer { view, context in
            ComposeItem(view: view, context: context(false), modifier: modifier, style: style)
        })
    }

    private static let horizontalInset = 16.0
    private static let verticalInset = 32.0
    private static let minimumItemHeight = 44.0
    private static let horizontalItemInset = 16.0
    private static let verticalItemInset = 4.0

    @Composable private func ComposeItem(view: View, context: ComposeContext, modifier: Modifier = Modifier, style: ListStyle) {
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
    @Composable private func ComposeEditableItem(view: View, context: ComposeContext, modifier: Modifier, style: ListStyle, objectsBinding: Binding<RandomAccessCollection<Any>>, identifier: (Any) -> AnyHashable, index: Int, editActions: EditActions = [], reorderableState: ReorderableLazyListState) {
        let editActionsModifiers = EditActionsModifierView.unwrap(view: view)
        let isDeleteEnabled = editActions.contains(.delete) && editActionsModifiers?.isDeleteDisabled != true
        let isMoveEnabled = editActions.contains(.move) && editActionsModifiers?.isMoveDisabled != true
        guard isDeleteEnabled || isMoveEnabled else {
            ComposeItem(view: view, context: context, modifier: modifier, style: style)
            return
        }

        let key = composeBundleString(for: identifier(objectsBinding.wrappedValue[index]))
        if isDeleteEnabled {
            let rememberedIndex = rememberUpdatedState(index)
            let rememberedBinding = rememberUpdatedState(objectsBinding)
            let dismissState = rememberDismissState(confirmValueChange: {
                if $0 == DismissValue.DismissedToStart, rememberedBinding.value.wrappedValue.count > rememberedIndex.value {
                    (rememberedBinding.value.wrappedValue as? RangeReplaceableCollection<Any>)?.remove(at: rememberedIndex.value)
                }
                return true
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
public func List<ObjectType, Content>(_ data: any RandomAccessCollection<ObjectType>, @ViewBuilder rowContent: (ObjectType) -> Content) -> List<Content> where ObjectType: Identifiable<Hashable>, Content: View {
    return List(identifier: { ($0 as! ObjectType).id }, objects: data as! RandomAccessCollection<Any>, objectContent: { rowContent($0 as! ObjectType) })
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
public func List<Data, ObjectType, Content>(_ data: Binding<Data>, editActions: EditActions = [], @ViewBuilder rowContent: (Binding<ObjectType>) -> Content) -> List<Content> where Data: RandomAccessCollection<ObjectType>, ObjectType: Identifiable<Hashable>, Content: View {
    return List(identifier: { ($0 as! ObjectType).id }, objectsBinding: data as! Binding<RandomAccessCollection<Any>>, objectsBindingContent: { data, index in
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
    private(set) var indexedItems: (Range<Int>, ((Any) -> AnyHashable)?, (Int) -> View) -> Void = { _, _, _ in  }
    private(set) var objectItems: (RandomAccessCollection<Any>, (Any) -> AnyHashable, (Any) -> View) -> Void = { _, _, _ in }
    private(set) var objectBindingItems: (Binding<RandomAccessCollection<Any>>, (Any) -> AnyHashable, EditActions, (Binding<RandomAccessCollection<Any>>, Int) -> View) -> Void = { _, _, _, _ in }

    private(set) var sectionHeader: (View) -> Void = { _ in }
    private(set) var sectionFooter: (View) -> Void = { _ in }

    /// Initialize the content factories.
    func initialize(item: (View) -> Void,
                    indexedItems: (Range<Int>, ((Any) -> AnyHashable)?, (Int) -> View) -> Void,
                    objectItems: (RandomAccessCollection<Any>, (Any) -> AnyHashable, (Any) -> View) -> Void,
                    objectBindingItems: (Binding<RandomAccessCollection<Any>>, (Any) -> AnyHashable, EditActions, (Binding<RandomAccessCollection<Any>>, Int) -> View) -> Void,
                    sectionHeader: (View) -> Void,
                    sectionFooter: (View) -> Void) {
        content.removeAll()
        self.item = { view in
            item(view)
            content.append(.items(1))
        }
        self.indexedItems = { range, identifier, factory in
            indexedItems(range, identifier, factory)
            content.append(.items(range.endExclusive - range.start))
        }
        self.objectItems = { objects, identifier, factory in
            objectItems(objects, identifier, factory)
            content.append(.objectItems(objects))
        }
        self.objectBindingItems = { binding, identifier, editActions, factory in
            objectBindingItems(binding, identifier, editActions, factory)
            content.append(.objectBindingItems(binding))
        }
        self.sectionHeader = { view in
            sectionHeader(view)
            content.append(.items(1))
        }
        self.sectionFooter = { view in
            sectionFooter(view)
            content.append(.items(1))
        }
    }

    /// The current number of items.
    var count: Int {
        var itemCount = 0
        for content in self.content {
            switch content {
            case .items(let count): itemCount += count
            case .objectItems(let objects): itemCount += objects.count
            case .objectBindingItems(let binding): itemCount += binding.wrappedValue.count
            }
        }
        return itemCount
    }

    /// Move an item.
    func move(from fromIndex: Int, to toIndex: Int) {
        if fromIndex == toIndex {
            return
        }
        var itemIndex = 1 // List header
        for content in self.content {
            switch content {
            case .items(let count): itemIndex += count
            case .objectItems(let objects): itemIndex += objects.count
            case .objectBindingItems(let binding):
                if min(fromIndex, toIndex) >= itemIndex && max(fromIndex, toIndex) < itemIndex + binding.wrappedValue.count {
                    if let element = (binding.wrappedValue as? RangeReplaceableCollection<Any>)?.remove(at: fromIndex - itemIndex) {
                        (binding.wrappedValue as? RangeReplaceableCollection<Any>)?.insert(element, at: toIndex - itemIndex)
                    }
                    return
                } else {
                    itemIndex += binding.wrappedValue.count
                }
            }
        }
    }

    /// Whether a given move would be permitted.
    func canMove(from fromIndex: Int, to toIndex: Int) -> Bool {
        if fromIndex == toIndex {
            return true
        }
        var itemIndex = 1 // List header
        for content in self.content {
            switch content {
            case .items(let count): itemIndex += count
            case .objectItems(let objects): itemIndex += objects.count
            case .objectBindingItems(let binding):
                if fromIndex >= itemIndex && fromIndex < itemIndex + binding.wrappedValue.count {
                    return toIndex >= itemIndex && toIndex < itemIndex + binding.wrappedValue.count
                } else {
                    itemIndex += binding.wrappedValue.count
                }
            }
        }
        return false
    }

    private enum Content {
        case items(Int)
        case objectItems(RandomAccessCollection<Any>)
        case objectBindingItems(Binding<RandomAccessCollection<Any>>)
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
    @available(iOS 14.0, macOS 11.0, *)
    @available(tvOS, unavailable)
    @available(watchOS, unavailable)
    @MainActor public init<Data, RowContent>(_ data: Data, children: KeyPath<Data.Element, Data?>, selection: Binding<Set<SelectionValue>>?, @ViewBuilder rowContent: @escaping (Data.Element) -> RowContent) where Content == OutlineGroup<Data, Data.Element.ID, RowContent, RowContent, DisclosureGroup<RowContent, OutlineSubgroupChildren>>, Data : RandomAccessCollection, RowContent : View, Data.Element : Identifiable { fatalError() }

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
    @available(iOS 14.0, macOS 11.0, *)
    @available(tvOS, unavailable)
    @available(watchOS, unavailable)
    @MainActor public init<Data, ID, RowContent>(_ data: Data, id: KeyPath<Data.Element, ID>, children: KeyPath<Data.Element, Data?>, selection: Binding<Set<SelectionValue>>?, @ViewBuilder rowContent: @escaping (Data.Element) -> RowContent) where Content == OutlineGroup<Data, ID, RowContent, RowContent, DisclosureGroup<RowContent, OutlineSubgroupChildren>>, Data : RandomAccessCollection, ID : Hashable, RowContent : View { fatalError() }

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
    @available(iOS 14.0, macOS 11.0, *)
    @available(tvOS, unavailable)
    @available(watchOS, unavailable)
    @MainActor public init<Data, RowContent>(_ data: Data, children: KeyPath<Data.Element, Data?>, selection: Binding<SelectionValue?>?, @ViewBuilder rowContent: @escaping (Data.Element) -> RowContent) where Content == OutlineGroup<Data, Data.Element.ID, RowContent, RowContent, DisclosureGroup<RowContent, OutlineSubgroupChildren>>, Data : RandomAccessCollection, RowContent : View, Data.Element : Identifiable { fatalError() }

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
    @available(iOS 14.0, macOS 11.0, *)
    @available(tvOS, unavailable)
    @available(watchOS, unavailable)
    @MainActor public init<Data, ID, RowContent>(_ data: Data, id: KeyPath<Data.Element, ID>, children: KeyPath<Data.Element, Data?>, selection: Binding<SelectionValue?>?, @ViewBuilder rowContent: @escaping (Data.Element) -> RowContent) where Content == OutlineGroup<Data, ID, RowContent, RowContent, DisclosureGroup<RowContent, OutlineSubgroupChildren>>, Data : RandomAccessCollection, ID : Hashable, RowContent : View { fatalError() }

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

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension List where SelectionValue == Never {
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
    @available(iOS 14.0, macOS 11.0, *)
    @available(tvOS, unavailable)
    @available(watchOS, unavailable)
    @MainActor public init<Data, RowContent>(_ data: Data, children: KeyPath<Data.Element, Data?>, @ViewBuilder rowContent: @escaping (Data.Element) -> RowContent) where Content == OutlineGroup<Data, Data.Element.ID, RowContent, RowContent, DisclosureGroup<RowContent, OutlineSubgroupChildren>>, Data : RandomAccessCollection, RowContent : View, Data.Element : Identifiable { fatalError() }

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
    @available(iOS 14.0, macOS 11.0, *)
    @available(tvOS, unavailable)
    @available(watchOS, unavailable)
    @MainActor public init<Data, ID, RowContent>(_ data: Data, id: KeyPath<Data.Element, ID>, children: KeyPath<Data.Element, Data?>, @ViewBuilder rowContent: @escaping (Data.Element) -> RowContent) where Content == OutlineGroup<Data, ID, RowContent, RowContent, DisclosureGroup<RowContent, OutlineSubgroupChildren>>, Data : RandomAccessCollection, ID : Hashable, RowContent : View { fatalError() }
}

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
    @MainActor public init<Data, RowContent>(_ data: Binding<Data>, children: WritableKeyPath<Data.Element, Data?>, selection: Binding<Set<SelectionValue>>?, @ViewBuilder rowContent: @escaping (Binding<Data.Element>) -> RowContent) where Content == OutlineGroup<Binding<Data>, Data.Element.ID, RowContent, RowContent, DisclosureGroup<RowContent, OutlineSubgroupChildren>>, Data : MutableCollection, Data : RandomAccessCollection, RowContent : View, Data.Element : Identifiable { fatalError() }

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
    @MainActor public init<Data, ID, RowContent>(_ data: Binding<Data>, id: KeyPath<Data.Element, ID>, children: WritableKeyPath<Data.Element, Data?>, selection: Binding<Set<SelectionValue>>?, @ViewBuilder rowContent: @escaping (Binding<Data.Element>) -> RowContent) where Content == OutlineGroup<Binding<Data>, ID, RowContent, RowContent, DisclosureGroup<RowContent, OutlineSubgroupChildren>>, Data : MutableCollection, Data : RandomAccessCollection, ID : Hashable, RowContent : View { fatalError() }

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
    @MainActor public init<Data, RowContent>(_ data: Binding<Data>, children: WritableKeyPath<Data.Element, Data?>, selection: Binding<SelectionValue?>?, @ViewBuilder rowContent: @escaping (Binding<Data.Element>) -> RowContent) where Content == OutlineGroup<Binding<Data>, Data.Element.ID, RowContent, RowContent, DisclosureGroup<RowContent, OutlineSubgroupChildren>>, Data : MutableCollection, Data : RandomAccessCollection, RowContent : View, Data.Element : Identifiable { fatalError() }

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
    @MainActor public init<Data, ID, RowContent>(_ data: Binding<Data>, id: KeyPath<Data.Element, ID>, children: WritableKeyPath<Data.Element, Data?>, selection: Binding<SelectionValue?>?, @ViewBuilder rowContent: @escaping (Binding<Data.Element>) -> RowContent) where Content == OutlineGroup<Binding<Data>, ID, RowContent, RowContent, DisclosureGroup<RowContent, OutlineSubgroupChildren>>, Data : MutableCollection, Data : RandomAccessCollection, ID : Hashable, RowContent : View { fatalError() }
}

@available(iOS 15.0, macOS 12.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension List where SelectionValue == Never {

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
    @MainActor public init<Data, RowContent>(_ data: Binding<Data>, children: WritableKeyPath<Data.Element, Data?>, @ViewBuilder rowContent: @escaping (Binding<Data.Element>) -> RowContent) where Content == OutlineGroup<Binding<Data>, Data.Element.ID, RowContent, RowContent, DisclosureGroup<RowContent, OutlineSubgroupChildren>>, Data : MutableCollection, Data : RandomAccessCollection, RowContent : View, Data.Element : Identifiable { fatalError() }

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
    @MainActor public init<Data, ID, RowContent>(_ data: Binding<Data>, id: KeyPath<Data.Element, ID>, children: WritableKeyPath<Data.Element, Data?>, @ViewBuilder rowContent: @escaping (Binding<Data.Element>) -> RowContent) where Content == OutlineGroup<Binding<Data>, ID, RowContent, RowContent, DisclosureGroup<RowContent, OutlineSubgroupChildren>>, Data : MutableCollection, Data : RandomAccessCollection, ID : Hashable, RowContent : View { fatalError() }
}

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
