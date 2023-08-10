// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

#if !SKIP



/// A container for views that you present as menu items in a context menu.
///
/// A context menu view allows you to present a situationally specific menu
/// that enables taking actions relevant to the current task.
///
/// You can create a context menu by first defining a `ContextMenu` container
/// with the controls that represent the actions that people can take,
/// and then using the ``View/contextMenu(_:)`` view modifier to apply the
/// menu to a view.
///
/// The example below creates and applies a two item context menu container
/// to a ``Text`` view. The Boolean value `shouldShowMenu`, which defaults to
/// true, controls the availability of context menu:
///
///     private let menuItems = ContextMenu {
///         Button {
///             // Add this item to a list of favorites.
///         } label: {
///             Label("Add to Favorites", systemImage: "heart")
///         }
///         Button {
///             // Open Maps and center it on this item.
///         } label: {
///             Label("Show in Maps", systemImage: "mappin")
///         }
///     }
///
///     private struct ContextMenuMenuItems: View {
///         @State private var shouldShowMenu = true
///
///         var body: some View {
///             Text("Turtle Rock")
///                 .contextMenu(shouldShowMenu ? menuItems : nil)
///         }
///     }
///
/// ![A screenshot of a context menu showing two menu items: Add to
/// Favorites, and Show in Maps.](View-contextMenu-1-iOS)
@available(iOS, introduced: 13.0, deprecated: 100000.0, message: "Use `contextMenu(menuItems:)` instead.")
@available(macOS, introduced: 10.15, deprecated: 100000.0, message: "Use `contextMenu(menuItems:)` instead.")
@available(tvOS, unavailable)
@available(watchOS, introduced: 6.0, deprecated: 7.0)
public struct ContextMenu<MenuItems> where MenuItems : View {

    public init(@ViewBuilder menuItems: () -> MenuItems) { fatalError() }
}


#endif
