// Copyright 2023–2026 Skip
#if !SKIP_BRIDGE

public struct BackgroundTask<Request, Response> {
    @available(*, unavailable)
    public static var urlSession: BackgroundTask<String, Void> { get { fatalError() } }

    @available(*, unavailable)
    public static func urlSession(_ identifier: String) -> BackgroundTask<Void, Void> { fatalError() }

    @available(*, unavailable)
    public static func urlSession(matching: @escaping (String) -> Bool) -> BackgroundTask<String, Void> { fatalError() }

    @available(*, unavailable)
    public static func appRefresh(_ identifier: String) -> BackgroundTask<Void, Void> { fatalError() }
}

#endif
