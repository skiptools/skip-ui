// Copyright 2023–2025 Skip
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception
#if false
/// An index view style that places a page index view over its content.
///
/// You can also use ``IndexViewStyle/page`` to construct this style.
@available(iOS 14.0, tvOS 14.0, watchOS 8.0, *)
@available(macOS, unavailable)
public struct PageIndexViewStyle : IndexViewStyle {

    /// The background style for the page index view.
    public struct BackgroundDisplayMode : Sendable {

        /// Background will use the default for the platform.
        public static let automatic: PageIndexViewStyle.BackgroundDisplayMode = { fatalError() }()

        /// Background is only shown while the index view is interacted with.
        @available(watchOS, unavailable)
        public static let interactive: PageIndexViewStyle.BackgroundDisplayMode = { fatalError() }()

        /// Background is always displayed behind the page index view.
        @available(watchOS, unavailable)
        public static let always: PageIndexViewStyle.BackgroundDisplayMode = { fatalError() }()

        /// Background is never displayed behind the page index view.
        public static let never: PageIndexViewStyle.BackgroundDisplayMode = { fatalError() }()
    }

    /// Creates a page index view style.
    ///
    /// - Parameter backgroundDisplayMode: The display mode of the background of any
    /// page index views receiving this style
    public init(backgroundDisplayMode: PageIndexViewStyle.BackgroundDisplayMode = .automatic) { fatalError() }
}
#endif
