// Copyright 2023–2025 Skip
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception
#if false
/// The standard sizes of sidebar rows.
///
/// On macOS, sidebar rows have three different sizes: small, medium, and large.
/// The size is primarily controlled by the current users' "Sidebar Icon Size"
/// in Appearance settings, and applies to all applications.
///
/// On all other platforms, the only supported sidebar size is `.medium`.
///
/// This size can be read or written in the environment using
/// `EnvironmentValues.sidebarRowSize`.
@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
public enum SidebarRowSize : Sendable {

    /// The standard "small" row size
    case small

    /// The standard "medium" row size
    case medium

    /// The standard "large" row size
    case large

    
}

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension SidebarRowSize : Hashable {
}
#endif
