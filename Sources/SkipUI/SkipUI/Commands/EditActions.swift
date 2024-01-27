// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

import Foundation

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
        return EditActionsModifierView(view: self, isDeleteDisabled: isDisabled)
        #else
        return self
        #endif
    }
    
    public func moveDisabled(_ isDisabled: Bool) -> some View {
        #if SKIP
        return EditActionsModifierView(view: self, isMoveDisabled: isDisabled)
        #else
        return self
        #endif
    }
}

#if SKIP
final class EditActionsModifierView: ComposeModifierView {
    var isDeleteDisabled: Bool?
    var isMoveDisabled: Bool?

    init(view: View, isDeleteDisabled: Bool? = nil, isMoveDisabled: Bool? = nil) {
        super.init(view: view, role: ComposeModifierRole.editActions)
        let wrappedEditActionsView = Self.unwrap(view: view)
        self.isDeleteDisabled = isDeleteDisabled ?? wrappedEditActionsView?.isDeleteDisabled
        self.isMoveDisabled = isMoveDisabled ?? wrappedEditActionsView?.isMoveDisabled
    }

    /// Return the edit actions modifier information for the given view.
    static func unwrap(view: View) -> EditActionsModifierView? {
        return view.strippingModifiers(until: { $0 == .editActions }, perform: { $0 as? EditActionsModifierView })
    }
}

extension Array {
    public mutating func remove(atOffsets offsets: IndexSet) {
        for offset in offsets.reversed() {
            remove(at: offset)
        }
    }

    public mutating func move(fromOffsets source: IndexSet, toOffset destination: Int) {
        // Calling with the same offset or the
        guard source.count > 1 || (destination != source[0] && destination != source[0] + 1) else {
            return
        }

        var moved: [Element] = []
        var belowDestinationCount = 0
        for offset in source.reversed() {
            moved.append(remove(at: offset))
            if offset < destination {
                belowDestinationCount += 1
            }
        }
        for m in moved {
            insert(m, at: destination - belowDestinationCount)
        }
    }
}
#endif
