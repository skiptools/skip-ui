// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

public struct ViewThatFits<Content> : View where Content : View {
    @available(*, unavailable)
    public init(in axes: Axis.Set = [.horizontal, .vertical], @ViewBuilder content: () -> Content) {
    }

    #if !SKIP
    public var body: some View {
        stubView()
    }
    #endif
}
