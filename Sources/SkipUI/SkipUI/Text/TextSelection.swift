// Copyright 2023–2025 Skip
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception
#if !SKIP_BRIDGE
import Foundation
#if SKIP
import androidx.compose.ui.text.TextRange
#endif

// SKIP @bridge
public struct TextSelection : Equatable, Hashable {
    public enum Indices : Equatable, Hashable {
        case selection(Range<String.Index>)
    }
    
    public var indices: TextSelection.Indices
    
    public var affinity: TextSelectionAffinity {
        return .automatic
    }
    
    public let isInsertion: Bool
    
    public init(range: Range<String.Index>) {
        self.indices = .selection(range)
        self.isInsertion = false
    }
    
    public init(insertionPoint: String.Index) {
        self.indices = .selection(insertionPoint..<insertionPoint)
        self.isInsertion = true
    }
    
    public static func == (lhs: TextSelection, rhs: TextSelection) -> Bool {
        return lhs.indices == rhs.indices
    }
    
    #if SKIP
    
    /// Return the equivalent Compose text range.
    public func asComposeTextRange() -> TextRange {
        switch self.indices {
        case .selection(let range):
            return TextRange(range.lowerBound, range.upperBound)
        }
    }
    
    #endif
}

public enum TextSelectionAffinity : Equatable, Hashable {
    case automatic
    case upstream
    case downstream
}

#endif
