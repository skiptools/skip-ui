// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

#if !SKIP_BRIDGE
#if SKIP
import androidx.window.core.layout.WindowHeightSizeClass
import androidx.window.core.layout.WindowWidthSizeClass
#endif

public enum UserInterfaceSizeClass: Hashable {
    case compact
    case regular

    #if SKIP
    public static func fromWindowHeightSizeClass(_ sizeClass: WindowHeightSizeClass) -> UserInterfaceSizeClass {
        return sizeClass == WindowHeightSizeClass.COMPACT ? .compact : .regular
    }

    public static func fromWindowWidthSizeClass(_ sizeClass: WindowWidthSizeClass) -> UserInterfaceSizeClass {
        return sizeClass == WindowWidthSizeClass.COMPACT ? .compact : .regular
    }
    #endif
}

#endif
