// Copyright 2023–2025 Skip
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception
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
