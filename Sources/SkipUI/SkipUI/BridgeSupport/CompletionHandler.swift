// Copyright 2025 Skip
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception
#if !SKIP_BRIDGE

/// Generic completion handler to take the place of passing a completion closure to a bridged closure, as we
/// do not yet supporting bridging closure arguments to closures.
// SKIP @bridge
public final class CompletionHandler {
    private let handler: () -> Void

    public init(_ handler: @escaping () -> Void) {
        self.handler = handler
    }

    // SKIP @bridge
    public func run() {
        handler()
    }

    // SKIP @bridge
    public var onCancel: (() -> Void)?
}

#endif
