// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

#if SKIP
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.lazy.grid.LazyHorizontalGrid
import androidx.compose.runtime.Composable
import androidx.compose.ui.unit.dp
#else
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
        let (gridCells, cellAlignment, verticalSpacing) = GridItem.asGridCells(items: rows)
        let boxAlignment = cellAlignment?.asComposeAlignment() ?? androidx.compose.ui.Alignment.Center
        let verticalArrangement = Arrangement.spacedBy((verticalSpacing ?? 8.0).dp, alignment: alignment.asComposeAlignment())
        let horizontalArrangement = Arrangement.spacedBy((spacing ?? 8.0).dp)
        let isScrollEnabled = EnvironmentValues.shared._scrollAxes.contains(.horizontal)

        // Collect all top-level views to compose. The LazyHorizontalGrid itself is not a composable context, so we have to execute
        // our content's Compose function to collect its views before entering the LazyHorizontalGrid body, then use LazyHorizontalGrid's
        // LazyGridScope functions to compose individual items
        let collectingComposer = LazyItemCollectingComposer()
        let viewsCollector = context.content(composer: collectingComposer)
        content.Compose(context: viewsCollector)

        let itemContext = context.content()
        let factoryContext = LazyItemFactoryContext()
        ComposeContainer(axis: .vertical, modifier: context.modifier, fillWidth: true, fillHeight: true) { modifier in
            LazyHorizontalGrid(modifier: modifier, rows: gridCells, horizontalArrangement: horizontalArrangement, verticalArrangement: verticalArrangement, userScrollEnabled: isScrollEnabled) {
                factoryContext.initialize(
                    startItemIndex: 0,
                    item: { view in
                        item {
                            Box(contentAlignment: boxAlignment) {
                                view.Compose(context: itemContext)
                            }
                        }
                    },
                    indexedItems: { range, identifier, _, _, _, factory in
                        let count = range.endExclusive - range.start
                        let key: ((Int) -> String)? = identifier == nil ? nil : { composeBundleString(for: identifier!($0)) }
                        items(count: count, key: key) { index in
                            Box(contentAlignment: boxAlignment) {
                                factory(index + range.start).Compose(context: itemContext)
                            }
                        }
                    },
                    objectItems: { objects, identifier, _, _, _, factory in
                        let key: (Int) -> String = { composeBundleString(for: identifier(objects[$0])) }
                        items(count: objects.count, key: key) { index in
                            Box(contentAlignment: boxAlignment) {
                                factory(objects[index]).Compose(context: itemContext)
                            }
                        }
                    },
                    objectBindingItems: { objectsBinding, identifier, _, _, _, _, factory in
                        let key: (Int) -> String = { composeBundleString(for: identifier(objectsBinding.wrappedValue[$0])) }
                        items(count: objectsBinding.wrappedValue.count, key: key) { index in
                            Box(contentAlignment: boxAlignment) {
                                factory(objectsBinding, index).Compose(context: itemContext)
                            }
                        }
                    },
                    sectionHeader: { view in
                        item {
                            Box(contentAlignment: boxAlignment) {
                                view.Compose(context: itemContext)
                            }
                        }
                    },
                    sectionFooter: { view in
                        item {
                            Box(contentAlignment: boxAlignment) {
                                view.Compose(context: itemContext)
                            }
                        }
                    }
                )
                for view in collectingComposer.views {
                    if let factory = view as? LazyItemFactory {
                        factory.composeLazyItems(context: factoryContext)
                    } else {
                        factoryContext.item(view)
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
