// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

// TODO: Process for use in SkipUI

#if !SKIP

/// Programmatic window dismissal behaviors.
///
/// Use values of this type to control window dismissal during the
/// current transaction.
///
/// For example, to dismiss windows showing a modal presentation
/// that would otherwise prohibit dismissal, use the ``destructive``
/// behavior:
///
///     struct DismissWindowButton: View {
///         @Environment(\.dismissWindow) private var dismissWindow
///
///         var body: some View {
///             Button("Close Auxiliary Window") {
///                 withTransaction(\.dismissBehavior, .destructive) {
///                     dismissWindow(id: "auxiliary")
///                 }
///             }
///         }
///     }
///
@available(iOS 17.0, macOS 14.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
public struct DismissBehavior : Sendable {

    /// The interactive dismiss behavior.
    ///
    /// Use this behavior when you want to dismiss a window in a manner that is
    /// similar to the standard system affordances for window dismissal - for
    /// example, when a user clicks the close button.
    ///
    /// This is the default behavior on macOS and iOS.
    ///
    /// On macOS, dismissing a window using this behavior will not dismiss a
    /// window which is currently showing a modal presentation, such as a sheet
    /// or alert. Additionally, a document window that is dismissed with this
    /// behavior will show the save dialog if there are unsaved changes to the
    /// document.
    ///
    /// On iOS, dismissing a window using this behavior will dismiss it
    /// regardless of any modal presentations being shown.
    public static let interactive: DismissBehavior = { fatalError() }()

    /// The destructive dismiss behavior.
    ///
    /// Use this behavior when you want to dismiss a window regardless of
    /// any conditions that would normally prevent the dismissal. Dismissing
    /// windows in this matter may result in loss of state.
    ///
    /// On macOS, this behavior will cause windows to dismiss even when they are
    /// currently showing a modal presentation, such as a sheet or alert.
    /// Additionally, a document window will not show the save dialog when
    /// there are unsaved changes and the window is dismissed with this
    /// behavior.
    ///
    /// On iOS, this behavior behaves the same as `interactive`.
    public static let destructive: DismissBehavior = { fatalError() }()
}

#endif
