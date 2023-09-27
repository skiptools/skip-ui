// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

// `ObservedObject` support is implemented in the Skip transpiler

#if !SKIP

// Stubs needed to compile this package

import protocol Combine.ObservableObject

@propertyWrapper @frozen public struct ObservedObject<ObjectType> : DynamicProperty where ObjectType : ObservableObject {
    @dynamicMemberLookup @frozen public struct Wrapper {
        public subscript<Subject>(dynamicMember keyPath: ReferenceWritableKeyPath<ObjectType, Subject>) -> Binding<Subject> { get { fatalError() } }
    }

    public init(wrappedValue initialValue: ObjectType) { fatalError() }
    @MainActor public var wrappedValue: ObjectType { get { fatalError() } }
    @MainActor public var projectedValue: ObservedObject<ObjectType>.Wrapper { get { fatalError() } }
}
#endif
