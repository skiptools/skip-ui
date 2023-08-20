// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

#if !SKIP

/// The kinds of background tasks that your app or extension can handle.
///
/// Use a value of this type with the ``Scene/backgroundTask(_:action:)`` scene
/// modifier to create a handler for background tasks that the system sends
/// to your app or extension. For example, you can use ``urlSession`` to define
/// an asynchronous closure that the system calls when it launches your app or
/// extension to handle a response from a background
/// .
@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
public struct BackgroundTask<Request, Response> : Sendable {
}

@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
extension BackgroundTask {

    /// A task that responds to background URL sessions.
    public static var urlSession: BackgroundTask<String, Void> { get { fatalError() } }

    /// A task that responds to background URL sessions matching the given
    /// identifier.
    ///
    /// - Parameter identifier: The identifier to match.
    ///
    /// - Returns: A background task that you can handle with your app or
    ///   extension.
    public static func urlSession(_ identifier: String) -> BackgroundTask<Void, Void> { fatalError() }

    /// A task that responds to background URL sessions matching the given
    /// predicate.
    ///
    /// - Parameter matching: The predicate to match.
    ///
    /// - Returns: A background task that you can handle with your app or
    ///   extension.
    public static func urlSession(matching: @escaping @Sendable (String) -> Bool) -> BackgroundTask<String, Void> { fatalError() }

    /// A task that updates your app’s state in the background for a
    /// matching identifier.
    ///
    /// - Parameter matching: The identifier to match.
    ///
    /// - Returns: A background task that you can handle with your app or
    ///   extension.
    @available(macOS, unavailable)
    public static func appRefresh(_ identifier: String) -> BackgroundTask<Void, Void> { fatalError() }
}


#endif
