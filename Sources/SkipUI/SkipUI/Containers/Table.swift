// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

import Foundation
#if SKIP
import androidx.compose.foundation.ExperimentalFoundationApi
import androidx.compose.foundation.background
import androidx.compose.foundation.clickable
import androidx.compose.foundation.interaction.MutableInteractionSource
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.requiredHeightIn
import androidx.compose.foundation.layout.width
import androidx.compose.foundation.layout.requiredWidthIn
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.rememberLazyListState
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.Stable
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.rememberCoroutineScope
import androidx.compose.runtime.rememberUpdatedState
import androidx.compose.ui.Modifier
import androidx.compose.ui.zIndex
import androidx.compose.ui.platform.LocalDensity
import androidx.compose.ui.unit.Density
import androidx.compose.ui.unit.Dp
import androidx.compose.ui.unit.dp
import kotlinx.coroutines.delay
import kotlinx.coroutines.launch
#endif

// SKIP INSERT: @Stable // Otherwise Compose recomposes all internal @Composable funcs because 'this' is unstable
@available(iOS 16.0, macOS 14.0, *)
public final class Table<ObjectType, ID> : View where ObjectType: Identifiable<ID> {
    let data: any RandomAccessCollection<ObjectType>
    var selection: Binding<Any?>?
    let columnSpecs: ComposeBuilder

    // Note: The SwiftUI.Table content block does *not* accept any arguments. We add the argument to the
    // Kotlin transpilation so that we can also add it to each nested TableColumn call, which in turn allows
    // the Kotlin compiler to infer the expected ObjectType for the columns. Otherwise TableColumn calls
    // don't have enough information for the Kotlin compiler to infer their generic type
    public init(_ data: any RandomAccessCollection<ObjectType>, selection: Any? = nil, @ViewBuilder content: (any RandomAccessCollection<ObjectType>) -> any View) {
        self.data = data
        self.selection = selection as? Binding<Any?>
        let view = content(data)
        self.columnSpecs = view as? ComposeBuilder ?? ComposeBuilder(view: view)
    }

    #if SKIP
    @Composable public override func ComposeContent(context: ComposeContext) {
        // When we layout, extend into safe areas that are due to system bars, not into any app chrome. We'll add
        // blank head
        let safeArea = EnvironmentValues.shared._safeArea
        var ignoresSafeAreaEdges: Edge.Set = [.top, .bottom]
        ignoresSafeAreaEdges.formIntersection(safeArea?.absoluteSystemBarEdges ?? [])
        let itemContext = context.content()
        IgnoresSafeAreaLayout(edges: ignoresSafeAreaEdges, context: context) { context in
            ComposeContainer(scrollAxes: .vertical, modifier: context.modifier, fillWidth: true, fillHeight: true) { modifier in
                Box(modifier: modifier) {
                    let density = LocalDensity.current
                    let headerSafeAreaHeight = headerSafeAreaHeight(safeArea, density: density)
                    let footerSafeAreaHeight = footerSafeAreaHeight(safeArea, density: density)
                    ComposeTable(context: itemContext, headerSafeAreaHeight: headerSafeAreaHeight, footerSafeAreaHeight: footerSafeAreaHeight)
                }
            }
        }
    }

    // SKIP INSERT: @OptIn(ExperimentalFoundationApi::class)
    @Composable private func ComposeTable(context: ComposeContext, headerSafeAreaHeight: Dp, footerSafeAreaHeight: Dp) {
        // Collect all top-level views to compose. The LazyColumn itself is not a composable context, so we have to gather
        // our content before entering the LazyColumn body, then use LazyColumn's LazyListScope functions to compose
        // individual items
        let columnSpecs = self.columnSpecs.collectViews(context: context)
        let modifier = context.modifier.fillMaxWidth()

        let listState = rememberLazyListState()
        // Integrate with our scroll-to-top navigation bar taps
        let coroutineScope = rememberCoroutineScope()
        PreferenceValues.shared.contribute(context: context, key: ScrollToTopPreferenceKey.self, value: {
            coroutineScope.launch {
                listState.animateScrollToItem(0)
            }
        })

        // See explanation in List.swift
        let forceUnanimatedItems = remember { mutableStateOf(false) }
        if Animation.current(isAnimating: false) == nil {
            forceUnanimatedItems.value = true
            LaunchedEffect(System.currentTimeMillis()) {
                delay(300)
                forceUnanimatedItems.value = false
            }
        } else {
            forceUnanimatedItems.value = false
        }

        let shouldAnimateItems: @Composable () -> Bool = {
            // We disable animation to prevent filtered items from animating when they return
            !forceUnanimatedItems.value && EnvironmentValues.shared._searchableState?.isFiltering() != true
        }

        let key: (Int) -> String = { composeBundleString(for: data[$0].id) }
        let isCompact = EnvironmentValues.shared.horizontalSizeClass == .compact
        LazyColumn(state: listState, modifier: modifier) {
            if headerSafeAreaHeight.value > 0 {
                item {
                    ComposeHeaderFooter(safeAreaHeight: headerSafeAreaHeight)
                }
            }
            if !isCompact {
                item {
                    let animationModifier = shouldAnimateItems() ? Modifier.animateItemPlacement() : Modifier
                    ComposeHeadersRow(columnSpecs: columnSpecs, context: context, animationModifier: animationModifier)
                }
            }
            items(count: data.count, key: key) { index in
                let animationModifier = shouldAnimateItems() ? Modifier.animateItemPlacement() : Modifier
                ComposeRow(columnSpecs: columnSpecs, index: index, context: context, isCompact: isCompact, animationModifier: animationModifier)
            }
            if footerSafeAreaHeight.value > 0.0 {
                item {
                    ComposeHeaderFooter(safeAreaHeight: footerSafeAreaHeight)
                }
            }
        }
    }

    @Composable private func ComposeHeadersRow(columnSpecs: [View], context: ComposeContext, animationModifier: Modifier) {
        let modifier = Modifier.fillMaxWidth().then(animationModifier)
        let foregroundStyle: ShapeStyle = EnvironmentValues.shared._foregroundStyle ?? Color.accentColor
        EnvironmentValues.shared.setValues {
            $0.set_foregroundStyle(foregroundStyle)
        } in: {
            Column(modifier: modifier) {
                Row(modifier: List.contentModifier(level: 0), verticalAlignment: androidx.compose.ui.Alignment.CenterVertically) {
                    for columnSpec in columnSpecs {
                        guard let tableColumn = columnSpec as? TableColumn else {
                            continue
                        }
                        let itemContentModifier = modifier(for: tableColumn.columnWidth, defaultWeight:  Modifier.weight(Float(1.0)))
                        let itemContext = context.content(modifier: itemContentModifier)
                        tableColumn.columnHeader.Compose(context: itemContext)
                    }
                }
                List.ComposeSeparator(level: 0)
            }
        }
    }

    @Composable private func ComposeRow(columnSpecs: [View], index: Int, context: ComposeContext, isCompact: Bool, animationModifier: Modifier) {
        var modifier = Modifier.fillMaxWidth()
        let itemID = rememberUpdatedState(data[index].id)
        let isSelected = isSelected(id: itemID.value)
        if isSelected {
            let selectionColor = isCompact ? Color.separator.colorImpl() : (EnvironmentValues.shared._tint?.colorImpl() ?? Color.accentColor.colorImpl())
            modifier = modifier.background(selectionColor)
        }
        if selection != nil {
            let interactionSource = remember { MutableInteractionSource() }
            modifier = modifier.clickable(interactionSource, nil) {
                select(id: itemID.value)
            }
        }
        modifier = modifier.then(animationModifier)
        let foregroundStyle = EnvironmentValues.shared._foregroundStyle
        Column(modifier: modifier) {
            Row(modifier: List.contentModifier(level: 0), verticalAlignment: androidx.compose.ui.Alignment.CenterVertically) {
                let count = isCompact ? 1 : columnSpecs.count
                for i in 0..<min(count, columnSpecs.count) {
                    guard let tableColumn = columnSpecs[i] as? TableColumn else {
                        continue
                    }
                    let itemContentModifier = isCompact ? Modifier.fillMaxWidth() : modifier(for: tableColumn.columnWidth, defaultWeight: Modifier.weight(Float(1.0)))
                    let itemComposer = ListItemComposer(contentModifier: itemContentModifier)
                    let itemContext = context.content(composer: itemComposer)

                    var itemForegroundStyle: ShapeStyle? = foregroundStyle
                    if itemForegroundStyle == nil {
                        if isSelected && !isCompact {
                            itemForegroundStyle = i == 0 ? Color.white : Color.white.opacity(0.8)
                        } else {
                            itemForegroundStyle = i == 0 ? nil : Color.secondary
                        }
                    }
                    let placement = EnvironmentValues.shared._placement
                    EnvironmentValues.shared.setValues {
                        $0.set_foregroundStyle(itemForegroundStyle)
                        $0.set_placement(placement.union(ViewPlacement.listItem))
                    } in: {
                        tableColumn.cellContent(data[index]).Compose(context: itemContext)
                    }
                }
            }
            List.ComposeSeparator(level: 0)
        }
    }

    /// - Warning: Only call with a positive safe area height. This is distinct from having this function detect
    /// and return without rendering. That causes a weird rubber banding effect on overscroll.
    @Composable private func ComposeHeaderFooter(safeAreaHeight: Dp) {
        let modifier = Modifier.fillMaxWidth()
            .height(safeAreaHeight)
            .zIndex(Float(0.5))
            .background(Color.background.colorImpl())
        Box(modifier: modifier) {
        }
    }

    @Composable private func modifier(for width: TableColumn.WidthSpec, defaultWeight: Modifier) -> Modifier {
        switch width {
        case .fixed(let value):
            return Modifier.width(value.dp)
        case .range(let min, let ideal, let max):
            // Mirror the logic we use in FrameLayout
            if max == Double.infinity {
                var modifier = defaultWeight
                if let min, min > 0.0 {
                    modifier = modifier.requiredWidthIn(min: min.dp)
                }
                return modifier
            } else if min != nil || max != nil {
                return Modifier.requiredWidthIn(min: min != nil ? min!.dp : Dp.Unspecified, max: max != nil ? max!.dp : Dp.Unspecified)
            } else {
                return defaultWeight
            }
        case .default:
            return defaultWeight
        }
    }

    private func headerSafeAreaHeight(_ safeArea: SafeArea?, density: Density) -> Dp {
        guard let safeArea, safeArea.absoluteSystemBarEdges.contains(.top) && safeArea.safeBoundsPx.top > safeArea.presentationBoundsPx.top else {
            return 0.dp
        }
        return with(density) { (safeArea.safeBoundsPx.top - safeArea.presentationBoundsPx.top).toDp() }
    }

    private func footerSafeAreaHeight(_ safeArea: SafeArea?, density: Density) -> Dp {
        guard let safeArea, safeArea.absoluteSystemBarEdges.contains(.bottom) && safeArea.presentationBoundsPx.bottom > safeArea.safeBoundsPx.bottom else {
            return 0.dp
        }
        return with(density) { (safeArea.presentationBoundsPx.bottom - safeArea.safeBoundsPx.bottom).toDp() }
    }
    #else
    public var body: some View {
        stubView()
    }
    #endif

    private func isSelected(id: ID) -> Bool {
        let wrappedValue = selection?.wrappedValue
        // SKIP NOWARN
        if let set = wrappedValue as? Set<ID> {
            return set.contains(id)
        } else {
            return id == (wrappedValue as? ID)
        }
    }

    private func select(id: ID) {
        // SKIP NOWARN
        if selection?.wrappedValue is Set<ID> {
            let selectedSet: Set<ID> = [id]
            selection?.wrappedValue = selectedSet
        } else {
            selection?.wrappedValue = id
        }
    }
}

#if SKIP
@available(*, unavailable)
public func Table<T, ID>(of valueType: T.Type, selection: Any? = nil, columnCustomization: Any? = nil, @ViewBuilder columns: () -> any View, @ViewBuilder rows: () -> any View) -> Table<T, ID> where T: Identifiable<ID> {
    fatalError()
}

@available(*, unavailable)
public func Table(selection: Any? = nil, sortOrder: Any, @ViewBuilder columns: () -> any View, @ViewBuilder rows: () -> any View) -> any View {
    fatalError()
}

@available(*, unavailable)
public func Table<T, ID>(of valueType: T.Type, selection: Any? = nil, sortOrder: Any, columnCustomization: Any? = nil, @ViewBuilder columns: () -> any View, @ViewBuilder rows: () -> any View) -> Table<T, ID> where T: Identifiable<ID> {
    fatalError()
}

@available(*, unavailable)
public func Table<ObjectType, ID>(_ data: any RandomAccessCollection<ObjectType>, selection: Any? = nil, columnCustomization: Any, @ViewBuilder content: (any RandomAccessCollection<ObjectType>) -> any View) -> Table<ObjectType, ID> where ObjectType: Identifiable<ID> {
    fatalError()
}

@available(*, unavailable)
public func Table<ObjectType, ID>(_ data: any RandomAccessCollection<ObjectType>, selection: Any? = nil, sortOrder: Any, columnCustomization: Any? = nil, @ViewBuilder content: (any RandomAccessCollection<ObjectType>) -> any View) -> Table<ObjectType, ID> where ObjectType: Identifiable<ID> {
    fatalError()
}

@available(*, unavailable)
public func Table<ObjectType, ID>(_ data: any RandomAccessCollection<ObjectType>, children: Any, selection: Any? = nil, sortOrder: Any? = nil, columnCustomization: Any? = nil, @ViewBuilder content: (any RandomAccessCollection<ObjectType>) -> any View) -> Table<ObjectType, ID> where ObjectType: Identifiable<ID> {
    fatalError()
}
#endif

@available(iOS 16.0, macOS 14.0, *)
public struct TableColumn : View {
    let columnHeader: Text
    let columnWidth: WidthSpec
    let cellContent: (Any) -> any View

    init(columnHeader: Text, columnWidth: WidthSpec, cellContent: @escaping (Any) -> any View) {
        self.columnHeader = columnHeader
        self.columnWidth = columnWidth
        self.cellContent = cellContent
    }

    #if !SKIP
    public var body: some View {
        stubView()
    }
    #endif

    public func width(_ width: CGFloat? = nil) -> TableColumn {
        guard let width else {
            return self
        }
        return TableColumn(columnHeader: columnHeader, columnWidth: .fixed(width), cellContent: cellContent)
    }

    public func width(min: CGFloat? = nil, ideal: CGFloat? = nil, max: CGFloat? = nil) -> TableColumn {
        guard min != nil || ideal != nil || max != nil else {
            return self
        }
        return TableColumn(columnHeader: columnHeader, columnWidth: .range(min: min, ideal: ideal, max: max), cellContent: cellContent)
    }

    @available(*, unavailable)
    public func defaultVisibility(_ visibility: Visibility) -> TableColumn {
        fatalError()
    }

    @available(*, unavailable)
    public func customizationID(_ id: String) -> TableColumn {
        fatalError()
    }

    @available(*, unavailable)
    public func disabledCustomizationBehavior(_ behavior: Any) -> TableColumn {
        fatalError()
    }

    enum WidthSpec {
        case `default`
        case fixed(CGFloat)
        case range(min: CGFloat?, ideal: CGFloat?, max: CGFloat?)
    }
}

#if SKIP
// SKIP DECLARE: fun <ObjectType> TableColumn(data: RandomAccessCollection<ObjectType>, title: String, value: (ObjectType) -> String, comparator: Any? = null): TableColumn
public func TableColumn<ObjectType>(_ title: String, value: (ObjectType) -> String, comparator: Any? = nil) -> TableColumn {
    return TableColumn(columnHeader: Text(verbatim: title).bold(), columnWidth: .default, cellContent: { Text(verbatim: value($0 as! ObjectType)) })
}

// SKIP DECLARE: fun <ObjectType> TableColumn(data: RandomAccessCollection<ObjectType>, title: String, value: Any? = null, comparator: Any? = null, content: (ObjectType) -> View): TableColumn
public func TableColumn<ObjectType>(_ title: String, value: Any? = nil, comparator: Any? = nil, @ViewBuilder content: @escaping (ObjectType) -> any View) -> TableColumn {
    return TableColumn(columnHeader: Text(verbatim: title).bold(), columnWidth: .default, cellContent: { content($0 as! ObjectType) })
}

// SKIP DECLARE: fun <ObjectType> TableColumn(data: RandomAccessCollection<ObjectType>, titleKey: LocalizedStringKey, value: (ObjectType) -> String, comparator: Any? = null): TableColumn
public func TableColumn<ObjectType>(_ titleKey: LocalizedStringKey, value: (ObjectType) -> String, comparator: Any? = nil) -> TableColumn {
    return TableColumn(columnHeader: Text(titleKey).bold(), columnWidth: .default, cellContent: { Text(verbatim: value($0 as! ObjectType)) })
}

// SKIP DECLARE: fun <ObjectType> TableColumn(data: RandomAccessCollection<ObjectType>, titleKey: LocalizedStringKey, value: Any? = null, comparator: Any? = null, content: (ObjectType) -> View): TableColumn
public func TableColumn<ObjectType>(_ titleKey: LocalizedStringKey, value: Any? = nil, comparator: Any? = nil, @ViewBuilder content: @escaping (ObjectType) -> any View) -> TableColumn {
    return TableColumn(columnHeader: Text(titleKey).bold(), columnWidth: .default, cellContent: { content($0 as! ObjectType) })
}

// SKIP DECLARE: fun <ObjectType> TableColumn(data: RandomAccessCollection<ObjectType>, title: Text, value: (ObjectType) -> String, comparator: Any? = null): TableColumn
public func TableColumn<ObjectType>(_ title: Text, value: (ObjectType) -> String, comparator: Any? = nil) -> TableColumn {
    return TableColumn(columnHeader: title, columnWidth: .default, cellContent: { Text(verbatim: value($0 as! ObjectType)) })
}

// SKIP DECLARE: fun <ObjectType> TableColumn(data: RandomAccessCollection<ObjectType>, title: Text, value: Any? = null, comparator: Any? = null, content: (ObjectType) -> View): TableColumn
public func TableColumn<ObjectType>(_ title: Text, value: Any? = nil, comparator: Any? = nil, @ViewBuilder content: @escaping (ObjectType) -> any View) -> TableColumn {
    return TableColumn(columnHeader: title, columnWidth: .default, cellContent: { content($0 as! ObjectType) })
}

// SKIP DECLARE: fun <ObjectType> TableColumn(data: RandomAccessCollection<ObjectType>, title: String, sortUsing: Any, content: (ObjectType) -> View): TableColumn
@available(*, unavailable)
public func TableColumn<ObjectType>(_ title: String, sortUsing comparator: Any, @ViewBuilder content: @escaping (ObjectType) -> Content) -> TableColumn {
    fatalError()
}

// SKIP DECLARE: fun <ObjectType> TableColumn(data: RandomAccessCollection<ObjectType>, titleKey: LocalizedStringKey, sortUsing: Any, content: (ObjectType) -> View): TableColumn
@available(*, unavailable)
public func TableColumn<ObjectType>(_ titleKey: LocalizedStringKey, sortUsing comparator: Any, @ViewBuilder content: @escaping (ObjectType) -> Content) -> TableColumn {
    fatalError()
}

// SKIP DECLARE: fun <ObjectType> TableColumn(data: RandomAccessCollection<ObjectType>, text: Text, sortUsing: Any, content: (ObjectType) -> View): TableColumn
@available(*, unavailable)
public func TableColumn<ObjectType>(_ titleKey: LocalizedStringKey, sortUsing comparator: Any, @ViewBuilder content: @escaping (ObjectType) -> Content) -> TableColumn {
    fatalError()
}
#endif

@available(*, unavailable)
public struct TableRow : View {
    public init(_ value: Any) {
    }

    #if !SKIP
    public var body: some View {
        stubView()
    }
    #endif

//    @available(*, unavailable)
//    public func contextMenu(@ViewBuilder menuItems: () -> any View) -> TableRow {
//        fatalError()
//    }
//
//    @available(*, unavailable)
//    public func contextMenu(@ViewBuilder menuItems: () -> any View, @ViewBuilder preview: () -> any View) -> TableRow {
//        fatalError()
//    }
//
//    @available(*, unavailable)
//    public func draggable(_ payload: () -> Any) -> TableRow {
//        fatalError()
//    }
//
//    @available(*, unavailable)
//    public func dropDestination(for payloadType: Any.Type, action: ([Any]) -> Void) -> TableRow {
//        fatalError()
//    }
//
//    @available(*, unavailable)
//    public func itemProvider(_ action: (() -> Any?)?) -> TableRow {
//        fatalError()
//    }
//
//    @available(*, unavailable)
//    public func dropDestination(for payloadType: Any.Type, action: (Int, [Any]) -> Void) -> TableRow {
//        fatalError()
//    }
//
//    @available(*, unavailable)
//    public func onInsert(of supportedContentTypes: [Any], perform action: (Int, [Any]) -> Void) -> TableRow {
//        fatalError()
//    }
}

extension View {
    @available(*, unavailable)
    public func tableColumnHeaders(_ visibility: Visibility) -> some View {
        return self
    }

    @available(*, unavailable)
    public func tableStyle(_ style: TableStyle) -> some View {
        return self
    }
}

public struct TableStyle {
    public static let automatic = TableStyle()
    @available(*, unavailable)
    public static let inset = TableStyle()
}

@available(*, unavailable)
public struct DisclosureTableRow {
    public init(_ value: Any, isExpanded: Binding<Bool>? = nil, @ViewBuilder content: () -> any View) {
    }
}
