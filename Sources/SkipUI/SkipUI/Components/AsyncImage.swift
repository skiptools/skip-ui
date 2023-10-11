// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

import Foundation

public struct AsyncImage /* <Content> */ : View /* where Content : View */ {
    @available(*, unavailable)
    public init(url: URL?, scale: CGFloat = 1.0) /* where Content == Image */ {
    }

    @available(*, unavailable)
    public init(url: URL?, scale: CGFloat = 1.0, @ViewBuilder content: @escaping (Image) -> any View, @ViewBuilder placeholder: @escaping () -> any View) {
    }

    @available(*, unavailable)
    public init(url: URL?, scale: CGFloat = 1.0, transaction: Any? = nil /* Transaction = Transaction() */, @ViewBuilder content: @escaping (AsyncImagePhase) -> any View) {
    }

    #if !SKIP
    public var body: some View {
        stubView()
    }
    #endif
}

public enum AsyncImagePhase : Sendable {
    case empty
    case success(Image)
    case failure(Error)

    public var image: Image? {
        switch self {
        case .success(let image):
            return image
        default:
            return nil
        }
    }

    public var error: Error? {
        switch self {
        case .failure(let error):
            return error
        default:
            return nil
        }
    }
}
