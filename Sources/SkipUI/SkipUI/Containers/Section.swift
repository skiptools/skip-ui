// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

// Erase generics to facilitate specialized constructor support.
public struct Section : View {
    @available(*, unavailable)
    public init(@ViewBuilder content: () -> any View, @ViewBuilder header: () -> any View, @ViewBuilder footer: () -> any View) {
    }

    @available(*, unavailable)
    public init(@ViewBuilder content: () -> any View, @ViewBuilder footer: () -> any View) {
    }

    @available(*, unavailable)
    public init(@ViewBuilder content: () -> any View, @ViewBuilder header: () -> any View) {
    }

    @available(*, unavailable)
    public init(@ViewBuilder content: () -> any View) {
    }

    @available(*, unavailable)
    public init(_ titleKey: LocalizedStringKey, @ViewBuilder content: () -> any View) {
    }

    @available(*, unavailable)
    public init(_ title: String, @ViewBuilder content: () -> any View) {
    }

    @available(*, unavailable)
    public init(_ titleKey: LocalizedStringKey, isExpanded: Binding<Bool>, @ViewBuilder content: () -> any View) {
    }

    @available(*, unavailable)
    public init(_ title: String, isExpanded: Binding<Bool>, @ViewBuilder content: () -> any View) {
    }

    @available(*, unavailable)
    public init(isExpanded: Binding<Bool>, @ViewBuilder content: () -> any View, @ViewBuilder header: () -> any View) {
    }

    #if !SKIP
    public var body: some View {
        stubView()
    }
    #endif
}
