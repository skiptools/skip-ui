// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

#if SKIP

/// Allow views to specialize based on their placement.
struct ViewPlacement: RawRepresentable, OptionSet {
    let rawValue: Int

    static let listItem = ViewPlacement(rawValue: 1)
    static let systemTextColor = ViewPlacement(rawValue: 2)
    static let onPrimaryColor = ViewPlacement(rawValue: 4)
    static let tagged = ViewPlacement(rawValue: 8)
    static let toolbar = ViewPlacement(rawValue: 16)
}

#endif
