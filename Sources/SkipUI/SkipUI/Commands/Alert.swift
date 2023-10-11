// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

import Foundation

extension View {
    @available(*, unavailable)
    public func alert(_ titleKey: LocalizedStringKey, isPresented: Binding<Bool>, @ViewBuilder actions: () -> any View) -> some View {
        return self
    }

    @available(*, unavailable)
    public func alert(_ title: String, isPresented: Binding<Bool>, @ViewBuilder actions: () -> any View) -> some View {
        return self
    }

    @available(*, unavailable)
    public func alert(_ title: Text, isPresented: Binding<Bool>, @ViewBuilder actions: () -> any View) -> some View {
        return self
    }

    @available(*, unavailable)
    public func alert(_ titleKey: LocalizedStringKey, isPresented: Binding<Bool>, @ViewBuilder actions: () -> any View, @ViewBuilder message: () -> any View) -> some View {
        return self
    }

    @available(*, unavailable)
    public func alert(_ title: String, isPresented: Binding<Bool>, @ViewBuilder actions: () -> any View, @ViewBuilder message: () -> any View) -> some View {
        return self
    }

    @available(*, unavailable)
    public func alert(_ title: Text, isPresented: Binding<Bool>, @ViewBuilder actions: () -> any View, @ViewBuilder message: () -> any View) -> some View {
        return self
    }

    @available(*, unavailable)
    public func alert<T>(_ titleKey: LocalizedStringKey, isPresented: Binding<Bool>, presenting data: T?, @ViewBuilder actions: (T) -> any View) -> some View {
        return self
    }

    @available(*, unavailable)
    public func alert<T>(_ title: String, isPresented: Binding<Bool>, presenting data: T?, @ViewBuilder actions: (T) -> any View) -> some View {
        return self
    }

    @available(*, unavailable)
    public func alert<T>(_ title: Text, isPresented: Binding<Bool>, presenting data: T?, @ViewBuilder actions: (T) -> any View) -> some View {
        return self
    }

    @available(*, unavailable)
    public func alert<T>(_ titleKey: LocalizedStringKey, isPresented: Binding<Bool>, presenting data: T?, @ViewBuilder actions: (T) -> any View, @ViewBuilder message: (T) -> any View) -> some View {
        return self
    }

    @available(*, unavailable)
    public func alert<T>(_ title: String, isPresented: Binding<Bool>, presenting data: T?, @ViewBuilder actions: (T) -> any View, @ViewBuilder message: (T) -> any View) -> some View {
        return self
    }

    @available(*, unavailable)
    public func alert<T>(_ title: Text, isPresented: Binding<Bool>, presenting data: T?, @ViewBuilder actions: (T) -> any View, @ViewBuilder message: (T) -> any View) -> some View {
        return self
    }

    @available(*, unavailable)
    public func alert<E>(isPresented: Binding<Bool>, error: E?, @ViewBuilder actions: () -> any View) -> some View where E : LocalizedError {
        return self
    }

    @available(*, unavailable)
    public func alert<E>(isPresented: Binding<Bool>, error: E?, @ViewBuilder actions: (E) -> any View, @ViewBuilder message: (E) -> any View) -> some View where E : LocalizedError {
        return self
    }
}
