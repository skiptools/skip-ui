// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

// SKIP INSERT: import androidx.compose.runtime.Composable
// SKIP INSERT: import androidx.compose.ui.unit.dp

public struct HStack<Content> : View where Content : View {
    let alignment: VerticalAlignment
    let spacing: CGFloat?
    let content: Content

    public init(alignment: VerticalAlignment = .center, spacing: CGFloat? = nil, @ViewBuilder content: () -> Content) {
        self.alignment = alignment
        self.spacing = spacing
        self.content = content()
    }

    #if SKIP
    /*
     https://cs.android.com/androidx/platform/frameworks/support/+/androidx-main:compose/foundation/foundation-layout/src/commonMain/kotlin/androidx/compose/foundation/layout/Row.kt
     @Composable
     inline fun Row(
         modifier: Modifier = Modifier,
         horizontalArrangement: Arrangement.Horizontal = Arrangement.Start,
         verticalAlignment: Alignment.Vertical = Alignment.Top,
         content: @Composable RowScope.() -> Unit
     )
     */
    @Composable public override func Compose(context: ComposeContext) {
        let rowAlignment: androidx.compose.ui.Alignment.Vertical
        switch alignment {
        case .bottom:
            rowAlignment = androidx.compose.ui.Alignment.Bottom
        case .top:
            rowAlignment = androidx.compose.ui.Alignment.Top
        default:
            rowAlignment = androidx.compose.ui.Alignment.CenterVertically
        }
        var contentContext = context.content(of: self)
        contentContext.style.primaryAxis = .horizontal
        androidx.compose.foundation.layout.Row(modifier: context.modifier, horizontalArrangement: androidx.compose.foundation.layout.Arrangement.spacedBy((spacing ?? 8.0).dp), verticalAlignment: rowAlignment) {
            content.Eval(context: contentContext)
        }
    }
    #else
    public var body: some View {
        stubView()
    }
    #endif
}

#if !SKIP

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
    public var animatableData: AnimatableData { get { fatalError() } set { fatalError() } }

    /// Cached values associated with the layout instance.
    ///
    /// If you create a cache for your custom layout, you can use
    /// a type alias to define this type as your data storage type.
    /// Alternatively, you can refer to the data storage type directly in all
    /// the places where you work with the cache.
    ///
    /// See ``makeCache(subviews:)-23agy`` for more information.
    public typealias Cache = Never

    public func makeCache(subviews: Subviews) -> Never {
        fatalError()
    }

    public func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout Never) -> CGSize {
        fatalError()
    }

    public func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout Never) {
    }
}

@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
extension HStackLayout : Sendable {
}

#endif
