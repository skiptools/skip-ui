// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

/// Executes a closure with the specified transaction and returns the result.
///
/// - Parameters:
///   - transaction : An instance of a transaction, set as the thread's current
///     transaction.
///   - body: A closure to execute.
///
/// - Returns: The result of executing the closure with the specified
///   transaction.
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
public func withTransaction<Result>(_ transaction: Transaction, _ body: () throws -> Result) rethrows -> Result { fatalError() }

/// Executes a closure with the specified transaction key path and value and
/// returns the result.
///
/// - Parameters:
///   - keyPath: A key path that indicates the property of the ``Transaction``
///     structure to update.
///   - value: The new value to set for the item specified by `keyPath`.
///   - body: A closure to execute.
///
/// - Returns: The result of executing the closure with the specified
///   transaction value.
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
public func withTransaction<R, V>(_ keyPath: WritableKeyPath<Transaction, V>, _ value: V, _ body: () throws -> R) rethrows -> R { fatalError() }
