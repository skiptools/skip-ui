// Copyright 2023–2026 Skip
// SPDX-License-Identifier: MPL-2.0

/// The result of composing content.
///
/// Reserved for future use. Having a return value also expands recomposition scope. See `ComposeBuilder` for details.
public struct ComposeResult: Sendable {
    public static let ok = ComposeResult()
}
