// Copyright 2023–2025 Skip
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception
#if !SKIP_BRIDGE

public enum Visibility : Hashable, CaseIterable, Sendable {
    case automatic
    case visible
    case hidden
}

#endif
