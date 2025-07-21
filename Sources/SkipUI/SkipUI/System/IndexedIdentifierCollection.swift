// Copyright 2023–2025 Skip
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception
/*
/// A collection wrapper that iterates over the indices and identifiers of a
/// collection together.
///
/// You don't use this type directly. Instead SkipUI creates this type on
/// your behalf.
@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
public struct IndexedIdentifierCollection<Base, ID> : Collection where Base : Collection, ID : Hashable {

    /// A type representing the sequence's elements.
    public struct Element {
    }

    /// A type that represents a position in the collection.
    ///
    /// Valid indices consist of the position of every element and a
    /// "past the end" position that's not valid for use as a subscript
    /// argument.
    public typealias Index = Base.Index

    /// The position of the first element in a nonempty collection.
    ///
    /// If the collection is empty, `startIndex` is equal to `endIndex`.
    public var startIndex: IndexedIdentifierCollection<Base, ID>.Index { get { fatalError() } }

    /// The collection's "past the end" position---that is, the position one
    /// greater than the last valid subscript argument.
    ///
    /// When you need a range that includes the last element of a collection, use
    /// the half-open range operator (`..<`) with `endIndex`. The `..<` operator
    /// creates a range that doesn't include the upper bound, so it's always
    /// safe to use with `endIndex`. For example:
    ///
    ///     let numbers = [10, 20, 30, 40, 50]
    ///     if let index = numbers.firstIndex(of: 30) {
    ///         print(numbers[index ..< numbers.endIndex])
    ///     }
    ///     // Prints "[30, 40, 50]"
    ///
    /// If the collection is empty, `endIndex` is equal to `startIndex`.
    public var endIndex: IndexedIdentifierCollection<Base, ID>.Index { get { fatalError() } }

    /// Accesses the element at the specified position.
    ///
    /// The following example accesses an element of an array through its
    /// subscript to print its value:
    ///
    ///     var streets = ["Adams", "Bryant", "Channing", "Douglas", "Evarts"]
    ///     print(streets[1])
    ///     // Prints "Bryant"
    ///
    /// You can subscript a collection with any valid index other than the
    /// collection's end index. The end index refers to the position one past
    /// the last element of a collection, so it doesn't correspond with an
    /// element.
    ///
    /// - Parameter position: The position of the element to access. `position`
    ///   must be a valid index of the collection that is not equal to the
    ///   `endIndex` property.
    ///
    /// - Complexity: O(1)
    public subscript(position: IndexedIdentifierCollection<Base, ID>.Index) -> IndexedIdentifierCollection<Base, ID>.Element { get { fatalError() } }

    /// Returns the position immediately after the given index.
    ///
    /// The successor of an index must be well defined. For an index `i` into a
    /// collection `c`, calling `c.index(after: i)` returns the same index every
    /// time.
    ///
    /// - Parameter i: A valid index of the collection. `i` must be less than
    ///   `endIndex`.
    /// - Returns: The index value immediately after `i`.
    public func index(after i: IndexedIdentifierCollection<Base, ID>.Index) -> IndexedIdentifierCollection<Base, ID>.Index { fatalError() }

    /// A type that represents the indices that are valid for subscripting the
    /// collection, in ascending order.
    public typealias Indices = DefaultIndices<IndexedIdentifierCollection<Base, ID>>

    /// A type that provides the collection's iteration interface and
    /// encapsulates its iteration state.
    ///
    /// By default, a collection conforms to the `Sequence` protocol by
    /// supplying `IndexingIterator` as its associated `Iterator`
    /// type.
    public typealias Iterator = IndexingIterator<IndexedIdentifierCollection<Base, ID>>

    /// A collection representing a contiguous subrange of this collection's
    /// elements. The subsequence shares indices with the original collection.
    ///
    /// The default subsequence type for collections that don't define their own
    /// is `Slice`.
    public typealias SubSequence = Slice<IndexedIdentifierCollection<Base, ID>>
}

@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
extension IndexedIdentifierCollection : BidirectionalCollection where Base : BidirectionalCollection {

    /// Returns the position immediately before the given index.
    ///
    /// - Parameter i: A valid index of the collection. `i` must be greater than
    ///   `startIndex`.
    /// - Returns: The index value immediately before `i`.
    public func index(before i: IndexedIdentifierCollection<Base, ID>.Index) -> IndexedIdentifierCollection<Base, ID>.Index { fatalError() }
}

@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
extension IndexedIdentifierCollection : RandomAccessCollection where Base : RandomAccessCollection {
}
*/
