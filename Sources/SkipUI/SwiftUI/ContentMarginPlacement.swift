// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

#if !SKIP

/// The placement of margins.
///
/// Different views can support customizating margins that appear in
/// different parts of that view. Use values of this type to customize
/// those margins of a particular placement.
///
/// For example, use a ``ContentMarginPlacement/scrollIndicators``
/// placement to customize the margins of scrollable view's scroll
/// indicators separately from the margins of a scrollable view's
/// content.
///
/// Use this type in conjunction with the ``View/contentMargin(_:for:)``
/// modifier.
@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
public struct ContentMarginPlacement {

    /// The automatic placement.
    ///
    /// Views that support margin customization can automatically use
    /// margins with this placement. For example, a ``ScrollView`` will
    /// use this placement to automatically inset both its content and
    /// scroll indicators by the specified amount.
    public static var automatic: ContentMarginPlacement { get { fatalError() } }

    /// The scroll content placement.
    ///
    /// Scrollable views like ``ScrollView`` will use this placement to
    /// inset their content, but not their scroll indicators.
    public static var scrollContent: ContentMarginPlacement { get { fatalError() } }

    /// The scroll indicators placement.
    ///
    /// Scrollable views like ``ScrollView`` will use this placement to
    /// inset their scroll indicators, but not their content.
    public static var scrollIndicators: ContentMarginPlacement { get { fatalError() } }
}


#endif
