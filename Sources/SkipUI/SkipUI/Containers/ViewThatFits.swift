// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

public struct ViewThatFits : View {
    @available(*, unavailable)
    public init(in axes: Axis.Set = [.horizontal, .vertical], @ViewBuilder content: () -> ComposeView) {
    }

    #if !SKIP
    public var body: some View {
        stubView()
    }
    #endif
}
