// Copyright 2023–2026 Skip
// SPDX-License-Identifier: MPL-2.0
#if !SKIP_BRIDGE

public enum EditMode : Hashable {
    case inactive
    case transient
    case active

    public var isEditing: Bool {
        return self != .inactive
    }
}

/// Bridges an `editMode` binding by the mode's case index.
// SKIP @bridge
public final class EditModeBinding {
    // SKIP @bridge
    public let getMode: () -> Int
    // SKIP @bridge
    public let setMode: (Int) -> Void

    // SKIP @bridge
    public init(getMode: @escaping () -> Int, setMode: @escaping (Int) -> Void) {
        self.getMode = getMode
        self.setMode = setMode
    }

    #if SKIP
    convenience init(_ binding: Binding<EditMode>) {
        self.init(getMode: { binding.wrappedValue.bridgedIndex }, setMode: { binding.wrappedValue = EditMode(bridgedIndex: $0) })
    }

    var binding: Binding<EditMode> {
        return Binding(get: { EditMode(bridgedIndex: self.getMode()) }, set: { self.setMode($0.bridgedIndex) })
    }
    #endif
}

extension EditMode {
    init(bridgedIndex: Int) {
        switch bridgedIndex {
        case 1: self = .transient
        case 2: self = .active
        default: self = .inactive
        }
    }

    var bridgedIndex: Int {
        switch self {
        case .inactive: return 0
        case .transient: return 1
        case .active: return 2
        }
    }
}

#endif
