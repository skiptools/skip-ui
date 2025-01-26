// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

#if !SKIP_BRIDGE

public enum ColorRenderingMode : Hashable, Sendable {
    case nonLinear
    case linear
    case extendedLinear
}

#endif
