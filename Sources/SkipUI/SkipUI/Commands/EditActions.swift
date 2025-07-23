// Copyright 2023–2025 Skip
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception
#if !SKIP_BRIDGE
import Foundation

public struct EditActions /* <Data> */ : OptionSet {
    public let rawValue: Int

    public init(rawValue: Int) {
        self.rawValue = rawValue
    }

    public static let move = EditActions(rawValue: 1) // For bridging
    public static let delete = EditActions(rawValue: 2) // For bridging
    public static let all = EditActions(rawValue: 3) // For bridging
}

extension View {
    // SKIP @bridge
    public func deleteDisabled(_ isDisabled: Bool) -> any View {
        #if SKIP
        return ModifiedContent(content: self, modifier: EditActionsModifier(isDeleteDisabled: isDisabled))
        #else
        return self
        #endif
    }

    // SKIP @bridge
    public func moveDisabled(_ isDisabled: Bool) -> any View {
        #if SKIP
        return ModifiedContent(content: self, modifier: EditActionsModifier(isMoveDisabled: isDisabled))
        #else
        return self
        #endif
    }
}

#if SKIP
final class EditActionsModifier: RenderModifier {
    let isDeleteDisabled: Bool?
    let isMoveDisabled: Bool?

    init(isDeleteDisabled: Bool? = nil, isMoveDisabled: Bool? = nil) {
        self.isDeleteDisabled = isDeleteDisabled
        self.isMoveDisabled = isMoveDisabled
        super.init()
    }

    /// Return the edit actions modifier information for the given view.
    static func combined(for renderable: Renderable) -> EditActionsModifier {
        var isDeleteDisabled: Bool? = nil
        var isMoveDisabled: Bool? = nil
        renderable.forEachModifier {
            if let editActionsModifier = $0 as? EditActionsModifier {
                isDeleteDisabled = isDeleteDisabled ?? editActionsModifier.isDeleteDisabled
                isMoveDisabled = isMoveDisabled ?? editActionsModifier.isMoveDisabled
            }
            return nil
        }
        return EditActionsModifier(isDeleteDisabled: isDeleteDisabled, isMoveDisabled: isMoveDisabled)
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
#endif
