// Copyright 2023–2025 Skip
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception
#if !SKIP_BRIDGE

// For our purposes, Bindable and ObservedObject act exactly the same
public typealias ObservedObject<T> = Bindable<T>

#endif
