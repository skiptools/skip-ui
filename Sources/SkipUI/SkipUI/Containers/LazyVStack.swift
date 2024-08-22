// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

#if SKIP
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.rememberLazyListState
import androidx.compose.runtime.Composable
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.rememberCoroutineScope
import androidx.compose.ui.Modifier
import androidx.compose.ui.unit.dp
import kotlinx.coroutines.launch
#else
import struct CoreGraphics.CGFloat
#endif

public struct LazyVStack : View {
    let alignment: HorizontalAlignment
    let spacing: CGFloat?
    let content: ComposeBuilder

    public init(alignment: HorizontalAlignment = .center, spacing: CGFloat? = nil, pinnedViews: PinnedScrollableViews = [], @ViewBuilder content: () -> any View) {
        self.alignment = alignment
        self.spacing = spacing
        self.content = ComposeBuilder.from(content)
    }
    
    #if SKIP
    @Composable override func ComposeContent(context: ComposeContext) {
        // Let any parent scroll view know about our builtin scrolling. If there is a parent scroll
        // view that didn't already know, abort and wait for recompose to avoid fatal nested scroll error
        let builtinScrollAxisSet = PreferenceValues.shared.collector(key: BuiltinScrollAxisSetPreferenceKey.self)?.state.value.reduced as? Axis.Set
        PreferenceValues.shared.contribute(context: context, key: BuiltinScrollAxisSetPreferenceKey.self, value: Axis.Set.vertical)
        guard builtinScrollAxisSet?.contains(Axis.Set.vertical) != false else {
            return
        }

        let columnAlignment = alignment.asComposeAlignment()
        let columnArrangement = Arrangement.spacedBy((spacing ?? 8.0).dp, alignment: androidx.compose.ui.Alignment.CenterVertically)
        let isScrollEnabled = EnvironmentValues.shared._scrollAxes.contains(.vertical)

        // Collect all top-level views to compose. The LazyColumn itself is not a composable context, so we have to execute
        // our content's Compose function to collect its views before entering the LazyColumn body, then use LazyColumn's
        // LazyListScope functions to compose individual items
        let collectingComposer = LazyItemCollectingComposer()
        let viewsCollector = context.content(composer: collectingComposer)
        content.Compose(context: viewsCollector)

        let searchableState = EnvironmentValues.shared._searchableState
        let isSearchable = searchableState?.isOnNavigationStack() == false

        let itemContext = context.content()
        let factoryContext = remember { mutableStateOf(LazyItemFactoryContext()) }
        ComposeContainer(axis: .vertical, modifier: context.modifier, fillWidth: true, fillHeight: true) { modifier in
            // Integrate with our scroll-to-top and ScrollViewReader
            let listState = rememberLazyListState(initialFirstVisibleItemIndex = isSearchable ? 1 : 0)
            let coroutineScope = rememberCoroutineScope()
            PreferenceValues.shared.contribute(context: context, key: ScrollToTopPreferenceKey.self, value: {
                coroutineScope.launch {
                    listState.animateScrollToItem(0)
                }
            })
            let scrollToID: (Any) -> Void = { id in
                if let itemIndex = factoryContext.value.index(for: id) {
                    coroutineScope.launch {
                        if Animation.isInWithAnimation {
                            listState.animateScrollToItem(itemIndex)
                        } else {
                            listState.scrollToItem(itemIndex)
                        }
                    }
                }
            }
            PreferenceValues.shared.contribute(context: context, key: ScrollToIDPreferenceKey.self, value: scrollToID)

            Box(modifier: modifier) {
                LazyColumn(state: listState, modifier: Modifier.fillMaxWidth(), verticalArrangement: columnArrangement, horizontalAlignment: columnAlignment, contentPadding: EnvironmentValues.shared._contentPadding.asPaddingValues(), userScrollEnabled: isScrollEnabled) {
                    factoryContext.value.initialize(
                        startItemIndex: isSearchable ? 1 : 0,
                        item: { view in
                            item {
                                view.Compose(context: itemContext)
                            }
                        },
                        indexedItems: { range, identifier, _, _, _, factory in
                            let count = range.endExclusive - range.start
                            let key: ((Int) -> String)? = identifier == nil ? nil : { composeBundleString(for: identifier!($0)) }
                            items(count: count, key: key) { index in
                                factory(index + range.start).Compose(context: itemContext)
                            }
                        },
                        objectItems: { objects, identifier, _, _, _, factory in
                            let key: (Int) -> String = { composeBundleString(for: identifier(objects[$0])) }
                            items(count: objects.count, key: key) { index in
                                factory(objects[index]).Compose(context: itemContext)
                            }
                        },
                        objectBindingItems: { objectsBinding, identifier, _, _, _, _, factory in
                            let key: (Int) -> String = { composeBundleString(for: identifier(objectsBinding.wrappedValue[$0])) }
                            items(count: objectsBinding.wrappedValue.count, key: key) { index in
                                factory(objectsBinding, index).Compose(context: itemContext)
                            }
                        },
                        sectionHeader: { view in
                            item {
                                view.Compose(context: itemContext)
                            }
                        },
                        sectionFooter: { view in
                            item {
                                view.Compose(context: itemContext)
                            }
                        }
                    )
                    if isSearchable {
                        item {
                            let modifier = Modifier.padding(16.dp).fillMaxWidth()
                            SearchField(state: searchableState!, context: context.content(modifier: modifier))
                        }
                    }
                    for view in collectingComposer.views {
                        if let factory = view as? LazyItemFactory {
                            factory.composeLazyItems(context: factoryContext.value)
                        } else {
                            factoryContext.value.item(view)
                        }
                    }
                }
            }
        }
    }
    #else
    public var body: some View {
        stubView()
    }
    #endif
}
