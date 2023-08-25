// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

#if !SKIP
import struct CoreGraphics.CGRect
import struct CoreGraphics.CGSize
#endif

// SKIP INSERT: import androidx.compose.runtime.Composable

public struct ZStack<Content> : View where Content : View {
    let alignment: Alignment
    let content: Content

    public init(alignment: Alignment = .center, @ViewBuilder content: () -> Content) {
        self.alignment = alignment
        self.content = content()
    }

    #if SKIP
    /*
     https://cs.android.com/androidx/platform/frameworks/support/+/androidx-main:compose/foundation/foundation-layout/src/commonMain/kotlin/androidx/compose/foundation/layout/Box.kt
     @Composable
     inline fun Box(
        modifier: Modifier = Modifier,
        contentAlignment: Alignment = Alignment.TopStart,
        propagateMinConstraints: Boolean = false,
        content: @Composable BoxScope.() -> Unit
     )
     */
    @Composable public override func ComposeContent(context: ComposeContext) {
        let boxAlignment: androidx.compose.ui.Alignment
        switch alignment {
        case .leading, .leadingFirstTextBaseline, .leadingLastTextBaseline:
            boxAlignment = androidx.compose.ui.Alignment.CenterStart
        case .trailing, .trailingFirstTextBaseline, .trailingLastTextBaseline:
            boxAlignment = androidx.compose.ui.Alignment.CenterEnd
        case .top:
            boxAlignment = androidx.compose.ui.Alignment.TopCenter
        case .bottom:
            boxAlignment = androidx.compose.ui.Alignment.BottomCenter
        case .topLeading:
            boxAlignment = androidx.compose.ui.Alignment.TopStart
        case .topTrailing:
            boxAlignment = androidx.compose.ui.Alignment.TopEnd
        case .bottomLeading:
            boxAlignment = androidx.compose.ui.Alignment.BottomStart
        case .bottomTrailing:
            boxAlignment = androidx.compose.ui.Alignment.BottomEnd
        default:
            boxAlignment = androidx.compose.ui.Alignment.Center
        }
        var contentContext = context.content(of: self)
        contentContext.style.fillWidth = nil
        contentContext.style.fillHeight = nil
        androidx.compose.foundation.layout.Box(modifier: context.modifier, contentAlignment: boxAlignment) {
            content.Compose(context: contentContext)
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

/// An overlaying container that you can use in conditional layouts.
///
/// This layout container behaves like a ``ZStack``, but conforms to the
/// ``Layout`` protocol so you can use it in the conditional layouts that you
/// construct with ``AnyLayout``. If you don't need a conditional layout, use
/// ``ZStack`` instead.
@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
@frozen public struct ZStackLayout : Layout {
    /// The alignment of subviews.
    public var alignment: Alignment { get { fatalError() } }

    /// Creates a stack with the specified alignment.
    ///
    /// - Parameters:
    ///   - alignment: The guide for aligning the subviews in this stack
    ///     on both the x- and y-axes.
    @inlinable public init(alignment: Alignment = .center) { fatalError() }

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
    public typealias Cache = Void

    public func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout Void) -> CGSize {
        fatalError()
    }

    public func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout Void) {
        fatalError()
    }
}

@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
extension ZStackLayout : Sendable {
}

#endif
