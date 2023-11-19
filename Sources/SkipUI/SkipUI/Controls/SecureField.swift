// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

// Erase the generic Label to facilitate specialized constructor support.
public struct SecureField : View {
    @available(*, unavailable)
    public init(_ titleKey: LocalizedStringKey, text: Binding<String>, prompt: Text?) {
    }

    @available(*, unavailable)
    public init(_ title: String, text: Binding<String>, prompt: Text?) {
    }

    @available(*, unavailable)
    public init(text: Binding<String>, prompt: Text? = nil, @ViewBuilder label: () -> any View) {
    }

    @available(*, unavailable)
    public init(_ titleKey: LocalizedStringKey, text: Binding<String>) {
    }

    @available(*, unavailable)
    public init(_ title: String, text: Binding<String>) {
    }

    #if !SKIP
    public var body: some View {
        stubView()
    }
    #endif
}
