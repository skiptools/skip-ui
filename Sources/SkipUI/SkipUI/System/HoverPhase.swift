// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

#if !SKIP
#if canImport(CoreGraphics)
import struct CoreGraphics.CGPoint
#endif
#endif

public enum HoverPhase : Equatable, Sendable {
    case active(CGPoint)
    case ended
}
