// Copyright 2023–2025 Skip
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception
#if !SKIP_BRIDGE

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

#endif
