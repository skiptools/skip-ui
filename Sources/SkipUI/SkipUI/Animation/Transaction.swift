// Copyright 2023–2026 Skip
// SPDX-License-Identifier: MPL-2.0
#if !SKIP_BRIDGE
#if SKIP
import SkipModel
#endif

/// The context of the current state-processing update.
///
/// On Android, `Transaction` is a plain value carrier — its `animation` field is the source
/// of truth for the per-slot mutation tag. `withTransaction(_:_:)` pushes `self` onto the
/// `StateTracking` thread-local stack so writes inside the body get tagged with this
/// transaction, then on exit pops the stack AND publishes the animation through
/// `Animation.markRecentWithAnimation(_:)` as a fallback for render-time-resolved values.
#if SKIP
public final class Transaction: StateMutationTransaction {
    public var animation: Animation?
    public var disablesAnimations: Bool
    public var isContinuous: Bool
    public var tracksVelocity: Bool

    /// Storage for custom values written via `withTransaction(_:_:_:)` keypath form. The key is
    /// the fully-qualified `TransactionKey` type name.
    private var customValues: [String: Any?]?

    public init() {
        self.animation = nil
        self.disablesAnimations = false
        self.isContinuous = false
        self.tracksVelocity = false
    }

    public init(animation: Animation?) {
        self.animation = animation
        self.disablesAnimations = false
        self.isContinuous = false
        self.tracksVelocity = false
    }

    /// Read a custom value by key type name. Returns `nil` if no value was set.
    ///
    /// Skip Lite cannot access a static member of a generic type from a companion object, so the
    /// Swift-side subscript `Transaction[K.Type]` (which would call `K.defaultValue`) is not
    /// available on Android. Custom-key consumers manage their own defaults via these helpers.
    public func getCustomValue(forKeyTypeName name: String) -> Any? {
        guard let values = customValues else { return nil }
        return values[name] ?? nil
    }

    /// Set a custom value by key type name.
    public func setCustomValue(forKeyTypeName name: String, value: Any?) {
        if customValues == nil {
            customValues = [:]
        }
        var values = customValues!
        values[name] = value
        customValues = values
    }

    /// Produce a shallow copy of this transaction. Used by `withTransaction(_:_:_:)` so a
    /// keypath-mutated copy doesn't poison the outer transaction.
    func copy() -> Transaction {
        let result = Transaction()
        result.animation = animation
        result.disablesAnimations = disablesAnimations
        result.isContinuous = isContinuous
        result.tracksVelocity = tracksVelocity
        if let customValues {
            result.customValues = customValues
        }
        return result
    }
}
#else
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
@frozen public struct Transaction {

    /// Creates a transaction.
    @inlinable public init() { fatalError() }

    /// Accesses the transaction value associated with a custom key.
    @available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
    public subscript<K>(key: K.Type) -> K.Value where K : TransactionKey { get { fatalError() } }
}
#endif

#if !SKIP
/// A key for accessing values in a transaction.
///
/// On Android, custom `TransactionKey`s aren't supported via the protocol's `defaultValue` static
/// (Skip Lite can't access a static member of a generic type from a companion object). Use
/// `Transaction.getCustomValue(forKeyTypeName:)` and `setCustomValue(forKeyTypeName:value:)` for
/// custom-key storage instead.
@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
public protocol TransactionKey {

    /// The associated type representing the type of the transaction key's
    /// value.
    associatedtype Value

    /// The default value for the transaction key.
    static var defaultValue: Self.Value { get }
}
#endif

/// Executes a closure with the specified transaction and returns the result. The transaction
/// is pushed onto the per-thread `StateTracking` stack for the body's duration so observable
/// writes inside get the per-slot tag; on exit, the transaction is popped AND (if it carries
/// an animation and doesn't disable animations) the animation is published through one
/// Compose frame as a fallback for animatable values that resolve later.
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
public func withTransaction<Result>(_ transaction: Transaction, _ body: () throws -> Result) rethrows -> Result {
    #if SKIP
    let token = StateTracking.pushTransaction(transaction)
    defer {
        StateTracking.popTransaction(token)
        if let animation = transaction.animation, !transaction.disablesAnimations {
            Animation.markRecentWithAnimation(animation)
        }
    }
    return try body()
    #else
    fatalError()
    #endif
}

#if !SKIP
/// Executes a closure with the specified transaction key path and value and returns the result.
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
public func withTransaction<R, V>(_ keyPath: WritableKeyPath<Transaction, V>, _ value: V, _ body: () throws -> R) rethrows -> R {
    fatalError()
}
#endif

// Skip Lite cannot model `WritableKeyPath<Transaction, V>` at the call site, so the keypath
// variant of `withTransaction` is iOS-only for now. Use the explicit-Transaction overload to set
// individual properties on the Skip side.

#endif
