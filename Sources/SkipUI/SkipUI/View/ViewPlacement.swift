// Copyright 2023–2025 Skip
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception
#if SKIP

/// Allow views to specialize based on their placement.
struct ViewPlacement: RawRepresentable, OptionSet {
    let rawValue: Int

    static let listItem = ViewPlacement(rawValue: 1)
    static let systemTextColor = ViewPlacement(rawValue: 2)
    static let onPrimaryColor = ViewPlacement(rawValue: 4)
    static let toolbar = ViewPlacement(rawValue: 8)
}

#endif
