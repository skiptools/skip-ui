// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

#if !SKIP

import struct Foundation.IndexSet

/// No-op
@usableFromInline func stubDynamicViewContent() -> some DynamicViewContent {
    return never()
}

/// A type of view that generates views from an underlying collection of data.
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
public protocol DynamicViewContent : View {

    /// The type of the underlying collection of data.
    associatedtype Data : Collection

    /// The collection of underlying data.
    var data: Self.Data { get }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension DynamicViewContent {

    /// Sets the deletion action for the dynamic view.
    ///
    /// - Parameter action: The action that you want SkipUI to perform when
    ///   elements in the view are deleted. SkipUI passes a set of indices to the
    ///   closure that's relative to the dynamic view's underlying collection of
    ///   data.
    ///
    /// - Returns: A view that calls `action` when elements are deleted from the
    ///   original view.
    @inlinable public func onDelete(perform action: ((IndexSet) -> Void)?) -> some DynamicViewContent { return stubDynamicViewContent() }

}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension DynamicViewContent {

    /// Sets the move action for the dynamic view.
    ///
    /// - Parameters:
    ///   - action: A closure that SkipUI invokes when elements in the dynamic
    ///     view are moved. The closure takes two arguments that represent the
    ///     offset relative to the dynamic view's underlying collection of data.
    ///     Pass `nil` to disable the ability to move items.
    ///
    /// - Returns: A view that calls `action` when elements are moved within the
    ///   original view.
    @inlinable public func onMove(perform action: ((IndexSet, Int) -> Void)?) -> some DynamicViewContent { return stubDynamicViewContent() }

}

extension Never : DynamicViewContent {
    public typealias Data = [Never]

    /// The collection of underlying data.
    public var data: Self.Data { fatalError() }
}


extension RangeReplaceableCollection where Self : MutableCollection {

    /// Removes all the elements at the specified offsets from the collection.
    ///
    /// - Complexity: O(*n*) where *n* is the length of the collection.
    ///
    @available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
    public mutating func remove(atOffsets offsets: IndexSet) { fatalError() }
}

extension MutableCollection {

    /// Moves all the elements at the specified offsets to the specified
    /// destination offset, preserving ordering.
    ///
    /// Pass an offset as `destination` to indicate where in the collection the
    /// moved elements should be inserted. Of the elements that are not
    /// represented by the offsets in `source`, those before `destination` are
    /// moved toward the beginning of the collection to make room for the moved
    /// elements, while those at or after `destination` are moved toward the
    /// end.
    ///
    /// In this example, demonstrating moving several elements to different
    /// destination offsets, `lowercaseOffsets` represents the offsets of the
    /// lowercase elements in `letters`:
    ///
    ///     var letters = Array("ABcDefgHIJKlmNO")
    ///     let lowercaseOffsets = IndexSet(...)
    ///     letters.move(fromOffsets: lowercaseOffsets, toOffset: 2)
    ///     // String(letters) == "ABcefglmDHIJKNO"
    ///
    ///     // Reset the `letters` array.
    ///     letters = Array("ABcDefgHIJKlmNO")
    ///     letters.move(fromOffsets: lowercaseOffsets, toOffset: 15)
    ///     // String(letters) == "ABDHIJKNOcefglm"
    ///
    /// If `source` represents a single element, calling this method with its
    /// own offset, or the offset of the following element, as `destination`
    /// has no effect.
    ///
    ///     letters = Array("ABcDefgHIJKlmNO")
    ///     letters.move(fromOffsets: IndexSet(integer: 2), toOffset: 2)
    ///     // String(letters) == "ABcDefgHIJKlmNO"
    ///
    /// - Parameters:
    ///   - source: An index set representing the offsets of all elements that
    ///     should be moved.
    ///   - destination: The offset of the element before which to insert the
    ///     moved elements. `destination` must be in the closed range
    ///     `0...count`.
    ///
    /// - Complexity: O(*n* log *n*), where *n* is the length of the collection.
    @available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
    public mutating func move(fromOffsets source: IndexSet, toOffset destination: Int) { fatalError() }
}

#endif
