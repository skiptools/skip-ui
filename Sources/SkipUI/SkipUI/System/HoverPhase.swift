// Copyright 2023–2025 Skip
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception
#if !SKIP_BRIDGE
#if !SKIP
#if canImport(CoreGraphics)
import struct CoreGraphics.CGPoint
#endif
#endif

public enum HoverPhase : Equatable {
    case active(CGPoint)
    case ended
}

#endif
