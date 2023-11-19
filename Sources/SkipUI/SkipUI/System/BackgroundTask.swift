// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

public struct BackgroundTask<Request, Response> : Sendable {
    @available(*, unavailable)
    public static var urlSession: BackgroundTask<String, Void> { get { fatalError() } }

    @available(*, unavailable)
    public static func urlSession(_ identifier: String) -> BackgroundTask<Void, Void> { fatalError() }

    @available(*, unavailable)
    public static func urlSession(matching: @escaping @Sendable (String) -> Bool) -> BackgroundTask<String, Void> { fatalError() }

    @available(*, unavailable)
    public static func appRefresh(_ identifier: String) -> BackgroundTask<Void, Void> { fatalError() }
}
