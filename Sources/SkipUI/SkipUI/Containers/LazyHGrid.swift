// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

#if SKIP
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.lazy.grid.GridItemSpan
import androidx.compose.foundation.lazy.grid.LazyHorizontalGrid
import androidx.compose.foundation.lazy.grid.rememberLazyGridState
import androidx.compose.runtime.Composable
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.rememberCoroutineScope
import androidx.compose.ui.unit.dp
import kotlinx.coroutines.launch
#elseif canImport(CoreGraphics)
import struct CoreGraphics.CGFloat
#endif

public struct LazyHGrid: View {
    let rows: [GridItem]
    let alignment: VerticalAlignment
    let spacing: CGFloat?
    let content: ComposeBuilder

    public init(rows: [GridItem], alignment: VerticalAlignment = .center, spacing: CGFloat? = nil, pinnedViews: PinnedScrollableViews = [], @ViewBuilder content: () -> any View) {
        self.rows = rows
        self.alignment = alignment
        self.spacing = spacing
        self.content = ComposeBuilder.from(content)
    }

    #if SKIP
    @Composable override func ComposeContent(context: ComposeContext) {
        // Let any parent scroll view know about our builtin scrolling. If there is a parent scroll
        // view that didn't already know, abort and wait for recompose to avoid fatal nested scroll error
        PreferenceValues.shared.contribute(context: context, key: BuiltinScrollAxisSetPreferenceKey.self, value: Axis.Set.horizontal)
        guard !EnvironmentValues.shared._scrollAxes.contains(Axis.Set.horizontal) else {
            return
        }

        let (gridCells, cellAlignment, verticalSpacing) = GridItem.asGridCells(items: rows)
        let boxAlignment = cellAlignment?.asComposeAlignment() ?? androidx.compose.ui.Alignment.Center
        let verticalArrangement = Arrangement.spacedBy((verticalSpacing ?? 8.0).dp, alignment: alignment.asComposeAlignment())
        let horizontalArrangement = Arrangement.spacedBy((spacing ?? 8.0).dp)
        let isScrollEnabled = EnvironmentValues.shared._scrollViewAxes.contains(.horizontal)
        let scrollAxes: Axis.Set = isScrollEnabled ? Axis.Set.horizontal : []

        // Collect all top-level views to compose. The LazyHorizontalGrid itself is not a composable context, so we have to execute
        // our content's Compose function to collect its views before entering the LazyHorizontalGrid body, then use LazyHorizontalGrid's
        // LazyGridScope functions to compose individual items
        let collectingComposer = LazyItemCollectingComposer()
        let viewsCollector = context.content(composer: collectingComposer)
        content.Compose(context: viewsCollector)

        let itemContext = context.content()
        let factoryContext = remember { mutableStateOf(LazyItemFactoryContext()) }
        ComposeContainer(axis: .vertical, scrollAxes: scrollAxes, modifier: context.modifier, fillWidth: true, fillHeight: true) { modifier in
            // Integrate with our scroll-to-top and ScrollViewReader
            let gridState = rememberLazyGridState()
            let coroutineScope = rememberCoroutineScope()
            let scrollToID: (Any) -> Void = { id in
                if let itemIndex = factoryContext.value.index(for: id) {
                    coroutineScope.launch {
                        if Animation.isInWithAnimation {
                            gridState.animateScrollToItem(itemIndex)
                        } else {
                            gridState.scrollToItem(itemIndex)
                        }
                    }
                }
            }
            PreferenceValues.shared.contribute(context: context, key: ScrollToIDPreferenceKey.self, value: scrollToID)

            LazyHorizontalGrid(state: gridState, modifier: modifier, rows: gridCells, horizontalArrangement: horizontalArrangement, verticalArrangement: verticalArrangement, contentPadding: EnvironmentValues.shared._contentPadding.asPaddingValues(), userScrollEnabled: isScrollEnabled) {
                factoryContext.value.initialize(
                    startItemIndex: 0,
                    item: { view, _ in
                        item {
                            Box(contentAlignment: boxAlignment) {
                                view.Compose(context: itemContext)
                            }
                        }
                    },
                    indexedItems: { range, identifier, _, _, _, _, factory in
                        let count = range.endExclusive - range.start
                        let key: ((Int) -> String)? = identifier == nil ? nil : { composeBundleString(for: identifier!($0)) }
                        items(count: count, key: key) { index in
                            Box(contentAlignment: boxAlignment) {
                                factory(index + range.start).Compose(context: itemContext)
                            }
                        }
                    },
                    objectItems: { objects, identifier, _, _, _, _, factory in
                        let key: (Int) -> String = { composeBundleString(for: identifier(objects[$0])) }
                        items(count: objects.count, key: key) { index in
                            Box(contentAlignment: boxAlignment) {
                                factory(objects[index]).Compose(context: itemContext)
                            }
                        }
                    },
                    objectBindingItems: { objectsBinding, identifier, _, _, _, _, _, factory in
                        let key: (Int) -> String = { composeBundleString(for: identifier(objectsBinding.wrappedValue[$0])) }
                        items(count: objectsBinding.wrappedValue.count, key: key) { index in
                            Box(contentAlignment: boxAlignment) {
                                factory(objectsBinding, index).Compose(context: itemContext)
                            }
                        }
                    },
                    sectionHeader: { view in
                        item(span: { GridItemSpan(maxLineSpan) }) {
                            Box(contentAlignment: androidx.compose.ui.Alignment.Center) {
                                view.Compose(context: itemContext)
                            }
                        }
                    },
                    sectionFooter: { view in
                        item(span: { GridItemSpan(maxLineSpan) }) {
                            Box(contentAlignment: androidx.compose.ui.Alignment.Center) {
                                view.Compose(context: itemContext)
                            }
                        }
                    }
                )
                for (view, level) in collectingComposer.views {
                    if let factory = view as? LazyItemFactory {
                        factory.composeLazyItems(context: factoryContext.value, level: level)
                    } else {
                        factoryContext.value.item(view, level)
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
