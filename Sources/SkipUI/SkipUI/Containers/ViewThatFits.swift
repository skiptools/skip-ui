// Copyright 2023–2025 Skip
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception
#if !SKIP_BRIDGE

public struct ViewThatFits : View {
    @available(*, unavailable)
    public init(in axes: Axis.Set = [.horizontal, .vertical], @ViewBuilder content: () -> any View) {
    }

    #if !SKIP
    public var body: some View {
        stubView()
    }
    #endif
}

#endif
