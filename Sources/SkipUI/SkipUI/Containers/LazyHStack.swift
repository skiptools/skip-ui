// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

#if SKIP
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.lazy.LazyRow
import androidx.compose.runtime.Composable
import androidx.compose.ui.unit.dp
#else
import struct CoreGraphics.CGFloat
#endif

public struct LazyHStack : View {
    let alignment: VerticalAlignment
    let spacing: CGFloat?
    let content: ComposeBuilder

    public init(alignment: VerticalAlignment = .center, spacing: CGFloat? = nil, @ViewBuilder content: () -> any View) {
        self.alignment = alignment
        self.spacing = spacing
        self.content = ComposeBuilder.from(content)
    }

    @available(*, unavailable)
    public init(alignment: VerticalAlignment = .center, spacing: CGFloat? = nil, pinnedViews: PinnedScrollableViews, @ViewBuilder content: () -> any View) {
        self.alignment = alignment
        self.spacing = spacing
        self.content = ComposeBuilder.from(content)
    }

    #if SKIP
    @Composable override func ComposeContent(context: ComposeContext) {
        let rowAlignment: androidx.compose.ui.Alignment.Vertical
        switch alignment {
        case .bottom:
            rowAlignment = androidx.compose.ui.Alignment.Bottom
        case .top:
            rowAlignment = androidx.compose.ui.Alignment.Top
        default:
            rowAlignment = androidx.compose.ui.Alignment.CenterVertically
        }
        let rowArrangement = Arrangement.spacedBy((spacing ?? 8.0).dp, alignment: androidx.compose.ui.Alignment.CenterHorizontally)

        // Collect all top-level views to compose. The LazyRow itself is not a composable context, so we have to execute
        // our content's Compose function to collect its views before entering the LazyRow body, then use LazyRow's
        // LazyListScope functions to compose individual items
        let collectingComposer = LazyItemCollectingComposer()
        let viewsCollector = context.content(composer: collectingComposer)
        content.Compose(context: viewsCollector)

        let itemContext = context.content()
        let factoryContext = LazyItemFactoryContext()
        ComposeContainer(axis: .horizontal, modifier: context.modifier, fillWidth: true, fillHeight: false) { modifier in
            LazyRow(modifier: modifier, horizontalArrangement: rowArrangement, verticalAlignment: rowAlignment) {
                factoryContext.initialize(
                    startItemIndex: 0,
                    item: { view in
                        item {
                            view.Compose(context: itemContext)
                        }
                    },
                    indexedItems: { range, identifier, _, _, _, factory in
                        let count = range.endExclusive - range.start
                        let key: ((Int) -> String)? = identifier == nil ? nil : { composeBundleString(for: identifier!($0)) }
                        items(count: count, key: key) { index in
                            let keyValue = key?(index + range.start) // Key closure already remaps index
                            factory(index + range.start).Compose(context: itemContext)
                        }
                    },
                    objectItems: { objects, identifier, _, _, _, factory in
                        let key: (Int) -> String = { composeBundleString(for: identifier(objects[$0])) }
                        items(count: objects.count, key: key) { index in
                            let keyValue = key(index) // Key closure already remaps index
                            factory(objects[index]).Compose(context: itemContext)
                        }
                    },
                    objectBindingItems: { objectsBinding, identifier, _, _, _, _, factory in
                        let key: (Int) -> String = { composeBundleString(for: identifier(objectsBinding.wrappedValue[$0])) }
                        items(count: objectsBinding.wrappedValue.count, key: key) { index in
                            let keyValue = key(index) // Key closure already remaps index
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
