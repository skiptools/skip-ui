// Copyright 2023–2025 Skip
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception
#if SKIP

/// Manage options used in `View.Evaluate(context:options:)`.
struct EvaluateOptions {
    private static let keepForEach = 1 << 0
    private static let keepNonModified = 1 << 1
    // We use values < 1000 for bitwise options and add 1000 per lazy item level (+ 1)
    private static let lazyItemLevels = 1000

    init(_ value: Int) {
        self.value = value
    }

    init(isKeepForEach: Bool = false, isKeepNonModified: Bool = false, lazyItemLevel: Int? = nil) {
        var options = EvaluateOptions(0)
        options.isKeepForEach = isKeepForEach
        options.isKeepNonModified = isKeepNonModified
        options.lazyItemLevel = lazyItemLevel
        self = options
    }

    private(set) var value: Int

    /// Option to keep `ForEach` instances rather than evaluating them.
    var isKeepForEach: Bool {
        get {
            return (value % Self.lazyItemLevels) & Self.keepForEach == Self.keepForEach
        }
        set {
            if newValue {
                value = value | Self.keepForEach
            } else {
                value = value & ~Self.keepForEach
            }
        }
    }

    /// Option to keep any view that is not a `ModifiedContent` rather than evaluating it.
    ///
    /// If the view is not a `Renderable`, it is wrapped in one.
    ///
    /// - Warning: Only works reliably when evaluating a `ComposeBuilder`.
    var isKeepNonModified: Bool {
        get {
            return (value % Self.lazyItemLevels) & Self.keepNonModified == Self.keepNonModified
        }
        set {
            if newValue {
                value = value | Self.keepNonModified
            } else {
                value = value & ~Self.keepNonModified
            }
        }
    }

    /// Manage lazy item evaluation.
    ///
    /// - Seealso: `LazyItemFactory`
    var lazyItemLevel: Int? {
        get {
            guard value >= Self.lazyItemLevels else {
                return nil
            }
            var level = 0
            while true {
                value -= Self.lazyItemLevels
                guard value >= Self.lazyItemLevels else {
                    break
                }
                level += 1
            }
            return level
        }
        set {
            var value = self.value % Self.lazyItemLevels
            if let newValue {
                value += Self.lazyItemLevels * (newValue + 1)
            }
            self.value = value
        }
    }
}

#endif
