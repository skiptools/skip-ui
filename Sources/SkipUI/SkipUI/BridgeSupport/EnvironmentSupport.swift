// Copyright 2025 Skip
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception
#if !SKIP_BRIDGE

/// Support for bridged`SwiftUI.@Environment`.
///
/// The Compose side manages object lifecycles, so we hold references to the native value.
/// Environment values are not necessarily bridged or bridgable, so we use an opaque pointer.
/// This support object is placed in the Compose environment.
// SKIP @bridge
public final class EnvironmentSupport {
    /// Supply a Swift pointer to an object that holds the environment value and a block to release the object on finalize.
    // SKIP @bridge
    public init(valueHolder: Int64) {
        self.valueHolder = valueHolder
        self.builtinValue = nil
    }

    public init(builtinValue: Any?) {
        self.builtinValue = builtinValue
        self.valueHolder = Int64(0)
    }

    #if SKIP
    deinit {
        if valueHolder != Int64(0) {
            valueHolder = Swift_release(valueHolder)
        }
    }

    /// - Seealso `SkipFuseUI.Environment`
    // SKIP EXTERN
    private func Swift_release(Swift_valueHolder: Int64) -> Int64
    #endif


    // SKIP @bridge
    public private(set) var valueHolder: Int64

    // SKIP @bridge
    public let builtinValue: Any?
}

#endif
