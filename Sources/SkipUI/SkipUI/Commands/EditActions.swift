// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

// TODO: Process for use in SkipUI

#if !SKIP

/// A set of edit actions on a collection of data that a view can offer
/// to a user.
@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
public struct EditActions<Data> : OptionSet, Sendable {

    /// The raw value.
    public let rawValue: Int = { fatalError() }()

    /// Creates a new set from a raw value.
    ///
    /// - Parameter rawValue: The raw value with which to create the
    /// collection edits.
    public init(rawValue: Int) { fatalError() }

    /// All the edit actions available on this collection.
    public static var all: EditActions<Data> { get { fatalError() } }

    /// The type of the elements of an array literal.
    public typealias ArrayLiteralElement = EditActions<Data>

    /// The element type of the option set.
    ///
    /// To inherit all the default implementations from the `OptionSet` protocol,
    /// the `Element` type must be `Self`, the default.
    public typealias Element = EditActions<Data>

    /// The raw type that can be used to represent all values of the conforming
    /// type.
    ///
    /// Every distinct value of the conforming type has a corresponding unique
    /// value of the `RawValue` type, but there may be values of the `RawValue`
    /// type that don't have a corresponding value of the conforming type.
    public typealias RawValue = Int
}

@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
extension EditActions where Data : RangeReplaceableCollection {

    /// An edit action that allows the user to delete one or more elements
    /// of a collection.
    public static var delete: EditActions<Data> { get { fatalError() } }

    /// All the edit actions available on this collection.
    public static var all: EditActions<Data> { get { fatalError() } }
}

@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
extension EditActions where Data : MutableCollection {

    /// An edit action that allows the user to move elements of a
    /// collection.
    public static var move: EditActions<Data> { get { fatalError() } }

    /// All the edit actions available on this collection.
    public static var all: EditActions<Data> { get { fatalError() } }
}

@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
extension EditActions where Data : MutableCollection, Data : RangeReplaceableCollection {

    /// All the edit actions available on this collection.
    public static var all: EditActions<Data> { get { fatalError() } }
}


#endif
