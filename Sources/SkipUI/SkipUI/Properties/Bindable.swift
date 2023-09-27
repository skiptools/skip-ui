// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

// `Bindable` support is implemented in the Skip transpiler. Its code is not needed

//import Observation
//
//@dynamicMemberLookup @propertyWrapper public struct Bindable<Value> {
//    public var wrappedValue: Value { get { fatalError() } }
//    public var projectedValue: Bindable<Value> { get { fatalError() } }
//    public init(wrappedValue: Value) { fatalError() }
//}
//
//extension Bindable where Value : AnyObject {
//    public subscript<Subject>(dynamicMember keyPath: ReferenceWritableKeyPath<Value, Subject>) -> Binding<Subject> { get { fatalError() } }
//}
//
//extension Bindable : Identifiable where Value : Identifiable {
//    public var id: Value.ID { get { fatalError() } }
//    public typealias ID = Value.ID
//}
//
//extension Bindable : Sendable where Value : Sendable {
//}
//
//extension Bindable where Value : AnyObject, Value : Observable {
//    public init(wrappedValue: Value) { fatalError() }
//    public init(_ wrappedValue: Value) { fatalError() }
//    public init(projectedValue: Bindable<Value>) { fatalError() }
//}
