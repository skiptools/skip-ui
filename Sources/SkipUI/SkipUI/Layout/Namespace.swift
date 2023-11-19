// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

// TODO: Process for use in SkipUI

#if !SKIP

/// A dynamic property type that allows access to a namespace defined
/// by the persistent identity of the object containing the property
/// (e.g. a view).
@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
@frozen @propertyWrapper public struct Namespace : DynamicProperty {

    @inlinable public init() { fatalError() }

    public var wrappedValue: Namespace.ID { get { fatalError() } }

    /// A namespace defined by the persistent identity of an
    /// `@Namespace` dynamic property.
    @frozen public struct ID : Hashable {

    
        

        }
}

@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
extension Namespace : Sendable {
}

@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
extension Namespace.ID : Sendable {
}

#endif
