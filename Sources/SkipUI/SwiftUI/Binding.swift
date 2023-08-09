// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

import Combine
import Observation

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension Bindable where Value : AnyObject, Value : Observable {

    /// Creates a bindable object from an observable object.
    ///
    /// You should not call this initializer directly. Instead, declare a
    /// property with the `@Bindable` attribute, and provide an initial value.
    public init(wrappedValue: Value) { fatalError() }

    /// Creates a bindable object from an observable object.
    ///
    /// This initializer is equivalent to `init(wrappedValue:)`, but is more
    /// succinct when directly creating bindable objects, e.g.
    /// `Bindable(myModel)`.
    public init(_ wrappedValue: Value) { fatalError() }

    /// Creates a bindable from the value of another bindable.
    public init(projectedValue: Bindable<Value>) { fatalError() }
}
