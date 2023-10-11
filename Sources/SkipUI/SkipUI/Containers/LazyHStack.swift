// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

#if !SKIP
import struct CoreGraphics.CGFloat
#endif

public struct LazyHStack<Content> : View where Content : View {
    @available(*, unavailable)
    public init(alignment: VerticalAlignment = .center, spacing: CGFloat? = nil, pinnedViews: PinnedScrollableViews = [], @ViewBuilder content: () -> Content) {
    }

    #if !SKIP
    public var body: some View {
        stubView()
    }
    #endif
}
