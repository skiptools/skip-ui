// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

#if SKIP
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Row
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.unit.dp
#else
import struct CoreGraphics.CGFloat
import struct CoreGraphics.CGRect
import struct CoreGraphics.CGSize
#endif

public struct HStack : View {
    let alignment: VerticalAlignment
    let spacing: CGFloat?
    let content: ComposeBuilder

    public init(alignment: VerticalAlignment = .center, spacing: CGFloat? = nil, @ViewBuilder content: () -> any View) {
        self.alignment = alignment
        self.spacing = spacing
        self.content = ComposeBuilder.from(content)
    }

    #if SKIP
    @Composable public override func ComposeContent(context: ComposeContext) {
        let rowAlignment: androidx.compose.ui.Alignment.Vertical
        switch alignment {
        case .bottom:
            rowAlignment = androidx.compose.ui.Alignment.Bottom
        case .top:
            rowAlignment = androidx.compose.ui.Alignment.Top
        default:
            rowAlignment = androidx.compose.ui.Alignment.CenterVertically
        }
        let contentContext = context.content()
        ComposeContainer(axis: .horizontal, modifier: context.modifier) { modifier in
            Row(modifier: modifier, horizontalArrangement: Arrangement.spacedBy((spacing ?? 8.0).dp), verticalAlignment: rowAlignment) {
                let fillWidthModifier = Modifier.weight(Float(1.0)) // Only available in Row context
                EnvironmentValues.shared.setValues {
                    $0.set_fillWidthModifier(fillWidthModifier)
                } in: {
                    content.Compose(context: contentContext)
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

#if false

// TODO: Process for use in SkipUI

/// A horizontal container that you can use in conditional layouts.
///
/// This layout container behaves like an ``HStack``, but conforms to the
/// ``Layout`` protocol so you can use it in the conditional layouts that you
/// construct with ``AnyLayout``. If you don't need a conditional layout, use
/// ``HStack`` instead.
@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
@frozen public struct HStackLayout : Layout {
    /// The vertical alignment of subviews.
    public var alignment: VerticalAlignment { get { fatalError() } }

    /// The distance between adjacent subviews.
    ///
    /// Set this value to `nil` to use default distances between subviews.
    public var spacing: CGFloat?

    /// Creates a horizontal stack with the specified spacing and vertical
    /// alignment.
    ///
    /// - Parameters:
    ///     - alignment: The guide for aligning the subviews in this stack. It
    ///       has the same vertical screen coordinate for all subviews.
    ///     - spacing: The distance between adjacent subviews. Set this value
    ///       to `nil` to use default distances between subviews.
    @inlinable public init(alignment: VerticalAlignment = .center, spacing: CGFloat? = nil) { fatalError() }

    /// The type defining the data to animate.
    public typealias AnimatableData = EmptyAnimatableData
    public var animatableData: AnimatableData { get { fatalError() } set { } }

    /// Cached values associated with the layout instance.
    ///
    /// If you create a cache for your custom layout, you can use
    /// a type alias to define this type as your data storage type.
    /// Alternatively, you can refer to the data storage type directly in all
    /// the places where you work with the cache.
    ///
    /// See ``makeCache(subviews:)-23agy`` for more information.
    public typealias Cache = Any

    public func makeCache(subviews: Subviews) -> Cache {
        fatalError()
    }

    public func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout Cache) -> CGSize {
        fatalError()
    }

    public func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout Cache) {
    }
}

@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
extension HStackLayout : Sendable {
}

#endif
