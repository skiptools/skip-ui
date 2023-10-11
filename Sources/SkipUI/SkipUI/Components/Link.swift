// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

import Foundation

// Erase the generic Label to facilitate specialized constructor support.
public struct Link : View {
    @available(*, unavailable)
    public init(destination: URL, @ViewBuilder label: () -> Label) {
    }

    @available(*, unavailable)
    public init(_ titleKey: LocalizedStringKey, destination: URL) {
    }

    @available(*, unavailable)
    public init(_ title: String, destination: URL) {
    }

    #if !SKIP
    public var body: some View {
        stubView()
    }
    #endif
}
