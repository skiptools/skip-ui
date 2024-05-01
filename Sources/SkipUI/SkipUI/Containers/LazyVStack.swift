// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

#if SKIP
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.runtime.Composable
import androidx.compose.ui.unit.dp
#else
import struct CoreGraphics.CGFloat
#endif

public struct LazyVStack : View {
    let alignment: HorizontalAlignment
    let spacing: CGFloat?
    let content: ComposeBuilder

    public init(alignment: HorizontalAlignment = .center, spacing: CGFloat? = nil, @ViewBuilder content: () -> any View) {
        self.alignment = alignment
        self.spacing = spacing
        self.content = ComposeBuilder.from(content)
    }

    @available(*, unavailable)
    public init(alignment: HorizontalAlignment = .center, spacing: CGFloat? = nil, pinnedViews: PinnedScrollableViews, @ViewBuilder content: () -> any View) {
        self.alignment = alignment
        self.spacing = spacing
        self.content = ComposeBuilder.from(content)
    }

#if SKIP
@Composable override func ComposeContent(context: ComposeContext) {
    let columnAlignment: androidx.compose.ui.Alignment.Horizontal
    switch alignment {
    case .leading:
        columnAlignment = androidx.compose.ui.Alignment.Start
    case .trailing:
        columnAlignment = androidx.compose.ui.Alignment.End
    default:
        columnAlignment = androidx.compose.ui.Alignment.CenterHorizontally
    }
    let columnArrangement = Arrangement.spacedBy((spacing ?? 8.0).dp, alignment: androidx.compose.ui.Alignment.CenterVertically)

    // Collect all top-level views to compose. The LazyColumn itself is not a composable context, so we have to execute
    // our content's Compose function to collect its views before entering the LazyColumn body, then use LazyColumn's
    // LazyListScope functions to compose individual items
    let collectingComposer = LazyItemCollectingComposer()
    let viewsCollector = context.content(composer: collectingComposer)
    content.Compose(context: viewsCollector)

    let itemContext = context.content()
    let factoryContext = LazyItemFactoryContext()
    ComposeContainer(axis: .vertical, modifier: context.modifier, fillWidth: true, fillHeight: true) { modifier in
        LazyColumn(modifier: modifier, verticalArrangement: columnArrangement, horizontalAlignment: columnAlignment) {
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
