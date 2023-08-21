// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

#if SKIP
#if !SKIP
//import SwiftUI
#else
import AndroidxComposeRuntime
#endif

internal func SkipUIInternalModuleName() -> String {
    return "SkipUI"
}

public func SkipUIPublicModuleName() -> String {
    return "SkipUI"
}

#if SKIP
public typealias CGFloat = Double
#endif

#if SKIP
public struct Binding<V> {
    public let get: () -> V
    public let set: (V) -> Void

    public var wrappedValue: V {
        get {
            return get()
        }
        set {
            set(newValue)
        }
    }
}

public final class State<V> {
    private var onUpdate: ((V) -> Void)?

    public init(initialValue: V) {
        wrappedValue = initialValue
    }

    public var wrappedValue: V {
        didSet {
            onUpdate?(newValue)
        }
    }

    public func sync(value: V, onUpdate: (V) -> Void) {
        self.wrappedValue = value
        self.onUpdate = onUpdate
    }
}
#else
// typealias Bindable = SwiftUI.Bindable
//public typealias Binding = SwiftUI.Binding
//public typealias Environment = SwiftUI.Environment
//public typealias EnvironmentKey = SwiftUI.EnvironmentKey
//public typealias EnvironmentObject = SwiftUI.EnvironmentObject
//public typealias EnvironmentValues = SwiftUI.EnvironmentValues
//public typealias ObservableObject = SwiftUI.ObservableObject
//public typealias ObservedObject = SwiftUI.ObservedObject
//public typealias Published = SwiftUI.Published
//public typealias State = SwiftUI.State
//public typealias StateObject = SwiftUI.StateObject
#endif

#if SKIP
// TODO: support Compose animation using LaunchedEffect?
public func withAnimation(block: () -> Void) {
    block()
}
#else
//public func withAnimation<Result>(body: () -> Result) -> Result {
//    SwiftUI.withAnimation(.default, body)
//}
#endif
#endif
