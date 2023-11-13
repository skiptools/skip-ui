// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

#if SKIP
#else
import struct Foundation.IndexSet
#endif

public struct EditActions /* <Data> */ : OptionSet, Sendable {
    public let rawValue: Int

    public init(rawValue: Int) {
        self.rawValue = rawValue
    }

    public static let move = EditActions(rawValue: 1)
    public static let delete = EditActions(rawValue: 2)
    public static let all = EditActions(rawValue: 3)
}

extension View {
    public func deleteDisabled(_ isDisabled: Bool) -> some View {
        #if SKIP
        return EditActionsModifierView(contextView: self, isDeleteDisabled: isDisabled)
        #else
        return self
        #endif
    }
    
    public func moveDisabled(_ isDisabled: Bool) -> some View {
        #if SKIP
        return EditActionsModifierView(contextView: self, isMoveDisabled: isDisabled)
        #else
        return self
        #endif
    }
}

#if SKIP
class EditActionsModifierView: ComposeModifierView {
    var isDeleteDisabled: Bool?
    var isMoveDisabled: Bool?

    init(contextView: View, isDeleteDisabled: Bool? = nil, isMoveDisabled: Bool? = nil) {
        super.init(contextView: contextView, role: ComposeModifierRole.editActions, contextTransform: { _ in })
        let wrappedEditActionsView = Self.unwrap(view: contextView)
        self.isDeleteDisabled = isDeleteDisabled ?? wrappedEditActionsView?.isDeleteDisabled
        self.isMoveDisabled = isMoveDisabled ?? wrappedEditActionsView?.isMoveDisabled
    }

    /// Return the edit actions modifier information for the given view.
    static func unwrap(view: View) -> EditActionsModifierView? {
        return view.strippingModifiers(until: { $0 == .editActions }, perform: { $0 as? EditActionsModifierView })
    }
}
#endif

#if !SKIP
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
    public func onDelete(perform action: ((IndexSet) -> Void)?) -> some DynamicViewContent { stubDynamicViewContent() }

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
    public func onMove(perform action: ((IndexSet, Int) -> Void)?) -> some DynamicViewContent { stubDynamicViewContent() }

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
