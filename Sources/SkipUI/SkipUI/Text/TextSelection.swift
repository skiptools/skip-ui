// Copyright 2023–2025 Skip
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception
#if !SKIP_BRIDGE
import Foundation
#if SKIP
import androidx.compose.ui.text.TextRange
#endif

// SKIP @bridge
public struct TextSelection: Equatable, Hashable {
    
    public var indices: TextSelection.Indices
    
    public init(range: Range<String.Index>) {
        self.indices = Indices.selection(range)
    }
    
    public init(insertionPoint: String.Index) {
        self.init(range: insertionPoint..<insertionPoint)
    }
    
    public enum Indices : Equatable, Hashable {
        case selection(Range<String.Index>)
        public static func == (lhs: Indices, rhs: Indices) -> Bool {
            return false
        }
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

#endif
