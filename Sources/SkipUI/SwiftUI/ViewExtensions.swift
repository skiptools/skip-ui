// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

import protocol Foundation.LocalizedError

import struct Foundation.URL
import struct Foundation.CharacterSet
import struct Foundation.Locale

import class Foundation.FileWrapper
import class Foundation.NSUserActivity
import class Foundation.UserDefaults

import protocol Combine.ObservableObject

extension View {

    /// Sets the preferred visibility of the non-transient system views
    /// overlaying the app.
    ///
    /// Use this modifier if you would like to customise the immersive
    /// experience of your app by hiding or showing system overlays that may
    /// affect user experience. The following example hides every persistent
    /// system overlay.
    ///
    ///     struct ImmersiveView: View {
    ///         var body: some View {
    ///             Text("Maximum immersion")
    ///                 .persistentSystemOverlays(.hidden)
    ///         }
    ///     }
    ///
    /// Note that this modifier only sets a preference and, ultimately the
    /// system will decide if it will honour it or not.
    ///
    /// These non-transient system views include:
    /// - The Home indicator
    /// - The SharePlay indicator
    /// - The Multi-task indicator and Picture-in-picture on iPad
    ///
    /// - Parameter visibility: A value that indicates the visibility of the
    /// non-transient system views overlaying the app.
    @available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
    public func persistentSystemOverlays(_ visibility: Visibility) -> some View { return never() }

}

extension View {

    @available(iOS, introduced: 13.0, deprecated: 100000.0, message: "Use toolbar(_:) with navigationBarLeading or navigationBarTrailing placement")
    @available(tvOS, introduced: 13.0, deprecated: 100000.0, message: "Use toolbar(_:) with navigationBarLeading or navigationBarTrailing placement")
    @available(macOS, unavailable)
    @available(watchOS, unavailable)
    @available(xrOS, introduced: 1.0, deprecated: 100000.0, message: "Use toolbar(_:) with navigationBarLeading or navigationBarTrailing placement")
    public func navigationBarItems<L, T>(leading: L, trailing: T) -> some View where L : View, T : View { return never() }


    @available(iOS, introduced: 13.0, deprecated: 100000.0, message: "Use toolbar(_:) with navigationBarLeading or navigationBarTrailing placement")
    @available(tvOS, introduced: 13.0, deprecated: 100000.0, message: "Use toolbar(_:) with navigationBarLeading or navigationBarTrailing placement")
    @available(macOS, unavailable)
    @available(watchOS, unavailable)
    @available(xrOS, introduced: 1.0, deprecated: 100000.0, message: "Use toolbar(_:) with navigationBarLeading or navigationBarTrailing placement")
    public func navigationBarItems<L>(leading: L) -> some View where L : View { return never() }


    @available(iOS, introduced: 13.0, deprecated: 100000.0, message: "Use toolbar(_:) with navigationBarLeading or navigationBarTrailing placement")
    @available(tvOS, introduced: 13.0, deprecated: 100000.0, message: "Use toolbar(_:) with navigationBarLeading or navigationBarTrailing placement")
    @available(macOS, unavailable)
    @available(watchOS, unavailable)
    @available(xrOS, introduced: 1.0, deprecated: 100000.0, message: "Use toolbar(_:) with navigationBarLeading or navigationBarTrailing placement")
    public func navigationBarItems<T>(trailing: T) -> some View where T : View { return never() }

}

extension View {

    /// Positions this view within an invisible frame with a size relative
    /// to the nearest container.
    ///
    /// Use this modifier to specify a size for a view's width, height,
    /// or both that is dependent on the size of the nearest container.
    /// Different things can represent a "container" including:
    ///   - The window presenting a view on iPadOS or macOS, or the
    ///     screen of a device on iOS.
    ///   - A column of a NavigationSplitView
    ///   - A NavigationStack
    ///   - A tab of a TabView
    ///   - A scrollable view like ScrollView or List
    ///
    /// The size provided to this modifier is the size of a container like
    /// the ones listed above subtraacking any safe area insets that might
    /// be applied to that container.
    ///
    /// The following example will have each purple rectangle occupy the full
    /// size of the screen on iOS:
    ///
    ///     ScrollView(.horizontal) {
    ///         LazyHStack(spacing: 0.0) {
    ///             ForEach(items) { item in
    ///                 Rectangle()
    ///                     .fill(.purple)
    ///                     .containerRelativeFrame([.horizontal, .vertical])
    ///             }
    ///         }
    ///     }
    ///
    /// Use the ``View/containerRelativeFrame(_:count:span:spacing:alignment:)``
    /// modifier to size a view such that multiple views will be visible in
    /// the container. When using this modifier, the count refers to the
    /// total number of rows or columns that the length of the container size
    /// in a particular axis should be divided into. The span refers to the
    /// number of rows or columns that the modified view should actually
    /// occupy. Thus the size of the element can be described like so:
    ///
    ///     let availableWidth = (containerWidth - (spacing * (count - 1)))
    ///     let columnWidth = (availableWidth / count)
    ///     let itemWidth = (columnWidth * span) + ((span - 1) * spacing)
    ///
    /// The following example only uses the nearest container size in the
    /// horizontal axis, allowing the vertical axis to be determined using
    /// the ``View/aspectRatio(_:contentMode:)-771ow`` modifier.
    ///
    ///     ScrollView(.horizontal) {
    ///         LazyHStack(spacing: 10.0) {
    ///             ForEach(items) { item in
    ///                 Rectangle()
    ///                     .fill(.purple)
    ///                     .aspectRatio(3.0 / 2.0, contentMode: .fit)
    ///                     .containerRelativeFrame(
    ///                         .horizontal, count: 4, span: 3, spacing: 10.0)
    ///             }
    ///         }
    ///     }
    ///     .safeAreaPadding(.horizontal, 20.0)
    ///
    /// Use the ``View/containerRelativeFrame(_:alignment:_:)``
    /// modifier to apply your own custom logic to adjust the size
    /// of the nearest container for your view. The following example will
    /// result in the container frame's width being divided by 3 and using
    /// that value as the width of the purple rectangle.
    ///
    ///     Rectangle()
    ///         .fill(.purple)
    ///         .aspectRatio(1.0, contentMode: .fill)
    ///         .containerRelativeFrame(
    ///             .horizontal, alignment: .topLeading
    ///         ) { length, axis in
    ///             if axis == .vertical {
    ///                 return length / 3.0
    ///             } else {
    ///                 return length / 5.0
    ///             }
    ///         }
    ///
    @available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
    public func containerRelativeFrame(_ axes: Axis.Set, alignment: Alignment = .center) -> some View { return never() }


    /// Positions this view within an invisible frame with a size relative
    /// to the nearest container.
    ///
    /// Use the ``View/containerRelativeFrame(_:alignment:)`` modifier
    /// to specify a size for a view's width, height, or both that
    /// is dependent on the size of the nearest container. Different
    /// things can represent a "container" including:
    ///   - The window presenting a view on iPadOS or macOS, or the
    ///     screen of a device on iOS.
    ///   - A column of a NavigationSplitView
    ///   - A NavigationStack
    ///   - A tab of a TabView
    ///   - A scrollable view like ScrollView or List
    ///
    /// The size provided to this modifier is the size of a container like
    /// the ones listed above subtraacking any safe area insets that might
    /// be applied to that container.
    ///
    /// The following example will have each purple rectangle occupy the full
    /// size of the screen on iOS:
    ///
    ///     ScrollView(.horizontal) {
    ///         LazyHStack(spacing: 0.0) {
    ///             ForEach(items) { item in
    ///                 Rectangle()
    ///                     .fill(.purple)
    ///                     .containerRelativeFrame([.horizontal, .vertical])
    ///             }
    ///         }
    ///     }
    ///
    /// Use this modifier to size a view such that multiple views will be
    /// visible in the container. When using this modifier, the count refers
    /// to the total number of rows or columns that the length of the
    /// container size in a particular axis should be divided into. The span
    /// refers to the number of rows or columns that the modified view
    /// should actually occupy. Thus the size of the element can be
    /// described like so:
    ///
    ///     let availableWidth = (containerWidth - (spacing * (count - 1)))
    ///     let columnWidth = (availableWidth / count)
    ///     let itemWidth = (columnWidth * span) + ((span - 1) * spacing)
    ///
    /// The following example only uses the nearest container size in the
    /// horizontal axis, allowing the vertical axis to be determined using
    /// the ``View/aspectRatio(_:contentMode:)-771ow`` modifier.
    ///
    ///     ScrollView(.horizontal) {
    ///         LazyHStack(spacing: 10.0) {
    ///             ForEach(items) { item in
    ///                 Rectangle()
    ///                     .fill(.purple)
    ///                     .aspectRatio(3.0 / 2.0, contentMode: .fit)
    ///                     .containerRelativeFrame(
    ///                         .horizontal, count: 4, span: 3, spacing: 10.0)
    ///             }
    ///         }
    ///     }
    ///     .safeAreaPadding(.horizontal, 20.0)
    ///
    /// Use the ``View/containerRelativeFrame(_:alignment:_:)``
    /// modifier to apply your own custom logic to adjust the size
    /// of the nearest container for your view. The following example will
    /// result in the container frame's width being divided by 3 and using
    /// that value as the width of the purple rectangle.
    ///
    ///     Rectangle()
    ///         .fill(.purple)
    ///         .aspectRatio(1.0, contentMode: .fill)
    ///         .containerRelativeFrame(
    ///             .horizontal, alignment: .topLeading
    ///         ) { length, axis in
    ///             if axis == .vertical {
    ///                 return length / 3.0
    ///             } else {
    ///                 return length / 5.0
    ///             }
    ///         }
    ///
    @available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
    public func containerRelativeFrame(_ axes: Axis.Set, count: Int, span: Int = 1, spacing: CGFloat, alignment: Alignment = .center) -> some View { return never() }


    /// Positions this view within an invisible frame with a size relative
    /// to the nearest container.
    ///
    /// Use the ``View/containerRelativeFrame(_:alignment:)`` modifier
    /// to specify a size for a view's width, height, or both that
    /// is dependent on the size of the nearest container. Different
    /// things can represent a "container" including:
    ///   - The window presenting a view on iPadOS or macOS, or the
    ///     screen of a device on iOS.
    ///   - A column of a NavigationSplitView
    ///   - A NavigationStack
    ///   - A tab of a TabView
    ///   - A scrollable view like ScrollView or List
    ///
    /// The size provided to this modifier is the size of a container like
    /// the ones listed above subtraacking any safe area insets that might
    /// be applied to that container.
    ///
    /// The following example will have each purple rectangle occupy the full
    /// size of the screen on iOS:
    ///
    ///     ScrollView(.horizontal) {
    ///         LazyHStack(spacing: 0.0) {
    ///             ForEach(items) { item in
    ///                 Rectangle()
    ///                     .fill(.purple)
    ///                     .containerRelativeFrame([.horizontal, .vertical])
    ///             }
    ///         }
    ///     }
    ///
    /// Use the ``View/containerRelativeFrame(_:count:spacing:alignment:)``
    /// modifier to size a view such that multiple views will be
    /// visible in the container. When using this modifier, the count
    /// refers to the total number of rows or columns that the length of
    /// the container size in a particular axis should be divided into.
    /// The span refers to the number of rows or columns that the modified
    /// view should actually occupy. Thus the size of the element can
    /// be described like so:
    ///
    ///     let availableWidth = (containerWidth - (spacing * (count - 1)))
    ///     let columnWidth = (availableWidth / count)
    ///     let itemWidth = (columnWidth * span) + ((span - 1) * spacing)
    ///
    /// The following example only uses the nearest container size in the
    /// horizontal axis, allowing the vertical axis to be determined using
    /// the ``View/aspectRatio(_:contentMode:)-771ow`` modifier.
    ///
    ///     ScrollView(.horizontal) {
    ///         LazyHStack(spacing: 10.0) {
    ///             ForEach(items) { item in
    ///                 Rectangle()
    ///                     .fill(.purple)
    ///                     .aspectRatio(3.0 / 2.0, contentMode: .fit)
    ///                     .containerRelativeFrame(
    ///                         .horizontal, count: 4, span: 3, spacing: 10.0)
    ///             }
    ///         }
    ///     }
    ///     .safeAreaPadding(.horizontal, 20.0)
    ///
    /// Use this modifier to apply your own custom logic to adjust the size
    /// of the nearest container for your view. The following example will
    /// result in the container frame's width being divided by 3 and using
    /// that value as the width of the purple rectangle.
    ///
    ///     Rectangle()
    ///         .fill(.purple)
    ///         .aspectRatio(1.0, contentMode: .fill)
    ///         .containerRelativeFrame(
    ///             .horizontal, alignment: .topLeading
    ///         ) { length, axis in
    ///             if axis == .vertical {
    ///                 return length / 3.0
    ///             } else {
    ///                 return length / 5.0
    ///             }
    ///         }
    ///
    @available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
    public func containerRelativeFrame(_ axes: Axis.Set, alignment: Alignment = .center, _ length: @escaping (CGFloat, Axis) -> CGFloat) -> some View { return never() }

}

@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
extension View {

    /// Reads the specified preference value from the view, using it to
    /// produce a second view that is applied as an overlay to the
    /// original view.
    ///
    /// The values of the preference key from both views
    /// are combined and made visible to the parent view.
    ///
    /// - Parameters:
    ///   - key: The preference key type whose value is to be read.
    ///   - alignment: An optional alignment to use when positioning the
    ///     overlay view relative to the original view.
    ///   - transform: A function that produces the overlay view from
    ///     the preference value read from the original view.
    ///
    /// - Returns: A view that layers a second view in front of the view.
    @inlinable public func overlayPreferenceValue<K, V>(_ key: K.Type, alignment: Alignment = .center, @ViewBuilder _ transform: @escaping (K.Value) -> V) -> some View where K : PreferenceKey, V : View { return never() }


    /// Reads the specified preference value from the view, using it to
    /// produce a second view that is applied as the background of the
    /// original view.
    ///
    /// The values of the preference key from both views
    /// are combined and made visible to the parent view.
    ///
    /// - Parameters:
    ///   - key: The preference key type whose value is to be read.
    ///   - alignment: An optional alignment to use when positioning the
    ///     background view relative to the original view.
    ///   - transform: A function that produces the background view from
    ///     the preference value read from the original view.
    ///
    /// - Returns: A view that layers a second view behind the view.
    @inlinable public func backgroundPreferenceValue<K, V>(_ key: K.Type, alignment: Alignment = .center, @ViewBuilder _ transform: @escaping (K.Value) -> V) -> some View where K : PreferenceKey, V : View { return never() }

}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension View {

    /// Reads the specified preference value from the view, using it to
    /// produce a second view that is applied as an overlay to the
    /// original view.
    ///
    /// - Parameters:
    ///   - key: The preference key type whose value is to be read.
    ///   - transform: A function that produces the overlay view from
    ///     the preference value read from the original view.
    ///
    /// - Returns: A view that layers a second view in front of the view.
    @inlinable public func overlayPreferenceValue<Key, T>(_ key: Key.Type = Key.self, @ViewBuilder _ transform: @escaping (Key.Value) -> T) -> some View where Key : PreferenceKey, T : View { return never() }


    /// Reads the specified preference value from the view, using it to
    /// produce a second view that is applied as the background of the
    /// original view.
    ///
    /// - Parameters:
    ///   - key: The preference key type whose value is to be read.
    ///   - transform: A function that produces the background view from
    ///     the preference value read from the original view.
    ///
    /// - Returns: A view that layers a second view behind the view.
    @inlinable public func backgroundPreferenceValue<Key, T>(_ key: Key.Type = Key.self, @ViewBuilder _ transform: @escaping (Key.Value) -> T) -> some View where Key : PreferenceKey, T : View { return never() }

}

@available(iOS 13.0, macOS 10.15, watchOS 10.0, *)
@available(tvOS, unavailable)
extension View {

    /// Sets the style for date pickers within this view.
    @available(watchOS 10.0, *)
    @available(tvOS, unavailable)
    public func datePickerStyle<S>(_ style: S) -> some View where S : DatePickerStyle { return never() }

}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension View {

    /// Presents a sheet using the given item as a data source
    /// for the sheet's content.
    ///
    /// Use this method when you need to present a modal view with content
    /// from a custom data source. The example below shows a custom data source
    /// `InventoryItem` that the `content` closure uses to populate the display
    /// the action sheet shows to the user:
    ///
    ///     struct ShowPartDetail: View {
    ///         @State private var sheetDetail: InventoryItem?
    ///
    ///         var body: some View {
    ///             Button("Show Part Details") {
    ///                 sheetDetail = InventoryItem(
    ///                     id: "0123456789",
    ///                     partNumber: "Z-1234A",
    ///                     quantity: 100,
    ///                     name: "Widget")
    ///             }
    ///             .sheet(item: $sheetDetail,
    ///                    onDismiss: didDismiss) { detail in
    ///                 VStack(alignment: .leading, spacing: 20) {
    ///                     Text("Part Number: \(detail.partNumber)")
    ///                     Text("Name: \(detail.name)")
    ///                     Text("Quantity On-Hand: \(detail.quantity)")
    ///                 }
    ///                 .onTapGesture {
    ///                     sheetDetail = nil
    ///                 }
    ///             }
    ///         }
    ///
    ///         func didDismiss() {
    ///             // Handle the dismissing action.
    ///         }
    ///     }
    ///
    ///     struct InventoryItem: Identifiable {
    ///         var id: String
    ///         let partNumber: String
    ///         let quantity: Int
    ///         let name: String
    ///     }
    ///
    /// ![A view showing a custom structure acting as a data source, providing
    /// data to a modal sheet.](SkipUI-View-SheetItemContent.png)
    ///
    /// In vertically compact environments, such as iPhone in landscape
    /// orientation, a sheet presentation automatically adapts to appear as a
    /// full-screen cover. Use the ``View/presentationCompactAdaptation(_:)`` or
    /// ``View/presentationCompactAdaptation(horizontal:vertical:)`` modifier to
    /// override this behavior.
    ///
    /// - Parameters:
    ///   - item: A binding to an optional source of truth for the sheet.
    ///     When `item` is non-`nil`, the system passes the item's content to
    ///     the modifier's closure. You display this content in a sheet that you
    ///     create that the system displays to the user. If `item` changes,
    ///     the system dismisses the sheet and replaces it with a new one
    ///     using the same process.
    ///   - onDismiss: The closure to execute when dismissing the sheet.
    ///   - content: A closure returning the content of the sheet.
    public func sheet<Item, Content>(item: Binding<Item?>, onDismiss: (() -> Void)? = nil, @ViewBuilder content: @escaping (Item) -> Content) -> some View where Item : Identifiable, Content : View { return never() }


    /// Presents a sheet when a binding to a Boolean value that you
    /// provide is true.
    ///
    /// Use this method when you want to present a modal view to the
    /// user when a Boolean value you provide is true. The example
    /// below displays a modal view of the mockup for a software license
    /// agreement when the user toggles the `isShowingSheet` variable by
    /// clicking or tapping on the "Show License Agreement" button:
    ///
    ///     struct ShowLicenseAgreement: View {
    ///         @State private var isShowingSheet = false
    ///         var body: some View {
    ///             Button(action: {
    ///                 isShowingSheet.toggle()
    ///             }) {
    ///                 Text("Show License Agreement")
    ///             }
    ///             .sheet(isPresented: $isShowingSheet,
    ///                    onDismiss: didDismiss) {
    ///                 VStack {
    ///                     Text("License Agreement")
    ///                         .font(.title)
    ///                         .padding(50)
    ///                     Text("""
    ///                             Terms and conditions go here.
    ///                         """)
    ///                         .padding(50)
    ///                     Button("Dismiss",
    ///                            action: { isShowingSheet.toggle() })
    ///                 }
    ///             }
    ///         }
    ///
    ///         func didDismiss() {
    ///             // Handle the dismissing action.
    ///         }
    ///     }
    ///
    /// ![A screenshot of a full-screen modal sheet showing the mockup of a
    /// software license agreement with a Dismiss
    /// button.](SkipUI-View-SheetIsPresentingContent.png)
    ///
    /// In vertically compact environments, such as iPhone in landscape
    /// orientation, a sheet presentation automatically adapts to appear as a
    /// full-screen cover. Use the ``View/presentationCompactAdaptation(_:)`` or
    /// ``View/presentationCompactAdaptation(horizontal:vertical:)`` modifier to
    /// override this behavior.
    ///
    /// - Parameters:
    ///   - isPresented: A binding to a Boolean value that determines whether
    ///     to present the sheet that you create in the modifier's
    ///     `content` closure.
    ///   - onDismiss: The closure to execute when dismissing the sheet.
    ///   - content: A closure that returns the content of the sheet.
    public func sheet<Content>(isPresented: Binding<Bool>, onDismiss: (() -> Void)? = nil, @ViewBuilder content: @escaping () -> Content) -> some View where Content : View { return never() }

}

@available(iOS 14.0, tvOS 14.0, watchOS 7.0, *)
@available(macOS, unavailable)
extension View {

    /// Presents a modal view that covers as much of the screen as
    /// possible using the binding you provide as a data source for the
    /// sheet's content.
    ///
    /// Use this method to display a modal view that covers as much of the
    /// screen as possible. In the example below a custom structure —
    /// `CoverData` — provides data for the full-screen view to display in the
    /// `content` closure when the user clicks or taps the
    /// "Present Full-Screen Cover With Data" button:
    ///
    ///     struct FullScreenCoverItemOnDismissContent: View {
    ///         @State private var coverData: CoverData?
    ///
    ///         var body: some View {
    ///             Button("Present Full-Screen Cover With Data") {
    ///                 coverData = CoverData(body: "Custom Data")
    ///             }
    ///             .fullScreenCover(item: $coverData,
    ///                              onDismiss: didDismiss) { details in
    ///                 VStack(spacing: 20) {
    ///                     Text("\(details.body)")
    ///                 }
    ///                 .onTapGesture {
    ///                     coverData = nil
    ///                 }
    ///             }
    ///         }
    ///
    ///         func didDismiss() {
    ///             // Handle the dismissing action.
    ///         }
    ///
    ///     }
    ///
    ///     struct CoverData: Identifiable {
    ///         var id: String {
    ///             return body
    ///         }
    ///         let body: String
    ///     }
    ///
    /// ![A full-screen modal view that shows Custom
    /// Content.](SkipUI-FullScreenCoverItemOnDismissContent.png)
    ///
    /// - Parameters:
    ///   - item: A binding to an optional source of truth for the sheet.
    ///     When `item` is non-`nil`, the system passes the contents to
    ///     the modifier's closure. You display this content in a sheet that you
    ///     create that the system displays to the user. If `item` changes,
    ///     the system dismisses the currently displayed sheet and replaces
    ///     it with a new one using the same process.
    ///   - onDismiss: The closure to execute when dismissing the modal view.
    ///   - content: A closure returning the content of the modal view.
    public func fullScreenCover<Item, Content>(item: Binding<Item?>, onDismiss: (() -> Void)? = nil, @ViewBuilder content: @escaping (Item) -> Content) -> some View where Item : Identifiable, Content : View { return never() }


    /// Presents a modal view that covers as much of the screen as
    /// possible when binding to a Boolean value you provide is true.
    ///
    /// Use this method to show a modal view that covers as much of the screen
    /// as possible. The example below displays a custom view when the user
    /// toggles the value of the `isPresenting` binding:
    ///
    ///     struct FullScreenCoverPresentedOnDismiss: View {
    ///         @State private var isPresenting = false
    ///         var body: some View {
    ///             Button("Present Full-Screen Cover") {
    ///                 isPresenting.toggle()
    ///             }
    ///             .fullScreenCover(isPresented: $isPresenting,
    ///                              onDismiss: didDismiss) {
    ///                 VStack {
    ///                     Text("A full-screen modal view.")
    ///                         .font(.title)
    ///                     Text("Tap to Dismiss")
    ///                 }
    ///                 .onTapGesture {
    ///                     isPresenting.toggle()
    ///                 }
    ///                 .foregroundColor(.white)
    ///                 .frame(maxWidth: .infinity,
    ///                        maxHeight: .infinity)
    ///                 .background(Color.blue)
    ///                 .ignoresSafeArea(edges: .all)
    ///             }
    ///         }
    ///
    ///         func didDismiss() {
    ///             // Handle the dismissing action.
    ///         }
    ///     }
    ///
    /// ![A full-screen modal view with the text A full-screen modal view
    /// and Tap to Dismiss.](SkipUI-FullScreenCoverIsPresented.png)
    /// - Parameters:
    ///   - isPresented: A binding to a Boolean value that determines whether
    ///     to present the sheet.
    ///   - onDismiss: The closure to execute when dismissing the modal view.
    ///   - content: A closure that returns the content of the modal view.
    public func fullScreenCover<Content>(isPresented: Binding<Bool>, onDismiss: (() -> Void)? = nil, @ViewBuilder content: @escaping () -> Content) -> some View where Content : View { return never() }

}

@available(iOS 13.0, macOS 10.15, watchOS 6.0, tvOS 14.0, *)
extension View {

    /// Adds an action to perform when this view recognizes a long press
    /// gesture.
    ///
    /// - Parameters:
    ///     - minimumDuration: The minimum duration of the long press that must
    ///     elapse before the gesture succeeds.
    ///     - maximumDistance: The maximum distance that the fingers or cursor
    ///     performing the long press can move before the gesture fails.
    ///     - action: The action to perform when a long press is recognized.
    ///     - onPressingChanged:  A closure to run when the pressing state of the
    ///     gesture changes, passing the current state as a parameter.
    @available(tvOS, unavailable)
    public func onLongPressGesture(minimumDuration: Double = 0.5, maximumDistance: CGFloat = 10, perform action: @escaping () -> Void, onPressingChanged: ((Bool) -> Void)? = nil) -> some View { return never() }

}

@available(iOS 13.0, macOS 10.15, watchOS 6.0, tvOS 14.0, *)
extension View {

    /// Adds an action to perform when this view recognizes a long press
    /// gesture.
    @available(iOS, deprecated: 100000.0, renamed: "onLongPressGesture(minimumDuration:maximumDuration:perform:onPressingChanged:)")
    @available(macOS, deprecated: 100000.0, renamed: "onLongPressGesture(minimumDuration:maximumDuration:perform:onPressingChanged:)")
    @available(tvOS, unavailable)
    @available(watchOS, deprecated: 100000.0, renamed: "onLongPressGesture(minimumDuration:maximumDuration:perform:onPressingChanged:)")
    @available(xrOS, deprecated: 100000.0, renamed: "onLongPressGesture(minimumDuration:maximumDuration:perform:onPressingChanged:)")
    public func onLongPressGesture(minimumDuration: Double = 0.5, maximumDistance: CGFloat = 10, pressing: ((Bool) -> Void)? = nil, perform action: @escaping () -> Void) -> some View { return never() }

}

extension View {

    /// Sets whether to disable autocorrection for this view.
    ///
    /// Use this method when the effect of autocorrection would
    /// make it more difficult for the user to input information. The entry of
    /// proper names and street addresses are examples where autocorrection can
    /// negatively affect the user's ability complete a data entry task.
    ///
    /// The example below configures a ``TextField`` with the default
    /// keyboard. Disabling autocorrection allows the user to enter arbitrary
    /// text without the autocorrection system offering suggestions or
    /// attempting to override their input.
    ///
    ///     TextField("1234 Main St.", text: $address)
    ///         .keyboardType(.default)
    ///         .autocorrectionDisabled(true)
    ///
    /// - Parameter disable: A Boolean value that indicates whether
    ///   autocorrection is disabled for this view. The default value is `true`.
    @available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 8.0, *)
    public func autocorrectionDisabled(_ disable: Bool = true) -> some View { return never() }

}

extension View {

    /// Sets whether to disable autocorrection for this view.
    ///
    /// Use `disableAutocorrection(_:)` when the effect of autocorrection would
    /// make it more difficult for the user to input information. The entry of
    /// proper names and street addresses are examples where autocorrection can
    /// negatively affect the user's ability complete a data entry task.
    ///
    /// In the example below configures a ``TextField`` with the `.default`
    /// keyboard. Disabling autocorrection allows the user to enter arbitrary
    /// text without the autocorrection system offering suggestions or
    /// attempting to override their input.
    ///
    ///     TextField("1234 Main St.", text: $address)
    ///         .keyboardType(.default)
    ///         .disableAutocorrection(true)
    ///
    /// - Parameter enabled: A Boolean value that indicates whether
    ///   autocorrection is disabled for this view.
    @available(iOS, introduced: 13.0, deprecated: 100000.0, renamed: "autocorrectionDisabled(_:)")
    @available(macOS, introduced: 10.15, deprecated: 100000.0, renamed: "autocorrectionDisabled(_:)")
    @available(tvOS, introduced: 13.0, deprecated: 100000.0, renamed: "autocorrectionDisabled(_:)")
    @available(watchOS, introduced: 8.0, deprecated: 100000.0, renamed: "autocorrectionDisabled(_:)")
    @available(xrOS, introduced: 1.0, deprecated: 100000.0, renamed: "autocorrectionDisabled(_:)")
    public func disableAutocorrection(_ disable: Bool?) -> some View { return never() }

}

@available(iOS 14.0, tvOS 14.0, watchOS 8.0, *)
@available(macOS, unavailable)
extension View {

    /// Sets the style for the index view within the current environment.
    ///
    /// - Parameter style: The style to apply to this view.
    public func indexViewStyle<S>(_ style: S) -> some View where S : IndexViewStyle { return never() }

}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
extension View {

    /// Marks the view as containing sensitive, private user data.
    ///
    /// SkipUI redacts views marked with this modifier when you apply the
    /// ``RedactionReasons/privacy`` redaction reason.
    ///
    ///     struct BankAccountView: View {
    ///         var body: some View {
    ///             VStack {
    ///                 Text("Account #")
    ///
    ///                 Text(accountNumber)
    ///                     .font(.headline)
    ///                     .privacySensitive() // Hide only the account number.
    ///             }
    ///         }
    ///     }
    public func privacySensitive(_ sensitive: Bool = true) -> some View { return never() }

}

@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
extension View {

    /// Sets the available detents for the enclosing sheet.
    ///
    /// By default, sheets support the ``PresentationDetent/large`` detent.
    ///
    ///     struct ContentView: View {
    ///         @State private var showSettings = false
    ///
    ///         var body: some View {
    ///             Button("View Settings") {
    ///                 showSettings = true
    ///             }
    ///             .sheet(isPresented: $showSettings) {
    ///                 SettingsView()
    ///                     .presentationDetents([.medium, .large])
    ///             }
    ///         }
    ///     }
    ///
    /// - Parameter detents: A set of supported detents for the sheet.
    ///   If you provide more that one detent, people can drag the sheet
    ///   to resize it.
    public func presentationDetents(_ detents: Set<PresentationDetent>) -> some View { return never() }


    /// Sets the available detents for the enclosing sheet, giving you
    /// programmatic control of the currently selected detent.
    ///
    /// By default, sheets support the ``PresentationDetent/large`` detent.
    ///
    ///     struct ContentView: View {
    ///         @State private var showSettings = false
    ///         @State private var settingsDetent = PresentationDetent.medium
    ///
    ///         var body: some View {
    ///             Button("View Settings") {
    ///                 showSettings = true
    ///             }
    ///             .sheet(isPresented: $showSettings) {
    ///                 SettingsView()
    ///                     .presentationDetents(
    ///                         [.medium, .large],
    ///                         selection: $settingsDetent
    ///                      )
    ///             }
    ///         }
    ///     }
    ///
    /// - Parameters:
    ///   - detents: A set of supported detents for the sheet.
    ///     If you provide more that one detent, people can drag the sheet
    ///     to resize it.
    ///   - selection: A ``Binding`` to the currently selected detent.
    ///     Ensure that the value matches one of the detents that you
    ///     provide for the `detents` parameter.
    public func presentationDetents(_ detents: Set<PresentationDetent>, selection: Binding<PresentationDetent>) -> some View { return never() }


    /// Sets the visibility of the drag indicator on top of a sheet.
    ///
    /// You can show a drag indicator when it isn't apparent that a
    /// sheet can resize or when the sheet can't dismiss interactively.
    ///
    ///     struct ContentView: View {
    ///         @State private var showSettings = false
    ///
    ///         var body: some View {
    ///             Button("View Settings") {
    ///                 showSettings = true
    ///             }
    ///             .sheet(isPresented: $showSettings) {
    ///                 SettingsView()
    ///                     .presentationDetents([.medium, .large])
    ///                     .presentationDragIndicator(.visible)
    ///             }
    ///         }
    ///     }
    ///
    /// - Parameter visibility: The preferred visibility of the drag indicator.
    public func presentationDragIndicator(_ visibility: Visibility) -> some View { return never() }

}

@available(iOS 16.4, macOS 13.3, tvOS 16.4, watchOS 9.4, *)
extension View {

    /// Controls whether people can interact with the view behind a
    /// presentation.
    ///
    /// On many platforms, SkipUI automatically disables the view behind a
    /// sheet that you present, so that people can't interact with the backing
    /// view until they dismiss the sheet. Use this modifier if you want to
    /// enable interaction.
    ///
    /// The following example enables people to interact with the view behind
    /// the sheet when the sheet is at the smallest detent, but not at the other
    /// detents:
    ///
    ///     struct ContentView: View {
    ///         @State private var showSettings = false
    ///
    ///         var body: some View {
    ///             Button("View Settings") {
    ///                 showSettings = true
    ///             }
    ///             .sheet(isPresented: $showSettings) {
    ///                 SettingsView()
    ///                     .presentationDetents(
    ///                         [.height(120), .medium, .large])
    ///                     .presentationBackgroundInteraction(
    ///                         .enabled(upThrough: .height(120)))
    ///             }
    ///         }
    ///     }
    ///
    /// - Parameters:
    ///   - interaction: A specification of how people can interact with the
    ///     view behind a presentation.
    public func presentationBackgroundInteraction(_ interaction: PresentationBackgroundInteraction) -> some View { return never() }


    /// Specifies how to adapt a presentation to compact size classes.
    ///
    /// Some presentations adapt their appearance depending on the context. For
    /// example, a sheet presentation over a vertically-compact view uses a
    /// full-screen-cover appearance by default. Use this modifier to indicate
    /// a custom adaptation preference. For example, the following code
    /// uses a presentation adaptation value of ``PresentationAdaptation/none``
    /// to request that the system not adapt the sheet in compact size classes:
    ///
    ///     struct ContentView: View {
    ///         @State private var showSettings = false
    ///
    ///         var body: some View {
    ///             Button("View Settings") {
    ///                 showSettings = true
    ///             }
    ///             .sheet(isPresented: $showSettings) {
    ///                 SettingsView()
    ///                     .presentationDetents([.medium, .large])
    ///                     .presentationCompactAdaptation(.none)
    ///             }
    ///         }
    ///     }
    ///
    /// If you want to specify different adaptations for each dimension,
    /// use the ``View/presentationCompactAdaptation(horizontal:vertical:)``
    /// method instead.
    ///
    /// - Parameter adaptation: The adaptation to use in either a horizontally
    ///   or vertically compact size class.
    public func presentationCompactAdaptation(_ adaptation: PresentationAdaptation) -> some View { return never() }


    /// Specifies how to adapt a presentation to horizontally and vertically
    /// compact size classes.
    ///
    /// Some presentations adapt their appearance depending on the context. For
    /// example, a popover presentation over a horizontally-compact view uses a
    /// sheet appearance by default. Use this modifier to indicate a custom
    /// adaptation preference.
    ///
    ///     struct ContentView: View {
    ///         @State private var showInfo = false
    ///
    ///         var body: some View {
    ///             Button("View Info") {
    ///                 showInfo = true
    ///             }
    ///             .popover(isPresented: $showInfo) {
    ///                 InfoView()
    ///                     .presentationCompactAdaptation(
    ///                         horizontal: .popover,
    ///                         vertical: .sheet)
    ///             }
    ///         }
    ///     }
    ///
    /// If you want to specify the same adaptation for both dimensions,
    /// use the ``View/presentationCompactAdaptation(_:)`` method instead.
    ///
    /// - Parameters:
    ///   - horizontalAdaptation: The adaptation to use in a horizontally
    ///     compact size class.
    ///   - verticalAdaptation: The adaptation to use in a vertically compact
    ///     size class. In a size class that is both horizontally and vertically
    ///     compact, SkipUI uses the `verticalAdaptation` value.
    public func presentationCompactAdaptation(horizontal horizontalAdaptation: PresentationAdaptation, vertical verticalAdaptation: PresentationAdaptation) -> some View { return never() }


    /// Requests that the presentation have a specific corner radius.
    ///
    /// Use this modifier to change the corner radius of a presentation.
    ///
    ///     struct ContentView: View {
    ///         @State private var showSettings = false
    ///
    ///         var body: some View {
    ///             Button("View Settings") {
    ///                 showSettings = true
    ///             }
    ///             .sheet(isPresented: $showSettings) {
    ///                 SettingsView()
    ///                     .presentationDetents([.medium, .large])
    ///                     .presentationCornerRadius(21)
    ///             }
    ///         }
    ///     }
    ///
    /// - Parameter cornerRadius: The corner radius, or `nil` to use the system
    ///   default.
    public func presentationCornerRadius(_ cornerRadius: CGFloat?) -> some View { return never() }


    /// Configures the behavior of swipe gestures on a presentation.
    ///
    /// By default, when a person swipes up on a scroll view in a resizable
    /// presentation, the presentation grows to the next detent. A scroll view
    /// embedded in the presentation only scrolls after the presentation
    /// reaches its largest size. Use this modifier to control which action
    /// takes precedence.
    ///
    /// For example, you can request that swipe gestures scroll content first,
    /// resizing the sheet only after hitting the end of the scroll view, by
    /// passing the ``PresentationContentInteraction/scrolls`` value to this
    /// modifier:
    ///
    ///     struct ContentView: View {
    ///         @State private var showSettings = false
    ///
    ///         var body: some View {
    ///             Button("View Settings") {
    ///                 showSettings = true
    ///             }
    ///             .sheet(isPresented: $showSettings) {
    ///                 SettingsView()
    ///                     .presentationDetents([.medium, .large])
    ///                     .presentationContentInteraction(.scrolls)
    ///             }
    ///         }
    ///     }
    ///
    /// People can always resize your presentation using the drag indicator.
    ///
    /// - Parameter behavior: The requested behavior.
    public func presentationContentInteraction(_ behavior: PresentationContentInteraction) -> some View { return never() }

}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension View {

    /// Adds a condition for whether the view's view hierarchy is deletable.
    @inlinable public func deleteDisabled(_ isDisabled: Bool) -> some View { return never() }

}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
extension View {

    /// Makes symbols within the view show a particular variant.
    ///
    /// When you want all the symbols
    /// in a part of your app's user interface to use the same variant, use the
    /// `symbolVariant(_:)` modifier with a ``SymbolVariants`` value, like
    /// ``SymbolVariants/fill-swift.type.property``:
    ///
    ///     VStack(spacing: 20) {
    ///         HStack(spacing: 20) {
    ///             Image(systemName: "person")
    ///             Image(systemName: "folder")
    ///             Image(systemName: "gearshape")
    ///             Image(systemName: "list.bullet")
    ///         }
    ///
    ///         HStack(spacing: 20) {
    ///             Image(systemName: "person")
    ///             Image(systemName: "folder")
    ///             Image(systemName: "gearshape")
    ///             Image(systemName: "list.bullet")
    ///         }
    ///         .symbolVariant(.fill) // Shows filled variants, when available.
    ///     }
    ///
    /// A symbol that doesn't have the specified variant remains unaffected.
    /// In the example above, the `list.bullet` symbol doesn't have a filled
    /// variant, so the `symbolVariant(_:)` modifer has no effect.
    ///
    /// ![A screenshot showing two rows of four symbols. Both rows contain a
    /// person, a folder, a gear, and a bullet list. The symbols in the first
    /// row are outlined. The symbols in the second row are filled, except the
    /// list, which is the same in both rows.](View-symbolVariant-1)
    ///
    /// If you apply the modifier more than once, its effects accumulate.
    /// Alternatively, you can apply multiple variants in one call:
    ///
    ///     Label("Airplane", systemImage: "airplane.circle.fill")
    ///
    ///     Label("Airplane", systemImage: "airplane")
    ///         .symbolVariant(.circle)
    ///         .symbolVariant(.fill)
    ///
    ///     Label("Airplane", systemImage: "airplane")
    ///         .symbolVariant(.circle.fill)
    ///
    /// All of the labels in the code above produce the same output:
    ///
    /// ![A screenshot of a label that shows an airplane in a filled circle
    /// beside the word Airplane.](View-symbolVariant-2)
    ///
    /// You can apply all these variants in any order, but
    /// if you apply more than one shape variant, the one closest to the
    /// symbol takes precedence. For example, the following image uses the
    /// ``SymbolVariants/square-swift.type.property`` shape:
    ///
    ///     Image(systemName: "arrow.left")
    ///         .symbolVariant(.square) // This shape takes precedence.
    ///         .symbolVariant(.circle)
    ///         .symbolVariant(.fill)
    ///
    /// ![A screenshot of a left arrow symbol in a filled
    /// square.](View-symbolVariant-3)
    ///
    /// To cause a symbol to ignore the variants currently in the environment,
    /// directly set the ``EnvironmentValues/symbolVariants`` environment value
    /// to ``SymbolVariants/none`` using the ``View/environment(_:_:)`` modifer.
    ///
    /// - Parameter variant: The variant to use for symbols. Use the values in
    ///   ``SymbolVariants``.
    /// - Returns: A view that applies the specified symbol variant or variants
    ///   to itself and its child views.
    public func symbolVariant(_ variant: SymbolVariants) -> some View { return never() }

}

@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
extension View {

    /// Associates a destination view with a presented data type for use within
    /// a navigation stack.
    ///
    /// Add this view modifer to a view inside a ``NavigationStack`` to
    /// describe the view that the stack displays when presenting
    /// a particular kind of data. Use a ``NavigationLink`` to present
    /// the data. For example, you can present a `ColorDetail` view for
    /// each presentation of a ``Color`` instance:
    ///
    ///     NavigationStack {
    ///         List {
    ///             NavigationLink("Mint", value: Color.mint)
    ///             NavigationLink("Pink", value: Color.pink)
    ///             NavigationLink("Teal", value: Color.teal)
    ///         }
    ///         .navigationDestination(for: Color.self) { color in
    ///             ColorDetail(color: color)
    ///         }
    ///         .navigationTitle("Colors")
    ///     }
    ///
    /// You can add more than one navigation destination modifier to the stack
    /// if it needs to present more than one kind of data.
    ///
    /// Do not put a navigation destination modifier inside a "lazy" container,
    /// like ``List`` or ``LazyVStack``. These containers create child views
    /// only when needed to render on screen. Add the navigation destination
    /// modifier outside these containers so that the navigation stack can
    /// always see the destination.
    ///
    /// - Parameters:
    ///   - data: The type of data that this destination matches.
    ///   - destination: A view builder that defines a view to display
    ///     when the stack's navigation state contains a value of
    ///     type `data`. The closure takes one argument, which is the value
    ///     of the data to present.
    public func navigationDestination<D, C>(for data: D.Type, @ViewBuilder destination: @escaping (D) -> C) -> some View where D : Hashable, C : View { return never() }


    /// Associates a destination view with a binding that can be used to push
    /// the view onto a ``NavigationStack``.
    ///
    /// In general, favor binding a path to a navigation stack for programmatic
    /// navigation. Add this view modifer to a view inside a ``NavigationStack``
    /// to programmatically push a single view onto the stack. This is useful
    /// for building components that can push an associated view. For example,
    /// you can present a `ColorDetail` view for a particular color:
    ///
    ///     @State private var showDetails = false
    ///     var favoriteColor: Color
    ///
    ///     NavigationStack {
    ///         VStack {
    ///             Circle()
    ///                 .fill(favoriteColor)
    ///             Button("Show details") {
    ///                 showDetails = true
    ///             }
    ///         }
    ///         .navigationDestination(isPresented: $showDetails) {
    ///             ColorDetail(color: favoriteColor)
    ///         }
    ///         .navigationTitle("My Favorite Color")
    ///     }
    ///
    /// Do not put a navigation destination modifier inside a "lazy" container,
    /// like ``List`` or ``LazyVStack``. These containers create child views
    /// only when needed to render on screen. Add the navigation destination
    /// modifier outside these containers so that the navigation stack can
    /// always see the destination.
    ///
    /// - Parameters:
    ///   - isPresented: A binding to a Boolean value that indicates whether
    ///     `destination` is currently presented.
    ///   - destination: A view to present.
    public func navigationDestination<V>(isPresented: Binding<Bool>, @ViewBuilder destination: () -> V) -> some View where V : View { return never() }

}

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension View {

    /// Associates a destination view with a bound value for use within a
    /// navigation stack or navigation split view
    ///
    /// Add this view modifer to a view inside a ``NavigationStack`` or
    /// ``NavigationSplitView`` to describe the view that the stack displays
    /// when presenting a particular kind of data. Use a ``NavigationLink`` to
    /// present the data, which updates the binding. Programmatically update
    /// the binding to display or remove the view. For example, you can replace
    /// the view showing in the detail column of a navigation split view:
    ///
    ///     @State private var colorShown: Color?
    ///
    ///     NavigationSplitView {
    ///         List {
    ///             NavigationLink("Mint", value: Color.mint)
    ///             NavigationLink("Pink", value: Color.pink)
    ///             NavigationLink("Teal", value: Color.teal)
    ///         }
    ///         .navigationDestination(item: $colorShown) { color in
    ///             ColorDetail(color: color)
    ///         }
    ///     } detail: {
    ///         Text("Select a color")
    ///     }
    ///
    /// When the person using the app taps on the Mint link, the mint color
    /// shows in the detail and `colorShown` gets the value `Color.mint`. You
    /// can reset the navigation split view to show the message "Select a color"
    /// by setting `colorShown` back to `nil`.
    ///
    /// You can add more than one navigation destination modifier to the stack
    /// if it needs to present more than one kind of data.
    ///
    /// Do not put a navigation destination modifier inside a "lazy" container,
    /// like ``List`` or ``LazyVStack``. These containers create child views
    /// only when needed to render on screen. Add the navigation destination
    /// modifier outside these containers so that the navigation split view can
    /// always see the destination.
    ///
    /// - Parameters:
    ///   - item: A binding to the data presented, or `nil` if nothing is
    ///     currently presented.
    ///   - destination: A view builder that defines a view to display
    ///     when `item` is not `nil`.
    public func navigationDestination<D, C>(item: Binding<D?>, @ViewBuilder destination: @escaping (D) -> C) -> some View where D : Hashable, C : View { return never() }

}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension View {

    /// Adds a condition for whether the view's view hierarchy is movable.
    @inlinable public func moveDisabled(_ isDisabled: Bool) -> some View { return never() }

}

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension View {

    /// Plays the given keyframes when the given trigger value changes, updating
    /// the view using the modifiers you apply in `body`.
    ///
    /// Note that the `content` closure will be updated on every frame while
    /// animating, so avoid performing any expensive operations directly within
    /// `content`.
    ///
    /// If the trigger value changes while animating, the `keyframes` closure
    /// will be called with the current interpolated value, and the keyframes
    /// that you return define a new animation that replaces the old one. The
    /// previous velocity will be preserved, so cubic or spring keyframes will
    /// maintain continuity from the previous animation if they do not specify
    /// a custom initial velocity.
    ///
    /// When a keyframe animation finishes, the animator will remain at the
    /// end value, which becomes the initial value for the next animation.
    ///
    /// - Parameters:
    ///   - initialValue: The initial value that the keyframes will animate
    ///     from.
    ///   - trigger: A value to observe for changes.
    ///   - content: A view builder closure that takes two parameters. The first
    ///     parameter is a proxy value representing the modified view. The
    ///     second parameter is the interpolated value generated by the
    ///     keyframes.
    ///   - keyframes: Keyframes defining how the value changes over time. The
    ///     current value of the animator is the single argument, which is
    ///     equal to `initialValue` when the view first appears, then is equal
    ///     to the end value of the previous keyframe animation on subsequent
    ///     calls.
    public func keyframeAnimator<Value>(initialValue: Value, trigger: some Equatable, @ViewBuilder content: @escaping @Sendable (PlaceholderContentView<Self>, Value) -> some View, @KeyframesBuilder<Value> keyframes: @escaping (Value) -> some Keyframes) -> some View { return never() }


    /// Loops the given keyframes continuously, updating
    /// the view using the modifiers you apply in `body`.
    ///
    /// Note that the `content` closure will be updated on every frame while
    /// animating, so avoid performing any expensive operations directly within
    /// `content`.
    ///
    /// - Parameters:
    ///   - initialValue: The initial value that the keyframes will animate
    ///     from.
    ///   - repeating: Whether the keyframes are currently repeating. If false,
    ///     the value at the beginning of the keyframe timeline will be
    ///     provided to the content closure.
    ///   - content: A view builder closure that takes two parameters. The first
    ///     parameter is a proxy value representing the modified view. The
    ///     second parameter is the interpolated value generated by the
    ///     keyframes.
    ///   - keyframes: Keyframes defining how the value changes over time. The
    ///     current value of the animator is the single argument, which is
    ///     equal to `initialValue` when the view first appears, then is equal
    ///     to the end value of the previous keyframe animation on subsequent
    ///     calls.
    public func keyframeAnimator<Value>(initialValue: Value, repeating: Bool = true, @ViewBuilder content: @escaping @Sendable (PlaceholderContentView<Self>, Value) -> some View, @KeyframesBuilder<Value> keyframes: @escaping (Value) -> some Keyframes) -> some View { return never() }

}

@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
extension View {

    /// Creates a new view that exposes the provided object to other views whose
    /// whose state depends on the focused view hierarchy.
    ///
    /// Use this method instead of ``View/focusedSceneObject(_:)`` when your
    /// scene includes multiple focusable views with their own associated data,
    /// and you need an app- or scene-scoped element like a command or toolbar
    /// item that operates on the data associated with whichever view currently
    /// has focus. Each focusable view can supply its own object:
    ///
    ///     struct MessageView: View {
    ///         @StateObject private var message = Message(...)
    ///
    ///         var body: some View {
    ///             TextField(...)
    ///                 .focusedObject(message)
    ///         }
    ///     }
    ///
    /// Interested views can then use the ``FocusedObject`` property wrapper to
    /// observe and update the focused view's object. In this example, an app
    /// command updates the focused view's data, and is automatically disabled
    /// when focus is in an unrelated part of the scene:
    ///
    ///     struct MessageCommands: Commands {
    ///         @FocusedObject private var message: Message?
    ///
    ///         var body: some Commands {
    ///             CommandGroup(after: .pasteboard) {
    ///                 Button("Add Duck to Message") {
    ///                     message?.text.append(" 🦆")
    ///                 }
    ///                 .keyboardShortcut("d")
    ///                 .disabled(message == nil)
    ///             }
    ///         }
    ///     }
    ///
    /// - Parameters:
    ///   - object: The observable object to associate with focus.
    /// - Returns: A view that supplies an observable object when in focus.
    @inlinable public func focusedObject<T>(_ object: T) -> some View where T : ObservableObject { return never() }


    /// Creates a new view that exposes the provided object to other views whose
    /// state depends on the focused view hierarchy.
    ///
    /// Use this method instead of ``View/focusedSceneObject(_:)`` when your
    /// scene includes multiple focusable views with their own associated data,
    /// and you need an app- or scene-scoped element like a command or toolbar
    /// item that operates on the data associated with whichever view currently
    /// has focus. Each focusable view can supply its own object:
    ///
    ///     struct MessageView: View {
    ///         @StateObject private var message = Message(...)
    ///
    ///         var body: some View {
    ///             TextField(...)
    ///                 .focusedObject(message)
    ///         }
    ///     }
    ///
    /// Interested views can then use the ``FocusedObject`` property wrapper to
    /// observe and update the focused view's object. In this example, an app
    /// command updates the focused view's data, and is automatically disabled
    /// when focus is in an unrelated part of the scene:
    ///
    ///     struct MessageCommands: Commands {
    ///         @FocusedObject private var message: Message?
    ///
    ///         var body: some Commands {
    ///             CommandGroup(after: .pasteboard) {
    ///                 Button("Add Duck to Message") {
    ///                     message?.text.append(" 🦆")
    ///                 }
    ///                 .keyboardShortcut("d")
    ///                 .disabled(message == nil)
    ///             }
    ///         }
    ///     }
    ///
    /// - Parameters:
    ///   - object: The observable object to associate with focus, or `nil` if
    ///     no object is currently available.
    /// - Returns: A view that supplies an observable object when in focus.
    @inlinable public func focusedObject<T>(_ object: T?) -> some View where T : ObservableObject { return never() }


    /// Creates a new view that exposes the provided object to other views whose
    /// whose state depends on the active scene.
    ///
    /// Use this method instead of ``View/focusedObject(_:)`` for observable
    /// objects that must be visible regardless of where focus is located in the
    /// active scene. This is sometimes needed for things like main menu and
    /// discoverability HUD commands that observe and update data from the
    /// active scene but aren't concerned with what the user is actually focused
    /// on. The scene's root view can supply the scene's state object:
    ///
    ///     struct RootView: View {
    ///         @StateObject private var sceneData = SceneData()
    ///
    ///         var body: some View {
    ///             NavigationSplitView {
    ///                 ...
    ///             }
    ///             .focusedSceneObject(sceneData)
    ///         }
    ///     }
    ///
    /// Interested views can then use the ``FocusedObject`` property wrapper to
    /// observe and update the active scene's state object. In this example, an
    /// app command updates the active scene's data, and is enabled as long as
    /// any scene is active.
    ///
    ///     struct MessageCommands: Commands {
    ///         @FocusedObject private var sceneData: SceneData?
    ///
    ///         var body: some Commands {
    ///             CommandGroup(after: .newItem) {
    ///                 Button("New Message") {
    ///                     sceneData?.addMessage()
    ///                 }
    ///                 .keyboardShortcut("n", modifiers: [.option, .command])
    ///                 .disabled(sceneData == nil)
    ///             }
    ///         }
    ///     }
    ///
    /// - Parameters:
    ///   - object: The observable object to associate with the scene.
    /// - Returns: A view that supplies an observable object while the scene
    ///   is active.
    @inlinable public func focusedSceneObject<T>(_ object: T) -> some View where T : ObservableObject { return never() }


    /// Creates a new view that exposes the provided object to other views whose
    /// whose state depends on the active scene.
    ///
    /// Use this method instead of ``View/focusedObject(_:)`` for observable
    /// objects that must be visible regardless of where focus is located in the
    /// active scene. This is sometimes needed for things like main menu and
    /// discoverability HUD commands that observe and update data from the
    /// active scene but aren't concerned with what the user is actually focused
    /// on. The scene's root view can supply the scene's state object:
    ///
    ///     struct RootView: View {
    ///         @StateObject private var sceneData = SceneData()
    ///
    ///         var body: some View {
    ///             NavigationSplitView {
    ///                 ...
    ///             }
    ///             .focusedSceneObject(sceneData)
    ///         }
    ///     }
    ///
    /// Interested views can then use the ``FocusedObject`` property wrapper to
    /// observe and update the active scene's state object. In this example, an
    /// app command updates the active scene's data, and is enabled as long as
    /// any scene is active.
    ///
    ///     struct MessageCommands: Commands {
    ///         @FocusedObject private var sceneData: SceneData?
    ///
    ///         var body: some Commands {
    ///             CommandGroup(after: .newItem) {
    ///                 Button("New Message") {
    ///                     sceneData?.addMessage()
    ///                 }
    ///                 .keyboardShortcut("n", modifiers: [.option, .command])
    ///                 .disabled(sceneData == nil)
    ///             }
    ///         }
    ///     }
    ///
    /// - Parameters:
    ///   - object: The observable object to associate with the scene, or `nil`
    ///     if no object is currently available.
    /// - Returns: A view that supplies an observable object while the scene
    ///   is active.
    @inlinable public func focusedSceneObject<T>(_ object: T?) -> some View where T : ObservableObject { return never() }

}

@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
extension View {

    /// Tells a view that acts as a cell in a grid to span the specified
    /// number of columns.
    ///
    /// By default, each view that you put into the content closure of a
    /// ``GridRow`` corresponds to exactly one column of the grid. Apply the
    /// `gridCellColumns(_:)` modifier to a view that you want to span more
    /// than one column, as in the following example of a typical macOS
    /// configuration view:
    ///
    ///     Grid(alignment: .leadingFirstTextBaseline) {
    ///         GridRow {
    ///             Text("Regular font:")
    ///                 .gridColumnAlignment(.trailing)
    ///             Text("Helvetica 12")
    ///             Button("Select...") { }
    ///         }
    ///         GridRow {
    ///             Text("Fixed-width font:")
    ///             Text("Menlo Regular 11")
    ///             Button("Select...") { }
    ///         }
    ///         GridRow {
    ///             Color.clear
    ///                 .gridCellUnsizedAxes([.vertical, .horizontal])
    ///             Toggle("Use fixed-width font for new documents", isOn: $isOn)
    ///                 .gridCellColumns(2) // Span two columns.
    ///         }
    ///     }
    ///
    /// The ``Toggle`` in the example above spans the column that contains
    /// the font names and the column that contains the buttons:
    ///
    /// ![A screenshot of a configuration view, arranged in a grid. The grid
    /// has three colums and three rows. Scanning from top to bottom, the
    /// left-most column contains a cell with the text Regular font, a cell with
    /// the text Fixed-width font, and a blank cell. The middle row contains
    /// a cell with the text Helvetica 12, a cell with the text Menlo Regular
    /// 11, and a cell with a labeled checkbox. The label says Use fixed-width
    /// font for new documents. The label spans its own cell and the cell to
    /// its right. The right-most column contains two cells with buttons
    /// labeled Select. The last column's bottom cell is merged with the cell
    /// from the middle columnn that holds the labeled
    /// checkbox.](View-gridCellColumns-1-macOS)
    ///
    /// > Important: When you tell a cell to span multiple columns, the grid
    /// changes the merged cell to use anchor alignment, rather than the
    /// usual alignment guides. For information about the behavior of
    /// anchor alignment, see ``View/gridCellAnchor(_:)``.
    ///
    /// As a convenience you can cause a view to span all of the ``Grid``
    /// columns by placing the view directly in the content closure of the
    /// ``Grid``, outside of a ``GridRow``, and omitting the modifier. To do
    /// the opposite and include more than one view in a cell, group the views
    /// using an appropriate layout container, like an ``HStack``, so that
    /// they act as a single view.
    ///
    /// - Parameters:
    ///   - count: The number of columns that the view should consume
    ///     when placed in a grid row.
    ///
    /// - Returns: A view that occupies the specified number of columns in a
    ///   grid row.
    @inlinable public func gridCellColumns(_ count: Int) -> some View { return never() }


    /// Specifies a custom alignment anchor for a view that acts as a grid cell.
    ///
    /// Grids, like stacks and other layout containers, perform most alignment
    /// operations using alignment guides. The grid moves the contents of each
    /// cell in a row in the y direction until the specified
    /// ``VerticalAlignment`` guide of each view in the row aligns with the same
    /// guide of all the other views in the row. Similarly, the grid aligns the
    /// ``HorizontalAlignment`` guides of views in a column by adjusting views
    /// in the x direction. See the guide types for more information about
    /// typical SkipUI alignment operations.
    ///
    /// When you use the `gridCellAnchor(_:)` modifier on a
    /// view in a grid, the grid changes to an anchor-based alignment strategy
    /// for the associated cell. With anchor alignment, the grid projects a
    /// ``UnitPoint`` that you specify onto both the view and the cell, and
    /// aligns the two projections. For example, consider the following grid:
    ///
    ///     Grid(horizontalSpacing: 1, verticalSpacing: 1) {
    ///         GridRow {
    ///             Color.red.frame(width: 60, height: 60)
    ///             Color.red.frame(width: 60, height: 60)
    ///         }
    ///         GridRow {
    ///             Color.red.frame(width: 60, height: 60)
    ///             Color.blue.frame(width: 10, height: 10)
    ///                 .gridCellAnchor(UnitPoint(x: 0.25, y: 0.75))
    ///         }
    ///     }
    ///
    /// The grid creates red reference squares in the first row and column to
    /// establish row and column sizes. Without the anchor modifier, the blue
    /// marker in the remaining cell would appear at the center of its cell,
    /// because of the grid's default ``Alignment/center`` alignment. With
    /// the anchor modifier shown in the code above, the grid aligns the one
    /// quarter point of the marker with the one quarter point of its cell in
    /// the x direction, as measured from the origin at the top left of the
    /// cell. The grid also aligns the three quarters point of the marker
    /// with the three quarters point of the cell in the y direction:
    ///
    /// ![A screenshot of a grid with two rows and two columns. The cells in
    /// the top row and left-most column are each completely filled with a red
    /// rectangle. The lower-right cell contains a small blue square that's
    /// horizontally placed about one quarter of the way from the left to the
    /// right, and about three quarters of the way from the top to the
    /// bottom of the cell it occupies.](View-gridCellAnchor-1-iOS)
    ///
    /// ``UnitPoint`` defines many convenience points that correspond to the
    /// typical alignment guides, which you can use as well. For example, you
    /// can use ``UnitPoint/topTrailing`` to align the top and trailing edges
    /// of a view in a cell with the top and trailing edges of the cell:
    ///
    ///     Color.blue.frame(width: 10, height: 10)
    ///         .gridCellAnchor(.topTrailing)
    ///
    /// ![A screenshot of a grid with two rows and two columns. The cells in
    /// the top row and left-most column are each completely filled with a red
    /// rectangle. The lower-right cell contains a small blue square that's
    /// horizontally aligned with the trailing edge, and vertically aligned
    /// with the top edge of the cell.](View-gridCellAnchor-2-iOS)
    ///
    /// Applying the anchor-based alignment strategy to a single cell
    /// doesn't affect the alignment strategy that the grid uses on other cells.
    ///
    /// ### Anchor alignment for merged cells
    ///
    /// If you use the ``View/gridCellColumns(_:)`` modifier to cause
    /// a cell to span more than one column, or if you place a view in a grid
    /// outside of a row so that the view spans the entire grid, the grid
    /// automatically converts its vertical and horizontal alignment guides
    /// to the unit point equivalent for the merged cell, and uses an
    /// anchor-based approach for that cell. For example, the following grid
    /// places the marker at the center of the merged cell by converting the
    /// grid's default ``Alignment/center`` alignment guide to a
    /// ``UnitPoint/center`` anchor for the blue marker in the merged cell:
    ///
    ///     Grid(alignment: .center, horizontalSpacing: 1, verticalSpacing: 1) {
    ///         GridRow {
    ///             Color.red.frame(width: 60, height: 60)
    ///             Color.red.frame(width: 60, height: 60)
    ///             Color.red.frame(width: 60, height: 60)
    ///         }
    ///         GridRow {
    ///             Color.red.frame(width: 60, height: 60)
    ///             Color.blue.frame(width: 10, height: 10)
    ///                 .gridCellColumns(2)
    ///         }
    ///     }
    ///
    /// The grid makes this conversion in part to avoid ambiguity. Each column
    /// has its own horizontal guide, and it isn't clear which of these
    /// a cell that spans multiple columns should align with. Further, in
    /// the example above, neither of the center alignment guides for the
    /// second or third column would provide the expected behavior, which is
    /// to center the marker in the merged cell. Anchor alignment provides
    /// this behavior:
    ///
    /// ![A screenshot of a grid with two rows and three columns. The cells in
    /// the top row and left-most column are each completely filled with a red
    /// rectangle. The other two cells are meged into a single cell that
    /// contains a small blue square that's centered in the merged
    /// cell.](View-gridCellAnchor-3-iOS)
    ///
    /// - Parameters:
    ///   - anchor: The unit point that defines how to align the view
    ///     within the bounds of its grid cell.
    ///
    /// - Returns: A view that uses the specified anchor point to align its
    ///   content.
    @inlinable public func gridCellAnchor(_ anchor: UnitPoint) -> some View { return never() }


    /// Overrides the default horizontal alignment of the grid column that
    /// the view appears in.
    ///
    /// You set a default alignment for the cells in a grid in both vertical
    /// and horizontal dimensions when you create the grid with the
    /// ``Grid/init(alignment:horizontalSpacing:verticalSpacing:content:)``
    /// initializer. However, you can use the `gridColumnAlignment(_:)` modifier
    /// to override the horizontal alignment of a column within the grid. The
    /// following example sets a grid's alignment to
    /// ``Alignment/leadingFirstTextBaseline``, and then sets the first column
    /// to use ``HorizontalAlignment/trailing`` alignment:
    ///
    ///     Grid(alignment: .leadingFirstTextBaseline) {
    ///         GridRow {
    ///             Text("Regular font:")
    ///                 .gridColumnAlignment(.trailing) // Align the entire first column.
    ///             Text("Helvetica 12")
    ///             Button("Select...") { }
    ///         }
    ///         GridRow {
    ///             Text("Fixed-width font:")
    ///             Text("Menlo Regular 11")
    ///             Button("Select...") { }
    ///         }
    ///         GridRow {
    ///             Color.clear
    ///                 .gridCellUnsizedAxes([.vertical, .horizontal])
    ///             Toggle("Use fixed-width font for new documents", isOn: $isOn)
    ///                 .gridCellColumns(2)
    ///         }
    ///     }
    ///
    /// This creates the layout of a typical macOS configuration
    /// view, with the trailing edge of the first column flush with the
    /// leading edge of the second column:
    ///
    /// ![A screenshot of a configuration view, arranged in a grid. The grid
    /// has three colums and three rows. Scanning from top to bottom, the
    /// left-most column contains a cell with the text Regular font, a cell with
    /// the text Fixed-width font, and a blank cell. The middle row contains
    /// a cell with the text Helvetica 12, a cell with the text Menlo Regular
    /// 11, and a cell with a labeled checkbox. The label says Use fixed-width
    /// font for new documents. The label spans its own cell and the cell to
    /// its right. The right-most column contains two cells with buttons
    /// labeled Select. The last column's bottom cell is merged with the cell
    /// from the middle columnn that holds the labeled
    /// checkbox.](View-gridColumnAlignment-1-macOS)
    ///
    /// Add the modifier to only one cell in a column. The grid
    /// automatically aligns all cells in that column the same way.
    /// You get undefined behavior if you apply different alignments to
    /// different cells in the same column.
    ///
    /// To override row alignment, see ``GridRow/init(alignment:content:)``. To
    /// override alignment for a single cell, see ``View/gridCellAnchor(_:)``.
    ///
    /// - Parameters:
    ///   - guide: The ``HorizontalAlignment`` guide to use for the grid
    ///     column that the view appears in.
    ///
    /// - Returns: A view that uses the specified horizontal alignment, and
    ///   that causes all cells in the same column of a grid to use the
    ///   same alignment.
    @inlinable public func gridColumnAlignment(_ guide: HorizontalAlignment) -> some View { return never() }


    /// Asks grid layouts not to offer the view extra size in the specified
    /// axes.
    ///
    /// Use this modifier to prevent a flexible view from taking more space
    /// on the specified axes than the other cells in a row or column require.
    /// For example, consider the following ``Grid`` that places a ``Divider``
    /// between two rows of content:
    ///
    ///     Grid {
    ///         GridRow {
    ///             Text("Hello")
    ///             Image(systemName: "globe")
    ///         }
    ///         Divider()
    ///         GridRow {
    ///             Image(systemName: "hand.wave")
    ///             Text("World")
    ///         }
    ///     }
    ///
    /// The text and images all have ideal widths for their content. However,
    /// because a divider takes as much space as its parent offers, the grid
    /// fills the width of the display, expanding all the other cells to match:
    ///
    /// ![A screenshot of items arranged in a grid. The upper-left
    /// cell in the grid contains the word hello. The upper-right contains
    /// an image of a globe. The lower-left contains an image of a waving hand.
    /// The lower-right contains the word world. A dividing line that spans
    /// the width of the grid separates the upper and lower elements. The grid's
    /// rows have minimal vertical spacing, but it's columns have a lot of
    /// horizontal spacing, with column content centered
    /// horizontally.](View-gridCellUnsizedAxes-1-iOS)
    ///
    /// You can prevent the grid from giving the divider more width than
    /// the other cells require by adding the modifier with the
    /// ``Axis/horizontal`` parameter:
    ///
    ///     Divider()
    ///         .gridCellUnsizedAxes(.horizontal)
    ///
    /// This restores the grid to the width that it would have without the
    /// divider:
    ///
    /// ![A screenshot of items arranged in a grid. The upper-left
    /// position in the grid contains the word hello. The upper-right contains
    /// an image of a globe. The lower-left contains an image of a waving hand.
    /// The lower-right contains the word world. A dividing line that spans
    /// the width of the grid separates the upper and lower elements. The grid's
    /// rows and columns have minimal vertical or horizontal
    /// spacing.](View-gridCellUnsizedAxes-2-iOS)
    ///
    /// - Parameters:
    ///   - axes: The dimensions in which the grid shouldn't offer the view a
    ///     share of any available space. This prevents a flexible view like a
    ///     ``Spacer``, ``Divider``, or ``Color`` from defining the size of
    ///     a row or column.
    ///
    /// - Returns: A view that doesn't ask an enclosing grid for extra size
    ///   in one or more axes.
    @inlinable public func gridCellUnsizedAxes(_ axes: Axis.Set) -> some View { return never() }

}

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension View {

    /// Mark the receiver as their content might be invalidated.
    ///
    /// Use this modifier to annotate views that display values that are derived
    /// from the current state of your data and might be invalidated in
    /// response of, for example, user interaction.
    ///
    /// The view will change its appearance when ``RedactionReasons.invalidated``
    /// is present in the environment.
    ///
    /// In an interactive widget a view is invalidated from the moment the user
    /// interacts with a control on the widget to the moment when a new timeline
    /// update has been presented.
    ///
    /// - Parameters:
    ///   - invalidatable: Whether the receiver content might be invalidated.
    public func invalidatableContent(_ invalidatable: Bool = true) -> some View { return never() }

}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension View {

    /// Adds an accessibility action to the view. Actions allow assistive technologies,
    /// such as the VoiceOver, to interact with the view by invoking the action.
    ///
    /// For example, this is how a `.default` action to compose
    /// a new email could be added to a view.
    ///
    ///     var body: some View {
    ///         ContentView()
    ///             .accessibilityAction {
    ///                 // Handle action
    ///             }
    ///     }
    ///
    public func accessibilityAction(_ actionKind: AccessibilityActionKind = .default, _ handler: @escaping () -> Void) -> ModifiedContent<Self, AccessibilityAttachmentModifier> { fatalError() }

    /// Adds an accessibility action to the view. Actions allow assistive technologies,
    /// such as the VoiceOver, to interact with the view by invoking the action.
    ///
    /// For example, this is how a custom action to compose
    /// a new email could be added to a view.
    ///
    ///     var body: some View {
    ///         ContentView()
    ///             .accessibilityAction(named: Text("New Message")) {
    ///                 // Handle action
    ///             }
    ///     }
    ///
    public func accessibilityAction(named name: Text, _ handler: @escaping () -> Void) -> ModifiedContent<Self, AccessibilityAttachmentModifier> { fatalError() }
}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
extension View {

    /// Adds an accessibility action to the view. Actions allow assistive technologies,
    /// such as the VoiceOver, to interact with the view by invoking the action.
    ///
    /// For example, this is how a custom action to compose
    /// a new email could be added to a view.
    ///
    ///     var body: some View {
    ///         ContentView()
    ///             .accessibilityAction {
    ///                 // Handle action
    ///             } label: {
    ///                 Label("New Message", systemImage: "plus")
    ///             }
    ///     }
    ///
    public func accessibilityAction<Label>(action: @escaping () -> Void, @ViewBuilder label: () -> Label) -> some View where Label : View { return never() }

}

@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
extension View {

    /// Adds multiple accessibility actions to the view.
    ///
    /// Actions allow assistive technologies,
    /// such as the VoiceOver, to interact with the view by invoking the action.
    /// For example, this is how a dynamic number of custom action could
    /// be added to a view.
    ///
    ///     var isDraft: Bool
    ///
    ///     var body: some View {
    ///         ContentView()
    ///             .accessibilityActions {
    ///                 ForEach(actions) { action in
    ///                     Button {
    ///                         action()
    ///                     } label: {
    ///                         Text(action.title)
    ///                     }
    ///                 }
    ///
    ///                 if isDraft {
    ///                     Button {
    ///                         // Handle Delete
    ///                     } label: {
    ///                         Text("Delete")
    ///                     }
    ///                 }
    ///             }
    ///
    public func accessibilityActions<Content>(@ViewBuilder _ content: () -> Content) -> some View where Content : View { return never() }

}

@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
extension View {

    /// Adds an accessibility action to the view. Actions allow assistive technologies,
    /// such as the VoiceOver, to interact with the view by invoking the action.
    ///
    /// For example, this is how a custom action to compose
    /// a new email could be added to a view.
    ///
    ///     var body: some View {
    ///         ContentView()
    ///             .accessibilityAction(named: "New Message") {
    ///                 // Handle action
    ///             }
    ///     }
    ///
    public func accessibilityAction(named nameKey: LocalizedStringKey, _ handler: @escaping () -> Void) -> ModifiedContent<Self, AccessibilityAttachmentModifier> { fatalError() }

    /// Adds an accessibility action to the view. Actions allow assistive technologies,
    /// such as the VoiceOver, to interact with the view by invoking the action.
    ///
    /// For example, this is how a custom action to compose
    /// a new email could be added to a view.
    ///
    ///     var body: some View {
    ///         ContentView()
    ///             .accessibilityAction(named: "New Message") {
    ///                 // Handle action
    ///             }
    ///     }
    ///
    public func accessibilityAction<S>(named name: S, _ handler: @escaping () -> Void) -> ModifiedContent<Self, AccessibilityAttachmentModifier> where S : StringProtocol { fatalError() }
}

@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
extension View {

    /// Sets the style for the tab view within the current environment.
    ///
    /// - Parameter style: The style to apply to this tab view.
    public func tabViewStyle<S>(_ style: S) -> some View where S : TabViewStyle { return never() }

}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
extension View {

    /// Create an Accessibility Rotor with the specified user-visible label,
    /// and entries generated from the content closure.
    ///
    /// An Accessibility Rotor is a shortcut for Accessibility users to
    /// quickly navigate to specific elements of the user interface,
    /// and optionally specific ranges of text within those elements.
    ///
    /// In the following example, a Message application creates a Rotor
    /// allowing users to navigate to specifically the messages originating from
    /// VIPs.
    ///
    ///     // `messages` is a list of `Identifiable` `Message`s.
    ///
    ///     ScrollView {
    ///         LazyVStack {
    ///             ForEach(messages) { message in
    ///                 MessageView(message)
    ///             }
    ///         }
    ///     }
    ///     .accessibilityElement(children: .contain)
    ///     .accessibilityRotor("VIPs") {
    ///         // Not all the MessageViews are generated at once, the model knows
    ///         // about all the messages.
    ///         ForEach(messages) { message in
    ///             // If the Message is from a VIP, make a Rotor entry for it.
    ///             if message.isVIP {
    ///                 AccessibilityRotorEntry(message.subject, id: message.id)
    ///             }
    ///         }
    ///     }
    ///
    /// - Parameters:
    ///   - label: Localized label identifying this Rotor to the user.
    ///   - entries: Content used to generate Rotor entries. This can
    ///     include AccessibilityRotorEntry structs, as well as constructs such
    ///     as if and ForEach.
    public func accessibilityRotor<Content>(_ label: Text, @AccessibilityRotorContentBuilder entries: @escaping () -> Content) -> some View where Content : AccessibilityRotorContent { return never() }


    /// Create an Accessibility Rotor replacing the specified system-provided
    /// Rotor.
    ///
    /// An Accessibility Rotor is a shortcut for Accessibility users to
    /// quickly navigate to specific elements of the user interface,
    /// and optionally specific ranges of text within those elements.
    /// Replacing system Rotors this way is useful when the System Rotor
    /// does not automatically pick up elements that aren't on-screen,
    /// such as elements far down in a `LazyVStack` or `List`.
    ///
    /// In the following example, a Message application adds a Rotor allowing
    /// the user to navigate through all the ranges of text containing
    /// headings.
    ///
    ///     extension Message {
    ///         // Ranges of special areas in the `content` text. Calculated
    ///         // when `content` is set and then cached so that we don't have
    ///         // to re-compute them.
    ///         var contentHeadingRanges: [Range<String.Index>]
    ///     }
    ///
    ///     struct MessageContentView: View {
    ///         TextEditor(.constant(message.content))
    ///             .accessibilityRotor(.heading) {
    ///                 ForEach(range in message.contentHeadingRanges) {
    ///                     AccessibilityRotorEntry(textRange: range)
    ///                 }
    ///             }
    ///     }
    ///
    /// - Parameters:
    ///   - systemRotor: The system-provided Rotor that will be overridden
    ///     by this custom Rotor.
    ///   - entries: Content used to generate Rotor entries. This can
    ///     include AccessibilityRotorEntry structs, as well as constructs such
    ///     as if and ForEach.
    public func accessibilityRotor<Content>(_ systemRotor: AccessibilitySystemRotor, @AccessibilityRotorContentBuilder entries: @escaping () -> Content) -> some View where Content : AccessibilityRotorContent { return never() }


    /// Create an Accessibility Rotor with the specified user-visible label
    /// and entries.
    ///
    /// An Accessibility Rotor is a shortcut for Accessibility users to
    /// quickly navigate to specific elements of the user interface,
    /// and optionally specific ranges of text within those elements.
    ///
    /// Using this modifier requires
    /// that the Rotor be attached to a `ScrollView`, or an Accessibility
    /// Element directly within a `ScrollView`, such as a `ForEach`.
    ///
    /// In the following example, a Message application creates a Rotor
    /// allowing users to navigate to specifically the messages originating from
    /// VIPs.
    ///
    ///     // `messages` is a list of `Identifiable` `Message`s that have a
    ///     // `subject`.
    ///     // `vipMessages` is a filtered version of that list containing only
    ///     // messages from VIPs.
    ///
    ///     ScrollView {
    ///         LazyVStack {
    ///             ForEach(messages) { message in
    ///                 MessageView(message)
    ///             }
    ///         }
    ///     }
    ///     .accessibilityElement(children: .contain)
    ///     .accessibilityRotor("VIPs", entries: vipMessages, label: \.subject)
    ///
    /// - Parameters:
    ///   - rotorLabel: Localized label identifying this Rotor to the user.
    ///   - entries: An array of identifiable values that will be
    ///     used to generate the entries of the Rotor. The identifiers
    ///     of the `Identifiable` values must match up with identifiers in a
    ///     `ForEach` or explicit `id` calls within the `ScrollView`.
    ///     When the user navigates to entries from this Rotor, SkipUI will
    ///     automatically scroll them into place as needed.
    ///   - entryLabel: Key path on the `Identifiable` type that can be
    ///     used to get a user-visible label for every Rotor entry. This is used
    ///     on macOS when the user opens the list of entries for the Rotor.
    public func accessibilityRotor<EntryModel>(_ rotorLabel: Text, entries: [EntryModel], entryLabel: KeyPath<EntryModel, String>) -> some View where EntryModel : Identifiable { return never() }


    /// Create an Accessibility Rotor with the specified user-visible label
    /// and entries.
    ///
    /// An Accessibility Rotor is a shortcut for Accessibility users to
    /// quickly navigate to specific elements of the user interface,
    /// and optionally specific ranges of text within those elements.
    ///
    /// Using this modifier requires
    /// that the Rotor be attached to a `ScrollView`, or an Accessibility
    /// Element directly within a `ScrollView`, such as a `ForEach`.
    /// When the user navigates to entries from this Rotor, SkipUI will
    /// automatically scroll them into place as needed.
    ///
    /// In the following example, a Message application creates a Rotor
    /// allowing users to navigate to specifically the messages originating from
    /// VIPs.
    ///
    ///     // `messages` is a list of `Message`s that have a `subject` and a
    ///     // `uuid`. `vipMessages` is a filtered version of that list
    ///     // containing only messages from VIPs.
    ///     ScrollView {
    ///         LazyVStack {
    ///             ForEach(messages) { message in
    ///                 MessageView(message)
    ///             }
    ///         }
    ///     }
    ///     .accessibilityElement(children: .contain)
    ///     .accessibilityRotor("VIPs", entries: vipMessages,
    ///         id: \.uuid, label: \.subject)
    ///
    /// - Parameters:
    ///   - rotorLabel: Localized label identifying this Rotor to the user.
    ///   - entries: An array of values that will be used to generate
    ///     the entries of the Rotor.
    ///   - entryID: Key path on the entry type that can be used
    ///     to generate an identifier for the Entry. The identifiers
    ///     must match up with identifiers in `ForEach` or explicit `id` calls
    ///     within the `ScrollView`.
    ///   - entryLabel: Key path on the entry type that can be
    ///     used to get a user-visible label for every Rotor entry. This is used
    ///     on macOS when the user opens the list of entries for the Rotor.
    public func accessibilityRotor<EntryModel, ID>(_ rotorLabel: Text, entries: [EntryModel], entryID: KeyPath<EntryModel, ID>, entryLabel: KeyPath<EntryModel, String>) -> some View where ID : Hashable { return never() }


    /// Create an Accessibility Rotor replacing the specified system-provided
    /// Rotor.
    ///
    /// An Accessibility Rotor is a shortcut for Accessibility users to
    /// quickly navigate to specific elements of the user interface,
    /// and optionally specific ranges of text within those elements.
    ///
    /// Using this modifier requires
    /// that the Rotor be attached to a `ScrollView`, or an Accessibility
    /// Element directly within a `ScrollView`, such as a `ForEach`.
    ///
    /// In the following example, a Message application creates a Rotor
    /// allowing users to navigate to the headings in its vertical stack of
    /// messages.
    ///
    ///     // `messageListItems` is a list of `Identifiable` `MessageListItem`s
    ///     // that are either a `Message` or a heading, containing a `subject`.
    ///     // `headingMessageListItems` is a filtered list of
    ///     // `messageListItems` containing just the headings.
    ///     ScrollView {
    ///         LazyVStack {
    ///             ForEach(messageListItems) { messageListItem in
    ///                 switch messageListItem {
    ///                     case .heading(let subject):
    ///                         Text(subject)
    ///                     case .message(let message):
    ///                         MessageView(message)
    ///                 }
    ///             }
    ///         }
    ///     }
    ///     .accessibilityElement(children: .contain)
    ///     .accessibilityRotor(
    ///         .heading, entries: headingMessageListItems, label: \.subject)
    ///
    /// - Parameters:
    ///   - systemRotor: The system-provided Rotor that will be overridden
    ///     by this custom Rotor.
    ///   - entries: An array of identifiable values that will be
    ///     used to generate the entries of the Rotor. The identifiers
    ///     of the `Identifiable` values must match up with identifiers in a
    ///     `ForEach` or explicit `id` calls within the `ScrollView`.
    ///     When the user navigates to entries from this Rotor, SkipUI will
    ///     automatically scroll them into place as needed.
    ///   - entryLabel: Key path on the `Identifiable` type that can be
    ///     used to get a user-visible label for every Rotor entry. This is used
    ///     on macOS when the user opens the list of entries for the Rotor.
    public func accessibilityRotor<EntryModel>(_ systemRotor: AccessibilitySystemRotor, entries: [EntryModel], entryLabel: KeyPath<EntryModel, String>) -> some View where EntryModel : Identifiable { return never() }


    /// Create an Accessibility Rotor replacing the specified system-provided
    /// Rotor.
    ///
    /// An Accessibility Rotor is a shortcut for Accessibility users to
    /// quickly navigate to specific elements of the user interface,
    /// and optionally specific ranges of text within those elements.
    ///
    /// Using this modifier requires
    /// that the Rotor be attached to a `ScrollView`, or an Accessibility
    /// Element directly within a `ScrollView`, such as a `ForEach`.
    /// When the user navigates to entries from this Rotor, SkipUI will
    /// automatically scroll them into place as needed.
    ///
    /// In the following example, a Message application creates a Rotor
    /// allowing users to navigate to the headings in its vertical stack of
    /// messages.
    ///
    ///     // `messageListItems` is a list of `MessageListItem`s
    ///     // that are either a `Message` or a heading, containing a `subject`
    ///     // and a `uuid`.
    ///     // `headingMessageListItems` is a filtered list of
    ///     // `messageListItems` containing just the headings.
    ///     ScrollView {
    ///         LazyVStack {
    ///             ForEach(messageListItems) { messageListItem in
    ///                 switch messageListItem {
    ///                     case .heading(let subject):
    ///                         Text(subject)
    ///                     case .message(let message):
    ///                         MessageView(message)
    ///                 }
    ///             }
    ///         }
    ///     }
    ///     .accessibilityElement(children: .contain)
    ///     .accessibilityRotor(
    ///         .heading, entries: headingMessageListItems,
    ///         entryID: \.uuid, label: \.subject
    ///     )
    ///
    /// - Parameters:
    ///   - systemRotor: The system-provided Rotor that will be overridden
    ///     by this custom Rotor.
    ///   - entries: An array of values that will be used to generate
    ///     the entries of the Rotor.
    ///   - entryID: Key path on the entry type that can be used
    ///     to generate an identifier for the Entry. The identifiers
    ///     must match up with identifiers in `ForEach` or explicit `id` calls
    ///     within the `ScrollView`.
    ///   - entryLabel: Key path on the entry type that can be
    ///     used to get a user-visible label for every Rotor entry. This is used
    ///     on macOS when the user opens the list of entries for the Rotor.
    public func accessibilityRotor<EntryModel, ID>(_ systemRotor: AccessibilitySystemRotor, entries: [EntryModel], entryID: KeyPath<EntryModel, ID>, entryLabel: KeyPath<EntryModel, String>) -> some View where ID : Hashable { return never() }


    /// Create an Accessibility Rotor with the specified user-visible label
    /// and entries for each of the specified ranges. The Rotor will be attached
    /// to the current Accessibility element, and each entry will go the
    /// specified range of that element.
    ///
    /// An Accessibility Rotor is a shortcut for Accessibility users to
    /// quickly navigate to specific elements of the user interface,
    /// and optionally specific ranges of text within those elements.
    ///
    /// In the following example, a Message application adds a Rotor allowing
    /// the user to navigate through all the ranges of text containing
    /// email addresses.
    ///
    ///     extension Message {
    ///         // Ranges of special areas in the `content` text. Calculated
    ///         // when `content` is set and then cached so that we don't have
    ///         // to re-compute them.
    ///         var emailAddressRanges: [Range<String.Index>]
    ///     }
    ///
    ///     struct MessageContentView: View {
    ///         TextEditor(.constant(message.content))
    ///             .accessibilityRotor("Email Addresses",
    ///                 textRanges: message.emailAddressRanges)
    ///     }
    ///
    /// - Parameters:
    ///   - label: Localized label identifying this Rotor to the user.
    ///   - textRanges: An array of ranges that will be used to generate
    ///     the entries of the Rotor.
    public func accessibilityRotor(_ label: Text, textRanges: [Range<String.Index>]) -> some View { return never() }


    /// Create an Accessibility Rotor replacing the specified system-provided
    /// Rotor. The Rotor will be attached to the current Accessibility element,
    /// and each entry will go the specified range of that element.
    ///
    /// An Accessibility Rotor is a shortcut for Accessibility users to
    /// quickly navigate to specific elements of the user interface,
    /// and optionally specific ranges of text within those elements.
    ///
    /// In the following example, a Message application adds a Rotor allowing
    /// the user to navigate through all the ranges of text containing headings.
    ///
    ///     extension Message {
    ///         // Ranges of special areas in the `content` text. Calculated when
    ///         // `content` is set and then cached so that we don't have to
    ///         // re-compute them.
    ///         var headingRanges: [Range<String.Index>]
    ///     }
    ///
    ///     struct MessageContentView: View {
    ///         TextEditor(.constant(message.content))
    ///             .accessibilityRotor(
    ///                 .heading,
    ///                 textRanges: message.headingRanges
    ///             )
    ///     }
    ///
    /// - Parameters:
    ///   - systemRotor: The system-provided Rotor that will be overridden
    ///     by this custom Rotor.
    ///   - textRanges: An array of ranges that will be used to generate
    ///     the entries of the Rotor.
    public func accessibilityRotor(_ systemRotor: AccessibilitySystemRotor, textRanges: [Range<String.Index>]) -> some View { return never() }

}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
extension View {

    /// Create an Accessibility Rotor with the specified user-visible label,
    /// and entries generated from the content closure.
    ///
    /// An Accessibility Rotor is a shortcut for Accessibility users to
    /// quickly navigate to specific elements of the user interface,
    /// and optionally specific ranges of text within those elements.
    ///
    /// In the following example, a Message application creates a Rotor
    /// allowing users to navigate to specifically the messages originating from
    /// VIPs.
    ///
    ///     // `messages` is a list of `Identifiable` `Message`s.
    ///
    ///     ScrollView {
    ///         LazyVStack {
    ///             ForEach(messages) { message in
    ///                 MessageView(message)
    ///             }
    ///         }
    ///     }
    ///     .accessibilityElement(children: .contain)
    ///     .accessibilityRotor("VIPs") {
    ///         // Not all the MessageViews are generated at once, the model
    ///         // knows about all the messages.
    ///         ForEach(messages) { message in
    ///             // If the Message is from a VIP, make a Rotor entry for it.
    ///             if message.isVIP {
    ///                 AccessibilityRotorEntry(message.subject, id: message.id)
    ///             }
    ///         }
    ///     }
    ///
    /// - Parameters:
    ///   - labelKey: Localized label identifying this Rotor to the user.
    ///   - entries: Content used to generate Rotor entries. This can
    ///     include AccessibilityRotorEntry structs, as well as constructs such
    ///     as if and ForEach.
    public func accessibilityRotor<Content>(_ labelKey: LocalizedStringKey, @AccessibilityRotorContentBuilder entries: @escaping () -> Content) -> some View where Content : AccessibilityRotorContent { return never() }


    /// Create an Accessibility Rotor with the specified user-visible label,
    /// and entries generated from the content closure.
    ///
    /// An Accessibility Rotor is a shortcut for Accessibility users to
    /// quickly navigate to specific elements of the user interface,
    /// and optionally specific ranges of text within those elements.
    ///
    /// In the following example, a Message application creates a Rotor
    /// allowing users to navigate to specifically the messages originating from
    /// VIPs.
    ///
    ///     // `messages` is a list of `Identifiable` `Message`s.
    ///
    ///     ScrollView {
    ///         LazyVStack {
    ///             ForEach(messages) { message in
    ///                 MessageView(message)
    ///             }
    ///         }
    ///     }
    ///     .accessibilityElement(children: .contain)
    ///     .accessibilityRotor("VIPs") {
    ///         // Not all the MessageViews are generated at once, the model
    ///         // knows about all the messages.
    ///         ForEach(messages) { message in
    ///             // If the Message is from a VIP, make a Rotor entry for it.
    ///             if message.isVIP {
    ///                 AccessibilityRotorEntry(message.subject, id: message.id)
    ///             }
    ///         }
    ///     }
    ///
    /// - Parameters:
    ///   - label: Localized label identifying this Rotor to the user.
    ///   - entries: Content used to generate Rotor entries. This can
    ///     include AccessibilityRotorEntry structs, as well as constructs such
    ///     as if and ForEach.
    public func accessibilityRotor<L, Content>(_ label: L, @AccessibilityRotorContentBuilder entries: @escaping () -> Content) -> some View where L : StringProtocol, Content : AccessibilityRotorContent { return never() }


    /// Create an Accessibility Rotor with the specified user-visible label
    /// and entries.
    ///
    /// An Accessibility Rotor is a shortcut for Accessibility users to
    /// quickly navigate to specific elements of the user interface,
    /// and optionally specific ranges of text within those elements.
    ///
    /// Using this modifier requires
    /// that the Rotor be attached to a `ScrollView`, or an Accessibility
    /// Element directly within a `ScrollView`, such as a `ForEach`.
    ///
    /// In the following example, a Message application creates a Rotor
    /// allowing users to navigate to specifically the messages originating from
    /// VIPs.
    ///
    ///     // `messages` is a list of `Identifiable` `Message`s that have a
    ///     // `subject`.
    ///     // `vipMessages` is a filtered version of that list containing only
    ///     // messages from VIPs.
    ///
    ///     ScrollView {
    ///         LazyVStack {
    ///             ForEach(messages) { message in
    ///                 MessageView(message)
    ///             }
    ///         }
    ///     }
    ///     .accessibilityElement(children: .contain)
    ///     .accessibilityRotor("VIPs", entries: vipMessages,
    ///         entryLabel: \.subject)
    ///
    /// - Parameters:
    ///   - rotorLabelKey: Localized label identifying this Rotor to the user.
    ///   - entries: An array of identifiable values that will be
    ///     used to generate the entries of the Rotor. The identifiers
    ///     of the `Identifiable` values must match up with identifiers in a
    ///     `ForEach` or explicit `id` calls within the `ScrollView`.
    ///     When the user navigates to entries from this Rotor, SkipUI will
    ///     automatically scroll them into place as needed.
    ///   - entryLabel: Key path on the `Identifiable` type that can be
    ///     used to get a user-visible label for every Rotor entry. This is used
    ///     on macOS when the user opens the list of entries for the Rotor.
    public func accessibilityRotor<EntryModel>(_ rotorLabelKey: LocalizedStringKey, entries: [EntryModel], entryLabel: KeyPath<EntryModel, String>) -> some View where EntryModel : Identifiable { return never() }


    /// Create an Accessibility Rotor with the specified user-visible label
    /// and entries.
    ///
    /// An Accessibility Rotor is a shortcut for Accessibility users to
    /// quickly navigate to specific elements of the user interface,
    /// and optionally specific ranges of text within those elements.
    ///
    /// Using this modifier requires
    /// that the Rotor be attached to a `ScrollView`, or an Accessibility
    /// Element directly within a `ScrollView`, such as a `ForEach`.
    ///
    /// In the following example, a Message application creates a Rotor
    /// allowing users to navigate to specifically the messages originating from
    /// VIPs.
    ///
    ///     // `messages` is a list of `Identifiable` `Message`s that have a
    ///     // `subject`.
    ///     // `vipMesages` is a filtered version of that list containing only
    ///     // messages from VIPs.
    ///
    ///     ScrollView {
    ///         LazyVStack {
    ///             ForEach(messages) { message in
    ///                 MessageView(message)
    ///             }
    ///         }
    ///     }
    ///     .accessibilityElement(children: .contain)
    ///     .accessibilityRotor("VIPs", entries: vipMessages, label: \.subject)
    ///
    /// - Parameters:
    ///   - rotorLabel: Localized label identifying this Rotor to the user.
    ///   - entries: An array of identifiable values that will be
    ///     used to generate the entries of the Rotor. The identifiers
    ///     of the `Identifiable` values must match up with identifiers in a
    ///     `ForEach` or explicit `id` calls within the `ScrollView`.
    ///     When the user navigates to entries from this Rotor, SkipUI will
    ///     automatically scroll them into place as needed.
    ///   - entry: Key path on the `Identifiable` type that can be
    ///     used to get a user-visible label for every Rotor entry. This is used
    ///     on macOS when the user opens the list of entries for the Rotor.
    public func accessibilityRotor<L, EntryModel>(_ rotorLabel: L, entries: [EntryModel], entryLabel: KeyPath<EntryModel, String>) -> some View where L : StringProtocol, EntryModel : Identifiable { return never() }


    /// Create an Accessibility Rotor with the specified user-visible label
    /// and entries.
    ///
    /// An Accessibility Rotor is a shortcut for Accessibility users to
    /// quickly navigate to specific elements of the user interface,
    /// and optionally specific ranges of text within those elements.
    ///
    /// Using this modifier requires that the Rotor be attached to a
    /// `ScrollView`, or an Accessibility Element directly within a
    /// `ScrollView`, such as a `ForEach`. When the user navigates to entries
    /// from this Rotor, SkipUI will automatically scroll them into place as
    /// needed.
    ///
    /// In the following example, a Message application creates a Rotor
    /// allowing users to navigate to specifically the messages originating from
    /// VIPs.
    ///
    ///     // `messages` is a list of `Message`s that have a `subject` and a
    ///     // `uuid`. `vipMesages` is a filtered version of that list
    ///     // containing only messages from VIPs.
    ///     ScrollView {
    ///         LazyVStack {
    ///             ForEach(messages) { message in
    ///                 MessageView(message)
    ///             }
    ///         }
    ///     }
    ///     .accessibilityElement(children: .contain)
    ///     .accessibilityRotor("VIPs", entries: vipMessages,
    ///         entryID: \.uuid, entryLabel: \.subject)
    ///
    /// - Parameters:
    ///   - labelKey: Localized label identifying this Rotor to the user.
    ///   - entries: An array of values that will be used to generate
    ///     the entries of the Rotor.
    ///   - entryID: Key path on the entry type that can be used
    ///     to generate an identifier for the Entry. The identifiers
    ///     must match up with identifiers in `ForEach` or explicit `id` calls
    ///     within the `ScrollView`.
    ///   - entryLabel: Key path on the entry type that can be
    ///     used to get a user-visible label for every Rotor entry. This is used
    ///     on macOS when the user opens the list of entries for the Rotor.
    public func accessibilityRotor<EntryModel, ID>(_ rotorLabelKey: LocalizedStringKey, entries: [EntryModel], entryID: KeyPath<EntryModel, ID>, entryLabel: KeyPath<EntryModel, String>) -> some View where ID : Hashable { return never() }


    /// Create an Accessibility Rotor with the specified user-visible label
    /// and entries.
    ///
    /// An Accessibility Rotor is a shortcut for Accessibility users to
    /// quickly navigate to specific elements of the user interface,
    /// and optionally specific ranges of text within those elements.
    ///
    /// Using this modifier requires
    /// that the Rotor be attached to a `ScrollView`, or an Accessibility
    /// Element directly within a `ScrollView`, such as a `ForEach`.
    /// When the user navigates to entries from this Rotor, SkipUI will
    /// automatically scroll them into place as needed.
    ///
    /// In the following example, a Message application creates a Rotor
    /// allowing users to navigate to specifically the messages originating from
    /// VIPs.
    ///     // `messages` is a list of `Message`s that have a `subject` and a
    ///     // `uuid`. `vipMessages` is a filtered version of that list
    ///     // containing only messages from VIPs.
    ///     ScrollView {
    ///         LazyVStack {
    ///             ForEach(messages) { message in
    ///                 MessageView(message)
    ///             }
    ///         }
    ///     }
    ///     .accessibilityElement(children: .contain)
    ///     .accessibilityRotor("VIPs", entries: vipMessages,
    ///         id: \.uuid, label: \.subject)
    ///
    /// - Parameters:
    ///   - rotorLabel: Localized label identifying this Rotor to the user.
    ///   - entries: An array of values that will be used to generate
    ///     the entries of the Rotor.
    ///   - entryID: Key path on the entry type that can be used
    ///     to generate an identifier for the Entry. The identifiers
    ///     must match up with identifiers in `ForEach` or explicit `id` calls
    ///     within the `ScrollView`.
    ///   - entryLabel: Key path on the entry type that can be
    ///     used to get a user-visible label for every Rotor entry. This is used
    ///     on macOS when the user opens the list of entries for the Rotor.
    public func accessibilityRotor<L, EntryModel, ID>(_ rotorLabel: L, entries: [EntryModel], entryID: KeyPath<EntryModel, ID>, entryLabel: KeyPath<EntryModel, String>) -> some View where L : StringProtocol, ID : Hashable { return never() }


    /// Create an Accessibility Rotor with the specified user-visible label
    /// and entries for each of the specified ranges. The Rotor will be attached
    /// to the current Accessibility element, and each entry will go the
    /// specified range of that element.
    ///
    /// An Accessibility Rotor is a shortcut for Accessibility users to
    /// quickly navigate to specific elements of the user interface,
    /// and optionally specific ranges of text within those elements.
    ///
    /// In the following example, a Message application adds a Rotor allowing
    /// the user to navigate through all the ranges of text containing
    /// email addresses.
    ///
    ///     extension Message {
    ///         // Ranges of special areas in the `content` text. Calculated
    ///         // when `content` is set and then cached so that we don't have
    ///         // to re-compute them.
    ///         var emailAddressRanges: [Range<String.Index>]
    ///     }
    ///
    ///     struct MessageContentView: View {
    ///         TextEditor(.constant(message.content))
    ///             .accessibilityRotor("Email Addresses",
    ///                 textRanges: message.emailAddressRanges)
    ///     }
    ///
    /// - Parameters:
    ///   - labelKey: Localized label identifying this Rotor to the user.
    ///   - textRanges: An array of ranges that will be used to generate
    ///     the entries of the Rotor.
    public func accessibilityRotor(_ labelKey: LocalizedStringKey, textRanges: [Range<String.Index>]) -> some View { return never() }


    /// Create an Accessibility Rotor with the specified user-visible label
    /// and entries for each of the specified ranges. The Rotor will be attached
    /// to the current Accessibility element, and each entry will go the
    /// specified range of that element.
    ///
    /// An Accessibility Rotor is a shortcut for Accessibility users to
    /// quickly navigate to specific elements of the user interface,
    /// and optionally specific ranges of text within those elements.
    ///
    /// In the following example, a Message application adds a Rotor allowing
    /// the user to navigate through all the ranges of text containing
    /// email addresses.
    ///
    ///     extension Message {
    ///         // Ranges of special areas in the `content` text. Calculated
    ///         // when `content` is set and then cached so that we don't have
    ///         // to re-compute them.
    ///         var emailAddressRanges: [Range<String.Index>]
    ///     }
    ///
    ///     struct MessageContentView: View {
    ///         TextEditor(.constant(message.content))
    ///             .accessibilityRotor("Email Addresses",
    ///                 textRanges: message.emailAddressRanges)
    ///     }
    ///
    /// - Parameters:
    ///   - label: Localized label identifying this Rotor to the user.
    ///   - textRanges: An array of ranges that will be used to generate
    ///     the entries of the Rotor.
    public func accessibilityRotor<L>(_ label: L, textRanges: [Range<String.Index>]) -> some View where L : StringProtocol { return never() }

}

extension View {

    /// Adds a condition that controls whether users can select this view.
    ///
    /// Use this modifier to control the selectability of views in
    /// selectable containers like ``List`` or ``Table``. In the example,
    /// below, the user can't select the first item in the list.
    ///
    ///     @Binding var selection: Item.ID?
    ///     @Binding var items: [Item]
    ///
    ///     var body: some View {
    ///         List(selection: $selection) {
    ///             ForEach(items) { item in
    ///                 ItemView(item: item)
    ///                     .selectionDisabled(item.id == items.first.id)
    ///             }
    ///         }
    ///     }
    ///
    /// You can also use this modifier to specify the selectability of views
    /// within a `Picker`. The following example represents a flavor picker
    /// that disables selection on flavors that are unavailable.
    ///
    ///     Picker("Flavor", selection: $selectedFlavor) {
    ///         ForEach(Flavor.allCases) { flavor in
    ///             Text(flavor.rawValue.capitalized)
    ///                 .selectionDisabled(isSoldOut(flavor))
    ///         }
    ///     }
    ///
    /// - Parameter isDisabled: A Boolean value that determines whether users can
    ///   select this view.
    @available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
    public func selectionDisabled(_ isDisabled: Bool = true) -> some View { return never() }

}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
extension View {

    /// Modifies this view by binding its focus state to the given state value.
    ///
    /// Use this modifier to cause the view to receive focus whenever the
    /// the `binding` equals the `value`. Typically, you create an enumeration
    /// of fields that may receive focus, bind an instance of this enumeration,
    /// and assign its cases to focusable views.
    ///
    /// The following example uses the cases of a `LoginForm` enumeration to
    /// bind the focus state of two ``TextField`` views. A sign-in button
    /// validates the fields and sets the bound `focusedField` value to
    /// any field that requires the user to correct a problem.
    ///
    ///     struct LoginForm {
    ///         enum Field: Hashable {
    ///             case usernameField
    ///             case passwordField
    ///         }
    ///
    ///         @State private var username = ""
    ///         @State private var password = ""
    ///         @FocusState private var focusedField: Field?
    ///
    ///         var body: some View {
    ///             Form {
    ///                 TextField("Username", text: $username)
    ///                     .focused($focusedField, equals: .usernameField)
    ///
    ///                 SecureField("Password", text: $password)
    ///                     .focused($focusedField, equals: .passwordField)
    ///
    ///                 Button("Sign In") {
    ///                     if username.isEmpty {
    ///                         focusedField = .usernameField
    ///                     } else if password.isEmpty {
    ///                         focusedField = .passwordField
    ///                     } else {
    ///                         handleLogin(username, password)
    ///                     }
    ///                 }
    ///             }
    ///         }
    ///     }
    ///
    /// To control focus using a Boolean, use the ``View/focused(_:)`` method
    /// instead.
    ///
    /// - Parameters:
    ///   - binding: The state binding to register. When focus moves to the
    ///     modified view, the binding sets the bound value to the corresponding
    ///     match value. If a caller sets the state value programmatically to the
    ///     matching value, then focus moves to the modified view. When focus
    ///     leaves the modified view, the binding sets the bound value to
    ///     `nil`. If a caller sets the value to `nil`, SkipUI automatically
    ///     dismisses focus.
    ///   - value: The value to match against when determining whether the
    ///     binding should change.
    /// - Returns: The modified view.
    public func focused<Value>(_ binding: FocusState<Value>.Binding, equals value: Value) -> some View where Value : Hashable { return never() }


    /// Modifies this view by binding its focus state to the given Boolean state
    /// value.
    ///
    /// Use this modifier to cause the view to receive focus whenever the
    /// the `condition` value is `true`. You can use this modifier to
    /// observe the focus state of a single view, or programmatically set and
    /// remove focus from the view.
    ///
    /// In the following example, a single ``TextField`` accepts a user's
    /// desired `username`. The text field binds its focus state to the
    /// Boolean value `usernameFieldIsFocused`. A "Submit" button's action
    /// verifies whether the name is available. If the name is unavailable, the
    /// button sets `usernameFieldIsFocused` to `true`, which causes focus to
    /// return to the text field, so the user can enter a different name.
    ///
    ///     @State private var username: String = ""
    ///     @FocusState private var usernameFieldIsFocused: Bool
    ///     @State private var showUsernameTaken = false
    ///
    ///     var body: some View {
    ///         VStack {
    ///             TextField("Choose a username.", text: $username)
    ///                 .focused($usernameFieldIsFocused)
    ///             if showUsernameTaken {
    ///                 Text("That username is taken. Please choose another.")
    ///             }
    ///             Button("Submit") {
    ///                 showUsernameTaken = false
    ///                 if !isUserNameAvailable(username: username) {
    ///                     usernameFieldIsFocused = true
    ///                     showUsernameTaken = true
    ///                 }
    ///             }
    ///         }
    ///     }
    ///
    /// To control focus by matching a value, use the
    /// ``View/focused(_:equals:)`` method instead.
    ///
    /// - Parameter condition: The focus state to bind. When focus moves
    ///   to the view, the binding sets the bound value to `true`. If a caller
    ///   sets the value to  `true` programmatically, then focus moves to the
    ///   modified view. When focus leaves the modified view, the binding
    ///   sets the value to `false`. If a caller sets the value to `false`,
    ///   SkipUI automatically dismisses focus.
    ///
    /// - Returns: The modified view.
    public func focused(_ condition: FocusState<Bool>.Binding) -> some View { return never() }

}

@available(iOS 13.0, macOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension View {

    /// Hides the navigation bar for this view.
    ///
    /// Use `navigationBarHidden(_:)` to hide the navigation bar. This modifier
    /// only takes effect when this view is inside of and visible within a
    /// ``NavigationView``.
    ///
    /// - Parameter hidden: A Boolean value that indicates whether to hide the
    ///   navigation bar.
    @available(iOS, introduced: 13.0, deprecated: 100000.0, message: "Use toolbar(.hidden)")
    @available(macOS, unavailable)
    @available(tvOS, introduced: 13.0, deprecated: 100000.0, message: "Use toolbar(.hidden)")
    @available(watchOS, introduced: 6.0, deprecated: 100000.0, message: "Use toolbar(.hidden)")
    @available(xrOS, introduced: 1.0, deprecated: 100000.0, message: "Use toolbar(.hidden)")
    public func navigationBarHidden(_ hidden: Bool) -> some View { return never() }


    /// Sets the title in the navigation bar for this view.
    ///
    /// Use `navigationBarTitle(_:)` to set the title of the navigation bar.
    /// This modifier only takes effect when this view is inside of and visible
    /// within a ``NavigationView``.
    ///
    /// The example below shows setting the title of the navigation bar using a
    /// ``Text`` view:
    ///
    ///     struct FlavorView: View {
    ///         let items = ["Chocolate", "Vanilla", "Strawberry", "Mint Chip",
    ///                      "Pistachio"]
    ///         var body: some View {
    ///             NavigationView {
    ///                 List(items, id: \.self) {
    ///                     Text($0)
    ///                 }
    ///                 .navigationBarTitle(Text("Today's Flavors"))
    ///             }
    ///         }
    ///     }
    ///
    /// ![A screenshot showing the title of a navigation bar configured using a
    /// text view.](SkipUI-navigationBarTitle-Text.png)
    ///
    /// - Parameter title: A description of this view to display in the
    ///   navigation bar.
    @available(iOS, introduced: 13.0, deprecated: 100000.0, renamed: "navigationTitle(_:)")
    @available(macOS, unavailable)
    @available(tvOS, introduced: 13.0, deprecated: 100000.0, renamed: "navigationTitle(_:)")
    @available(watchOS, introduced: 6.0, deprecated: 100000.0, renamed: "navigationTitle(_:)")
    @available(xrOS, introduced: 1.0, deprecated: 100000.0, renamed: "navigationTitle(_:)")
    public func navigationBarTitle(_ title: Text) -> some View { return never() }


    /// Sets the title of this view's navigation bar with a localized string.
    ///
    /// Use `navigationBarTitle(_:)` to set the title of the navigation bar
    /// using a ``LocalizedStringKey`` that will be used to search for a
    /// matching localized string in the application's localizable strings
    /// assets.
    ///
    /// This modifier only takes effect when this view is inside of and visible
    /// within a ``NavigationView``.
    ///
    /// In the example below, a string constant is used to access a
    /// ``LocalizedStringKey`` that will be resolved at run time to provide a
    /// title for the navigation bar. If the localization key cannot be
    /// resolved, the text of the key name will be used as the title text.
    ///
    ///     struct FlavorView: View {
    ///         let items = ["Chocolate", "Vanilla", "Strawberry", "Mint Chip",
    ///                      "Pistachio"]
    ///         var body: some View {
    ///             NavigationView {
    ///                 List(items, id: \.self) {
    ///                     Text($0)
    ///                 }
    ///                 .navigationBarTitle("Today's Flavors")
    ///             }
    ///         }
    ///     }
    ///
    /// - Parameter titleKey: A key to a localized description of this view to
    ///   display in the navigation bar.
    @available(iOS, introduced: 13.0, deprecated: 100000.0, renamed: "navigationTitle(_:)")
    @available(macOS, unavailable)
    @available(tvOS, introduced: 13.0, deprecated: 100000.0, renamed: "navigationTitle(_:)")
    @available(watchOS, introduced: 6.0, deprecated: 100000.0, renamed: "navigationTitle(_:)")
    @available(xrOS, introduced: 1.0, deprecated: 100000.0, renamed: "navigationTitle(_:)")
    public func navigationBarTitle(_ titleKey: LocalizedStringKey) -> some View { return never() }


    /// Sets the title of this view's navigation bar with a string.
    ///
    /// Use `navigationBarTitle(_:)` to set the title of the navigation bar
    /// using a `String`. This modifier only takes effect when this view is
    /// inside of and visible within a ``NavigationView``.
    ///
    /// In the example below, text for the navigation bar title is provided
    /// using a string:
    ///
    ///     struct FlavorView: View {
    ///         let items = ["Chocolate", "Vanilla", "Strawberry", "Mint Chip",
    ///                      "Pistachio"]
    ///         let text = "Today's Flavors"
    ///         var body: some View {
    ///             NavigationView {
    ///                 List(items, id: \.self) {
    ///                     Text($0)
    ///                 }
    ///                 .navigationBarTitle(text)
    ///             }
    ///         }
    ///     }
    ///
    /// - Parameter title: A title for this view to display in the navigation
    ///   bar.
    @available(iOS, introduced: 13.0, deprecated: 100000.0, renamed: "navigationTitle(_:)")
    @available(macOS, unavailable)
    @available(tvOS, introduced: 13.0, deprecated: 100000.0, renamed: "navigationTitle(_:)")
    @available(watchOS, introduced: 6.0, deprecated: 100000.0, renamed: "navigationTitle(_:)")
    @available(xrOS, introduced: 1.0, deprecated: 100000.0, renamed: "navigationTitle(_:)")
    public func navigationBarTitle<S>(_ title: S) -> some View where S : StringProtocol { return never() }


    /// Sets the title and display mode in the navigation bar for this view.
    ///
    /// Use `navigationBarTitle(_:displayMode:)` to set the title of the
    /// navigation bar for this view and specify a display mode for the title
    /// from one of the ``NavigationBarItem/TitleDisplayMode`` styles. This
    /// modifier only takes effect when this view is inside of and visible
    /// within a ``NavigationView``.
    ///
    /// In the example below, text for the navigation bar title is provided
    /// using a ``Text`` view. The navigation bar title's
    /// ``NavigationBarItem/TitleDisplayMode`` is set to `.inline` which places
    /// the navigation bar title in the bounds of the navigation bar.
    ///
    ///     struct FlavorView: View {
    ///        let items = ["Chocolate", "Vanilla", "Strawberry", "Mint Chip",
    ///                     "Pistachio"]
    ///        var body: some View {
    ///             NavigationView {
    ///                 List(items, id: \.self) {
    ///                     Text($0)
    ///                 }
    ///                 .navigationBarTitle(Text("Today's Flavors", displayMode: .inline)
    ///             }
    ///         }
    ///     }
    ///
    /// - Parameters:
    ///   - title: A title for this view to display in the navigation bar.
    ///   - displayMode: The style to use for displaying the navigation bar title.
    @available(iOS, introduced: 13.0, deprecated: 100000.0, message: "Use navigationTitle(_:) with navigationBarTitleDisplayMode(_:)")
    @available(macOS, unavailable)
    @available(tvOS, unavailable)
    @available(watchOS, unavailable)
    @available(xrOS, introduced: 1.0, deprecated: 100000.0, message: "Use navigationTitle(_:) with navigationBarTitleDisplayMode(_:)")
    public func navigationBarTitle(_ title: Text, displayMode: NavigationBarItem.TitleDisplayMode) -> some View { return never() }


    /// Sets the title and display mode in the navigation bar for this view.
    ///
    /// Use `navigationBarTitle(_:displayMode:)` to set the title of the
    /// navigation bar for this view and specify a display mode for the title
    /// from one of the ``NavigationBarItem/TitleDisplayMode`` styles. This
    /// modifier only takes effect when this view is inside of and visible
    /// within a ``NavigationView``.
    ///
    /// In the example below, text for the navigation bar title is provided
    /// using a string. The navigation bar title's
    /// ``NavigationBarItem/TitleDisplayMode`` is set to `.inline` which places
    /// the navigation bar title in the bounds of the navigation bar.
    ///
    ///     struct FlavorView: View {
    ///         let items = ["Chocolate", "Vanilla", "Strawberry", "Mint Chip",
    ///                      "Pistachio"]
    ///         var body: some View {
    ///             NavigationView {
    ///                 List(items, id: \.self) {
    ///                     Text($0)
    ///                 }
    ///                 .navigationBarTitle("Today's Flavors", displayMode: .inline)
    ///             }
    ///         }
    ///     }
    ///
    /// If the `titleKey` can't be found, the title uses the text of the key
    /// name instead.
    ///
    /// - Parameters:
    ///   - titleKey: A key to a localized description of this view to display
    ///     in the navigation bar.
    ///   - displayMode: The style to use for displaying the navigation bar
    ///     title.
    @available(iOS, introduced: 13.0, deprecated: 100000.0, message: "Use navigationTitle(_:) with navigationBarTitleDisplayMode(_:)")
    @available(macOS, unavailable)
    @available(tvOS, unavailable)
    @available(watchOS, unavailable)
    @available(xrOS, introduced: 1.0, deprecated: 100000.0, message: "Use navigationTitle(_:) with navigationBarTitleDisplayMode(_:)")
    public func navigationBarTitle(_ titleKey: LocalizedStringKey, displayMode: NavigationBarItem.TitleDisplayMode) -> some View { return never() }


    /// Sets the title and display mode in the navigation bar for this view.
    ///
    /// Use `navigationBarTitle(_:displayMode:)` to set the title of the
    /// navigation bar for this view and specify a display mode for the
    /// title from one of the `NavigationBarItem.Title.DisplayMode`
    /// styles. This modifier only takes effect when this view is inside of and
    /// visible within a `NavigationView`.
    ///
    /// In the example below, `navigationBarTitle(_:displayMode:)` uses a
    /// string to provide a title for the navigation bar. Setting the title's
    /// `displayMode` to `.inline` places the navigation bar title within the
    /// bounds of the navigation bar.
    ///
    /// In the example below, text for the navigation bar title is provided using
    /// a string. The navigation bar title's `displayMode` is set to
    /// `.inline` which places the navigation bar title in the bounds of the
    /// navigation bar.
    ///
    ///     struct FlavorView: View {
    ///         let items = ["Chocolate", "Vanilla", "Strawberry", "Mint Chip",
    ///                      "Pistachio"]
    ///         let title = "Today's Flavors"
    ///         var body: some View {
    ///             NavigationView {
    ///                 List(items, id: \.self) {
    ///                     Text($0)
    ///                 }
    ///                 .navigationBarTitle(title, displayMode: .inline)
    ///             }
    ///         }
    ///     }
    ///
    /// ![A screenshot of a navigation bar, showing the title within the bounds
    ///  of the navigation bar]
    /// (SkipUI-navigationBarTitle-stringProtocol.png)
    ///
    /// - Parameters:
    ///   - title: A title for this view to display in the navigation bar.
    ///   - displayMode: The way to display the title.
    @available(iOS, introduced: 14.0, deprecated: 100000.0, message: "Use navigationTitle(_:) with navigationBarTitleDisplayMode(_:)")
    @available(macOS, unavailable)
    @available(tvOS, unavailable)
    @available(watchOS, unavailable)
    @available(xrOS, introduced: 1.0, deprecated: 100000.0, message: "Use navigationTitle(_:) with navigationBarTitleDisplayMode(_:)")
    public func navigationBarTitle<S>(_ title: S, displayMode: NavigationBarItem.TitleDisplayMode) -> some View where S : StringProtocol { return never() }


    /// Hides the navigation bar back button for the view.
    ///
    /// Use `navigationBarBackButtonHidden(_:)` to hide the back button for this
    /// view.
    ///
    /// This modifier only takes effect when this view is inside of and visible
    /// within a ``NavigationView``.
    ///
    /// - Parameter hidesBackButton: A Boolean value that indicates whether to
    ///   hide the back button. The default value is `true`.
    public func navigationBarBackButtonHidden(_ hidesBackButton: Bool = true) -> some View { return never() }

}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension View {

    /// Applies a modifier to a view and returns a new view.
    ///
    /// Use this modifier to combine a ``View`` and a ``ViewModifier``, to
    /// create a new view. For example, if you create a view modifier for
    /// a new kind of caption with blue text surrounded by a rounded rectangle:
    ///
    ///     struct BorderedCaption: ViewModifier {
    ///         func body(content: Content) -> some View {
    ///             content
    ///                 .font(.caption2)
    ///                 .padding(10)
    ///                 .overlay(
    ///                     RoundedRectangle(cornerRadius: 15)
    ///                         .stroke(lineWidth: 1)
    ///                 )
    ///                 .foregroundColor(Color.blue)
    ///         }
    ///     }
    ///
    /// You can use ``modifier(_:)`` to extend ``View`` to create new modifier
    /// for applying the `BorderedCaption` defined above:
    ///
    ///     extension View {
    ///         func borderedCaption() -> some View {
    ///             modifier(BorderedCaption())
    ///         }
    ///     }
    ///
    /// Then you can apply the bordered caption to any view:
    ///
    ///     Image(systemName: "bus")
    ///         .resizable()
    ///         .frame(width:50, height:50)
    ///     Text("Downtown Bus")
    ///         .borderedCaption()
    ///
    /// ![A screenshot showing the image of a bus with a caption reading
    /// Downtown Bus. A view extension, using custom a modifier, renders the
    ///  caption in blue text surrounded by a rounded
    ///  rectangle.](SkipUI-View-ViewModifier.png)
    ///
    /// - Parameter modifier: The modifier to apply to this view.
    @inlinable public func modifier<T>(_ modifier: T) -> ModifiedContent<Self, T> { fatalError() }
}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
extension View {

    /// Sets the container shape to use for any container relative shape
    /// within this view.
    ///
    /// The example below defines a view that shows its content with a rounded
    /// rectangle background and the same container shape. Any
    /// ``ContainerRelativeShape`` within the `content` matches the rounded
    /// rectangle shape from this container inset as appropriate.
    ///
    ///     struct PlatterContainer<Content: View> : View {
    ///         @ViewBuilder var content: Content
    ///         var body: some View {
    ///             content
    ///                 .padding()
    ///                 .containerShape(shape)
    ///                 .background(shape.fill(.background))
    ///         }
    ///         var shape: RoundedRectangle { RoundedRectangle(cornerRadius: 20) }
    ///     }
    ///
    @inlinable public func containerShape<T>(_ shape: T) -> some View where T : InsettableShape { return never() }

}

extension View {

    /// Configure the title menu of a toolbar.
    ///
    /// A title menu represent common functionality that can be done on the
    /// content represented by your app's toolbar or navigation title. This
    /// menu may be populated from your app's commands like
    /// ``CommandGroupPlacement/saveItem`` or
    /// ``CommandGroupPlacement/printItem``.
    ///
    ///     ContentView()
    ///         .toolbar {
    ///             ToolbarTitleMenu()
    ///         }
    ///
    /// You can provide your own set of actions to override this behavior.
    ///
    ///     ContentView()
    ///         .toolbarTitleMenu {
    ///             DuplicateButton()
    ///             PrintButton()
    ///         }
    ///
    /// In iOS and iPadOS, this will construct a menu that can be presented by
    /// tapping the navigation title in the app's navigation bar.
    ///
    /// - Parameter content: The content associated to the toolbar title menu.
    @available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
    public func toolbarTitleMenu<C>(@ViewBuilder content: () -> C) -> some View where C : View { return never() }

}

@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
extension View {

    /// Sets whether this view should ignore the system Smart Invert setting.
    ///
    /// Use this modifier to suppress Smart Invert in a view that shouldn't
    /// be inverted. Or pass an `active` argument of `false` to begin following
    /// the Smart Invert setting again when it was previously disabled.
    ///
    /// - Parameter active: A true value ignores the system Smart Invert
    ///   setting. A false value follows the system setting.
    @inlinable public func accessibilityIgnoresInvertColors(_ active: Bool = true) -> some View { return never() }

}

@available(iOS 17.0, macOS 14.0, xrOS 1.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension View {

    /// Sets the style for text editors within this view.
    public func textEditorStyle(_ style: some TextEditorStyle) -> some View { return never() }

}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension View {

    /// Configures whether this view participates in hit test operations.
    @inlinable public func allowsHitTesting(_ enabled: Bool) -> some View { return never() }

}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension View {

    /// Adds an action to perform before this view appears.
    ///
    /// The exact moment that SkipUI calls this method
    /// depends on the specific view type that you apply it to, but
    /// the `action` closure completes before the first
    /// rendered frame appears.
    ///
    /// - Parameter action: The action to perform. If `action` is `nil`, the
    ///   call has no effect.
    ///
    /// - Returns: A view that triggers `action` before it appears.
    @inlinable public func onAppear(perform action: (() -> Void)? = nil) -> some View { return never() }


    /// Adds an action to perform after this view disappears.
    ///
    /// The exact moment that SkipUI calls this method
    /// depends on the specific view type that you apply it to, but
    /// the `action` closure doesn't execute until the view
    /// disappears from the interface.
    ///
    /// - Parameter action: The action to perform. If `action` is `nil`, the
    ///   call has no effect.
    ///
    /// - Returns: A view that triggers `action` after it disappears.
    @inlinable public func onDisappear(perform action: (() -> Void)? = nil) -> some View { return never() }

}

@available(iOS 17.0, macOS 14.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension View {

    /// Specifies the selection effect to apply to a palette item.
    ///
    /// ``PaletteSelectionEffect/automatic`` applies the system's default
    /// appearance when selected. When using un-tinted SF Symbols or template
    /// images, the current tint color is applied to the selected items' image.
    /// If the provided SF Symbols have custom tints, a stroke is drawn around selected items.
    ///
    /// If you wish to provide a specific image (or SF Symbol) to indicate
    /// selection, use ``PaletteSelectionEffect/custom`` to forgo the system's
    /// default selection appearance allowing the provided image to solely
    /// indicate selection instead.
    ///
    /// The following example creates a palette picker that disables the
    /// system selection behavior:
    ///
    ///     Menu {
    ///         Picker("Palettes", selection: $selection) {
    ///             ForEach(palettes) { palette in
    ///                 Label(palette.title, image: selection == palette ?
    ///                       "selected-palette" : "palette")
    ///                 .tint(palette.tint)
    ///                 .tag(palette)
    ///             }
    ///         }
    ///         .pickerStyle(.palette)
    ///         .paletteSelectionEffect(.custom)
    ///     } label: {
    ///         ...
    ///     }
    ///
    /// If a specific SF Symbol variant is preferable instead, use
    /// ``PaletteSelectionEffect/symbolVariant(_:)``.
    ///
    ///     Menu {
    ///         ControlGroup {
    ///             ForEach(ColorTags.allCases) { colorTag in
    ///                 Toggle(isOn: $selectedColorTags[colorTag]) {
    ///                     Label(colorTag.name, systemImage: "circle")
    ///                 }
    ///                 .tint(colorTag.color)
    ///             }
    ///         }
    ///         .controlGroupStyle(.palette)
    ///         .paletteSelectionEffect(.symbolVariant(.fill))
    ///     }
    ///
    /// - Parameter effect: The type of effect to apply when a palette item is selected.
    public func paletteSelectionEffect(_ effect: PaletteSelectionEffect) -> some View { return never() }

}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension View where Self : Equatable {

    /// Prevents the view from updating its child view when its new value is the
    /// same as its old value.
    @inlinable public func equatable() -> EquatableView<Self> { fatalError() }
}

@available(iOS 14.0, macOS 11.0, tvOS 17.0, *)
@available(watchOS, unavailable)
extension View {

    /// Sets the style for menus within this view.
    ///
    /// To set a specific style for all menu instances within a view, use the
    /// `menuStyle(_:)` modifier:
    ///
    ///     Menu("PDF") {
    ///         Button("Open in Preview", action: openInPreview)
    ///         Button("Save as PDF", action: saveAsPDF)
    ///     }
    ///     .menuStyle(ButtonMenuStyle())
    ///
    public func menuStyle<S>(_ style: S) -> some View where S : MenuStyle { return never() }

}

@available(iOS 17.0, watchOS 10.0, *)
@available(macOS, unavailable)
@available(tvOS, unavailable)
extension View {

    /// Sets the spacing between adjacent sections in a List.
    ///
    /// Pass `.default` for the default spacing, or use `.compact` for
    /// a compact appearance between sections.
    ///
    /// The following example creates a List with compact spacing between
    /// sections:
    ///
    ///     List {
    ///         Section("Colors") {
    ///             Text("Blue")
    ///             Text("Red")
    ///         }
    ///
    ///         Section("Shapes") {
    ///             Text("Square")
    ///             Text("Circle")
    ///         }
    ///     }
    ///     .listSectionSpacing(.compact)
    @inlinable public func listSectionSpacing(_ spacing: ListSectionSpacing) -> some View { return never() }


    /// Sets the spacing to a custom value between adjacent sections in a List.
    ///
    /// The following example creates a List with 5 pts of spacing between
    /// sections:
    ///
    ///     List {
    ///         Section("Colors") {
    ///             Text("Blue")
    ///             Text("Red")
    ///         }
    ///
    ///         Section("Shapes") {
    ///             Text("Square")
    ///             Text("Circle")
    ///         }
    ///     }
    ///     .listSectionSpacing(5.0)
    ///
    /// Spacing can also be specified on a per-section basis. The following
    /// example creates a List with compact spacing for its second section:
    ///
    ///     List {
    ///         Section("Colors") {
    ///             Text("Blue")
    ///             Text("Red")
    ///         }
    ///
    ///         Section("Borders") {
    ///             Text("Dashed")
    ///             Text("Solid")
    ///         }
    ///         .listSectionSpacing(.compact)
    ///
    ///         Section("Shapes") {
    ///             Text("Square")
    ///             Text("Circle")
    ///         }
    ///     }
    ///
    /// If adjacent sections have different spacing value, the smaller value on
    /// the shared edge is used. Spacing specified inside the List is preferred
    /// over any List-wide value.
    ///
    /// - Parameter spacing: the amount of spacing to apply.
    @inlinable public func listSectionSpacing(_ spacing: CGFloat) -> some View { return never() }

}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension View {

    /// Attaches a gesture to the view with a lower precedence than gestures
    /// defined by the view.
    ///
    /// Use this method when you need to attach a gesture to a view. The
    /// example below defines a custom gesture that prints a message to the
    /// console and attaches it to the view's ``VStack``. Inside the ``VStack``
    /// a red heart ``Image`` defines its own ``TapGesture``
    /// handler that also prints a message to the console, and blue rectangle
    /// with no custom gesture handlers. Tapping or clicking the image
    /// prints a message to the console from the tap gesture handler on the
    /// image, while tapping or clicking  the rectangle inside the ``VStack``
    /// prints a message in the console from the enclosing vertical stack
    /// gesture handler.
    ///
    ///     struct GestureExample: View {
    ///         @State private var message = "Message"
    ///         let newGesture = TapGesture().onEnded {
    ///             print("Tap on VStack.")
    ///         }
    ///
    ///         var body: some View {
    ///             VStack(spacing:25) {
    ///                 Image(systemName: "heart.fill")
    ///                     .resizable()
    ///                     .frame(width: 75, height: 75)
    ///                     .padding()
    ///                     .foregroundColor(.red)
    ///                     .onTapGesture {
    ///                         print("Tap on image.")
    ///                     }
    ///                 Rectangle()
    ///                     .fill(Color.blue)
    ///             }
    ///             .gesture(newGesture)
    ///             .frame(width: 200, height: 200)
    ///             .border(Color.purple)
    ///         }
    ///     }
    ///
    /// - Parameters:
    ///    - gesture: A gesture to attach to the view.
    ///    - mask: A value that controls how adding this gesture to the view
    ///      affects other gestures recognized by the view and its subviews.
    ///      Defaults to ``SkipUI/GestureMask/all``.
    public func gesture<T>(_ gesture: T, including mask: GestureMask = .all) -> some View where T : Gesture { return never() }


    /// Attaches a gesture to the view with a higher precedence than gestures
    /// defined by the view.
    ///
    /// Use this method when you need to define a high priority gesture
    /// to take precedence over the view's existing gestures. The
    /// example below defines a custom gesture that prints a message to the
    /// console and attaches it to the view's ``VStack``. Inside the ``VStack``
    /// a red heart ``Image`` defines its own ``TapGesture`` handler that
    /// also prints a message to the console, and a blue rectangle
    /// with no custom gesture handlers. Tapping or clicking any of the
    /// views results in a console message from the high priority gesture
    /// attached to the enclosing ``VStack``.
    ///
    ///     struct HighPriorityGestureExample: View {
    ///         @State private var message = "Message"
    ///         let newGesture = TapGesture().onEnded {
    ///             print("Tap on VStack.")
    ///         }
    ///
    ///         var body: some View {
    ///             VStack(spacing:25) {
    ///                 Image(systemName: "heart.fill")
    ///                     .resizable()
    ///                     .frame(width: 75, height: 75)
    ///                     .padding()
    ///                     .foregroundColor(.red)
    ///                     .onTapGesture {
    ///                         print("Tap on image.")
    ///                     }
    ///                 Rectangle()
    ///                     .fill(Color.blue)
    ///             }
    ///             .highPriorityGesture(newGesture)
    ///             .frame(width: 200, height: 200)
    ///             .border(Color.purple)
    ///         }
    ///     }
    ///
    /// - Parameters:
    ///    - gesture: A gesture to attach to the view.
    ///    - mask: A value that controls how adding this gesture to the view
    ///      affects other gestures recognized by the view and its subviews.
    ///      Defaults to ``SkipUI/GestureMask/all``.
    public func highPriorityGesture<T>(_ gesture: T, including mask: GestureMask = .all) -> some View where T : Gesture { return never() }


    /// Attaches a gesture to the view to process simultaneously with gestures
    /// defined by the view.
    ///
    /// Use this method when you need to define and process  a view specific
    /// gesture simultaneously with the same priority as the
    /// view's existing gestures. The example below defines a custom gesture
    /// that prints a message to the console and attaches it to the view's
    /// ``VStack``. Inside the ``VStack`` is a red heart ``Image`` defines its
    /// own ``TapGesture`` handler that also prints a message to the console
    /// and a blue rectangle with no custom gesture handlers.
    ///
    /// Tapping or clicking the "heart" image sends two messages to the
    /// console: one for the image's tap gesture handler, and the other from a
    /// custom gesture handler attached to the enclosing vertical stack.
    /// Tapping or clicking on the blue rectangle results only in the single
    /// message to the console from the tap recognizer attached to the
    /// ``VStack``:
    ///
    ///     struct SimultaneousGestureExample: View {
    ///         @State private var message = "Message"
    ///         let newGesture = TapGesture().onEnded {
    ///             print("Gesture on VStack.")
    ///         }
    ///
    ///         var body: some View {
    ///             VStack(spacing:25) {
    ///                 Image(systemName: "heart.fill")
    ///                     .resizable()
    ///                     .frame(width: 75, height: 75)
    ///                     .padding()
    ///                     .foregroundColor(.red)
    ///                     .onTapGesture {
    ///                         print("Gesture on image.")
    ///                     }
    ///                 Rectangle()
    ///                     .fill(Color.blue)
    ///             }
    ///             .simultaneousGesture(newGesture)
    ///             .frame(width: 200, height: 200)
    ///             .border(Color.purple)
    ///         }
    ///     }
    ///
    /// - Parameters:
    ///    - gesture: A gesture to attach to the view.
    ///    - mask: A value that controls how adding this gesture to the view
    ///      affects other gestures recognized by the view and its subviews.
    ///      Defaults to ``SkipUI/GestureMask/all``.
    public func simultaneousGesture<T>(_ gesture: T, including mask: GestureMask = .all) -> some View where T : Gesture { return never() }

}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension View {

    /// Sets the style for buttons within this view to a button style with a
    /// custom appearance and standard interaction behavior.
    ///
    /// Use this modifier to set a specific style for all button instances
    /// within a view:
    ///
    ///     HStack {
    ///         Button("Sign In", action: signIn)
    ///         Button("Register", action: register)
    ///     }
    ///     .buttonStyle(.bordered)
    ///
    /// You can also use this modifier to set the style for controls with a button
    /// style through composition:
    ///
    ///     VStack {
    ///         Menu("Terms and Conditions") {
    ///             Button("Open in Preview", action: openInPreview)
    ///             Button("Save as PDF", action: saveAsPDF)
    ///         }
    ///         Toggle("Remember Password", isOn: $isToggleOn)
    ///         Toggle("Flag", isOn: $flagged)
    ///         Button("Sign In", action: signIn)
    ///     }
    ///     .menuStyle(.button)
    ///     .toggleStyle(.button)
    ///     .buttonStyle(.bordered)
    ///
    /// In this example, `.menuStyle(.button)` says that the Terms and
    /// Conditions menu renders as a button, while
    /// `.toggleStyle(.button)` says that the two toggles also render as
    /// buttons. Finally, `.buttonStyle(.bordered)` says that the menu,
    /// both toggles, and the Sign In button all render with the
    /// bordered button style.```
    public func buttonStyle<S>(_ style: S) -> some View where S : ButtonStyle { return never() }

}

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension View {

    /// Cycles through the given phases when the trigger value changes,
    /// updating the view using the modifiers you apply in `body`.
    ///
    /// The phases that you provide specify the individual values that will
    /// be animated to when the trigger value changes.
    ///
    /// When the view first appears, the value from the first phase is provided
    /// to the `content` closure. When the trigger value changes, the content
    /// closure is called with the value from the second phase and its
    /// corresponding animation. This continues until the last phase is
    /// reached, after which the first phase is animated to.
    ///
    /// - Parameters:
    ///   - phases: Phases defining the states that will be cycled through.
    ///     This sequence must not be empty. If an empty sequence is provided,
    ///     a visual warning will be displayed in place of this view, and a
    ///     warning will be logged.
    ///   - trigger: A value to observe for changes.
    ///   - content: A view builder closure that takes two parameters. The first
    ///     parameter is a proxy value representing the modified view. The
    ///     second parameter is the current phase.
    ///   - animation: A closure that returns the animation to use when
    ///     transitioning to the next phase. If `nil` is returned, the
    ///     transition will not be animated.
    public func phaseAnimator<Phase>(_ phases: some Sequence, trigger: some Equatable, @ViewBuilder content: @escaping (PlaceholderContentView<Self>, Phase) -> some View, animation: @escaping (Phase) -> Animation? = { _ in .default }) -> some View where Phase : Equatable { return never() }


    /// Cycles through the given phases continuously, updating the content
    /// using the view builder closure that you supply.
    ///
    /// The phases that you provide define the individual values that will
    /// be animated between.
    ///
    /// When the view first appears, the the first phase is provided
    /// to the `content` closure. The animator then immediately animates
    /// to the second phase, using an animation returned from the `animation`
    /// closure. This continues until the last phase is reached, after which
    /// the animator loops back to the beginning.
    ///
    /// - Parameters:
    ///   - phases: Phases defining the states that will be cycled through.
    ///     This sequence must not be empty. If an empty sequence is provided,
    ///     a visual warning will be displayed in place of this view, and a
    ///     warning will be logged.
    ///   - content: A view builder closure that takes two parameters. The first
    ///     parameter is a proxy value representing the modified view. The
    ///     second parameter is the current phase.
    ///   - animation: A closure that returns the animation to use when
    ///     transitioning to the next phase. If `nil` is returned, the
    ///     transition will not be animated.
    public func phaseAnimator<Phase>(_ phases: some Sequence, @ViewBuilder content: @escaping (PlaceholderContentView<Self>, Phase) -> some View, animation: @escaping (Phase) -> Animation? = { _ in .default }) -> some View where Phase : Equatable { return never() }

}

@available(iOS 15.0, *)
@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension View {

    /// Sets the vertical spacing between two adjacent rows in a List.
    ///
    /// The following example creates a List with 10 pts of spacing between each
    /// row:
    ///
    ///     List {
    ///         Text("Blue")
    ///         Text("Red")
    ///     }
    ///     .listRowSpacing(10.0)
    ///
    /// - Parameter spacing: The spacing value to use. A value of `nil` uses
    ///   the default spacing.
    @inlinable public func listRowSpacing(_ spacing: CGFloat?) -> some View { return never() }

}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension View {

    /// Sets a value for the specified preference key, the value is a
    /// function of the key's current value and a geometry value tied
    /// to the current coordinate space, allowing readers of the value
    /// to convert the geometry to their local coordinates.
    ///
    /// - Parameters:
    ///   - key: the preference key type.
    ///   - value: the geometry value in the current coordinate space.
    ///   - transform: the function to produce the preference value.
    ///
    /// - Returns: a new version of the view that writes the preference.
    @inlinable public func transformAnchorPreference<A, K>(key _: K.Type = K.self, value: Anchor<A>.Source, transform: @escaping (inout K.Value, Anchor<A>) -> Void) -> some View where K : PreferenceKey { return never() }

}

@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
extension View {

    /// Adds a reason to apply a redaction to this view hierarchy.
    ///
    /// Adding a redaction is an additive process: any redaction
    /// provided will be added to the reasons provided by the parent.
    public func redacted(reason: RedactionReasons) -> some View { return never() }


    /// Removes any reason to apply a redaction to this view hierarchy.
    public func unredacted() -> some View { return never() }

}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension View {

    /// Layers the given view behind this view.
    ///
    /// Use `background(_:alignment:)` when you need to place one view behind
    /// another, with the background view optionally aligned with a specified
    /// edge of the frontmost view.
    ///
    /// The example below creates two views: the `Frontmost` view, and the
    /// `DiamondBackground` view. The `Frontmost` view uses the
    /// `DiamondBackground` view for the background of the image element inside
    /// the `Frontmost` view's ``VStack``.
    ///
    ///     struct DiamondBackground: View {
    ///         var body: some View {
    ///             VStack {
    ///                 Rectangle()
    ///                     .fill(.gray)
    ///                     .frame(width: 250, height: 250, alignment: .center)
    ///                     .rotationEffect(.degrees(45.0))
    ///             }
    ///         }
    ///     }
    ///
    ///     struct Frontmost: View {
    ///         var body: some View {
    ///             VStack {
    ///                 Image(systemName: "folder")
    ///                     .font(.system(size: 128, weight: .ultraLight))
    ///                     .background(DiamondBackground())
    ///             }
    ///         }
    ///     }
    ///
    /// ![A view showing a large folder image with a gray diamond placed behind
    /// it as its background view.](View-background-1)
    ///
    /// - Parameters:
    ///   - background: The view to draw behind this view.
    ///   - alignment: The alignment with a default value of
    ///     ``Alignment/center`` that you use to position the background view.
    @available(iOS, introduced: 13.0, deprecated: 100000.0, message: "Use `background(alignment:content:)` instead.")
    @available(macOS, introduced: 10.15, deprecated: 100000.0, message: "Use `background(alignment:content:)` instead.")
    @available(tvOS, introduced: 13.0, deprecated: 100000.0, message: "Use `background(alignment:content:)` instead.")
    @available(watchOS, introduced: 6.0, deprecated: 100000.0, message: "Use `background(alignment:content:)` instead.")
    @available(xrOS, introduced: 1.0, deprecated: 100000.0, message: "Use `background(alignment:content:)` instead.")
    @inlinable public func background<Background>(_ background: Background, alignment: Alignment = .center) -> some View where Background : View { return never() }

}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
extension View {

    /// Layers the views that you specify behind this view.
    ///
    /// Use this modifier to place one or more views behind another view.
    /// For example, you can place a collection of stars beind a ``Text`` view:
    ///
    ///     Text("ABCDEF")
    ///         .background(alignment: .leading) { Star(color: .red) }
    ///         .background(alignment: .center) { Star(color: .green) }
    ///         .background(alignment: .trailing) { Star(color: .blue) }
    ///
    /// The example above assumes that you've defined a `Star` view with a
    /// parameterized color:
    ///
    ///     struct Star: View {
    ///         var color: Color
    ///
    ///         var body: some View {
    ///             Image(systemName: "star.fill")
    ///                 .foregroundStyle(color)
    ///         }
    ///     }
    ///
    /// By setting different `alignment` values for each modifier, you make the
    /// stars appear in different places behind the text:
    ///
    /// ![A screenshot of the letters A, B, C, D, E, and F written in front of
    /// three stars. The stars, from left to right, are red, green, and
    /// blue.](View-background-2)
    ///
    /// If you specify more than one view in the `content` closure, the modifier
    /// collects all of the views in the closure into an implicit ``ZStack``,
    /// taking them in order from back to front. For example, you can layer a
    /// vertical bar behind a circle, with both of those behind a horizontal
    /// bar:
    ///
    ///     Color.blue
    ///         .frame(width: 200, height: 10) // Creates a horizontal bar.
    ///         .background {
    ///             Color.green
    ///                 .frame(width: 10, height: 100) // Creates a vertical bar.
    ///             Circle()
    ///                 .frame(width: 50, height: 50)
    ///         }
    ///
    /// Both the background modifier and the implicit ``ZStack`` composed from
    /// the background content --- the circle and the vertical bar --- use a
    /// default ``Alignment/center`` alignment. The vertical bar appears
    /// centered behind the circle, and both appear as a composite view centered
    /// behind the horizontal bar:
    ///
    /// ![A screenshot of a circle with a horizontal blue bar layered on top
    /// and a vertical green bar layered underneath. All of the items are center
    /// aligned.](View-background-3)
    ///
    /// If you specify an alignment for the background, it applies to the
    /// implicit stack rather than to the individual views in the closure. You
    /// can see this if you add the ``Alignment/leading`` alignment:
    ///
    ///     Color.blue
    ///         .frame(width: 200, height: 10)
    ///         .background(alignment: .leading) {
    ///             Color.green
    ///                 .frame(width: 10, height: 100)
    ///             Circle()
    ///                 .frame(width: 50, height: 50)
    ///         }
    ///
    /// The vertical bar and the circle move as a unit to align the stack
    /// with the leading edge of the horizontal bar, while the
    /// vertical bar remains centered on the circle:
    ///
    /// ![A screenshot of a horizontal blue bar in front of a circle, which
    /// is in front of a vertical green bar. The horizontal bar and the circle
    /// are center aligned with each other; the left edges of the circle
    /// and the horizontal are aligned.](View-background-3a)
    ///
    /// To control the placement of individual items inside the `content`
    /// closure, either use a different background modifier for each item, as
    /// the earlier example of stars under text demonstrates, or add an explicit
    /// ``ZStack`` inside the content closure with its own alignment:
    ///
    ///     Color.blue
    ///         .frame(width: 200, height: 10)
    ///         .background(alignment: .leading) {
    ///             ZStack(alignment: .leading) {
    ///                 Color.green
    ///                     .frame(width: 10, height: 100)
    ///                 Circle()
    ///                     .frame(width: 50, height: 50)
    ///             }
    ///         }
    ///
    /// The stack alignment ensures that the circle's leading edge aligns with
    /// the vertical bar's, while the background modifier aligns the composite
    /// view with the horizontal bar:
    ///
    /// ![A screenshot of a horizontal blue bar in front of a circle, which
    /// is in front of a vertical green bar. All items are aligned on their
    /// left edges.](View-background-4)
    ///
    /// You can achieve layering without a background modifier by putting both
    /// the modified view and the background content into a ``ZStack``. This
    /// produces a simpler view hierarchy, but it changes the layout priority
    /// that SkipUI applies to the views. Use the background modifier when you
    /// want the modified view to dominate the layout.
    ///
    /// If you want to specify a ``ShapeStyle`` like a
    /// ``HierarchicalShapeStyle`` or a ``Material`` as the background, use
    /// ``View/background(_:ignoresSafeAreaEdges:)`` instead.
    /// To specify a ``Shape`` or ``InsettableShape``, use
    /// ``View/background(_:in:fillStyle:)-89n7j`` or
    /// ``View/background(_:in:fillStyle:)-20tq5``, respectively.
    /// To configure the background of a presentation, like a sheet, use
    /// ``View/presentationBackground(alignment:content:)``.
    ///
    /// - Parameters:
    ///   - alignment: The alignment that the modifier uses to position the
    ///     implicit ``ZStack`` that groups the background views. The default
    ///     is ``Alignment/center``.
    ///   - content: A ``ViewBuilder`` that you use to declare the views to draw
    ///     behind this view, stacked in a cascading order from bottom to top.
    ///     The last view that you list appears at the front of the stack.
    ///
    /// - Returns: A view that uses the specified content as a background.
    @inlinable public func background<V>(alignment: Alignment = .center, @ViewBuilder content: () -> V) -> some View where V : View { return never() }


    /// Sets the view's background to the default background style.
    ///
    /// This modifier behaves like ``View/background(_:ignoresSafeAreaEdges:)``,
    /// except that it always uses the ``ShapeStyle/background`` shape style.
    /// For example, you can add a background to a ``Label``:
    ///
    ///     ZStack {
    ///         Color.teal
    ///         Label("Flag", systemImage: "flag.fill")
    ///             .padding()
    ///             .background()
    ///     }
    ///
    /// Without the background modifier, the teal color behind the label shows
    /// through the label. With the modifier, the label's text and icon appear
    /// backed by a region filled with a color that's appropriate for light
    /// or dark appearance:
    ///
    /// ![A screenshot of a flag icon and the word flag inside a rectangle; the
    /// rectangle is filled with the background color and layered on top of a
    /// larger rectangle that's filled with the color teal.](View-background-7)
    ///
    /// If you want to specify a ``View`` or a stack of views as the background,
    /// use ``View/background(alignment:content:)`` instead.
    /// To specify a ``Shape`` or ``InsettableShape``, use
    /// ``View/background(_:in:fillStyle:)-89n7j`` or
    /// ``View/background(_:in:fillStyle:)-20tq5``, respectively.
    /// To configure the background of a presentation, like a sheet, use
    /// ``View/presentationBackground(_:)``.
    ///
    /// - Parameters:
    ///   - edges: The set of edges for which to ignore safe area insets
    ///     when adding the background. The default value is ``Edge/Set/all``.
    ///     Specify an empty set to respect safe area insets on all edges.
    ///
    /// - Returns: A view with the ``ShapeStyle/background`` shape style
    ///   drawn behind it.
    @inlinable public func background(ignoresSafeAreaEdges edges: Edge.Set = .all) -> some View { return never() }


    /// Sets the view's background to a style.
    ///
    /// Use this modifier to place a type that conforms to the ``ShapeStyle``
    /// protocol --- like a ``Color``, ``Material``, or
    /// ``HierarchicalShapeStyle`` --- behind a view. For example, you can add
    /// the ``ShapeStyle/regularMaterial`` behind a ``Label``:
    ///
    ///     struct FlagLabel: View {
    ///         var body: some View {
    ///             Label("Flag", systemImage: "flag.fill")
    ///                 .padding()
    ///                 .background(.regularMaterial)
    ///         }
    ///     }
    ///
    /// SkipUI anchors the style to the view's bounds. For the example above,
    /// the background fills the entirety of the label's frame, which includes
    /// the padding:
    ///
    /// ![A screenshot of a flag symbol and the word flag layered over a
    /// gray rectangle.](View-background-5)
    ///
    /// SkipUI limits the background style's extent to the modified view's
    /// container-relative shape. You can see this effect if you constrain the
    /// `FlagLabel` view with a ``View/containerShape(_:)`` modifier:
    ///
    ///     FlagLabel()
    ///         .containerShape(RoundedRectangle(cornerRadius: 16))
    ///
    /// The background takes on the specified container shape:
    ///
    /// ![A screenshot of a flag symbol and the word flag layered over a
    /// gray rectangle with rounded corners.](View-background-6)
    ///
    /// By default, the background ignores safe area insets on all edges, but
    /// you can provide a specific set of edges to ignore, or an empty set to
    /// respect safe area insets on all edges:
    ///
    ///     Rectangle()
    ///         .background(
    ///             .regularMaterial,
    ///             ignoresSafeAreaEdges: []) // Ignore no safe area insets.
    ///
    /// If you want to specify a ``View`` or a stack of views as the background,
    /// use ``View/background(alignment:content:)`` instead.
    /// To specify a ``Shape`` or ``InsettableShape``, use
    /// ``View/background(_:in:fillStyle:)-89n7j`` or
    /// ``View/background(_:in:fillStyle:)-20tq5``, respectively.
    /// To configure the background of a presentation, like a sheet, use
    /// ``View/presentationBackground(_:)``.
    ///
    /// - Parameters:
    ///   - style: An instance of a type that conforms to ``ShapeStyle`` that
    ///     SkipUI draws behind the modified view.
    ///   - edges: The set of edges for which to ignore safe area insets
    ///     when adding the background. The default value is ``Edge/Set/all``.
    ///     Specify an empty set to respect safe area insets on all edges.
    ///
    /// - Returns: A view with the specified style drawn behind it.
    @inlinable public func background<S>(_ style: S, ignoresSafeAreaEdges edges: Edge.Set = .all) -> some View where S : ShapeStyle { return never() }


    /// Sets the view's background to a shape filled with the
    /// default background style.
    ///
    /// This modifier behaves like ``View/background(_:in:fillStyle:)-89n7j``,
    /// except that it always uses the ``ShapeStyle/background`` shape style
    /// to fill the specified shape. For example, you can create a ``Path``
    /// that outlines a trapezoid:
    ///
    ///     let trapezoid = Path { path in
    ///         path.move(to: .zero)
    ///         path.addLine(to: CGPoint(x: 90, y: 0))
    ///         path.addLine(to: CGPoint(x: 80, y: 50))
    ///         path.addLine(to: CGPoint(x: 10, y: 50))
    ///     }
    ///
    /// Then you can use that shape as a background for a ``Label``:
    ///
    ///     ZStack {
    ///         Color.teal
    ///         Label("Flag", systemImage: "flag.fill")
    ///             .padding()
    ///             .background(in: trapezoid)
    ///     }
    ///
    /// Without the background modifier, the fill color shows
    /// through the label. With the modifier, the label's text and icon appear
    /// backed by a shape filled with a color that's appropriate for light
    /// or dark appearance:
    ///
    /// ![A screenshot of a flag icon and the word flag inside a trapezoid; the
    /// trapezoid is filled with the background color and layered on top of
    /// a rectangle filled with the color teal.](View-background-B)
    ///
    /// To create a background with other ``View`` types --- or with a stack
    /// of views --- use ``View/background(alignment:content:)`` instead.
    /// To add a ``ShapeStyle`` as a background, use
    /// ``View/background(_:ignoresSafeAreaEdges:)``.
    ///
    /// - Parameters:
    ///   - shape: An instance of a type that conforms to ``Shape`` that
    ///     SkipUI draws behind the view using the ``ShapeStyle/background``
    ///     shape style.
    ///   - fillStyle: The ``FillStyle`` to use when drawing the shape.
    ///     The default style uses the nonzero winding number rule and
    ///     antialiasing.
    ///
    /// - Returns: A view with the specified shape drawn behind it.
    @inlinable public func background<S>(in shape: S, fillStyle: FillStyle = FillStyle()) -> some View where S : Shape { return never() }


    /// Sets the view's background to a shape filled with a style.
    ///
    /// Use this modifier to layer a type that conforms to the ``Shape``
    /// protocol behind a view. Specify the ``ShapeStyle`` that's used to
    /// fill the shape. For example, you can create a ``Path`` that outlines
    /// a trapezoid:
    ///
    ///     let trapezoid = Path { path in
    ///         path.move(to: .zero)
    ///         path.addLine(to: CGPoint(x: 90, y: 0))
    ///         path.addLine(to: CGPoint(x: 80, y: 50))
    ///         path.addLine(to: CGPoint(x: 10, y: 50))
    ///     }
    ///
    /// Then you can use that shape as a background for a ``Label``:
    ///
    ///     Label("Flag", systemImage: "flag.fill")
    ///         .padding()
    ///         .background(.teal, in: trapezoid)
    ///
    /// The ``ShapeStyle/teal`` color fills the shape:
    ///
    /// ![A screenshot of the flag icon and the word flag inside a trapezoid;
    /// The trapezoid is filled with the color teal.](View-background-A)
    ///
    /// This modifier and ``View/background(_:in:fillStyle:)-20tq5`` are
    /// convenience methods for placing a single shape behind a view. To
    /// create a background with other ``View`` types --- or with a stack
    /// of views --- use ``View/background(alignment:content:)`` instead.
    /// To add a ``ShapeStyle`` as a background, use
    /// ``View/background(_:ignoresSafeAreaEdges:)``.
    ///
    /// - Parameters:
    ///   - style: A ``ShapeStyle`` that SkipUI uses to the fill the shape
    ///     that you specify.
    ///   - shape: An instance of a type that conforms to ``Shape`` that
    ///     SkipUI draws behind the view.
    ///   - fillStyle: The ``FillStyle`` to use when drawing the shape.
    ///     The default style uses the nonzero winding number rule and
    ///     antialiasing.
    ///
    /// - Returns: A view with the specified shape drawn behind it.
    @inlinable public func background<S, T>(_ style: S, in shape: T, fillStyle: FillStyle = FillStyle()) -> some View where S : ShapeStyle, T : Shape { return never() }


    /// Sets the view's background to an insettable shape filled with the
    /// default background style.
    ///
    /// This modifier behaves like ``View/background(_:in:fillStyle:)-20tq5``,
    /// except that it always uses the ``ShapeStyle/background`` shape style
    /// to fill the specified insettable shape. For example, you can use
    /// a ``RoundedRectangle`` as a background on a ``Label``:
    ///
    ///     ZStack {
    ///         Color.teal
    ///         Label("Flag", systemImage: "flag.fill")
    ///             .padding()
    ///             .background(in: RoundedRectangle(cornerRadius: 8))
    ///     }
    ///
    /// Without the background modifier, the fill color shows
    /// through the label. With the modifier, the label's text and icon appear
    /// backed by a shape filled with a color that's appropriate for light
    /// or dark appearance:
    ///
    /// ![A screenshot of a flag icon and the word flag inside a rectangle with
    /// rounded corners; the rectangle is filled with the background color, and
    /// is layered on top of a larger rectangle that's filled with the color
    /// teal.](View-background-9)
    ///
    /// To create a background with other ``View`` types --- or with a stack
    /// of views --- use ``View/background(alignment:content:)`` instead.
    /// To add a ``ShapeStyle`` as a background, use
    /// ``View/background(_:ignoresSafeAreaEdges:)``.
    ///
    /// - Parameters:
    ///   - shape: An instance of a type that conforms to ``InsettableShape``
    ///     that SkipUI draws behind the view using the
    ///     ``ShapeStyle/background`` shape style.
    ///   - fillStyle: The ``FillStyle`` to use when drawing the shape.
    ///     The default style uses the nonzero winding number rule and
    ///     antialiasing.
    ///
    /// - Returns: A view with the specified insettable shape drawn behind it.
    @inlinable public func background<S>(in shape: S, fillStyle: FillStyle = FillStyle()) -> some View where S : InsettableShape { return never() }


    /// Sets the view's background to an insettable shape filled with a style.
    ///
    /// Use this modifier to layer a type that conforms to the
    /// ``InsettableShape`` protocol --- like a ``Rectangle``, ``Circle``, or
    /// ``Capsule`` --- behind a view. Specify the ``ShapeStyle`` that's used to
    /// fill the shape. For example, you can place a ``RoundedRectangle``
    /// behind a ``Label``:
    ///
    ///     Label("Flag", systemImage: "flag.fill")
    ///         .padding()
    ///         .background(.teal, in: RoundedRectangle(cornerRadius: 8))
    ///
    /// The ``ShapeStyle/teal`` color fills the shape:
    ///
    /// ![A screenshot of the flag icon and word on a teal rectangle with
    /// rounded corners.](View-background-8)
    ///
    /// This modifier and ``View/background(_:in:fillStyle:)-89n7j`` are
    /// convenience methods for placing a single shape behind a view. To
    /// create a background with other ``View`` types --- or with a stack
    /// of views --- use ``View/background(alignment:content:)`` instead.
    /// To add a ``ShapeStyle`` as a background, use
    /// ``View/background(_:ignoresSafeAreaEdges:)``.
    ///
    /// - Parameters:
    ///   - style: A ``ShapeStyle`` that SkipUI uses to the fill the shape
    ///     that you specify.
    ///   - shape: An instance of a type that conforms to ``InsettableShape``
    ///     that SkipUI draws behind the view.
    ///   - fillStyle: The ``FillStyle`` to use when drawing the shape.
    ///     The default style uses the nonzero winding number rule and
    ///     antialiasing.
    ///
    /// - Returns: A view with the specified insettable shape drawn behind it.
    @inlinable public func background<S, T>(_ style: S, in shape: T, fillStyle: FillStyle = FillStyle()) -> some View where S : ShapeStyle, T : InsettableShape { return never() }

}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension View {

    /// Layers a secondary view in front of this view.
    ///
    /// When you apply an overlay to a view, the original view continues to
    /// provide the layout characteristics for the resulting view. In the
    /// following example, the heart image is shown overlaid in front of, and
    /// aligned to the bottom of the folder image.
    ///
    ///     Image(systemName: "folder")
    ///         .font(.system(size: 55, weight: .thin))
    ///         .overlay(Text("❤️"), alignment: .bottom)
    ///
    /// ![View showing placement of a heart overlaid onto a folder
    /// icon.](View-overlay-1)
    ///
    /// - Parameters:
    ///   - overlay: The view to layer in front of this view.
    ///   - alignment: The alignment for `overlay` in relation to this view.
    ///
    /// - Returns: A view that layers `overlay` in front of the view.
    @available(iOS, introduced: 13.0, deprecated: 100000.0, message: "Use `overlay(alignment:content:)` instead.")
    @available(macOS, introduced: 10.15, deprecated: 100000.0, message: "Use `overlay(alignment:content:)` instead.")
    @available(tvOS, introduced: 13.0, deprecated: 100000.0, message: "Use `overlay(alignment:content:)` instead.")
    @available(watchOS, introduced: 6.0, deprecated: 100000.0, message: "Use `overlay(alignment:content:)` instead.")
    @available(xrOS, introduced: 1.0, deprecated: 100000.0, message: "Use `overlay(alignment:content:)` instead.")
    @inlinable public func overlay<Overlay>(_ overlay: Overlay, alignment: Alignment = .center) -> some View where Overlay : View { return never() }


    /// Adds a border to this view with the specified style and width.
    ///
    /// Use this modifier to draw a border of a specified width around the
    /// view's frame. By default, the border appears inside the bounds of this
    /// view. For example, you can add a four-point wide border covers the text:
    ///
    ///     Text("Purple border inside the view bounds.")
    ///         .border(Color.purple, width: 4)
    ///
    /// ![A screenshot showing the text Purple border inside the view bounds.
    /// The text is surrounded by a purple border that outlines the text,
    /// but isn't quite big enough and encroaches on the text.](View-border-1)
    ///
    /// To place a border around the outside of this view, apply padding of the
    /// same width before adding the border:
    ///
    ///     Text("Purple border outside the view bounds.")
    ///         .padding(4)
    ///         .border(Color.purple, width: 4)
    ///
    /// ![A screenshot showing the text Purple border outside the view bounds.
    /// The text is surrounded by a purple border that outlines the text
    /// without touching the text.](View-border-2)
    ///
    /// - Parameters:
    ///   - content: A value that conforms to the ``ShapeStyle`` protocol,
    ///     like a ``Color`` or ``HierarchicalShapeStyle``, that SkipUI
    ///     uses to fill the border.
    ///   - width: The thickness of the border. The default is 1 pixel.
    ///
    /// - Returns: A view that adds a border with the specified style and width
    ///   to this view.
    @inlinable public func border<S>(_ content: S, width: CGFloat = 1) -> some View where S : ShapeStyle { return never() }

}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
extension View {

    /// Layers the views that you specify in front of this view.
    ///
    /// Use this modifier to place one or more views in front of another view.
    /// For example, you can place a group of stars on a ``RoundedRectangle``:
    ///
    ///     RoundedRectangle(cornerRadius: 8)
    ///         .frame(width: 200, height: 100)
    ///         .overlay(alignment: .topLeading) { Star(color: .red) }
    ///         .overlay(alignment: .topTrailing) { Star(color: .yellow) }
    ///         .overlay(alignment: .bottomLeading) { Star(color: .green) }
    ///         .overlay(alignment: .bottomTrailing) { Star(color: .blue) }
    ///
    /// The example above assumes that you've defined a `Star` view with a
    /// parameterized color:
    ///
    ///     struct Star: View {
    ///         var color = Color.yellow
    ///
    ///         var body: some View {
    ///             Image(systemName: "star.fill")
    ///                 .foregroundStyle(color)
    ///         }
    ///     }
    ///
    /// By setting different `alignment` values for each modifier, you make the
    /// stars appear in different places on the rectangle:
    ///
    /// ![A screenshot of a rounded rectangle with a star in each corner. The
    /// star in the upper-left is red; the start in the upper-right is yellow;
    /// the star in the lower-left is green; the star the lower-right is
    /// blue.](View-overlay-2)
    ///
    /// If you specify more than one view in the `content` closure, the modifier
    /// collects all of the views in the closure into an implicit ``ZStack``,
    /// taking them in order from back to front. For example, you can place a
    /// star and a ``Circle`` on a field of ``ShapeStyle/blue``:
    ///
    ///     Color.blue
    ///         .frame(width: 200, height: 200)
    ///         .overlay {
    ///             Circle()
    ///                 .frame(width: 100, height: 100)
    ///             Star()
    ///         }
    ///
    /// Both the overlay modifier and the implicit ``ZStack`` composed from the
    /// overlay content --- the circle and the star --- use a default
    /// ``Alignment/center`` alignment. The star appears centered on the circle,
    /// and both appear as a composite view centered in front of the square:
    ///
    /// ![A screenshot of a star centered on a circle, which is
    /// centered on a square.](View-overlay-3)
    ///
    /// If you specify an alignment for the overlay, it applies to the implicit
    /// stack rather than to the individual views in the closure. You can see
    /// this if you add the ``Alignment/bottom`` alignment:
    ///
    ///     Color.blue
    ///         .frame(width: 200, height: 200)
    ///         .overlay(alignment: .bottom) {
    ///             Circle()
    ///                 .frame(width: 100, height: 100)
    ///             Star()
    ///         }
    ///
    /// The circle and the star move down as a unit to align the stack's bottom
    /// edge with the bottom edge of the square, while the star remains
    /// centered on the circle:
    ///
    /// ![A screenshot of a star centered on a circle, which is on a square.
    /// The circle's bottom edge is aligned with the square's bottom
    /// edge.](View-overlay-3a)
    ///
    /// To control the placement of individual items inside the `content`
    /// closure, either use a different overlay modifier for each item, as the
    /// earlier example of stars in the corners of a rectangle demonstrates, or
    /// add an explicit ``ZStack`` inside the content closure with its own
    /// alignment:
    ///
    ///     Color.blue
    ///         .frame(width: 200, height: 200)
    ///         .overlay(alignment: .bottom) {
    ///             ZStack(alignment: .bottom) {
    ///                 Circle()
    ///                     .frame(width: 100, height: 100)
    ///                 Star()
    ///             }
    ///         }
    ///
    /// The stack alignment ensures that the star's bottom edge aligns with the
    /// circle's, while the overlay aligns the composite view with the square:
    ///
    /// ![A screenshot of a star, a circle, and a square with all their
    /// bottom edges aligned.](View-overlay-4)
    ///
    /// You can achieve layering without an overlay modifier by putting both the
    /// modified view and the overlay content into a ``ZStack``. This can
    /// produce a simpler view hierarchy, but changes the layout priority that
    /// SkipUI applies to the views. Use the overlay modifier when you want the
    /// modified view to dominate the layout.
    ///
    /// If you want to specify a ``ShapeStyle`` like a ``Color`` or a
    /// ``Material`` as the overlay, use
    /// ``View/overlay(_:ignoresSafeAreaEdges:)`` instead. To specify a
    /// ``Shape``, use ``View/overlay(_:in:fillStyle:)``.
    ///
    /// - Parameters:
    ///   - alignment: The alignment that the modifier uses to position the
    ///     implicit ``ZStack`` that groups the foreground views. The default
    ///     is ``Alignment/center``.
    ///   - content: A ``ViewBuilder`` that you use to declare the views to
    ///     draw in front of this view, stacked in the order that you list them.
    ///     The last view that you list appears at the front of the stack.
    ///
    /// - Returns: A view that uses the specified content as a foreground.
    @inlinable public func overlay<V>(alignment: Alignment = .center, @ViewBuilder content: () -> V) -> some View where V : View { return never() }


    /// Layers the specified style in front of this view.
    ///
    /// Use this modifier to layer a type that conforms to the ``ShapeStyle``
    /// protocol, like a ``Color``, ``Material``, or ``HierarchicalShapeStyle``,
    /// in front of a view. For example, you can overlay the
    /// ``ShapeStyle/ultraThinMaterial`` over a ``Circle``:
    ///
    ///     struct CoveredCircle: View {
    ///         var body: some View {
    ///             Circle()
    ///                 .frame(width: 300, height: 200)
    ///                 .overlay(.ultraThinMaterial)
    ///         }
    ///     }
    ///
    /// SkipUI anchors the style to the view's bounds. For the example above,
    /// the overlay fills the entirety of the circle's frame (which happens
    /// to be wider than the circle is tall):
    ///
    /// ![A screenshot of a circle showing through a rectangle that imposes
    /// a blurring effect.](View-overlay-5)
    ///
    /// SkipUI also limits the style's extent to the view's
    /// container-relative shape. You can see this effect if you constrain the
    /// `CoveredCircle` view with a ``View/containerShape(_:)`` modifier:
    ///
    ///     CoveredCircle()
    ///         .containerShape(RoundedRectangle(cornerRadius: 30))
    ///
    /// The overlay takes on the specified container shape:
    ///
    /// ![A screenshot of a circle showing through a rounded rectangle that
    /// imposes a blurring effect.](View-overlay-6)
    ///
    /// By default, the overlay ignores safe area insets on all edges, but you
    /// can provide a specific set of edges to ignore, or an empty set to
    /// respect safe area insets on all edges:
    ///
    ///     Rectangle()
    ///         .overlay(
    ///             .secondary,
    ///             ignoresSafeAreaEdges: []) // Ignore no safe area insets.
    ///
    /// If you want to specify a ``View`` or a stack of views as the overlay
    /// rather than a style, use ``View/overlay(alignment:content:)`` instead.
    /// If you want to specify a ``Shape``, use
    /// ``View/overlay(_:in:fillStyle:)``.
    ///
    /// - Parameters:
    ///   - style: An instance of a type that conforms to ``ShapeStyle`` that
    ///     SkipUI layers in front of the modified view.
    ///   - edges: The set of edges for which to ignore safe area insets
    ///     when adding the overlay. The default value is ``Edge/Set/all``.
    ///     Specify an empty set to respect safe area insets on all edges.
    ///
    /// - Returns: A view with the specified style drawn in front of it.
    @inlinable public func overlay<S>(_ style: S, ignoresSafeAreaEdges edges: Edge.Set = .all) -> some View where S : ShapeStyle { return never() }


    /// Layers a shape that you specify in front of this view.
    ///
    /// Use this modifier to layer a type that conforms to the ``Shape``
    /// protocol --- like a ``Rectangle``, ``Circle``, or ``Capsule`` --- in
    /// front of a view. Specify a ``ShapeStyle`` that's used to fill the shape.
    /// For example, you can overlay the outline of one rectangle in front of
    /// another:
    ///
    ///     Rectangle()
    ///         .frame(width: 200, height: 100)
    ///         .overlay(.teal, in: Rectangle().inset(by: 10).stroke(lineWidth: 5))
    ///
    /// The example above uses the ``InsettableShape/inset(by:)`` method to
    /// slightly reduce the size of the overlaid rectangle, and the
    /// ``Shape/stroke(lineWidth:)`` method to fill only the shape's outline.
    /// This creates an inset border:
    ///
    /// ![A screenshot of a rectangle with a teal border that's
    /// inset from the edge.](View-overlay-7)
    ///
    /// This modifier is a convenience method for layering a shape over a view.
    /// To handle the more general case of overlaying a ``View`` --- or a stack
    /// of views --- with control over the position, use
    /// ``View/overlay(alignment:content:)`` instead. To cover a view with a
    /// ``ShapeStyle``, use ``View/overlay(_:ignoresSafeAreaEdges:)``.
    ///
    /// - Parameters:
    ///   - style: A ``ShapeStyle`` that SkipUI uses to the fill the shape
    ///     that you specify.
    ///   - shape: An instance of a type that conforms to ``Shape`` that
    ///     SkipUI draws in front of the view.
    ///   - fillStyle: The ``FillStyle`` to use when drawing the shape.
    ///     The default style uses the nonzero winding number rule and
    ///     antialiasing.
    ///
    /// - Returns: A view with the specified shape drawn in front of it.
    @inlinable public func overlay<S, T>(_ style: S, in shape: T, fillStyle: FillStyle = FillStyle()) -> some View where S : ShapeStyle, T : Shape { return never() }

}

extension View {

    /// Tells a menu whether to dismiss after performing an action.
    ///
    /// Use this modifier to control the dismissal behavior of a menu.
    /// In the example below, the menu doesn't dismiss after someone
    /// chooses either the increase or decrease action:
    ///
    ///     Menu("Font size") {
    ///         Button(action: increase) {
    ///             Label("Increase", systemImage: "plus.magnifyingglass")
    ///         }
    ///         .menuActionDismissBehavior(.disabled)
    ///
    ///         Button("Reset", action: reset)
    ///
    ///         Button(action: decrease) {
    ///             Label("Decrease", systemImage: "minus.magnifyingglass")
    ///         }
    ///         .menuActionDismissBehavior(.disabled)
    ///     }
    ///
    /// You can use this modifier on any controls that present a menu, like a
    /// ``Picker`` that uses the ``PickerStyle/menu`` style or a
    /// ``ControlGroup``. For example, the code below creates a picker that
    /// disables dismissal when someone selects one of the options:
    ///
    ///     Picker("Flavor", selection: $selectedFlavor) {
    ///         ForEach(Flavor.allCases) { flavor in
    ///             Text(flavor.rawValue.capitalized)
    ///                 .tag(flavor)
    ///         }
    ///     }
    ///     .pickerStyle(.menu)
    ///     .menuActionDismissBehavior(.disabled)
    ///
    /// You can also use this modifier on context menus. The example below
    /// creates a context menu that stays presented after someone selects an
    /// action to run:
    ///
    ///     Text("Favorite Card Suit")
    ///         .padding()
    ///         .contextMenu {
    ///             Button("♥️ - Hearts", action: increaseHeartsCount)
    ///             Button("♣️ - Clubs", action: increaseClubsCount)
    ///             Button("♠️ - Spades", action: increaseSpadesCount)
    ///             Button("♦️ - Diamonds", action: increaseDiamondsCount)
    ///         }
    ///         .menuActionDismissBehavior(.disabled)
    ///
    /// - Parameter dismissal: The menu action dismissal behavior to apply.
    ///
    /// - Returns: A view that has the specified menu dismissal behavior.
    @available(iOS 16.4, macOS 13.3, tvOS 16.4, watchOS 9.4, *)
    public func menuActionDismissBehavior(_ behavior: MenuActionDismissBehavior) -> some View { return never() }

}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension View {

    /// Constrains this view's dimensions to the specified aspect ratio.
    ///
    /// Use `aspectRatio(_:contentMode:)` to constrain a view's dimensions to an
    /// aspect ratio specified by a
    ///  using the specified
    /// content mode.
    ///
    /// If this view is resizable, the resulting view will have `aspectRatio` as
    /// its aspect ratio. In this example, the purple ellipse has a 3:4
    /// width-to-height ratio, and scales to fit its frame:
    ///
    ///     Ellipse()
    ///         .fill(Color.purple)
    ///         .aspectRatio(0.75, contentMode: .fit)
    ///         .frame(width: 200, height: 200)
    ///         .border(Color(white: 0.75))
    ///
    /// ![A view showing a purple ellipse that has a 3:4 width-to-height ratio,
    /// and scales to fit its frame.](SkipUI-View-aspectRatio-cgfloat.png)
    ///
    /// - Parameters:
    ///   - aspectRatio: The ratio of width to height to use for the resulting
    ///     view. Use `nil` to maintain the current aspect ratio in the
    ///     resulting view.
    ///   - contentMode: A flag that indicates whether this view fits or fills
    ///     the parent context.
    ///
    /// - Returns: A view that constrains this view's dimensions to the aspect
    ///   ratio of the given size using `contentMode` as its scaling algorithm.
    @inlinable public func aspectRatio(_ aspectRatio: CGFloat? = nil, contentMode: ContentMode) -> some View { return never() }


    /// Constrains this view's dimensions to the aspect ratio of the given size.
    ///
    /// Use `aspectRatio(_:contentMode:)` to constrain a view's dimensions to
    /// an aspect ratio specified by a
    /// .
    ///
    /// If this view is resizable, the resulting view uses `aspectRatio` as its
    /// own aspect ratio. In this example, the purple ellipse has a 3:4
    /// width-to-height ratio, and scales to fill its frame:
    ///
    ///     Ellipse()
    ///         .fill(Color.purple)
    ///         .aspectRatio(CGSize(width: 3, height: 4), contentMode: .fill)
    ///         .frame(width: 200, height: 200)
    ///         .border(Color(white: 0.75))
    ///
    /// ![A view showing a purple ellipse that has a 3:4 width-to-height ratio,
    /// and scales to fill its frame.](SkipUI-View-aspectRatio.png)
    ///
    /// - Parameters:
    ///   - aspectRatio: A size that specifies the ratio of width to height to
    ///     use for the resulting view.
    ///   - contentMode: A flag indicating whether this view should fit or fill
    ///     the parent context.
    ///
    /// - Returns: A view that constrains this view's dimensions to
    ///   `aspectRatio`, using `contentMode` as its scaling algorithm.
    @inlinable public func aspectRatio(_ aspectRatio: CGSize, contentMode: ContentMode) -> some View { return never() }


    /// Scales this view to fit its parent.
    ///
    /// Use `scaledToFit()` to scale this view to fit its parent, while
    /// maintaining the view's aspect ratio as the view scales.
    ///
    ///     Circle()
    ///         .fill(Color.pink)
    ///         .scaledToFit()
    ///         .frame(width: 300, height: 150)
    ///         .border(Color(white: 0.75))
    ///
    /// ![A screenshot of pink circle scaled to fit its
    /// frame.](SkipUI-View-scaledToFit-1.png)
    ///
    /// This method is equivalent to calling
    /// ``View/aspectRatio(_:contentMode:)-6j7xz`` with a `nil` aspectRatio and
    /// a content mode of ``ContentMode/fit``.
    ///
    /// - Returns: A view that scales this view to fit its parent, maintaining
    ///   this view's aspect ratio.
    @inlinable public func scaledToFit() -> some View { return never() }


    /// Scales this view to fill its parent.
    ///
    /// Use `scaledToFill()` to scale this view to fill its parent, while
    /// maintaining the view's aspect ratio as the view scales:
    ///
    ///     Circle()
    ///         .fill(Color.pink)
    ///         .scaledToFill()
    ///         .frame(width: 300, height: 150)
    ///         .border(Color(white: 0.75))
    ///
    /// ![A screenshot of pink circle scaled to fill its
    /// frame.](SkipUI-View-scaledToFill-1.png)
    ///
    /// This method is equivalent to calling
    /// ``View/aspectRatio(_:contentMode:)-6j7xz`` with a `nil` aspectRatio and
    /// a content mode of ``ContentMode/fill``.
    ///
    /// - Returns: A view that scales this view to fill its parent, maintaining
    ///   this view's aspect ratio.
    @inlinable public func scaledToFill() -> some View { return never() }

}

extension View {

    /// Associates a binding to be updated when a scroll view within this
    /// view scrolls.
    ///
    /// Use this modifier along with the ``View/scrollTargetLayout()``
    /// modifier to know the identity of the view that is actively scrolled.
    /// As the scroll view scrolls, the binding will be updated with the
    /// identity of the leading-most / top-most view.
    ///
    /// Use the ``View/scrollTargetLayout()`` modifier to configure
    /// which the layout that contains your scroll targets. In the following
    /// example, the top-most ItemView will update with the scrolledID
    /// binding as the scroll view scrolls.
    ///
    ///     @Binding var items: [Item]
    ///     @Binding var scrolledID: Item.ID?
    ///
    ///     ScrollView {
    ///         LazyVStack {
    ///             ForEach(items) { item in
    ///                 ItemView(item)
    ///             }
    ///         }
    ///         .scrollTargetLayout()
    ///     }
    ///     .scrollPosition(id: $scrolledID)
    ///
    /// You can write to the binding to scroll to the view with
    /// the provided identity.
    ///
    ///     @Binding var items: [Item]
    ///     @Binding var scrolledID: Item.ID?
    ///
    ///     ScrollView {
    ///         // ...
    ///     }
    ///     .scrollPosition(id: $scrolledID)
    ///     .toolbar {
    ///         Button("Scroll to Top") {
    ///             scrolledID = items.first
    ///         }
    ///     }
    ///
    /// SkipUI will attempt to keep the view with the identity specified
    /// in the provided binding when events occur that might cause it
    /// to be scrolled out of view by the system. Some examples of these
    /// include:
    ///   - The data backing the content of a scroll view is re-ordered.
    ///   - The size of the scroll view changes, like when a window is resized
    ///     on macOS or during a rotation on iOS.
    ///   - The scroll view initially lays out it content defaulting to
    ///     the top most view, but the binding has a different view's identity.
    ///
    @available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
    public func scrollPosition(id: Binding<(some Hashable)?>) -> some View { return never() }

}

extension View {

    /// Associates an anchor to control which part of the scroll view's
    /// content should be initially rendered.
    ///
    /// Use this modifier to specify an anchor to control which part of
    /// the scroll view's content should be initially visible.
    ///
    /// Provide a value of `UnitPoint/center`` to have the scroll
    /// view start in the center of its content when a scroll view
    /// is scrollable in both axes.
    ///
    ///     ScrollView([.horizontal, .vertical]) {
    ///         // initially centered content
    ///     }
    ///     .scrollPosition(initialAnchor: .center)
    ///
    /// Provide a value of `UnitPoint/bottom` to have the scroll view
    /// start at the bottom of its content when scrollable in the
    /// vertical axis.
    ///
    ///     @Binding var items: [Item]
    ///     @Binding var scrolledID: Item.ID?
    ///
    ///     ScrollView {
    ///         LazyVStack {
    ///             ForEach(items) { item in
    ///                 ItemView(item)
    ///             }
    ///         }
    ///     }
    ///     .scrollPosition(initialAnchor: .bottom)
    ///
    /// Once the user scrolls the scroll view, the value provided to this
    /// modifier will have no effect.
    ///
    @available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
    public func scrollPosition(initialAnchor: UnitPoint?) -> some View { return never() }

}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension View {

    /// Fixes this view at its ideal size in the specified dimensions.
    ///
    /// This function behaves like ``View/fixedSize()``, except with
    /// `fixedSize(horizontal:vertical:)` the fixing of the axes can be
    /// optionally specified in one or both dimensions. For example, if you
    /// horizontally fix a text view before wrapping it in the frame view,
    /// you're telling the text view to maintain its ideal _width_. The view
    /// calculates this to be the space needed to represent the entire string.
    ///
    ///     Text("A single line of text, too long to fit in a box.")
    ///         .fixedSize(horizontal: true, vertical: false)
    ///         .frame(width: 200, height: 200)
    ///         .border(Color.gray)
    ///
    /// This can result in the view exceeding the parent's bounds, which may or
    /// may not be the effect you want.
    ///
    /// ![A screenshot showing a text view exceeding the bounds of its
    /// parent.](SkipUI-View-fixedSize-3.png)
    ///
    /// - Parameters:
    ///   - horizontal: A Boolean value that indicates whether to fix the width
    ///     of the view.
    ///   - vertical: A Boolean value that indicates whether to fix the height
    ///     of the view.
    ///
    /// - Returns: A view that fixes this view at its ideal size in the
    ///   dimensions specified by `horizontal` and `vertical`.
    @inlinable public func fixedSize(horizontal: Bool, vertical: Bool) -> some View { return never() }


    /// Fixes this view at its ideal size.
    ///
    /// During the layout of the view hierarchy, each view proposes a size to
    /// each child view it contains. If the child view doesn't need a fixed size
    /// it can accept and conform to the size offered by the parent.
    ///
    /// For example, a ``Text`` view placed in an explicitly sized frame wraps
    /// and truncates its string to remain within its parent's bounds:
    ///
    ///     Text("A single line of text, too long to fit in a box.")
    ///         .frame(width: 200, height: 200)
    ///         .border(Color.gray)
    ///
    /// ![A screenshot showing the text in a text view contained within its
    /// parent.](SkipUI-View-fixedSize-1.png)
    ///
    /// The `fixedSize()` modifier can be used to create a view that maintains
    /// the *ideal size* of its children both dimensions:
    ///
    ///     Text("A single line of text, too long to fit in a box.")
    ///         .fixedSize()
    ///         .frame(width: 200, height: 200)
    ///         .border(Color.gray)
    ///
    /// This can result in the view exceeding the parent's bounds, which may or
    /// may not be the effect you want.
    ///
    /// ![A screenshot showing a text view exceeding the bounds of its
    /// parent.](SkipUI-View-fixedSize-2.png)
    ///
    /// You can think of `fixedSize()` as the creation of a *counter proposal*
    /// to the view size proposed to a view by its parent. The ideal size of a
    /// view, and the specific effects of `fixedSize()` depends on the
    /// particular view and how you have configured it.
    ///
    /// To create a view that fixes the view's size in either the horizontal or
    /// vertical dimensions, see ``View/fixedSize(horizontal:vertical:)``.
    ///
    /// - Returns: A view that fixes this view at its ideal size.
    @inlinable public func fixedSize() -> some View { return never() }

}

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension View {

    /// Sets the spring loading behavior this view.
    ///
    /// Spring loading refers to a view being activated during a drag and drop
    /// interaction. On iOS this can occur when pausing briefly on top of a
    /// view with dragged content. On macOS this can occur with similar brief
    /// pauses or on pressure-sensitive systems by "force clicking" during the
    /// drag. This has no effect on tvOS or watchOS.
    ///
    /// This is commonly used with views that have a navigation or presentation
    /// effect, allowing the destination to be revealed without pausing the
    /// drag interaction. For example, a button that reveals a list of folders
    /// that a dragged item can be dropped onto.
    ///
    ///     Button {
    ///         showFolders = true
    ///     } label: {
    ///         Label("Show Folders", systemImage: "folder")
    ///     }
    ///     .springLoadingBehavior(.enabled)
    ///
    /// Unlike `disabled(_:)`, this modifier overrides the value set by an
    /// ancestor view rather than being unioned with it. For example, the below
    /// button would allow spring loading:
    ///
    ///     HStack {
    ///         Button {
    ///             showFolders = true
    ///         } label: {
    ///             Label("Show Folders", systemImage: "folder")
    ///         }
    ///         .springLoadingBehavior(.enabled)
    ///
    ///         ...
    ///     }
    ///     .springLoadingBehavior(.disabled)
    ///
    /// - Parameter behavior: Whether spring loading is enabled or not. If
    ///   unspecified, the default behavior is `.automatic.`
    @inlinable public func springLoadingBehavior(_ behavior: SpringLoadingBehavior) -> some View { return never() }

}

@available(iOS 13.0, macOS 10.15, tvOS 14.0, *)
@available(watchOS, introduced: 6.0, deprecated: 7.0)
extension View {

    /// Adds a context menu to a view.
    ///
    /// Use this modifier to add a context menu to a view in your app's
    /// user interface. Compose the menu by returning controls like ``Button``,
    /// ``Toggle``, and ``Picker`` from the `menuItems` closure. You can also
    /// use ``Menu`` to define submenus or ``Section`` to group items.
    ///
    /// The following example creates a ``Text`` view that has a context menu
    /// with two buttons:
    ///
    ///     Text("Turtle Rock")
    ///         .padding()
    ///         .contextMenu {
    ///             Button {
    ///                 // Add this item to a list of favorites.
    ///             } label: {
    ///                 Label("Add to Favorites", systemImage: "heart")
    ///             }
    ///             Button {
    ///                 // Open Maps and center it on this item.
    ///             } label: {
    ///                 Label("Show in Maps", systemImage: "mappin")
    ///             }
    ///         }
    ///
    /// People can activate the menu with an action like Control-clicking, or
    /// by using the touch and hold gesture in iOS and iPadOS:
    ///
    /// ![A screenshot of a context menu showing two menu items: Add to
    /// Favorites, and Show in Maps.](View-contextMenu-1-iOS)
    ///
    /// The system dismisses the menu if someone makes a selection, or taps
    /// or clicks outside the menu.
    ///
    /// If you want to show a preview beside the menu, use
    /// ``View/contextMenu(menuItems:preview:)``. To add a context menu to a
    /// container that supports selection, like a ``List`` or a ``Table``, and
    /// to distinguish between menu activation on a selection and
    /// activation in an empty area of the container, use
    /// ``View/contextMenu(forSelectionType:menu:primaryAction:)``.
    ///
    /// - Parameter menuItems: A closure that produces the menu's contents. You
    ///   can deactivate the context menu by returning nothing from the closure.
    ///
    /// - Returns: A view that can display a context menu.
    public func contextMenu<MenuItems>(@ViewBuilder menuItems: () -> MenuItems) -> some View where MenuItems : View { return never() }

}

@available(iOS 16.0, macOS 13.0, tvOS 16.0, *)
@available(watchOS, unavailable)
extension View {

    /// Adds a context menu with a preview to a view.
    ///
    /// When you use this modifer to add a context menu to a view in your
    /// app's user interface, the system shows a preview beside the menu.
    /// Compose the menu by returning controls like ``Button``, ``Toggle``, and
    /// ``Picker`` from the `menuItems` closure. You can also use ``Menu`` to
    /// define submenus or ``Section`` to group items.
    ///
    /// Define the preview by returning a view from the `preview` closure. The
    /// system sizes the preview to match the size of its content. For example,
    /// you can add a two button context menu to a ``Text`` view, and include
    /// an ``Image`` as a preview:
    ///
    ///     Text("Turtle Rock")
    ///         .padding()
    ///         .contextMenu {
    ///             Button {
    ///                 // Add this item to a list of favorites.
    ///             } label: {
    ///                 Label("Add to Favorites", systemImage: "heart")
    ///             }
    ///             Button {
    ///                 // Open Maps and center it on this item.
    ///             } label: {
    ///                 Label("Show in Maps", systemImage: "mappin")
    ///             }
    ///         } preview: {
    ///             Image("turtlerock") // Loads the image from an asset catalog.
    ///         }
    ///
    /// When someone activates the context menu with an action like touch and
    /// hold in iOS or iPadOS, the system displays the image and the menu:
    ///
    /// ![A screenshot of a context menu with two buttons that are labeled
    /// Add to Favorites, and Show in Maps. An image of a Joshua Tree appears
    /// above the menu.](View-contextMenu-2-iOS)
    ///
    /// > Note: This view modifier produces a context menu on macOS, but that
    /// platform doesn't display the preview.
    ///
    /// If you don't need a preview, use ``View/contextMenu(menuItems:)``
    /// instead. If you want to add a context menu to a container that supports
    /// selection, like a ``List`` or a ``Table``, and you want to distinguish
    /// between menu activation on a selection and activation in an empty area
    /// of the container, use
    /// ``View/contextMenu(forSelectionType:menu:primaryAction:)``.
    ///
    /// - Parameters:
    ///   - menuItems: A closure that produces the menu's contents. You can
    ///     deactivate the context menu by returning nothing from the closure.
    ///   - preview: A view that the system displays along with the menu.
    ///
    /// - Returns: A view that can display a context menu with a preview.
    public func contextMenu<M, P>(@ViewBuilder menuItems: () -> M, @ViewBuilder preview: () -> P) -> some View where M : View, P : View { return never() }

}

@available(iOS, introduced: 13.0, deprecated: 100000.0, message: "Use `contextMenu(menuItems:)` instead.")
@available(macOS, introduced: 10.15, deprecated: 100000.0, message: "Use `contextMenu(menuItems:)` instead.")
@available(tvOS, unavailable)
@available(watchOS, introduced: 6.0, deprecated: 7.0)
extension View {

    /// Adds a context menu to the view.
    ///
    /// Use this method to attach a specified context menu to a view.
    /// You can make the context menu unavailable by conditionally passing `nil`
    /// as the value for the `contextMenu`.
    ///
    /// The example below creates a ``ContextMenu`` that contains two items and
    /// passes them into the modifier. The Boolean value `shouldShowMenu`,
    /// which defaults to `true`, controls the context menu availability:
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
    ///
    /// - Parameter contextMenu: A context menu container for views that you
    ///   present as menu items in a context menu.
    ///
    /// - Returns: A view that can show a context menu.
    public func contextMenu<MenuItems>(_ contextMenu: ContextMenu<MenuItems>?) -> some View where MenuItems : View { return never() }

}

extension View {

    /// Sets the maximum number of lines that text can occupy in this view.
    ///
    /// Use this modifier to cap the number of lines that an individual text
    /// element can display.
    ///
    /// The line limit applies to all ``Text`` instances within a hierarchy. For
    /// example, an ``HStack`` with multiple pieces of text longer than three
    /// lines caps each piece of text to three lines rather than capping the
    /// total number of lines across the ``HStack``.
    ///
    /// In the example below, the modifier limits the very long
    /// line in the ``Text`` element to the 2 lines that fit within the view's
    /// bounds:
    ///
    ///     Text("This is a long string that demonstrates the effect of SkipUI's lineLimit(:_) operator.")
    ///         .frame(width: 200, height: 200, alignment: .leading)
    ///         .lineLimit(2)
    ///
    /// ![A screenshot showing showing the effect of the line limit operator on
    /// a very long string in a view.](SkipUI-view-lineLimit.png)
    ///
    /// - Parameter number: The line limit. If `nil`, no line limit applies.
    ///
    /// - Returns: A view that limits the number of lines that ``Text``
    ///   instances display.
    @available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
    @inlinable public func lineLimit(_ number: Int?) -> some View { return never() }


    /// Sets to a partial range the number of lines that text can occupy in
    /// this view.
    ///
    /// Use this modifier to specify a partial range of lines that a ``Text``
    /// view or a vertical ``TextField`` can occupy. When the text of such
    /// views occupies less space than the provided limit, that view expands to
    /// occupy the minimum number of lines.
    ///
    ///     Form {
    ///         TextField("Title", text: $model.title)
    ///         TextField("Notes", text: $model.notes, axis: .vertical)
    ///             .lineLimit(3...)
    ///     }
    ///
    /// - Parameter limit: The line limit.
    @available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
    public func lineLimit(_ limit: PartialRangeFrom<Int>) -> some View { return never() }


    /// Sets to a partial range the number of lines that text can occupy
    /// in this view.
    ///
    /// Use this modifier to specify a partial range of lines that a
    /// ``Text`` view or a vertical ``TextField`` can occupy. When the text of
    /// such views occupies more space than the provided limit, a ``Text`` view
    /// truncates its content while a ``TextField`` becomes scrollable.
    ///
    ///     Form {
    ///         TextField("Title", text: $model.title)
    ///         TextField("Notes", text: $model.notes, axis: .vertical)
    ///             .lineLimit(...3)
    ///     }
    ///
    /// > Note: This modifier is equivalent to the ``View/lineLimit(_:)-513mb``
    /// modifier taking just an integer.
    ///
    /// - Parameter limit: The line limit.
    @available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
    public func lineLimit(_ limit: PartialRangeThrough<Int>) -> some View { return never() }


    /// Sets to a closed range the number of lines that text can occupy in
    /// this view.
    ///
    /// Use this modifier to specify a closed range of lines that a ``Text``
    /// view or a vertical ``TextField`` can occupy. When the text of such
    /// views occupies more space than the provided limit, a ``Text`` view
    /// truncates its content while a ``TextField`` becomes scrollable.
    ///
    ///     Form {
    ///         TextField("Title", text: $model.title)
    ///         TextField("Notes", text: $model.notes, axis: .vertical)
    ///             .lineLimit(1...3)
    ///     }
    ///
    /// - Parameter limit: The line limit.
    @available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
    public func lineLimit(_ limit: ClosedRange<Int>) -> some View { return never() }


    /// Sets a limit for the number of lines text can occupy in this view.
    ///
    /// Use this modifier to specify a limit to the lines that a
    /// ``Text`` or a vertical ``TextField`` may occupy. If passed a
    /// value of true for the `reservesSpace` parameter, and the text of such
    /// views occupies less space than the provided limit, that view expands
    /// to occupy the minimum number of lines. When the text occupies
    /// more space than the provided limit, a ``Text`` view truncates its
    /// content while a ``TextField`` becomes scrollable.
    ///
    ///     GroupBox {
    ///         Text("Title")
    ///             .font(.headline)
    ///             .lineLimit(2, reservesSpace: true)
    ///         Text("Subtitle")
    ///             .font(.subheadline)
    ///             .lineLimit(4, reservesSpace: true)
    ///     }
    ///
    /// - Parameter limit: The line limit.
    /// - Parameter reservesSpace: Whether text reserves space so that
    ///   it always occupies the height required to display the specified
    ///   number of lines.
    @available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
    public func lineLimit(_ limit: Int, reservesSpace: Bool) -> some View { return never() }

}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
extension View {

    /// Sets the header prominence for this view.
    ///
    /// In the following example, the section header appears with increased
    /// prominence:
    ///
    ///     List {
    ///         Section(header: Text("Header")) {
    ///             Text("Row")
    ///         }
    ///         .headerProminence(.increased)
    ///     }
    ///     .listStyle(.insetGrouped)
    ///
    /// - Parameter prominence: The prominence to apply.
    public func headerProminence(_ prominence: Prominence) -> some View { return never() }

}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension View {

    /// Sets the style for pickers within this view.
    public func pickerStyle<S>(_ style: S) -> some View where S : PickerStyle { return never() }

}

@available(iOS 15.0, macOS 12.0, tvOS 17.0, *)
@available(watchOS, unavailable)
extension View {

    /// Sets the menu indicator visibility for controls within this view.
    ///
    /// Use this modifier to override the default menu indicator
    /// visibility for controls in this view. For example, the code below
    /// creates a menu without an indicator:
    ///
    ///     Menu {
    ///         ForEach(history , id: \.self) { historyItem in
    ///             Button(historyItem.title) {
    ///                 self.openURL(historyItem.url)
    ///             }
    ///         }
    ///     } label: {
    ///         Label("Back", systemImage: "chevron.backward")
    ///             .labelStyle(.iconOnly)
    ///     } primaryAction: {
    ///         if let last = history.last {
    ///             self.openURL(last.url)
    ///         }
    ///     }
    ///     .menuIndicator(.hidden)
    ///
    /// - Note: On tvOS, the standard button styles do not include a menu
    ///         indicator, so this modifier will have no effect when using a
    ///         built-in button style. You can implement an indicator in your
    ///         own ``ButtonStyle`` implementation by checking the value of the
    ///         `menuIndicatorVisibility` environment value.
    ///
    /// - Parameter visibility: The menu indicator visibility to apply.
    @inlinable public func menuIndicator(_ visibility: Visibility) -> some View { return never() }

}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension View {

    /// Adds a different padding amount to each edge of this view.
    ///
    /// Use this modifier to add a different amount of padding on each edge
    /// of a view:
    ///
    ///     VStack {
    ///         Text("Text padded by different amounts on each edge.")
    ///             .padding(EdgeInsets(top: 10, leading: 20, bottom: 40, trailing: 0))
    ///             .border(.gray)
    ///         Text("Unpadded text for comparison.")
    ///             .border(.yellow)
    ///     }
    ///
    /// The order in which you apply modifiers matters. The example above
    /// applies the padding before applying the border to ensure that the
    /// border encompasses the padded region:
    ///
    /// ![A screenshot of two text strings arranged vertically, each surrounded
    /// by a border, with a small space between the two borders.
    /// The first string says Text padded by different amounts on each edge.
    /// Its border is gray, and there are different amounts of space between
    /// the string and its border on each edge: 40 points on the bottom, 10
    /// points on the top, 20 points on the leading edge, and no space on
    /// the trailing edge.
    /// The second string says Unpadded text for comparison.
    /// Its border is yellow, and there's no space between the string
    /// and its border.](View-padding-3-iOS)
    ///
    /// To pad a view on specific edges with equal padding for all padded
    /// edges, use ``View/padding(_:_:)``. To pad all edges of a view
    /// equally, use ``View/padding(_:)-68shk``.
    ///
    /// - Parameter insets: An ``EdgeInsets`` instance that contains
    ///   padding amounts for each edge.
    ///
    /// - Returns: A view that's padded by different amounts on each edge.
    @inlinable public func padding(_ insets: EdgeInsets) -> some View { return never() }


    /// Adds an equal padding amount to specific edges of this view.
    ///
    /// Use this modifier to add a specified amount of padding to one or more
    /// edges of the view. Indicate the edges to pad by naming either a single
    /// value from ``Edge/Set``, or by specifying an
    /// that contains edge values:
    ///
    ///     VStack {
    ///         Text("Text padded by 20 points on the bottom and trailing edges.")
    ///             .padding([.bottom, .trailing], 20)
    ///             .border(.gray)
    ///         Text("Unpadded text for comparison.")
    ///             .border(.yellow)
    ///     }
    ///
    /// The order in which you apply modifiers matters. The example above
    /// applies the padding before applying the border to ensure that the
    /// border encompasses the padded region:
    ///
    /// ![A screenshot of two text strings arranged vertically, each surrounded
    /// by a border, with a small space between the two borders.
    /// The first string says Text padded by 20 points
    /// on the bottom and trailing edges.
    /// Its border is gray, and there are 20 points of space between the bottom
    /// and trailing edges of the string and its border.
    /// There's no space between the string and the border on the other edges.
    /// The second string says Unpadded text for comparison.
    /// Its border is yellow, and there's no space between the string
    /// and its border.](View-padding-2-iOS)
    ///
    /// You can omit either or both of the parameters. If you omit the `length`,
    /// SkipUI uses a default amount of padding. If you
    /// omit the `edges`, SkipUI applies the padding to all edges. Omit both
    /// to add a default padding all the way around a view. SkipUI chooses a
    /// default amount of padding that's appropriate for the platform and
    /// the presentation context.
    ///
    ///     VStack {
    ///         Text("Text with default padding.")
    ///             .padding()
    ///             .border(.gray)
    ///         Text("Unpadded text for comparison.")
    ///             .border(.yellow)
    ///     }
    ///
    /// The example above looks like this in iOS under typical conditions:
    ///
    /// ![A screenshot of two text strings arranged vertically, each surrounded
    /// by a border, with a small space between the two borders.
    /// The first string says Text with default padding.
    /// Its border is gray, and there is padding on all sides
    /// between the border and the string it encloses in an amount that's
    /// similar to the height of the text.
    /// The second string says Unpadded text for comparison.
    /// Its border is yellow, and there's no space between the string
    /// and its border.](View-padding-2a-iOS)
    ///
    /// To control the amount of padding independently for each edge, use
    /// ``View/padding(_:)-6pgqq``. To pad all outside edges of a view by a
    /// specified amount, use ``View/padding(_:)-68shk``.
    ///
    /// - Parameters:
    ///   - edges: The set of edges to pad for this view. The default
    ///     is ``Edge/Set/all``.
    ///   - length: An amount, given in points, to pad this view on the
    ///     specified edges. If you set the value to `nil`, SkipUI uses
    ///     a platform-specific default amount. The default value of this
    ///     parameter is `nil`.
    ///
    /// - Returns: A view that's padded by the specified amount on the
    ///   specified edges.
    @inlinable public func padding(_ edges: Edge.Set = .all, _ length: CGFloat? = nil) -> some View { return never() }


    /// Adds a specific padding amount to each edge of this view.
    ///
    /// Use this modifier to add padding all the way around a view.
    ///
    ///     VStack {
    ///         Text("Text padded by 10 points on each edge.")
    ///             .padding(10)
    ///             .border(.gray)
    ///         Text("Unpadded text for comparison.")
    ///             .border(.yellow)
    ///     }
    ///
    /// The order in which you apply modifiers matters. The example above
    /// applies the padding before applying the border to ensure that the
    /// border encompasses the padded region:
    ///
    /// ![A screenshot of two text strings arranged vertically, each surrounded
    /// by a border, with a small space between the two borders.
    /// The first string says Text padded by 10 points on each edge.
    /// Its border is gray, and there are 10 points of space on all sides
    /// between the string and its border.
    /// The second string says Unpadded text for comparison.
    /// Its border is yellow, and there's no space between the string
    /// and its border.](View-padding-1-iOS)
    ///
    /// To independently control the amount of padding for each edge, use
    /// ``View/padding(_:)-6pgqq``. To pad a select set of edges by the
    /// same amount, use ``View/padding(_:_:)``.
    ///
    /// - Parameter length: The amount, given in points, to pad this view on all
    ///   edges.
    ///
    /// - Returns: A view that's padded by the amount you specify.
    @inlinable public func padding(_ length: CGFloat) -> some View { return never() }

}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
extension View {

    /// Adds padding to the specified edges of this view using an amount that's
    /// appropriate for the current scene.
    ///
    /// Use this modifier to add a scene-appropriate amount of padding to a
    /// view. Specify either a single edge value from ``Edge/Set``, or an
    ///  that
    /// describes the edges to pad.
    ///
    /// In macOS, use scene padding to produce the recommended spacing around
    /// the root view of a window. In watchOS, use scene padding to align
    /// elements of your user interface with top level elements, like the title
    /// of a navigation view. For example, compare the effects of different
    /// kinds of padding on text views presented inside a ``NavigationView``
    /// in watchOS:
    ///
    ///     VStack(alignment: .leading, spacing: 10) {
    ///         Text("Scene padding")
    ///             .scenePadding(.horizontal)
    ///             .border(.red) // Border added for reference.
    ///         Text("Regular padding")
    ///             .padding(.horizontal)
    ///             .border(.green)
    ///         Text("Text with no padding")
    ///             .border(.blue)
    ///         Button("Button") { }
    ///     }
    ///     .navigationTitle("Hello World")
    ///
    /// The text with scene padding automatically aligns with the title,
    /// unlike the text that uses the default padding or the text without
    /// padding:
    ///
    /// ![A watchOS screenshot with the title Hello World and a back button
    /// in the upper left. The title is indented by a small amount from
    /// the leading edge of the screen. Three bordered strings and a button
    /// appear arranged vertically below the title.
    /// The first string says Scene padding and has a red border that's aligned
    /// with the leading edge of the screen. The leading
    /// edge of the string inside the border aligns with the leading edge of
    /// the screen's title.
    /// The second string says Regular padding and has a green border that's
    /// aligned with the leading edge of the screen. The leading edge of the
    /// string appears offset from the title's leading edge by a small amount.
    /// The third string says Text with no padding and has a blue border that's
    /// aligned with the leading edge of the screen. The string is also aligned
    /// with the leading edge of the screen.](View-scenePadding-1-watchOS)
    ///
    /// Scene padding in watchOS also ensures that your content avoids the
    /// curved edges of a device like Apple Watch Series 7.
    /// In other platforms, scene padding produces the same default padding that
    /// you get from the ``View/padding(_:_:)`` modifier.
    ///
    /// > Important: Scene padding doesn't pad the top and bottom edges of a
    /// view in watchOS, even if you specify those edges as part of the input.
    /// For example, if you specify ``Edge/Set/vertical`` instead of
    /// ``Edge/Set/horizontal`` in the example above, the modifier would have
    /// no effect in watchOS. It does, however, apply to all the edges that you
    /// specify in other platforms.
    ///
    /// - Parameter edges: The set of edges along which to pad this view.
    ///
    /// - Returns: A view that's padded on specified edges by a
    ///   scene-appropriate amount.
    public func scenePadding(_ edges: Edge.Set = .all) -> some View { return never() }


    /// Adds a specified kind of padding to the specified edges of this view
    /// using an amount that's appropriate for the current scene.
    ///
    /// Use this modifier to add a scene-appropriate amount of padding to a
    /// view. Specify either a single edge value from ``Edge/Set``, or an
    ///  that
    /// describes the edges to pad.
    ///
    /// In macOS, use scene padding to produce the recommended spacing around
    /// the root view of a window. In watchOS, use scene padding to align
    /// elements of your user interface with top level elements, like the title
    /// of a navigation view. For example, compare the effects of different
    /// kinds of padding on text views presented inside a ``NavigationView``
    /// in watchOS:
    ///
    ///     VStack(alignment: .leading, spacing: 10) {
    ///         Text("Minimum Scene padding")
    ///             .scenePadding(.minimum, edges: .horizontal)
    ///             .border(.red) // Border added for reference.
    ///         Text("Navigation Bar Scene padding")
    ///             .scenePadding(.navigationBar, edges: .horizontal)
    ///             .border(.yellow)
    ///         Text("Regular padding")
    ///             .padding(.horizontal)
    ///             .border(.green)
    ///         Text("Text with no padding")
    ///             .border(.blue)
    ///         Button("Button") { }
    ///     }
    ///     .navigationTitle("Hello World")
    ///
    /// The text with minimum scene padding uses the system minimum padding
    /// and the text with navigation bar scene padding automatically aligns
    /// with the navigation bar content. In contrast, the text that uses the
    /// default padding and the text without padding do not align with scene
    /// elements.
    ///
    /// Scene padding in watchOS also ensures that your content avoids the
    /// curved edges of a device like Apple Watch Series 7.
    /// In other platforms, scene padding produces the same default padding that
    /// you get from the ``View/padding(_:_:)`` modifier.
    ///
    /// > Important: Scene padding doesn't pad the top and bottom edges of a
    /// view in watchOS, even if you specify those edges as part of the input.
    /// For example, if you specify ``Edge/Set/vertical`` instead of
    /// ``Edge/Set/horizontal`` in the example above, the modifier would have
    /// no effect in watchOS. It does, however, apply to all the edges that you
    /// specify in other platforms.
    ///
    /// - Parameter padding: The kind of padding to add.
    /// - Parameter edges: The set of edges along which to pad this view.
    ///
    /// - Returns: A view that's padded on specified edges by a
    ///   scene-appropriate amount.
    @available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
    public func scenePadding(_ padding: ScenePadding, edges: Edge.Set = .all) -> some View { return never() }

}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension View {

    /// Offset this view by the horizontal and vertical amount specified in the
    /// offset parameter.
    ///
    /// Use `offset(_:)` to shift the displayed contents by the amount
    /// specified in the `offset` parameter.
    ///
    /// The original dimensions of the view aren't changed by offsetting the
    /// contents; in the example below the gray border drawn by this view
    /// surrounds the original position of the text:
    ///
    ///     Text("Offset by passing CGSize()")
    ///         .border(Color.green)
    ///         .offset(CGSize(width: 20, height: 25))
    ///         .border(Color.gray)
    ///
    /// ![A screenshot showing a view that offset from its original position a
    /// CGPoint to specify the x and y offset.](SkipUI-View-offset.png)
    ///
    /// - Parameter offset: The distance to offset this view.
    ///
    /// - Returns: A view that offsets this view by `offset`.
    @inlinable public func offset(_ offset: CGSize) -> some View { return never() }


    /// Offset this view by the specified horizontal and vertical distances.
    ///
    /// Use `offset(x:y:)` to shift the displayed contents by the amount
    /// specified in the `x` and `y` parameters.
    ///
    /// The original dimensions of the view aren't changed by offsetting the
    /// contents; in the example below the gray border drawn by this view
    /// surrounds the original position of the text:
    ///
    ///     Text("Offset by passing horizontal & vertical distance")
    ///         .border(Color.green)
    ///         .offset(x: 20, y: 50)
    ///         .border(Color.gray)
    ///
    /// ![A screenshot showing a view that offset from its original position
    /// using and x and y offset.](skipui-offset-xy.png)
    ///
    /// - Parameters:
    ///   - x: The horizontal distance to offset this view.
    ///   - y: The vertical distance to offset this view.
    ///
    /// - Returns: A view that offsets this view by `x` and `y`.
    @inlinable public func offset(x: CGFloat = 0, y: CGFloat = 0) -> some View { return never() }

}

extension View {

    /// Configures the search scopes for this view.
    ///
    /// To enable people to narrow the scope of their searches, you can
    /// create a type that represents the possible scopes, and then create a
    /// state variable to hold the current selection. For example, you can
    /// scope the product search to just fruits or just vegetables:
    ///
    ///     enum ProductScope {
    ///         case fruit
    ///         case vegetable
    ///     }
    ///
    ///     @State private var scope: ProductScope = .fruit
    ///
    /// Provide a binding to the scope, as well as a view that represents each
    /// scope:
    ///
    ///     ProductList()
    ///         .searchable(text: $text, tokens: $tokens) { token in
    ///             switch token {
    ///             case .apple: Text("Apple")
    ///             case .pear: Text("Pear")
    ///             case .banana: Text("Banana")
    ///             }
    ///         }
    ///         .searchScopes($scope) {
    ///             Text("Fruit").tag(ProductScope.fruit)
    ///             Text("Vegetable").tag(ProductScope.vegetable)
    ///         }
    ///
    /// SkipUI uses this binding and view to add a ``Picker`` with the search
    /// field. In iOS, iPadOS, macOS, and tvOS, the picker appears below the
    /// search field when search is active. To ensure that the picker operates
    /// correctly, match the type of the scope binding with the type of each
    /// view's tag. Then modify your search to account for the current value of
    /// the `scope` state property.
    ///
    /// For more information about using searchable modifiers, see
    /// <doc:Adding-a-search-interface-to-your-app>.
    ///
    /// - Parameters:
    ///   - scope: The active scope of the search field.
    ///   - scopes: A view builder that represents the scoping options
    ///     SkipUI uses to populate a ``Picker``.
    @available(iOS 16.0, macOS 13.0, tvOS 16.4, *)
    @available(watchOS, unavailable)
    public func searchScopes<V, S>(_ scope: Binding<V>, @ViewBuilder scopes: () -> S) -> some View where V : Hashable, S : View { return never() }

}

extension View {

    /// Configures the search scopes for this view with the specified
    /// activation strategy.
    ///
    /// To enable people to narrow the scope of their searches, you can
    /// create a type that represents the possible scopes, and then create a
    /// state variable to hold the current selection. For example, you can
    /// scope the product search to just fruits or just vegetables:
    ///
    ///     enum ProductScope {
    ///         case fruit
    ///         case vegetable
    ///     }
    ///
    ///     @State private var scope: ProductScope = .fruit
    ///
    /// Provide a binding to the scope, as well as a view that represents each
    /// scope:
    ///
    ///     ProductList()
    ///         .searchable(text: $text, tokens: $tokens) { token in
    ///             switch token {
    ///             case .apple: Text("Apple")
    ///             case .pear: Text("Pear")
    ///             case .banana: Text("Banana")
    ///             }
    ///         }
    ///         .searchScopes($scope) {
    ///             Text("Fruit").tag(ProductScope.fruit)
    ///             Text("Vegetable").tag(ProductScope.vegetable)
    ///         }
    ///
    /// SkipUI uses this binding and view to add a ``Picker`` below the search
    /// field. In iOS, macOS, and tvOS, the picker appears below the search
    /// field when search is active. To ensure that the picker operates
    /// correctly, match the type of the scope binding with the type of each
    /// view's tag. Then condition your search on the current value of the
    /// `scope` state property.
    ///
    /// By default, the appearance of scopes varies by platform:
    ///   - In iOS and iPadOS, search scopes appear when someone enters text
    ///     into the search field and disappear when someone cancels the search.
    ///   - In macOS, search scopes appear when SkipUI presents search and
    ///     disappear when someone cancels the search.
    ///
    /// However, you can use the `activation` parameter with a value of
    /// ``SearchScopeActivation/onTextEntry`` or
    /// ``SearchScopeActivation/onSearchPresentation`` to configure this
    /// behavior:
    ///
    ///     .searchScopes($scope, activation: .onSearchPresentation) {
    ///         Text("Fruit").tag(ProductScope.fruit)
    ///         Text("Vegetable").tag(ProductScope.vegetable)
    ///     }
    ///
    /// For more information about using searchable modifiers, see
    /// <doc:Adding-a-search-interface-to-your-app>.
    ///
    /// - Parameters:
    ///   - scope: The active scope of the search field.
    ///   - activation: The activation style of the search field's scopes.
    ///   - scopes: A view builder that represents the scoping options
    ///     SkipUI uses to populate a ``Picker``.
    @available(iOS 16.4, macOS 13.3, tvOS 16.4, *)
    @available(watchOS, unavailable)
    public func searchScopes<V, S>(_ scope: Binding<V>, activation: SearchScopeActivation, @ViewBuilder _ scopes: () -> S) -> some View where V : Hashable, S : View { return never() }

}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension View {

    /// Sets the view's horizontal alignment.
    ///
    /// Use `alignmentGuide(_:computeValue:)` to calculate specific offsets
    /// to reposition views in relationship to one another. You can return a
    /// constant or can use the ``ViewDimensions`` argument to the closure to
    /// calculate a return value.
    ///
    /// In the example below, the ``HStack`` is offset by a constant of 50
    /// points to the right of center:
    ///
    ///     VStack {
    ///         Text("Today's Weather")
    ///             .font(.title)
    ///             .border(.gray)
    ///         HStack {
    ///             Text("🌧")
    ///             Text("Rain & Thunderstorms")
    ///             Text("⛈")
    ///         }
    ///         .alignmentGuide(HorizontalAlignment.center) { _ in  50 }
    ///         .border(.gray)
    ///     }
    ///     .border(.gray)
    ///
    /// Changing the alignment of one view may have effects on surrounding
    /// views. Here the offset values inside a stack and its contained views is
    /// the difference of their absolute offsets.
    ///
    /// ![A view showing the two emoji offset from a text element using a
    /// horizontal alignment guide.](SkipUI-View-HAlignmentGuide.png)
    ///
    /// - Parameters:
    ///   - g: A ``HorizontalAlignment`` value at which to base the offset.
    ///   - computeValue: A closure that returns the offset value to apply to
    ///     this view.
    ///
    /// - Returns: A view modified with respect to its horizontal alignment
    ///   according to the computation performed in the method's closure.
    @inlinable public func alignmentGuide(_ g: HorizontalAlignment, computeValue: @escaping (ViewDimensions) -> CGFloat) -> some View { return never() }


    /// Sets the view's vertical alignment.
    ///
    /// Use `alignmentGuide(_:computeValue:)` to calculate specific offsets
    /// to reposition views in relationship to one another. You can return a
    /// constant or can use the ``ViewDimensions`` argument to the closure to
    /// calculate a return value.
    ///
    /// In the example below, the weather emoji are offset 20 points from the
    /// vertical center of the ``HStack``.
    ///
    ///     VStack {
    ///         Text("Today's Weather")
    ///             .font(.title)
    ///             .border(.gray)
    ///
    ///         HStack {
    ///             Text("🌧")
    ///                 .alignmentGuide(VerticalAlignment.center) { _ in -20 }
    ///                 .border(.gray)
    ///             Text("Rain & Thunderstorms")
    ///                 .border(.gray)
    ///             Text("⛈")
    ///                 .alignmentGuide(VerticalAlignment.center) { _ in 20 }
    ///                 .border(.gray)
    ///         }
    ///     }
    ///
    /// Changing the alignment of one view may have effects on surrounding
    /// views. Here the offset values inside a stack and its contained views is
    /// the difference of their absolute offsets.
    ///
    /// ![A view showing the two emoji offset from a text element using a
    /// vertical alignment guide.](SkipUI-View-VAlignmentGuide.png)
    ///
    /// - Parameters:
    ///   - g: A ``VerticalAlignment`` value at which to base the offset.
    ///   - computeValue: A closure that returns the offset value to apply to
    ///     this view.
    ///
    /// - Returns: A view modified with respect to its vertical alignment
    ///   according to the computation performed in the method's closure.
    @inlinable public func alignmentGuide(_ g: VerticalAlignment, computeValue: @escaping (ViewDimensions) -> CGFloat) -> some View { return never() }

}

@available(iOS 17.0, macOS 14.0, tvOS 17.0, *)
@available(watchOS, unavailable)
extension View {

    /// Returns a new view configured with the specified allowed
    /// dynamic range.
    ///
    /// The following example enables HDR rendering within a view
    /// hierarchy:
    ///
    ///     MyView().allowedDynamicRange(.high)
    ///
    /// - Parameter range: the requested dynamic range, or nil to
    ///   restore the default allowed range.
    ///
    /// - Returns: a new view.
    public func allowedDynamicRange(_ range: Image.DynamicRange?) -> some View { return never() }

}

@available(iOS 16.0, macOS 13.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension View {

    /// Adds an item-based context menu to a view.
    ///
    /// You can add an item-based context menu to a container that supports
    /// selection, like a ``List`` or a ``Table``. In the closure that you
    /// use to define the menu, you receive a collection of items that
    /// depends on the selection state of the container and the location where
    /// the person clicks or taps to activate the menu. The collection contains:
    ///
    /// * The selected item or items, when people initiate the context menu
    ///   from any selected item.
    /// * Nothing, if people tap or click to activate the context menu from
    ///   an empty part of the container. This is true even when one or more
    ///   items is currently selected.
    ///
    /// You can vary the menu contents according to the number of selected
    /// items. For example, the following code has a list that defines an
    /// empty area menu, a single item menu, and a multi-item menu:
    ///
    ///     struct ContextMenuItemExample: View {
    ///         var items: [Item]
    ///         @State private var selection = Set<Item.ID>()
    ///
    ///         var body: some View {
    ///             List(selection: $selection) {
    ///                 ForEach(items) { item in
    ///                     Text(item.name)
    ///                 }
    ///             }
    ///             .contextMenu(forSelectionType: Item.ID.self) { items in
    ///                 if items.isEmpty { // Empty area menu.
    ///                     Button("New Item") { }
    ///
    ///                 } else if items.count == 1 { // Single item menu.
    ///                     Button("Copy") { }
    ///                     Button("Delete", role: .destructive) { }
    ///
    ///                 } else { // Multi-item menu.
    ///                     Button("Copy") { }
    ///                     Button("New Folder With Selection") { }
    ///                     Button("Delete Selected", role: .destructive) { }
    ///                 }
    ///             }
    ///         }
    ///     }
    ///
    /// The above example assumes that the `Item` type conforms to the
    /// protocol, and relies on the associated `ID` type for both selection
    /// and context menu presentation.
    ///
    /// If you add the modifier to a view hierarchy that doesn't have a
    /// container that supports selection, the context menu never activates.
    /// To add a context menu that doesn't depend on selection behavior, use
    /// ``View/contextMenu(menuItems:)``. To add a context menu to a specific
    /// row in a table, use ``TableRowContent/contextMenu(menuItems:)``.
    ///
    /// ### Add a primary action
    ///
    /// Optionally, you can add a custom primary action to the context menu. In
    /// macOS, a single click on a row in a selectable container selects that
    /// row, and a double click performs the primary action. In iOS and iPadOS,
    /// tapping on the row activates the primary action. To select a row
    /// without performing an action, either enter edit mode or hold
    /// shift or command on a keyboard while tapping the row.
    ///
    /// For example, you can modify the context menu from the previous example
    /// so that double clicking the row on macOS opens a new window for
    /// selected items. Get the ``OpenWindowAction`` from the environment:
    ///
    ///     @Environment(\.openWindow) private var openWindow
    ///
    /// Then call ``EnvironmentValues/openWindow`` from inside the
    /// `primaryAction` closure for each item:
    ///
    ///     .contextMenu(forSelectionType: Item.ID.self) { items in
    ///         // ...
    ///     } primaryAction: { items in
    ///         for item in items {
    ///             openWindow(value: item)
    ///         }
    ///     }
    ///
    /// The open window action depends on the declaration of a ``WindowGroup``
    /// scene in your ``App`` that responds to the `Item` type:
    ///
    ///     WindowGroup("Item Detail", for: Item.self) { $item in
    ///         // ...
    ///     }
    ///
    /// - Parameters:
    ///   - itemType: The identifier type of the items. Ensure that this
    ///     matches the container's selection type.
    ///   - menu: A closure that produces the menu. A single parameter to the
    ///     closure contains the set of items to act on. An empty set indicates
    ///     menu activation over the empty area of the selectable container,
    ///     while a non-empty set indicates menu activation over selected items.
    ///     Use controls like ``Button``, ``Picker``, and ``Toggle`` to define
    ///     the menu items. You can also create submenus using ``Menu``, or
    ///     group items with ``Section``. You can deactivate the context menu
    ///     by returning nothing from the closure.
    ///   - primaryAction: A closure that defines the action to perform in
    ///     response to the primary interaction. A single parameter to the
    ///     closure contains the set of items to act on.
    ///
    /// - Returns: A view that can display an item-based context menu.
    public func contextMenu<I, M>(forSelectionType itemType: I.Type = I.self, @ViewBuilder menu: @escaping (Set<I>) -> M, primaryAction: ((Set<I>) -> Void)? = nil) -> some View where I : Hashable, M : View { return never() }

}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
extension View {

    /// Presents a confirmation dialog when a given condition is true, using a
    /// localized string key for the title.
    ///
    /// In the example below, a button conditionally presents a confirmation
    /// dialog depending upon the value of a bound Boolean variable. When the
    /// Boolean value is set to `true`, the system displays a confirmation
    /// dialog with a cancel action and a destructive action.
    ///
    ///     struct ConfirmEraseItems: View {
    ///         @State private var isShowingDialog = false
    ///         var body: some View {
    ///             Button("Empty Trash") {
    ///                 isShowingDialog = true
    ///             }
    ///             .confirmationDialog(
    ///                 "Permanently erase the items in the Trash?",
    ///                 isPresented: $isShowingDialog
    ///             ) {
    ///                 Button("Empty Trash", role: .destructive) {
    ///                     // Handle empty trash action.
    ///                 }
    ///             }
    ///         }
    ///     }
    ///
    /// All actions in a confirmation dialog will dismiss the dialog after the
    /// action runs. The default button will be shown with greater prominence.
    /// You can influence the default button by assigning it the
    /// ``KeyboardShortcut/defaultAction`` keyboard shortcut.
    ///
    /// The system may reorder the buttons based on their role and prominence.
    ///
    /// Dialogs include a standard dismiss action by default. If you provide a
    /// button with a role of ``ButtonRole/cancel``, that button takes the place
    /// of the default dismiss action. You don't have to dismiss the
    /// presentation with the cancel button's action.
    ///
    /// > Note: In regular size classes in iOS, the system renders confirmation
    /// dialogs as a popover that the user dismisses by tapping anywhere outside
    /// the popover, rather than displaying the standard dismiss action.
    ///
    /// On iOS, tvOS, and watchOS, confirmation dialogs only support controls
    /// with labels that are ``Text``. Passing any other type of view results in
    /// the content being omitted.
    ///
    /// This modifier creates a ``Text`` view for the title on your behalf, and
    /// treats the localized key similar to
    /// ``Text/init(_:tableName:bundle:comment:)``. See ``Text`` for more
    /// information about localizing strings.
    ///
    /// - Parameters:
    ///   - titleKey: The key for the localized string that describes the title
    ///     of the dialog.
    ///   - isPresented: A binding to a Boolean value that determines whether to
    ///     present the dialog. When the user presses or taps the dialog's
    ///     default action button, the system sets this value to `false`,
    ///     dismissing the dialog.
    ///   - titleVisibility: The visibility of the dialog's title. The default
    ///     value is ``Visibility/automatic``.
    ///   - actions: A view builder returning the dialog's actions.
    public func confirmationDialog<A>(_ titleKey: LocalizedStringKey, isPresented: Binding<Bool>, titleVisibility: Visibility = .automatic, @ViewBuilder actions: () -> A) -> some View where A : View { return never() }


    /// Presents a confirmation dialog when a given condition is true, using a
    /// string variable as a title.
    ///
    /// In the example below, a button conditionally presents a confirmation
    /// dialog depending upon the value of a bound Boolean variable. When the
    /// Boolean value is set to `true`, the system displays a confirmation
    /// dialog with a cancel action and a destructive action.
    ///
    ///     struct ConfirmEraseItems: View {
    ///         @State private var isShowingDialog = false
    ///         var title: String
    ///         var body: some View {
    ///             Button("Empty Trash") {
    ///                 isShowingDialog = true
    ///             }
    ///             .confirmationDialog(
    ///                 title,
    ///                 isPresented: $isShowingDialog
    ///             ) {
    ///                 Button("Empty Trash", role: .destructive) {
    ///                     // Handle empty trash action.
    ///                 }
    ///                 Button("Cancel", role: .cancel) {
    ///                     isShowingDialog = false
    ///                 }
    ///             }
    ///         }
    ///     }
    ///
    /// All actions in a confirmation dialog will dismiss the dialog after the
    /// action runs. The default button will be shown with greater prominence.
    /// You can influence the default button by assigning it the
    /// ``KeyboardShortcut/defaultAction`` keyboard shortcut.
    ///
    /// The system may reorder the buttons based on their role and prominence.
    ///
    /// Dialogs include a standard dismiss action by default. If you provide a
    /// button with a role of ``ButtonRole/cancel``, that button takes the place
    /// of the default dismiss action. You don't have to dismiss the
    /// presentation with the cancel button's action.
    ///
    /// > Note: In regular size classes in iOS, the system renders confirmation
    /// dialogs as a popover that the user dismisses by tapping anywhere outside
    /// the popover, rather than displaying the standard dismiss action.
    ///
    /// - Parameters:
    ///   - title: A text string used as the title of the dialog.
    ///   - isPresented: A binding to a Boolean value that determines whether to
    ///     present the dialog. When the user presses or taps the dialog's
    ///     default action button, the system sets this value to `false`,
    ///     dismissing the dialog.
    ///   - titleVisibility: The visibility of the dialog's title. The default
    ///     value is ``Visibility/automatic``.
    ///   - actions: A view builder returning the dialog's actions.
    public func confirmationDialog<S, A>(_ title: S, isPresented: Binding<Bool>, titleVisibility: Visibility = .automatic, @ViewBuilder actions: () -> A) -> some View where S : StringProtocol, A : View { return never() }


    /// Presents a confirmation dialog when a given condition is true, using a
    /// text view for the title.
    ///
    /// In the example below, a button conditionally presents a confirmation
    /// dialog depending upon the value of a bound Boolean variable. When the
    /// Boolean value is set to `true`, the system displays a confirmation
    /// dialog with a cancel action and a destructive action.
    ///
    ///     struct ConfirmEraseItems: View {
    ///         @State private var isShowingDialog = false
    ///         var body: some View {
    ///             Button("Empty Trash") {
    ///                 isShowingDialog = true
    ///             }
    ///             .confirmationDialog(
    ///                 Text("Permanently erase the items in the trash?"),
    ///                 isPresented: $isShowingDialog
    ///             ) {
    ///                 Button("Empty Trash", role: .destructive) {
    ///                     // Handle empty trash action.
    ///                 }
    ///             }
    ///         }
    ///     }
    ///
    /// All actions in a confirmation dialog will dismiss the dialog after the
    /// action runs. The default button will be shown with greater prominence.
    /// You can influence the default button by assigning it the
    /// ``KeyboardShortcut/defaultAction`` keyboard shortcut.
    ///
    /// The system may reorder the buttons based on their role and prominence.
    ///
    /// Dialogs include a standard dismiss action by default. If you provide a
    /// button with a role of ``ButtonRole/cancel``, that button takes the place
    /// of the default dismiss action. You don't have to dismiss the
    /// presentation with the cancel button's action.
    ///
    /// > Note: In regular size classes in iOS, the system renders confirmation
    /// dialogs as a popover that the user dismisses by tapping anywhere outside
    /// the popover, rather than displaying the standard dismiss action.
    ///
    /// - Parameters:
    ///   - title: the title of the dialog.
    ///   - isPresented: A binding to a Boolean value that determines whether
    ///     to present the dialog. When the user presses or taps the dialog's
    ///     default action button, the system sets this value to `false`,
    ///     dismissing the dialog.
    ///   - titleVisibility: The visibility of the dialog's title. The default
    ///     value is ``Visibility/automatic``.
    ///   - actions: A view builder returning the dialog's actions.
    public func confirmationDialog<A>(_ title: Text, isPresented: Binding<Bool>, titleVisibility: Visibility = .automatic, @ViewBuilder actions: () -> A) -> some View where A : View { return never() }

}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
extension View {

    /// Presents a confirmation dialog with a message when a given condition is
    /// true, using a localized string key for the title.
    ///
    /// In the example below, a button conditionally presents a confirmation
    /// dialog depending upon the value of a bound Boolean variable. When the
    /// Boolean value is set to `true`, the system displays a confirmation
    /// dialog with a cancel action and a destructive action.
    ///
    ///     struct ConfirmEraseItems: View {
    ///         @State private var isShowingDialog = false
    ///         var body: some View {
    ///             Button("Empty Trash") {
    ///                 isShowingDialog = true
    ///             }
    ///             .confirmationDialog(
    ///                 "Permanently erase the items in the Trash?",
    ///                 isPresented: $isShowingDialog
    ///             ) {
    ///                 Button("Empty Trash", role: .destructive) {
    ///                     // Handle empty trash action.
    ///                 }
    ///             } message: {
    ///                 Text("You cannot undo this action.")
    ///             }
    ///         }
    ///     }
    ///
    /// All actions in a confirmation dialog will dismiss the dialog after the
    /// action runs. The default button will be shown with greater prominence.
    /// You can influence the default button by assigning it the
    /// ``KeyboardShortcut/defaultAction`` keyboard shortcut.
    ///
    /// The system may reorder the buttons based on their role and prominence.
    ///
    /// Dialogs include a standard dismiss action by default. If you provide a
    /// button with a role of ``ButtonRole/cancel``, that button takes the place
    /// of the default dismiss action. You don't have to dismiss the
    /// presentation with the cancel button's action.
    ///
    /// > Note: In regular size classes in iOS, the system renders confirmation
    /// dialogs as a popover that the user dismisses by tapping anywhere outside
    /// the popover, rather than displaying the standard dismiss action.
    ///
    /// On iOS, tvOS, and watchOS, confirmation dialogs only support controls
    /// with labels that are `Text`. Passing any other type of view results in
    /// the content being omitted.
    ///
    /// This modifier creates a ``Text`` view for the title on your behalf, and
    /// treats the localized key similar to
    /// ``Text/init(_:tableName:bundle:comment:)``. See ``Text`` for more
    /// information about localizing strings.
    ///
    /// - Parameters:
    ///   - titleKey: The key for the localized string that describes the title
    ///     of the dialog.
    ///   - isPresented: A binding to a Boolean value that determines whether to
    ///     present the dialog. When the user presses or taps the dialog's
    ///     default action button, the system sets this value to `false`,
    ///     dismissing the dialog.
    ///   - titleVisibility: The visibility of the dialog's title. The default
    ///     value is ``Visibility/automatic``.
    ///   - actions: A view builder returning the dialog's actions.
    ///   - message: A view builder returning the message for the dialog.
    public func confirmationDialog<A, M>(_ titleKey: LocalizedStringKey, isPresented: Binding<Bool>, titleVisibility: Visibility = .automatic, @ViewBuilder actions: () -> A, @ViewBuilder message: () -> M) -> some View where A : View, M : View { return never() }


    /// Presents a confirmation dialog with a message when a given condition is
    /// true, using a string variable for the title.
    ///
    /// In the example below, a button conditionally presents a confirmation
    /// dialog depending upon the value of a bound Boolean variable. When the
    /// Boolean value is set to `true`, the system displays a confirmation
    /// dialog with a cancel action and a destructive action.
    ///
    ///     struct ConfirmEraseItems: View {
    ///         @State private var isShowingDialog = false
    ///         var title: String
    ///         var body: some View {
    ///             Button("Empty Trash") {
    ///                 isShowingDialog = true
    ///             }
    ///             .confirmationDialog(
    ///                 title,
    ///                 isPresented: $isShowingDialog
    ///             ) {
    ///                 Button("Empty Trash", role: .destructive) {
    ///                     // Handle empty trash action.
    ///                 }
    ///                 Button("Cancel", role: .cancel) {
    ///                     isShowingDialog = false
    ///                 }
    ///             } message: {
    ///                 Text("You cannot undo this action.")
    ///             }
    ///         }
    ///     }
    ///
    /// All actions in a confirmation dialog will dismiss the dialog after the
    /// action runs. The default button will be shown with greater prominence.
    /// You can influence the default button by assigning it the
    /// ``KeyboardShortcut/defaultAction`` keyboard shortcut.
    ///
    /// The system may reorder the buttons based on their role and prominence.
    ///
    /// Dialogs include a standard dismiss action by default. If you provide a
    /// button with a role of ``ButtonRole/cancel``, that button takes the place
    /// of the default dismiss action. You don't have to dismiss the
    /// presentation with the cancel button's action.
    ///
    /// > Note: In regular size classes in iOS, the system renders confirmation
    /// dialogs as a popover that the user dismisses by tapping anywhere outside
    /// the popover, rather than displaying the standard dismiss action.
    ///
    /// - Parameters:
    ///   - title: A text string used as the title of the dialog.
    ///   - isPresented: A binding to a Boolean value that determines whether to
    ///     present the dialog. When the user presses or taps the dialog's
    ///     default action button, the system sets this value to `false`,
    ///     dismissing the dialog.
    ///   - titleVisibility: The visibility of the dialog's title. The default
    ///     value is ``Visibility/automatic``.
    ///   - actions: A view builder returning the dialog's actions.
    ///   - message: A view builder returning the message for the dialog.
    public func confirmationDialog<S, A, M>(_ title: S, isPresented: Binding<Bool>, titleVisibility: Visibility = .automatic, @ViewBuilder actions: () -> A, @ViewBuilder message: () -> M) -> some View where S : StringProtocol, A : View, M : View { return never() }


    /// Presents a confirmation dialog with a message when a given condition is
    /// true, using a text view for the title.
    ///
    /// In the example below, a button conditionally presents a confirmation
    /// dialog depending upon the value of a bound Boolean variable. When the
    /// Boolean value is set to `true`, the system displays a confirmation
    /// dialog with a cancel action and a destructive action.
    ///
    ///     struct ConfirmEraseItems: View {
    ///         @State private var isShowingDialog = false
    ///         var body: some View {
    ///             Button("Empty Trash") {
    ///                 isShowingDialog = true
    ///             }
    ///             .confirmationDialog(
    ///                 Text("Permanently erase the items in the trash?"),
    ///                 isPresented: $isShowingDialog
    ///             ) {
    ///                 Button("Empty Trash", role: .destructive) {
    ///                     // Handle empty trash action.
    ///                 }
    ///             } message: {
    ///                 Text("You cannot undo this action.")
    ///             }
    ///         }
    ///     }
    ///
    /// All actions in a confirmation dialog will dismiss the dialog after the
    /// action runs. The default button will be shown with greater prominence.
    /// You can influence the default button by assigning it the
    /// ``KeyboardShortcut/defaultAction`` keyboard shortcut.
    ///
    /// The system may reorder the buttons based on their role and prominence.
    ///
    /// Dialogs include a standard dismiss action by default. If you provide a
    /// button with a role of ``ButtonRole/cancel``, that button takes the place
    /// of the default dismiss action. You don't have to dismiss the
    /// presentation with the cancel button's action.
    ///
    /// > Note: In regular size classes in iOS, the system renders confirmation
    /// dialogs as a popover that the user dismisses by tapping anywhere outside
    /// the popover, rather than displaying the standard dismiss action.
    ///
    /// - Parameters:
    ///   - title: the title of the dialog.
    ///   - isPresented: A binding to a Boolean value that determines whether
    ///     to present the dialog. When the user presses or taps the dialog's
    ///     default action button, the system sets this value to `false`,
    ///     dismissing the dialog.
    ///   - titleVisibility: The visibility of the dialog's title. The default
    ///     value is ``Visibility/automatic``.
    ///   - actions: A view builder returning the dialog's actions.
    ///   - message: A view builder returning the message for the dialog.
    public func confirmationDialog<A, M>(_ title: Text, isPresented: Binding<Bool>, titleVisibility: Visibility = .automatic, @ViewBuilder actions: () -> A, @ViewBuilder message: () -> M) -> some View where A : View, M : View { return never() }

}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
extension View {

    /// Presents a confirmation dialog using data to produce the dialog's
    /// content and a localized string key for the title.
    ///
    /// In order for the interface to appear, both `isPresented` must be `true`
    /// and `data` must not be `nil`. `data` should not change after the
    /// presentation occurs. Any changes which occur after the presentation
    /// occurs will be ignored.
    ///
    /// Use this method when you need to populate the fields of a confirmation
    /// dialog with content from a data source. The example below shows a custom
    /// data source, `FileDetails`, that provides data to populate the dialog:
    ///
    ///     struct FileDetails: Identifiable {
    ///         var id: String { name }
    ///         let name: String
    ///         let fileType: UTType
    ///     }
    ///     struct ConfirmFileImport: View {
    ///         @State private var isConfirming = false
    ///         @State private var dialogDetail: FileDetails?
    ///         var body: some View {
    ///             Button("Import File") {
    ///                 dialogDetail = FileDetails(
    ///                     name: "MyImageFile.png", fileType: .png)
    ///                 isConfirming = true
    ///             }
    ///             .confirmationDialog(
    ///                 "Are you sure you want to import this file?",
    ///                 isPresented: $isConfirming, presenting: dialogDetail
    ///             ) { detail in
    ///                 Button {
    ///                     // Handle import action.
    ///                 } label: {
    ///                     Text("""
    ///                     Import \(detail.name)
    ///                     File Type: \(detail.fileType.description)
    ///                     """)
    ///                 }
    ///                 Button("Cancel", role: .cancel) {
    ///                     dialogDetail = nil
    ///                 }
    ///             }
    ///         }
    ///     }
    ///
    /// This modifier creates a ``Text`` view for the title on your behalf, and
    /// treats the localized key similar to
    /// ``Text/init(_:tableName:bundle:comment:)``. See ``Text`` for more
    /// information about localizing strings.
    ///
    /// All actions in a confirmation dialog will dismiss the dialog after the
    /// action runs. The default button will be shown with greater prominence.
    /// You can influence the default button by assigning it the
    /// ``KeyboardShortcut/defaultAction`` keyboard shortcut.
    ///
    /// The system may reorder the buttons based on their role and prominence.
    ///
    /// Dialogs include a standard dismiss action by default. If you provide a
    /// button with a role of ``ButtonRole/cancel``, that button takes the place
    /// of the default dismiss action. You don't have to dismiss the
    /// presentation with the cancel button's action.
    ///
    /// > Note: In regular size classes in iOS, the system renders confirmation
    /// dialogs as a popover that the user dismisses by tapping anywhere outside
    /// the popover, rather than displaying the standard dismiss action.
    ///
    /// On iOS, tvOS, and watchOS, confirmation dialogs only support controls
    /// with labels that are `Text`. Passing any other type of view results in
    /// the content being omitted.
    ///
    /// - Parameters:
    ///   - titleKey: The key for the localized string that describes the title
    ///     of the dialog.
    ///   - isPresented: A binding to a Boolean value that determines whether
    ///     to present the dialog. When the user presses or taps the dialog's
    ///     default action button, the system sets this value to `false`,
    ///     dismissing the dialog.
    ///   - titleVisibility: The visibility of the dialog's title. The default
    ///     value is ``Visibility/automatic``.
    ///   - data: An optional source of truth for the confirmation dialog. The
    ///     system passes the contents to the modifier's closures. You use this
    ///     data to populate the fields of a confirmation dialog that you create
    ///     that the system displays to the user.
    ///   - actions: A view builder returning the dialog's actions given the
    ///     currently available data.
    public func confirmationDialog<A, T>(_ titleKey: LocalizedStringKey, isPresented: Binding<Bool>, titleVisibility: Visibility = .automatic, presenting data: T?, @ViewBuilder actions: (T) -> A) -> some View where A : View { return never() }


    /// Presents a confirmation dialog using data to produce the dialog's
    /// content and a string variable for the title.
    ///
    /// In order for the interface to appear, both `isPresented` must be `true`
    /// and `data` must not be `nil`. `data` should not change after the
    /// presentation occurs. Any changes which occur after the presentation
    /// occurs will be ignored.
    ///
    /// Use this method when you need to populate the fields of a confirmation
    /// dialog with content from a data source. The example below shows a custom
    /// data source, `FileDetails`, that provides data to populate the dialog:
    ///
    ///     struct FileDetails: Identifiable {
    ///         var id: String { name }
    ///         let name: String
    ///         let fileType: UTType
    ///     }
    ///     struct ConfirmFileImport: View {
    ///         var title: String
    ///         @State private var isConfirming = false
    ///         @State private var dialogDetail: FileDetails?
    ///         var body: some View {
    ///             Button("Import File") {
    ///                 dialogDetail = FileDetails(
    ///                     name: "MyImageFile.png", fileType: .png)
    ///                 isConfirming = true
    ///             }
    ///             .confirmationDialog(
    ///                 title, isPresented: $isConfirming,
    ///                 presenting: dialogDetail
    ///             ) { detail in
    ///                 Button {
    ///                     // Handle import action.
    ///                 } label: {
    ///                     Text("""
    ///                     Import \(detail.name)
    ///                     File Type: \(detail.fileType.description)
    ///                     """)
    ///                 }
    ///                 Button("Cancel", role: .cancel) {
    ///                     dialogDetail = nil
    ///                 }
    ///             }
    ///         }
    ///     }
    ///
    /// All actions in a confirmation dialog will dismiss the dialog after the
    /// action runs. The default button will be shown with greater prominence.
    /// You can influence the default button by assigning it the
    /// ``KeyboardShortcut/defaultAction`` keyboard shortcut.
    ///
    /// The system may reorder the buttons based on their role and prominence.
    ///
    /// Dialogs include a standard dismiss action by default. If you provide a
    /// button with a role of ``ButtonRole/cancel``, that button takes the place
    /// of the default dismiss action. You don't have to dismiss the
    /// presentation with the cancel button's action.
    ///
    /// > Note: In regular size classes in iOS, the system renders confirmation
    /// dialogs as a popover that the user dismisses by tapping anywhere outside
    /// the popover, rather than displaying the standard dismiss action.
    ///
    /// On iOS, tvOS, and watchOS, confirmation dialogs only support controls
    /// with labels that are `Text`. Passing any other type of view results in
    /// the content being omitted.
    ///
    /// - Parameters:
    ///   - title: A text string used as the title of the dialog.
    ///   - isPresented: A binding to a Boolean value that determines whether
    ///     to present the dialog. When the user presses or taps the dialog's
    ///     default action button, the system sets this value to `false`,
    ///     dismissing the dialog.
    ///   - titleVisibility: The visibility of the dialog's title. The default
    ///     value is ``Visibility/automatic``.
    ///   - data: An optional source of truth for the confirmation dialog. The
    ///     system passes the contents to the modifier's closures. You use this
    ///     data to populate the fields of a confirmation dialog that you create
    ///     that the system displays to the user.
    ///   - actions: A view builder returning the dialog's actions given the
    ///     currently available data.
    public func confirmationDialog<S, A, T>(_ title: S, isPresented: Binding<Bool>, titleVisibility: Visibility = .automatic, presenting data: T?, @ViewBuilder actions: (T) -> A) -> some View where S : StringProtocol, A : View { return never() }


    /// Presents a confirmation dialog using data to produce the dialog's
    /// content and a text view for the title.
    ///
    /// In order for the interface to appear, both `isPresented` must be `true`
    /// and `data` must not be `nil`. `data` should not change after the
    /// presentation occurs. Any changes which occur after the presentation
    /// occurs will be ignored.
    ///
    /// Use this method when you need to populate the fields of a confirmation
    /// dialog with content from a data source. The example below shows a custom
    /// data source, `FileDetails`, that provides data to populate the dialog:
    ///
    ///     struct FileDetails: Identifiable {
    ///         var id: String { name }
    ///         let name: String
    ///         let fileType: UTType
    ///     }
    ///     struct ConfirmFileImport: View {
    ///         @State private var isConfirming = false
    ///         @State private var dialogDetail: FileDetails?
    ///         var body: some View {
    ///             Button("Import File") {
    ///                 dialogDetail = FileDetails(
    ///                     name: "MyImageFile.png", fileType: .png)
    ///                 isConfirming = true
    ///             }
    ///             .confirmationDialog(
    ///                 Text("Import New File?"),
    ///                 isPresented: $isConfirming, presenting: dialogDetail
    ///             ) { detail in
    ///                 Button {
    ///                     // Handle import action.
    ///                 } label: {
    ///                     Text("""
    ///                     Import \(detail.name)
    ///                     File Type: \(detail.fileType.description)
    ///                     """)
    ///                 }
    ///                 Button("Cancel", role: .cancel) {
    ///                     dialogDetail = nil
    ///                 }
    ///             }
    ///         }
    ///     }
    ///
    /// All actions in a confirmation dialog will dismiss the dialog after the
    /// action runs. The default button will be shown with greater prominence.
    /// You can influence the default button by assigning it the
    /// ``KeyboardShortcut/defaultAction`` keyboard shortcut.
    ///
    /// The system may reorder the buttons based on their role and prominence.
    ///
    /// Dialogs include a standard dismiss action by default. If you provide a
    /// button with a role of ``ButtonRole/cancel``, that button takes the place
    /// of the default dismiss action. You don't have to dismiss the
    /// presentation with the cancel button's action.
    ///
    /// > Note: In regular size classes in iOS, the system renders confirmation
    /// dialogs as a popover that the user dismisses by tapping anywhere outside
    /// the popover, rather than displaying the standard dismiss action.
    ///
    /// On iOS, tvOS, and watchOS, confirmation dialogs only support controls
    /// with labels that are `Text`. Passing any other type of view results in
    /// the content being omitted.
    ///
    /// - Parameters:
    ///   - title: the title of the dialog.
    ///   - isPresented: A binding to a Boolean value that determines whether
    ///     to present the dialog. When the user presses or taps the dialog's
    ///     default action button, the system sets this value to `false`,
    ///     dismissing the dialog.
    ///   - titleVisibility: The visibility of the dialog's title. The default
    ///     value is ``Visibility/automatic``.
    ///   - data: An optional source of truth for the confirmation dialog. The
    ///     system passes the contents to the modifier's closures. You use this
    ///     data to populate the fields of a confirmation dialog that you create
    ///     that the system displays to the user.
    ///   - actions: A view builder returning the dialog's actions given the
    ///     currently available data.
    public func confirmationDialog<A, T>(_ title: Text, isPresented: Binding<Bool>, titleVisibility: Visibility = .automatic, presenting data: T?, @ViewBuilder actions: (T) -> A) -> some View where A : View { return never() }

}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
extension View {

    /// Presents a confirmation dialog with a message using data to produce the
    /// dialog's content and a localized string key for the title.
    ///
    /// In order for the interface to appear, both `isPresented` must be `true`
    /// and `data` must not be `nil`. `data` should not change after the
    /// presentation occurs. Any changes which occur after the presentation
    /// occurs will be ignored.
    ///
    /// Use this method when you need to populate the fields of a confirmation
    /// dialog with content from a data source. The example below shows a custom
    /// data source, `FileDetails`, that provides data to populate the dialog:
    ///
    ///     struct FileDetails: Identifiable {
    ///         var id: String { name }
    ///         let name: String
    ///         let fileType: UTType
    ///     }
    ///     struct ConfirmFileImport: View {
    ///         @State private var isConfirming = false
    ///         @State private var dialogDetail: FileDetails?
    ///         var body: some View {
    ///             Button("Import File") {
    ///                 dialogDetail = FileDetails(
    ///                     name: "MyImageFile.png", fileType: .png)
    ///                 isConfirming = true
    ///             }
    ///             .confirmationDialog(
    ///                 "Are you sure you want to import this file?",
    ///                 isPresented: $isConfirming, presenting: dialogDetail
    ///             ) { detail in
    ///                 Button {
    ///                     // Handle import action.
    ///                 } label: {
    ///                     Text("Import \(detail.name)")
    ///                 }
    ///                 Button("Cancel", role: .cancel) {
    ///                     dialogDetail = nil
    ///                 }
    ///             } message: { detail in
    ///                 Text(
    ///                     """
    ///                     This will add \(detail.name).\(detail.fileType) \
    ///                     to your library.
    ///                     """)
    ///             }
    ///         }
    ///     }
    ///
    /// This modifier creates a ``Text`` view for the title on your behalf, and
    /// treats the localized key similar to
    /// ``Text/init(_:tableName:bundle:comment:)``. See ``Text`` for more
    /// information about localizing strings.
    ///
    /// All actions in a confirmation dialog will dismiss the dialog after the
    /// action runs. The default button will be shown with greater prominence.
    /// You can influence the default button by assigning it the
    /// ``KeyboardShortcut/defaultAction`` keyboard shortcut.
    ///
    /// The system may reorder the buttons based on their role and prominence.
    ///
    /// Dialogs include a standard dismiss action by default. If you provide a
    /// button with a role of ``ButtonRole/cancel``, that button takes the place
    /// of the default dismiss action. You don't have to dismiss the
    /// presentation with the cancel button's action.
    ///
    /// > Note: In regular size classes in iOS, the system renders confirmation
    /// dialogs as a popover that the user dismisses by tapping anywhere outside
    /// the popover, rather than displaying the standard dismiss action.
    ///
    /// On iOS, tvOS, and watchOS, confirmation dialogs only support controls
    /// with labels that are `Text`. Passing any other type of view results in
    /// the content being omitted.
    ///
    /// - Parameters:
    ///   - titleKey: The key for the localized string that describes the title
    ///     of the dialog.
    ///   - isPresented: A binding to a Boolean value that determines whether
    ///     to present the dialog. When the user presses or taps the dialog's
    ///     default action button, the system sets this value to `false`,
    ///     dismissing the dialog.
    ///   - titleVisibility: The visibility of the dialog's title. The default
    ///     value is ``Visibility/automatic``.
    ///   - data: An optional source of truth for the confirmation dialog. The
    ///     system passes the contents to the modifier's closures. You use this
    ///     data to populate the fields of a confirmation dialog that you create
    ///     that the system displays to the user.
    ///   - actions: A view builder returning the dialog's actions given the
    ///     currently available data.
    ///   - message: A view builder returning the message for the dialog given
    ///     the currently available data.
    public func confirmationDialog<A, M, T>(_ titleKey: LocalizedStringKey, isPresented: Binding<Bool>, titleVisibility: Visibility = .automatic, presenting data: T?, @ViewBuilder actions: (T) -> A, @ViewBuilder message: (T) -> M) -> some View where A : View, M : View { return never() }


    /// Presents a confirmation dialog with a message using data to produce the
    /// dialog's content and a string variable for the title.
    ///
    /// In order for the interface to appear, both `isPresented` must be `true`
    /// and `data` must not be `nil`. `data` should not change after the
    /// presentation occurs. Any changes which occur after the presentation
    /// occurs will be ignored.
    ///
    /// Use this method when you need to populate the fields of a confirmation
    /// dialog with content from a data source. The example below shows a custom
    /// data source, `FileDetails`, that provides data to populate the dialog:
    ///
    ///     struct FileDetails: Identifiable {
    ///         var id: String { name }
    ///         let name: String
    ///         let fileType: UTType
    ///     }
    ///     struct ConfirmFileImport: View {
    ///         var title: String
    ///         @State private var isConfirming = false
    ///         @State private var dialogDetail: FileDetails?
    ///         var body: some View {
    ///             Button("Import File") {
    ///                 dialogDetail = FileDetails(
    ///                     name: "MyImageFile.png", fileType: .png)
    ///                 isConfirming = true
    ///             }
    ///             .confirmationDialog(
    ///                 title, isPresented: $isConfirming,
    ///                 presenting: dialogDetail
    ///             ) { detail in
    ///                 Button {
    ///                     // Handle import action.
    ///                 } label: {
    ///                     Text("Import \(detail.name)")
    ///                 }
    ///                 Button("Cancel", role: .cancel) {
    ///                     dialogDetail = nil
    ///                 }
    ///             } message: { detail in
    ///                 Text(
    ///                     """
    ///                     This will add \(detail.name).\(detail.fileType) \
    ///                     to your library.
    ///                     """)
    ///             }
    ///         }
    ///     }
    ///
    /// All actions in a confirmation dialog will dismiss the dialog after the
    /// action runs. The default button will be shown with greater prominence.
    /// You can influence the default button by assigning it the
    /// ``KeyboardShortcut/defaultAction`` keyboard shortcut.
    ///
    /// The system may reorder the buttons based on their role and prominence.
    ///
    /// Dialogs include a standard dismiss action by default. If you provide a
    /// button with a role of ``ButtonRole/cancel``, that button takes the place
    /// of the default dismiss action. You don't have to dismiss the
    /// presentation with the cancel button's action.
    ///
    /// > Note: In regular size classes in iOS, the system renders confirmation
    /// dialogs as a popover that the user dismisses by tapping anywhere outside
    /// the popover, rather than displaying the standard dismiss action.
    ///
    /// On iOS, tvOS, and watchOS, confirmation dialogs only support controls
    /// with labels that are `Text`. Passing any other type of view results in
    /// the content being omitted.
    ///
    /// - Parameters:
    ///   - title: A text string used as the title of the dialog.
    ///   - isPresented: A binding to a Boolean value that determines whether
    ///     to present the dialog. When the user presses or taps the dialog's
    ///     default action button, the system sets this value to `false`,
    ///     dismissing the dialog.
    ///   - titleVisibility: The visibility of the dialog's title. The default
    ///     value is ``Visibility/automatic``.
    ///   - data: An optional source of truth for the confirmation dialog. The
    ///     system passes the contents to the modifier's closures. You use this
    ///     data to populate the fields of a confirmation dialog that you create
    ///     that the system displays to the user.
    ///   - actions: A view builder returning the dialog's actions given the
    ///     currently available data.
    ///   - message: A view builder returning the message for the dialog given
    ///     the currently available data.
    public func confirmationDialog<S, A, M, T>(_ title: S, isPresented: Binding<Bool>, titleVisibility: Visibility = .automatic, presenting data: T?, @ViewBuilder actions: (T) -> A, @ViewBuilder message: (T) -> M) -> some View where S : StringProtocol, A : View, M : View { return never() }


    /// Presents a confirmation dialog with a message using data to produce the
    /// dialog's content and a text view for the message.
    ///
    /// In order for the interface to appear, both `isPresented` must be `true`
    /// and `data` must not be `nil`. `data` should not change after the
    /// presentation occurs. Any changes which occur after the presentation
    /// occurs will be ignored.
    ///
    /// Use this method when you need to populate the fields of a confirmation
    /// dialog with content from a data source. The example below shows a custom
    /// data source, `FileDetails`, that provides data to populate the dialog:
    ///
    ///     struct FileDetails: Identifiable {
    ///         var id: String { name }
    ///         let name: String
    ///         let fileType: UTType
    ///     }
    ///     struct ConfirmFileImport: View {
    ///         @State private var isConfirming = false
    ///         @State private var dialogDetail: FileDetails?
    ///         var body: some View {
    ///             Button("Import File") {
    ///                 dialogDetail = FileDetails(
    ///                     name: "MyImageFile.png", fileType: .png)
    ///                 isConfirming = true
    ///             }
    ///             .confirmationDialog(
    ///                 Text("Import New File?"),
    ///                 isPresented: $isConfirming, presenting: dialogDetail
    ///             ) { detail in
    ///                 Button {
    ///                     // Handle import action.
    ///                 } label: {
    ///                     Text("Import \(detail.name)")
    ///                 }
    ///                 Button("Cancel", role: .cancel) {
    ///                     dialogDetail = nil
    ///                 }
    ///             } message: { detail in
    ///                 Text(
    ///                     """
    ///                     This will add \(detail.name).\(detail.fileType) \
    ///                     to your library.
    ///                     """)
    ///             }
    ///         }
    ///     }
    ///
    /// All actions in a confirmation dialog will dismiss the dialog after the
    /// action runs. The default button will be shown with greater prominence.
    /// You can influence the default button by assigning it the
    /// ``KeyboardShortcut/defaultAction`` keyboard shortcut.
    ///
    /// The system may reorder the buttons based on their role and prominence.
    ///
    /// Dialogs include a standard dismiss action by default. If you provide a
    /// button with a role of ``ButtonRole/cancel``, that button takes the place
    /// of the default dismiss action. You don't have to dismiss the
    /// presentation with the cancel button's action.
    ///
    /// > Note: In regular size classes in iOS, the system renders confirmation
    /// dialogs as a popover that the user dismisses by tapping anywhere outside
    /// the popover, rather than displaying the standard dismiss action.
    ///
    /// On iOS, tvOS, and watchOS, confirmation dialogs only support controls
    /// with labels that are `Text`. Passing any other type of view results in
    /// the content being omitted.
    ///
    /// - Parameters:
    ///   - title: the title of the dialog.
    ///   - isPresented: A binding to a Boolean value that determines whether
    ///     to present the dialog. When the user presses or taps the dialog's
    ///     default action button, the system sets this value to `false`,
    ///     dismissing the dialog.
    ///   - titleVisibility: The visibility of the dialog's title. The default
    ///     value is ``Visibility/automatic``.
    ///   - data: An optional source of truth for the confirmation dialog. The
    ///     system passes the contents to the modifier's closures. You use this
    ///     data to populate the fields of a confirmation dialog that you create
    ///     that the system displays to the user.
    ///   - actions: A view builder returning the dialog's actions given the
    ///     currently available data.
    ///   - message: A view builder returning the message for the dialog given
    ///     the currently available data.
    public func confirmationDialog<A, M, T>(_ title: Text, isPresented: Binding<Bool>, titleVisibility: Visibility = .automatic, presenting data: T?, @ViewBuilder actions: (T) -> A, @ViewBuilder message: (T) -> M) -> some View where A : View, M : View { return never() }

}

extension View {

    /// Specifies the language for typesetting.
    ///
    /// In some cases `Text` may contain text of a particular language which
    /// doesn't match the device UI language. In that case it's useful to
    /// specify a language so line height, line breaking and spacing will
    /// respect the script used for that language. For example:
    ///
    ///     Text(verbatim: "แอปเปิล")
    ///         .typesettingLanguage(.init(languageCode: .thai))
    ///
    /// Note: this language does not affect text localization.
    ///
    /// - Parameters:
    ///   - language: The explicit language to use for typesetting.
    ///   - isEnabled: A Boolean value that indicates whether text langauge is
    ///     added
    /// - Returns: A view with the typesetting language set to the value you
    ///   supply.
    @available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
    public func typesettingLanguage(_ language: Locale.Language, isEnabled: Bool = true) -> some View { return never() }


    /// Specifies the language for typesetting.
    ///
    /// In some cases `Text` may contain text of a particular language which
    /// doesn't match the device UI language. In that case it's useful to
    /// specify a language so line height, line breaking and spacing will
    /// respect the script used for that language. For example:
    ///
    ///     Text(verbatim: "แอปเปิล").typesettingLanguage(
    ///         .explicit(.init(languageCode: .thai)))
    ///
    /// Note: this language does not affect text localized localization.
    ///
    /// - Parameters:
    ///   - language: The language to use for typesetting.
    ///   - isEnabled: A Boolean value that indicates whether text language is
    ///     added
    /// - Returns: A view with the typesetting language set to the value you
    ///   supply.
    @available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
    public func typesettingLanguage(_ language: TypesettingLanguage, isEnabled: Bool = true) -> some View { return never() }

}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension View {

    /// Positions the center of this view at the specified point in its parent's
    /// coordinate space.
    ///
    /// Use the `position(_:)` modifier to place the center of a view at a
    /// specific coordinate in the parent view using a
    ///  to specify the `x`
    /// and `y` offset.
    ///
    ///     Text("Position by passing a CGPoint()")
    ///         .position(CGPoint(x: 175, y: 100))
    ///         .border(Color.gray)
    ///
    /// - Parameter position: The point at which to place the center of this
    ///   view.
    ///
    /// - Returns: A view that fixes the center of this view at `position`.
    @inlinable public func position(_ position: CGPoint) -> some View { return never() }


    /// Positions the center of this view at the specified coordinates in its
    /// parent's coordinate space.
    ///
    /// Use the `position(x:y:)` modifier to place the center of a view at a
    /// specific coordinate in the parent view using an `x` and `y` offset.
    ///
    ///     Text("Position by passing the x and y coordinates")
    ///         .position(x: 175, y: 100)
    ///         .border(Color.gray)
    ///
    /// - Parameters:
    ///   - x: The x-coordinate at which to place the center of this view.
    ///   - y: The y-coordinate at which to place the center of this view.
    ///
    /// - Returns: A view that fixes the center of this view at `x` and `y`.
    @inlinable public func position(x: CGFloat = 0, y: CGFloat = 0) -> some View { return never() }

}

@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
extension View {

    /// Sets a fixed, preferred width for the column containing this view.
    ///
    /// Apply this modifier to the content of a column in a
    /// ``NavigationSplitView`` to specify a fixed preferred width for the
    /// column. Use ``View/navigationSplitViewColumnWidth(min:ideal:max:)`` if
    /// you need to specify a flexible width.
    ///
    /// The following example shows a three-column navigation split view where
    /// the first column has a preferred width of 150 points, and the second
    /// column has a flexible, preferred width between 150 and 400 points:
    ///
    ///     NavigationSplitView {
    ///         MySidebar()
    ///             .navigationSplitViewColumnWidth(150)
    ///     } contents: {
    ///         MyContents()
    ///             .navigationSplitViewColumnWidth(
    ///                 min: 150, ideal: 200, max: 400)
    ///     } detail: {
    ///         MyDetail()
    ///     }
    ///
    /// Only some platforms enable resizing columns. If
    /// you specify a width that the current presentation environment doesn't
    /// support, SkipUI may use a different width for your column.
    public func navigationSplitViewColumnWidth(_ width: CGFloat) -> some View { return never() }


    /// Sets a flexible, preferred width for the column containing this view.
    ///
    /// Apply this modifier to the content of a column in a
    /// ``NavigationSplitView`` to specify a preferred flexible width for the
    /// column. Use ``View/navigationSplitViewColumnWidth(_:)`` if you need to
    /// specify a fixed width.
    ///
    /// The following example shows a three-column navigation split view where
    /// the first column has a preferred width of 150 points, and the second
    /// column has a flexible, preferred width between 150 and 400 points:
    ///
    ///     NavigationSplitView {
    ///         MySidebar()
    ///             .navigationSplitViewColumnWidth(150)
    ///     } contents: {
    ///         MyContents()
    ///             .navigationSplitViewColumnWidth(
    ///                 min: 150, ideal: 200, max: 400)
    ///     } detail: {
    ///         MyDetail()
    ///     }
    ///
    /// Only some platforms enable resizing columns. If
    /// you specify a width that the current presentation environment doesn't
    /// support, SkipUI may use a different width for your column.
    public func navigationSplitViewColumnWidth(min: CGFloat? = nil, ideal: CGFloat, max: CGFloat? = nil) -> some View { return never() }

}

@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
extension View {

    /// Uses the string you specify to identify the view.
    ///
    /// Use this value for testing. It isn't visible to the user.
    public func accessibilityIdentifier(_ identifier: String) -> ModifiedContent<Self, AccessibilityAttachmentModifier> { fatalError() }
}

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension View {

    /// Enables user suppression of dialogs and alerts presented within `self`,
    /// with a custom suppression message on macOS. Unused on other platforms.
    ///
    /// Applying dialog suppression adds a toggle to dialogs on macOS,
    /// which allows the user to request the alert not be displayed again.
    /// Typically whether a dialog is suppressed is stored in `AppStorage`
    /// and used to decide whether to present the dialog in the future.
    ///
    /// The following example configures a `confirmationDialog` with a
    /// suppression toggle. The toggle's state is stored in `AppStorage` and
    /// used to determine whether or not to show the dialog when the
    /// "Delete Items" button is pressed.
    ///
    ///     struct ConfirmEraseItems: View {
    ///         @State private var isShowingDialog = false
    ///
    ///         @AppStorage("suppressEraseItemAlert")
    ///         private var suppressAlert = false
    ///
    ///         var body: some View {
    ///             Button("Delete Items") {
    ///                 if !suppressAlert {
    ///                     isShowingDialog = true
    ///                 } else {
    ///                     // Handle item deletion.
    ///                 }
    ///             }
    ///             .confirmationDialog(
    ///                 "Are you sure you want to erase these items?",
    ///                 isPresented: $isShowingDialog
    ///             ) {
    ///                 Button("Erase", role: .destructive) {
    ///                     // Handle item deletion.
    ///                 }
    ///                 Button("Cancel", role: .cancel) {
    ///                     isShowingDialog = false
    ///                 }
    ///             }
    ///             .dialogSuppressionToggle(
    ///                 "Do not ask about erasing items again",
    ///                 isSuppressed: $suppressAlert)
    ///         }
    ///     }
    ///
    /// - Parameters:
    ///   - titleKey: The title of the suppression toggle in the dialog. This
    ///     parameter can be elided to use the default suppression title.
    ///   - isSuppressed: Whether the suppression toggle is on or off in the
    ///     dialog.
    public func dialogSuppressionToggle(_ titleKey: LocalizedStringKey, isSuppressed: Binding<Bool>) -> some View { return never() }


    /// Enables user suppression of dialogs and alerts presented within `self`,
    /// with a custom suppression message on macOS. Unused on other platforms.
    ///
    /// Applying dialog suppression adds a toggle to dialogs on macOS,
    /// which allows the user to request the alert not be displayed again.
    /// Typically whether a dialog is suppressed is stored in `AppStorage`
    /// and used to decide whether to present the dialog in the future.
    ///
    /// The following example configures a `confirmationDialog` with a
    /// suppression toggle. The toggle's state is stored in `AppStorage` and
    /// used to determine whether or not to show the dialog when the
    /// "Delete Items" button is pressed.
    ///
    ///     struct ConfirmEraseItems: View {
    ///         @State private var isShowingDialog = false
    ///
    ///         @AppStorage("suppressEraseItemAlert")
    ///         private var suppressAlert = false
    ///
    ///         var body: some View {
    ///             Button("Delete Items") {
    ///                 if !suppressAlert {
    ///                     isShowingDialog = true
    ///                 } else {
    ///                     // Handle item deletion.
    ///                 }
    ///             }
    ///             .confirmationDialog(
    ///                 "Are you sure you want to erase these items?",
    ///                 isPresented: $isShowingDialog
    ///             ) {
    ///                 Button("Erase", role: .destructive) {
    ///                     // Handle item deletion.
    ///                 }
    ///                 Button("Cancel", role: .cancel) {
    ///                     isShowingDialog = false
    ///                 }
    ///             }
    ///             .dialogSuppressionToggle(
    ///                 "Do not ask about erasing items again",
    ///                 isSuppressed: $suppressAlert)
    ///         }
    ///     }
    ///
    /// - Parameters:
    ///   - title: The title of the suppression toggle in the dialog. This
    ///     parameter can be elided to use the default suppression title.
    ///   - isSuppressed: Whether the suppression toggle is on or off in the
    ///     dialog.
    public func dialogSuppression<S>(_ title: S, isSuppressed: Binding<Bool>) -> some View where S : StringProtocol { return never() }


    /// Enables user suppression of dialogs and alerts presented within `self`,
    /// with a custom suppression message on macOS. Unused on other platforms.
    ///
    /// Applying dialog suppression adds a toggle to dialogs on macOS,
    /// which allows the user to request the alert not be displayed again.
    /// Typically whether a dialog is suppressed is stored in `AppStorage`
    /// and used to decide whether to present the dialog in the future.
    ///
    /// The following example configures a `confirmationDialog` with a
    /// suppression toggle. The toggle's state is stored in `AppStorage` and
    /// used to determine whether or not to show the dialog when the
    /// "Delete Items" button is pressed.
    ///
    ///     struct ConfirmEraseItems: View {
    ///         @State private var isShowingDialog = false
    ///
    ///         @AppStorage("suppressEraseItemAlert")
    ///         private var suppressAlert = false
    ///
    ///         var body: some View {
    ///             Button("Delete Items") {
    ///                 if !suppressAlert {
    ///                     isShowingDialog = true
    ///                 } else {
    ///                     // Handle item deletion.
    ///                 }
    ///             }
    ///             .confirmationDialog(
    ///                 "Are you sure you want to erase these items?",
    ///                 isPresented: $isShowingDialog
    ///             ) {
    ///                 Button("Erase", role: .destructive) {
    ///                     // Handle item deletion.
    ///                 }
    ///                 Button("Cancel", role: .cancel) {
    ///                     isShowingDialog = false
    ///                 }
    ///             }
    ///             .dialogSuppressionToggle(
    ///                 Text("Do not ask about erasing items again"),
    ///                 isSuppressed: $suppressAlert)
    ///         }
    ///     }
    ///
    /// - Parameters:
    ///   - label: The label of the suppression toggle in the dialog. This
    ///     parameter can be elided to use the default suppression title.
    ///   - isSuppressed: Whether the suppression toggle is on or off in the
    ///     dialog.
    public func dialogSuppressionToggle(_ label: Text, isSuppressed: Binding<Bool>) -> some View { return never() }


    /// Enables user suppression of dialogs and alerts presented within `self`,
    /// with a default suppression message on macOS. Unused on other platforms.
    ///
    /// Applying dialog suppression adds a toggle to dialogs on macOS,
    /// which allows the user to request the alert not be displayed again.
    /// Typically whether a dialog is suppressed is stored in `AppStorage`
    /// and used to decide whether to present the dialog in the future.
    ///
    /// The following example configures a `confirmationDialog` with a
    /// suppression toggle. The toggle's state is stored in `AppStorage` and
    /// used to determine whether or not to show the dialog when the
    /// "Delete Items" button is pressed.
    ///
    ///     struct ConfirmEraseItems: View {
    ///         @State private var isShowingDialog = false
    ///
    ///         @AppStorage("suppressEraseItemAlert")
    ///         private var suppressAlert = false
    ///
    ///         var body: some View {
    ///             Button("Delete Items") {
    ///                 if !suppressAlert {
    ///                     isShowingDialog = true
    ///                 } else {
    ///                     // Handle item deletion.
    ///                 }
    ///             }
    ///             .confirmationDialog(
    ///                 "Are you sure you want to erase these items?",
    ///                 isPresented: $isShowingDialog
    ///             ) {
    ///                 Button("Erase", role: .destructive) {
    ///                     // Handle item deletion.
    ///                 }
    ///                 Button("Cancel", role: .cancel) {
    ///                     isShowingDialog = false
    ///                 }
    ///             }
    ///             .dialogSuppressionToggle(isSuppressed: $suppressAlert)
    ///         }
    ///     }
    ///
    /// - Parameter isSuppressed: Whether the suppression toggle is on or off
    ///   in the dialog.
    public func dialogSuppressionToggle(isSuppressed: Binding<Bool>) -> some View { return never() }

}

extension View {

    /// Changes the view's proposed area to extend outside the screen's safe
    /// areas.
    ///
    /// Use `edgesIgnoringSafeArea(_:)` to change the area proposed for this
    /// view so that — were the proposal accepted — this view could extend
    /// outside the safe area to the bounds of the screen for the specified
    /// edges.
    ///
    /// For example, you can propose that a text view ignore the safe area's top
    /// inset:
    ///
    ///     VStack {
    ///         Text("This text is outside of the top safe area.")
    ///             .edgesIgnoringSafeArea([.top])
    ///             .border(Color.purple)
    ///         Text("This text is inside VStack.")
    ///             .border(Color.yellow)
    ///     }
    ///     .border(Color.gray)
    ///
    /// ![A screenshot showing a view whose bounds exceed the safe area of the
    /// screen.](SkipUI-View-edgesIgnoringSafeArea.png)
    ///
    /// Depending on the surrounding view hierarchy, SkipUI may not honor an
    /// `edgesIgnoringSafeArea(_:)` request. This can happen, for example, if
    /// the view is inside a container that respects the screen's safe area. In
    /// that case you may need to apply `edgesIgnoringSafeArea(_:)` to the
    /// container instead.
    ///
    /// - Parameter edges: The set of the edges in which to expand the size
    ///   requested for this view.
    ///
    /// - Returns: A view that may extend outside of the screen's safe area
    ///   on the edges specified by `edges`.
    @available(iOS, introduced: 13.0, deprecated: 100000.0, message: "Use ignoresSafeArea(_:edges:) instead.")
    @available(macOS, introduced: 10.15, deprecated: 100000.0, message: "Use ignoresSafeArea(_:edges:) instead.")
    @available(tvOS, introduced: 13.0, deprecated: 100000.0, message: "Use ignoresSafeArea(_:edges:) instead.")
    @available(watchOS, introduced: 6.0, deprecated: 100000.0, message: "Use ignoresSafeArea(_:edges:) instead.")
    @available(xrOS, introduced: 1.0, deprecated: 100000.0, message: "Use ignoresSafeArea(_:edges:) instead.")
    @inlinable public func edgesIgnoringSafeArea(_ edges: Edge.Set) -> some View { return never() }

}

@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
extension View {

    /// Expands the view out of its safe area.
    ///
    /// - Parameters:
    ///   - regions: the kinds of rectangles removed from the safe area
    ///     that should be ignored (i.e. added back to the safe area
    ///     of the new child view).
    ///   - edges: the edges of the view that may be outset, any edges
    ///     not in this set will be unchanged, even if that edge is
    ///     abutting a safe area listed in `regions`.
    ///
    /// - Returns: a new view with its safe area expanded.
    ///
    @inlinable public func ignoresSafeArea(_ regions: SafeAreaRegions = .all, edges: Edge.Set = .all) -> some View { return never() }

}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension View {

    /// Sets the environment value of the specified key path to the given value.
    ///
    /// Use this modifier to set one of the writable properties of the
    /// ``EnvironmentValues`` structure, including custom values that you
    /// create. For example, you can set the value associated with the
    /// ``EnvironmentValues/truncationMode`` key:
    ///
    ///     MyView()
    ///         .environment(\.truncationMode, .head)
    ///
    /// You then read the value inside `MyView` or one of its descendants
    /// using the ``Environment`` property wrapper:
    ///
    ///     struct MyView: View {
    ///         @Environment(\.truncationMode) var truncationMode: Text.TruncationMode
    ///
    ///         var body: some View { ... }
    ///     }
    ///
    /// SkipUI provides dedicated view modifiers for setting most
    /// environment values, like the ``View/truncationMode(_:)``
    /// modifier which sets the ``EnvironmentValues/truncationMode`` value:
    ///
    ///     MyView()
    ///         .truncationMode(.head)
    ///
    /// Prefer the dedicated modifier when available, and offer your own when
    /// defining custom environment values, as described in
    /// ``EnvironmentKey``.
    ///
    /// The ``View/environment(_:_:)`` modifier affects the given view,
    /// as well as that view's descendant views. It has no effect
    /// outside the view hierarchy on which you call it.
    ///
    /// - Parameters:
    ///   - keyPath: A key path that indicates the property of the
    ///     ``EnvironmentValues`` structure to update.
    ///   - value: The new value to set for the item specified by `keyPath`.
    ///
    /// - Returns: A view that has the given value set in its environment.
    @inlinable public func environment<V>(_ keyPath: WritableKeyPath<EnvironmentValues, V>, _ value: V) -> some View { return never() }

}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension View {

    /// Controls the display order of overlapping views.
    ///
    /// Use `zIndex(_:)` when you want to control the front-to-back ordering of
    /// views.
    ///
    /// In this example there are two overlapping rotated rectangles. The
    /// frontmost is represented by the larger index value.
    ///
    ///     VStack {
    ///         Rectangle()
    ///             .fill(Color.yellow)
    ///             .frame(width: 100, height: 100, alignment: .center)
    ///             .zIndex(1) // Top layer.
    ///
    ///         Rectangle()
    ///             .fill(Color.red)
    ///             .frame(width: 100, height: 100, alignment: .center)
    ///             .rotationEffect(.degrees(45))
    ///             // Here a zIndex of 0 is the default making
    ///             // this the bottom layer.
    ///     }
    ///
    /// ![A screenshot showing two overlapping rectangles. The frontmost view is
    /// represented by the larger zIndex value.](SkipUI-View-zIndex.png)
    ///
    /// - Parameter value: A relative front-to-back ordering for this view; the
    ///   default is `0`.
    @inlinable public func zIndex(_ value: Double) -> some View { return never() }

}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension View {

    /// Sets the color of the foreground elements displayed by this view.
    ///
    /// - Parameter color: The foreground color to use when displaying this
    ///   view. Pass `nil` to remove any custom foreground color and to allow
    ///   the system or the container to provide its own foreground color.
    ///   If a container-specific override doesn't exist, the system uses
    ///   the primary color.
    ///
    /// - Returns: A view that uses the foreground color you supply.
    @available(iOS, introduced: 13.0, deprecated: 100000.0, renamed: "foregroundStyle(_:)")
    @available(macOS, introduced: 10.15, deprecated: 100000.0, renamed: "foregroundStyle(_:)")
    @available(tvOS, introduced: 13.0, deprecated: 100000.0, renamed: "foregroundStyle(_:)")
    @available(watchOS, introduced: 6.0, deprecated: 100000.0, renamed: "foregroundStyle(_:)")
    @available(xrOS, introduced: 1.0, deprecated: 100000.0, renamed: "foregroundStyle(_:)")
    @inlinable public func foregroundColor(_ color: Color?) -> some View { return never() }

}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
extension View {

    /// Associates a fully formed string with the value of this view.
    ///
    /// Use this method to associate a fully formed string with a
    /// view that is within a search suggestion list context. The system
    /// uses this value when the view is selected to replace the
    /// partial text being currently edited of the associated search field.
    ///
    /// On tvOS, the string that you provide to the this modifier is
    /// used when displaying the associated suggestion and when
    /// replacing the partial text of the search field.
    ///
    ///     SearchPlaceholderView()
    ///         .searchable(text: $text) {
    ///             Text("🍎").searchCompletion("apple")
    ///             Text("🍐").searchCompletion("pear")
    ///             Text("🍌").searchCompletion("banana")
    ///         }
    ///
    /// - Parameters:
    ///   - text: A string to use as the view’s completion.
    public func searchCompletion(_ completion: String) -> some View { return never() }

}

extension View {

    /// Associates a search token with the value of this view.
    ///
    /// Use this method to associate a search token with a view that is
    /// within a search suggestion list context. The system uses this value
    /// when the view is selected to replace the partial text being currently
    /// edited of the associated search field.
    ///
    ///     enum FruitToken: Hashable, Identifiable, CaseIterable {
    ///         case apple
    ///         case pear
    ///         case banana
    ///
    ///         var id: Self { self }
    ///     }
    ///
    ///     @State private var text = ""
    ///     @State private var tokens: [FruitToken] = []
    ///
    ///     SearchPlaceholderView()
    ///         .searchable(text: $text, tokens: $tokens) { token in
    ///             switch token {
    ///             case .apple: Text("Apple")
    ///             case .pear: Text("Pear")
    ///             case .banana: Text("Banana")
    ///             }
    ///         }
    ///         .searchSuggestions {
    ///             Text("🍎").searchCompletion(FruitToken.apple)
    ///             Text("🍐").searchCompletion(FruitToken.pear)
    ///             Text("🍌").searchCompletion(FruitToken.banana)
    ///         }
    ///
    /// - Parameters:
    ///   - token: Data to use as the view’s completion.
    @available(iOS 16.0, macOS 13.0, *)
    @available(tvOS, unavailable)
    @available(watchOS, unavailable)
    public func searchCompletion<T>(_ token: T) -> some View where T : Identifiable { return never() }


    /// Configures how to display search suggestions within this view.
    ///
    /// SkipUI presents search suggestions differently depending on several
    /// factors, like the platform, the position of the search field, and the
    /// size class. Use this modifier when you want to only display suggestions
    /// in certain ways under certain conditions. For example, you might choose
    /// to display suggestions in a menu when possible, but directly filter
    /// your data source otherwise.
    ///
    ///     enum FruitSuggestion: String, Identifiable {
    ///         case apple, banana, orange
    ///         var id: Self { self }
    ///     }
    ///
    ///     @State private var text = ""
    ///     @State private var suggestions: [FruitSuggestion] = []
    ///
    ///     var body: some View {
    ///         MainContent()
    ///             .searchable(text: $text) {
    ///                 ForEach(suggestions) { suggestion
    ///                     Text(suggestion.rawValue)
    ///                         .searchCompletion(suggestion.rawValue)
    ///                 }
    ///                 .searchSuggestions(.hidden, for: .content)
    ///             }
    ///     }
    ///
    /// - Parameters:
    ///   - visibility: The visibility of the search suggestions
    ///     for the specified locations.
    ///   - placements: The set of locations in which to set the visibility of
    ///     search suggestions.
    @available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
    public func searchSuggestions(_ visibility: Visibility, for placements: SearchSuggestionsPlacement.Set) -> some View { return never() }

}

@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
extension View {

    /// Associates a value with a custom layout property.
    ///
    /// Use this method to set a value for a custom property that
    /// you define with ``LayoutValueKey``. For example, if you define
    /// a `Flexibility` key, you can set the key on a ``Text`` view
    /// using the key's type and a value:
    ///
    ///     Text("Another View")
    ///         .layoutValue(key: Flexibility.self, value: 3)
    ///
    /// For convenience, you might define a method that does this in an
    /// extension to ``View``:
    ///
    ///     extension View {
    ///         func layoutFlexibility(_ value: CGFloat?) -> some View {
    ///             layoutValue(key: Flexibility.self, value: value)
    ///         }
    ///     }
    ///
    /// This method makes the call site easier to read:
    ///
    ///     Text("Another View")
    ///         .layoutFlexibility(3)
    ///
    /// If you perform layout operations in a type that conforms to the
    /// ``Layout`` protocol, you can read the key's associated value for
    /// each subview of your custom layout type. Do this by indexing the
    /// subview's proxy with the key. For more information, see
    /// ``LayoutValueKey``.
    ///
    /// - Parameters:
    ///   - key: The type of the key that you want to set a value for.
    ///     Create the key as a type that conforms to the ``LayoutValueKey``
    ///     protocol.
    ///   - value: The value to assign to the key for this view.
    ///     The value must be of the type that you establish for the key's
    ///     associated value when you implement the key's
    ///     ``LayoutValueKey/defaultValue`` property.
    ///
    /// - Returns: A view that has the specified value for the specified key.
    @inlinable public func layoutValue<K>(key: K.Type, value: K.Value) -> some View where K : LayoutValueKey { return never() }

}

@available(macOS 13.0, iOS 16.0, tvOS 16.0, watchOS 9.0, *)
extension View {

    /// Adds an accessibility zoom action to the view. Actions allow
    /// assistive technologies, such as VoiceOver, to interact with the
    /// view by invoking the action.
    ///
    /// For example, this is how a zoom action is used to transform the scale
    /// of a shape which has a `MagnificationGesture`.
    ///
    ///     var body: some View {
    ///         Circle()
    ///             .scaleEffect(magnifyBy)
    ///             .gesture(magnification)
    ///             .accessibilityLabel("Circle Magnifier")
    ///             .accessibilityZoomAction { action in
    ///                 switch action.direction {
    ///                 case .zoomIn:
    ///                     magnifyBy += 0.5
    ///                 case .zoomOut:
    ///                      magnifyBy -= 0.5
    ///                 }
    ///             }
    ///     }
    ///
    public func accessibilityZoomAction(_ handler: @escaping (AccessibilityZoomGestureAction) -> Void) -> ModifiedContent<Self, AccessibilityAttachmentModifier> { fatalError() }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension View {

    /// Applies an affine transformation to this view's rendered output.
    ///
    /// Use `transformEffect(_:)` to rotate, scale, translate, or skew the
    /// output of the view according to the provided
    /// .
    ///
    /// In the example below, the text is rotated at -30˚ on the `y` axis.
    ///
    ///     let transform = CGAffineTransform(rotationAngle: -30 * (.pi / 180))
    ///
    ///     Text("Projection effect using transforms")
    ///         .transformEffect(transform)
    ///         .border(Color.gray)
    ///
    /// ![A screenshot of a view showing text that is rotated at -30 degrees on
    /// the y axis.](SkipUI-View-transformEffect.png)
    ///
    /// - Parameter transform: A
    ///  to
    /// apply to the view.
    @inlinable public func transformEffect(_ transform: CGAffineTransform) -> some View { return never() }

}

extension View {

    /// Presents an action sheet using the given item as a data source for the
    /// sheet's content.
    ///
    /// Use this method when you need to populate the fields of an action sheet
    /// with content from a data source. The example below shows a custom data
    /// source, `FileDetails`, that provides data to populate the action sheet:
    ///
    ///     struct FileDetails: Identifiable {
    ///         var id: String { name }
    ///         let name: String
    ///         let fileType: UTType
    ///     }
    ///
    ///     struct ConfirmFileImport: View {
    ///         @State private var sheetDetail: FileDetails?
    ///
    ///         var body: some View {
    ///             Button("Show Action Sheet") {
    ///                 sheetDetail = FileDetails(name: "MyImageFile.png",
    ///                                           fileType: .png)
    ///             }
    ///             .actionSheet(item: $sheetDetail) { detail in
    ///                 ActionSheet(
    ///                     title: Text("File Import"),
    ///                     message: Text("""
    ///                              Import \(detail.name)?
    ///                              File Type: \(detail.fileType.description)
    ///                              """),
    ///                     buttons: [
    ///                         .destructive(Text("Import"),
    ///                                      action: importFile),
    ///                         .cancel()
    ///                     ])
    ///             }
    ///         }
    ///
    ///         func importFile() {
    ///             // Handle import action.
    ///         }
    ///     }
    ///
    /// ![A screenshot showing an action sheet populated using a custom data
    /// source that describes a file and file
    /// format.](SkipUI-View-ActionSheetItemContent.png)
    ///
    /// - Parameters:
    ///   - item: A binding to an optional source of truth for the action
    ///     sheet. When `item` is non-`nil`, the system passes
    ///     the contents to the modifier's closure. You use this content
    ///     to populate the fields of an action sheet that you create that the
    ///     system displays to the user. If `item` changes, the system
    ///     dismisses the currently displayed action sheet and replaces it
    ///     with a new one using the same process.
    ///   - content: A closure returning the ``ActionSheet`` you create.
    @available(iOS, introduced: 13.0, deprecated: 100000.0, message: "use `confirmationDialog(title:isPresented:titleVisibility:presenting::actions:)`instead.")
    @available(macOS, unavailable)
    @available(tvOS, introduced: 13.0, deprecated: 100000.0, message: "use `confirmationDialog(title:isPresented:titleVisibility:presenting:actions:)`instead.")
    @available(watchOS, introduced: 6.0, deprecated: 100000.0, message: "use `confirmationDialog(title:isPresented:titleVisibility:presenting:actions:)`instead.")
    public func actionSheet<T>(item: Binding<T?>, content: (T) -> ActionSheet) -> some View where T : Identifiable { return never() }


    /// Presents an action sheet when a given condition is true.
    ///
    /// In the example below, a button conditionally presents an action sheet
    /// depending upon the value of a bound Boolean variable. When the Boolean
    /// value is set to `true`, the system displays an action sheet with both
    /// destructive and default actions:
    ///
    ///     struct ConfirmEraseItems: View {
    ///         @State private var isShowingSheet = false
    ///         var body: some View {
    ///             Button("Show Action Sheet", action: {
    ///                 isShowingSheet = true
    ///             })
    ///             .actionSheet(isPresented: $isShowingSheet) {
    ///                 ActionSheet(
    ///                     title: Text("Permanently erase the items in the Trash?"),
    ///                     message: Text("You can't undo this action."),
    ///                     buttons:[
    ///                         .destructive(Text("Empty Trash"),
    ///                                      action: emptyTrashAction),
    ///                         .cancel()
    ///                     ]
    ///                 )}
    ///         }
    ///
    ///         func emptyTrashAction() {
    ///             // Handle empty trash action.
    ///         }
    ///     }
    ///
    /// ![An action sheet with a title and message showing the use of default
    /// and destructive button
    /// types.](SkipUI-View-ActionSheetisPresentedContent.png)
    ///
    /// > Note: In regular size classes in iOS, the system renders alert sheets
    ///    as a popover that the user dismisses by tapping anywhere outside the
    ///    popover, rather than displaying the default dismiss button.
    ///
    /// - Parameters:
    ///   - isPresented: A binding to a Boolean value that determines whether
    ///     to present the action sheet that you create in the modifier's
    ///     `content` closure. When the user presses or taps the sheet's default
    ///     action button the system sets this value to `false` dismissing
    ///     the sheet.
    ///   - content: A closure returning the `ActionSheet` to present.
    @available(iOS, introduced: 13.0, deprecated: 100000.0, message: "use `confirmationDialog(title:isPresented:titleVisibility:presenting::actions:)`instead.")
    @available(macOS, unavailable)
    @available(tvOS, introduced: 13.0, deprecated: 100000.0, message: "use `confirmationDialog(title:isPresented:titleVisibility:presenting:actions:)`instead.")
    @available(watchOS, introduced: 6.0, deprecated: 100000.0, message: "use `confirmationDialog(title:isPresented:titleVisibility:presenting:actions:)`instead.")
    public func actionSheet(isPresented: Binding<Bool>, content: () -> ActionSheet) -> some View { return never() }

}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension View {

    /// Adds a condition that controls whether users can interact with this
    /// view.
    ///
    /// The higher views in a view hierarchy can override the value you set on
    /// this view. In the following example, the button isn't interactive
    /// because the outer `disabled(_:)` modifier overrides the inner one:
    ///
    ///     HStack {
    ///         Button(Text("Press")) {}
    ///         .disabled(false)
    ///     }
    ///     .disabled(true)
    ///
    /// - Parameter disabled: A Boolean value that determines whether users can
    ///   interact with this view.
    ///
    /// - Returns: A view that controls whether users can interact with this
    ///   view.
    @inlinable public func disabled(_ disabled: Bool) -> some View { return never() }

}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension View {

    /// Sets the accent color for this view and the views it contains.
    ///
    /// Use `accentColor(_:)` when you want to apply a broad theme color to
    /// your app's user interface. Some styles of controls use the accent color
    /// as a default tint color.
    ///
    /// > Note: In macOS, SkipUI applies customization of the accent color
    /// only if the user chooses Multicolor under General > Accent color
    /// in System Preferences.
    ///
    /// In the example below, the outer ``VStack`` contains two child views. The
    /// first is a button with the default accent color. The second is a ``VStack``
    /// that contains a button and a slider, both of which adopt the purple
    /// accent color of their containing view. Note that the ``Text`` element
    /// used as a label alongside the `Slider` retains its default color.
    ///
    ///     VStack(spacing: 20) {
    ///         Button(action: {}) {
    ///             Text("Regular Button")
    ///         }
    ///         VStack {
    ///             Button(action: {}) {
    ///                 Text("Accented Button")
    ///             }
    ///             HStack {
    ///                 Text("Accented Slider")
    ///                 Slider(value: $sliderValue, in: -100...100, step: 0.1)
    ///             }
    ///         }
    ///         .accentColor(.purple)
    ///     }
    ///
    /// ![A VStack showing two child views: one VStack containing a default
    /// accented button, and a second VStack where the VStack has a purple
    /// accent color applied. The accent color modifies the enclosed button and
    /// slider, but not the color of a Text item used as a label for the
    /// slider.](View-accentColor-1)
    ///
    /// - Parameter accentColor: The color to use as an accent color. Set the
    ///   value to `nil` to use the inherited accent color.
    @available(iOS, introduced: 13.0, deprecated: 100000.0, message: "Use the asset catalog's accent color or View.tint(_:) instead.")
    @available(macOS, introduced: 10.15, deprecated: 100000.0, message: "Use the asset catalog's accent color or View.tint(_:) instead.")
    @available(tvOS, introduced: 13.0, deprecated: 100000.0, message: "Use the asset catalog's accent color or View.tint(_:) instead.")
    @available(watchOS, introduced: 6.0, deprecated: 100000.0, message: "Use the asset catalog's accent color or View.tint(_:) instead.")
    @available(xrOS, introduced: 1.0, deprecated: 100000.0, message: "Use the asset catalog's accent color or View.tint(_:) instead.")
    @inlinable public func accentColor(_ accentColor: Color?) -> some View { return never() }

}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension View {

    /// Rotates this view's rendered output around the specified point.
    ///
    /// Use `rotationEffect(_:anchor:)` to rotate the view by a specific amount.
    ///
    /// In the example below, the text is rotated by 22˚.
    ///
    ///     Text("Rotation by passing an angle in degrees")
    ///         .rotationEffect(.degrees(22))
    ///         .border(Color.gray)
    ///
    /// ![A screenshot showing rotation effect rotating the text 22 degrees with
    /// respect to its view.](SkipUI-View-rotationEffect.png)
    ///
    /// - Parameters:
    ///   - angle: The angle at which to rotate the view.
    ///   - anchor: The location with a default of ``UnitPoint/center`` that
    ///     defines a point at which the rotation is anchored.
    @inlinable public func rotationEffect(_ angle: Angle, anchor: UnitPoint = .center) -> some View { return never() }

}

extension View {

    /// Specifies if the view is focusable.
    ///
    /// - Parameters isFocusable: A Boolean value that indicates whether this
    ///   view is focusable.
    ///
    /// - Returns: A view that sets whether a view is focusable.
    @available(iOS 17.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
    public func focusable(_ isFocusable: Bool = true) -> some View { return never() }


    /// Specifies if the view is focusable, and if so, what focus-driven
    /// interactions it supports.
    ///
    /// By default, SkipUI enables all possible focus interactions. However, on
    /// macOS and iOS it is conventional for button-like views to only accept
    /// focus when the user has enabled keyboard navigation system-wide in the
    /// Settings app. Clients can reproduce this behavior with custom views by
    /// only supporting `.activate` interactions.
    ///
    ///     MyTapGestureView(...)
    ///         .focusable(interactions: .activate)
    ///
    /// - Note: The focus interactions allowed for custom views changed in
    ///   macOS 14—previously, custom views could only become focused with
    ///   keyboard navigation enabled system-wide. Clients built using older
    ///   SDKs will continue to see the older focus behavior, while custom views
    ///   in clients built using macOS 14 or later will always be focusable
    ///   unless the client requests otherwise by specifying a restricted set of
    ///   focus interactions.
    ///
    /// - Parameters:
    ///   - isFocusable: `true` if the view should participate in focus;
    ///     `false` otherwise. The default value is `true`.
    ///   - interactions: The types of focus interactions supported by the view.
    ///     The default value is `.automatic`.
    /// - Returns: A view that sets whether its child is focusable.
    @available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
    public func focusable(_ isFocusable: Bool = true, interactions: FocusInteractions) -> some View { return never() }


    /// Adds a condition that controls whether this view can display focus
    /// effects, such as a default focus ring or hover effect.
    ///
    /// The higher views in a view hierarchy can override the value you set on
    /// this view. In the following example, the button does not display a focus
    /// effect because the outer `focusEffectDisabled(_:)` modifier overrides
    /// the inner one:
    ///
    ///     HStack {
    ///         Button("Press") {}
    ///             .focusEffectDisabled(false)
    ///     }
    ///     .focusEffectDisabled(true)
    ///
    /// - Parameter disabled: A Boolean value that determines whether this view
    ///   can display focus effects.
    /// - Returns: A view that controls whether focus effects can be displayed
    ///   in this view.
    @available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
    public func focusEffectDisabled(_ disabled: Bool = true) -> some View { return never() }

}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension View {

    /// Scales this view's rendered output by the given vertical and horizontal
    /// size amounts, relative to an anchor point.
    ///
    /// Use `scaleEffect(_:anchor:)` to scale a view by applying a scaling
    /// transform of a specific size, specified by `scale`.
    ///
    ///     Image(systemName: "envelope.badge.fill")
    ///         .resizable()
    ///         .frame(width: 100, height: 100, alignment: .center)
    ///         .foregroundColor(Color.red)
    ///         .scaleEffect(CGSize(x: 0.9, y: 1.3), anchor: .leading)
    ///         .border(Color.gray)
    ///
    /// ![A screenshot showing a red envelope scaled to a size of 90x130
    /// pixels.](SkipUI-View-scaleEffect.png)
    ///
    /// - Parameters:
    ///   - scale: A  that
    ///     represents the horizontal and vertical amount to scale the view.
    ///   - anchor: The point with a default of ``UnitPoint/center`` that
    ///     defines the location within the view from which to apply the
    ///     transformation.
    @inlinable public func scaleEffect(_ scale: CGSize, anchor: UnitPoint = .center) -> some View { return never() }


    /// Scales this view's rendered output by the given amount in both the
    /// horizontal and vertical directions, relative to an anchor point.
    ///
    /// Use `scaleEffect(_:anchor:)` to apply a horizontally and vertically
    /// scaling transform to a view.
    ///
    ///     Image(systemName: "envelope.badge.fill")
    ///         .resizable()
    ///         .frame(width: 100, height: 100, alignment: .center)
    ///         .foregroundColor(Color.red)
    ///         .scaleEffect(2, anchor: .leading)
    ///         .border(Color.gray)
    ///
    /// ![A screenshot showing a 100x100 pixel red envelope scaled up to 2x the
    /// size of its view.](SkipUI-View-scaleEffect-cgfloat.png)
    ///
    /// - Parameters:
    ///   - s: The amount to scale the view in the view in both the horizontal
    ///     and vertical directions.
    ///   - anchor: The anchor point with a default of ``UnitPoint/center`` that
    ///     indicates the starting position for the scale operation.
    @inlinable public func scaleEffect(_ s: CGFloat, anchor: UnitPoint = .center) -> some View { return never() }


    /// Scales this view's rendered output by the given horizontal and vertical
    /// amounts, relative to an anchor point.
    ///
    /// Use `scaleEffect(x:y:anchor:)` to apply a scaling transform to a view by
    /// a specific horizontal and vertical amount.
    ///
    ///     Image(systemName: "envelope.badge.fill")
    ///         .resizable()
    ///         .frame(width: 100, height: 100, alignment: .center)
    ///         .foregroundColor(Color.red)
    ///         .scaleEffect(x: 0.5, y: 0.5, anchor: .bottomTrailing)
    ///         .border(Color.gray)
    ///
    /// ![A screenshot showing a 100x100 pixel red envelope scaled down 50% in
    /// both the x and y axes.](SkipUI-View-scaleEffect-xy.png)
    ///
    /// - Parameters:
    ///   - x: An amount that represents the horizontal amount to scale the
    ///     view. The default value is `1.0`.
    ///   - y: An amount that represents the vertical amount to scale the view.
    ///     The default value is `1.0`.
    ///   - anchor: The anchor point that indicates the starting position for
    ///     the scale operation.
    @inlinable public func scaleEffect(x: CGFloat = 1.0, y: CGFloat = 1.0, anchor: UnitPoint = .center) -> some View { return never() }

}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension View {

    /// Sets the priority by which a parent layout should apportion space to
    /// this child.
    ///
    /// Views typically have a default priority of `0` which causes space to be
    /// apportioned evenly to all sibling views. Raising a view's layout
    /// priority encourages the higher priority view to shrink later when the
    /// group is shrunk and stretch sooner when the group is stretched.
    ///
    ///     HStack {
    ///         Text("This is a moderately long string.")
    ///             .font(.largeTitle)
    ///             .border(Color.gray)
    ///
    ///         Spacer()
    ///
    ///         Text("This is a higher priority string.")
    ///             .font(.largeTitle)
    ///             .layoutPriority(1)
    ///             .border(Color.gray)
    ///     }
    ///
    /// In the example above, the first ``Text`` element has the default
    /// priority `0` which causes its view to shrink dramatically due to the
    /// higher priority of the second ``Text`` element, even though all of their
    /// other attributes (font, font size and character count) are the same.
    ///
    /// ![A screenshot showing twoText views different layout
    /// priorities.](SkipUI-View-layoutPriority.png)
    ///
    /// A parent layout offers the child views with the highest layout priority
    /// all the space offered to the parent minus the minimum space required for
    /// all its lower-priority children.
    ///
    /// - Parameter value: The priority by which a parent layout apportions
    ///   space to the child.
    @inlinable public func layoutPriority(_ value: Double) -> some View { return never() }

}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension View {

    /// Applies a Gaussian blur to this view.
    ///
    /// Use `blur(radius:opaque:)` to apply a gaussian blur effect to the
    /// rendering of this view.
    ///
    /// The example below shows two ``Text`` views, the first with no blur
    /// effects, the second with `blur(radius:opaque:)` applied with the
    /// `radius` set to `2`. The larger the radius, the more diffuse the
    /// effect.
    ///
    ///     struct Blur: View {
    ///         var body: some View {
    ///             VStack {
    ///                 Text("This is some text.")
    ///                     .padding()
    ///                 Text("This is some blurry text.")
    ///                     .blur(radius: 2.0)
    ///             }
    ///         }
    ///     }
    ///
    /// ![A screenshot showing the effect of applying gaussian blur effect to
    /// the rendering of a view.](SkipUI-View-blurRadius.png)
    ///
    /// - Parameters:
    ///   - radius: The radial size of the blur. A blur is more diffuse when its
    ///     radius is large.
    ///   - opaque: A Boolean value that indicates whether the blur renderer
    ///     permits transparency in the blur output. Set to `true` to create an
    ///     opaque blur, or set to `false` to permit transparency.
    @inlinable public func blur(radius: CGFloat, opaque: Bool = false) -> some View { return never() }

}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension View {

    /// Brightens this view by the specified amount.
    ///
    /// Use `brightness(_:)` to brighten the intensity of the colors in a view.
    /// The example below shows a series of red squares, with their brightness
    /// increasing from 0 (fully red) to 100% (white) in 20% increments.
    ///
    ///     struct Brightness: View {
    ///         var body: some View {
    ///             HStack {
    ///                 ForEach(0..<6) {
    ///                     Color.red.frame(width: 60, height: 60, alignment: .center)
    ///                         .brightness(Double($0) * 0.2)
    ///                         .overlay(Text("\(Double($0) * 0.2 * 100, specifier: "%.0f")%"),
    ///                                  alignment: .bottom)
    ///                         .border(Color.gray)
    ///                 }
    ///             }
    ///         }
    ///     }
    ///
    /// ![Rendering showing the effects of brightness adjustments in 20%
    /// increments from fully-red to white.](SkipUI-View-brightness.png)
    ///
    /// - Parameter amount: A value between 0 (no effect) and 1 (full white
    ///   brightening) that represents the intensity of the brightness effect.
    ///
    /// - Returns: A view that brightens this view by the specified amount.
    @inlinable public func brightness(_ amount: Double) -> some View { return never() }

}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension View {

    /// Inverts the colors in this view.
    ///
    /// The `colorInvert()` modifier inverts all of the colors in a view so that
    /// each color displays as its complementary color. For example, blue
    /// converts to yellow, and white converts to black.
    ///
    /// In the example below, two red squares each have an interior green
    /// circle. The inverted square shows the effect of the square's colors:
    /// complimentary colors for red and green — teal and purple.
    ///
    ///     struct InnerCircleView: View {
    ///         var body: some View {
    ///             Circle()
    ///                 .fill(Color.green)
    ///                 .frame(width: 40, height: 40, alignment: .center)
    ///         }
    ///     }
    ///
    ///     struct ColorInvert: View {
    ///         var body: some View {
    ///             HStack {
    ///                 Color.red.frame(width: 100, height: 100, alignment: .center)
    ///                     .overlay(InnerCircleView(), alignment: .center)
    ///                     .overlay(Text("Normal")
    ///                                  .font(.callout),
    ///                              alignment: .bottom)
    ///                     .border(Color.gray)
    ///
    ///                 Spacer()
    ///
    ///                 Color.red.frame(width: 100, height: 100, alignment: .center)
    ///                     .overlay(InnerCircleView(), alignment: .center)
    ///                     .colorInvert()
    ///                     .overlay(Text("Inverted")
    ///                                  .font(.callout),
    ///                              alignment: .bottom)
    ///                     .border(Color.gray)
    ///             }
    ///             .padding(50)
    ///         }
    ///     }
    ///
    /// ![Two red squares with centered green circles with one showing the
    /// effect of color inversion, which yields teal and purple replacing the
    /// red and green colors.](SkipUI-View-colorInvert.png)
    ///
    /// - Returns: A view that inverts its colors.
    @inlinable public func colorInvert() -> some View { return never() }

}

@available(iOS 17.0, macOS 14.0, tvOS 17.0, *)
@available(watchOS, unavailable)
extension View {

    /// Performs an action if the user presses a key on a hardware keyboard
    /// while the view has focus.
    ///
    /// SkipUI performs the action for key-down and key-repeat events.
    ///
    /// - Parameters:
    ///   - key: The key to match against incoming hardware keyboard events.
    ///   - action: The action to perform. Return `.handled` to consume the
    ///     event and prevent further dispatch, or `.ignored` to allow dispatch
    ///     to continue.
    /// - Returns: A modified view that binds hardware keyboard input
    ///   when focused.
    public func onKeyPress(_ key: KeyEquivalent, action: @escaping () -> KeyPress.Result) -> some View { return never() }


    /// Performs an action if the user presses a key on a hardware keyboard
    /// while the view has focus.
    ///
    /// SkipUI performs the action for the specified event phases.
    ///
    /// - Parameters:
    ///   - key: The key to match against incoming hardware keyboard events.
    ///   - phases: The key-press phases to match (`.down`, `.up`,
    ///     and `.repeat`).
    ///   - action: The action to perform. The action receives a value
    ///     describing the matched key event. Return `.handled` to consume the
    ///     event and prevent further dispatch, or `.ignored` to allow dispatch
    ///     to continue.
    /// - Returns: A modified view that binds hardware keyboard input
    ///   when focused.
    public func onKeyPress(_ key: KeyEquivalent, phases: KeyPress.Phases, action: @escaping (KeyPress) -> KeyPress.Result) -> some View { return never() }


    /// Performs an action if the user presses one or more keys on a hardware
    /// keyboard while the view has focus.
    ///
    /// - Parameters:
    ///   - keys: A set of keys to match against incoming hardware
    ///     keyboard events.
    ///   - phases: The key-press phases to match (`.down`, `.repeat`, and
    ///     `.up`). The default value is `[.down, .repeat]`.
    ///   - action: The action to perform. The action receives a value
    ///     describing the matched key event. Return `.handled` to consume the
    ///     event and prevent further dispatch, or `.ignored` to allow dispatch
    ///     to continue.
    /// - Returns: A modified view that binds keyboard input when focused.
    public func onKeyPress(keys: Set<KeyEquivalent>, phases: KeyPress.Phases = [.down, .repeat], action: @escaping (KeyPress) -> KeyPress.Result) -> some View { return never() }


    /// Performs an action if the user presses one or more keys on a hardware
    /// keyboard while the view has focus.
    ///
    /// - Parameters:
    ///   - characters: The set of characters to match against incoming
    ///     hardware keyboard events.
    ///   - phases: The key-press phases to match (`.down`, `.repeat`, and
    ///     `.up`). The default value is `[.down, .repeat]`.
    ///   - action: The action to perform. The action receives a value
    ///     describing the matched key event. Return `.handled` to consume the
    ///     event and prevent further dispatch, or `.ignored` to allow dispatch
    ///     to continue.
    /// - Returns: A modified view that binds hardware keyboard input
    ///   when focused.
    public func onKeyPress(characters: CharacterSet, phases: KeyPress.Phases = [.down, .repeat], action: @escaping (KeyPress) -> KeyPress.Result) -> some View { return never() }


    /// Performs an action if the user presses any key on a hardware keyboard
    /// while the view has focus.
    ///
    /// - Parameters:
    ///   - phases: The key-press phases to match (`.down`, `.repeat`, and
    ///     `.up`). The default value is `[.down, .repeat]`.
    ///   - action: The action to perform. The action receives a value
    ///     describing the matched key event. Return `.handled` to consume the
    ///     event and prevent further dispatch, or `.ignored` to allow dispatch
    ///     to continue.
    /// - Returns: A modified view that binds hardware keyboard input
    ///   when focused.
    public func onKeyPress(phases: KeyPress.Phases = [.down, .repeat], action: @escaping (KeyPress) -> KeyPress.Result) -> some View { return never() }

}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension View {

    /// Adds a color multiplication effect to this view.
    ///
    /// The following example shows two versions of the same image side by side;
    /// at left is the original, and at right is a duplicate with the
    /// `colorMultiply(_:)` modifier applied with ``ShapeStyle/purple``.
    ///
    ///     struct InnerCircleView: View {
    ///         var body: some View {
    ///             Circle()
    ///                 .fill(Color.green)
    ///                 .frame(width: 40, height: 40, alignment: .center)
    ///         }
    ///     }
    ///
    ///     struct ColorMultiply: View {
    ///         var body: some View {
    ///             HStack {
    ///                 Color.red.frame(width: 100, height: 100, alignment: .center)
    ///                     .overlay(InnerCircleView(), alignment: .center)
    ///                     .overlay(Text("Normal")
    ///                                  .font(.callout),
    ///                              alignment: .bottom)
    ///                     .border(Color.gray)
    ///
    ///                 Spacer()
    ///
    ///                 Color.red.frame(width: 100, height: 100, alignment: .center)
    ///                     .overlay(InnerCircleView(), alignment: .center)
    ///                     .colorMultiply(Color.purple)
    ///                     .overlay(Text("Multiply")
    ///                                 .font(.callout),
    ///                              alignment: .bottom)
    ///                     .border(Color.gray)
    ///             }
    ///             .padding(50)
    ///         }
    ///     }
    ///
    /// ![A screenshot showing two images showing the effect of multiplying the
    /// colors of an image with another color.](SkipUI-View-colorMultiply.png)
    ///
    /// - Parameter color: The color to bias this view toward.
    ///
    /// - Returns: A view with a color multiplication effect.
    @inlinable public func colorMultiply(_ color: Color) -> some View { return never() }

}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension View {

    /// Sets the contrast and separation between similar colors in this view.
    ///
    /// Apply contrast to a view to increase or decrease the separation between
    /// similar colors in the view.
    ///
    /// In the example below, the `contrast(_:)` modifier is applied to a set of
    /// red squares each containing a contrasting green inner circle. At each
    /// step in the loop, the `contrast(_:)` modifier changes the contrast of
    /// the circle/square view in 20% increments. This ranges from -20% contrast
    /// (yielding inverted colors — turning the red square to pale-green and the
    /// green circle to mauve), to neutral-gray at 0%, to 100% contrast
    /// (bright-red square / bright-green circle). Applying negative contrast
    /// values, as shown in the -20% square, will apply contrast in addition to
    /// inverting colors.
    ///
    ///     struct CircleView: View {
    ///         var body: some View {
    ///             Circle()
    ///                 .fill(Color.green)
    ///                 .frame(width: 25, height: 25, alignment: .center)
    ///         }
    ///     }
    ///
    ///     struct Contrast: View {
    ///         var body: some View {
    ///             HStack {
    ///                 ForEach(-1..<6) {
    ///                     Color.red.frame(width: 50, height: 50, alignment: .center)
    ///                         .overlay(CircleView(), alignment: .center)
    ///                         .contrast(Double($0) * 0.2)
    ///                         .overlay(Text("\(Double($0) * 0.2 * 100, specifier: "%.0f")%")
    ///                                      .font(.callout),
    ///                                  alignment: .bottom)
    ///                         .border(Color.gray)
    ///                 }
    ///             }
    ///         }
    ///     }
    ///
    /// ![Demonstration of the effect of contrast on a view applying contrast
    /// values from -20% to 100% contrast.](SkipUI-View-contrast.png)
    ///
    /// - Parameter amount: The intensity of color contrast to apply. negative
    ///   values invert colors in addition to applying contrast.
    ///
    /// - Returns: A view that applies color contrast to this view.
    @inlinable public func contrast(_ amount: Double) -> some View { return never() }

}

extension View {

    /// Configures the search suggestions for this view.
    ///
    /// You can suggest search terms during a search operation by providing a
    /// collection of view to this modifier. The interface presents the
    /// suggestion views as a list of choices when someone activates the
    /// search interface. Associate a string with each suggestion
    /// view by adding the ``View/searchCompletion(_:)-2uaf3`` modifier to
    /// the view. For example, you can suggest fruit types by displaying their
    /// emoji, and provide the corresponding search string as a search
    /// completion in each case:
    ///
    ///     ProductList()
    ///         .searchable(text: $text)
    ///         .searchSuggestions {
    ///             Text("🍎").searchCompletion("apple")
    ///             Text("🍐").searchCompletion("pear")
    ///             Text("🍌").searchCompletion("banana")
    ///         }
    ///
    /// When someone chooses a suggestion, SkipUI replaces the text in the
    /// search field with the search completion string. If you omit the search
    /// completion modifier for a particular suggestion view, SkipUI displays
    /// the suggestion, but the suggestion view doesn't react to taps or clicks.
    ///
    /// > Important: In tvOS, searchable modifiers only support suggestion views
    /// of type ``Text``, like in the above example. Other platforms can use any
    /// view for the suggestions, including custom views.
    ///
    /// You can update the suggestions that you provide as conditions change.
    ///
    /// For example, you can specify an array of suggestions that you store
    /// in a model:
    ///
    ///     ProductList()
    ///         .searchable(text: $text)
    ///         .searchSuggestions {
    ///             ForEach(model.suggestedSearches) { suggestion in
    ///                 Label(suggestion.title,  image: suggestion.image)
    ///                     .searchCompletion(suggestion.text)
    ///             }
    ///         }
    ///
    /// If the model's `suggestedSearches` begins as an empty array, the
    /// interface doesn't display any suggestions to start. You can then provide
    /// logic that updates the array based on some condition. For example, you
    /// might update the completions based on the current search text. Note that
    /// certain events or actions, like when someone moves a macOS window, might
    /// dismiss the suggestion view.
    ///
    /// For more information about using search modifiers, see
    /// <doc:Adding-a-search-interface-to-your-app>.
    ///
    /// - Parameters:
    ///   - suggestions: A view builder that produces content that
    ///     populates a list of suggestions.
    @available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
    public func searchSuggestions<S>(@ViewBuilder _ suggestions: () -> S) -> some View where S : View { return never() }

}

extension View {

    /// Marks this view as searchable, which configures the display of a
    /// search field.
    ///
    /// For more information about using searchable modifiers, see
    /// <doc:Adding-a-search-interface-to-your-app>.
    ///
    /// - Parameters:
    ///   - text: The text to display and edit in the search field.
    ///   - placement: Where the search field should attempt to be
    ///     placed based on the containing view hierarchy.
    ///   - prompt: A ``Text`` view representing the prompt of the search field
    ///     which provides users with guidance on what to search for.
    ///   - suggestions: A view builder that produces content that
    ///     populates a list of suggestions.
    @available(iOS, introduced: 15.0, deprecated: 100000.0, message: "Use the searchable modifier with the searchSuggestions modifier")
    @available(macOS, introduced: 12.0, deprecated: 100000.0, message: "Use the searchable modifier with the searchSuggestions modifier")
    @available(tvOS, introduced: 15.0, deprecated: 100000.0, message: "Use the searchable modifier with the searchSuggestions modifier")
    @available(watchOS, introduced: 8.0, deprecated: 100000.0, message: "Use the searchable modifier with the searchSuggestions modifier")
    public func searchable<S>(text: Binding<String>, placement: SearchFieldPlacement = .automatic, prompt: Text? = nil, @ViewBuilder suggestions: () -> S) -> some View where S : View { return never() }


    /// Marks this view as searchable, which configures the display of a
    /// search field.
    ///
    /// For more information about using searchable modifiers, see
    /// <doc:Adding-a-search-interface-to-your-app>.
    ///
    /// - Parameters:
    ///   - text: The text to display and edit in the search field.
    ///   - placement: Where the search field should attempt to be
    ///     placed based on the containing view hierarchy.
    ///   - prompt: A key for the localized prompt of the search field
    ///     which provides users with guidance on what to search for.
    ///   - suggestions: A view builder that produces content that
    ///     populates a list of suggestions.
    @available(iOS, introduced: 15.0, deprecated: 100000.0, message: "Use the searchable modifier with the searchSuggestions modifier")
    @available(macOS, introduced: 12.0, deprecated: 100000.0, message: "Use the searchable modifier with the searchSuggestions modifier")
    @available(tvOS, introduced: 15.0, deprecated: 100000.0, message: "Use the searchable modifier with the searchSuggestions modifier")
    @available(watchOS, introduced: 8.0, deprecated: 100000.0, message: "Use the searchable modifier with the searchSuggestions modifier")
    public func searchable<S>(text: Binding<String>, placement: SearchFieldPlacement = .automatic, prompt: LocalizedStringKey, @ViewBuilder suggestions: () -> S) -> some View where S : View { return never() }


    /// Marks this view as searchable, which configures the display of a
    /// search field.
    ///
    /// For more information about using searchable modifiers, see
    /// <doc:Adding-a-search-interface-to-your-app>.
    ///
    /// - Parameters:
    ///   - text: The text to display and edit in the search field.
    ///   - placement: Where the search field should attempt to be
    ///     placed based on the containing view hierarchy.
    ///   - prompt: A string representing the prompt of the search field
    ///     which provides users with guidance on what to search for.
    ///   - suggestions: A view builder that produces content that
    ///     populates a list of suggestions.
    @available(iOS, introduced: 15.0, deprecated: 100000.0, message: "Use the searchable modifier with the searchSuggestions modifier")
    @available(macOS, introduced: 12.0, deprecated: 100000.0, message: "Use the searchable modifier with the searchSuggestions modifier")
    @available(tvOS, introduced: 15.0, deprecated: 100000.0, message: "Use the searchable modifier with the searchSuggestions modifier")
    @available(watchOS, introduced: 8.0, deprecated: 100000.0, message: "Use the searchable modifier with the searchSuggestions modifier")
    public func searchable<V, S>(text: Binding<String>, placement: SearchFieldPlacement = .automatic, prompt: S, @ViewBuilder suggestions: () -> V) -> some View where V : View, S : StringProtocol { return never() }

}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension View {

    /// Adds a grayscale effect to this view.
    ///
    /// A grayscale effect reduces the intensity of colors in this view.
    ///
    /// The example below shows a series of red squares with their grayscale
    /// effect increasing from 0 (reddest) to 99% (fully desaturated) in
    /// approximate 20% increments:
    ///
    ///     struct Saturation: View {
    ///         var body: some View {
    ///             HStack {
    ///                 ForEach(0..<6) {
    ///                     Color.red.frame(width: 60, height: 60, alignment: .center)
    ///                         .grayscale(Double($0) * 0.1999)
    ///                         .overlay(Text("\(Double($0) * 0.1999 * 100, specifier: "%.4f")%"),
    ///                                  alignment: .bottom)
    ///                         .border(Color.gray)
    ///                 }
    ///             }
    ///         }
    ///     }
    ///
    /// ![Rendering showing the effects of grayscale adjustments in
    /// approximately 20% increments from fully-red at 0% to fully desaturated
    /// at 99%.](SkipUI-View-grayscale.png)
    ///
    /// - Parameter amount: The intensity of grayscale to apply from 0.0 to less
    ///   than 1.0. Values closer to 0.0 are more colorful, and values closer to
    ///   1.0 are less colorful.
    ///
    /// - Returns: A view that adds a grayscale effect to this view.
    @inlinable public func grayscale(_ amount: Double) -> some View { return never() }

}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension View {

    /// Applies a hue rotation effect to this view.
    ///
    /// Use hue rotation effect to shift all of the colors in a view according
    /// to the angle you specify.
    ///
    /// The example below shows a series of squares filled with a linear
    /// gradient. Each square shows the effect of a 36˚ hueRotation (a total of
    /// 180˚ across the 5 squares) on the gradient:
    ///
    ///     struct HueRotation: View {
    ///         var body: some View {
    ///             HStack {
    ///                 ForEach(0..<6) {
    ///                     Rectangle()
    ///                         .fill(.linearGradient(
    ///                             colors: [.blue, .red, .green],
    ///                             startPoint: .top, endPoint: .bottom))
    ///                         .hueRotation((.degrees(Double($0 * 36))))
    ///                         .frame(width: 60, height: 60, alignment: .center)
    ///                 }
    ///             }
    ///         }
    ///     }
    ///
    /// ![Shows the effect of hueRotation on a linear
    /// gradient.](SkipUI-hueRotation.png)
    ///
    /// - Parameter angle: The hue rotation angle to apply to the colors in this
    ///   view.
    ///
    /// - Returns: A view that applies a hue rotation effect to this view.
    @inlinable public func hueRotation(_ angle: Angle) -> some View { return never() }

}

@available(iOS 13.0, macOS 11.0, tvOS 13.0, watchOS 6.0, *)
extension View {

    /// Sets the preferred color scheme for this presentation.
    ///
    /// Use one of the values in ``ColorScheme`` with this modifier to set a
    /// preferred color scheme for the nearest enclosing presentation, like a
    /// popover, a sheet, or a window. The value that you set overrides the
    /// user's Dark Mode selection for that presentation. In the example below,
    /// the ``Toggle`` controls an `isDarkMode` state variable, which in turn
    /// controls the color scheme of the sheet that contains the toggle:
    ///
    ///     @State private var isPresented = false
    ///     @State private var isDarkMode = true
    ///
    ///     var body: some View {
    ///         Button("Show Sheet") {
    ///             isPresented = true
    ///         }
    ///         .sheet(isPresented: $isPresented) {
    ///             List {
    ///                 Toggle("Dark Mode", isOn: $isDarkMode)
    ///             }
    ///             .preferredColorScheme(isDarkMode ? .dark : .light)
    ///         }
    ///     }
    ///
    /// If you apply the modifier to any of the views in the sheet --- which in
    /// this case are a ``List`` and a ``Toggle`` --- the value that you set
    /// propagates up through the view hierarchy to the enclosing
    /// presentation, or until another color scheme modifier higher in the
    /// hierarchy overrides it. The value you set also flows down to all child
    /// views of the enclosing presentation.
    ///
    /// A common use for this modifier is to create side-by-side previews of the
    /// same view with light and dark appearances:
    ///
    ///     struct MyView_Previews: PreviewProvider {
    ///         static var previews: some View {
    ///             MyView().preferredColorScheme(.light)
    ///             MyView().preferredColorScheme(.dark)
    ///         }
    ///     }
    ///
    /// If you need to detect the color scheme that currently applies to a view,
    /// read the ``EnvironmentValues/colorScheme`` environment value:
    ///
    ///     @Environment(\.colorScheme) private var colorScheme
    ///
    ///     var body: some View {
    ///         Text(colorScheme == .dark ? "Dark" : "Light")
    ///     }
    ///
    /// - Parameter colorScheme: The preferred color scheme for this view.
    ///
    /// - Returns: A view that sets the color scheme.
    @inlinable public func preferredColorScheme(_ colorScheme: ColorScheme?) -> some View { return never() }

}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension View {

    /// Adds a luminance to alpha effect to this view.
    ///
    /// Use this modifier to create a semitransparent mask, with the opacity of
    /// each part of the modified view controlled by the luminance of the
    /// corresponding part of the original view. Regions of lower luminance
    /// become more transparent, while higher luminance yields greater
    /// opacity.
    ///
    /// In particular, the modifier maps the red, green, and blue components of
    /// each input pixel's color to a grayscale value, and that value becomes
    /// the alpha component of a black pixel in the output. This modifier
    /// produces an effect that's equivalent to using the `feColorMatrix`
    /// filter primitive with the `luminanceToAlpha` type attribute, as defined
    /// by the [Scalable Vector Graphics (SVG) 2](https://www.w3.org/TR/SVG2/)
    /// specification.
    ///
    /// The example below defines a `Palette` view as a series of rectangles,
    /// each composed as a ``Color`` with a particular white value,
    /// and then displays two versions of the palette over a blue background:
    ///
    ///     struct Palette: View {
    ///         var body: some View {
    ///             HStack(spacing: 0) {
    ///                 ForEach(0..<10) { index in
    ///                     Color(white: Double(index) / Double(9))
    ///                         .frame(width: 20, height: 40)
    ///                 }
    ///             }
    ///         }
    ///     }
    ///
    ///     struct LuminanceToAlphaExample: View {
    ///         var body: some View {
    ///             VStack(spacing: 20) {
    ///                 Palette()
    ///
    ///                 Palette()
    ///                     .luminanceToAlpha()
    ///             }
    ///             .padding()
    ///             .background(.blue)
    ///         }
    ///     }
    ///
    /// The unmodified version of the palette contains rectangles that range
    /// from solid black to solid white, thus with increasing luminance. The
    /// second version of the palette, which has the `luminanceToAlpha()`
    /// modifier applied, allows the background to show through in an amount
    /// that corresponds inversely to the luminance of the input.
    ///
    /// ![A screenshot of a blue background with two wide rectangles on it,
    /// arranged vertically, with one above the other. Each is composed of a
    /// series of smaller rectangles arranged from left to right. The component
    /// rectangles of the first large rectangle range from black to white as
    /// you scan from left to right, with each successive component rectangle
    /// slightly whiter than the previous. The component rectangles of the
    /// second large rectangle range from fully transparent to fully opaque,
    /// scanning in the same direction.](View-luminanceToAlpha-1-iOS)
    ///
    /// - Returns: A view with the luminance to alpha effect applied.
    @inlinable public func luminanceToAlpha() -> some View { return never() }

}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension View {

    /// Adjusts the color saturation of this view.
    ///
    /// Use color saturation to increase or decrease the intensity of colors in
    /// a view.
    ///
    /// The example below shows a series of red squares with their saturation
    /// increasing from 0 (gray) to 100% (fully-red) in 20% increments:
    ///
    ///     struct Saturation: View {
    ///         var body: some View {
    ///             HStack {
    ///                 ForEach(0..<6) {
    ///                     Color.red.frame(width: 60, height: 60, alignment: .center)
    ///                         .saturation(Double($0) * 0.2)
    ///                         .overlay(Text("\(Double($0) * 0.2 * 100, specifier: "%.0f")%"),
    ///                                  alignment: .bottom)
    ///                         .border(Color.gray)
    ///                 }
    ///             }
    ///         }
    ///     }
    ///
    /// ![Rendering showing the effects of saturation adjustments in 20%
    /// increments from gray at 0% to fully-red at
    /// 100%.](SkipUI-View-saturation.png)
    ///
    /// - SeeAlso: `contrast(_:)`
    /// - Parameter amount: The amount of saturation to apply to this view.
    ///
    /// - Returns: A view that adjusts the saturation of this view.
    @inlinable public func saturation(_ amount: Double) -> some View { return never() }

}

extension View {

    /// Sets a tag that you use for tracking interactivity.
    ///
    /// The following example tracks the scrolling activity of a ``List``:
    ///
    ///     List {
    ///         Section("Today") {
    ///             ForEach(messageStore.today) { message in
    ///                 Text(message.title)
    ///             }
    ///         }
    ///     }
    ///     .interactionActivityTrackingTag("MessagesList")
    ///
    /// The resolved activity tracking tag is additive, so using the
    /// modifier across the view hierarchy builds the tag from top to
    /// bottom. The example below shows a hierarchical usage of this
    /// modifier with the resulting tag `Home-Feed`:
    ///
    ///     var body: some View {
    ///         Home()
    ///             .interactionActivityTrackingTag("Home")
    ///     }
    ///
    ///     struct Home: View {
    ///         var body: some View {
    ///             List {
    ///                 Text("A List Item")
    ///                 Text("A Second List Item")
    ///                 Text("A Third List Item")
    ///             }
    ///             .interactionActivityTrackingTag("Feed")
    ///         }
    ///     }
    ///
    /// - Parameter tag: The tag used to track user interactions
    ///   hosted by this view as activities.
    ///
    /// - Returns: A view that uses a tracking tag.
    @available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
    public func interactionActivityTrackingTag(_ tag: String) -> some View { return never() }

}

@available(iOS 17.0, macOS 14.0, tvOS 17.0, *)
@available(watchOS, unavailable)
extension View {

    /// Returns a new view that applies `shader` to `self` as a filter
    /// effect on the color of each pixel.
    ///
    /// For a shader function to act as a color filter it must have a
    /// function signature matching:
    ///
    ///     [[ stitchable ]] half4 name(float2 position, half4 color, args...)
    ///
    /// where `position` is the user-space coordinates of the pixel
    /// applied to the shader and `color` its source color, as a
    /// pre-multiplied color in the destination color space. `args...`
    /// should be compatible with the uniform arguments bound to
    /// `shader`. The function should return the modified color value.
    ///
    /// > Important: Views backed by AppKit or UIKit views may not
    ///   render into the filtered layer. Instead, they log a warning
    ///   and display a placeholder image to highlight the error.
    ///
    /// - Parameters:
    ///   - shader: The shader to apply to `self` as a color filter.
    ///   - isEnabled: Whether the effect is enabled or not.
    ///
    /// - Returns: A new view that renders `self` with the shader
    ///   applied as a color filter.
    public func colorEffect(_ shader: Shader, isEnabled: Bool = true) -> some View { return never() }


    /// Returns a new view that applies `shader` to `self` as a
    /// geometric distortion effect on the location of each pixel.
    ///
    /// For a shader function to act as a distortion effect it must
    /// have a function signature matching:
    ///
    ///     [[ stitchable ]] float2 name(float2 position, args...)
    ///
    /// where `position` is the user-space coordinates of the
    /// destination pixel applied to the shader. `args...` should be
    /// compatible with the uniform arguments bound to `shader`. The
    /// function should return the user-space coordinates of the
    /// corresponding source pixel.
    ///
    /// > Important: Views backed by AppKit or UIKit views may not
    ///   render into the filtered layer. Instead, they log a warning
    ///   and display a placeholder image to highlight the error.
    ///
    /// - Parameters:
    ///   - shader: The shader to apply as a distortion effect.
    ///   - maxSampleOffset: The maximum distance in each axis between
    ///     the returned source pixel position and the destination pixel
    ///     position, for all source pixels.
    ///   - isEnabled: Whether the effect is enabled or not.
    ///
    /// - Returns: A new view that renders `self` with the shader
    ///   applied as a distortion effect.
    public func distortionEffect(_ shader: Shader, maxSampleOffset: CGSize, isEnabled: Bool = true) -> some View { return never() }


    /// Returns a new view that applies `shader` to `self` as a filter
    /// on the raster layer created from `self`.
    ///
    /// For a shader function to act as a layer effect it must
    /// have a function signature matching:
    ///
    ///     [[ stitchable ]] half4 name(float2 position,
    ///       SkipUI::Layer layer, args...)
    ///
    /// where `position` is the user-space coordinates of the
    /// destination pixel applied to the shader, and `layer` is a
    /// subregion of the raster contents of `self`. `args...` should be
    /// compatible with the uniform arguments bound to `shader`. The
    /// function should return the color mapping to the destination
    /// pixel, typically by sampling one or more pixels from `layer` at
    /// location(s) derived from `position` and them applying some kind
    /// of transformation to produce a new color.
    ///
    /// > Important: Views backed by AppKit or UIKit views may not
    ///   render into the filtered layer. Instead, they log a warning
    ///   and display a placeholder image to highlight the error.
    ///
    /// - Parameters:
    ///   - shader: The shader to apply as a layer effect.
    ///   - maxSampleOffset: If the shader function samples from the
    ///     layer at locations not equal to the destination position,
    ///     this value must specify the maximum sampling distance in
    ///     each axis, for all source pixels.
    ///   - isEnabled: Whether the effect is enabled or not.
    ///
    /// - Returns: A new view that renders `self` with the shader
    ///   applied as a distortion effect.
    public func layerEffect(_ shader: Shader, maxSampleOffset: CGSize, isEnabled: Bool = true) -> some View { return never() }

}

extension View {

    /// Adds an action to perform when this view recognizes a tap gesture,
    /// and provides the action with the location of the interaction.
    ///
    /// Use this method to perform the specified `action` when the user clicks
    /// or taps on the modified view `count` times. The action closure receives
    /// the location of the interaction.
    ///
    /// > Note: If you create a control that's functionally equivalent
    /// to a ``Button``, use ``ButtonStyle`` to create a customized button
    /// instead.
    ///
    /// The following code adds a tap gesture to a ``Circle`` that toggles the color
    /// of the circle based on the tap location.
    ///
    ///     struct TapGestureExample: View {
    ///         @State private var location: CGPoint = .zero
    ///
    ///         var body: some View {
    ///             Circle()
    ///                 .fill(self.location.y > 50 ? Color.blue : Color.red)
    ///                 .frame(width: 100, height: 100, alignment: .center)
    ///                 .onTapGesture { location in
    ///                     self.location = location
    ///                 }
    ///         }
    ///     }
    ///
    /// - Parameters:
    ///    - count: The number of taps or clicks required to trigger the action
    ///      closure provided in `action`. Defaults to `1`.
    ///    - coordinateSpace: The coordinate space in which to receive
    ///      location values. Defaults to ``CoordinateSpace/local``.
    ///    - action: The action to perform. This closure receives an input
    ///      that indicates where the interaction occurred.
    @available(iOS, introduced: 16.0, deprecated: 100000.0, message: "use overload that accepts a CoordinateSpaceProtocol instead")
    @available(macOS, introduced: 13.0, deprecated: 100000.0, message: "use overload that accepts a CoordinateSpaceProtocol instead")
    @available(watchOS, introduced: 9.0, deprecated: 100000.0, message: "use overload that accepts a CoordinateSpaceProtocol instead")
    @available(tvOS, unavailable)
    @available(xrOS, introduced: 1.0, deprecated: 100000.0, message: "use overload that accepts a CoordinateSpaceProtocol instead")
    public func onTapGesture(count: Int = 1, coordinateSpace: CoordinateSpace = .local, perform action: @escaping (CGPoint) -> Void) -> some View { return never() }

}

extension View {

    /// Adds an action to perform when this view recognizes a tap gesture,
    /// and provides the action with the location of the interaction.
    ///
    /// Use this method to perform the specified `action` when the user clicks
    /// or taps on the modified view `count` times. The action closure receives
    /// the location of the interaction.
    ///
    /// > Note: If you create a control that's functionally equivalent
    /// to a ``Button``, use ``ButtonStyle`` to create a customized button
    /// instead.
    ///
    /// The following code adds a tap gesture to a ``Circle`` that toggles the color
    /// of the circle based on the tap location.
    ///
    ///     struct TapGestureExample: View {
    ///         @State private var location: CGPoint = .zero
    ///
    ///         var body: some View {
    ///             Circle()
    ///                 .fill(self.location.y > 50 ? Color.blue : Color.red)
    ///                 .frame(width: 100, height: 100, alignment: .center)
    ///                 .onTapGesture { location in
    ///                     self.location = location
    ///                 }
    ///         }
    ///     }
    ///
    /// - Parameters:
    ///    - count: The number of taps or clicks required to trigger the action
    ///      closure provided in `action`. Defaults to `1`.
    ///    - coordinateSpace: The coordinate space in which to receive
    ///      location values. Defaults to ``CoordinateSpace/local``.
    ///    - action: The action to perform. This closure receives an input
    ///      that indicates where the interaction occurred.
    @available(iOS 17.0, macOS 14.0, watchOS 10.0, *)
    @available(tvOS, unavailable)
    public func onTapGesture(count: Int = 1, coordinateSpace: some CoordinateSpaceProtocol = .local, perform action: @escaping (CGPoint) -> Void) -> some View { return never() }

}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension View {

    /// Sets the transparency of this view.
    ///
    /// Apply opacity to reveal views that are behind another view or to
    /// de-emphasize a view.
    ///
    /// When applying the `opacity(_:)` modifier to a view that has already had
    /// its opacity transformed, the modifier multiplies the effect of the
    /// underlying opacity transformation.
    ///
    /// The example below shows yellow and red rectangles configured to overlap.
    /// The top yellow rectangle has its opacity set to 50%, allowing the
    /// occluded portion of the bottom rectangle to be visible:
    ///
    ///     struct Opacity: View {
    ///         var body: some View {
    ///             VStack {
    ///                 Color.yellow.frame(width: 100, height: 100, alignment: .center)
    ///                     .zIndex(1)
    ///                     .opacity(0.5)
    ///
    ///                 Color.red.frame(width: 100, height: 100, alignment: .center)
    ///                     .padding(-40)
    ///             }
    ///         }
    ///     }
    ///
    /// ![Two overlaid rectangles, where the topmost has its opacity set to 50%,
    /// which allows the occluded portion of the bottom rectangle to be
    /// visible.](SkipUI-View-opacity.png)
    ///
    /// - Parameter opacity: A value between 0 (fully transparent) and 1 (fully
    ///   opaque).
    ///
    /// - Returns: A view that sets the transparency of this view.
    @inlinable public func opacity(_ opacity: Double) -> some View { return never() }

}

@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
extension View {

    /// Adds a label to the view that describes its contents.
    ///
    /// Use this method to provide an accessibility label for a view that doesn't display text, like an icon.
    /// For example, you could use this method to label a button that plays music with the text "Play".
    /// Don't include text in the label that repeats information that users already have. For example,
    /// don't use the label "Play button" because a button already has a trait that identifies it as a button.
    public func accessibilityLabel(_ label: Text) -> ModifiedContent<Self, AccessibilityAttachmentModifier> { fatalError() }

    /// Adds a label to the view that describes its contents.
    ///
    /// Use this method to provide an accessibility label for a view that doesn't display text, like an icon.
    /// For example, you could use this method to label a button that plays music with the text "Play".
    /// Don't include text in the label that repeats information that users already have. For example,
    /// don't use the label "Play button" because a button already has a trait that identifies it as a button.
    public func accessibilityLabel(_ labelKey: LocalizedStringKey) -> ModifiedContent<Self, AccessibilityAttachmentModifier> { fatalError() }

    /// Adds a label to the view that describes its contents.
    ///
    /// Use this method to provide an accessibility label for a view that doesn't display text, like an icon.
    /// For example, you could use this method to label a button that plays music with the text "Play".
    /// Don't include text in the label that repeats information that users already have. For example,
    /// don't use the label "Play button" because a button already has a trait that identifies it as a button.
    public func accessibilityLabel<S>(_ label: S) -> ModifiedContent<Self, AccessibilityAttachmentModifier> where S : StringProtocol { fatalError() }
}

@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
extension View {

    /// Sets a style for labeled content.
    public func labeledContentStyle<S>(_ style: S) -> some View where S : LabeledContentStyle { return never() }

}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension View {

    /// Applies the given animation to this view when the specified value
    /// changes.
    ///
    /// - Parameters:
    ///   - animation: The animation to apply. If `animation` is `nil`, the view
    ///     doesn't animate.
    ///   - value: A value to monitor for changes.
    ///
    /// - Returns: A view that applies `animation` to this view whenever `value`
    ///   changes.
    @inlinable public func animation<V>(_ animation: Animation?, value: V) -> some View where V : Equatable { return never() }

}

extension View where Self : Equatable {

    /// Applies the given animation to this view when this view changes.
    ///
    /// - Parameters:
    ///   - animation: The animation to apply. If `animation` is `nil`, the view
    ///     doesn't animate.
    ///
    /// - Returns: A view that applies `animation` to this view whenever it
    ///   changes.
    @available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
    @inlinable public func animation(_ animation: Animation?) -> some View { return never() }

}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
extension View {

    /// Presents an alert when a given condition is true, using a localized
    /// string key for the title.
    ///
    /// In the example below, a login form conditionally presents an alert by
    /// setting the `didFail` state variable. When the form sets the value to
    /// to `true`, the system displays an alert with an "OK" action.
    ///
    ///     struct Login: View {
    ///         @State private var didFail = false
    ///
    ///         var body: some View {
    ///             LoginForm(didFail: $didFail)
    ///                 .alert(
    ///                     "Login failed.",
    ///                     isPresented: $didFail
    ///                 ) {
    ///                     Button("OK") {
    ///                         // Handle the acknowledgement.
    ///                     }
    ///                 }
    ///         }
    ///     }
    ///
    /// All actions in an alert dismiss the alert after the action runs.
    /// The default button is shown with greater prominence.  You can
    /// influence the default button by assigning it the
    /// ``KeyboardShortcut/defaultAction`` keyboard shortcut.
    ///
    /// The system may reorder the buttons based on their role and prominence.
    ///
    /// If no actions are present, the system includes a standard "OK"
    /// action. No default cancel action is provided. If you want to show a
    /// cancel action, use a button with a role of ``ButtonRole/cancel``.
    ///
    /// On iOS, tvOS, and watchOS, alerts only support controls with labels that
    /// are ``Text``. Passing any other type of view results in the content
    /// being omitted.
    ///
    /// This modifier creates a ``Text`` view for the title on your behalf, and
    /// treats the localized key similar to
    /// ``Text/init(_:tableName:bundle:comment:)``. See ``Text`` for more
    /// information about localizing strings.
    ///
    /// - Parameters:
    ///   - titleKey: The key for the localized string that describes the title
    ///     of the alert.
    ///   - isPresented: A binding to a Boolean value that determines whether to
    ///     present the alert. When the user presses or taps one of the alert's
    ///     actions, the system sets this value to `false` and dismisses.
    ///   - actions: A ``ViewBuilder`` returning the alert's actions.
    public func alert<A>(_ titleKey: LocalizedStringKey, isPresented: Binding<Bool>, @ViewBuilder actions: () -> A) -> some View where A : View { return never() }


    /// Presents an alert when a given condition is true, using a string
    /// variable as a title.
    ///
    /// In the example below, a login form conditionally presents an alert by
    /// setting the `didFail` state variable. When the form sets the value to
    /// to `true`, the system displays an alert with an "OK" action.
    ///
    ///     struct Login: View {
    ///         @State private var didFail = false
    ///         let alertTitle: String = "Login failed."
    ///
    ///         var body: some View {
    ///             LoginForm(didFail: $didFail)
    ///                 .alert(
    ///                     alertTitle,
    ///                     isPresented: $didFail
    ///                 ) {
    ///                     Button("OK") {
    ///                         // Handle the acknowledgement.
    ///                     }
    ///                 }
    ///         }
    ///     }
    ///
    /// All actions in an alert dismiss the alert after the action runs.
    /// The default button is shown with greater prominence.  You can
    /// influence the default button by assigning it the
    /// ``KeyboardShortcut/defaultAction`` keyboard shortcut.
    ///
    /// The system may reorder the buttons based on their role and prominence.
    ///
    /// If no actions are present, the system includes a standard "OK"
    /// action. No default cancel action is provided. If you want to show a
    /// cancel action, use a button with a role of ``ButtonRole/cancel``.
    ///
    /// On iOS, tvOS, and watchOS, alerts only support controls with labels that
    /// are ``Text``. Passing any other type of view results in the content
    /// being omitted.
    ///
    /// - Parameters:
    ///   - title: A text string used as the title of the alert.
    ///   - isPresented: A binding to a Boolean value that determines whether to
    ///     present the alert. When the user presses or taps one of the alert's
    ///     actions, the system sets this value to `false` and dismisses.
    ///   - actions: A ``ViewBuilder`` returning the alert's actions.
    public func alert<S, A>(_ title: S, isPresented: Binding<Bool>, @ViewBuilder actions: () -> A) -> some View where S : StringProtocol, A : View { return never() }


    /// Presents an alert when a given condition is true, using a text view for
    /// the title.
    ///
    /// In the example below, a login form conditionally presents an alert by
    /// setting the `didFail` state variable. When the form sets the value to
    /// to `true`, the system displays an alert with an "OK" action.
    ///
    ///     struct Login: View {
    ///         @State private var didFail = false
    ///         let alertTitle: String = "Login failed."
    ///
    ///         var body: some View {
    ///             LoginForm(didFail: $didFail)
    ///                 .alert(
    ///                     Text(alertTitle),
    ///                     isPresented: $didFail
    ///                 ) {
    ///                     Button("OK") {
    ///                         // Handle the acknowledgement.
    ///                     }
    ///                 }
    ///         }
    ///     }
    ///
    /// All actions in an alert dismiss the alert after the action runs.
    /// The default button is shown with greater prominence.  You can
    /// influence the default button by assigning it the
    /// ``KeyboardShortcut/defaultAction`` keyboard shortcut.
    ///
    /// The system may reorder the buttons based on their role and prominence.
    ///
    /// If no actions are present, the system includes a standard "OK"
    /// action. No default cancel action is provided. If you want to show a
    /// cancel action, use a button with a role of ``ButtonRole/cancel``.
    ///
    /// On iOS, tvOS, and watchOS, alerts only support controls with labels that
    /// are ``Text``. Passing any other type of view results in the content
    /// being omitted.
    ///
    /// - Parameters:
    ///   - title: The title of the alert.
    ///   - isPresented: A binding to a Boolean value that determines whether to
    ///     present the alert. When the user presses or taps one of the alert's
    ///     actions, the system sets this value to `false` and dismisses.
    ///   - actions: A ``ViewBuilder`` returning the alert's actions.
    public func alert<A>(_ title: Text, isPresented: Binding<Bool>, @ViewBuilder actions: () -> A) -> some View where A : View { return never() }

}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
extension View {

    /// Presents an alert with a message when a given condition is true, using
    /// a localized string key for a title.
    ///
    /// In the example below, a login form conditionally presents an alert by
    /// setting the `didFail` state variable. When the form sets the value to
    /// to `true`, the system displays an alert with an "OK" action.
    ///
    ///     struct Login: View {
    ///         @State private var didFail = false
    ///
    ///         var body: some View {
    ///             LoginForm(didFail: $didFail)
    ///                 .alert(
    ///                     "Login failed.",
    ///                     isPresented: $didFail
    ///                 ) {
    ///                     Button("OK") {
    ///                         // Handle the acknowledgement.
    ///                     }
    ///                 } message: {
    ///                     Text("Please check your credentials and try again.")
    ///                 }
    ///         }
    ///     }
    ///
    /// All actions in an alert dismiss the alert after the action runs.
    /// The default button is shown with greater prominence.  You can
    /// influence the default button by assigning it the
    /// ``KeyboardShortcut/defaultAction`` keyboard shortcut.
    ///
    /// The system may reorder the buttons based on their role and prominence.
    ///
    /// If no actions are present, the system includes a standard "OK"
    /// action. No default cancel action is provided. If you want to show a
    /// cancel action, use a button with a role of ``ButtonRole/cancel``.
    ///
    /// On iOS, tvOS, and watchOS, alerts only support controls with labels that
    /// are ``Text``. Passing any other type of view results in the content
    /// being omitted.
    ///
    /// Only unstyled text is supported for the message.
    ///
    /// This modifier creates a ``Text`` view for the title on your behalf, and
    /// treats the localized key similar to
    /// ``Text/init(_:tableName:bundle:comment:)``. See ``Text`` for more
    /// information about localizing strings.
    ///
    /// - Parameters:
    ///   - titleKey: The key for the localized string that describes the title
    ///     of the alert.
    ///   - isPresented: A binding to a Boolean value that determines whether to
    ///     present the alert. When the user presses or taps one of the alert's
    ///     actions, the system sets this value to `false` and dismisses.
    ///   - actions: A ``ViewBuilder`` returning the alert's actions.
    ///   - message: A ``ViewBuilder`` returning the message for the alert.
    public func alert<A, M>(_ titleKey: LocalizedStringKey, isPresented: Binding<Bool>, @ViewBuilder actions: () -> A, @ViewBuilder message: () -> M) -> some View where A : View, M : View { return never() }


    /// Presents an alert with a message when a given condition is true using
    /// a string variable as a title.
    ///
    /// In the example below, a login form conditionally presents an alert by
    /// setting the `didFail` state variable. When the form sets the value to
    /// to `true`, the system displays an alert with an "OK" action.
    ///
    ///     struct Login: View {
    ///         @State private var didFail = false
    ///         let alertTitle: String = "Login failed."
    ///
    ///         var body: some View {
    ///             LoginForm(didFail: $didFail)
    ///                 .alert(
    ///                     alertTitle,
    ///                     isPresented: $didFail
    ///                 ) {
    ///                     Button("OK") {
    ///                         // Handle the acknowledgement.
    ///                     }
    ///                 } message: {
    ///                     Text("Please check your credentials and try again.")
    ///                 }
    ///         }
    ///     }
    ///
    /// All actions in an alert dismiss the alert after the action runs.
    /// The default button is shown with greater prominence.  You can
    /// influence the default button by assigning it the
    /// ``KeyboardShortcut/defaultAction`` keyboard shortcut.
    ///
    /// The system may reorder the buttons based on their role and prominence.
    ///
    /// If no actions are present, the system includes a standard "OK"
    /// action. No default cancel action is provided. If you want to show a
    /// cancel action, use a button with a role of ``ButtonRole/cancel``.
    ///
    /// On iOS, tvOS, and watchOS, alerts only support controls with labels that
    /// are ``Text``. Passing any other type of view results in the content
    /// being omitted.
    ///
    /// Only unstyled text is supported for the message.
    ///
    /// - Parameters:
    ///   - title: A text string used as the title of the alert.
    ///   - isPresented: A binding to a Boolean value that determines whether to
    ///     present the alert. When the user presses or taps one of the alert's
    ///     actions, the system sets this value to `false` and dismisses.
    ///   - actions: A ``ViewBuilder`` returning the alert's actions.
    ///   - message: A ``ViewBuilder`` returning the message for the alert.
    public func alert<S, A, M>(_ title: S, isPresented: Binding<Bool>, @ViewBuilder actions: () -> A, @ViewBuilder message: () -> M) -> some View where S : StringProtocol, A : View, M : View { return never() }


    /// Presents an alert with a message when a given condition is true using
    /// a text view as a title.
    ///
    /// In the example below, a login form conditionally presents an alert by
    /// setting the `didFail` state variable. When the form sets the value to
    /// to `true`, the system displays an alert with an "OK" action.
    ///
    ///     struct Login: View {
    ///         @State private var didFail = false
    ///         let alertTitle: String = "Login failed."
    ///
    ///         var body: some View {
    ///             LoginForm(didFail: $didFail)
    ///                 .alert(
    ///                     Text(alertTitle),
    ///                     isPresented: $didFail
    ///                 ) {
    ///                     Button("OK") {
    ///                         // Handle the acknowledgement.
    ///                     }
    ///                 } message: {
    ///                    Text("Please check your credentials and try again.")
    ///                 }
    ///         }
    ///     }
    ///
    /// All actions in an alert dismiss the alert after the action runs.
    /// The default button is shown with greater prominence.  You can
    /// influence the default button by assigning it the
    /// ``KeyboardShortcut/defaultAction`` keyboard shortcut.
    ///
    /// The system may reorder the buttons based on their role and prominence.
    ///
    /// If no actions are present, the system includes a standard "OK"
    /// action. No default cancel action is provided. If you want to show a
    /// cancel action, use a button with a role of ``ButtonRole/cancel``.
    ///
    /// On iOS, tvOS, and watchOS, alerts only support controls with labels that
    /// are ``Text``. Passing any other type of view results in the content
    /// being omitted.
    ///
    /// Only unstyled text is supported for the message.
    ///
    /// - Parameters:
    ///   - title: The title of the alert.
    ///   - isPresented: A binding to a Boolean value that determines whether to
    ///     present the alert. When the user presses or taps one of the alert's
    ///     actions, the system sets this value to `false` and dismisses.
    ///   - actions: A ``ViewBuilder`` returning the alert's actions.
    ///   - message: A ``ViewBuilder`` returning the message for the alert.
    public func alert<A, M>(_ title: Text, isPresented: Binding<Bool>, @ViewBuilder actions: () -> A, @ViewBuilder message: () -> M) -> some View where A : View, M : View { return never() }

}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
extension View {

    /// Presents an alert using the given data to produce the alert's content
    /// and a localized string key for a title.
    ///
    /// For the alert to appear, both `isPresented` must be `true` and
    /// `data` must not be `nil`. The data should not change after the
    /// presentation occurs. Any changes that you make after the presentation
    /// occurs are ignored.
    ///
    /// Use this method when you need to populate the fields of an alert with
    /// content from a data source. The example below shows a custom data
    /// source, `SaveDetails`, that provides data to populate the alert:
    ///
    ///     struct SaveDetails: Identifiable {
    ///         let name: String
    ///         let error: String
    ///         let id = UUID()
    ///     }
    ///
    ///     struct SaveButton: View {
    ///         @State private var didError = false
    ///         @State private var details: SaveDetails?
    ///
    ///         var body: some View {
    ///             Button("Save") {
    ///                 details = model.save(didError: $didError)
    ///             }
    ///             .alert(
    ///                 "Save failed.",
    ///                 isPresented: $didError,
    ///                 presenting: details
    ///             ) { details in
    ///                 Button(role: .destructive) {
    ///                     // Handle the deletion.
    ///                 } label: {
    ///                     Text("Delete \(details.name)")
    ///                 }
    ///                 Button("Retry") {
    ///                     // Handle the retry action.
    ///                 }
    ///             }
    ///         }
    ///     }
    ///
    /// This modifier creates a ``Text`` view for the title on your behalf, and
    /// treats the localized key similar to
    /// ``Text/init(_:tableName:bundle:comment:)``. See ``Text`` for more
    /// information about localizing strings.
    ///
    /// All actions in an alert dismiss the alert after the action runs.
    /// The default button is shown with greater prominence.  You can
    /// influence the default button by assigning it the
    /// ``KeyboardShortcut/defaultAction`` keyboard shortcut.
    ///
    /// The system may reorder the buttons based on their role and prominence.
    ///
    /// If no actions are present, the system includes a standard "OK"
    /// action. No default cancel action is provided. If you want to show a
    /// cancel action, use a button with a role of ``ButtonRole/cancel``.
    ///
    /// On iOS, tvOS, and watchOS, alerts only support controls with labels that
    /// are ``Text``. Passing any other type of view results in the content
    /// being omitted.
    ///
    /// - Parameters:
    ///   - titleKey: The key for the localized string that describes the title
    ///     of the alert.
    ///   - isPresented: A binding to a Boolean value that determines whether to
    ///     present the alert. When the user presses or taps one of the alert's
    ///     actions, the system sets this value to `false` and dismisses.
    ///   - data: An optional source of truth for the alert. The system passes
    ///     the contents to the modifier's closures. You use this data to
    ///     populate the fields of an alert that you create that the system
    ///     displays to the user.
    ///   - actions: A ``ViewBuilder`` returning the alert's actions given the
    ///     currently available data.
    public func alert<A, T>(_ titleKey: LocalizedStringKey, isPresented: Binding<Bool>, presenting data: T?, @ViewBuilder actions: (T) -> A) -> some View where A : View { return never() }


    /// Presents an alert using the given data to produce the alert's content
    /// and a string variable as a title.
    ///
    /// For the alert to appear, both `isPresented` must be `true` and
    /// `data` must not be `nil`. The data should not change after the
    /// presentation occurs. Any changes that you make after the presentation
    /// occurs are ignored.
    ///
    /// Use this method when you need to populate the fields of an alert with
    /// content from a data source. The example below shows a custom data
    /// source, `SaveDetails`, that provides data to populate the alert:
    ///
    ///     struct SaveDetails: Identifiable {
    ///         let name: String
    ///         let error: String
    ///         let id = UUID()
    ///     }
    ///
    ///     struct SaveButton: View {
    ///         @State private var didError = false
    ///         @State private var details: SaveDetails?
    ///         let alertTitle: String = "Save failed."
    ///
    ///         var body: some View {
    ///             Button("Save") {
    ///                 details = model.save(didError: $didError)
    ///             }
    ///             .alert(
    ///                 alertTitle,
    ///                 isPresented: $didError,
    ///                 presenting: details
    ///             ) { details in
    ///                 Button(role: .destructive) {
    ///                     // Handle the deletion.
    ///                 } label: {
    ///                     Text("Delete \(details.name)")
    ///                 }
    ///                 Button("Retry") {
    ///                     // Handle the retry action.
    ///                 }
    ///             }
    ///         }
    ///     }
    ///
    /// All actions in an alert dismiss the alert after the action runs.
    /// The default button is shown with greater prominence.  You can
    /// influence the default button by assigning it the
    /// ``KeyboardShortcut/defaultAction`` keyboard shortcut.
    ///
    /// The system may reorder the buttons based on their role and prominence.
    ///
    /// If no actions are present, the system includes a standard "OK"
    /// action. No default cancel action is provided. If you want to show a
    /// cancel action, use a button with a role of ``ButtonRole/cancel``.
    ///
    /// On iOS, tvOS, and watchOS, alerts only support controls with labels that
    /// are ``Text``. Passing any other type of view results in the content
    /// being omitted.
    ///
    /// - Parameters:
    ///   - title: A text string used as the title of the alert.
    ///   - isPresented: A binding to a Boolean value that determines whether to
    ///     present the alert. When the user presses or taps one of the alert's
    ///     actions, the system sets this value to `false` and dismisses.
    ///   - data: An optional source of truth for the alert. The system passes
    ///     the contents to the modifier's closures. You use this data to
    ///     populate the fields of an alert that you create that the system
    ///     displays to the user.
    ///   - actions: A ``ViewBuilder`` returning the alert's actions given the
    ///     currently available data.
    public func alert<S, A, T>(_ title: S, isPresented: Binding<Bool>, presenting data: T?, @ViewBuilder actions: (T) -> A) -> some View where S : StringProtocol, A : View { return never() }


    /// Presents an alert using the given data to produce the alert's content
    /// and a text view as a title.
    ///
    /// For the alert to appear, both `isPresented` must be `true` and
    /// `data` must not be `nil`. The data should not change after the
    /// presentation occurs. Any changes that you make after the presentation
    /// occurs are ignored.
    ///
    /// Use this method when you need to populate the fields of an alert with
    /// content from a data source. The example below shows a custom data
    /// source, `SaveDetails`, that provides data to populate the alert:
    ///
    ///     struct SaveDetails: Identifiable {
    ///         let name: String
    ///         let error: String
    ///         let id = UUID()
    ///     }
    ///
    ///     struct SaveButton: View {
    ///         @State private var didError = false
    ///         @State private var details: SaveDetails?
    ///         let alertTitle: String = "Save failed."
    ///
    ///             var body: some View {
    ///             Button("Save") {
    ///                 details = model.save(didError: $didError)
    ///             }
    ///             .alert(
    ///                 Text(alertTitle),
    ///                 isPresented: $didError,
    ///                 presenting: details
    ///             ) { details in
    ///                 Button(role: .destructive) {
    ///                     // Handle the deletion.
    ///                 } label: {
    ///                     Text("Delete \(details.name)")
    ///                 }
    ///                 Button("Retry") {
    ///                     // Handle the retry action.
    ///                 }
    ///             }
    ///         }
    ///     }
    ///
    /// All actions in an alert dismiss the alert after the action runs.
    /// The default button is shown with greater prominence.  You can
    /// influence the default button by assigning it the
    /// ``KeyboardShortcut/defaultAction`` keyboard shortcut.
    ///
    /// The system may reorder the buttons based on their role and prominence.
    ///
    /// If no actions are present, the system includes a standard "OK"
    /// action. No default cancel action is provided. If you want to show a
    /// cancel action, use a button with a role of ``ButtonRole/cancel``.
    ///
    /// On iOS, tvOS, and watchOS, alerts only support controls with labels that
    /// are ``Text``. Passing any other type of view results in the content
    /// being omitted.
    ///
    /// - Parameters:
    ///   - title: the title of the alert.
    ///   - isPresented: A binding to a Boolean value that determines whether to
    ///     present the alert. When the user presses or taps one of the alert's
    ///     actions, the system sets this value to `false` and dismisses.
    ///   - data: An optional source of truth for the alert. The system passes
    ///     the contents to the modifier's closures. You use this data to
    ///     populate the fields of an alert that you create that the system
    ///     displays to the user.
    ///   - actions: A ``ViewBuilder`` returning the alert's actions given the
    ///     currently available data.
    public func alert<A, T>(_ title: Text, isPresented: Binding<Bool>, presenting data: T?, @ViewBuilder actions: (T) -> A) -> some View where A : View { return never() }

}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
extension View {

    /// Presents an alert with a message using the given data to produce the
    /// alert's content and a localized string key for a title.
    ///
    /// For the alert to appear, both `isPresented` must be `true` and
    /// `data` must not be `nil`. The data should not change after the
    /// presentation occurs. Any changes that you make after the presentation
    /// occurs are ignored.
    ///
    /// Use this method when you need to populate the fields of an alert with
    /// content from a data source. The example below shows a custom data
    /// source, `SaveDetails`, that provides data to populate the alert:
    ///
    ///     struct SaveDetails: Identifiable {
    ///         let name: String
    ///         let error: String
    ///         let id = UUID()
    ///     }
    ///
    ///     struct SaveButton: View {
    ///         @State private var didError = false
    ///         @State private var details: SaveDetails?
    ///
    ///         var body: some View {
    ///             Button("Save") {
    ///                 details = model.save(didError: $didError)
    ///             }
    ///             .alert(
    ///                 "Save failed.",
    ///                 isPresented: $didError,
    ///                 presenting: details
    ///             ) { details in
    ///                 Button(role: .destructive) {
    ///                     // Handle the deletion.
    ///                 } label: {
    ///                     Text("Delete \(details.name)")
    ///                 }
    ///                 Button("Retry") {
    ///                     // Handle the retry action.
    ///                 }
    ///             } message: { details in
    ///                 Text(details.error)
    ///             }
    ///         }
    ///     }
    ///
    /// This modifier creates a ``Text`` view for the title on your behalf, and
    /// treats the localized key similar to
    /// ``Text/init(_:tableName:bundle:comment:)``. See ``Text`` for more
    /// information about localizing strings.
    ///
    /// All actions in an alert dismiss the alert after the action runs.
    /// The default button is shown with greater prominence.  You can
    /// influence the default button by assigning it the
    /// ``KeyboardShortcut/defaultAction`` keyboard shortcut.
    ///
    /// The system may reorder the buttons based on their role and prominence.
    ///
    /// If no actions are present, the system includes a standard "OK"
    /// action. No default cancel action is provided. If you want to show a
    /// cancel action, use a button with a role of ``ButtonRole/cancel``.
    ///
    /// On iOS, tvOS, and watchOS, alerts only support controls with labels that
    /// are ``Text``. Passing any other type of view results in the content
    /// being omitted.
    ///
    /// Only unstyled text is supported for the message.
    ///
    /// - Parameters:
    ///   - titleKey: The key for the localized string that describes the title
    ///     of the alert.
    ///   - isPresented: A binding to a Boolean value that determines whether to
    ///     present the alert. When the user presses or taps one of the alert's
    ///     actions, the system sets this value to `false` and dismisses.
    ///   - data: An optional source of truth for the alert. The system passes
    ///     the contents to the modifier's closures. You use this data to
    ///     populate the fields of an alert that you create that the system
    ///     displays to the user.
    ///   - actions: A ``ViewBuilder`` returning the alert's actions given the
    ///     currently available data.
    ///   - message: A ``ViewBuilder`` returning the message for the alert given
    ///     the currently available data.
    public func alert<A, M, T>(_ titleKey: LocalizedStringKey, isPresented: Binding<Bool>, presenting data: T?, @ViewBuilder actions: (T) -> A, @ViewBuilder message: (T) -> M) -> some View where A : View, M : View { return never() }


    /// Presents an alert with a message using the given data to produce the
    /// alert's content and a string variable as a title.
    ///
    /// For the alert to appear, both `isPresented` must be `true` and
    /// `data` must not be `nil`. The data should not change after the
    /// presentation occurs. Any changes that you make after the presentation
    /// occurs are ignored.
    ///
    /// Use this method when you need to populate the fields of an alert with
    /// content from a data source. The example below shows a custom data
    /// source, `SaveDetails`, that provides data to populate the alert:
    ///
    ///     struct SaveDetails: Identifiable {
    ///         let name: String
    ///         let error: String
    ///         let id = UUID()
    ///     }
    ///
    ///     struct SaveButton: View {
    ///         @State private var didError = false
    ///         @State private var details: SaveDetails?
    ///         let alertTitle: String = "Save failed."
    ///
    ///         var body: some View {
    ///             Button("Save") {
    ///                 details = model.save(didError: $didError)
    ///             }
    ///             .alert(
    ///                 alertTitle,
    ///                 isPresented: $didError,
    ///                 presenting: details
    ///             ) { details in
    ///                 Button(role: .destructive) {
    ///                     // Handle the deletion.
    ///                 } label: {
    ///                     Text("Delete \(details.name)")
    ///                 }
    ///                 Button("Retry") {
    ///                     // Handle the retry action.
    ///                 }
    ///             } message: { details in
    ///                 Text(details.error)
    ///             }
    ///         }
    ///     }
    ///
    /// All actions in an alert dismiss the alert after the action runs.
    /// The default button is shown with greater prominence.  You can
    /// influence the default button by assigning it the
    /// ``KeyboardShortcut/defaultAction`` keyboard shortcut.
    ///
    /// The system may reorder the buttons based on their role and prominence.
    ///
    /// If no actions are present, the system includes a standard "OK"
    /// action. No default cancel action is provided. If you want to show a
    /// cancel action, use a button with a role of ``ButtonRole/cancel``.
    ///
    /// On iOS, tvOS, and watchOS, alerts only support controls with labels that
    /// are ``Text``. Passing any other type of view results in the content
    /// being omitted.
    ///
    /// Only unstyled text is supported for the message.
    ///
    /// - Parameters:
    ///   - title: A text string used as the title of the alert.
    ///   - isPresented: A binding to a Boolean value that determines whether to
    ///     present the alert. When the user presses or taps one of the alert's
    ///     actions, the system sets this value to `false` and dismisses.
    ///   - data: An optional source of truth for the alert. The system passes
    ///     the contents to the modifier's closures. You use this data to
    ///     populate the fields of an alert that you create that the system
    ///     displays to the user.
    ///   - actions: A ``ViewBuilder`` returning the alert's actions given the
    ///     currently available data.
    ///   - message: A ``ViewBuilder`` returning the message for the alert given
    ///     the currently available data.
    public func alert<S, A, M, T>(_ title: S, isPresented: Binding<Bool>, presenting data: T?, @ViewBuilder actions: (T) -> A, @ViewBuilder message: (T) -> M) -> some View where S : StringProtocol, A : View, M : View { return never() }


    /// Presents an alert with a message using the given data to produce the
    /// alert's content and a text view for a title.
    ///
    /// For the alert to appear, both `isPresented` must be `true` and
    /// `data` must not be `nil`. The data should not change after the
    /// presentation occurs. Any changes that you make after the presentation
    /// occurs are ignored.
    ///
    /// Use this method when you need to populate the fields of an alert with
    /// content from a data source. The example below shows a custom data
    /// source, `SaveDetails`, that provides data to populate the alert:
    ///
    ///     struct SaveDetails: Identifiable {
    ///         let name: String
    ///         let error: String
    ///         let id = UUID()
    ///     }
    ///
    ///     struct SaveButton: View {
    ///         @State private var didError = false
    ///         @State private var details: SaveDetails?
    ///         let alertTitle: String = "Save failed."
    ///
    ///         var body: some View {
    ///             Button("Save") {
    ///                 details = model.save(didError: $didError)
    ///             }
    ///             .alert(
    ///                 Text(alertTitle),
    ///                 isPresented: $didError,
    ///                 presenting: details
    ///             ) { details in
    ///                 Button(role: .destructive) {
    ///                     // Handle the deletion.
    ///                 } label: {
    ///                     Text("Delete \(details.name)")
    ///                 }
    ///                 Button("Retry") {
    ///                     // Handle the retry action.
    ///                 }
    ///             } message: { details in
    ///                 Text(details.error)
    ///             }
    ///         }
    ///     }
    ///
    /// All actions in an alert dismiss the alert after the action runs.
    /// The default button is shown with greater prominence.  You can
    /// influence the default button by assigning it the
    /// ``KeyboardShortcut/defaultAction`` keyboard shortcut.
    ///
    /// The system may reorder the buttons based on their role and prominence.
    ///
    /// If no actions are present, the system includes a standard "OK"
    /// action. No default cancel action is provided. If you want to show a
    /// cancel action, use a button with a role of ``ButtonRole/cancel``.
    ///
    /// On iOS, tvOS, and watchOS, alerts only support controls with labels that
    /// are ``Text``. Passing any other type of view results in the content
    /// being omitted.
    ///
    /// Only unstyled text is supported for the message.
    ///
    /// - Parameters:
    ///   - title: the title of the alert.
    ///   - isPresented: A binding to a Boolean value that determines whether to
    ///     present the alert. When the user presses or taps one of the alert's
    ///     actions, the system sets this value to `false` and dismisses.
    ///   - data: An optional source of truth for the alert. The system passes
    ///     the contents to the modifier's closures. You use this data to
    ///     populate the fields of an alert that you create that the system
    ///     displays to the user.
    ///   - actions: A ``ViewBuilder`` returning the alert's actions given the
    ///     currently available data.
    ///   - message: A ``ViewBuilder`` returning the message for the alert given
    ///     the currently available data.
    public func alert<A, M, T>(_ title: Text, isPresented: Binding<Bool>, presenting data: T?, @ViewBuilder actions: (T) -> A, @ViewBuilder message: (T) -> M) -> some View where A : View, M : View { return never() }

}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
extension View {

    /// Presents an alert when an error is present.
    ///
    /// In the example below, a form conditionally presents an alert depending
    /// upon the value of an error. When the error value isn't `nil`, the system
    /// presents an alert with an "OK" action.
    ///
    /// The title of the alert is inferred from the error's `errorDescription`.
    ///
    ///     struct TicketPurchase: View {
    ///         @State private var error: TicketPurchaseError? = nil
    ///         @State private var showAlert = false
    ///
    ///         var body: some View {
    ///             TicketForm(showAlert: $showAlert, error: $error)
    ///                 .alert(isPresented: $showAlert, error: error) {
    ///                     Button("OK") {
    ///                         // Handle acknowledgement.
    ///                     }
    ///                 }
    ///         }
    ///     }
    ///
    /// All actions in an alert dismiss the alert after the action runs.
    /// The default button is shown with greater prominence.  You can
    /// influence the default button by assigning it the
    /// ``KeyboardShortcut/defaultAction`` keyboard shortcut.
    ///
    /// The system may reorder the buttons based on their role and prominence.
    ///
    /// If no actions are present, the system includes a standard "OK"
    /// action. No default cancel action is provided. If you want to show a
    /// cancel action, use a button with a role of ``ButtonRole/cancel``.
    ///
    /// On iOS, tvOS, and watchOS, alerts only support controls with labels that
    /// are ``Text``. Passing any other type of view results in the content
    /// being omitted.
    ///
    /// This modifier creates a ``Text`` view for the title on your behalf, and
    /// treats the localized key similar to
    /// ``Text/init(_:tableName:bundle:comment:)``. See ``Text`` for more
    /// information about localizing strings.
    ///
    /// - Parameters:
    ///   - isPresented: A binding to a Boolean value that determines whether to
    ///     present the alert. When the user presses or taps one of the alert's
    ///     actions, the system sets this value to `false` and dismisses.
    ///   - error: An optional localized Error that is used to generate the
    ///     alert's title.  The system passes the contents to the modifier's
    ///     closures. You use this data to populate the fields of an alert that
    ///     you create that the system displays to the user.
    ///   - actions: A ``ViewBuilder`` returning the alert's actions.
    public func alert<E, A>(isPresented: Binding<Bool>, error: E?, @ViewBuilder actions: () -> A) -> some View where E : LocalizedError, A : View { return never() }


    /// Presents an alert with a message when an error is present.
    ///
    /// In the example below, a form conditionally presents an alert depending
    /// upon the value of an error. When the error value isn't `nil`, the system
    /// presents an alert with an "OK" action.
    ///
    /// The title of the alert is inferred from the error's `errorDescription`.
    ///
    ///     struct TicketPurchase: View {
    ///         @State private var error: TicketPurchaseError? = nil
    ///         @State private var showAlert = false
    ///
    ///         var body: some View {
    ///             TicketForm(showAlert: $showAlert, error: $error)
    ///                 .alert(isPresented: $showAlert, error: error) { _ in
    ///                     Button("OK") {
    ///                         // Handle acknowledgement.
    ///                     }
    ///                 } message: { error in
    ///                     Text(error.recoverySuggestion ?? "Try again later.")
    ///                 }
    ///         }
    ///     }
    ///
    /// All actions in an alert dismiss the alert after the action runs.
    /// The default button is shown with greater prominence.  You can
    /// influence the default button by assigning it the
    /// ``KeyboardShortcut/defaultAction`` keyboard shortcut.
    ///
    /// The system may reorder the buttons based on their role and prominence.
    ///
    /// If no actions are present, the system includes a standard "OK"
    /// action. No default cancel action is provided. If you want to show a
    /// cancel action, use a button with a role of ``ButtonRole/cancel``.
    ///
    /// On iOS, tvOS, and watchOS, alerts only support controls with labels that
    /// are ``Text``. Passing any other type of view results in the content
    /// being omitted.
    ///
    /// This modifier creates a ``Text`` view for the title on your behalf, and
    /// treats the localized key similar to
    /// ``Text/init(_:tableName:bundle:comment:)``. See ``Text`` for more
    /// information about localizing strings.
    ///
    /// - Parameters:
    ///   - isPresented: A binding to a Boolean value that determines whether to
    ///     present the alert. When the user presses or taps one of the alert's
    ///     actions, the system sets this value to `false` and dismisses.
    ///   - error: An optional localized Error that is used to generate the
    ///     alert's title.  The system passes the contents to the modifier's
    ///     closures. You use this data to populate the fields of an alert that
    ///     you create that the system displays to the user.
    ///   - actions: A ``ViewBuilder`` returning the alert's actions.
    ///   - message: A view builder returning the message for the alert given
    ///     the current error.
    public func alert<E, A, M>(isPresented: Binding<Bool>, error: E?, @ViewBuilder actions: (E) -> A, @ViewBuilder message: (E) -> M) -> some View where E : LocalizedError, A : View, M : View { return never() }

}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension View {

    /// Sets the unique tag value of this view.
    ///
    /// Use this modifier to differentiate among certain selectable views,
    /// like the possible values of a ``Picker`` or the tabs of a ``TabView``.
    /// Tag values can be of any type that conforms to the
    ///  protocol.
    ///
    /// In the example below, the ``ForEach`` loop in the ``Picker`` view
    /// builder iterates over the `Flavor` enumeration. It extracts the string
    /// value of each enumeration element for use in constructing the row
    /// label, and uses the enumeration value, cast as an optional, as input
    /// to the `tag(_:)` modifier. The ``Picker`` requires the tags to have a
    /// type that exactly matches the selection type, which in this case is an
    /// optional `Flavor`.
    ///
    ///     struct FlavorPicker: View {
    ///         enum Flavor: String, CaseIterable, Identifiable {
    ///             case chocolate, vanilla, strawberry
    ///             var id: Self { self }
    ///         }
    ///
    ///         @State private var selectedFlavor: Flavor? = nil
    ///
    ///         var body: some View {
    ///             Picker("Flavor", selection: $selectedFlavor) {
    ///                 ForEach(Flavor.allCases) { flavor in
    ///                     Text(flavor.rawValue).tag(Optional(flavor))
    ///                 }
    ///             }
    ///         }
    ///     }
    ///
    /// If you change `selectedFlavor` to be non-optional, you need to
    /// remove the
    /// cast from the tag input to match.
    ///
    /// A ``ForEach`` automatically applies a default tag to each enumerated
    /// view using the `id` parameter of the corresponding element. If
    /// the element's `id` parameter and the picker's `selection` input
    /// have exactly the same type, you can omit the explicit tag modifier.
    /// To see examples that don't require an explicit tag, see ``Picker``.
    ///
    /// - Parameter tag: A
    ///   value to use as the view's tag.
    ///
    /// - Returns: A view with the specified tag set.
    @inlinable public func tag<V>(_ tag: V) -> some View where V : Hashable { return never() }

}

@available(iOS 15.0, macOS 13.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension View {

    /// Sets the display mode for the separator associated with this specific row.
    ///
    /// Separators can be presented above and below a row. You can specify to
    /// which edge this preference should apply.
    ///
    /// This modifier expresses a preference to the containing ``List``. The list
    /// style is the final arbiter of the separator visibility.
    ///
    /// The following example shows a simple grouped list whose row separators
    /// are hidden:
    ///
    ///     List {
    ///         ForEach(garage.cars) { car in
    ///             Text(car.model)
    ///                 .listRowSeparator(.hidden)
    ///         }
    ///     }
    ///     .listStyle(.grouped)
    ///
    /// To change the color of a row separators, use
    /// ``View/listRowSeparatorTint(_:edges:)``.
    /// To hide or change the tint color for a section separators, use
    /// ``View/listSectionSeparator(_:edges:)`` and
    /// ``View/listSectionSeparatorTint(_:edges:)``.
    ///
    /// - Parameters:
    ///     - visibility: The visibility of this row's separators.
    ///     - edges: The set of row edges for which this preference applies.
    ///         The list style might already decide to not display separators for
    ///         some edges, typically the top edge. The default is
    ///         ``VerticalEdge/Set/all``.
    ///
    public func listRowSeparator(_ visibility: Visibility, edges: VerticalEdge.Set = .all) -> some View { return never() }


    /// Sets the tint color associated with a row.
    ///
    /// Separators can be presented above and below a row. You can specify to
    /// which edge this preference should apply.
    ///
    /// This modifier expresses a preference to the containing ``List``. The list
    /// style is the final arbiter for the separator tint.
    ///
    /// The following example shows a simple grouped list whose row separators
    /// are tinted based on row-specific data:
    ///
    ///     List {
    ///         ForEach(garage.cars) { car in
    ///             Text(car.model)
    ///                 .listRowSeparatorTint(car.brandColor)
    ///         }
    ///     }
    ///     .listStyle(.grouped)
    ///
    /// To hide a row separators, use
    /// ``View/listRowSeparator(_:edges:)``.
    /// To hide or change the tint color for a section separator, use
    /// ``View/listSectionSeparator(_:edges:)`` and
    /// ``View/listSectionSeparatorTint(_:edges:)``.
    ///
    /// - Parameters:
    ///     - color: The color to use to tint the row separators, or `nil` to
    ///         use the default color for the current list style.
    ///     - edges: The set of row edges for which the tint applies.
    ///         The list style might decide to not display certain separators,
    ///         typically the top edge. The default is ``VerticalEdge/Set/all``.
    ///
    public func listRowSeparatorTint(_ color: Color?, edges: VerticalEdge.Set = .all) -> some View { return never() }

}

@available(iOS 15.0, macOS 13.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension View {

    /// Sets whether to hide the separator associated with a list section.
    ///
    /// Separators can be presented above and below a section. You can specify to
    /// which edge this preference should apply.
    ///
    /// This modifier expresses a preference to the containing ``List``. The list
    /// style is the final arbiter of the separator visibility.
    ///
    /// The following example shows a simple grouped list whose bottom
    /// sections separator are hidden:
    ///
    ///     List {
    ///         ForEach(garage) { garage in
    ///             Section(header: Text(garage.location)) {
    ///                 ForEach(garage.cars) { car in
    ///                     Text(car.model)
    ///                         .listRowSeparatorTint(car.brandColor)
    ///                 }
    ///             }
    ///             .listSectionSeparator(.hidden, edges: .bottom)
    ///         }
    ///     }
    ///     .listStyle(.grouped)
    ///
    /// To change the visibility and tint color for a row separator, use
    /// ``View/listRowSeparator(_:edges:)`` and
    /// ``View/listRowSeparatorTint(_:edges:)``.
    /// To set the tint color for a section separator, use
    /// ``View/listSectionSeparatorTint(_:edges:)``.
    ///
    /// - Parameters:
    ///     - visibility: The visibility of this section's separators.
    ///     - edges: The set of row edges for which the preference applies.
    ///         The list style might already decide to not display separators for
    ///         some edges. The default is ``VerticalEdge/Set/all``.
    ///
    public func listSectionSeparator(_ visibility: Visibility, edges: VerticalEdge.Set = .all) -> some View { return never() }


    /// Sets the tint color associated with a section.
    ///
    /// Separators can be presented above and below a section. You can specify to
    /// which edge this preference should apply.
    ///
    /// This modifier expresses a preference to the containing ``List``. The list
    /// style is the final arbiter for the separator tint.
    ///
    /// The following example shows a simple grouped list whose section separators
    /// are tinted based on section-specific data:
    ///
    ///     List {
    ///         ForEach(garage) { garage in
    ///             Section(header: Text(garage.location)) {
    ///                 ForEach(garage.cars) { car in
    ///                     Text(car.model)
    ///                         .listRowSeparatorTint(car.brandColor)
    ///                 }
    ///             }
    ///             .listSectionSeparatorTint(
    ///                 garage.cars.last?.brandColor, edges: .bottom)
    ///         }
    ///     }
    ///     .listStyle(.grouped)
    ///
    /// To change the visibility and tint color for a row separator, use
    /// ``View/listRowSeparator(_:edges:)`` and
    /// ``View/listRowSeparatorTint(_:edges:)``.
    /// To hide a section separator, use
    /// ``View/listSectionSeparator(_:edges:)``.
    ///
    /// - Parameters:
    ///     - color: The color to use to tint the section separators, or `nil` to
    ///         use the default color for the current list style.
    ///     - edges: The set of row edges for which the tint applies.
    ///         The list style might decide to not display certain separators,
    ///         typically the top edge. The default is ``VerticalEdge/Set/all``.
    ///
    public func listSectionSeparatorTint(_ color: Color?, edges: VerticalEdge.Set = .all) -> some View { return never() }

}

@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
extension View {

    /// Specifies whether to hide this view from system accessibility features.
    public func accessibilityHidden(_ hidden: Bool) -> ModifiedContent<Self, AccessibilityAttachmentModifier> { fatalError() }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension View {

    /// Sets the blend mode for compositing this view with overlapping views.
    ///
    /// Use `blendMode(_:)` to combine overlapping views and use a different
    /// visual effect to produce the result. The ``BlendMode`` enumeration
    /// defines many possible effects.
    ///
    /// In the example below, the two overlapping rectangles have a
    /// ``BlendMode/colorBurn`` effect applied, which effectively removes the
    /// non-overlapping portion of the second image:
    ///
    ///     HStack {
    ///         Color.yellow.frame(width: 50, height: 50, alignment: .center)
    ///
    ///         Color.red.frame(width: 50, height: 50, alignment: .center)
    ///             .rotationEffect(.degrees(45))
    ///             .padding(-20)
    ///             .blendMode(.colorBurn)
    ///     }
    ///
    /// ![Two overlapping rectangles showing the effect of the blend mode view
    /// modifier applying the colorBurn effect.](SkipUI-blendMode.png)
    ///
    /// - Parameter blendMode: The ``BlendMode`` for compositing this view.
    ///
    /// - Returns: A view that applies `blendMode` to this view.
    @inlinable public func blendMode(_ blendMode: BlendMode) -> some View { return never() }

}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension View {

    /// Places a custom background view behind a list row item.
    ///
    /// Use `listRowBackground(_:)` to place a custom background view behind a
    /// list row item.
    ///
    /// In the example below, the `Flavor` enumeration provides content for list
    /// items. The SkipUI ``ForEach`` structure computes views for each element
    /// of the `Flavor` enumeration and extracts the raw value of each of its
    /// elements using the resulting text to create each list row item. The
    /// `listRowBackground(_:)` modifier then places the view you supply behind
    /// each of the list row items:
    ///
    ///     struct ContentView: View {
    ///         enum Flavor: String, CaseIterable, Identifiable {
    ///             var id: String { self.rawValue }
    ///             case vanilla, chocolate, strawberry
    ///         }
    ///
    ///         var body: some View {
    ///             List {
    ///                 ForEach(Flavor.allCases) {
    ///                     Text($0.rawValue)
    ///                         .listRowBackground(Ellipse()
    ///                                             .background(Color.clear)
    ///                                             .foregroundColor(.purple)
    ///                                             .opacity(0.3)
    ///                         )
    ///                 }
    ///             }
    ///         }
    ///     }
    ///
    /// ![A screenshot showing the placement of an image as the background to
    ///   each row in a list.](SkipUI-View-listRowBackground.png)
    ///
    /// - Parameter view: The ``View`` to use as the background behind the list
    ///   row view.
    ///
    /// - Returns: A list row view with `view` as its background view.
    @inlinable public func listRowBackground<V>(_ view: V?) -> some View where V : View { return never() }

}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension View {

    /// Composites this view's contents into an offscreen image before final
    /// display.
    ///
    /// The `drawingGroup(opaque:colorMode:)` modifier flattens a subtree of
    /// views into a single view before rendering it.
    ///
    /// In the example below, the contents of the view are composited to a
    /// single bitmap; the bitmap is then displayed in place of the view:
    ///
    ///     VStack {
    ///         ZStack {
    ///             Text("DrawingGroup")
    ///                 .foregroundColor(.black)
    ///                 .padding(20)
    ///                 .background(Color.red)
    ///             Text("DrawingGroup")
    ///                 .blur(radius: 2)
    ///         }
    ///         .font(.largeTitle)
    ///         .compositingGroup()
    ///         .opacity(1.0)
    ///     }
    ///      .background(Color.white)
    ///      .drawingGroup()
    ///
    /// > Note: Views backed by native platform views may not render into the
    ///   image. Instead, they log a warning and display a placeholder image to
    ///   highlight the error.
    ///
    /// ![A screenshot showing the effects on several stacks configured as a
    /// drawing group.](SkipUI-View-drawingGroup.png)
    ///
    /// - Parameters:
    ///   - opaque: A Boolean value that indicates whether the image is opaque.
    ///     The default is `false`; if set to `true`, the alpha channel of the
    ///     image must be `1`.
    ///   - colorMode: One of the working color space and storage formats
    ///     defined in ``ColorRenderingMode``. The default is
    ///     ``ColorRenderingMode/nonLinear``.
    ///
    /// - Returns: A view that composites this view's contents into an offscreen
    ///   image before display.
    public func drawingGroup(opaque: Bool = false, colorMode: ColorRenderingMode = .nonLinear) -> some View { return never() }

}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension View {

    /// Wraps this view in a compositing group.
    ///
    /// A compositing group makes compositing effects in this view's ancestor
    /// views, such as opacity and the blend mode, take effect before this view
    /// is rendered.
    ///
    /// Use `compositingGroup()` to apply effects to a parent view before
    /// applying effects to this view.
    ///
    /// In the example below the `compositingGroup()` modifier separates the
    /// application of effects into stages. It applies the ``View/opacity(_:)``
    /// effect to the VStack before the `blur(radius:)` effect is applied to the
    /// views inside the enclosed ``ZStack``. This limits the scope of the
    /// opacity change to the outermost view.
    ///
    ///     VStack {
    ///         ZStack {
    ///             Text("CompositingGroup")
    ///                 .foregroundColor(.black)
    ///                 .padding(20)
    ///                 .background(Color.red)
    ///             Text("CompositingGroup")
    ///                 .blur(radius: 2)
    ///         }
    ///         .font(.largeTitle)
    ///         .compositingGroup()
    ///         .opacity(0.9)
    ///     }
    ///
    /// ![A view showing the effect of the compositingGroup modifier in applying
    /// compositing effects to parent views before child views are
    /// rendered.](SkipUI-View-compositingGroup.png)
    ///
    /// - Returns: A view that wraps this view in a compositing group.
    @inlinable public func compositingGroup() -> some View { return never() }

}

extension View {

    /// Sets the style for navigation split views within this view.
    ///
    /// - Parameter style: The style to set.
    ///
    /// - Returns: A view that uses the specified navigation split view style.
    @available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
    public func navigationSplitViewStyle<S>(_ style: S) -> some View where S : NavigationSplitViewStyle { return never() }

}

@available(iOS 17.0, macOS 14.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
@available(xrOS, unavailable)
extension View {

    /// Inserts an inspector at the applied position in the view hierarchy.
    ///
    /// Apply this modifier to declare an inspector with a context-dependent
    /// presentation. For example, an inspector can present as a trailing
    /// column in a horizontally regular size class, but adapt to a sheet in a
    /// horizontally compact size class.
    ///
    ///     struct ShapeEditor: View {
    ///         @State var presented: Bool = false
    ///         var body: some View {
    ///             MyEditorView()
    ///                 .inspector(isPresented: $presented) {
    ///                     TextTraitsInspectorView()
    ///                 }
    ///         }
    ///     }
    ///
    /// - Parameters:
    ///   - isPresented: A binding to `Bool` controlling the presented state.
    ///   - content: The inspector content.
    ///
    /// - Note: Trailing column inspectors have their presentation state
    /// restored by the framework.
    public func inspector<V>(isPresented: Binding<Bool>, @ViewBuilder content: () -> V) -> some View where V : View { return never() }


    /// Sets a flexible, preferred width for the inspector in a trailing-column
    /// presentation.
    ///
    /// Apply this modifier on the content of a
    /// ``View/inspector(isPresented:content:)`` to specify a preferred flexible
    /// width for the column. Use ``View/inspectorColumnWidth(_:)`` if you need
    /// to specify a fixed width.
    ///
    /// The following example shows an editor interface with an inspector, which
    /// when presented as a trailing-column, has a preferred width of 225
    /// points, maximum of 400, and a minimum of 150 at which point it will
    /// collapse, if allowed.
    ///
    ///     MyEditorView()
    ///         .inspector {
    ///             TextTraitsInspectorView()
    ///                 .inspectorColumnWidth(min: 150, ideal: 225, max: 400)
    ///         }
    ///
    /// Only some platforms enable flexible inspector columns. If
    /// you specify a width that the current presentation environment doesn't
    /// support, SkipUI may use a different width for your column.
    /// - Parameters:
    ///   - min: The minimum allowed width for the trailing column inspector
    ///   - ideal: The initial width of the inspector in the absence of state
    ///   restoration. `ideal` influences the resulting width on macOS when a
    ///   user double-clicks the divider on the leading edge of the inspector.
    ///   clicks a divider to readjust
    ///   - max: The maximum allowed width for the trailing column inspector
    public func inspectorColumnWidth(min: CGFloat? = nil, ideal: CGFloat, max: CGFloat? = nil) -> some View { return never() }


    /// Sets a fixed, preferred width for the inspector containing this view
    /// when presented as a trailing column.
    ///
    /// Apply this modifier on the content of a
    /// ``View/inspector(isPresented:content:)`` to specify a fixed preferred
    /// width for the trailing column. Use
    /// ``View/navigationSplitViewColumnWidth(min:ideal:max:)`` if
    /// you need to specify a flexible width.
    ///
    /// The following example shows an editor interface with an inspector, which
    /// when presented as a trailing-column, has a fixed width of 225
    /// points. The example also uses ``View/interactiveDismissDisabled(_:)`` to
    /// prevent the inspector from being collapsed by user action like dragging
    /// a divider.
    ///
    ///     MyEditorView()
    ///         .inspector {
    ///             TextTraitsInspectorView()
    ///                 .inspectorColumnWidth(225)
    ///                 .interactiveDismissDisabled()
    ///         }
    ///
    /// - Parameter width: The preferred fixed width for the inspector if
    /// presented as a trailing column.
    /// - Note: A fixed width does not prevent the user collapsing the
    /// inspector on macOS. See ``View/interactiveDismissDisabled(_:)``.
    public func inspectorColumnWidth(_ width: CGFloat) -> some View { return never() }

}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension View {

    /// Sets a value for the specified preference key, the value is a
    /// function of a geometry value tied to the current coordinate
    /// space, allowing readers of the value to convert the geometry to
    /// their local coordinates.
    ///
    /// - Parameters:
    ///   - key: the preference key type.
    ///   - value: the geometry value in the current coordinate space.
    ///   - transform: the function to produce the preference value.
    ///
    /// - Returns: a new version of the view that writes the preference.
    @inlinable public func anchorPreference<A, K>(key _: K.Type = K.self, value: Anchor<A>.Source, transform: @escaping (Anchor<A>) -> K.Value) -> some View where K : PreferenceKey { return never() }

}

@available(iOS 16.0, macOS 12.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension View {

    /// Sets the style for tables within this view.
    public func tableStyle<S>(_ style: S) -> some View where S : TableStyle { return never() }

}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension View {

    /// Sets a clipping shape for this view.
    ///
    /// Use `clipShape(_:style:)` to clip the view to the provided shape. By
    /// applying a clipping shape to a view, you preserve the parts of the view
    /// covered by the shape, while eliminating other parts of the view. The
    /// clipping shape itself isn't visible.
    ///
    /// For example, this code applies a circular clipping shape to a `Text`
    /// view:
    ///
    ///     Text("Clipped text in a circle")
    ///         .frame(width: 175, height: 100)
    ///         .foregroundColor(Color.white)
    ///         .background(Color.black)
    ///         .clipShape(Circle())
    ///
    /// The resulting view shows only the portion of the text that lies within
    /// the bounds of the circle.
    ///
    /// ![A screenshot of text clipped to the shape of a
    /// circle.](SkipUI-View-clipShape.png)
    ///
    /// - Parameters:
    ///   - shape: The clipping shape to use for this view. The `shape` fills
    ///     the view's frame, while maintaining its aspect ratio.
    ///   - style: The fill style to use when rasterizing `shape`.
    ///
    /// - Returns: A view that clips this view to `shape`, using `style` to
    ///   define the shape's rasterization.
    @inlinable public func clipShape<S>(_ shape: S, style: FillStyle = FillStyle()) -> some View where S : Shape { return never() }


    /// Clips this view to its bounding rectangular frame.
    ///
    /// Use the `clipped(antialiased:)` modifier to hide any content that
    /// extends beyond the layout bounds of the shape.
    ///
    /// By default, a view's bounding frame is used only for layout, so any
    /// content that extends beyond the edges of the frame is still visible.
    ///
    ///     Text("This long text string is clipped")
    ///         .fixedSize()
    ///         .frame(width: 175, height: 100)
    ///         .clipped()
    ///         .border(Color.gray)
    ///
    /// ![Screenshot showing text clipped to its
    /// frame.](SkipUI-View-clipped.png)
    ///
    /// - Parameter antialiased: A Boolean value that indicates whether the
    ///   rendering system applies smoothing to the edges of the clipping
    ///   rectangle.
    ///
    /// - Returns: A view that clips this view to its bounding frame.
    @inlinable public func clipped(antialiased: Bool = false) -> some View { return never() }


    /// Clips this view to its bounding frame, with the specified corner radius.
    ///
    /// By default, a view's bounding frame only affects its layout, so any
    /// content that extends beyond the edges of the frame remains visible. Use
    /// `cornerRadius(_:antialiased:)` to hide any content that extends beyond
    /// these edges while applying a corner radius.
    ///
    /// The following code applies a corner radius of 25 to a text view:
    ///
    ///     Text("Rounded Corners")
    ///         .frame(width: 175, height: 75)
    ///         .foregroundColor(Color.white)
    ///         .background(Color.black)
    ///         .cornerRadius(25)
    ///
    /// ![A screenshot of a rectangle with rounded corners bounding a text
    /// view.](SkipUI-View-cornerRadius.png)
    ///
    /// - Parameter antialiased: A Boolean value that indicates whether the
    ///   rendering system applies smoothing to the edges of the clipping
    ///   rectangle.
    ///
    /// - Returns: A view that clips this view to its bounding frame with the
    ///   specified corner radius.
    @available(iOS, introduced: 13.0, deprecated: 100000.0, message: "Use `clipShape` or `fill` instead.")
    @available(macOS, introduced: 10.15, deprecated: 100000.0, message: "Use `clipShape` or `fill` instead.")
    @available(tvOS, introduced: 13.0, deprecated: 100000.0, message: "Use `clipShape` or `fill` instead.")
    @available(watchOS, introduced: 6.0, deprecated: 100000.0, message: "Use `clipShape` or `fill` instead.")
    @available(xrOS, introduced: 1.0, deprecated: 100000.0, message: "Use `clipShape` or `fill` instead.")
    @inlinable public func cornerRadius(_ radius: CGFloat, antialiased: Bool = true) -> some View { return never() }

}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension View {

    /// Adds a shadow to this view.
    ///
    /// Use this modifier to add a shadow of a specified color behind a view.
    /// You can offset the shadow from its view independently in the horizontal
    /// and vertical dimensions using the `x` and `y` parameters. You can also
    /// blur the edges of the shadow using the `radius` parameter. Use a
    /// radius of zero to create a sharp shadow. Larger radius values produce
    /// softer shadows.
    ///
    /// The example below creates a grid of boxes with varying offsets and blur.
    /// Each box displays its radius and offset values for reference.
    ///
    ///     struct Shadow: View {
    ///         let steps = [0, 5, 10]
    ///
    ///         var body: some View {
    ///             VStack(spacing: 50) {
    ///                 ForEach(steps, id: \.self) { offset in
    ///                     HStack(spacing: 50) {
    ///                         ForEach(steps, id: \.self) { radius in
    ///                             Color.blue
    ///                                 .shadow(
    ///                                     color: .primary,
    ///                                     radius: CGFloat(radius),
    ///                                     x: CGFloat(offset), y: CGFloat(offset))
    ///                                 .overlay {
    ///                                     VStack {
    ///                                         Text("\(radius)")
    ///                                         Text("(\(offset), \(offset))")
    ///                                     }
    ///                                 }
    ///                         }
    ///                     }
    ///                 }
    ///             }
    ///         }
    ///     }
    ///
    /// ![A three by three grid of blue boxes with shadows.
    /// All the boxes display an integer that indicates the shadow's radius and
    /// an ordered pair that indicates the shadow's offset. The boxes in the
    /// first row show zero offset and have shadows directly below the box;
    /// the boxes in the second row show an offset of five in both directions
    /// and have shadows with a small offset toward the right and down; the
    /// boxes in the third row show an offset of ten in both directions and have
    /// shadows with a large offset toward the right and down. The boxes in
    /// the first column show a radius of zero have shadows with sharp edges;
    /// the boxes in the second column show a radius of five and have shadows
    /// with slightly blurry edges; the boxes in the third column show a radius
    /// of ten and have very blurry edges. Because the shadow of the box in the
    /// upper left is both completely sharp and directly below the box, it isn't
    /// visible.](View-shadow-1-iOS)
    ///
    /// The example above uses ``Color/primary`` as the color to make the
    /// shadow easy to see for the purpose of illustration. In practice,
    /// you might prefer something more subtle, like ``Color/gray-8j2b``.
    /// If you don't specify a color, the method uses a semi-transparent
    /// black.
    ///
    /// - Parameters:
    ///   - color: The shadow's color.
    ///   - radius: A measure of how much to blur the shadow. Larger values
    ///     result in more blur.
    ///   - x: An amount to offset the shadow horizontally from the view.
    ///   - y: An amount to offset the shadow vertically from the view.
    ///
    /// - Returns: A view that adds a shadow to this view.
    @inlinable public func shadow(color: Color = Color(.sRGBLinear, white: 0, opacity: 0.33), radius: CGFloat, x: CGFloat = 0, y: CGFloat = 0) -> some View { return never() }

}

extension View {

    /// Sets the rename action in the environment to update focus state.
    ///
    /// Use this modifier in conjunction with the ``RenameButton`` to implement
    /// standard rename interactions. A rename button receives its action
    /// from the environment. Use this modifier to customize the action
    /// provided to the rename button.
    ///
    ///     struct RowView: View {
    ///         @State private var text = ""
    ///         @FocusState private var isFocused: Bool
    ///
    ///         var body: some View {
    ///             TextField(text: $item.name) {
    ///                 Text("Prompt")
    ///             }
    ///             .focused($isFocused)
    ///             .contextMenu {
    ///                 RenameButton()
    ///                 // ... your own custom actions
    ///             }
    ///             .renameAction($isFocused)
    ///     }
    ///
    /// When someone taps the rename button in the context menu, the rename
    /// action focuses the text field by setting the `isFocused`
    /// property to true.
    ///
    /// - Parameter isFocused: The focus binding to update when
    ///   activating the rename action.
    ///
    /// - Returns: A view that has the specified rename action.
    @available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
    public func renameAction(_ isFocused: FocusState<Bool>.Binding) -> some View { return never() }


    /// Sets a closure to run for the rename action.
    ///
    /// Use this modifier in conjunction with the ``RenameButton`` to implement
    /// standard rename interactions. A rename button receives its action
    /// from the environment. Use this modifier to customize the action
    /// provided to the rename button.
    ///
    ///     struct RowView: View {
    ///         @State private var text = ""
    ///         @FocusState private var isFocused: Bool
    ///
    ///         var body: some View {
    ///             TextField(text: $item.name) {
    ///                 Text("Prompt")
    ///             }
    ///             .focused($isFocused)
    ///             .contextMenu {
    ///                 RenameButton()
    ///                 // ... your own custom actions
    ///             }
    ///             .renameAction { isFocused = true }
    ///     }
    ///
    /// When the user taps the rename button in the context menu, the rename
    /// action focuses the text field by setting the `isFocused`
    /// property to true.
    ///
    /// - Parameter action: A closure to run when renaming.
    ///
    /// - Returns: A view that has the specified rename action.
    @available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
    public func renameAction(_ action: @escaping () -> Void) -> some View { return never() }

}

extension View {

    /// Configures the toolbar title display mode for this view.
    ///
    /// Use this modifier to override the default toolbar title display
    /// mode.
    ///
    ///     NavigationStack {
    ///         ContentView()
    ///             .toolbarTitleDisplayMode(.inlineLarge)
    ///     }
    ///
    /// See ``ToolbarTitleDisplayMode`` for more information on the
    /// different kinds of display modes. This modifier has no effect
    /// on macOS.
    @available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
    public func toolbarTitleDisplayMode(_ mode: ToolbarTitleDisplayMode) -> some View { return never() }

}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension View {

    /// Sets the style for toggles in a view hierarchy.
    ///
    /// Use this modifier on a ``Toggle`` instance to set a style that defines
    /// the control's appearance and behavior. For example, you can choose
    /// the ``ToggleStyle/switch`` style:
    ///
    ///     Toggle("Vibrate on Ring", isOn: $vibrateOnRing)
    ///         .toggleStyle(.switch)
    ///
    /// Built-in styles typically have a similar appearance across platforms,
    /// tailored to the platform's overall style:
    ///
    /// | Platform    | Appearance |
    /// |-------------|------------|
    /// | iOS, iPadOS | ![A screenshot of the text Vibrate on Ring appearing to the left of a toggle switch that's on. The toggle's tint color is green. The toggle and its text appear in a rounded rectangle.](View-toggleStyle-1-iOS) |
    /// | macOS       | ![A screenshot of the text Vibrate on Ring appearing to the left of a toggle switch that's on. The toggle's tint color is blue. The toggle and its text appear on a neutral background.](View-toggleStyle-1-macOS) |
    ///
    /// ### Styling toggles in a hierarchy
    ///
    /// You can set a style for all toggle instances within a view hierarchy
    /// by applying the style modifier to a container view. For example, you
    /// can apply the ``ToggleStyle/button`` style to an ``HStack``:
    ///
    ///     HStack {
    ///         Toggle(isOn: $isFlagged) {
    ///             Label("Flag", systemImage: "flag.fill")
    ///         }
    ///         Toggle(isOn: $isMuted) {
    ///             Label("Mute", systemImage: "speaker.slash.fill")
    ///         }
    ///     }
    ///     .toggleStyle(.button)
    ///
    /// The example above has the following appearance when `isFlagged` is
    /// `true` and `isMuted` is `false`:
    ///
    /// | Platform    | Appearance |
    /// |-------------|------------|
    /// | iOS, iPadOS | ![A screenshot of two buttons arranged horizontally. The first has the image of a flag and is active with a blue tint. The second has an image of a speaker with a line through it and is inactive with a neutral tint.](View-toggleStyle-2-iOS) |
    /// | macOS       | ![A screenshot of two buttons arranged horizontally. The first has the image of a flag and is active with a blue tint. The second has an image of a speaker with a line through it and is inactive with a neutral tint.](View-toggleStyle-2-macOS) |
    ///
    /// ### Automatic styling
    ///
    /// If you don't set a style, SkipUI assumes a value of
    /// ``ToggleStyle/automatic``, which corresponds to a context-specific
    /// default. Specify the automatic style explicitly to override a
    /// container's style and revert to the default:
    ///
    ///     HStack {
    ///         Toggle(isOn: $isShuffling) {
    ///             Label("Shuffle", systemImage: "shuffle")
    ///         }
    ///         Toggle(isOn: $isRepeating) {
    ///             Label("Repeat", systemImage: "repeat")
    ///         }
    ///
    ///         Divider()
    ///
    ///         Toggle("Enhance Sound", isOn: $isEnhanced)
    ///             .toggleStyle(.automatic) // Revert to the default style.
    ///     }
    ///     .toggleStyle(.button) // Use button style for toggles in the stack.
    ///     .labelStyle(.iconOnly) // Omit the title from any labels.
    ///
    /// The style that SkipUI uses as the default depends on both the platform
    /// and the context. In macOS, the default in most contexts is a
    /// ``ToggleStyle/checkbox``, while in iOS, the default toggle style is a
    /// ``ToggleStyle/switch``:
    ///
    /// | Platform    | Appearance |
    /// |-------------|------------|
    /// | iOS, iPadOS | ![A screenshot of several horizontally arranged items: two buttons, a vertical divider line, the text Enhance sound, and a switch. The first button has two right facing arrows that cross over in the middle and is active with a blue tint. The second button has one right and one left facing arrow and is inactive with neutral tint. The switch is on and has a green tint.](View-toggleStyle-3-iOS) |
    /// | macOS       | ![A screenshot of several horizontally arranged items: two buttons, a vertical divider line, a checkbox, and the text Enhance sound. The first button has two right facing arrows that cross over in the middle and is active with a blue tint. The second button has one right and one left facing arrow and is inactive with a neutral tint. The check box is checked and has a blue tint.](View-toggleStyle-3-macOS) |
    ///
    /// > Note: Like toggle style does for toggles, the ``View/labelStyle(_:)``
    /// modifier sets the style for ``Label`` instances in the hierarchy. The
    /// example above demostrates the compact ``LabelStyle/iconOnly`` style,
    /// which is useful for button toggles in space-constrained contexts.
    /// Always include a descriptive title for better accessibility.
    ///
    /// For more information about how SkipUI chooses a default toggle style,
    /// see the ``ToggleStyle/automatic`` style.
    ///
    /// - Parameter style: The toggle style to set. Use one of the built-in
    ///   values, like ``ToggleStyle/switch`` or ``ToggleStyle/button``,
    ///   or a custom style that you define by creating a type that conforms
    ///   to the ``ToggleStyle`` protocol.
    ///
    /// - Returns: A view that uses the specified toggle style for itself
    ///   and its child views.
    public func toggleStyle<S>(_ style: S) -> some View where S : ToggleStyle { return never() }

}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension View {

    /// Scales images within the view according to one of the relative sizes
    /// available including small, medium, and large images sizes.
    ///
    /// The example below shows the relative scaling effect. The system renders
    /// the image at a relative size based on the available space and
    /// configuration options of the image it is scaling.
    ///
    ///     VStack {
    ///         HStack {
    ///             Image(systemName: "heart.fill")
    ///                 .imageScale(.small)
    ///             Text("Small")
    ///         }
    ///         HStack {
    ///             Image(systemName: "heart.fill")
    ///                 .imageScale(.medium)
    ///             Text("Medium")
    ///         }
    ///
    ///         HStack {
    ///             Image(systemName: "heart.fill")
    ///                 .imageScale(.large)
    ///             Text("Large")
    ///         }
    ///     }
    ///
    /// ![A view showing small, medium, and large hearts rendered at a size
    /// relative to the available space.](SkipUI-View-imageScale.png)
    ///
    /// - Parameter scale: One of the relative sizes provided by the image scale
    ///   enumeration.
    @available(macOS 11.0, *)
    @inlinable public func imageScale(_ scale: Image.Scale) -> some View { return never() }


    /// Sets the default font for text in this view.
    ///
    /// Use `font(_:)` to apply a specific font to all of the text in a view.
    ///
    /// The example below shows the effects of applying fonts to individual
    /// views and to view hierarchies. Font information flows down the view
    /// hierarchy as part of the environment, and remains in effect unless
    /// overridden at the level of an individual view or view container.
    ///
    /// Here, the outermost ``VStack`` applies a 16-point system font as a
    /// default font to views contained in that ``VStack``. Inside that stack,
    /// the example applies a ``Font/largeTitle`` font to just the first text
    /// view; this explicitly overrides the default. The remaining stack and the
    /// views contained with it continue to use the 16-point system font set by
    /// their containing view:
    ///
    ///     VStack {
    ///         Text("Font applied to a text view.")
    ///             .font(.largeTitle)
    ///
    ///         VStack {
    ///             Text("These 2 text views have the same font")
    ///             Text("applied to their parent hierarchy")
    ///         }
    ///     }
    ///     .font(.system(size: 16, weight: .light, design: .default))
    ///
    /// ![A screenshot showing the application fonts to an individual text field
    /// and view hierarchy.](SkipUI-view-font.png)
    ///
    /// - Parameter font: The default font to use in this view.
    ///
    /// - Returns: A view with the default font set to the value you supply.
    @inlinable public func font(_ font: Font?) -> some View { return never() }


    /// Modifies the fonts of all child views to use fixed-width digits, if
    /// possible, while leaving other characters proportionally spaced.
    ///
    /// Using fixed-width digits allows you to easily align numbers of the
    /// same size in a table-like arrangement. This feature is also known as
    /// "tabular figures" or "tabular numbers."
    ///
    /// This modifier only affects numeric characters, and leaves all other
    /// characters unchanged.
    ///
    /// The following example shows the effect of `monospacedDigit()` on
    /// multiple child views. The example consists of two ``VStack`` views
    /// inside an ``HStack``. Each `VStack` contains two ``Button`` views, with
    /// the second `VStack` applying the `monospacedDigit()` modifier to its
    /// contents. As a result, the digits in the buttons in the trailing
    /// `VStack` are the same width, which in turn gives the buttons equal widths.
    ///
    ///     var body: some View {
    ///         HStack(alignment: .top) {
    ///             VStack(alignment: .leading) {
    ///                 Button("Delete 111 messages") {}
    ///                 Button("Delete 222 messages") {}
    ///             }
    ///             VStack(alignment: .leading) {
    ///                 Button("Delete 111 messages") {}
    ///                 Button("Delete 222 messages") {}
    ///             }
    ///             .monospacedDigit()
    ///         }
    ///         .padding()
    ///         .navigationTitle("monospacedDigit() Child Views")
    ///     }
    ///
    /// ![A macOS window showing four buttons, arranged in two columns. Each
    /// column's buttons contain the same text: Delete 111 messages and Delete
    /// 222 messages. The right column's buttons have fixed width, or
    /// monospaced, digits, which make the 1 characters wider than they would be
    /// in a proportional font. Because the 1 and 2 characters are the same
    /// width in the right column, the buttons are the same
    /// width.](View-monospacedDigit-1)
    ///
    /// If a child view's base font doesn't support fixed-width digits, the font
    /// remains unchanged.
    ///
    /// - Returns: A view whose child views' fonts use fixed-width numeric
    /// characters, while leaving other characters proportionally spaced.
    @available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
    public func monospacedDigit() -> some View { return never() }


    /// Modifies the fonts of all child views to use the fixed-width variant of
    /// the current font, if possible.
    ///
    /// If a child view's base font doesn't support fixed-width, the font
    /// remains unchanged.
    ///
    /// - Returns: A view whose child views' fonts use fixed-width characters,
    /// while leaving other characters proportionally spaced.
    @available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
    public func monospaced(_ isActive: Bool = true) -> some View { return never() }


    /// Sets the font weight of the text in this view.
    ///
    /// - Parameter weight: One of the available font weights.
    ///   Providing `nil` removes the effect of any font weight
    ///   modifier applied higher in the view hierarchy.
    ///
    /// - Returns: A view that uses the font weight you specify.
    @available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
    public func fontWeight(_ weight: Font.Weight?) -> some View { return never() }


    /// Sets the font width of the text in this view.
    ///
    /// - Parameter width: One of the available font widths.
    ///   Providing `nil` removes the effect of any font width
    ///   modifier applied higher in the view hierarchy.
    ///
    /// - Returns: A view that uses the font width you specify.
    @available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
    public func fontWidth(_ width: Font.Width?) -> some View { return never() }


    /// Applies a bold font weight to the text in this view.
    ///
    /// - Parameter isActive: A Boolean value that indicates
    ///   whether bold font styling is added. The default value is `true`.
    ///
    /// - Returns: A view with bold text.
    @available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
    public func bold(_ isActive: Bool = true) -> some View { return never() }


    /// Applies italics to the text in this view.
    ///
    /// - Parameter isActive: A Boolean value that indicates
    ///   whether italic styling is added. The default value is `true`.
    ///
    /// - Returns: A View with italic text.
    @available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
    public func italic(_ isActive: Bool = true) -> some View { return never() }


    /// Sets the font design of the text in this view.
    ///
    /// - Parameter design: One of the available font designs.
    ///   Providing `nil` removes the effect of any font design
    ///   modifier applied higher in the view hierarchy.
    ///
    /// - Returns: A view that uses the font design you specify.
    @available(iOS 16.1, macOS 13.0, tvOS 16.1, watchOS 9.1, *)
    public func fontDesign(_ design: Font.Design?) -> some View { return never() }


    /// Sets the spacing, or kerning, between characters for the text in this view.
    ///
    /// - Parameter kerning: The spacing to use between individual characters in text.
    ///   Value of `0` sets the kerning to the system default value.
    ///
    /// - Returns: A view where text has the specified amount of kerning.
    @available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
    public func kerning(_ kerning: CGFloat) -> some View { return never() }


    /// Sets the tracking for the text in this view.
    ///
    /// - Parameter tracking: The amount of additional space, in points, that
    ///   the view should add to each character cluster after layout. Value of `0`
    ///   sets the tracking to the system default value.
    ///
    /// - Returns: A view where text has the specified amount of tracking.
    @available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
    public func tracking(_ tracking: CGFloat) -> some View { return never() }


    /// Sets the vertical offset for the text relative to its baseline
    /// in this view.
    ///
    /// - Parameter baselineOffset: The amount to shift the text
    ///   vertically (up or down) relative to its baseline.
    ///
    /// - Returns: A view where text is above or below its baseline.
    @available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
    public func baselineOffset(_ baselineOffset: CGFloat) -> some View { return never() }

}

@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
extension View {

    /// Sets the style for forms in a view hierarchy.
    ///
    /// - Parameter style: The form style to set.
    /// - Returns: A view that uses the specified form style for itself
    ///   and its child views.
    public func formStyle<S>(_ style: S) -> some View where S : FormStyle { return never() }

}

extension View {

    /// Sets the visibility of scroll indicators within this view.
    ///
    /// Use this modifier to hide or show scroll indicators on scrollable
    /// content in views like a ``ScrollView``, ``List``, or ``TextEditor``.
    /// This modifier applies the prefered visibility to any
    /// scrollable content within a view hierarchy.
    ///
    ///     ScrollView {
    ///         VStack(alignment: .leading) {
    ///             ForEach(0..<100) {
    ///                 Text("Row \($0)")
    ///             }
    ///         }
    ///     }
    ///     .scrollIndicators(.hidden)
    ///
    /// Use the ``ScrollIndicatorVisibility/hidden`` value to indicate that you
    /// prefer that views never show scroll indicators along a given axis.
    /// Use ``ScrollIndicatorVisibility/visible`` when you prefer that
    /// views show scroll indicators. Depending on platform conventions,
    /// visible scroll indicators might only appear while scrolling. Pass
    /// ``ScrollIndicatorVisibility/automatic`` to allow views to
    /// decide whether or not to show their indicators.
    ///
    /// - Parameters:
    ///   - visibility: The visibility to apply to scrollable views.
    ///   - axes: The axes of scrollable views that the visibility applies to.
    ///
    /// - Returns: A view with the specified scroll indicator visibility.
    @available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
    public func scrollIndicators(_ visibility: ScrollIndicatorVisibility, axes: Axis.Set = [.vertical, .horizontal]) -> some View { return never() }

}

extension View {

    /// Flashes the scroll indicators of scrollable views when a value changes.
    ///
    /// When the value that you provide to this modifier changes, the scroll
    /// indicators of any scrollable views within the modified view hierarchy
    /// briefly flash. The following example configures the scroll indicators
    /// to flash any time `flashCount` changes:
    ///
    ///     @State private var isPresented = false
    ///     @State private var flashCount = 0
    ///
    ///     ScrollView {
    ///         // ...
    ///     }
    ///     .scrollIndicatorsFlash(trigger: flashCount)
    ///     .sheet(isPresented: $isPresented) {
    ///         // ...
    ///     }
    ///     .onChange(of: isPresented) { newValue in
    ///         if newValue {
    ///             flashCount += 1
    ///         }
    ///     }
    ///
    /// Only scroll indicators that you configure to be visible flash.
    /// To flash scroll indicators when a scroll view initially appears,
    /// use ``View/scrollIndicatorsFlash(onAppear:)`` instead.
    ///
    /// - Parameter value: The value that causes scroll indicators to flash.
    ///   The value must conform to the
    ///
    ///   protocol.
    ///
    /// - Returns: A view that flashes any visible scroll indicators when a
    ///   value changes.
    @available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
    public func scrollIndicatorsFlash(trigger value: some Equatable) -> some View { return never() }


    /// Flashes the scroll indicators of a scrollable view when it appears.
    ///
    /// Use this modifier to control whether the scroll indicators of a scroll
    /// view briefly flash when the view first appears. For example, you can
    /// make the indicators flash by setting the `onAppear` parameter to `true`:
    ///
    ///     ScrollView {
    ///         // ...
    ///     }
    ///     .scrollIndicatorsFlash(onAppear: true)
    ///
    /// Only scroll indicators that you configure to be visible flash.
    /// To flash scroll indicators when a value changes, use
    /// ``View/scrollIndicatorsFlash(trigger:)`` instead.
    ///
    /// - Parameter onAppear: A Boolean value that indicates whether the scroll
    ///   indicators flash when the scroll view appears.
    ///
    /// - Returns: A view that flashes any visible scroll indicators when it
    ///   first appears.
    @available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
    public func scrollIndicatorsFlash(onAppear: Bool) -> some View { return never() }

}

extension View {

    /// Disables or enables scrolling in scrollable views.
    ///
    /// Use this modifier to control whether a ``ScrollView`` can scroll:
    ///
    ///     @State private var isScrollDisabled = false
    ///
    ///     var body: some View {
    ///         ScrollView {
    ///             VStack {
    ///                 Toggle("Disable", isOn: $isScrollDisabled)
    ///                 MyContent()
    ///             }
    ///         }
    ///         .scrollDisabled(isScrollDisabled)
    ///     }
    ///
    /// SkipUI passes the disabled property through the environment, which
    /// means you can use this modifier to disable scrolling for all scroll
    /// views within a view hierarchy. In the following example, the modifier
    /// affects both scroll views:
    ///
    ///      ScrollView {
    ///          ForEach(rows) { row in
    ///              ScrollView(.horizontal) {
    ///                  RowContent(row)
    ///              }
    ///          }
    ///      }
    ///      .scrollDisabled(true)
    ///
    /// You can also use this modifier to disable scrolling for other kinds
    /// of scrollable views, like a ``List`` or a ``TextEditor``.
    ///
    /// - Parameter disabled: A Boolean that indicates whether scrolling is
    ///   disabled.
    @available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
    public func scrollDisabled(_ disabled: Bool) -> some View { return never() }

}

extension View {

    /// Sets whether a scroll view clips its content to its bounds.
    ///
    /// By default, a scroll view clips its content to its bounds, but you can
    /// disable that behavior by using this modifier. For example, if the views
    /// inside the scroll view have shadows that extend beyond the bounds of the
    /// scroll view, you can use this modifier to avoid clipping the shadows:
    ///
    ///     struct ContentView: View {
    ///         var disabled: Bool
    ///         let colors: [Color] = [.red, .green, .blue, .mint, .teal]
    ///
    ///         var body: some View {
    ///             ScrollView(.horizontal) {
    ///                 HStack(spacing: 20) {
    ///                     ForEach(colors, id: \.self) { color in
    ///                         Rectangle()
    ///                             .frame(width: 100, height: 100)
    ///                             .foregroundStyle(color)
    ///                             .shadow(color: .primary, radius: 20)
    ///                     }
    ///                 }
    ///             }
    ///             .scrollClipDisabled(disabled)
    ///         }
    ///     }
    ///
    /// The scroll view in the above example clips when the
    /// content view's `disabled` input is `false`, as it does
    /// if you omit the modifier, but not when the input is `true`:
    ///
    /// @TabNavigator {
    ///     @Tab("True") {
    ///         ![A horizontal row of uniformly sized, evenly spaced, vertically aligned squares inside a bounding box that's about twice the height of the squares, and almost four times the width. From left to right, three squares appear in full, while only the first quarter of a fourth square appears at the far right. All the squares have shadows that fade away before reaching the top or the bottom of the bounding box.](View-scrollClipDisabled-1-iOS)
    ///     }
    ///     @Tab("False") {
    ///         ![A horizontal row of uniformly sized, evenly spaced, vertically aligned squares inside a bounding box that's about twice the height of the squares, and almost four times the width. From left to right, three squares appear in full, while only the first quarter of a fourth square appears at the far right. All the squares have shadows that are visible in between squares, but clipped at the top and bottom of the squares.](View-scrollClipDisabled-2-iOS)
    ///     }
    /// }
    ///
    /// While you might want to avoid clipping parts of views that exceed the
    /// bounds of the scroll view, like the shadows in the above example, you
    /// typically still want the scroll view to clip at some point.
    /// Create custom clipping by using the ``View/clipShape(_:style:)``
    /// modifier to add a different clip shape. The following code disables
    /// the default clipping and then adds rectangular clipping that exceeds
    /// the bounds of the scroll view by the default padding amount:
    ///
    ///     ScrollView(.horizontal) {
    ///         // ...
    ///     }
    ///     .scrollClipDisabled()
    ///     .padding()
    ///     .clipShape(Rectangle())
    ///
    /// - Parameter disabled: A Boolean value that specifies whether to disable
    ///   scroll view clipping.
    ///
    /// - Returns: A view that disables or enables scroll view clipping.
    @available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
    public func scrollClipDisabled(_ disabled: Bool = true) -> some View { return never() }

}

extension View {

    /// Configures the behavior in which scrollable content interacts with
    /// the software keyboard.
    ///
    /// You use this modifier to customize how scrollable content interacts
    /// with the software keyboard. For example, you can specify a value of
    /// ``ScrollDismissesKeyboardMode/immediately`` to indicate that you
    /// would like scrollable content to immediately dismiss the keyboard if
    /// present when a scroll drag gesture begins.
    ///
    ///     @State private var text = ""
    ///
    ///     ScrollView {
    ///         TextField("Prompt", text: $text)
    ///         ForEach(0 ..< 50) { index in
    ///             Text("\(index)")
    ///                 .padding()
    ///         }
    ///     }
    ///     .scrollDismissesKeyboard(.immediately)
    ///
    /// You can also use this modifier to customize the keyboard dismissal
    /// behavior for other kinds of scrollable views, like a ``List`` or a
    /// ``TextEditor``.
    ///
    /// By default, a ``TextEditor`` is interactive while other kinds
    /// of scrollable content always dismiss the keyboard on a scroll
    /// when linked against iOS 16 or later. Pass a value of
    /// ``ScrollDismissesKeyboardMode/never`` to indicate that scrollable
    /// content should never automatically dismiss the keyboard.
    ///
    /// - Parameter mode: The keyboard dismissal mode that scrollable content
    ///   uses.
    ///
    /// - Returns: A view that uses the specified keyboard dismissal mode.
    @available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
    @available(xrOS, unavailable)
    public func scrollDismissesKeyboard(_ mode: ScrollDismissesKeyboardMode) -> some View { return never() }

}

extension View {

    /// Configures the bounce behavior of scrollable views along the specified
    /// axis.
    ///
    /// Use this modifier to indicate whether scrollable views bounce when
    /// people scroll to the end of the view's content, taking into account the
    /// relative sizes of the view and its content. For example, the following
    /// ``ScrollView`` only enables bounce behavior if its content is large
    /// enough to require scrolling:
    ///
    ///     ScrollView {
    ///         Text("Small")
    ///         Text("Content")
    ///     }
    ///     .scrollBounceBehavior(.basedOnSize)
    ///
    /// The modifier passes the scroll bounce mode through the ``Environment``,
    /// which means that the mode affects any scrollable views in the modified
    /// view hierarchy. Provide an axis to the modifier to constrain the kinds
    /// of scrollable views that the mode affects. For example, all the scroll
    /// views in the following example can access the mode value, but
    /// only the two nested scroll views are affected, because only they use
    /// horizontal scrolling:
    ///
    ///     ScrollView { // Defaults to vertical scrolling.
    ///         ScrollView(.horizontal) {
    ///             ShelfContent()
    ///         }
    ///         ScrollView(.horizontal) {
    ///             ShelfContent()
    ///         }
    ///     }
    ///     .scrollBounceBehavior(.basedOnSize, axes: .horizontal)
    ///
    /// You can use this modifier to configure any kind of scrollable view,
    /// including ``ScrollView``, ``List``, ``Table``, and ``TextEditor``:
    ///
    ///     List {
    ///         Text("Hello")
    ///         Text("World")
    ///     }
    ///     .scrollBounceBehavior(.basedOnSize)
    ///
    /// - Parameters:
    ///   - behavior: The bounce behavior to apply to any scrollable views
    ///     within the configured view. Use one of the ``ScrollBounceBehavior``
    ///     values.
    ///   - axes: The set of axes to apply `behavior` to. The default is
    ///     ``Axis/vertical``.
    ///
    /// - Returns: A view that's configured with the specified scroll bounce
    ///   behavior.
    @available(iOS 16.4, macOS 13.3, tvOS 16.4, watchOS 9.4, *)
    public func scrollBounceBehavior(_ behavior: ScrollBounceBehavior, axes: Axis.Set = [.vertical]) -> some View { return never() }

}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension View {

    /// Positions this view within an invisible frame with the specified size.
    ///
    /// Use this method to specify a fixed size for a view's width, height, or
    /// both. If you only specify one of the dimensions, the resulting view
    /// assumes this view's sizing behavior in the other dimension.
    ///
    /// For example, the following code lays out an ellipse in a fixed 200 by
    /// 100 frame. Because a shape always occupies the space offered to it by
    /// the layout system, the first ellipse is 200x100 points. The second
    /// ellipse is laid out in a frame with only a fixed height, so it occupies
    /// that height, and whatever width the layout system offers to its parent.
    ///
    ///     VStack {
    ///         Ellipse()
    ///             .fill(Color.purple)
    ///             .frame(width: 200, height: 100)
    ///         Ellipse()
    ///             .fill(Color.blue)
    ///             .frame(height: 100)
    ///     }
    ///
    /// ![A screenshot showing the effect of frame size options: a purple
    /// ellipse shows the effect of a fixed frame size, while a blue ellipse
    /// shows the effect of constraining a view in one
    /// dimension.](SkipUI-View-frame-1.png)
    ///
    /// `The alignment` parameter specifies this view's alignment within the
    /// frame.
    ///
    ///     Text("Hello world!")
    ///         .frame(width: 200, height: 30, alignment: .topLeading)
    ///         .border(Color.gray)
    ///
    /// In the example above, the text is positioned at the top, leading corner
    /// of the frame. If the text is taller than the frame, its bounds may
    /// extend beyond the bottom of the frame's bounds.
    ///
    /// ![A screenshot showing the effect of frame size options on a text view
    /// showing a fixed frame size with a specified
    /// alignment.](SkipUI-View-frame-2.png)
    ///
    /// - Parameters:
    ///   - width: A fixed width for the resulting view. If `width` is `nil`,
    ///     the resulting view assumes this view's sizing behavior.
    ///   - height: A fixed height for the resulting view. If `height` is `nil`,
    ///     the resulting view assumes this view's sizing behavior.
    ///   - alignment: The alignment of this view inside the resulting frame.
    ///     Note that most alignment values have no apparent effect when the
    ///     size of the frame happens to match that of this view.
    ///
    /// - Returns: A view with fixed dimensions of `width` and `height`, for the
    ///   parameters that are non-`nil`.
    @inlinable public func frame(width: CGFloat? = nil, height: CGFloat? = nil, alignment: Alignment = .center) -> some View { return never() }


    /// Positions this view within an invisible frame.
    ///
    /// Use ``SkipUI/View/frame(width:height:alignment:)`` or
    /// ``SkipUI/View/frame(minWidth:idealWidth:maxWidth:minHeight:idealHeight:maxHeight:alignment:)``
    /// instead.
    @available(*, deprecated, message: "Please pass one or more parameters.")
    @inlinable public func frame() -> some View { return never() }

}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension View {

    /// Positions this view within an invisible frame having the specified size
    /// constraints.
    ///
    /// Always specify at least one size characteristic when calling this
    /// method. Pass `nil` or leave out a characteristic to indicate that the
    /// frame should adopt this view's sizing behavior, constrained by the other
    /// non-`nil` arguments.
    ///
    /// The size proposed to this view is the size proposed to the frame,
    /// limited by any constraints specified, and with any ideal dimensions
    /// specified replacing any corresponding unspecified dimensions in the
    /// proposal.
    ///
    /// If no minimum or maximum constraint is specified in a given dimension,
    /// the frame adopts the sizing behavior of its child in that dimension. If
    /// both constraints are specified in a dimension, the frame unconditionally
    /// adopts the size proposed for it, clamped to the constraints. Otherwise,
    /// the size of the frame in either dimension is:
    ///
    /// - If a minimum constraint is specified and the size proposed for the
    ///   frame by the parent is less than the size of this view, the proposed
    ///   size, clamped to that minimum.
    /// - If a maximum constraint is specified and the size proposed for the
    ///   frame by the parent is greater than the size of this view, the
    ///   proposed size, clamped to that maximum.
    /// - Otherwise, the size of this view.
    ///
    /// - Parameters:
    ///   - minWidth: The minimum width of the resulting frame.
    ///   - idealWidth: The ideal width of the resulting frame.
    ///   - maxWidth: The maximum width of the resulting frame.
    ///   - minHeight: The minimum height of the resulting frame.
    ///   - idealHeight: The ideal height of the resulting frame.
    ///   - maxHeight: The maximum height of the resulting frame.
    ///   - alignment: The alignment of this view inside the resulting frame.
    ///     Note that most alignment values have no apparent effect when the
    ///     size of the frame happens to match that of this view.
    ///
    /// - Returns: A view with flexible dimensions given by the call's non-`nil`
    ///   parameters.
    @inlinable public func frame(minWidth: CGFloat? = nil, idealWidth: CGFloat? = nil, maxWidth: CGFloat? = nil, minHeight: CGFloat? = nil, idealHeight: CGFloat? = nil, maxHeight: CGFloat? = nil, alignment: Alignment = .center) -> some View { return never() }

}

@available(iOS 14.0, macOS 11.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension View {

    /// Sets the style for group boxes within this view.
    ///
    /// - Parameter style: The style to apply to boxes within this view.
    public func groupBoxStyle<S>(_ style: S) -> some View where S : GroupBoxStyle { return never() }

}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 7.0, *)
extension View {

    /// Sets the tab bar item associated with this view.
    ///
    /// Use `tabItem(_:)` to configure a view as a tab bar item in a
    /// ``TabView``. The example below adds two views as tabs in a ``TabView``:
    ///
    ///     struct View1: View {
    ///         var body: some View {
    ///             Text("View 1")
    ///         }
    ///     }
    ///
    ///     struct View2: View {
    ///         var body: some View {
    ///             Text("View 2")
    ///         }
    ///     }
    ///
    ///     struct TabItem: View {
    ///         var body: some View {
    ///             TabView {
    ///                 View1()
    ///                     .tabItem {
    ///                         Label("Menu", systemImage: "list.dash")
    ///                     }
    ///
    ///                 View2()
    ///                     .tabItem {
    ///                         Label("Order", systemImage: "square.and.pencil")
    ///                     }
    ///             }
    ///         }
    ///     }
    ///
    /// ![A screenshot of a two views configured as tab items in a tab
    /// view.](SkipUI-View-tabItem.png)
    ///
    /// - Parameter label: The tab bar item to associate with this view.
    public func tabItem<V>(@ViewBuilder _ label: () -> V) -> some View where V : View { return never() }

}

@available(iOS 13.0, macOS 10.15, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension View {

    /// Presents a popover using the given item as a data source for the
    /// popover's content.
    ///
    /// Use this method when you need to present a popover with content
    /// from a custom data source. The example below uses data in
    /// the `PopoverModel` structure to populate the view in the `content`
    /// closure that the popover displays to the user:
    ///
    ///     struct PopoverExample: View {
    ///         @State private var popover: PopoverModel?
    ///
    ///         var body: some View {
    ///             Button("Show Popover") {
    ///                 popover = PopoverModel(message: "Custom Message")
    ///             }
    ///             .popover(item: $popover) { detail in
    ///                 Text("\(detail.message)")
    ///                     .padding()
    ///             }
    ///         }
    ///     }
    ///
    ///     struct PopoverModel: Identifiable {
    ///         var id: String { message }
    ///         let message: String
    ///     }
    ///
    /// ![A screenshot showing a popover that says Custom Message hovering
    /// over a Show Popover button.](View-popover-2)
    ///
    /// - Parameters:
    ///   - item: A binding to an optional source of truth for the popover.
    ///     When `item` is non-`nil`, the system passes the contents to
    ///     the modifier's closure. You use this content to populate the fields
    ///     of a popover that you create that the system displays to the user.
    ///     If `item` changes, the system dismisses the currently presented
    ///     popover and replaces it with a new popover using the same process.
    ///   - attachmentAnchor: The positioning anchor that defines the
    ///     attachment point of the popover. The default is
    ///     ``Anchor/Source/bounds``.
    ///   - arrowEdge: The edge of the `attachmentAnchor` that defines the
    ///     location of the popover's arrow in macOS. The default is ``Edge/top``.
    ///     iOS ignores this parameter.
    ///   - content: A closure returning the content of the popover.
    @available(tvOS, unavailable)
    @available(watchOS, unavailable)
    public func popover<Item, Content>(item: Binding<Item?>, attachmentAnchor: PopoverAttachmentAnchor = .rect(.bounds), arrowEdge: Edge = .top, @ViewBuilder content: @escaping (Item) -> Content) -> some View where Item : Identifiable, Content : View { return never() }


    /// Presents a popover when a given condition is true.
    ///
    /// Use this method to show a popover whose contents are a SkipUI view
    /// that you provide when a bound Boolean variable is `true`. In the
    /// example below, a popover displays whenever the user toggles
    /// the `isShowingPopover` state variable by pressing the
    /// "Show Popover" button:
    ///
    ///     struct PopoverExample: View {
    ///         @State private var isShowingPopover = false
    ///
    ///         var body: some View {
    ///             Button("Show Popover") {
    ///                 self.isShowingPopover = true
    ///             }
    ///             .popover(isPresented: $isShowingPopover) {
    ///                 Text("Popover Content")
    ///                     .padding()
    ///             }
    ///         }
    ///     }
    ///
    /// ![A screenshot showing a popover that says Popover Content hovering
    /// over a Show Popover button.](View-popover-1)
    ///
    /// - Parameters:
    ///   - isPresented: A binding to a Boolean value that determines whether
    ///     to present the popover content that you return from the modifier's
    ///     `content` closure.
    ///   - attachmentAnchor: The positioning anchor that defines the
    ///     attachment point of the popover. The default is
    ///     ``Anchor/Source/bounds``.
    ///   - arrowEdge: The edge of the `attachmentAnchor` that defines the
    ///     location of the popover's arrow in macOS. The default is ``Edge/top``.
    ///     iOS ignores this parameter.
    ///   - content: A closure returning the content of the popover.
    @available(tvOS, unavailable)
    @available(watchOS, unavailable)
    public func popover<Content>(isPresented: Binding<Bool>, attachmentAnchor: PopoverAttachmentAnchor = .rect(.bounds), arrowEdge: Edge = .top, @ViewBuilder content: @escaping () -> Content) -> some View where Content : View { return never() }

}

@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
extension View {

    /// Sets the style for labels within this view.
    ///
    /// Use this modifier to set a specific style for all labels within a view:
    ///
    ///     VStack {
    ///         Label("Fire", systemImage: "flame.fill")
    ///         Label("Lightning", systemImage: "bolt.fill")
    ///     }
    ///     .labelStyle(MyCustomLabelStyle())
    ///
    public func labelStyle<S>(_ style: S) -> some View where S : LabelStyle { return never() }

}

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension View {

    /// Explicitly set whether this accessibility element is a direct touch
    /// area. Direct touch areas passthrough touch events to the app rather
    /// than being handled through an assistive technology, such as VoiceOver.
    /// The modifier accepts an optional `AccessibilityDirectTouchOptions`
    /// option set to customize the functionality of the direct touch area.
    ///
    /// For example, this is how a direct touch area would allow a VoiceOver
    /// user to interact with a view with a `rotationEffect` controlled by a
    /// `RotationGesture`. The direct touch area would require a user to
    /// activate the area before using the direct touch area.
    ///
    ///     var body: some View {
    ///         Rectangle()
    ///             .frame(width: 200, height: 200, alignment: .center)
    ///             .rotationEffect(angle)
    ///             .gesture(rotation)
    ///             .accessibilityDirectTouch(options: .requiresActivation)
    ///     }
    ///
    public func accessibilityDirectTouch(_ isDirectTouchArea: Bool = true, options: AccessibilityDirectTouchOptions = []) -> ModifiedContent<Self, AccessibilityAttachmentModifier> { fatalError() }
}

@available(iOS 13.4, macOS 10.15, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension View {

    /// Adds an action to perform when the user moves the pointer over or away
    /// from the view's frame.
    ///
    /// Calling this method defines a region for detecting pointer movement with
    /// the size and position of this view.
    ///
    /// - Parameter action: The action to perform whenever the pointer enters or
    ///   exits this view's frame. If the pointer is in the view's frame, the
    ///   `action` closure passes `true` as a parameter; otherwise, `false`.
    ///
    /// - Returns: A view that triggers `action` when the pointer enters or
    ///   exits this view's frame.
    @inlinable public func onHover(perform action: @escaping (Bool) -> Void) -> some View { return never() }

}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
extension View {

    /// Adds a descriptor to a View that represents a chart to make
    /// the chart's contents accessible to all users.
    ///
    /// Use this method to provide information about your chart view
    /// to allow VoiceOver and other assistive technology users to
    /// perceive and interact with your chart and its data.
    ///
    /// This may be applied to any View that represents a chart,
    /// including Image and custom-rendered chart views.
    ///
    /// The `accessibilityChartDescriptor` modifier can be applied to -any-
    /// view representing a chart, the simplest case being just an image of
    /// a chart. The implementation details of the view aren't important,
    /// only the fact that it represents a chart, and that the provided
    /// chart descriptor accurately describes the content of the chart.
    ///
    /// - Parameter chartDescriptor: The ``AXChartDescriptorRepresentable``
    ///  used to describe your chart and its data.
    ///
    /// Example usage:
    ///
    /// First define your `AXChartDescriptorRepresentable` type.
    ///
    ///     struct MyChartDescriptorRepresentable:
    ///     AXChartDescriptorRepresentable {
    ///         func makeChartDescriptor() -> AXChartDescriptor {
    ///             // Build and return your `AXChartDescriptor` here.
    ///         }
    ///
    ///         func updateChartDescriptor(_ descriptor: AXChartDescriptor) {
    ///             // Update your chart descriptor with any new values, or
    ///             // don't override if your chart doesn't have changing
    ///             // values.
    ///         }
    ///     }
    ///
    /// Then use the `accessibilityChartDescriptor` modifier to provide an
    /// instance of your `AXChartDescriptorRepresentable` type to the view
    /// representing your chart:
    ///
    ///     SomeChartView()
    ///         .accessibilityChartDescriptor(MyChartDescriptorRepresentable())
    public func accessibilityChartDescriptor<R>(_ representable: R) -> some View where R : AXChartDescriptorRepresentable { return never() }

}

@available(iOS 13.4, tvOS 16.0, xrOS 1.0, *)
@available(macOS, unavailable)
@available(watchOS, unavailable)
extension View {

    /// Applies a hover effect to this view.
    ///
    /// By default, ``HoverEffect/automatic`` is used. You can control the
    /// behavior of the automatic effect with the
    /// ``View/defaultHoverEffect(_:)`` modifier.
    ///
    /// - Parameters:
    ///   - effect: The effect to apply to this view.
    ///   - isEnabled: Whether the effect is enabled or not.
    /// - Returns: A new view that applies a hover effect to `self`.
    @available(iOS 13.4, tvOS 16.0, xrOS 1.0, *)
    @available(macOS, unavailable)
    @available(watchOS, unavailable)
    public func hoverEffect(_ effect: HoverEffect = .automatic) -> some View { return never() }

}

@available(iOS 17.0, tvOS 17.0, xrOS 1.0, *)
@available(macOS, unavailable)
@available(watchOS, unavailable)
extension View {

    /// Applies a hover effect to this view.
    ///
    /// By default, ``HoverEffect/automatic`` is used. You can control the
    /// behavior of the automatic effect with the
    /// ``View/defaultHoverEffect(_:)`` modifier.
    ///
    /// - Parameters:
    ///   - effect: The effect to apply to this view.
    ///   - isEnabled: Whether the effect is enabled or not.
    /// - Returns: A new view that applies a hover effect to `self`.
    public func hoverEffect(_ effect: HoverEffect = .automatic, isEnabled: Bool = true) -> some View { return never() }


    /// Sets the default hover effect to use for views within this view.
    ///
    /// Use this modifier to set a specific hover effect for all views with the
    /// ``View/hoverEffect(_:)`` modifier applied within a view. The default
    /// effect is typically used when no ``HoverEffect`` was provided or if
    /// ``HoverEffect/automatic`` is specified.
    ///
    /// For example, this view uses ``HoverEffect/highlight`` for both the red
    /// and green Color views:
    ///
    ///     HStack {
    ///         Color.red.hoverEffect()
    ///         Color.green.hoverEffect()
    ///     }
    ///     .defaultHoverEffect(.highlight)
    ///
    /// This also works for customizing the default hover effect in views like
    /// ``Button``s when using a SkipUI-defined style like
    /// ``ButtonStyle/bordered``, which can provide a hover effect by default.
    /// For example, this view replaces the hover effect for a ``Button`` with
    /// ``HoverEffect/highlight``:
    ///
    ///     Button("Next") {}
    ///         // perform action
    ///     }
    ///     .buttonStyle(.bordered)
    ///     .defaultHoverEffect(.highlight)
    ///
    /// Use a `nil` effect to indicate that the default hover effect should not
    /// be modified.
    ///
    /// - Parameter effect: The default hover effect to use for views within
    ///   this view.
    /// - Returns: A view that uses this effect as the default hover effect.
    public func defaultHoverEffect(_ effect: HoverEffect?) -> some View { return never() }


    /// Adds a condition that controls whether this view can display hover
    /// effects.
    ///
    /// The higher views in a view hierarchy can override the value you set on
    /// this view. In the following example, the button does not display a hover
    /// effect because the outer `hoverEffectDisabled(_:)` modifier overrides
    /// the inner one:
    ///
    ///     HStack {
    ///         Button("Press") {}
    ///             .hoverEffectDisabled(false)
    ///     }
    ///     .hoverEffectDisabled(true)
    ///
    /// - Parameter disabled: A Boolean value that determines whether this view
    ///   can display hover effects.
    ///
    /// - Returns: A view that controls whether hover effects can be displayed
    ///   in this view.
    public func hoverEffectDisabled(_ disabled: Bool = true) -> some View { return never() }

}


@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension View {

    /// Hides this view unconditionally.
    ///
    /// Hidden views are invisible and can't receive or respond to interactions.
    /// However, they do remain in the view hierarchy and affect layout. Use
    /// this modifier if you want to include a view for layout purposes, but
    /// don't want it to display.
    ///
    ///     HStack {
    ///         Image(systemName: "a.circle.fill")
    ///         Image(systemName: "b.circle.fill")
    ///         Image(systemName: "c.circle.fill")
    ///             .hidden()
    ///         Image(systemName: "d.circle.fill")
    ///     }
    ///
    /// The third circle takes up space, because it's still present, but
    /// SkipUI doesn't draw it onscreen.
    ///
    /// ![A row of circles with the letters A, B, and D, with a gap where
    ///   the circle with the letter C should be.](SkipUI-View-hidden-1.png)
    ///
    /// If you want to conditionally include a view in the view hierarchy, use
    /// an `if` statement instead:
    ///
    ///     VStack {
    ///         HStack {
    ///             Image(systemName: "a.circle.fill")
    ///             Image(systemName: "b.circle.fill")
    ///             if !isHidden {
    ///                 Image(systemName: "c.circle.fill")
    ///             }
    ///             Image(systemName: "d.circle.fill")
    ///         }
    ///         Toggle("Hide", isOn: $isHidden)
    ///     }
    ///
    /// Depending on the current value of the `isHidden` state variable in the
    /// example above, controlled by the ``Toggle`` instance, SkipUI draws
    /// the circle or completely omits it from the layout.
    ///
    /// ![Two side by side groups of items, each composed of a toggle beneath
    ///   a row of circles with letters in them. The toggle on the left
    ///   is off and has four equally spaced circles above it: A, B, C, and D.
    ///   The toggle on the right is on and has three equally spaced circles
    ///   above it: A, B, and D.](SkipUI-View-hidden-2.png)
    ///
    /// - Returns: A hidden view.
    @inlinable public func hidden() -> some View { return never() }

}

@available(iOS 16.0, macOS 13.0, watchOS 9.0, *)
@available(tvOS, unavailable)
extension View {

    /// Specifies the visibility of the background for scrollable views within
    /// this view.
    ///
    /// The following example hides the standard system background of the List.
    ///
    ///     List {
    ///         Text("One")
    ///         Text("Two")
    ///         Text("Three")
    ///     }
    ///     .scrollContentBackground(.hidden)
    ///
    /// - Parameters:
    ///    - visibility: the visibility to use for the background.
    public func scrollContentBackground(_ visibility: Visibility) -> some View { return never() }

}

extension View {

    /// Configures the view's document for purposes of navigation.
    ///
    /// In iOS, iPadOS, this populates the title menu with a header
    /// previewing the document. In macOS, this populates a proxy icon.
    ///
    /// Refer to the <doc:Configure-Your-Apps-Navigation-Titles> article
    /// for more information on navigation document modifiers.
    ///
    /// - Parameters:
    ///   - document: The URL content associated to the
    ///     navigation title.
    ///   - preview: The preview of the document to use when sharing.
    @available(iOS 16.0, macOS 13.0, watchOS 9.0, tvOS 16.0, *)
    public func navigationDocument(_ url: URL) -> some View { return never() }

}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
extension View {

    /// Modifies this view by binding its accessibility element's focus state to
    /// the given state value.
    ///
    /// - Parameters:
    ///   - binding: The state binding to register. When accessibility focus moves to the
    ///     accessibility element of the modified view, SkipUI sets the bound value to the corresponding
    ///     match value. If you set the state value programmatically to the matching value, then
    ///     accessibility focus moves to the accessibility element of the modified view. SkipUI sets
    ///     the value to `nil` if accessibility focus leaves the accessibility element associated with the
    ///     modified view, and programmatically setting the value to `nil` dismisses focus automatically.
    ///   - value: The value to match against when determining whether the
    ///     binding should change.
    /// - Returns: The modified view.
    public func accessibilityFocused<Value>(_ binding: AccessibilityFocusState<Value>.Binding, equals value: Value) -> some View where Value : Hashable { return never() }


    /// Modifies this view by binding its accessibility element's focus state
    /// to the given boolean state value.
    ///
    /// - Parameter condition: The accessibility focus state to bind. When
    ///     accessibility focus moves to the accessibility element of the
    ///     modified view, the focus value is set to `true`.
    ///     If the value is set to `true` programmatically, then accessibility
    ///     focus will move to accessibility element of the modified view.
    ///     The value will be set to `false` if accessibility focus leaves
    ///     the accessibility element of the modified view,
    ///     and accessibility focus will be dismissed automatically if the
    ///     value is set to `false` programmatically.
    ///
    /// - Returns: The modified view.
    public func accessibilityFocused(_ condition: AccessibilityFocusState<Bool>.Binding) -> some View { return never() }

}

@available(iOS 15.0, tvOS 15.0, watchOS 8.0, *)
@available(macOS, unavailable)
extension View {

    /// Sets how often the shift key in the keyboard is automatically enabled.
    ///
    /// Use `textInputAutocapitalization(_:)` when you need to automatically
    /// capitalize words, sentences, or other text like proper nouns.
    ///
    /// In example below, as the user enters text the shift key is
    /// automatically enabled before every word:
    ///
    ///     TextField("Last, First", text: $fullName)
    ///         .textInputAutocapitalization(.words)
    ///
    /// The ``TextInputAutocapitalization`` struct defines the available
    /// autocapitalizing behavior. Providing `nil` to  this view modifier does
    /// not change the autocapitalization behavior. The default is
    /// ``TextInputAutocapitalization.sentences``.
    ///
    /// - Parameter autocapitalization: One of the capitalizing behaviors
    /// defined in the ``TextInputAutocapitalization`` struct or nil.
    public func textInputAutocapitalization(_ autocapitalization: TextInputAutocapitalization?) -> some View { return never() }

}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
extension View {

    /// Sets the Dynamic Type size within the view to the given value.
    ///
    /// As an example, you can set a Dynamic Type size in `ContentView` to be
    /// ``DynamicTypeSize/xLarge`` (this can be useful in previews to see your
    /// content at a different size) like this:
    ///
    ///     ContentView()
    ///         .dynamicTypeSize(.xLarge)
    ///
    /// If a Dynamic Type size range is applied after setting a value,
    /// the value is limited by that range:
    ///
    ///     ContentView() // Dynamic Type size will be .large
    ///         .dynamicTypeSize(...DynamicTypeSize.large)
    ///         .dynamicTypeSize(.xLarge)
    ///
    /// When limiting the Dynamic Type size, consider if adding a
    /// large content view with ``View/accessibilityShowsLargeContentViewer()``
    /// would be appropriate.
    ///
    /// - Parameter size: The size to set for this view.
    ///
    /// - Returns: A view that sets the Dynamic Type size to the specified
    ///   `size`.
    public func dynamicTypeSize(_ size: DynamicTypeSize) -> some View { return never() }


    /// Limits the Dynamic Type size within the view to the given range.
    ///
    /// As an example, you can constrain the maximum Dynamic Type size in
    /// `ContentView` to be no larger than ``DynamicTypeSize/large``:
    ///
    ///     ContentView()
    ///         .dynamicTypeSize(...DynamicTypeSize.large)
    ///
    /// If the Dynamic Type size is limited to multiple ranges, the result is
    /// their intersection:
    ///
    ///     ContentView() // Dynamic Type sizes are from .small to .large
    ///         .dynamicTypeSize(.small...)
    ///         .dynamicTypeSize(...DynamicTypeSize.large)
    ///
    /// A specific Dynamic Type size can still be set after a range is applied:
    ///
    ///     ContentView() // Dynamic Type size is .xLarge
    ///         .dynamicTypeSize(.xLarge)
    ///         .dynamicTypeSize(...DynamicTypeSize.large)
    ///
    /// When limiting the Dynamic Type size, consider if adding a
    /// large content view with ``View/accessibilityShowsLargeContentViewer()``
    /// would be appropriate.
    ///
    /// - Parameter range: The range of sizes that are allowed in this view.
    ///
    /// - Returns: A view that constrains the Dynamic Type size of this view
    ///   within the specified `range`.
    public func dynamicTypeSize<T>(_ range: T) -> some View where T : RangeExpression, T.Bound == DynamicTypeSize { return never() }

}

@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
extension View {

    /// Defines a group of views with synchronized geometry using an
    /// identifier and namespace that you provide.
    ///
    /// This method sets the geometry of each view in the group from the
    /// inserted view with `isSource = true` (known as the "source" view),
    /// updating the values marked by `properties`.
    ///
    /// If inserting a view in the same transaction that another view
    /// with the same key is removed, the system will interpolate their
    /// frame rectangles in window space to make it appear that there
    /// is a single view moving from its old position to its new
    /// position. The usual transition mechanisms define how each of
    /// the two views is rendered during the transition (e.g. fade
    /// in/out, scale, etc), the `matchedGeometryEffect()` modifier
    /// only arranges for the geometry of the views to be linked, not
    /// their rendering.
    ///
    /// If the number of currently-inserted views in the group with
    /// `isSource = true` is not exactly one results are undefined, due
    /// to it not being clear which is the source view.
    ///
    /// - Parameters:
    ///   - id: The identifier, often derived from the identifier of
    ///     the data being displayed by the view.
    ///   - namespace: The namespace in which defines the `id`. New
    ///     namespaces are created by adding an `@Namespace` variable
    ///     to a ``View`` type and reading its value in the view's body
    ///     method.
    ///   - properties: The properties to copy from the source view.
    ///   - anchor: The relative location in the view used to produce
    ///     its shared position value.
    ///   - isSource: True if the view should be used as the source of
    ///     geometry for other views in the group.
    ///
    /// - Returns: A new view that defines an entry in the global
    ///   database of views synchronizing their geometry.
    ///
    @inlinable public func matchedGeometryEffect<ID>(id: ID, in namespace: Namespace.ID, properties: MatchedGeometryProperties = .frame, anchor: UnitPoint = .center, isSource: Bool = true) -> some View where ID : Hashable { return never() }

}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
extension View {

    /// Adds an action to perform when the user submits a value to this view.
    ///
    /// Different views may have different triggers for the provided action.
    /// A ``TextField``, or ``SecureField`` will trigger this action when the
    /// user hits the hardware or software return key. This modifier may also
    /// bind this action to a default action keyboard shortcut. You may set this
    /// action on an individual view or an entire view hierarchy.
    ///
    ///     TextField("Username", text: $username)
    ///         .onSubmit {
    ///             guard viewModel.validate() else { return }
    ///             viewModel.login()
    ///         }
    ///
    /// You can use the ``View/submitScope(_:)`` modifier to stop a submit
    /// trigger from a control from propagating higher up in the view hierarchy
    /// to higher `View.onSubmit(of:_:)` modifiers.
    ///
    ///     Form {
    ///         TextField("Username", text: $viewModel.userName)
    ///         SecureField("Password", text: $viewModel.password)
    ///
    ///         TextField("Tags", text: $viewModel.tags)
    ///             .submitScope()
    ///     }
    ///     .onSubmit {
    ///         guard viewModel.validate() else { return }
    ///         viewModel.login()
    ///     }
    ///
    /// You can use different submit triggers to filter the types of triggers
    /// that should invoke the provided submission action. For example, you
    /// may provide a value of ``SubmitTriggers/search`` to only hear
    /// submission triggers that originate from search fields vended by
    /// searchable modifiers.
    ///
    ///     @StateObject private var viewModel = ViewModel()
    ///
    ///     NavigationView {
    ///         SidebarView()
    ///         DetailView()
    ///     }
    ///     .searchable(
    ///         text: $viewModel.searchText,
    ///         placement: .sidebar
    ///     ) {
    ///         SuggestionsView()
    ///     }
    ///     .onSubmit(of: .search) {
    ///         viewModel.submitCurrentSearchQuery()
    ///     }
    ///
    /// - Parameters:
    ///   - triggers: The triggers that should invoke the provided action.
    ///   - action: The action to perform on submission of a value.
    public func onSubmit(of triggers: SubmitTriggers = .text, _ action: @escaping (() -> Void)) -> some View { return never() }


    /// Prevents submission triggers originating from this view to invoke
    /// a submission action configured by a submission modifier higher up
    /// in the view hierarchy.
    ///
    /// Use this modifier when you want to avoid specific views from initiating
    /// a submission action configured by the ``View/onSubmit(of:_:)`` modifier.
    /// In the example below, the tag field doesn't trigger the submission of
    /// the form:
    ///
    ///     Form {
    ///         TextField("Username", text: $viewModel.userName)
    ///         SecureField("Password", text: $viewModel.password)
    ///
    ///         TextField("Tags", text: $viewModel.tags)
    ///             .submitScope()
    ///     }
    ///     .onSubmit {
    ///         guard viewModel.validate() else { return }
    ///         viewModel.login()
    ///     }
    ///
    /// - Parameter isBlocking: A Boolean that indicates whether this scope is
    ///   actively blocking submission triggers from reaching higher submission
    ///   actions.
    public func submitScope(_ isBlocking: Bool = true) -> some View { return never() }

}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension View {

    /// Adds an action to perform when the specified preference key's value
    /// changes.
    ///
    /// - Parameters:
    ///   - key: The key to monitor for value changes.
    ///   - action: The action to perform when the value for `key` changes. The
    ///     `action` closure passes the new value as its parameter.
    ///
    /// - Returns: A view that triggers `action` when the value for `key`
    ///   changes.
    @inlinable public func onPreferenceChange<K>(_ key: K.Type = K.self, perform action: @escaping (K.Value) -> Void) -> some View where K : PreferenceKey, K.Value : Equatable { return never() }

}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 7.0, *)
extension View {

    /// Sets the style for navigation views within this view.
    ///
    /// Use this modifier to change the appearance and behavior of navigation
    /// views. For example, by default, navigation views appear with multiple
    /// columns in wider environments, like iPad in landscape orientation:
    ///
    /// ![A screenshot of an iPad in landscape orientation mode showing a
    /// multicolumn navigation view. The left column lists the colors Purple,
    /// Pink, and Orange, with Purple selected. The right column presents a
    /// detail view that shows a purple square.](View-navigationViewStyle-1)
    ///
    /// You can apply the ``NavigationViewStyle/stack`` style to force
    /// single-column stack navigation in these environments:
    ///
    ///     NavigationView {
    ///         List {
    ///             NavigationLink("Purple", destination: ColorDetail(color: .purple))
    ///             NavigationLink("Pink", destination: ColorDetail(color: .pink))
    ///             NavigationLink("Orange", destination: ColorDetail(color: .orange))
    ///         }
    ///         .navigationTitle("Colors")
    ///
    ///         Text("Select a Color") // A placeholder to show before selection.
    ///     }
    ///     .navigationViewStyle(.stack)
    ///
    /// ![A screenshot of an iPad in landscape orientation mode showing a
    /// single column containing the list Purple, Pink, and
    /// Orange.](View-navigationViewStyle-2)
    @available(iOS, introduced: 13.0, deprecated: 100000.0, message: "replace styled NavigationView with NavigationStack or NavigationSplitView instead")
    @available(macOS, introduced: 10.15, deprecated: 100000.0, message: "replace styled NavigationView with NavigationStack or NavigationSplitView instead")
    @available(tvOS, introduced: 13.0, deprecated: 100000.0, message: "replace styled NavigationView with NavigationStack or NavigationSplitView instead")
    @available(watchOS, introduced: 7.0, deprecated: 100000.0, message: "replace styled NavigationView with NavigationStack or NavigationSplitView instead")
    @available(xrOS, introduced: 1.0, deprecated: 100000.0, message: "replace styled NavigationView with NavigationStack or NavigationSplitView instead")
    public func navigationViewStyle<S>(_ style: S) -> some View where S : NavigationViewStyle { return never() }

}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension View {

    /// Sets the style for lists within this view.
    public func listStyle<S>(_ style: S) -> some View where S : ListStyle { return never() }

}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
extension View {

    /// Sets the rendering mode for symbol images within this view.
    ///
    /// - Parameter mode: The symbol rendering mode to use.
    ///
    /// - Returns: A view that uses the rendering mode you supply.
    @inlinable public func symbolRenderingMode(_ mode: SymbolRenderingMode?) -> some View { return never() }

}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
extension View {

    /// Explicitly set whether this Accessibility element responds to user
    /// interaction and would thus be interacted with by technologies such as
    /// Switch Control, Voice Control or Full Keyboard Access.
    ///
    /// If this is not set, the value is inferred from the traits of the
    /// Accessibility element, the presence of Accessibility actions on the
    /// element, or the presence of gestures on the element or containing views.
    public func accessibilityRespondsToUserInteraction(_ respondsToUserInteraction: Bool = true) -> ModifiedContent<Self, AccessibilityAttachmentModifier> { fatalError() }
}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
extension View {

    /// Marks this view as refreshable.
    ///
    /// Apply this modifier to a view to set the ``EnvironmentValues/refresh``
    /// value in the view's environment to a ``RefreshAction`` instance that
    /// uses the specified `action` as its handler. Views that detect the
    /// presence of the instance can change their appearance to provide a
    /// way for the user to execute the handler.
    ///
    /// For example, when you apply this modifier on iOS and iPadOS to a
    /// ``List``, the list enables a standard pull-to-refresh gesture that
    /// refreshes the list contents. When the user drags the top of the
    /// scrollable area downward, the view reveals a progress indicator
    /// and executes the specified handler. The indicator remains visible
    /// for the duration of the refresh, which runs asynchronously:
    ///
    ///     List(mailbox.conversations) { conversation in
    ///         ConversationCell(conversation)
    ///     }
    ///     .refreshable {
    ///         await mailbox.fetch()
    ///     }
    ///
    /// You can add refresh capability to your own views as well. For
    /// information on how to do that, see ``RefreshAction``.
    ///
    /// - Parameters:
    ///   - action: An asynchronous handler that SkipUI executes when the
    ///   user requests a refresh. Use this handler to initiate
    ///   an update of model data displayed in the modified view. Use
    ///   `await` in front of any asynchronous calls inside the handler.
    /// - Returns: A view with a new refresh action in its environment.
    public func refreshable(action: @escaping @Sendable () async -> Void) -> some View { return never() }

}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension View {

    /// Applies a transformation to a preference value.
    @inlinable public func transformPreference<K>(_ key: K.Type = K.self, _ callback: @escaping (inout K.Value) -> Void) -> some View where K : PreferenceKey { return never() }

}

extension View {

    /// Sets the screen edge from which you want your gesture to take
    /// precedence over the system gesture.
    ///
    /// The following code defers the vertical screen edges system gestures
    /// of a given canvas.
    ///
    ///     struct DeferredView: View {
    ///         var body: some View {
    ///             Canvas()
    ///                 .defersSystemGestures(on: .vertical)
    ///         }
    ///     }
    ///
    /// - Parameter edges: A value that indicates the screen edge from which
    ///   you want your gesture to take precedence over the system gesture.
    @available(iOS 16.0, *)
    @available(macOS, unavailable)
    @available(tvOS, unavailable)
    @available(watchOS, unavailable)
    @available(xrOS, unavailable)
    public func defersSystemGestures(on edges: Edge.Set) -> some View { return never() }

}

@available(iOS 15.0, macOS 12.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension View {

    /// Controls whether people can select text within this view.
    ///
    /// People sometimes need to copy useful information from ``Text`` views ---
    /// including error messages, serial numbers, or IP addresses --- so they
    /// can then paste the text into another context. Enable text selection
    /// to let people select text in a platform-appropriate way.
    ///
    /// You can apply this method to an individual text view, or to a
    /// container to make each contained text view selectable. In the following
    /// example, the person using the app can select text that shows the date of
    /// an event or the name or email of any of the event participants:
    ///
    ///     var body: some View {
    ///         VStack {
    ///             Text("Event Invite")
    ///                 .font(.title)
    ///             Text(invite.date.formatted(date: .long, time: .shortened))
    ///                 .textSelection(.enabled)
    ///
    ///             List(invite.recipients) { recipient in
    ///                 VStack (alignment: .leading) {
    ///                     Text(recipient.name)
    ///                     Text(recipient.email)
    ///                         .foregroundStyle(.secondary)
    ///                 }
    ///             }
    ///             .textSelection(.enabled)
    ///         }
    ///         .navigationTitle("New Invitation")
    ///     }
    ///
    /// On macOS, people use the mouse or trackpad to select a range of text,
    /// which they can quickly copy by choosing Edit > Copy, or with the
    /// standard keyboard shortcut.
    ///
    /// ![A macOS window titled New Invitation, with header Event Invite and
    /// the date and time of the event below it. The date --- July 31, 2022 ---
    /// is selected. Below this, a list of invitees by name and
    /// email.](View-textSelection-1)
    ///
    /// On iOS, the person using the app touches and holds on a selectable
    /// `Text` view, which brings up a system menu with menu items appropriate
    /// for the current context. These menu items operate on the entire contents
    /// of the `Text` view; the person can't select a range of text like they
    /// can on macOS.
    ///
    /// ![A portion of an iOS view, with header Event Invite and
    /// the date and time of the event below it. Below the date and time, a
    /// menu shows two items: Copy and Share. Below this, a list of invitees by
    /// name and email.](View-textSelection-2)
    ///
    /// - Note: ``Button`` views don't support text selection.
    public func textSelection<S>(_ selectability: S) -> some View where S : TextSelectability { return never() }

}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension View {

    /// Sets whether this view mirrors its contents horizontally when the layout
    /// direction is right-to-left.
    ///
    /// Use `flipsForRightToLeftLayoutDirection(_:)` when you need the system to
    /// horizontally mirror the contents of the view when presented in
    /// a right-to-left layout.
    ///
    /// To override the layout direction for a specific view, use the
    /// ``View/environment(_:_:)`` view modifier to explicitly override
    /// the ``EnvironmentValues/layoutDirection`` environment value for
    /// the view.
    ///
    /// - Parameter enabled: A Boolean value that indicates whether this view
    ///   should have its content flipped horizontally when the layout
    ///   direction is right-to-left. By default, views will adjust their layouts
    ///   automatically in a right-to-left context and do not need to be mirrored.
    ///
    /// - Returns: A view that conditionally mirrors its contents
    ///   horizontally when the layout direction is right-to-left.
    @inlinable public func flipsForRightToLeftLayoutDirection(_ enabled: Bool) -> some View { return never() }

}

extension View {

    /// Applies a text scale to text in the view.
    ///
    /// - Parameters:
    ///   - scale: The text scale to apply.
    ///   - isEnabled: If true the text scale is applied; otherwise text scale
    ///     is unchanged.
    /// - Returns: A view with the specified text scale applied.
    @available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
    public func textScale(_ scale: Text.Scale, isEnabled: Bool = true) -> some View { return never() }

}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
extension View {

    /// Sets whether VoiceOver should always speak all punctuation in the text view.
    ///
    /// Use this modifier to control whether the system speaks punctuation characters
    /// in the text. You might use this for code or other text where the punctuation is relevant, or where
    /// you want VoiceOver to speak a verbatim transcription of the text you provide. For example,
    /// given the text:
    ///
    ///     Text("All the world's a stage, " +
    ///          "And all the men and women merely players;")
    ///          .speechAlwaysIncludesPunctuation()
    ///
    /// VoiceOver would speak "All the world apostrophe s a stage comma and all the men
    /// and women merely players semicolon".
    ///
    /// By default, VoiceOver voices punctuation based on surrounding context.
    ///
    /// - Parameter value: A Boolean value that you set to `true` if
    ///   VoiceOver should speak all punctuation in the text. Defaults to `true`.
    public func speechAlwaysIncludesPunctuation(_ value: Bool = true) -> some View { return never() }


    /// Sets whether VoiceOver should speak the contents of the text view character by character.
    ///
    /// Use this modifier when you want VoiceOver to speak text as individual letters,
    /// character by character. This is important for text that is not meant to be spoken together, like:
    /// - An acronym that isn't a word, like APPL, spoken as "A-P-P-L".
    /// - A number representing a series of digits, like 25, spoken as "two-five" rather than "twenty-five".
    ///
    /// - Parameter value: A Boolean value that when `true` indicates
    ///    VoiceOver should speak text as individual characters. Defaults
    ///    to `true`.
    public func speechSpellsOutCharacters(_ value: Bool = true) -> some View { return never() }


    /// Raises or lowers the pitch of spoken text.
    ///
    /// Use this modifier when you want to change the pitch of spoken text.
    /// The value indicates how much higher or lower to change the pitch.
    ///
    /// - Parameter value: The amount to raise or lower the pitch.
    ///   Values between `-1` and `0` result in a lower pitch while
    ///   values between `0` and `1` result in a higher pitch.
    ///   The method clamps values to the range `-1` to `1`.
    public func speechAdjustedPitch(_ value: Double) -> some View { return never() }


    /// Controls whether to queue pending announcements behind existing speech rather than
    /// interrupting speech in progress.
    ///
    /// Use this modifier when you want affect the order in which the
    /// accessibility system delivers spoken text. Announcements can
    /// occur automatically when the label or value of an accessibility
    /// element changes.
    ///
    /// - Parameter value: A Boolean value that determines if VoiceOver speaks
    ///   changes to text immediately or enqueues them behind existing speech.
    ///   Defaults to `true`.
    public func speechAnnouncementsQueued(_ value: Bool = true) -> some View { return never() }

}

@available(iOS 16.0, *)
@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension View {

    /// Programmatically presents the find and replace interface for text
    /// editor views.
    ///
    /// Add this modifier to a ``TextEditor``, or to a view hierarchy that
    /// contains at least one text editor, to control the presentation of
    /// the find and replace interface. When you set the `isPresented` binding
    /// to `true`, the system shows the interface, and when you set it to
    /// `false`, the system hides the interface. The following example shows
    /// and hides the interface based on the state of a toolbar button:
    ///
    ///     TextEditor(text: $text)
    ///         .findNavigator(isPresented: $isPresented)
    ///         .toolbar {
    ///             Toggle(isOn: $isPresented) {
    ///                 Label("Find", systemImage: "magnifyingglass")
    ///             }
    ///         }
    ///
    /// The find and replace interface allows people to search for instances
    /// of a specified string in the text editor, and optionally to replace
    /// instances of the search string with another string. They can also
    /// show and hide the interface using built-in controls, like menus and
    /// keyboard shortcuts. SkipUI updates `isPresented` to reflect the
    /// users's actions.
    ///
    /// If the text editor view isn't currently in focus, the system still
    /// presents the find and replace interface when you set `isPresented`
    /// to `true`. If the view hierarchy contains multiple editors, the one
    /// that shows the find and replace interface is nondeterministic.
    ///
    /// You can disable the find and replace interface for a text editor by
    /// applying the ``View/findDisabled(_:)`` modifier to the editor. If you
    /// do that, setting this modifier's `isPresented` binding to `true` has
    /// no effect, but only if the disabling modifier appears closer to the
    /// text editor, like this:
    ///
    ///     TextEditor(text: $text)
    ///         .findDisabled(isDisabled)
    ///         .findNavigator(isPresented: $isPresented)
    ///
    /// - Parameter isPresented: A binding to a Boolean value that controls the
    ///   presentation of the find and replace interface.
    ///
    /// - Returns: A view that presents the find and replace interface when
    ///   `isPresented` is `true`.
    public func findNavigator(isPresented: Binding<Bool>) -> some View { return never() }


    /// Prevents find and replace operations in a text editor.
    ///
    /// Add this modifier to ensure that people can't activate the find
    /// and replace interface for a ``TextEditor``:
    ///
    ///     TextEditor(text: $text)
    ///         .findDisabled()
    ///
    /// When you disable the find operation, you also implicitly disable the
    /// replace operation. If you want to only disable replace, use
    /// ``View/replaceDisabled(_:)`` instead.
    ///
    /// Using this modifer also prevents programmatic find and replace
    /// interface presentation using the ``View/findNavigator(isPresented:)``
    /// method. Be sure to place the disabling modifier closer to the text
    /// editor for this to work:
    ///
    ///     TextEditor(text: $text)
    ///         .findDisabled(isDisabled)
    ///         .findNavigator(isPresented: $isPresented)
    ///
    /// If you apply this modifer at multiple levels of a view hierarchy,
    /// the call closest to the text editor takes precedence. For example,
    /// people can activate find and replace for the first text editor
    /// in the following example, but not the second:
    ///
    ///     VStack {
    ///         TextEditor(text: $text1)
    ///             .findDisabled(false)
    ///         TextEditor(text: $text2)
    ///     }
    ///     .findDisabled(true)
    ///
    /// - Parameter isDisabled: A Boolean value that indicates whether to
    ///   disable the find and replace interface for a text editor.
    ///
    /// - Returns: A view that disables the find and replace interface.
    public func findDisabled(_ isDisabled: Bool = true) -> some View { return never() }


    /// Prevents replace operations in a text editor.
    ///
    /// Add this modifier to ensure that people can't activate the replace
    /// feature of a find and replace interface for a ``TextEditor``:
    ///
    ///     TextEditor(text: $text)
    ///         .replaceDisabled()
    ///
    /// If you want to disable both find and replace, use the
    /// ``View/findDisabled(_:)`` modifier instead.
    ///
    /// Using this modifer also disables the replace feature of a find and
    /// replace interface that you present programmatically using the
    /// ``View/findNavigator(isPresented:)`` method. Be sure to place the
    /// disabling modifier closer to the text editor for this to work:
    ///
    ///     TextEditor(text: $text)
    ///         .replaceDisabled(isDisabled)
    ///         .findNavigator(isPresented: $isPresented)
    ///
    /// If you apply this modifer at multiple levels of a view hierarchy,
    /// the call closest to the text editor takes precedence. For example,
    /// people can activate find and replace for the first text editor
    /// in the following example, but only find for the second:
    ///
    ///     VStack {
    ///         TextEditor(text: $text1)
    ///             .replaceDisabled(false)
    ///         TextEditor(text: $text2)
    ///     }
    ///     .replaceDisabled(true)
    ///
    /// - Parameter isDisabled: A Boolean value that indicates whether text
    ///   replacement in the find and replace interface is disabled.
    ///
    /// - Returns: A view that disables the replace feature of a find and
    ///   replace interface.
    public func replaceDisabled(_ isDisabled: Bool = true) -> some View { return never() }

}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension View {

    /// Hides the labels of any controls contained within this view.
    ///
    /// Use this modifier when you want to omit a label from one or more
    /// controls in your user interface. For example, the first ``Toggle`` in
    /// the following example hides its label:
    ///
    ///     VStack {
    ///         Toggle(isOn: $toggle1) {
    ///             Text("Toggle 1")
    ///         }
    ///         .labelsHidden()
    ///
    ///         Toggle(isOn: $toggle2) {
    ///             Text("Toggle 2")
    ///         }
    ///     }
    ///
    /// The ``VStack`` in the example above centers the first toggle's control
    /// element in the available space, while it centers the second toggle's
    /// combined label and control element:
    ///
    /// ![A screenshot showing a view with two toggle controls where one label
    ///   is visible and the other label is hidden.](View-labelsHidden-1.png)
    ///
    /// Always provide a label for controls, even when you hide the label,
    /// because SkipUI uses labels for other purposes, including accessibility.
    ///
    /// > Note: This modifier doesn't work for all labels. It applies to
    ///   labels that are separate from the rest of the control's interface,
    ///   like they are for ``Toggle``, but not to controls like a bordered
    ///   button where the label is inside the button's border.
    public func labelsHidden() -> some View { return never() }

}

@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
extension View {

    /// Sets an explicit type select equivalent text in a collection, such as
    /// a list or table.
    ///
    /// By default, a type select equivalent is automatically derived from any
    /// `Text` or `TextField` content in a list or table. In the below example,
    /// type select can be used to select a person, even though no explicit
    /// value has been set.
    ///
    ///     List(people, selection: $selectedPersonID) { person in
    ///         Label {
    ///             Text(person.name)
    ///         } icon: {
    ///             person.avatar
    ///         }
    ///     }
    ///
    /// An explicit type select value should be set when there is no textual
    /// content or when a different value is desired compared to what's
    /// displayed in the view. Explicit values also provide a more performant
    /// for complex view types. In the below example, type select is explicitly
    /// set to allow selection of views that otherwise only display an image.
    ///
    ///     List(people, selection: $selectedPersonID) { person in
    ///         person.avatar
    ///             .accessibilityLabel(person.name)
    ///             .typeSelectEquivalent(person.name)
    ///     }
    ///
    /// Setting an empty string value disables text selection for the view,
    /// and a value of `nil` results in the view using its default value.
    ///
    /// - Parameter text: The explicit text value to use as a type select
    /// equivalent for a view in a collection.
    @inlinable public func typeSelectEquivalent(_ text: Text?) -> some View { return never() }


    /// Sets an explicit type select equivalent text in a collection, such as
    /// a list or table.
    ///
    /// By default, a type select equivalent is automatically derived from any
    /// `Text` or `TextField` content in a list or table. In the below example,
    /// type select can be used to select a person, even though no explicit
    /// value has been set.
    ///
    ///     List(people, selection: $selectedPersonID) { person in
    ///         Label {
    ///             Text(person.name)
    ///         } icon: {
    ///             person.avatar
    ///         }
    ///     }
    ///
    /// An explicit type select value should be set when there is no textual
    /// content or when a different value is desired compared to what's
    /// displayed in the view. Explicit values also provide a more performant
    /// for complex view types. In the below example, type select is explicitly
    /// set to allow selection of views that otherwise only display an image.
    ///
    ///     List(people, selection: $selectedPersonID) { person in
    ///         person.avatar
    ///             .accessibilityLabel(person.name)
    ///             .typeSelectEquivalent(person.name)
    ///     }
    ///
    /// Setting an empty string value disables text selection for the view,
    /// and a value of `nil` results in the view using its default value.
    ///
    /// - Parameter stringKey: The localized string key to use as a type select
    /// equivalent for a view in a collection.
    @_backDeploy(before: iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0)
    @inlinable public func typeSelectEquivalent(_ stringKey: LocalizedStringKey) -> some View { return never() }


    /// Sets an explicit type select equivalent text in a collection, such as
    /// a list or table.
    ///
    /// By default, a type select equivalent is automatically derived from any
    /// `Text` or `TextField` content in a list or table. In the below example,
    /// type select can be used to select a person, even though no explicit
    /// value has been set.
    ///
    ///     List(people, selection: $selectedPersonID) { person in
    ///         Label {
    ///             Text(person.name)
    ///         } icon: {
    ///             person.avatar
    ///         }
    ///     }
    ///
    /// An explicit type select value should be set when there is no textual
    /// content or when a different value is desired compared to what's
    /// displayed in the view. Explicit values also provide a more performant
    /// for complex view types. In the below example, type select is explicitly
    /// set to allow selection of views that otherwise only display an image.
    ///
    ///     List(people, selection: $selectedPersonID) { person in
    ///         person.avatar
    ///             .accessibilityLabel(person.name)
    ///             .typeSelectEquivalent(person.name)
    ///     }
    ///
    /// Setting an empty string value disables text selection for the view,
    /// and a value of `nil` results in the view using its default value.
    ///
    /// - Parameter string: The string to use as a type select equivalent for a
    /// view in a collection.
    @_backDeploy(before: iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0)
    @inlinable public func typeSelectEquivalent<S>(_ string: S) -> some View where S : StringProtocol { return never() }

}

@available(iOS 15.0, macOS 12.0, watchOS 8.0, *)
@available(tvOS, unavailable)
extension View {

    /// Adds custom swipe actions to a row in a list.
    ///
    /// Use this method to add swipe actions to a view that acts as a row in a
    /// list. Indicate the ``HorizontalEdge`` where the swipe action
    /// originates, and define individual actions with ``Button`` instances.
    /// For example, if you have a list of messages,
    /// you can add an action to toggle a message as unread
    /// on a swipe from the leading edge,
    /// and actions to delete or flag messages on a trailing edge swipe:
    ///
    ///     List {
    ///         ForEach(store.messages) { message in
    ///             MessageCell(message: message)
    ///                 .swipeActions(edge: .leading) {
    ///                     Button { store.toggleUnread(message) } label: {
    ///                         if message.isUnread {
    ///                             Label("Read", systemImage: "envelope.open")
    ///                         } else {
    ///                             Label("Unread", systemImage: "envelope.badge")
    ///                         }
    ///                     }
    ///                 }
    ///                 .swipeActions(edge: .trailing) {
    ///                     Button(role: .destructive) {
    ///                         store.delete(message)
    ///                     } label: {
    ///                         Label("Delete", systemImage: "trash")
    ///                     }
    ///                     Button { store.flag(message) } label: {
    ///                         Label("Flag", systemImage: "flag")
    ///                     }
    ///                 }
    ///             }
    ///         }
    ///     }
    ///
    /// Actions appear in the order you list them, starting from the swipe's
    /// originating edge. In the example above, the Delete action appears
    /// closest to the screen's trailing edge:
    ///
    /// ![A screenshot of a list of messages, where one of the messages has been
    ///   swiped from the trailing edge, revealing a Flag and Delete button.
    ///   The Flag button is grey, while the Delete button is
    ///   red.](View-swipeActions-1)
    ///
    /// For labels or images that appear in swipe actions, SkipUI automatically
    /// applies the ``SymbolVariants/fill-swift.type.property`` symbol variant,
    /// as shown above.
    ///
    /// By default, the user can perform the first action for a given swipe
    /// direction with a full swipe. For the example above, the user can perform
    /// both the toggle unread and delete actions with full swipes.
    /// You can opt out of this behavior for an edge by setting
    /// the `allowsFullSwipe` parameter to `false`. For example, you can
    /// disable the full swipe on the leading edge:
    ///
    ///     .swipeActions(edge: .leading, allowsFullSwipe: false) {
    ///         Button { store.toggleUnread(message) } label: {
    ///             if message.isUnread {
    ///                 Label("Read", systemImage: "envelope.open")
    ///             } else {
    ///                 Label("Unread", systemImage: "envelope.badge")
    ///             }
    ///         }
    ///     }
    ///
    /// When you set a role for a button using one of the values from the
    /// ``ButtonRole`` enumeration, SkipUI styles the button according to
    /// its role. In the example above, the delete action appears in
    /// ``ShapeStyle/red`` because it has the ``ButtonRole/destructive`` role.
    /// If you want to set a different color — for example, to match the
    /// overall theme of your app's UI — add the ``View/tint(_:)``
    /// modifier to the button:
    ///
    ///     MessageCell(message: message)
    ///         .swipeActions(edge: .leading) {
    ///             Button { store.toggleUnread(message) } label: {
    ///                 if message.isUnread {
    ///                     Label("Read", systemImage: "envelope.open")
    ///                 } else {
    ///                     Label("Unread", systemImage: "envelope.badge")
    ///                 }
    ///             }
    ///             .tint(.blue)
    ///         }
    ///         .swipeActions(edge: .trailing) {
    ///             Button(role: .destructive) { store.delete(message) } label: {
    ///                 Label("Delete", systemImage: "trash")
    ///             }
    ///             Button { store.flag(message) } label: {
    ///                 Label("Flag", systemImage: "flag")
    ///             }
    ///             .tint(.orange)
    ///         }
    ///
    /// The modifications in the code above make the toggle unread action
    /// ``ShapeStyle/blue`` and the flag action ``ShapeStyle/orange``:
    ///
    /// ![A screenshot of a row that the user swiped from the leading edge
    ///   to reveal a blue Unread button, and another screenshot of the same
    ///   row after the user swiped from the trailing edge to reveal an
    ///   orange Flag button and a red Delete button.](View-swipeActions-2)
    ///
    /// When you add swipe actions, SkipUI no longer synthesizes the Delete
    /// actions that otherwise appear when using the
    /// ``ForEach/onDelete(perform:)`` method on a ``ForEach`` instance.
    /// You become responsible for creating a Delete
    /// action, if appropriate, among your swipe actions.
    ///
    /// Actions accumulate for a given edge if you call the modifier multiple
    /// times on the same list row view.
    ///
    /// - Parameters:
    ///     - edge: The edge of the view to associate the swipe actions with.
    ///         The default is ``HorizontalEdge/trailing``.
    ///     - allowsFullSwipe: A Boolean value that indicates whether a full swipe
    ///         automatically performs the first action. The default is `true`.
    ///     - content: The content of the swipe actions.
    public func swipeActions<T>(edge: HorizontalEdge = .trailing, allowsFullSwipe: Bool = true, @ViewBuilder content: () -> T) -> some View where T : View { return never() }

}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
extension View {

    /// Sets the content shape for this view.
    ///
    /// The content shape has a variety of uses. You can control the kind of the
    /// content shape by specifying one in `kind`. For example, the
    /// following example only sets the focus ring shape of the view, without
    /// affecting its shape for hit-testing:
    ///
    ///     MyFocusableView()
    ///         .contentShape(.focusEffect, Circle())
    ///
    /// - Parameters:
    ///   - kind: The kinds to apply to this content shape.
    ///   - shape: The shape to use.
    ///   - eoFill: A Boolean that indicates whether the shape is interpreted
    ///     with the even-odd winding number rule.
    ///
    /// - Returns: A view that uses the given shape for the specified kind.
    @inlinable public func contentShape<S>(_ kind: ContentShapeKinds, _ shape: S, eoFill: Bool = false) -> some View where S : Shape { return never() }

}

@available(iOS 15.0, macOS 12.0, tvOS 17.0, *)
@available(watchOS, unavailable)
extension View {

    /// Sets the style for control groups within this view.
    ///
    /// - Parameter style: The style to apply to controls within this view.
    public func controlGroupStyle<S>(_ style: S) -> some View where S : ControlGroupStyle { return never() }

}

@available(iOS 14.0, macOS 11.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension View {

    /// Defines a keyboard shortcut and assigns it to the modified control.
    ///
    /// Pressing the control's shortcut while the control is anywhere in the
    /// frontmost window or scene, or anywhere in the macOS main menu, is
    /// equivalent to direct interaction with the control to perform its primary
    /// action.
    ///
    /// The target of a keyboard shortcut is resolved in a leading-to-trailing,
    /// depth-first traversal of one or more view hierarchies. On macOS, the
    /// system looks in the key window first, then the main window, and then the
    /// command groups; on other platforms, the system looks in the active
    /// scene, and then the command groups.
    ///
    /// If multiple controls are associated with the same shortcut, the first
    /// one found is used.
    ///
    /// The default localization configuration is set to ``KeyboardShortcut/Localization-swift.struct/automatic``.
    public func keyboardShortcut(_ key: KeyEquivalent, modifiers: EventModifiers = .command) -> some View { return never() }


    /// Assigns a keyboard shortcut to the modified control.
    ///
    /// Pressing the control's shortcut while the control is anywhere in the
    /// frontmost window or scene, or anywhere in the macOS main menu, is
    /// equivalent to direct interaction with the control to perform its primary
    /// action.
    ///
    /// The target of a keyboard shortcut is resolved in a leading-to-trailing
    /// traversal of one or more view hierarchies. On macOS, the system looks in
    /// the key window first, then the main window, and then the command groups;
    /// on other platforms, the system looks in the active scene, and then the
    /// command groups.
    ///
    /// If multiple controls are associated with the same shortcut, the first
    /// one found is used.
    public func keyboardShortcut(_ shortcut: KeyboardShortcut) -> some View { return never() }


    /// Assigns an optional keyboard shortcut to the modified control.
    ///
    /// Pressing the control's shortcut while the control is anywhere in the
    /// frontmost window or scene, or anywhere in the macOS main menu, is
    /// equivalent to direct interaction with the control to perform its primary
    /// action.
    ///
    /// The target of a keyboard shortcut is resolved in a leading-to-trailing
    /// traversal of one or more view hierarchies. On macOS, the system looks in
    /// the key window first, then the main window, and then the command groups;
    /// on other platforms, the system looks in the active scene, and then the
    /// command groups.
    ///
    /// If multiple controls are associated with the same shortcut, the first
    /// one found is used. If the provided shortcut is `nil`, the modifier will
    /// have no effect.
    @available(iOS 15.4, macOS 12.3, *)
    @available(tvOS, unavailable)
    @available(watchOS, unavailable)
    public func keyboardShortcut(_ shortcut: KeyboardShortcut?) -> some View { return never() }

}

@available(iOS 15.0, macOS 12.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension View {

    /// Defines a keyboard shortcut and assigns it to the modified control.
    ///
    /// Pressing the control's shortcut while the control is anywhere in the
    /// frontmost window or scene, or anywhere in the macOS main menu, is
    /// equivalent to direct interaction with the control to perform its primary
    /// action.
    ///
    /// The target of a keyboard shortcut is resolved in a leading-to-trailing,
    /// depth-first traversal of one or more view hierarchies. On macOS, the
    /// system looks in the key window first, then the main window, and then the
    /// command groups; on other platforms, the system looks in the active
    /// scene, and then the command groups.
    ///
    /// If multiple controls are associated with the same shortcut, the first
    /// one found is used.
    ///
    /// ### Localization
    ///
    /// Provide a `localization` value to specify how this shortcut
    /// should be localized.
    /// Given that `key` is always defined in relation to the US-English
    /// keyboard layout, it might be hard to reach on different international
    /// layouts. For example the shortcut `⌘[` works well for the
    /// US layout but is hard to reach for German users, where
    /// `[` is available by pressing `⌥5`, making users type `⌥⌘5`.
    /// The automatic keyboard shortcut remapping re-assigns the shortcut to
    /// an appropriate replacement, `⌘Ö` in this case.
    ///
    /// Certain shortcuts carry information about directionality. For instance,
    /// `⌘[` can reveal a previous view. Following the layout direction of
    /// the UI, this shortcut will be automatically mirrored to `⌘]`.
    /// However, this does not apply to items such as "Align Left `⌘{`",
    /// which will be "left" independently of the layout direction.
    /// When the shortcut shouldn't follow the directionality of the UI, but rather
    /// be the same in both right-to-left and left-to-right directions, using
    /// ``KeyboardShortcut/Localization-swift.struct/withoutMirroring``
    /// will prevent the system from flipping it.
    ///
    ///     var body: some Commands {
    ///         CommandMenu("Card") {
    ///             Button("Align Left") { ... }
    ///                 .keyboardShortcut("{",
    ///                      modifiers: .option,
    ///                      localization: .withoutMirroring)
    ///             Button("Align Right") { ... }
    ///                 .keyboardShortcut("}",
    ///                      modifiers: .option,
    ///                      localization: .withoutMirroring)
    ///         }
    ///     }
    ///
    /// Lastly, providing the option
    /// ``KeyboardShortcut/Localization-swift.struct/custom``
    /// disables
    /// the automatic localization for this shortcut to tell the system that
    /// internationalization is taken care of in a different way.
    public func keyboardShortcut(_ key: KeyEquivalent, modifiers: EventModifiers = .command, localization: KeyboardShortcut.Localization) -> some View { return never() }

}

extension View {

    /// Modifies this view by injecting a value that you provide for use by
    /// other views whose state depends on the focused view hierarchy.
    ///
    /// - Parameters:
    ///   - keyPath: The key path to associate `value` with when adding
    ///     it to the existing table of exported focus values.
    ///   - value: The focus value to export.
    /// - Returns: A modified representation of this view.
    @available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
    public func focusedValue<Value>(_ keyPath: WritableKeyPath<FocusedValues, Value?>, _ value: Value) -> some View { return never() }


    /// Creates a new view that exposes the provided value to other views whose
    /// state depends on the focused view hierarchy.
    ///
    /// Use this method instead of ``View/focusedSceneValue(_:_:)`` when your
    /// scene includes multiple focusable views with their own associated
    /// values, and you need an app- or scene-scoped element like a command or
    /// toolbar item that operates on the value associated with whichever view
    /// currently has focus. Each focusable view can supply its own value:
    ///
    ///
    ///
    /// - Parameters:
    ///   - keyPath: The key path to associate `value` with when adding
    ///     it to the existing table of exported focus values.
    ///   - value: The focus value to export, or `nil` if no value is
    ///     currently available.
    /// - Returns: A modified representation of this view.
    @available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
    public func focusedValue<Value>(_ keyPath: WritableKeyPath<FocusedValues, Value?>, _ value: Value?) -> some View { return never() }


    /// Modifies this view by injecting a value that you provide for use by
    /// other views whose state depends on the focused scene.
    ///
    /// Use this method instead of ``View/focusedValue(_:_:)`` for values that
    /// must be visible regardless of where focus is located in the active
    /// scene. For example, if an app needs a command for moving focus to a
    /// particular text field in the sidebar, it could use this modifier to
    /// publish a button action that's visible to command views as long as the
    /// scene is active, and regardless of where focus happens to be in it.
    ///
    ///     struct Sidebar: View {
    ///         @FocusState var isFiltering: Bool
    ///
    ///         var body: some View {
    ///             VStack {
    ///                 TextField(...)
    ///                     .focused(when: $isFiltering)
    ///                     .focusedSceneValue(\.filterAction) {
    ///                         isFiltering = true
    ///                     }
    ///             }
    ///         }
    ///     }
    ///
    ///     struct NavigationCommands: Commands {
    ///         @FocusedValue(\.filterAction) var filterAction
    ///
    ///         var body: some Commands {
    ///             CommandMenu("Navigate") {
    ///                 Button("Filter in Sidebar") {
    ///                     filterAction?()
    ///                 }
    ///             }
    ///             .disabled(filterAction == nil)
    ///         }
    ///     }
    ///
    ///     struct FilterActionKey: FocusedValuesKey {
    ///         typealias Value = () -> Void
    ///     }
    ///
    ///     extension FocusedValues {
    ///         var filterAction: (() -> Void)? {
    ///             get { self[FilterActionKey.self] }
    ///             set { self[FilterActionKey.self] = newValue }
    ///         }
    ///     }
    ///
    /// - Parameters:
    ///   - keyPath: The key path to associate `value` with when adding
    ///     it to the existing table of published focus values.
    ///   - value: The focus value to publish.
    /// - Returns: A modified representation of this view.
    @available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
    public func focusedSceneValue<T>(_ keyPath: WritableKeyPath<FocusedValues, T?>, _ value: T) -> some View { return never() }


    /// Creates a new view that exposes the provided value to other views whose
    /// state depends on the active scene.
    ///
    /// Use this method instead of ``View/focusedValue(_:_:)`` for values that
    /// must be visible regardless of where focus is located in the active
    /// scene. For example, if an app needs a command for moving focus to a
    /// particular text field in the sidebar, it could use this modifier to
    /// publish a button action that's visible to command views as long as the
    /// scene is active, and regardless of where focus happens to be in it.
    ///
    ///     struct Sidebar: View {
    ///         @FocusState var isFiltering: Bool
    ///
    ///         var body: some View {
    ///             VStack {
    ///                 TextField(...)
    ///                     .focused(when: $isFiltering)
    ///                     .focusedSceneValue(\.filterAction) {
    ///                         isFiltering = true
    ///                     }
    ///             }
    ///         }
    ///     }
    ///
    ///     struct NavigationCommands: Commands {
    ///         @FocusedValue(\.filterAction) var filterAction
    ///
    ///         var body: some Commands {
    ///             CommandMenu("Navigate") {
    ///                 Button("Filter in Sidebar") {
    ///                     filterAction?()
    ///                 }
    ///             }
    ///             .disabled(filterAction == nil)
    ///         }
    ///     }
    ///
    ///     struct FilterActionKey: FocusedValuesKey {
    ///         typealias Value = () -> Void
    ///     }
    ///
    ///     extension FocusedValues {
    ///         var filterAction: (() -> Void)? {
    ///             get { self[FilterActionKey.self] }
    ///             set { self[FilterActionKey.self] = newValue }
    ///         }
    ///     }
    ///
    /// - Parameters:
    ///   - keyPath: The key path to associate `value` with when adding
    ///     it to the existing table of published focus values.
    ///   - value: The focus value to publish, or `nil` if no value is
    ///     currently available.
    /// - Returns: A modified representation of this view.
    @available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
    public func focusedSceneValue<T>(_ keyPath: WritableKeyPath<FocusedValues, T?>, _ value: T?) -> some View { return never() }

}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension View {

    /// Sets the alignment of a text view that contains multiple lines of text.
    ///
    /// Use this modifier to set an alignment for a multiline block of text.
    /// For example, the modifier centers the contents of the following
    /// ``Text`` view:
    ///
    ///     Text("This is a block of text that shows up in a text element as multiple lines.\("\n") Here we have chosen to center this text.")
    ///         .frame(width: 200)
    ///         .multilineTextAlignment(.center)
    ///
    /// The text in the above example spans more than one line because:
    ///
    /// * The newline character introduces a line break.
    /// * The frame modifier limits the space available to the text view, and
    ///   by default a text view wraps lines that don't fit in the available
    ///   width. As a result, the text before the explicit line break wraps to
    ///   three lines, and the text after uses two lines.
    ///
    /// The modifier applies the alignment to the all the lines of text in
    /// the view, regardless of why wrapping occurs:
    ///
    /// ![A block of text that spans 5 lines. The lines of text are center-aligned.](View-multilineTextAlignment-1-iOS)
    ///
    /// The modifier has no effect on a ``Text`` view that contains only one
    /// line of text, because a text view has a width that exactly matches the
    /// width of its widest line. If you want to align an entire text view
    /// rather than its contents, set the aligment of its container, like a
    /// ``VStack`` or a frame that you create with the
    /// ``View/frame(minWidth:idealWidth:maxWidth:minHeight:idealHeight:maxHeight:alignment:)``
    /// modifier.
    ///
    /// > Note: You can use this modifier to control the alignment of a ``Text``
    ///   view that you create with the ``Text/init(_:style:)`` initializer
    ///   to display localized dates and times, including when the view uses
    ///   only a single line, but only when that view appears in a widget.
    ///
    /// The modifier also affects the content alignment of other text container
    /// types, like ``TextEditor`` and ``TextField``. In those cases, the
    /// modifier sets the alignment even when the view contains only a single
    /// line because view's width isn't dictated by the width of the text it
    /// contains.
    ///
    /// The modifier operates by setting the
    /// ``EnvironmentValues/multilineTextAlignment`` value in the environment,
    /// so it affects all the text containers in the modified view hierarchy.
    /// For example, you can apply the modifier to a ``VStack`` to
    /// configure all the text views inside the stack.
    ///
    /// - Parameter alignment: A value that you use to align multiple lines of
    ///   text within a view.
    ///
    /// - Returns: A view that aligns the lines of multiline ``Text`` instances
    ///   it contains.
    @inlinable public func multilineTextAlignment(_ alignment: TextAlignment) -> some View { return never() }


    /// Sets the truncation mode for lines of text that are too long to fit in
    /// the available space.
    ///
    /// Use the `truncationMode(_:)` modifier to determine whether text in a
    /// long line is truncated at the beginning, middle, or end. Truncation is
    /// indicated by adding an ellipsis (…) to the line when removing text to
    /// indicate to readers that text is missing.
    ///
    /// In the example below, the bounds of text view constrains the amount of
    /// text that the view displays and the `truncationMode(_:)` specifies from
    /// which direction and where to display the truncation indicator:
    ///
    ///     Text("This is a block of text that will show up in a text element as multiple lines. The text will fill the available space, and then, eventually, be truncated.")
    ///         .frame(width: 150, height: 150)
    ///         .truncationMode(.tail)
    ///
    /// ![A screenshot showing the effect of truncation mode on text in a
    /// view.](SkipUI-view-truncationMode.png)
    ///
    /// - Parameter mode: The truncation mode that specifies where to truncate
    ///   the text within the text view, if needed. You can truncate at the
    ///   beginning, middle, or end of the text view.
    ///
    /// - Returns: A view that truncates text at different points in a line
    ///   depending on the mode you select.
    @inlinable public func truncationMode(_ mode: Text.TruncationMode) -> some View { return never() }


    /// Sets the amount of space between lines of text in this view.
    ///
    /// Use `lineSpacing(_:)` to set the amount of spacing from the bottom of
    /// one line to the top of the next for text elements in the view.
    ///
    /// In the ``Text`` view in the example below, 10 points separate the bottom
    /// of one line to the top of the next as the text field wraps inside this
    /// view. Applying `lineSpacing(_:)` to a view hierarchy applies the line
    /// spacing to all text elements contained in the view.
    ///
    ///     Text("This is a string in a TextField with 10 point spacing applied between the bottom of one line and the top of the next.")
    ///         .frame(width: 200, height: 200, alignment: .leading)
    ///         .lineSpacing(10)
    ///
    /// ![A screenshot showing the effects of setting line spacing on the text
    /// in a view.](SkipUI-view-lineSpacing.png)
    ///
    /// - Parameter lineSpacing: The amount of space between the bottom of one
    ///   line and the top of the next line in points.
    @inlinable public func lineSpacing(_ lineSpacing: CGFloat) -> some View { return never() }


    /// Sets whether text in this view can compress the space between characters
    /// when necessary to fit text in a line.
    ///
    /// Use `allowsTightening(_:)` to enable the compression of inter-character
    /// spacing of text in a view to try to fit the text in the view's bounds.
    ///
    /// In the example below, two identically configured text views show the
    /// effects of `allowsTightening(_:)` on the compression of the spacing
    /// between characters:
    ///
    ///     VStack {
    ///         Text("This is a wide text element")
    ///             .font(.body)
    ///             .frame(width: 200, height: 50, alignment: .leading)
    ///             .lineLimit(1)
    ///             .allowsTightening(true)
    ///
    ///         Text("This is a wide text element")
    ///             .font(.body)
    ///             .frame(width: 200, height: 50, alignment: .leading)
    ///             .lineLimit(1)
    ///             .allowsTightening(false)
    ///     }
    ///
    /// ![A screenshot showing the effect of enabling text tightening in a
    /// view.](SkipUI-view-allowsTightening.png)
    ///
    /// - Parameter flag: A Boolean value that indicates whether the space
    ///   between characters compresses when necessary.
    ///
    /// - Returns: A view that can compress the space between characters when
    ///   necessary to fit text in a line.
    @inlinable public func allowsTightening(_ flag: Bool) -> some View { return never() }


    /// Sets the minimum amount that text in this view scales down to fit in the
    /// available space.
    ///
    /// Use the `minimumScaleFactor(_:)` modifier if the text you place in a
    /// view doesn't fit and it's okay if the text shrinks to accommodate. For
    /// example, a label with a minimum scale factor of `0.5` draws its text in
    /// a font size as small as half of the actual font if needed.
    ///
    /// In the example below, the ``HStack`` contains a ``Text`` label with a
    /// line limit of `1`, that is next to a ``TextField``. To allow the label
    /// to fit into the available space, the `minimumScaleFactor(_:)` modifier
    /// shrinks the text as needed to fit into the available space.
    ///
    ///     HStack {
    ///         Text("This is a long label that will be scaled to fit:")
    ///             .lineLimit(1)
    ///             .minimumScaleFactor(0.5)
    ///         TextField("My Long Text Field", text: $myTextField)
    ///     }
    ///
    /// ![A screenshot showing the effect of setting a minimumScaleFactor on
    /// text in a view.](SkipUI-View-minimumScaleFactor.png)
    ///
    /// - Parameter factor: A fraction between 0 and 1 (inclusive) you use to
    ///   specify the minimum amount of text scaling that this view permits.
    ///
    /// - Returns: A view that limits the amount of text downscaling.
    @inlinable public func minimumScaleFactor(_ factor: CGFloat) -> some View { return never() }


    /// Sets a transform for the case of the text contained in this view when
    /// displayed.
    ///
    /// The default value is `nil`, displaying the text without any case
    /// changes.
    ///
    /// - Parameter textCase: One of the ``Text/Case`` enumerations; the
    ///   default is `nil`.
    /// - Returns: A view that transforms the case of the text.
    @available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
    @inlinable public func textCase(_ textCase: Text.Case?) -> some View { return never() }

}

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension View {

    /// Returns a new view with its inherited symbol image effects
    /// either removed or left unchanged.
    ///
    /// The following example adds a repeating pulse effect to two
    /// symbol images, but then disables the effect on one of them:
    ///
    ///     VStack {
    ///         Image(systemName: "bolt.slash.fill") // does not pulse
    ///             .symbolEffectsRemoved()
    ///         Image(systemName: "folder.fill.badge.person.crop") // pulses
    ///     }
    ///     .symbolEffect(.pulse)
    ///
    /// - Parameter isEnabled: Whether to remove inherited symbol
    ///   effects or not.
    ///
    /// - Returns: a copy of the view with its symbol effects either
    ///   removed or left unchanged.
    public func symbolEffectsRemoved(_ isEnabled: Bool = true) -> some View { return never() }

}

@available(iOS 13.0, macOS 10.15, tvOS 16.0, watchOS 6.0, *)
extension View {

    /// Adds an action to perform when this view recognizes a tap gesture.
    ///
    /// Use this method to perform the specified `action` when the user clicks
    /// or taps on the view or container `count` times.
    ///
    /// > Note: If you create a control that's functionally equivalent
    /// to a ``Button``, use ``ButtonStyle`` to create a customized button
    /// instead.
    ///
    /// In the example below, the color of the heart images changes to a random
    /// color from the `colors` array whenever the user clicks or taps on the
    /// view twice:
    ///
    ///     struct TapGestureExample: View {
    ///         let colors: [Color] = [.gray, .red, .orange, .yellow,
    ///                                .green, .blue, .purple, .pink]
    ///         @State private var fgColor: Color = .gray
    ///
    ///         var body: some View {
    ///             Image(systemName: "heart.fill")
    ///                 .resizable()
    ///                 .frame(width: 200, height: 200)
    ///                 .foregroundColor(fgColor)
    ///                 .onTapGesture(count: 2) {
    ///                     fgColor = colors.randomElement()!
    ///                 }
    ///         }
    ///     }
    ///
    /// ![A screenshot of a view of a heart.](SkipUI-View-TapGesture.png)
    ///
    /// - Parameters:
    ///    - count: The number of taps or clicks required to trigger the action
    ///      closure provided in `action`. Defaults to `1`.
    ///    - action: The action to perform.
    public func onTapGesture(count: Int = 1, perform action: @escaping () -> Void) -> some View { return never() }

}

extension View {

    /// Applies an underline to the text in this view.
    ///
    /// - Parameters:
    ///   - isActive: A Boolean value that indicates whether underline
    ///     is added. The default value is `true`.
    ///   - pattern: The pattern of the line. The default value is `solid`.
    ///   - color: The color of the underline. If `color` is `nil`, the
    ///     underline uses the default foreground color.
    ///
    /// - Returns: A view where text has a line running along its baseline.
    @available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
    public func underline(_ isActive: Bool = true, pattern: Text.LineStyle.Pattern = .solid, color: Color? = nil) -> some View { return never() }


    /// Applies a strikethrough to the text in this view.
    ///
    /// - Parameters:
    ///   - isActive: A Boolean value that indicates whether
    ///     strikethrough is added. The default value is `true`.
    ///   - pattern: The pattern of the line. The default value is `solid`.
    ///   - color: The color of the strikethrough. If `color` is `nil`, the
    ///     strikethrough uses the default foreground color.
    ///
    /// - Returns: A view where text has a line through its center.
    @available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
    public func strikethrough(_ isActive: Bool = true, pattern: Text.LineStyle.Pattern = .solid, color: Color? = nil) -> some View { return never() }

}

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
@available(xrOS, unavailable)
extension View {

    /// Plays the specified `feedback` when the provided `trigger` value
    /// changes.
    ///
    /// For example, you could play feedback when a state value changes:
    ///
    ///     struct MyView: View {
    ///         @State private var showAccessory = false
    ///
    ///         var body: some View {
    ///             ContentView()
    ///                 .sensoryFeedback(.selection, trigger: showAccessory)
    ///                 .onLongPressGesture {
    ///                     showAccessory.toggle()
    ///                 }
    ///
    ///             if showAccessory {
    ///                 AccessoryView()
    ///             }
    ///         }
    ///     }
    ///
    /// - Parameters:
    ///   - feedback: Which type of feedback to play.
    ///   - trigger: A value to monitor for changes to determine when to play.
    public func sensoryFeedback<T>(_ feedback: SensoryFeedback, trigger: T) -> some View where T : Equatable { return never() }


    /// Plays the specified `feedback` when the provided `trigger` value changes
    /// and the `condition` closure returns `true`.
    ///
    /// For example, you could play feedback for certain state transitions:
    ///
    ///     struct MyView: View {
    ///         @State private var phase = Phase.inactive
    ///
    ///         var body: some View {
    ///             ContentView(phase: $phase)
    ///                 .sensoryFeedback(.selection, trigger: phase) { old, new in
    ///                     old == .inactive || new == .expanded
    ///                 }
    ///         }
    ///
    ///         enum Phase {
    ///             case inactive
    ///             case preparing
    ///             case active
    ///             case expanded
    ///         }
    ///     }
    ///
    /// - Parameters:
    ///   - feedback: Which type of feedback to play.
    ///   - trigger: A value to monitor for changes to determine when to play.
    ///   - condition: A closure to determine whether to play the feedback when
    ///     `trigger` changes.
    public func sensoryFeedback<T>(_ feedback: SensoryFeedback, trigger: T, condition: @escaping (_ oldValue: T, _ newValue: T) -> Bool) -> some View where T : Equatable { return never() }


    /// Plays feedback when returned from the `feedback` closure after the
    /// provided `trigger` value changes.
    ///
    /// For example, you could play different feedback for different state
    /// transitions:
    ///
    ///     struct MyView: View {
    ///         @State private var phase = Phase.inactive
    ///
    ///         var body: some View {
    ///             ContentView(phase: $phase)
    ///                 .sensoryFeedback(trigger: phase) { old, new in
    ///                     switch (old, new) {
    ///                         case (.inactive, _): return .success
    ///                         case (_, .expanded): return .impact
    ///                         default: return nil
    ///                     }
    ///                 }
    ///         }
    ///
    ///         enum Phase {
    ///             case inactive
    ///             case preparing
    ///             case active
    ///             case expanded
    ///         }
    ///     }
    ///
    /// - Parameters:
    ///   - trigger: A value to monitor for changes to determine when to play.
    ///   - feedback: A closure to determine whether to play the feedback and
    ///     what type of feedback to play when `trigger` changes.
    public func sensoryFeedback<T>(trigger: T, _ feedback: @escaping (_ oldValue: T, _ newValue: T) -> SensoryFeedback?) -> some View where T : Equatable { return never() }

}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
extension View {

    /// Sets the submit label for this view.
    ///
    ///     Form {
    ///         TextField("Username", $viewModel.username)
    ///             .submitLabel(.continue)
    ///         SecureField("Password", $viewModel.password)
    ///             .submitLabel(.done)
    ///     }
    ///
    /// - Parameter submitLabel: One of the cases specified in ``SubmitLabel``.
    public func submitLabel(_ submitLabel: SubmitLabel) -> some View { return never() }

}

extension View {

    /// Configures the content margin for a provided placement.
    ///
    /// Use this modifier to customize the content margins of different
    /// kinds of views. For example, you can use this modifier to customize
    /// the margins of scrollable views like ``ScrollView``. In the
    /// following example, the scroll view will automatically inset
    /// its content by the safe area plus an additional 20 points
    /// on the leading and trailing edge.
    ///
    ///     ScrollView(.horizontal) {
    ///         // ...
    ///     }
    ///     .contentMargins(.horizontal, 20.0)
    ///
    /// You can provide a ``ContentMarginPlacement`` to target specific
    /// parts of a view to customize. For example, provide a
    /// ``ContentMargingPlacement/scrollContent`` placement to
    /// inset the content of a ``TextEditor`` without affecting the
    /// insets of its scroll indicators.
    ///
    ///     TextEditor(text: $text)
    ///         .contentMargins(.horizontal, 20.0, for: .scrollContent)
    ///
    /// Similarly, you can customize the insets of scroll indicators
    /// separately from scroll content. Consider doing this when applying
    /// a custom clip shape that may clip the indicators.
    ///
    ///     ScrollView {
    ///         // ...
    ///     }
    ///     .clipShape(.rect(cornerRadius: 20.0))
    ///     .contentMargins(10.0, for: .scrollIndicators)
    ///
    /// When applying multiple contentMargins modifiers, modifiers with
    /// the same placement will override modifiers higher up in the view
    /// hierarchy.
    ///
    /// - Parameters:
    ///   - edges: The edges to add the margins to.
    ///   - insets: The amount of margins to add.
    ///   - placement: Where the margins should be added.
    @available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
    public func contentMargins(_ edges: Edge.Set = .all, _ insets: EdgeInsets, for placement: ContentMarginPlacement = .automatic) -> some View { return never() }


    /// Configures the content margin for a provided placement.
    ///
    /// Use this modifier to customize the content margins of different
    /// kinds of views. For example, you can use this modifier to customize
    /// the margins of scrollable views like ``ScrollView``. In the
    /// following example, the scroll view will automatically inset
    /// its content by the safe area plus an additional 20 points
    /// on the leading and trailing edge.
    ///
    ///     ScrollView(.horizontal) {
    ///         // ...
    ///     }
    ///     .contentMargins(.horizontal, 20.0)
    ///
    /// You can provide a ``ContentMarginPlacement`` to target specific
    /// parts of a view to customize. For example, provide a
    /// ``ContentMargingPlacement/scrollContent`` placement to
    /// inset the content of a ``TextEditor`` without affecting the
    /// insets of its scroll indicators.
    ///
    ///     TextEditor(text: $text)
    ///         .contentMargins(.horizontal, 20.0, for: .scrollContent)
    ///
    /// Similarly, you can customize the insets of scroll indicators
    /// separately from scroll content. Consider doing this when applying
    /// a custom clip shape that may clip the indicators.
    ///
    ///     ScrollView {
    ///         // ...
    ///     }
    ///     .clipShape(.rect(cornerRadius: 20.0))
    ///     .contentMargins(10.0, for: .scrollIndicators)
    ///
    /// When applying multiple contentMargins modifiers, modifiers with
    /// the same placement will override modifiers higher up in the view
    /// hierarchy.
    ///
    /// - Parameters:
    ///   - edges: The edges to add the margins to.
    ///   - length: The amount of margins to add.
    ///   - placement: Where the margins should be added.
    @available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
    public func contentMargins(_ edges: Edge.Set = .all, _ length: CGFloat?, for placement: ContentMarginPlacement = .automatic) -> some View { return never() }


    /// Configures the content margin for a provided placement.
    ///
    /// Use this modifier to customize the content margins of different
    /// kinds of views. For example, you can use this modifier to customize
    /// the margins of scrollable views like ``ScrollView``. In the
    /// following example, the scroll view will automatically inset
    /// its content by the safe area plus an additional 20 points
    /// on the leading and trailing edge.
    ///
    ///     ScrollView(.horizontal) {
    ///         // ...
    ///     }
    ///     .contentMargins(.horizontal, 20.0)
    ///
    /// You can provide a ``ContentMarginPlacement`` to target specific
    /// parts of a view to customize. For example, provide a
    /// ``ContentMargingPlacement/scrollContent`` placement to
    /// inset the content of a ``TextEditor`` without affecting the
    /// insets of its scroll indicators.
    ///
    ///     TextEditor(text: $text)
    ///         .contentMargins(.horizontal, 20.0, for: .scrollContent)
    ///
    /// Similarly, you can customize the insets of scroll indicators
    /// separately from scroll content. Consider doing this when applying
    /// a custom clip shape that may clip the indicators.
    ///
    ///     ScrollView {
    ///         // ...
    ///     }
    ///     .clipShape(.rect(cornerRadius: 20.0))
    ///     .contentMargins(10.0, for: .scrollIndicators)
    ///
    /// When applying multiple contentMargins modifiers, modifiers with
    /// the same placement will override modifiers higher up in the view
    /// hierarchy.
    ///
    /// - Parameters:
    ///   - length: The amount of margins to add on all edges.
    ///   - placement: Where the margins should be added.
    @available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
    public func contentMargins(_ length: CGFloat, for placement: ContentMarginPlacement = .automatic) -> some View { return never() }

}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
extension View {

    /// Marks this view as searchable, which configures the display of a
    /// search field.
    ///
    /// For more information about using searchable modifiers, see
    /// <doc:Adding-a-search-interface-to-your-app>.
    ///
    /// - Parameters:
    ///   - text: The text to display and edit in the search field.
    ///   - placement: The preferred placement of the search field within the
    ///     containing view hierarchy.
    ///   - prompt: A ``Text`` view representing the prompt of the search field
    ///     which provides users with guidance on what to search for.
    public func searchable(text: Binding<String>, placement: SearchFieldPlacement = .automatic, prompt: Text? = nil) -> some View { return never() }


    /// Marks this view as searchable, which configures the display of a
    /// search field.
    ///
    /// For more information about using searchable modifiers, see
    /// <doc:Adding-a-search-interface-to-your-app>.
    ///
    /// - Parameters:
    ///   - text: The text to display and edit in the search field.
    ///   - placement: The preferred placement of the search field within the
    ///     containing view hierarchy.
    ///   - prompt: The key for the localized prompt of the search field
    ///     which provides users with guidance on what to search for.
    public func searchable(text: Binding<String>, placement: SearchFieldPlacement = .automatic, prompt: LocalizedStringKey) -> some View { return never() }


    /// Marks this view as searchable, which configures the display of a
    /// search field.
    ///
    /// For more information about using searchable modifiers, see
    /// <doc:Adding-a-search-interface-to-your-app>.
    ///
    /// - Parameters:
    ///   - text: The text to display and edit in the search field.
    ///   - placement: The preferred placement of the search field within the
    ///     containing view hierarchy.
    ///   - prompt: A string representing the prompt of the search field
    ///     which provides users with guidance on what to search for.
    public func searchable<S>(text: Binding<String>, placement: SearchFieldPlacement = .automatic, prompt: S) -> some View where S : StringProtocol { return never() }

}

extension View {

    /// Marks this view as searchable with programmatic presentation of the
    /// search field.
    ///
    /// For more information about using searchable modifiers, see
    /// <doc:Adding-a-search-interface-to-your-app>.
    /// For information about presenting a search field programmatically, see
    /// <doc:Managing-search-interface-activation>.
    ///
    /// - Parameters:
    ///   - text: The text to display and edit in the search field.
    ///   - isPresenting: A ``Binding`` that controls the presented state
    ///     of search.
    ///   - placement: The preferred placement of the search field within the
    ///     containing view hierarchy.
    ///   - prompt: A ``Text`` view representing the prompt of the search field
    ///     which provides users with guidance on what to search for.
    @available(iOS 17.0, macOS 14.0, *)
    @available(tvOS, unavailable)
    @available(watchOS, unavailable)
    public func searchable(text: Binding<String>, isPresented: Binding<Bool>, placement: SearchFieldPlacement = .automatic, prompt: Text? = nil) -> some View { return never() }


    /// Marks this view as searchable with programmatic presentation of the
    /// search field.
    ///
    /// For more information about using searchable modifiers, see
    /// <doc:Adding-a-search-interface-to-your-app>.
    /// For information about presenting a search field programmatically, see
    /// <doc:Managing-search-interface-activation>.
    ///
    /// - Parameters:
    ///   - text: The text to display and edit in the search field.
    ///   - isPresenting: A ``Binding`` that controls the presented state
    ///     of search.
    ///   - placement: The preferred placement of the search field within the
    ///     containing view hierarchy.
    ///   - prompt: The key for the localized prompt of the search field
    ///     which provides users with guidance on what to search for.
    @available(iOS 17.0, macOS 14.0, *)
    @available(tvOS, unavailable)
    @available(watchOS, unavailable)
    public func searchable(text: Binding<String>, isPresented: Binding<Bool>, placement: SearchFieldPlacement = .automatic, prompt: LocalizedStringKey) -> some View { return never() }


    /// Marks this view as searchable with programmatic presentation of the
    /// search field.
    ///
    /// For more information about using searchable modifiers, see
    /// <doc:Adding-a-search-interface-to-your-app>.
    /// For information about presenting a search field programmatically, see
    /// <doc:Managing-search-interface-activation>.
    ///
    /// - Parameters:
    ///   - text: The text to display and edit in the search field.
    ///   - isPresenting: A ``Binding`` that controls the presented state
    ///     of search.
    ///   - placement: The preferred placement of the search field within the
    ///     containing view hierarchy.
    ///   - prompt: A string representing the prompt of the search field
    ///     which provides users with guidance on what to search for.
    @available(iOS 17.0, macOS 14.0, *)
    @available(tvOS, unavailable)
    @available(watchOS, unavailable)
    public func searchable<S>(text: Binding<String>, isPresented: Binding<Bool>, placement: SearchFieldPlacement = .automatic, prompt: S) -> some View where S : StringProtocol { return never() }

}

@available(iOS 16.4, macOS 13.3, tvOS 16.4, watchOS 9.4, *)
extension View {

    /// Sets the presentation background of the enclosing sheet using a shape
    /// style.
    ///
    /// The following example uses the ``Material/thick`` material as the sheet
    /// background:
    ///
    ///     struct ContentView: View {
    ///         @State private var showSettings = false
    ///
    ///         var body: some View {
    ///             Button("View Settings") {
    ///                 showSettings = true
    ///             }
    ///             .sheet(isPresented: $showSettings) {
    ///                 SettingsView()
    ///                     .presentationBackground(.thickMaterial)
    ///             }
    ///         }
    ///     }
    ///
    /// The `presentationBackground(_:)` modifier differs from the
    /// ``View/background(_:ignoresSafeAreaEdges:)`` modifier in several key
    /// ways. A presentation background:
    ///
    /// * Automatically fills the entire presentation.
    /// * Allows views behind the presentation to show through translucent
    ///   styles.
    ///
    /// - Parameter style: The shape style to use as the presentation
    ///   background.
    public func presentationBackground<S>(_ style: S) -> some View where S : ShapeStyle { return never() }


    /// Sets the presentation background of the enclosing sheet to a custom
    /// view.
    ///
    /// The following example uses a yellow view as the sheet background:
    ///
    ///     struct ContentView: View {
    ///         @State private var showSettings = false
    ///
    ///         var body: some View {
    ///             Button("View Settings") {
    ///                 showSettings = true
    ///             }
    ///             .sheet(isPresented: $showSettings) {
    ///                 SettingsView()
    ///                     .presentationBackground {
    ///                         Color.yellow
    ///                     }
    ///             }
    ///         }
    ///     }
    ///
    /// The `presentationBackground(alignment:content:)` modifier differs from
    /// the ``View/background(alignment:content:)`` modifier in several key
    /// ways. A presentation background:
    ///
    /// * Automatically fills the entire presentation.
    /// * Allows views behind the presentation to show through translucent
    ///   areas of the `content`.
    ///
    /// - Parameters:
    ///   - alignment: The alignment that the modifier uses to position the
    ///     implicit ``ZStack`` that groups the background views. The default is
    ///     ``Alignment/center``.
    ///   - content: The view to use as the background of the presentation.
    public func presentationBackground<V>(alignment: Alignment = .center, @ViewBuilder content: () -> V) -> some View where V : View { return never() }

}

@available(iOS 15.0, macOS 10.15, watchOS 9.0, *)
@available(tvOS, unavailable)
extension View {

    /// Sets the size for controls within this view.
    ///
    /// Use `controlSize(_:)` to override the system default size for controls
    /// in this view. In this example, a view displays several typical controls
    /// at `.mini`, `.small` and `.regular` sizes.
    ///
    ///     struct ControlSize: View {
    ///         var body: some View {
    ///             VStack {
    ///                 MyControls(label: "Mini")
    ///                     .controlSize(.mini)
    ///                 MyControls(label: "Small")
    ///                     .controlSize(.small)
    ///                 MyControls(label: "Regular")
    ///                     .controlSize(.regular)
    ///             }
    ///             .padding()
    ///             .frame(width: 450)
    ///             .border(Color.gray)
    ///         }
    ///     }
    ///
    ///     struct MyControls: View {
    ///         var label: String
    ///         @State private var value = 3.0
    ///         @State private var selected = 1
    ///         var body: some View {
    ///             HStack {
    ///                 Text(label + ":")
    ///                 Picker("Selection", selection: $selected) {
    ///                     Text("option 1").tag(1)
    ///                     Text("option 2").tag(2)
    ///                     Text("option 3").tag(3)
    ///                 }
    ///                 Slider(value: $value, in: 1...10)
    ///                 Button("OK") { }
    ///             }
    ///         }
    ///     }
    ///
    /// ![A screenshot showing several controls of various
    /// sizes.](SkipUI-View-controlSize.png)
    ///
    /// - Parameter controlSize: One of the control sizes specified in the
    ///   ``ControlSize`` enumeration.
    @available(tvOS, unavailable)
    @inlinable public func controlSize(_ controlSize: ControlSize) -> some View { return never() }

}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension View {

    /// Applies an inset to the rows in a list.
    ///
    /// Use `listRowInsets(_:)` to change the default padding of the content of
    /// list items.
    ///
    /// In the example below, the `Flavor` enumeration provides content for list
    /// items. The SkipUI ``ForEach`` structure computes views for each element
    /// of the `Flavor` enumeration and extracts the raw value of each of its
    /// elements using the resulting text to create each list row item. The
    /// `listRowInsets(_:)` modifier then changes the edge insets of each row
    /// of the list according to the ``EdgeInsets`` provided:
    ///
    ///     struct ContentView: View {
    ///         enum Flavor: String, CaseIterable, Identifiable {
    ///             var id: String { self.rawValue }
    ///             case vanilla, chocolate, strawberry
    ///         }
    ///
    ///         var body: some View {
    ///             List {
    ///                 ForEach(Flavor.allCases) {
    ///                     Text($0.rawValue)
    ///                         .listRowInsets(.init(top: 0,
    ///                                              leading: 25,
    ///                                              bottom: 0,
    ///                                              trailing: 0))
    ///                 }
    ///             }
    ///         }
    ///     }
    ///
    /// ![A screenshot showing a list with leading 25 point inset on each
    ///  row.](SkipUI-View-ListRowInsets.png)
    ///
    /// - Parameter insets: The ``EdgeInsets`` to apply to the edges of the
    ///   view.
    /// - Returns: A view that uses the given edge insets when used as a list
    ///   cell.
    @inlinable public func listRowInsets(_ insets: EdgeInsets?) -> some View { return never() }

}

@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
extension View {

    /// The activation point for an element is the location
    /// assistive technologies use to initiate gestures.
    ///
    /// Use this modifier to ensure that the activation point for a
    /// small element remains accurate even if you present a larger
    /// version of the element to VoiceOver.
    ///
    /// If an activation point is not provided, an activation point
    /// will be derrived from one of the accessibility elements
    /// decendents or from the center of the accessibility frame.
    public func accessibilityActivationPoint(_ activationPoint: CGPoint) -> ModifiedContent<Self, AccessibilityAttachmentModifier> { fatalError() }

    /// The activation point for an element is the location
    /// assistive technologies use to initiate gestures.
    ///
    /// Use this modifier to ensure that the activation point for a
    /// small element remains accurate even if you present a larger
    /// version of the element to VoiceOver.
    ///
    /// If an activation point is not provided, an activation point
    /// will be derrived from one of the accessibility elements
    /// decendents or from the center of the accessibility frame.
    public func accessibilityActivationPoint(_ activationPoint: UnitPoint) -> ModifiedContent<Self, AccessibilityAttachmentModifier> { fatalError() }
}

@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
extension View {

    /// Modifies the view to use a given transition as its method of animating
    /// changes to the contents of its views.
    ///
    /// This modifier allows you to perform a transition that animates a change
    /// within a single view. The provided ``ContentTransition`` can present an
    /// opacity animation for content changes, an interpolated animation of
    /// the content's paths as they change, or perform no animation at all.
    ///
    /// > Tip: The `contentTransition(_:)` modifier only has an effect within
    /// the context of an ``Animation``.
    ///
    /// In the following example, a ``Button`` changes the color and font size
    /// of a ``Text`` view. Since both of these properties apply to the paths of
    /// the text, the ``ContentTransition/interpolate`` transition can animate a
    /// gradual change to these properties through the entire transition. By
    /// contrast, the ``ContentTransition/opacity`` transition would simply fade
    /// between the start and end states.
    ///
    ///     private static let font1 = Font.system(size: 20)
    ///     private static let font2 = Font.system(size: 45)
    ///
    ///     @State private var color = Color.red
    ///     @State private var currentFont = font1
    ///
    ///     var body: some View {
    ///         VStack {
    ///             Text("Content transition")
    ///                 .foregroundColor(color)
    ///                 .font(currentFont)
    ///                 .contentTransition(.interpolate)
    ///             Spacer()
    ///             Button("Change") {
    ///                 withAnimation(Animation.easeInOut(duration: 5.0)) {
    ///                     color = (color == .red) ? .green : .red
    ///                     currentFont = (currentFont == font1) ? font2 : font1
    ///                 }
    ///             }
    ///         }
    ///     }
    ///
    /// This example uses an ease-in–ease-out animation with a five-second
    /// duration to make it easier to see the effect of the interpolation. The
    /// figure below shows the `Text` at the beginning of the animation,
    /// halfway through, and at the end.
    ///
    /// | Time    | Display |
    /// | ------- | ------- |
    /// | Start   | ![The text Content transition in a small red font.](ContentTransition-1) |
    /// | Middle  | ![The text Content transition in a medium brown font.](ContentTransition-2) |
    /// | End     | ![The text Content transition in a large green font.](ContentTransition-3) |
    ///
    /// To control whether content transitions use GPU-accelerated rendering,
    /// set the value of the
    /// ``EnvironmentValues/contentTransitionAddsDrawingGroup`` environment
    /// variable.
    ///
    /// - parameter transition: The transition to apply when animating the
    ///   content change.
    public func contentTransition(_ transition: ContentTransition) -> some View { return never() }

}

extension View {

    /// Marks this view as searchable with text and tokens.
    ///
    /// For more information about using searchable modifiers, see
    /// <doc:Adding-a-search-interface-to-your-app>.
    ///
    /// - Parameters:
    ///   - text: The text to display and edit in the search field.
    ///   - tokens: A collection of tokens to display and edit in the
    ///     search field.
    ///   - placement: The preferred placement of the search field within the
    ///     containing view hierarchy.
    ///   - prompt: A ``Text`` view representing the prompt of the search field
    ///     which provides users with guidance on what to search for.
    ///   - token: A view builder that creates a view given an element in
    ///     tokens.
    @available(iOS 16.0, macOS 13.0, *)
    @available(tvOS, unavailable)
    @available(watchOS, unavailable)
    public func searchable<C, T>(text: Binding<String>, tokens: Binding<C>, placement: SearchFieldPlacement = .automatic, prompt: Text? = nil, @ViewBuilder token: @escaping (C.Element) -> T) -> some View where C : RandomAccessCollection, C : RangeReplaceableCollection, T : View, C.Element : Identifiable { return never() }


    /// Marks this view as searchable, which configures the display of a
    /// search field.
    ///
    /// For more information about using searchable modifiers, see
    /// <doc:Adding-a-search-interface-to-your-app>.
    ///
    /// - Parameters:
    ///   - text: The text to display and edit in the search field.
    ///   - editableTokens: A collection of tokens to display and edit in the
    ///     search field.
    ///   - placement: The preferred placement of the search field within the
    ///     containing view hierarchy.
    ///   - prompt: A ``Text`` view representing the prompt of the search field
    ///     which provides users with guidance on what to search for.
    ///   - token: A view builder that creates a view given an element in
    ///     tokens.
    @available(iOS 17.0, macOS 14.0, *)
    @available(tvOS, unavailable)
    @available(watchOS, unavailable)
    public func searchable<C>(text: Binding<String>, editableTokens: Binding<C>, placement: SearchFieldPlacement = .automatic, prompt: Text? = nil, @ViewBuilder token: @escaping (Binding<C.Element>) -> some View) -> some View where C : RandomAccessCollection, C : RangeReplaceableCollection, C.Element : Identifiable { return never() }


    /// Marks this view as searchable with text and tokens.
    ///
    /// For more information about using searchable modifiers, see
    /// <doc:Adding-a-search-interface-to-your-app>.
    ///
    /// - Parameters:
    ///   - text: The text to display and edit in the search field.
    ///   - tokens: A collection of tokens to display and edit in the
    ///     search field.
    ///   - placement: The preferred placement of the search field within the
    ///     containing view hierarchy.
    ///   - prompt: The key for the localized prompt of the search field
    ///     which provides users with guidance on what to search for.
    ///   - token: A view builder that creates a view given an element in
    ///     tokens.
    @available(iOS 16.0, macOS 13.0, *)
    @available(tvOS, unavailable)
    @available(watchOS, unavailable)
    public func searchable<C, T>(text: Binding<String>, tokens: Binding<C>, placement: SearchFieldPlacement = .automatic, prompt: LocalizedStringKey, @ViewBuilder token: @escaping (C.Element) -> T) -> some View where C : RandomAccessCollection, C : RangeReplaceableCollection, T : View, C.Element : Identifiable { return never() }


    /// Marks this view as searchable, which configures the display of a
    /// search field.
    ///
    /// For more information about using searchable modifiers, see
    /// <doc:Adding-a-search-interface-to-your-app>.
    ///
    /// - Parameters:
    ///   - text: The text to display and edit in the search field.
    ///   - editableTokens: A collection of tokens to display and edit in the
    ///     search field.
    ///   - placement: The preferred placement of the search field within the
    ///     containing view hierarchy.
    ///   - prompt: The key for the localized prompt of the search field
    ///     which provides users with guidance on what to search for.
    ///   - token: A view builder that creates a view given an element in
    ///     tokens.
    @available(iOS 17.0, macOS 14.0, *)
    @available(tvOS, unavailable)
    @available(watchOS, unavailable)
    public func searchable<C>(text: Binding<String>, editableTokens: Binding<C>, placement: SearchFieldPlacement = .automatic, prompt: LocalizedStringKey, @ViewBuilder token: @escaping (Binding<C.Element>) -> some View) -> some View where C : RandomAccessCollection, C : RangeReplaceableCollection, C.Element : Identifiable { return never() }


    /// Marks this view as searchable with text and tokens.
    ///
    /// For more information about using searchable modifiers, see
    /// <doc:Adding-a-search-interface-to-your-app>.
    ///
    /// - Parameters:
    ///   - text: The text to display and edit in the search field.
    ///   - tokens: A collection of tokens to display and edit in the
    ///     search field.
    ///   - placement: The preferred placement of the search field within the
    ///     containing view hierarchy.
    ///   - prompt: A string representing the prompt of the search field
    ///     which provides users with guidance on what to search for.
    ///   - token: A view builder that creates a view given an element in
    ///     tokens.
    @available(iOS 16.0, macOS 13.0, *)
    @available(tvOS, unavailable)
    @available(watchOS, unavailable)
    public func searchable<C, T, S>(text: Binding<String>, tokens: Binding<C>, placement: SearchFieldPlacement = .automatic, prompt: S, @ViewBuilder token: @escaping (C.Element) -> T) -> some View where C : RandomAccessCollection, C : RangeReplaceableCollection, T : View, S : StringProtocol, C.Element : Identifiable { return never() }


    /// Marks this view as searchable, which configures the display of a
    /// search field.
    ///
    /// For more information about using searchable modifiers, see
    /// <doc:Adding-a-search-interface-to-your-app>.
    ///
    /// - Parameters:
    ///   - text: The text to display and edit in the search field.
    ///   - editableTokens: A collection of tokens to display and edit in the
    ///     search field.
    ///   - placement: The preferred placement of the search field within the
    ///     containing view hierarchy.
    ///   - prompt: A string representing the prompt of the search field
    ///     which provides users with guidance on what to search for.
    ///   - token: A view builder that creates a view given an element in
    ///     tokens.
    @available(iOS 17.0, macOS 14.0, *)
    @available(tvOS, unavailable)
    @available(watchOS, unavailable)
    public func searchable<C>(text: Binding<String>, editableTokens: Binding<C>, placement: SearchFieldPlacement = .automatic, prompt: some StringProtocol, @ViewBuilder token: @escaping (Binding<C.Element>) -> some View) -> some View where C : RandomAccessCollection, C : RangeReplaceableCollection, C.Element : Identifiable { return never() }

}

extension View {

    /// Marks this view as searchable with text and tokens, as well as
    /// programmatic presentation.
    ///
    /// For more information about using searchable modifiers, see
    /// <doc:Adding-a-search-interface-to-your-app>.
    /// For information about presenting a search field programmatically, see
    /// <doc:Managing-search-interface-activation>.
    ///
    /// - Parameters:
    ///   - text: The text to display and edit in the search field.
    ///   - tokens: A collection of tokens to display and edit in the
    ///     search field.
    ///   - isPresenting: A ``Binding`` that controls the presented state
    ///     of search.
    ///   - placement: The preferred placement of the search field within the
    ///     containing view hierarchy.
    ///   - prompt: A ``Text`` view representing the prompt of the search field
    ///     which provides users with guidance on what to search for.
    ///   - token: A view builder that creates a view given an element in
    ///     tokens.
    @available(iOS 17.0, macOS 14.0, *)
    @available(tvOS, unavailable)
    @available(watchOS, unavailable)
    public func searchable<C, T>(text: Binding<String>, tokens: Binding<C>, isPresented: Binding<Bool>, placement: SearchFieldPlacement = .automatic, prompt: Text? = nil, @ViewBuilder token: @escaping (C.Element) -> T) -> some View where C : RandomAccessCollection, C : RangeReplaceableCollection, T : View, C.Element : Identifiable { return never() }


    /// Marks this view as searchable, which configures the display of a
    /// search field.
    ///
    /// For more information about using searchable modifiers, see
    /// <doc:Adding-a-search-interface-to-your-app>.
    ///
    /// - Parameters:
    ///   - text: The text to display and edit in the search field.
    ///   - editableTokens: A collection of tokens to display and edit in the
    ///     search field.
    ///   - isPresenting: A ``Binding`` which controls the presented state
    ///     of search.
    ///   - placement: The preferred placement of the search field within the
    ///     containing view hierarchy.
    ///   - prompt: A ``Text`` view representing the prompt of the search field
    ///     which provides users with guidance on what to search for.
    ///   - token: A view builder that creates a view given an element in
    ///     tokens.
    @available(iOS 17.0, macOS 14.0, *)
    @available(tvOS, unavailable)
    @available(watchOS, unavailable)
    public func searchable<C>(text: Binding<String>, editableTokens: Binding<C>, isPresented: Binding<Bool>, placement: SearchFieldPlacement = .automatic, prompt: Text? = nil, @ViewBuilder token: @escaping (Binding<C.Element>) -> some View) -> some View where C : RandomAccessCollection, C : RangeReplaceableCollection, C.Element : Identifiable { return never() }


    /// Marks this view as searchable with text and tokens, as well as
    /// programmatic presentation.
    ///
    /// For more information about using searchable modifiers, see
    /// <doc:Adding-a-search-interface-to-your-app>.
    /// For information about presenting a search field programmatically, see
    /// <doc:Managing-search-interface-activation>.
    ///
    /// - Parameters:
    ///   - text: The text to display and edit in the search field.
    ///   - tokens: A collection of tokens to display and edit in the
    ///     search field.
    ///   - isPresenting: A ``Binding`` that controls the presented state
    ///     of search.
    ///   - placement: The preferred placement of the search field within the
    ///     containing view hierarchy.
    ///   - prompt: The key for the localized prompt of the search field
    ///     which provides users with guidance on what to search for.
    ///   - token: A view builder that creates a view given an element in
    ///     tokens.
    @available(iOS 17.0, macOS 14.0, *)
    @available(tvOS, unavailable)
    @available(watchOS, unavailable)
    public func searchable<C, T>(text: Binding<String>, tokens: Binding<C>, isPresented: Binding<Bool>, placement: SearchFieldPlacement = .automatic, prompt: LocalizedStringKey, @ViewBuilder token: @escaping (C.Element) -> T) -> some View where C : RandomAccessCollection, C : RangeReplaceableCollection, T : View, C.Element : Identifiable { return never() }


    /// Marks this view as searchable, which configures the display of a
    /// search field.
    ///
    /// For more information about using searchable modifiers, see
    /// <doc:Adding-a-search-interface-to-your-app>.
    ///
    /// - Parameters:
    ///   - text: The text to display and edit in the search field.
    ///   - editableTokens: A collection of tokens to display and edit in the
    ///     search field.
    ///   - isPresenting: A ``Binding`` which controls the presented state
    ///     of search.
    ///   - placement: The preferred placement of the search field within the
    ///     containing view hierarchy.
    ///   - prompt: The key for the localized prompt of the search field
    ///     which provides users with guidance on what to search for.
    ///   - token: A view builder that creates a view given an element in
    ///     tokens.
    @available(iOS 17.0, macOS 14.0, *)
    @available(tvOS, unavailable)
    @available(watchOS, unavailable)
    public func searchable<C>(text: Binding<String>, editableTokens: Binding<C>, isPresented: Binding<Bool>, placement: SearchFieldPlacement = .automatic, prompt: LocalizedStringKey, @ViewBuilder token: @escaping (Binding<C.Element>) -> some View) -> some View where C : RandomAccessCollection, C : RangeReplaceableCollection, C.Element : Identifiable { return never() }


    /// Marks this view as searchable with text and tokens, as well as
    /// programmatic presentation.
    ///
    /// For more information about using searchable modifiers, see
    /// <doc:Adding-a-search-interface-to-your-app>.
    /// For information about presenting a search field programmatically, see
    /// <doc:Managing-search-interface-activation>.
    ///
    /// - Parameters:
    ///   - text: The text to display and edit in the search field.
    ///   - tokens: A collection of tokens to display and edit in the
    ///     search field.
    ///   - isPresenting: A ``Binding`` that controls the presented state
    ///     of search.
    ///   - placement: The preferred placement of the search field within the
    ///     containing view hierarchy.
    ///   - prompt: A string representing the prompt of the search field
    ///     which provides users with guidance on what to search for.
    ///   - token: A view builder that creates a view given an element in
    ///     tokens.
    @available(iOS 17.0, macOS 14.0, *)
    @available(tvOS, unavailable)
    @available(watchOS, unavailable)
    public func searchable<C, T, S>(text: Binding<String>, tokens: Binding<C>, isPresented: Binding<Bool>, placement: SearchFieldPlacement = .automatic, prompt: S, @ViewBuilder token: @escaping (C.Element) -> T) -> some View where C : RandomAccessCollection, C : RangeReplaceableCollection, T : View, S : StringProtocol, C.Element : Identifiable { return never() }


    /// Marks this view as searchable, which configures the display of a
    /// search field.
    ///
    /// For more information about using searchable modifiers, see
    /// <doc:Adding-a-search-interface-to-your-app>.
    ///
    /// - Parameters:
    ///   - text: The text to display and edit in the search field.
    ///   - editableTokens: A collection of tokens to display and edit in the
    ///     search field.
    ///   - isPresenting: A ``Binding`` which controls the presented state
    ///     of search.
    ///   - placement: The preferred placement of the search field within the
    ///     containing view hierarchy.
    ///   - prompt: A string representing the prompt of the search field
    ///     which provides users with guidance on what to search for.
    ///   - token: A view builder that creates a view given an element in
    ///     tokens.
    @available(iOS 17.0, macOS 14.0, *)
    @available(tvOS, unavailable)
    @available(watchOS, unavailable)
    public func searchable<C>(text: Binding<String>, editableTokens: Binding<C>, isPresented: Binding<Bool>, placement: SearchFieldPlacement = .automatic, prompt: some StringProtocol, @ViewBuilder token: @escaping (Binding<C.Element>) -> some View) -> some View where C : RandomAccessCollection, C : RangeReplaceableCollection, C.Element : Identifiable { return never() }

}

extension View {

    /// Marks this view as searchable with text, tokens, and suggestions.
    ///
    /// For more information about using searchable modifiers, see
    /// <doc:Adding-a-search-interface-to-your-app>.
    ///
    /// - Parameters:
    ///   - text: The text to display and edit in the search field.
    ///   - tokens: A collection of tokens to display and edit in the
    ///     search field.
    ///   - suggestedTokens: A collection of tokens to display as suggestions.
    ///   - placement: The preferred placement of the search field within the
    ///     containing view hierarchy.
    ///   - prompt: A ``Text`` view representing the prompt of the search field
    ///     which provides users with guidance on what to search for.
    ///   - token: A view builder that creates a view given an element in
    ///     tokens.
    @available(iOS 16.0, macOS 13.0, *)
    @available(tvOS, unavailable)
    @available(watchOS, unavailable)
    public func searchable<C, T>(text: Binding<String>, tokens: Binding<C>, suggestedTokens: Binding<C>, placement: SearchFieldPlacement = .automatic, prompt: Text? = nil, @ViewBuilder token: @escaping (C.Element) -> T) -> some View where C : MutableCollection, C : RandomAccessCollection, C : RangeReplaceableCollection, T : View, C.Element : Identifiable { return never() }


    /// Marks this view as searchable with text, tokens, and suggestions.
    ///
    /// For more information about using searchable modifiers, see
    /// <doc:Adding-a-search-interface-to-your-app>.
    ///
    /// - Parameters:
    ///   - text: The text to display and edit in the search field.
    ///   - tokens: A collection of tokens to display and edit in the
    ///     search field.
    ///   - suggestedTokens: A collection of tokens to display as suggestions.
    ///   - placement: The preferred placement of the search field within the
    ///     containing view hierarchy.
    ///   - prompt: The key for the localized prompt of the search field
    ///     which provides users with guidance on what to search for.
    ///   - token: A view builder that creates a view given an element in
    ///     tokens.
    @available(iOS 16.0, macOS 13.0, *)
    @available(tvOS, unavailable)
    @available(watchOS, unavailable)
    public func searchable<C, T>(text: Binding<String>, tokens: Binding<C>, suggestedTokens: Binding<C>, placement: SearchFieldPlacement = .automatic, prompt: LocalizedStringKey, @ViewBuilder token: @escaping (C.Element) -> T) -> some View where C : MutableCollection, C : RandomAccessCollection, C : RangeReplaceableCollection, T : View, C.Element : Identifiable { return never() }


    /// Marks this view as searchable with text, tokens, and suggestions.
    ///
    /// For more information about using searchable modifiers, see
    /// <doc:Adding-a-search-interface-to-your-app>.
    ///
    /// - Parameters:
    ///   - text: The text to display and edit in the search field.
    ///   - tokens: A collection of tokens to display and edit in the
    ///     search field.
    ///   - suggestedTokens: A collection of tokens to display as suggestions.
    ///   - placement: The preferred placement of the search field within the
    ///     containing view hierarchy.
    ///   - prompt: A string representing the prompt of the search field
    ///     which provides users with guidance on what to search for.
    ///   - token: A view builder that creates a view given an element in
    ///     tokens.
    @available(iOS 16.0, macOS 13.0, *)
    @available(tvOS, unavailable)
    @available(watchOS, unavailable)
    public func searchable<C, T, S>(text: Binding<String>, tokens: Binding<C>, suggestedTokens: Binding<C>, placement: SearchFieldPlacement = .automatic, prompt: S, @ViewBuilder token: @escaping (C.Element) -> T) -> some View where C : MutableCollection, C : RandomAccessCollection, C : RangeReplaceableCollection, T : View, S : StringProtocol, C.Element : Identifiable { return never() }


    /// Marks this view as searchable with text, tokens, and suggestions, as
    /// well as programmatic presentation.
    ///
    /// For more information about using searchable modifiers, see
    /// <doc:Adding-a-search-interface-to-your-app>.
    /// For information about presenting a search field programmatically, see
    /// <doc:Managing-search-interface-activation>.
    ///
    /// - Parameters:
    ///   - text: The text to display and edit in the search field.
    ///   - tokens: A collection of tokens to display and edit in the
    ///     search field.
    ///   - suggestedTokens: A collection of tokens to display as suggestions.
    ///   - isPresenting: A ``Binding`` that controls the presented state
    ///     of search.
    ///   - placement: The preferred placement of the search field within the
    ///     containing view hierarchy.
    ///   - prompt: A ``Text`` view representing the prompt of the search field
    ///     which provides users with guidance on what to search for.
    ///   - token: A view builder that creates a view given an element in
    ///     tokens.
    @available(iOS 17.0, macOS 14.0, *)
    @available(tvOS, unavailable)
    @available(watchOS, unavailable)
    public func searchable<C, T>(text: Binding<String>, tokens: Binding<C>, suggestedTokens: Binding<C>, isPresented: Binding<Bool>, placement: SearchFieldPlacement = .automatic, prompt: Text? = nil, @ViewBuilder token: @escaping (C.Element) -> T) -> some View where C : RandomAccessCollection, C : RangeReplaceableCollection, T : View, C.Element : Identifiable { return never() }


    /// Marks this view as searchable with text, tokens, and suggestions, as
    /// well as programmatic presentation.
    ///
    /// For more information about using searchable modifiers, see
    /// <doc:Adding-a-search-interface-to-your-app>.
    /// For information about presenting a search field programmatically, see
    /// <doc:Managing-search-interface-activation>.
    ///
    /// - Parameters:
    ///   - text: The text to display and edit in the search field.
    ///   - tokens: A collection of tokens to display and edit in the
    ///     search field.
    ///   - suggestedTokens: A collection of tokens to display as suggestions.
    ///   - isPresenting: A ``Binding`` that controls the presented state
    ///     of search.
    ///   - placement: The preferred placement of the search field within the
    ///     containing view hierarchy.
    ///   - prompt: The key for the localized prompt of the search field
    ///     which provides users with guidance on what to search for.
    ///   - token: A view builder that creates a view given an element in
    ///     tokens.
    @available(iOS 17.0, macOS 14.0, *)
    @available(tvOS, unavailable)
    @available(watchOS, unavailable)
    public func searchable<C, T>(text: Binding<String>, tokens: Binding<C>, suggestedTokens: Binding<C>, isPresented: Binding<Bool>, placement: SearchFieldPlacement = .automatic, prompt: LocalizedStringKey, @ViewBuilder token: @escaping (C.Element) -> T) -> some View where C : RandomAccessCollection, C : RangeReplaceableCollection, T : View, C.Element : Identifiable { return never() }


    /// Marks this view as searchable with text, tokens, and suggestions, as
    /// well as programmatic presentation.
    ///
    /// For more information about using searchable modifiers, see
    /// <doc:Adding-a-search-interface-to-your-app>.
    /// For information about presenting a search field programmatically, see
    /// <doc:Managing-search-interface-activation>.
    ///
    /// - Parameters:
    ///   - text: The text to display and edit in the search field.
    ///   - tokens: A collection of tokens to display and edit in the
    ///     search field.
    ///   - suggestedTokens: A collection of tokens to display as suggestions.
    ///   - isPresenting: A ``Binding`` that controls the presented state
    ///     of search.
    ///   - placement: The preferred placement of the search field within the
    ///     containing view hierarchy.
    ///   - prompt: A string representing the prompt of the search field
    ///     which provides users with guidance on what to search for.
    ///   - token: A view builder that creates a view given an element in
    ///     tokens.
    @available(iOS 17.0, macOS 14.0, *)
    @available(tvOS, unavailable)
    @available(watchOS, unavailable)
    public func searchable<C, T, S>(text: Binding<String>, tokens: Binding<C>, suggestedTokens: Binding<C>, isPresented: Binding<Bool>, placement: SearchFieldPlacement = .automatic, prompt: S, @ViewBuilder token: @escaping (C.Element) -> T) -> some View where C : MutableCollection, C : RandomAccessCollection, C : RangeReplaceableCollection, T : View, S : StringProtocol, C.Element : Identifiable { return never() }

}

@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
extension View {

    /// Populates the toolbar or navigation bar with the views you provide.
    ///
    /// Use this modifier to add content to the toolbar. The toolbar modifier
    /// expects a collection of toolbar items that you can provide either by
    /// supplying a collection of views with each view wrapped in a
    /// ``ToolbarItem``, or by providing a collection of views as a
    /// ``ToolbarItemGroup``. The example below adds views to using a toolbar
    /// item group to support text editing features:
    ///
    ///     struct StructToolbarItemGroupView: View {
    ///         @State private var text = ""
    ///         @State private var bold = false
    ///         @State private var italic = false
    ///         @State private var fontSize = 12.0
    ///
    ///         var displayFont: Font {
    ///             let font = Font.system(size: CGFloat(fontSize),
    ///                                    weight: bold == true ? .bold : .regular)
    ///             return italic == true ? font.italic() : font
    ///         }
    ///
    ///         var body: some View {
    ///             TextEditor(text: $text)
    ///                 .font(displayFont)
    ///                 .toolbar {
    ///                     ToolbarItemGroup {
    ///                         Slider(
    ///                             value: $fontSize,
    ///                             in: 8...120,
    ///                             minimumValueLabel:
    ///                                 Text("A").font(.system(size: 8)),
    ///                             maximumValueLabel:
    ///                                 Text("A").font(.system(size: 16))
    ///                         ) {
    ///                             Text("Font Size (\(Int(fontSize)))")
    ///                         }
    ///                         .frame(width: 150)
    ///                         Toggle(isOn: $bold) {
    ///                             Image(systemName: "bold")
    ///                         }
    ///                         Toggle(isOn: $italic) {
    ///                             Image(systemName: "italic")
    ///                         }
    ///                     }
    ///                 }
    ///                 .navigationTitle("My Note")
    ///         }
    ///     }
    ///
    /// ![A window showing a font size selector, and toggles for bold, italic.
    ///   and underlined text styling installed in the toolbar to
    ///   support text editing in
    ///   macOS.](SkipUI-View-Styling-ToolbarContent.png)
    ///
    /// - Parameter content: The views representing the content of the toolbar.
    public func toolbar<Content>(@ViewBuilder content: () -> Content) -> some View where Content : View { return never() }


    /// Populates the toolbar or navigation bar with the specified items.
    ///
    /// Use this method to populate a toolbar with a collection of views that
    /// you provide to a toolbar view builder.
    ///
    /// The toolbar modifier expects a collection of toolbar items which you can
    /// provide either by supplying a collection of views with each view
    /// wrapped in a ``ToolbarItem``, or by providing a collection of views as
    /// a ``ToolbarItemGroup``. The example below uses a collection of
    /// ``ToolbarItem`` views to create a macOS toolbar that supports text
    /// editing features:
    ///
    ///     struct StructToolbarItemGroupView: View {
    ///         @State private var text = ""
    ///         @State private var bold = false
    ///         @State private var italic = false
    ///         @State private var fontSize = 12.0
    ///
    ///         var displayFont: Font {
    ///             let font = Font.system(size: CGFloat(fontSize),
    ///                                    weight: bold == true ? .bold : .regular)
    ///             return italic == true ? font.italic() : font
    ///         }
    ///
    ///         var body: some View {
    ///             TextEditor(text: $text)
    ///                 .font(displayFont)
    ///                 .toolbar {
    ///                     ToolbarItemGroup {
    ///                         Slider(
    ///                             value: $fontSize,
    ///                             in: 8...120,
    ///                             minimumValueLabel:
    ///                                 Text("A").font(.system(size: 8)),
    ///                             maximumValueLabel:
    ///                                 Text("A").font(.system(size: 16))
    ///                         ) {
    ///                             Text("Font Size (\(Int(fontSize)))")
    ///                         }
    ///                         .frame(width: 150)
    ///                         Toggle(isOn: $bold) {
    ///                             Image(systemName: "bold")
    ///                         }
    ///                         Toggle(isOn: $italic) {
    ///                             Image(systemName: "italic")
    ///                         }
    ///                     }
    ///                 }
    ///                 .navigationTitle("My Note")
    ///         }
    ///     }
    ///
    /// ![A window showing a font size selector, and toggles for bold, italic.
    ///   and underlined text styling installed in the toolbar to
    ///   support text editing in
    ///   macOS.](SkipUI-View-Styling-ToolbarContent.png)
    ///
    /// Although it's not mandatory, wrapping a related group of toolbar
    /// items together in a ``ToolbarItemGroup`` provides a one-to-one mapping
    /// between controls and toolbar items which results in the correct layout
    /// and spacing on each platform.
    ///
    /// - Parameter content: The items representing the content of the toolbar.
    public func toolbar<Content>(@ToolbarContentBuilder content: () -> Content) -> some View where Content : ToolbarContent { return never() }


    /// Populates the toolbar or navigation bar with the specified items,
    /// allowing for user customization.
    ///
    /// Use this modifier when you want to allow the user to customize the
    /// components and layout of elements in the toolbar. The toolbar modifier
    /// expects a collection of toolbar items which you can provide either by
    /// supplying a collection of views with each view wrapped in a
    /// ``ToolbarItem``.
    ///
    /// > Note: Customizable toolbars will be displayed on both macOS and iOS,
    ///   but only apps running on iPadOS 16.0 and later will support
    ///   user customization.
    ///
    /// The example below creates a view that represents each
    /// ``ToolbarItem`` along with an ID that uniquely identifies the toolbar
    /// item to the customization editor:
    ///
    ///     struct ToolsEditorView: View {
    ///         @State private var text = ""
    ///         @State private var bold = false
    ///         @State private var italic = false
    ///         @State private var fontSize = 12.0
    ///
    ///         var displayFont: Font {
    ///             let font = Font.system(
    ///                size: CGFloat(fontSize),
    ///                  weight: bold == true ? .bold : .regular)
    ///             return italic == true ? font.italic() : font
    ///         }
    ///
    ///         var body: some View {
    ///             TextEditor(text: $text)
    ///                 .font(displayFont)
    ///                 .toolbar(id: "editingtools") {
    ///                     ToolbarItem(
    ///                         id: "sizeSelector", placement: .secondaryAction
    ///                     ) {
    ///                         Slider(
    ///                             value: $fontSize,
    ///                             in: 8...120,
    ///                             minimumValueLabel:
    ///                                 Text("A").font(.system(size: 8)),
    ///                             maximumValueLabel:
    ///                                 Text("A").font(.system(size: 16))
    ///                         ) {
    ///                             Text("Font Size (\(Int(fontSize)))")
    ///                         }
    ///                         .frame(width: 150)
    ///                     }
    ///                     ToolbarItem(
    ///                         id: "bold", placement: .secondaryAction
    ///                     ) {
    ///                         Toggle(isOn: $bold) {
    ///                             Image(systemName: "bold")
    ///                         }
    ///                     }
    ///                     ToolbarItem(
    ///                         id: "italic", placement: .secondaryAction
    ///                     ) {
    ///                         Toggle(isOn: $italic) {
    ///                             Image(systemName: "italic")
    ///                         }
    ///                     }
    ///                 }
    ///                 .navigationTitle("My Note")
    ///         }
    ///     }
    ///
    /// ![A window showing the macOS toolbar customization
    ///   editor.](SkipUI-View-Styling-ToolbarCustomization.png)
    ///
    /// > Note: Only ``ToolbarItemPlacement/secondaryAction`` items support
    ///   customization in iPadOS. Other items follow the normal
    ///   placement rules and can't be customized by the user.
    ///
    /// In macOS you can enable menu support for toolbar customization by
    /// adding a ``ToolbarCommands`` instance to a scene using the
    /// ``Scene/commands(content:)`` scene modifier:
    ///
    ///     @main
    ///     struct ToolbarContent_macOSApp: App {
    ///         var body: some Scene {
    ///             WindowGroup {
    ///                 ToolsEditorView()
    ///                     .frame(maxWidth: .infinity, maxHeight: .infinity)
    ///             }
    ///             .commands {
    ///                 ToolbarCommands()
    ///             }
    ///         }
    ///     }
    ///
    /// When you add the toolbar commands, the system adds a menu item to
    /// your app's main menu to provide toolbar customization support.
    /// This is in addition to the ability to Control-click on the
    /// toolbar to open the toolbar customization editor.
    ///
    /// ![A screenshot of the toolbar editor support for the macOS view
    /// menu.](SkipUI-View-Styling-ToolbarCustomizationMenu.png)
    ///
    /// - Parameters:
    ///   - id: A unique identifier for this toolbar.
    ///   - content: The content representing the content of the toolbar.
    public func toolbar<Content>(id: String, @ToolbarContentBuilder content: () -> Content) -> some View where Content : CustomizableToolbarContent { return never() }

}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
extension View {

    /// Shows the specified content above or below the modified view.
    ///
    /// The `content` view is anchored to the specified
    /// vertical edge in the parent view, aligning its horizontal axis
    /// to the specified alignment guide. The modified view is inset by
    /// the height of `content`, from `edge`, with its safe area
    /// increased by the same amount.
    ///
    ///     struct ScrollableViewWithBottomBar: View {
    ///         var body: some View {
    ///             ScrollView {
    ///                 ScrolledContent()
    ///             }
    ///             .safeAreaInset(edge: .bottom, spacing: 0) {
    ///                 BottomBarContent()
    ///             }
    ///         }
    ///     }
    ///
    /// - Parameters:
    ///   - edge: The vertical edge of the view to inset by the height of
    ///    `content`, to make space for `content`.
    ///   - spacing: Extra distance placed between the two views, or
    ///     nil to use the default amount of spacing.
    ///   - alignment: The alignment guide used to position `content`
    ///     horizontally.
    ///   - content: A view builder function providing the view to
    ///     display in the inset space of the modified view.
    ///
    /// - Returns: A new view that displays both `content` above or below the
    ///   modified view,
    ///   making space for the `content` view by vertically insetting
    ///   the modified view, adjusting the safe area of the result to match.
    @inlinable public func safeAreaInset<V>(edge: VerticalEdge, alignment: HorizontalAlignment = .center, spacing: CGFloat? = nil, @ViewBuilder content: () -> V) -> some View where V : View { return never() }


    /// Shows the specified content beside the modified view.
    ///
    /// The `content` view is anchored to the specified
    /// horizontal edge in the parent view, aligning its vertical axis
    /// to the specified alignment guide. The modified view is inset by
    /// the width of `content`, from `edge`, with its safe area
    /// increased by the same amount.
    ///
    ///     struct ScrollableViewWithSideBar: View {
    ///         var body: some View {
    ///             ScrollView {
    ///                 ScrolledContent()
    ///             }
    ///             .safeAreaInset(edge: .leading, spacing: 0) {
    ///                 SideBarContent()
    ///             }
    ///         }
    ///     }
    ///
    /// - Parameters:
    ///   - edge: The horizontal edge of the view to inset by the width of
    ///    `content`, to make space for `content`.
    ///   - spacing: Extra distance placed between the two views, or
    ///     nil to use the default amount of spacing.
    ///   - alignment: The alignment guide used to position `content`
    ///     vertically.
    ///   - content: A view builder function providing the view to
    ///     display in the inset space of the modified view.
    ///
    /// - Returns: A new view that displays `content` beside the modified view,
    ///   making space for the `content` view by horizontally insetting
    ///   the modified view.
    @inlinable public func safeAreaInset<V>(edge: HorizontalEdge, alignment: VerticalAlignment = .center, spacing: CGFloat? = nil, @ViewBuilder content: () -> V) -> some View where V : View { return never() }

}

extension View {

    /// Adds the provided insets into the safe area of this view.
    ///
    /// Use this modifier when you would like to add a fixed amount
    /// of space to the safe area a view sees.
    ///
    ///     ScrollView(.horizontal) {
    ///         HStack(spacing: 10.0) {
    ///             ForEach(items) { item in
    ///                 ItemView(item)
    ///             }
    ///         }
    ///     }
    ///     .safeAreaPadding(.horizontal, 20.0)
    ///
    /// See the ``View/safeAreaInset(edge:alignment:spacing:content)``
    /// modifier for adding to the safe area based on the size of a
    /// view.
    @available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
    public func safeAreaPadding(_ insets: EdgeInsets) -> some View { return never() }


    /// Adds the provided insets into the safe area of this view.
    ///
    /// Use this modifier when you would like to add a fixed amount
    /// of space to the safe area a view sees.
    ///
    ///     ScrollView(.horizontal) {
    ///         HStack(spacing: 10.0) {
    ///             ForEach(items) { item in
    ///                 ItemView(item)
    ///             }
    ///         }
    ///     }
    ///     .safeAreaPadding(.horizontal, 20.0)
    ///
    /// See the ``View/safeAreaInset(edge:alignment:spacing:content)``
    /// modifier for adding to the safe area based on the size of a
    /// view.
    @available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
    public func safeAreaPadding(_ edges: Edge.Set = .all, _ length: CGFloat? = nil) -> some View { return never() }


    /// Adds the provided insets into the safe area of this view.
    ///
    /// Use this modifier when you would like to add a fixed amount
    /// of space to the safe area a view sees.
    ///
    ///     ScrollView(.horizontal) {
    ///         HStack(spacing: 10.0) {
    ///             ForEach(items) { item in
    ///                 ItemView(item)
    ///             }
    ///         }
    ///     }
    ///     .safeAreaPadding(.horizontal, 20.0)
    ///
    /// See the ``View/safeAreaInset(edge:alignment:spacing:content)``
    /// modifier for adding to the safe area based on the size of a
    /// view.
    @available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
    public func safeAreaPadding(_ length: CGFloat) -> some View { return never() }

}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension View {

    /// Sets the specified style to render backgrounds within the view.
    ///
    /// The following example uses this modifier to set the
    /// ``EnvironmentValues/backgroundStyle`` environment value to a
    /// ``ShapeStyle/blue`` color that includes a subtle ``Color/gradient``.
    /// SkipUI fills the ``Circle`` shape that acts as a background element
    /// with this style:
    ///
    ///     Image(systemName: "swift")
    ///         .padding()
    ///         .background(in: Circle())
    ///         .backgroundStyle(.blue.gradient)
    ///
    /// ![An image of the Swift logo inside a circle that's blue with a slight
    /// linear gradient. The blue color is slightly lighter at the top of the
    /// circle and slightly darker at the bottom.](View-backgroundStyle-1-iOS)
    ///
    /// To restore the default background style, set the
    /// ``EnvironmentValues/backgroundStyle`` environment value to
    /// `nil` using the ``View/environment(_:_:)`` modifer:
    ///
    ///     .environment(\.backgroundStyle, nil)
    ///
    @available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
    @inlinable public func backgroundStyle<S>(_ style: S) -> some View where S : ShapeStyle { return never() }

}

extension View {

    /// Adds an action to perform when the pointer enters, moves within, and
    /// exits the view's bounds.
    ///
    /// Call this method to define a region for detecting pointer movement with
    /// the size and position of this view.
    /// The following example updates `hoverLocation` and `isHovering` to be
    /// based on the phase provided to the closure:
    ///
    ///     @State private var hoverLocation: CGPoint = .zero
    ///     @State private var isHovering = false
    ///
    ///     var body: some View {
    ///         VStack {
    ///             Color.red
    ///                 .frame(width: 400, height: 400)
    ///                 .onContinuousHover { phase in
    ///                     switch phase {
    ///                     case .active(let location):
    ///                         hoverLocation = location
    ///                         isHovering = true
    ///                     case .ended:
    ///                         isHovering = false
    ///                     }
    ///                 }
    ///                 .overlay {
    ///                     Rectangle()
    ///                         .frame(width: 50, height: 50)
    ///                         .foregroundColor(isHovering ? .green : .blue)
    ///                         .offset(x: hoverLocation.x, y: hoverLocation.y)
    ///                 }
    ///         }
    ///     }
    ///
    /// - Parameters:
    ///    - coordinateSpace: The coordinate space for the
    ///    location values. Defaults to ``CoordinateSpace/local``.
    ///    - action: The action to perform whenever the pointer enters,
    ///    moves within, or exits the view's bounds. The `action` closure
    ///    passes the ``HoverPhase/active(_:)`` phase with the pointer's
    ///    coordinates if the pointer is in the view's bounds; otherwise, it
    ///    passes ``HoverPhase/ended``.
    ///
    /// - Returns: A view that calls `action` when the pointer enters,
    ///   moves within, or exits the view's bounds.
    @available(iOS, introduced: 16.0, deprecated: 100000.0, message: "use overload that accepts a CoordinateSpaceProtocol instead")
    @available(macOS, introduced: 13.0, deprecated: 100000.0, message: "use overload that accepts a CoordinateSpaceProtocol instead")
    @available(tvOS, introduced: 16.0, deprecated: 100000.0, message: "use overload that accepts a CoordinateSpaceProtocol instead")
    @available(watchOS, unavailable)
    @available(xrOS, introduced: 1.0, deprecated: 100000.0, message: "use overload that accepts a CoordinateSpaceProtocol instead")
    public func onContinuousHover(coordinateSpace: CoordinateSpace = .local, perform action: @escaping (HoverPhase) -> Void) -> some View { return never() }

}

extension View {

    /// Adds an action to perform when the pointer enters, moves within, and
    /// exits the view's bounds.
    ///
    /// Call this method to define a region for detecting pointer movement with
    /// the size and position of this view.
    /// The following example updates `hoverLocation` and `isHovering` to be
    /// based on the phase provided to the closure:
    ///
    ///     @State private var hoverLocation: CGPoint = .zero
    ///     @State private var isHovering = false
    ///
    ///     var body: some View {
    ///         VStack {
    ///             Color.red
    ///                 .frame(width: 400, height: 400)
    ///                 .onContinuousHover { phase in
    ///                     switch phase {
    ///                     case .active(let location):
    ///                         hoverLocation = location
    ///                         isHovering = true
    ///                     case .ended:
    ///                         isHovering = false
    ///                     }
    ///                 }
    ///                 .overlay {
    ///                     Rectangle()
    ///                         .frame(width: 50, height: 50)
    ///                         .foregroundColor(isHovering ? .green : .blue)
    ///                         .offset(x: hoverLocation.x, y: hoverLocation.y)
    ///                 }
    ///         }
    ///     }
    ///
    /// - Parameters:
    ///    - coordinateSpace: The coordinate space for the
    ///    location values. Defaults to ``CoordinateSpace/local``.
    ///    - action: The action to perform whenever the pointer enters,
    ///    moves within, or exits the view's bounds. The `action` closure
    ///    passes the ``HoverPhase/active(_:)`` phase with the pointer's
    ///    coordinates if the pointer is in the view's bounds; otherwise, it
    ///    passes ``HoverPhase/ended``.
    ///
    /// - Returns: A view that calls `action` when the pointer enters,
    ///   moves within, or exits the view's bounds.
    @available(iOS 17.0, macOS 14.0, tvOS 17.0, *)
    @available(watchOS, unavailable)
    public func onContinuousHover(coordinateSpace: some CoordinateSpaceProtocol = .local, perform action: @escaping (HoverPhase) -> Void) -> some View { return never() }

}

@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
extension View {

    /// Communicates to the user what happens after performing the view's
    /// action.
    ///
    /// Provide a hint in the form of a brief phrase, like "Purchases the item" or
    /// "Downloads the attachment".
    ///
    /// > Note: On macOS, if the view does not have an action and it has been
    ///   made into a container with ``accessibilityElement(children: .contain)``,
    ///   this will be used to describe the container. For example, if the container is
    ///   for a graph, the hint could be "graph".
    public func accessibilityHint(_ hint: Text) -> ModifiedContent<Self, AccessibilityAttachmentModifier> { fatalError() }

    /// Sets alternate input labels with which users identify a view.
    ///
    /// Provide labels in descending order of importance. Voice Control
    /// and Full Keyboard Access use the input labels.
    ///
    /// > Note: If you don't specify any input labels, the user can still
    ///   refer to the view using the accessibility label that you add with the
    ///   `accessibilityLabel()` modifier.
    ///
    /// - Parameter inputLabels: An array of Text elements to use as input labels.
    public func accessibilityInputLabels(_ inputLabels: [Text]) -> ModifiedContent<Self, AccessibilityAttachmentModifier> { fatalError() }
}

@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
extension View {

    /// Communicates to the user what happens after performing the view's
    /// action.
    ///
    /// Provide a hint in the form of a brief phrase, like "Purchases the item" or
    /// "Downloads the attachment".
    public func accessibilityHint(_ hintKey: LocalizedStringKey) -> ModifiedContent<Self, AccessibilityAttachmentModifier> { fatalError() }

    /// Communicates to the user what happens after performing the view's
    /// action.
    ///
    /// Provide a hint in the form of a brief phrase, like "Purchases the item" or
    /// "Downloads the attachment".
    public func accessibilityHint<S>(_ hint: S) -> ModifiedContent<Self, AccessibilityAttachmentModifier> where S : StringProtocol { fatalError() }

    /// Sets alternate input labels with which users identify a view.
    ///
    /// Provide labels in descending order of importance. Voice Control
    /// and Full Keyboard Access use the input labels.
    ///
    /// > Note: If you don't specify any input labels, the user can still
    ///   refer to the view using the accessibility label that you add with the
    ///   `accessibilityLabel()` modifier.
    public func accessibilityInputLabels(_ inputLabelKeys: [LocalizedStringKey]) -> ModifiedContent<Self, AccessibilityAttachmentModifier> { fatalError() }

    /// Sets alternate input labels with which users identify a view.
    ///
    /// Provide labels in descending order of importance. Voice Control
    /// and Full Keyboard Access use the input labels.
    ///
    /// > Note: If you don't specify any input labels, the user can still
    ///   refer to the view using the accessibility label that you add with the
    ///   `accessibilityLabel()` modifier.
    public func accessibilityInputLabels<S>(_ inputLabels: [S]) -> ModifiedContent<Self, AccessibilityAttachmentModifier> where S : StringProtocol { fatalError() }
}

extension View {

    /// Specifies whether to hide this view from system accessibility features.
    @available(iOS, introduced: 13.0, deprecated: 100000.0, renamed: "accessibilityHidden(_:)")
    @available(macOS, introduced: 10.15, deprecated: 100000.0, renamed: "accessibilityHidden(_:)")
    @available(tvOS, introduced: 13.0, deprecated: 100000.0, renamed: "accessibilityHidden(_:)")
    @available(watchOS, introduced: 6, deprecated: 100000.0, renamed: "accessibilityHidden(_:)")
    @available(xrOS, introduced: 1.0, deprecated: 100000.0, renamed: "accessibilityHidden(_:)")
    public func accessibility(hidden: Bool) -> ModifiedContent<Self, AccessibilityAttachmentModifier> { fatalError() }

    /// Adds a label to the view that describes its contents.
    ///
    /// Use this method to provide an accessibility label for a view that doesn't display text, like an icon.
    /// For example, you could use this method to label a button that plays music with the text "Play".
    /// Don't include text in the label that repeats information that users already have. For example,
    /// don't use the label "Play button" because a button already has a trait that identifies it as a button.
    @available(iOS, introduced: 13.0, deprecated: 100000.0, renamed: "accessibilityLabel(_:)")
    @available(macOS, introduced: 10.15, deprecated: 100000.0, renamed: "accessibilityLabel(_:)")
    @available(tvOS, introduced: 13.0, deprecated: 100000.0, renamed: "accessibilityLabel(_:)")
    @available(watchOS, introduced: 6, deprecated: 100000.0, renamed: "accessibilityLabel(_:)")
    @available(xrOS, introduced: 1.0, deprecated: 100000.0, renamed: "accessibilityLabel(_:)")
    public func accessibility(label: Text) -> ModifiedContent<Self, AccessibilityAttachmentModifier> { fatalError() }

    /// Communicates to the user what happens after performing the view's
    /// action.
    ///
    /// Provide a hint in the form of a brief phrase, like "Purchases the item" or
    /// "Downloads the attachment".
    @available(iOS, introduced: 13.0, deprecated: 100000.0, renamed: "accessibilityHint(_:)")
    @available(macOS, introduced: 10.15, deprecated: 100000.0, renamed: "accessibilityHint(_:)")
    @available(tvOS, introduced: 13.0, deprecated: 100000.0, renamed: "accessibilityHint(_:)")
    @available(watchOS, introduced: 6, deprecated: 100000.0, renamed: "accessibilityHint(_:)")
    @available(xrOS, introduced: 1.0, deprecated: 100000.0, renamed: "accessibilityHint(_:)")
    public func accessibility(hint: Text) -> ModifiedContent<Self, AccessibilityAttachmentModifier> { fatalError() }

    /// Sets alternate input labels with which users identify a view.
    ///
    /// Provide labels in descending order of importance. Voice Control
    /// and Full Keyboard Access use the input labels.
    ///
    /// > Note: If you don't specify any input labels, the user can still
    ///   refer to the view using the accessibility label that you add with the
    ///   ``accessibility(label:)`` modifier.
    ///
    /// - Parameter inputLabels: An array of Text elements to use as input labels.
    @available(iOS, introduced: 13.0, deprecated: 100000.0, renamed: "accessibilityInputLabels(_:)")
    @available(macOS, introduced: 10.15, deprecated: 100000.0, renamed: "accessibilityInputLabels(_:)")
    @available(tvOS, introduced: 13.0, deprecated: 100000.0, renamed: "accessibilityInputLabels(_:)")
    @available(watchOS, introduced: 6, deprecated: 100000.0, renamed: "accessibilityInputLabels(_:)")
    @available(xrOS, introduced: 1.0, deprecated: 100000.0, renamed: "accessibilityInputLabels(_:)")
    public func accessibility(inputLabels: [Text]) -> ModifiedContent<Self, AccessibilityAttachmentModifier> { fatalError() }

    /// Uses the specified string to identify the view.
    ///
    /// Use this value for testing. It isn't visible to the user.
    @available(iOS, introduced: 13.0, deprecated: 100000.0, renamed: "accessibilityIdentifier(_:)")
    @available(macOS, introduced: 10.15, deprecated: 100000.0, renamed: "accessibilityIdentifier(_:)")
    @available(tvOS, introduced: 13.0, deprecated: 100000.0, renamed: "accessibilityIdentifier(_:)")
    @available(watchOS, introduced: 6, deprecated: 100000.0, renamed: "accessibilityIdentifier(_:)")
    @available(xrOS, introduced: 1.0, deprecated: 100000.0, renamed: "accessibilityIdentifier(_:)")
    public func accessibility(identifier: String) -> ModifiedContent<Self, AccessibilityAttachmentModifier> { fatalError() }

    /// Sets a selection identifier for this view's accessibility element.
    ///
    /// Picker uses the value to determine what node to use for the
    /// accessibility value.
    @available(iOS, deprecated, introduced: 13.0)
    @available(macOS, deprecated, introduced: 10.15)
    @available(tvOS, deprecated, introduced: 13.0)
    @available(watchOS, deprecated, introduced: 6)
    @available(xrOS, introduced: 1.0, deprecated: 1.0)
    public func accessibility(selectionIdentifier: AnyHashable) -> ModifiedContent<Self, AccessibilityAttachmentModifier> { fatalError() }

    /// Sets the sort priority order for this view's accessibility element,
    /// relative to other elements at the same level.
    ///
    /// Higher numbers are sorted first. The default sort priority is zero.
    @available(iOS, introduced: 13.0, deprecated: 100000.0, renamed: "accessibilitySortPriority(_:)")
    @available(macOS, introduced: 10.15, deprecated: 100000.0, renamed: "accessibilitySortPriority(_:)")
    @available(tvOS, introduced: 13.0, deprecated: 100000.0, renamed: "accessibilitySortPriority(_:)")
    @available(watchOS, introduced: 6, deprecated: 100000.0, renamed: "accessibilitySortPriority(_:)")
    @available(xrOS, introduced: 1.0, deprecated: 100000.0, renamed: "accessibilitySortPriority(_:)")
    public func accessibility(sortPriority: Double) -> ModifiedContent<Self, AccessibilityAttachmentModifier> { fatalError() }

    /// Specifies the point where activations occur in the view.
    @available(iOS, introduced: 13.0, deprecated: 100000.0, renamed: "accessibilityActivationPoint(_:)")
    @available(macOS, introduced: 10.15, deprecated: 100000.0, renamed: "accessibilityActivationPoint(_:)")
    @available(tvOS, introduced: 13.0, deprecated: 100000.0, renamed: "accessibilityActivationPoint(_:)")
    @available(watchOS, introduced: 6, deprecated: 100000.0, renamed: "accessibilityActivationPoint(_:)")
    @available(xrOS, introduced: 1.0, deprecated: 100000.0, renamed: "accessibilityActivationPoint(_:)")
    public func accessibility(activationPoint: CGPoint) -> ModifiedContent<Self, AccessibilityAttachmentModifier> { fatalError() }

    /// Specifies the unit point where activations occur in the view.
    @available(iOS, introduced: 13.0, deprecated: 100000.0, renamed: "accessibilityActivationPoint(_:)")
    @available(macOS, introduced: 10.15, deprecated: 100000.0, renamed: "accessibilityActivationPoint(_:)")
    @available(tvOS, introduced: 13.0, deprecated: 100000.0, renamed: "accessibilityActivationPoint(_:)")
    @available(watchOS, introduced: 6, deprecated: 100000.0, renamed: "accessibilityActivationPoint(_:)")
    @available(xrOS, introduced: 1.0, deprecated: 100000.0, renamed: "accessibilityActivationPoint(_:)")
    public func accessibility(activationPoint: UnitPoint) -> ModifiedContent<Self, AccessibilityAttachmentModifier> { fatalError() }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension View {

    /// Binds a view's identity to the given proxy value.
    ///
    /// When the proxy value specified by the `id` parameter changes, the
    /// identity of the view — for example, its state — is reset.
    @inlinable public func id<ID>(_ id: ID) -> some View where ID : Hashable { return never() }

}

@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
extension View {

    /// Performs an action when a specified value changes.
    ///
    /// Use this modifier to run a closure when a value like
    /// an ``Environment`` value or a ``Binding`` changes.
    /// For example, you can clear a cache when you notice
    /// that the view's scene moves to the background:
    ///
    ///     struct ContentView: View {
    ///         @Environment(\.scenePhase) private var scenePhase
    ///         @StateObject private var cache = DataCache()
    ///
    ///         var body: some View {
    ///             MyView()
    ///                 .onChange(of: scenePhase) { newScenePhase in
    ///                     if newScenePhase == .background {
    ///                         cache.empty()
    ///                     }
    ///                 }
    ///         }
    ///     }
    ///
    /// SkipUI passes the new value into the closure. You can also capture the
    /// previous value to compare it to the new value. For example, in
    /// the following code example, `PlayerView` passes both the old and new
    /// values to the model.
    ///
    ///     struct PlayerView: View {
    ///         var episode: Episode
    ///         @State private var playState: PlayState = .paused
    ///
    ///         var body: some View {
    ///             VStack {
    ///                 Text(episode.title)
    ///                 Text(episode.showTitle)
    ///                 PlayButton(playState: $playState)
    ///             }
    ///             .onChange(of: playState) { [playState] newState in
    ///                 model.playStateDidChange(from: playState, to: newState)
    ///             }
    ///         }
    ///     }
    ///
    /// The system may call the action closure on the main actor, so avoid
    /// long-running tasks in the closure. If you need to perform such tasks,
    /// detach an asynchronous background task.
    ///
    /// Important: This modifier is deprecated and has been replaced with new
    /// versions that include either zero or two parameters within the closure,
    /// unlike this version that includes one parameter. This deprecated version
    /// and the new versions behave differently with respect to how they execute
    /// the action closure, specifically when the closure captures other values.
    /// Using the deprecated API, the closure is run with captured values that
    /// represent the "old" state. With the replacement API, the closure is run
    /// with captured values that represent the "new" state, which makes it
    /// easier to correctly perform updates that rely on supplementary values
    /// (that may or may not have changed) in addition to the changed value that
    /// triggered the action.
    ///
    /// - Important: This modifier is deprecated and has been replaced with new
    ///   versions that include either zero or two parameters within the
    ///   closure, unlike this version that includes one parameter. This
    ///   deprecated version and the new versions behave differently with
    ///   respect to how they execute the action closure, specifically when the
    ///   closure captures other values. Using the deprecated API, the closure
    ///   is run with captured values that represent the "old" state. With the
    ///   replacement API, the closure is run with captured values that
    ///   represent the "new" state, which makes it easier to correctly perform
    ///   updates that rely on supplementary values (that may or may not have
    ///   changed) in addition to the changed value that triggered the action.
    ///
    /// - Parameters:
    ///   - value: The value to check when determining whether to run the
    ///     closure. The value must conform to the
    ///
    ///     protocol.
    ///   - action: A closure to run when the value changes. The closure
    ///     takes a `newValue` parameter that indicates the updated
    ///     value.
    ///
    /// - Returns: A view that runs an action when the specified value changes.
    @available(iOS, deprecated: 17.0, message: "Use `onChange` with a two or zero parameter action closure instead.")
    @available(macOS, deprecated: 14.0, message: "Use `onChange` with a two or zero parameter action closure instead.")
    @available(tvOS, deprecated: 17.0, message: "Use `onChange` with a two or zero parameter action closure instead.")
    @available(watchOS, deprecated: 10.0, message: "Use `onChange` with a two or zero parameter action closure instead.")
    @available(xrOS, deprecated: 1.0, message: "Use `onChange` with a two or zero parameter action closure instead.")
    @inlinable public func onChange<V>(of value: V, perform action: @escaping (_ newValue: V) -> Void) -> some View where V : Equatable { return never() }

}

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension View {

    /// Adds a modifier for this view that fires an action when a specific
    /// value changes.
    ///
    /// You can use `onChange` to trigger a side effect as the result of a
    /// value changing, such as an `Environment` key or a `Binding`.
    ///
    /// The system may call the action closure on the main actor, so avoid
    /// long-running tasks in the closure. If you need to perform such tasks,
    /// detach an asynchronous background task.
    ///
    /// When the value changes, the new version of the closure will be called,
    /// so any captured values will have their values from the time that the
    /// observed value has its new value. The old and new observed values are
    /// passed into the closure. In the following code example, `PlayerView`
    /// passes both the old and new values to the model.
    ///
    ///     struct PlayerView: View {
    ///         var episode: Episode
    ///         @State private var playState: PlayState = .paused
    ///
    ///         var body: some View {
    ///             VStack {
    ///                 Text(episode.title)
    ///                 Text(episode.showTitle)
    ///                 PlayButton(playState: $playState)
    ///             }
    ///             .onChange(of: playState) { oldState, newState in
    ///                 model.playStateDidChange(from: oldState, to: newState)
    ///             }
    ///         }
    ///     }
    ///
    /// - Parameters:
    ///   - value: The value to check against when determining whether
    ///     to run the closure.
    ///   - initial: Whether the action should be run when this view initially
    ///     appears.
    ///   - action: A closure to run when the value changes.
    ///   - oldValue: The old value that failed the comparison check (or the
    ///     initial value when requested).
    ///   - newValue: The new value that failed the comparison check.
    ///
    /// - Returns: A view that fires an action when the specified value changes.
    public func onChange<V>(of value: V, initial: Bool = false, _ action: @escaping (_ oldValue: V, _ newValue: V) -> Void) -> some View where V : Equatable { return never() }


    /// Adds a modifier for this view that fires an action when a specific
    /// value changes.
    ///
    /// You can use `onChange` to trigger a side effect as the result of a
    /// value changing, such as an `Environment` key or a `Binding`.
    ///
    /// The system may call the action closure on the main actor, so avoid
    /// long-running tasks in the closure. If you need to perform such tasks,
    /// detach an asynchronous background task.
    ///
    /// When the value changes, the new version of the closure will be called,
    /// so any captured values will have their values from the time that the
    /// observed value has its new value. In the following code example,
    /// `PlayerView` calls into its model when `playState` changes model.
    ///
    ///     struct PlayerView: View {
    ///         var episode: Episode
    ///         @State private var playState: PlayState = .paused
    ///
    ///         var body: some View {
    ///             VStack {
    ///                 Text(episode.title)
    ///                 Text(episode.showTitle)
    ///                 PlayButton(playState: $playState)
    ///             }
    ///             .onChange(of: playState) {
    ///                 model.playStateDidChange(state: playState)
    ///             }
    ///         }
    ///     }
    ///
    /// - Parameters:
    ///   - value: The value to check against when determining whether
    ///     to run the closure.
    ///   - initial: Whether the action should be run when this view initially
    ///     appears.
    ///   - action: A closure to run when the value changes.
    ///
    /// - Returns: A view that fires an action when the specified value changes.
    public func onChange<V>(of value: V, initial: Bool = false, _ action: @escaping () -> Void) -> some View where V : Equatable { return never() }

}

@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
extension View {

    /// Sets the style for progress views in this view.
    ///
    /// For example, the following code creates a progress view that uses the
    /// "circular" style:
    ///
    ///     ProgressView()
    ///         .progressViewStyle(.circular)
    ///
    /// - Parameter style: The progress view style to use for this view.
    public func progressViewStyle<S>(_ style: S) -> some View where S : ProgressViewStyle { return never() }

}

extension View {

    /// Sets the container background of the enclosing container using a view.
    ///
    /// The following example uses a ``LinearGradient`` as a background:
    ///
    ///     struct ContentView: View {
    ///         var body: some View {
    ///             NavigationStack {
    ///                 List {
    ///                     NavigationLink("Blue") {
    ///                         Text("Blue")
    ///                         .containerBackground(.blue.gradient, for: .navigation)
    ///                     }
    ///                     NavigationLink("Red") {
    ///                         Text("Red")
    ///                         .containerBackground(.red.gradient, for: .navigation)
    ///                     }
    ///                 }
    ///             }
    ///         }
    ///     }
    ///
    /// The `.containerBackground(_:for:)` modifier differs from the
    /// ``View/background(_:ignoresSafeAreaEdges:)`` modifier by automatically
    /// filling an entire parent container. ``ContainerBackgroundPlacement``
    /// describes the available containers.
    ///
    /// - Parameters
    ///   - style: The shape style to use as the container background.
    ///   - container: The container that will use the background.
    @available(iOS 17.0, tvOS 17.0, macOS 14.0, watchOS 10.0, *)
    public func containerBackground<S>(_ style: S, for container: ContainerBackgroundPlacement) -> some View where S : ShapeStyle { return never() }


    /// Sets the container background of the enclosing container using a view.
    ///
    /// The following example uses a custom ``View`` as a background:
    ///
    ///     struct ContentView: View {
    ///         var body: some View {
    ///             NavigationStack {
    ///                 List {
    ///                     NavigationLink("Image") {
    ///                         Text("Image")
    ///                         .containerBackground(for: .navigation) {
    ///                             Image(name: "ImageAsset")
    ///                         }
    ///                     }
    ///                 }
    ///             }
    ///         }
    ///     }
    ///
    /// The `.containerBackground(for:alignment:content:)` modifier differs from
    /// the ``View/background(_:ignoresSafeAreaEdges:)`` modifier by
    /// automatically filling an entire parent container.
    /// ``ContainerBackgroundPlacement`` describes the available containers.
    ///
    /// - Parameters:
    ///   - alignment: The alignment that the modifier uses to position the
    ///     implicit ``ZStack`` that groups the background views. The default is
    ///     ``Alignment/center``.
    ///   - container: The container that will use the background.
    ///   - content: The view to use as the background of the container.
    @available(iOS 17.0, tvOS 17.0, macOS 14.0, watchOS 10.0, *)
    public func containerBackground<V>(for container: ContainerBackgroundPlacement, alignment: Alignment = .center, @ViewBuilder content: () -> V) -> some View where V : View { return never() }

}

extension View {

    /// Sets the scroll behavior of views scrollable in the provided axes.
    ///
    /// A scrollable view calculates where scroll gestures should end using its
    /// deceleration rate and the state of its scroll gesture by default. A
    /// scroll behavior allows for customizing this logic. You can provide
    /// your own ``ScrollTargetBehavior`` or use one of the built in behaviors
    /// provided by SkipUI.
    ///
    /// ### Paging Behavior
    ///
    /// SkipUI offers a ``PagingScrollTargetBehavior`` behavior which uses the
    /// geometry of the scroll view to decide where to allow scrolls to end.
    ///
    /// In the following example, every view in the lazy stack is flexible
    /// in both directions and the scroll view will settle to container aligned
    /// boundaries.
    ///
    ///     ScrollView {
    ///         LazyVStack(spacing: 0.0) {
    ///             ForEach(items) { item in
    ///                 FullScreenItem(item)
    ///             }
    ///         }
    ///     }
    ///     .scrollTargetBehavior(.paging)
    ///
    /// ### View Aligned Behavior
    ///
    /// SkipUI offers a ``ViewAlignedScrollTargetBehavior`` scroll behavior
    /// that will always settle on the geometry of individual views.
    ///
    ///     ScrollView(.horizontal) {
    ///         LazyHStack(spacing: 10.0) {
    ///             ForEach(items) { item in
    ///                 ItemView(item)
    ///             }
    ///         }
    ///         .scrollTargetLayout()
    ///     }
    ///     .scrollTargetBehavior(.viewAligned)
    ///     .safeAreaPadding(.horizontal, 20.0)
    ///
    /// You configure which views should be used for settling using the
    /// ``View/scrollTargetLayout()`` modifier. Apply this modifier to a
    /// layout container like ``LazyVStack`` or ``HStack`` and each individual
    /// view in that layout will be considered for alignment.
    ///
    /// You can also associate invidiual views for alignment using the
    /// ``View/scrollTarget()`` modifier.
    ///
    ///     ScrollView(.horizontal) {
    ///         HeaderView()
    ///             .scrollTarget()
    ///         LazyVStack {
    ///             // other content...
    ///         }
    ///         .scrollTargetLayout()
    ///     }
    ///     .scrollTargetBehavior(.viewAligned)
    ///
    @available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
    public func scrollTargetBehavior(_ behavior: some ScrollTargetBehavior) -> some View { return never() }

}

extension View {

    /// Configures the outermost layout as a scroll target layout.
    ///
    /// This modifier works together with the
    /// ``ViewAlignedScrollTargetBehavior`` to ensure that scroll views align
    /// to view based content.
    ///
    /// Apply this modifier to layout containers like ``LazyHStack`` or
    /// ``VStack`` within a ``ScrollView`` that contain the main repeating
    /// content of your ``ScrollView``.
    ///
    ///     ScrollView(.horizontal) {
    ///         LazyHStack(spacing: 10.0) {
    ///             ForEach(items) { item in
    ///                 ItemView(item)
    ///             }
    ///         }
    ///         .scrollTargetLayout()
    ///     }
    ///     .scrollTargetBehavior(.viewAligned)
    ///
    /// Scroll target layouts act as a convenience for applying a
    /// ``View/scrollTarget(isEnabled:)`` modifier to each views in
    /// the layout.
    ///
    /// A scroll target layout will ensure that any target layout
    /// nested within the primary one will not also become a scroll
    /// target layout.
    ///
    ///     LazyHStack { // a scroll target layout
    ///         VStack { ... } // not a scroll target layout
    ///         LazyHStack { ... } // also not a scroll target layout
    ///     }
    ///     .scrollTargetLayout()
    ///
    @available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
    public func scrollTargetLayout(isEnabled: Bool = true) -> some View { return never() }

}

extension View {

    /// Configures this view as a scroll target.
    ///
    /// Apply this modifier to individual views like ``Button`` or
    /// ``Text`` within a ``ScrollView`` that represent distinct pieces of
    /// content that a scroll view may wish to align to.
    ///
    ///     ScrollView {
    ///         Text("Header")
    ///             .font(.title2)
    ///             .scrollTarget()
    ///
    ///         LazyVStack {
    ///             ForEach(items) { item in
    ///                 ItemView(item)
    ///             }
    ///         }
    ///         .scrollTargetLayout()
    ///     }
    ///     .scrollTargetBehavior(.viewAligned)
    ///
    /// A scroll target layout act as a convenience for applying a
    /// ``View/scrollTarget(isEnabled:)`` modifier to each views in
    /// the layout.
    ///
    @available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
    public func scrollTarget(isEnabled: Bool = true) -> some View { return never() }

}

@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
extension View {

    /// Sets the sort priority order for this view's accessibility element,
    /// relative to other elements at the same level.
    ///
    /// Higher numbers are sorted first. The default sort priority is zero.
    public func accessibilitySortPriority(_ sortPriority: Double) -> ModifiedContent<Self, AccessibilityAttachmentModifier> { fatalError() }
}

extension View {

    /// Adds a custom large content view to be shown by
    /// the large content viewer.
    ///
    /// Rely on the large content viewer only in situations
    /// where items must remain small due to unavoidable
    /// design constraints. For example, buttons in a tab bar
    /// remain small to leave more room for the main app content.
    ///
    /// The following example shows how to add a custom large
    /// content view:
    ///
    ///     var body: some View {
    ///         Button(action: newMessage) {
    ///             Image(systemName: "plus")
    ///         }
    ///         .accessibilityShowsLargeContentViewer {
    ///             Label("New Message", systemImage: "plus")
    ///         }
    ///     }
    ///
    /// Don’t use the large content viewer as a replacement for proper
    /// Dynamic Type support. For example, Dynamic Type allows items
    /// in a list to grow or shrink vertically to accommodate the user’s preferred
    /// font size. Rely on the large content viewer only in situations where
    /// items must remain small due to unavoidable design constraints.
    ///
    /// For example, views that have their Dynamic Type size constrained
    /// with ``View/dynamicTypeSize(_:)-26aj0`` or
    /// ``View/dynamicTypeSize(_:)-26aj0`` may require a
    /// large content view.
    @available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
    public func accessibilityShowsLargeContentViewer<V>(@ViewBuilder _ largeContentView: () -> V) -> some View where V : View { return never() }


    /// Adds a default large content view to be shown by
    /// the large content viewer.
    ///
    /// Rely on the large content viewer only in situations
    /// where items must remain small due to unavoidable
    /// design constraints. For example, buttons in a tab bar
    /// remain small to leave more room for the main app content.
    ///
    /// The following example shows how to add a custom large
    /// content view:
    ///
    ///     var body: some View {
    ///         Button("New Message", action: newMessage)
    ///             .accessibilityShowsLargeContentViewer()
    ///     }
    ///
    /// Don’t use the large content viewer as a replacement for proper
    /// Dynamic Type support. For example, Dynamic Type allows items
    /// in a list to grow or shrink vertically to accommodate the user’s preferred
    /// font size. Rely on the large content viewer only in situations where
    /// items must remain small due to unavoidable design constraints.
    ///
    /// For example, views that have their Dynamic Type size constrained
    /// with ``View/dynamicTypeSize(_:)-26aj0`` or
    /// ``View/dynamicTypeSize(_:)-26aj0`` may require a
    /// large content view.
    @available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
    public func accessibilityShowsLargeContentViewer() -> some View { return never() }

}

@available(iOS 14.0, macOS 11.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension View {

    /// Presents a system interface for allowing the user to move an existing
    /// file to a new location.
    ///
    /// - Note: This interface provides security-scoped URLs.
    ///   Call the ``startAccessingSecurityScopedResource`` method to access or bookmark
    ///   the URLs, and the ``stopAccessingSecurityScopedResource`` method
    ///   to release the access.
    ///
    /// In order for the interface to appear, both `isPresented` must be `true`
    /// and `file` must not be `nil`. When the operation is finished,
    /// `isPresented` will be set to `false` before `onCompletion` is called. If
    /// the user cancels the operation, `isPresented` will be set to `false` and
    /// `onCompletion` will not be called.
    ///
    /// - Parameters:
    ///   - isPresented: A binding to whether the interface should be shown.
    ///   - file: The `URL` of the file to be moved.
    ///   - onCompletion: A callback that will be invoked when the operation has
    ///     has succeeded or failed. To access the received URLs, call `startAccessingSecurityScopedResource`.
    ///     When the access is no longer required, call `stopAccessingSecurityScopedResource`.
    ///   - result: A `Result` indicating whether the operation succeeded or
    ///     failed.
    public func fileMover(isPresented: Binding<Bool>, file: URL?, onCompletion: @escaping (_ result: Result<URL, Error>) -> Void) -> some View { return never() }


    /// Presents a system interface for allowing the user to move a collection
    /// of existing files to a new location.
    ///
    /// - Note: This interface provides security-scoped URLs.
    ///   Call the ``startAccessingSecurityScopedResource`` method to access or bookmark
    ///   the URLs, and the ``stopAccessingSecurityScopedResource`` method
    ///   to release the access.
    ///
    /// In order for the interface to appear, both `isPresented` must be `true`
    /// and `files` must not be empty. When the operation is finished,
    /// `isPresented` will be set to `false` before `onCompletion` is called. If
    /// the user cancels the operation, `isPresented` will be set to `false` and
    /// `onCompletion` will not be called.
    ///
    /// - Parameters:
    ///   - isPresented: A binding to whether the interface should be shown.
    ///   - files: A collection of `URL`s for the files to be moved.
    ///   - onCompletion: A callback that will be invoked when the operation has
    ///     has succeeded or failed. To access the received URLs, call `startAccessingSecurityScopedResource`.
    ///     When the access is no longer required, call `stopAccessingSecurityScopedResource`.
    ///   - result: A `Result` indicating whether the operation succeeded or
    ///     failed.
    public func fileMover<C>(isPresented: Binding<Bool>, files: C, onCompletion: @escaping (_ result: Result<[URL], Error>) -> Void) -> some View where C : Collection, C.Element == URL { return never() }

}

@available(iOS 17.0, macOS 14.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension View {

    /// Presents a system dialog for allowing the user to move
    /// an existing file to a new location.
    ///
    /// - Note: This dialog provides security-scoped URLs.
    ///   Call the ``startAccessingSecurityScopedResource`` method to access or bookmark
    ///   the URLs, and the ``stopAccessingSecurityScopedResource`` method
    ///   to release the access.
    ///
    /// For example, a button that allows the user to move a file might look like this:
    ///
    ///       struct MoveFileButton: View {
    ///           @State private var showFileMover = false
    ///           var file: URL
    ///           var onCompletion: (URL) -> Void
    ///           var onCancellation: (() -> Void)?
    ///
    ///           var body: some View {
    ///               Button {
    ///                   showFileMover = true
    ///               } label: {
    ///                   Label("Choose destination", systemImage: "folder.circle")
    ///               }
    ///               .fileMover(isPresented: $showFileMover, file: file) { result in
    ///                   switch result {
    ///                   case .success(let url):
    ///                       guard url.startAccessingSecurityScopedResource() else {
    ///                           return
    ///                       }
    ///                       onCompletion(url)
    ///                       url.stopAccessingSecurityScopedResource()
    ///                   case .failure(let error):
    ///                       print(error)
    ///                       // handle error
    ///                   }
    ///               } onCancellation: {
    ///                   onCancellation?()
    ///               }
    ///           }
    ///       }
    ///
    /// - Parameters:
    ///   - isPresented: A binding to whether the dialog should be shown.
    ///   - file: The URL of the file to be moved.
    ///   - onCompletion: A callback that will be invoked when the operation has
    ///     succeeded or failed. The `result` indicates whether
    ///     the operation succeeded or failed. To access the received URLs, call
    ///     `startAccessingSecurityScopedResource`.
    ///     When the access is no longer required, call `stopAccessingSecurityScopedResource`.
    ///   - onCancellation: A callback that will be invoked
    ///     if the user cancels the operation.
    public func fileMover(isPresented: Binding<Bool>, file: URL?, onCompletion: @escaping (Result<URL, Error>) -> Void, onCancellation: @escaping () -> Void) -> some View { return never() }


    /// Presents a system dialog for allowing the user to move
    /// a collection of existing files to a new location.
    ///
    /// - Note: This dialog provides security-scoped URLs.
    ///   Call the ``startAccessingSecurityScopedResource`` method to access or bookmark
    ///   the URLs, and the ``stopAccessingSecurityScopedResource`` method
    ///   to release the access.
    ///
    /// For example, a button that allows the user to move files might look like this:
    ///
    ///       struct MoveFilesButton: View {
    ///           @Binding var files: [URL]
    ///           @State private var showFileMover = false
    ///           var onCompletion: (URL) -> Void
    ///           var onCancellation: (() -> Void)?
    ///
    ///           var body: some View {
    ///               Button {
    ///                   showFileMover = true
    ///               } label: {
    ///                   Label("Choose destination", systemImage: "folder.circle")
    ///               }
    ///               .fileMover(isPresented: $showFileMover, files: files) { result in
    ///                   switch result {
    ///                   case .success(let urls):
    ///                       urls.forEach { url in
    ///                           guard url.startAccessingSecurityScopedResource() else {
    ///                               return
    ///                           }
    ///                           onCompletion(url)
    ///                           url.stopAccessingSecurityScopedResource()
    ///                       }
    ///                   case .failure(let error):
    ///                       print(error)
    ///                       // handle error
    ///                   }
    ///               } onCancellation: {
    ///                   onCancellation?()
    ///               }
    ///           }
    ///       }
    ///
    /// - Parameters:
    ///   - isPresented: A binding to whether the dialog should be shown.
    ///   - files: A collection of URLs for the files to be moved.
    ///   - onCompletion: A callback that will be invoked when the operation has
    ///     succeeded or failed. The `result` indicates whether
    ///     the operation succeeded or failed.
    ///     To access the received URLs, call `startAccessingSecurityScopedResource`.
    ///     When the access is no longer required, call `stopAccessingSecurityScopedResource`.
    ///   - onCancellation: A callback that will be invoked
    ///     if the user cancels the operation.
    public func fileMover<C>(isPresented: Binding<Bool>, files: C, onCompletion: @escaping (Result<[URL], Error>) -> Void, onCancellation: @escaping () -> Void) -> some View where C : Collection, C.Element == URL { return never() }

}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
extension View {

    /// Adds an asynchronous task to perform before this view appears.
    ///
    /// Use this modifier to perform an asynchronous task with a lifetime that
    /// matches that of the modified view. If the task doesn't finish
    /// before SkipUI removes the view or the view changes identity, SkipUI
    /// cancels the task.
    ///
    /// Use the `await` keyword inside the task to
    /// wait for an asynchronous call to complete, or to wait on the values of
    /// an
    /// instance. For example, you can modify a ``Text`` view to start a task
    /// that loads content from a remote resource:
    ///
    ///     let url = URL(string: "https://example.com")!
    ///     @State private var message = "Loading..."
    ///
    ///     var body: some View {
    ///         Text(message)
    ///             .task {
    ///                 do {
    ///                     var receivedLines = [String]()
    ///                     for try await line in url.lines {
    ///                         receivedLines.append(line)
    ///                         message = "Received \(receivedLines.count) lines"
    ///                     }
    ///                 } catch {
    ///                     message = "Failed to load"
    ///                 }
    ///             }
    ///     }
    ///
    /// This example uses the
    /// method to get the content stored at the specified
    ///  as an
    /// asynchronous sequence of strings. When each new line arrives, the body
    /// of the `for`-`await`-`in` loop stores the line in an array of strings
    /// and updates the content of the text view to report the latest line
    /// count.
    ///
    /// - Parameters:
    ///   - priority: The task priority to use when creating the asynchronous
    ///     task. The default priority is
    ///     .
    ///   - action: A closure that SkipUI calls as an asynchronous task
    ///     before the view appears. SkipUI will automatically cancel the task
    ///     at some point after the view disappears before the action completes.
    ///
    ///
    /// - Returns: A view that runs the specified action asynchronously before
    ///   the view appears.
    @inlinable public func task(priority: TaskPriority = .userInitiated, _ action: @escaping @Sendable () async -> Void) -> some View { return never() }


    /// Adds a task to perform before this view appears or when a specified
    /// value changes.
    ///
    /// This method behaves like ``View/task(priority:_:)``, except that it also
    /// cancels and recreates the task when a specified value changes. To detect
    /// a change, the modifier tests whether a new value for the `id` parameter
    /// equals the previous value. For this to work,
    /// the value's type must conform to the
    ///  protocol.
    ///
    /// For example, if you define an equatable `Server` type that posts custom
    /// notifications whenever its state changes --- for example, from _signed
    /// out_ to _signed in_ --- you can use the task modifier to update
    /// the contents of a ``Text`` view to reflect the state of the
    /// currently selected server:
    ///
    ///     Text(status ?? "Signed Out")
    ///         .task(id: server) {
    ///             let sequence = NotificationCenter.default.notifications(
    ///                 named: .didChangeStatus,
    ///                 object: server)
    ///             for try await notification in sequence {
    ///                 status = notification.userInfo["status"] as? String
    ///             }
    ///         }
    ///
    /// This example uses the
    /// method to wait indefinitely for an asynchronous sequence of
    /// notifications, given by an
    /// instance.
    ///
    /// Elsewhere, the server defines a custom `didUpdateStatus` notification:
    ///
    ///     extension NSNotification.Name {
    ///         static var didUpdateStatus: NSNotification.Name {
    ///             NSNotification.Name("didUpdateStatus")
    ///         }
    ///     }
    ///
    /// The server then posts a notification of this type whenever its status
    /// changes, like after the user signs in:
    ///
    ///     let notification = Notification(
    ///         name: .didUpdateStatus,
    ///         object: self,
    ///         userInfo: ["status": "Signed In"])
    ///     NotificationCenter.default.post(notification)
    ///
    /// The task attached to the ``Text`` view gets and displays the status
    /// value from the notification's user information dictionary. When the user
    /// chooses a different server, SkipUI cancels the task and creates a new
    /// one, which then starts waiting for notifications from the new server.
    ///
    /// - Parameters:
    ///   - id: The value to observe for changes. The value must conform
    ///     to the
    ///     protocol.
    ///   - priority: The task priority to use when creating the asynchronous
    ///     task. The default priority is
    ///     .
    ///   - action: A closure that SkipUI calls as an asynchronous task
    ///     before the view appears. SkipUI can automatically cancel the task
    ///     after the view disappears before the action completes. If the
    ///     `id` value changes, SkipUI cancels and restarts the task.
    ///
    /// - Returns: A view that runs the specified action asynchronously before
    ///   the view appears, or restarts the task with the `id` value changes.
    @inlinable public func task<T>(id value: T, priority: TaskPriority = .userInitiated, _ action: @escaping @Sendable () async -> Void) -> some View where T : Equatable { return never() }

}

@available(iOS 16.0, macOS 13.0, watchOS 7.0, *)
@available(tvOS, unavailable)
extension View {

    /// Sets the style for gauges within this view.
    public func gaugeStyle<S>(_ style: S) -> some View where S : GaugeStyle { return never() }

}

@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
extension View {

    /// Sets the tint effect associated with specific content in a list.
    ///
    /// The containing list's style will apply that tint as appropriate. watchOS
    /// uses the tint color for its background platter appearance. Sidebars on
    /// iOS and macOS apply the tint color to their `Label` icons, which
    /// otherwise use the accent color by default.
    ///
    /// - Parameter tint: The tint effect to use, or nil to not override the
    ///   inherited tint.
    @inlinable public func listItemTint(_ tint: ListItemTint?) -> some View { return never() }


    /// Sets a fixed tint color associated with specific content in a list.
    ///
    /// This is equivalent to using a tint of `ListItemTint.fixed(_:)` with the
    /// provided `tint` color.
    ///
    /// The containing list's style will apply that tint as appropriate. watchOS
    /// uses the tint color for its background platter appearance. Sidebars on
    /// iOS and macOS apply the tint color to their `Label` icons, which
    /// otherwise use the accent color by default.
    ///
    /// - Parameter color: The color to use to tint the content, or nil to not
    ///   override the inherited tint.
    @inlinable public func listItemTint(_ tint: Color?) -> some View { return never() }

}

@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
extension View {

    /// Adds the given traits to the view.
    public func accessibilityAddTraits(_ traits: AccessibilityTraits) -> ModifiedContent<Self, AccessibilityAttachmentModifier> { fatalError() }

    /// Removes the given traits from this view.
    public func accessibilityRemoveTraits(_ traits: AccessibilityTraits) -> ModifiedContent<Self, AccessibilityAttachmentModifier> { fatalError() }
}

extension View {

    /// Adds the given traits to the view.
    @available(iOS, introduced: 13.0, deprecated: 100000.0, renamed: "accessibilityAddTraits(_:)")
    @available(macOS, introduced: 10.15, deprecated: 100000.0, renamed: "accessibilityAddTraits(_:)")
    @available(tvOS, introduced: 13.0, deprecated: 100000.0, renamed: "accessibilityAddTraits(_:)")
    @available(watchOS, introduced: 6, deprecated: 100000.0, renamed: "accessibilityAddTraits(_:)")
    @available(xrOS, introduced: 1.0, deprecated: 100000.0, renamed: "accessibilityAddTraits(_:)")
    public func accessibility(addTraits traits: AccessibilityTraits) -> ModifiedContent<Self, AccessibilityAttachmentModifier> { fatalError() }

    /// Removes the given traits from this view.
    @available(iOS, introduced: 13.0, deprecated: 100000.0, renamed: "accessibilityRemoveTraits(_:)")
    @available(macOS, introduced: 10.15, deprecated: 100000.0, renamed: "accessibilityRemoveTraits(_:)")
    @available(tvOS, introduced: 13.0, deprecated: 100000.0, renamed: "accessibilityRemoveTraits(_:)")
    @available(watchOS, introduced: 6, deprecated: 100000.0, renamed: "accessibilityRemoveTraits(_:)")
    @available(xrOS, introduced: 1.0, deprecated: 100000.0, renamed: "accessibilityRemoveTraits(_:)")
    public func accessibility(removeTraits traits: AccessibilityTraits) -> ModifiedContent<Self, AccessibilityAttachmentModifier> { fatalError() }
}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
extension View {

    /// Conditionally prevents interactive dismissal of presentations like
    /// popovers, sheets, and inspectors.
    ///
    /// Users can dismiss certain kinds of presentations using built-in
    /// gestures. In particular, a user can dismiss a sheet by dragging it down,
    /// or a popover by clicking or tapping outside of the presented view. Use
    /// the `interactiveDismissDisabled(_:)` modifier to conditionally prevent
    /// this kind of dismissal. You typically do this to prevent the user from
    /// dismissing a presentation before providing needed data or completing
    /// a required action.
    ///
    /// For instance, suppose you have a view that displays a licensing
    /// agreement that the user must acknowledge before continuing:
    ///
    ///     struct TermsOfService: View {
    ///         @Binding var areTermsAccepted: Bool
    ///         @Environment(\.dismiss) private var dismiss
    ///
    ///         var body: some View {
    ///             Form {
    ///                 Text("License Agreement")
    ///                     .font(.title)
    ///                 Text("Terms and conditions go here.")
    ///                 Button("Accept") {
    ///                     areTermsAccepted = true
    ///                     dismiss()
    ///                 }
    ///             }
    ///         }
    ///     }
    ///
    /// If you present this view in a sheet, the user can dismiss it by either
    /// tapping the button --- which calls ``EnvironmentValues/dismiss``
    /// from its `action` closure --- or by dragging the sheet down. To
    /// ensure that the user accepts the terms by tapping the button,
    /// disable interactive dismissal, conditioned on the `areTermsAccepted`
    /// property:
    ///
    ///     struct ContentView: View {
    ///         @State private var isSheetPresented = false
    ///         @State private var areTermsAccepted = false
    ///
    ///         var body: some View {
    ///             Button("Use Service") {
    ///                 isSheetPresented = true
    ///             }
    ///             .sheet(isPresented: $isSheetPresented) {
    ///                 TermsOfService()
    ///                     .interactiveDismissDisabled(!areTermsAccepted)
    ///             }
    ///         }
    ///     }
    ///
    /// You can apply the modifier to any view in the sheet's view hierarchy,
    /// including to the sheet's top level view, as the example demonstrates,
    /// or to any child view, like the ``Form`` or the Accept ``Button``.
    ///
    /// The modifier has no effect on programmatic dismissal, which you can
    /// invoke by updating the ``Binding`` that controls the presentation, or
    /// by calling the environment's ``EnvironmentValues/dismiss`` action.
    /// On macOS, disabling interactive dismissal in a popover makes the popover
    /// nontransient.
    ///
    /// - Parameter isDisabled: A Boolean value that indicates whether to
    ///   prevent nonprogrammatic dismissal of the containing view hierarchy
    ///   when presented in a sheet or popover.
    public func interactiveDismissDisabled(_ isDisabled: Bool = true) -> some View { return never() }

}

@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
extension View {

    /// Links multiple accessibility elements so that the user can quickly
    /// navigate from one element to another, even when the elements are not near
    /// each other in the accessibility hierarchy.
    ///
    /// This can be useful to allow quickly jumping between content in a list and
    /// the same content shown in a detail view, for example. All elements marked
    /// with `accessibilityLinkedGroup` with the same namespace and identifier will be
    /// linked together.
    ///
    /// - Parameters:
    ///   - id: A hashable identifier used to separate sets of linked elements
    ///     within the same namespace. Elements with matching `namespace` and `id`
    ///     will be linked together.
    ///   - namespace: The namespace to use to organize linked accessibility
    ///     elements. All elements marked with `accessibilityLink` in this
    ///     namespace and with the specified `id` will be linked together.
    public func accessibilityLinkedGroup<ID>(id: ID, in namespace: Namespace.ID) -> some View where ID : Hashable { return never() }


    /// Pairs an accessibility element representing a label with the element
    /// for the matching content.
    ///
    /// Use `accessibilityLabeledPair` with a role of `AccessibilityLabeledPairRole.label`
    /// to identify the label, and a role of `AccessibilityLabeledPairRole.content`
    /// to identify the content.
    /// This improves the behavior of accessibility features such as VoiceOver
    /// when navigating such elements, allowing users to better understand the
    /// relationship between them.
    ///
    /// - Parameters:
    ///   - role: Determines whether this element should be used as the label
    ///     in the pair, or the content in the pair.
    ///   - id: The identifier for the label / content pair. Elements with
    ///     matching identifiers within the same namespace will be paired
    ///     together.
    ///   - namespace: The namespace used to organize label and content. Label
    ///     and content under the same namespace with matching identifiers will
    ///     be paired together.
    public func accessibilityLabeledPair<ID>(role: AccessibilityLabeledPairRole, id: ID, in namespace: Namespace.ID) -> some View where ID : Hashable { return never() }

}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
extension View {

    /// Replaces one or more accessibility elements for this view with new
    /// accessibility elements.
    ///
    /// You can make controls accessible by using a custom style. For example, a custom
    /// ``ToggleStyle`` that you create inherits the accessibility features of ``Toggle``
    /// automatically. When you can't use the parent view's accessibility elements, use the
    /// `accessibilityRepresentation(representation:)`
    /// modifier instead. This modifier replaces default accessibility elements with different accessibility
    /// elements that you provide. You use synthetic, non-visual accessibility elements to represent
    /// what the view displays.
    ///
    /// The example below makes a custom adjustable control accessible by explicitly
    /// defining the representation of its step increments using a ``Slider``:
    ///
    ///     var body: some View {
    ///         VStack {
    ///             SliderTrack(...) // Custom slider implementation.
    ///         }
    ///         .accessibilityRepresentation {
    ///             Slider(value: $value, in: 0...100) {
    ///                 Text("Label")
    ///             }
    ///         }
    ///     }
    ///
    /// SkipUI hides the view that you provide in the `representation` closure
    /// and makes it non-interactive. The framework uses it only to
    /// generate accessibility elements.
    ///
    /// - Parameter representation: A hidden view that the accessibility
    ///   system uses to generate accessibility elements.
    ///
    public func accessibilityRepresentation<V>(@ViewBuilder representation: () -> V) -> some View where V : View { return never() }


    /// Replaces the existing accessibility element's children with one or
    /// more new synthetic accessibility elements.
    ///
    /// Use this modifier to replace an existing element's children with one
    /// or more new synthetic accessibility elements you provide. This allows
    /// for synthetic, non-visual accessibility elements to be set as children
    /// of a visual accessibility element.
    ///
    /// SkipUI creates an accessibility container implicitly when needed.
    /// If an accessibility element already exists, the framework converts it
    /// into an accessibility container.
    ///
    /// In the  example below, a ``Canvas`` displays a graph of vertical bars that don't have any
    /// inherent accessibility elements. You make the view accessible by adding
    /// the ``accessibilityChildren(children:)`` modifier with views whose accessibility
    /// elements represent the values of each bar drawn in the canvas:
    ///
    ///     var body: some View {
    ///         Canvas { context, size in
    ///             // Draw Graph
    ///             for data in dataSet {
    ///                 let path = Path(
    ///                     roundedRect: CGRect(
    ///                         x: (size.width / CGFloat(dataSet.count))
    ///                         * CGFloat(data.week),
    ///                         y: 0,
    ///                         width: size.width / CGFloat(dataSet.count),
    ///                         height: CGFloat(data.lines),
    ///                     cornerRadius: 5)
    ///                 context.fill(path, with: .color(.blue))
    ///             }
    ///             // Draw Axis and Labels
    ///             ...
    ///         }
    ///         .accessibilityLabel("Lines of Code per Week")
    ///         .accessibilityChildren {
    ///             HStack {
    ///                 ForEach(dataSet) { data in
    ///                     RoundedRectangle(cornerRadius: 5)
    ///                         .accessibilityLabel("Week \(data.week)")
    ///                         .accessibilityValue("\(data.lines) lines")
    ///                 }
    ///             }
    ///         }
    ///     }
    ///
    /// SkipUI hides any views that you provide with the `children` parameter,
    /// then the framework uses the views to generate the accessibility elements.
    ///
    /// - Parameter children: A ``ViewBuilder`` that represents the replacement
    ///   child views the framework uses to generate accessibility elements.
    public func accessibilityChildren<V>(@ViewBuilder children: () -> V) -> some View where V : View { return never() }

}

@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension View {

    /// Sets the style for disclosure groups within this view.
    @available(iOS 16.0, macOS 13.0, *)
    @available(tvOS, unavailable)
    @available(watchOS, unavailable)
    public func disclosureGroupStyle<S>(_ style: S) -> some View where S : DisclosureGroupStyle { return never() }

}

@available(iOS 17.0, macOS 14.0, *)
@available(watchOS, unavailable)
@available(tvOS, unavailable)
extension View {

    /// Controls the visibility of a `Table`'s column header views.
    ///
    /// By default, `Table` will display a global header view with the labels
    /// of each table column. This area is also where users can sort, resize,
    /// and rearrange the columns. For simple cases that don't require those
    /// features, this header can be hidden.
    ///
    /// This will not affect the header of any `Section`s in a table.
    ///
    ///     Table(article.authors) {
    ///         TableColumn("Name", value: \.name)
    ///         TableColumn("Title", value: \.title)
    ///     }
    ///     .tableColumnHeaders(.hidden)
    ///
    /// - Parameter visibility: A value of `visible` will show table columns,
    ///   `hidden` will remove them, and `automatic` will defer to default
    ///   behavior.
    public func tableColumnHeaders(_ visibility: Visibility) -> some View { return never() }

}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension View {

    /// Rotates this view's rendered output in three dimensions around the given
    /// axis of rotation.
    ///
    /// Use `rotation3DEffect(_:axis:anchor:anchorZ:perspective:)` to rotate the
    /// view in three dimensions around the given axis of rotation, and
    /// optionally, position the view at a custom display order and perspective.
    ///
    /// In the example below, the text is rotated 45˚ about the `y` axis,
    /// front-most (the default `zIndex`) and default `perspective` (`1`):
    ///
    ///     Text("Rotation by passing an angle in degrees")
    ///         .rotation3DEffect(.degrees(45), axis: (x: 0.0, y: 1.0, z: 0.0))
    ///         .border(Color.gray)
    ///
    /// ![A screenshot showing the rotation of text 45 degrees about the
    /// y-axis.](SkipUI-View-rotation3DEffect.png)
    ///
    /// - Parameters:
    ///   - angle: The angle at which to rotate the view.
    ///   - axis: The `x`, `y` and `z` elements that specify the axis of
    ///     rotation.
    ///   - anchor: The location with a default of ``UnitPoint/center`` that
    ///     defines a point in 3D space about which the rotation is anchored.
    ///   - anchorZ: The location with a default of `0` that defines a point in
    ///     3D space about which the rotation is anchored.
    ///   - perspective: The relative vanishing point with a default of `1` for
    ///     this rotation.
    @inlinable public func rotation3DEffect(_ angle: Angle, axis: (x: CGFloat, y: CGFloat, z: CGFloat), anchor: UnitPoint = .center, anchorZ: CGFloat = 0, perspective: CGFloat = 1) -> some View { return never() }

}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension View {

    /// Transforms the environment value of the specified key path with the
    /// given function.
    @inlinable public func transformEnvironment<V>(_ keyPath: WritableKeyPath<EnvironmentValues, V>, transform: @escaping (inout V) -> Void) -> some View { return never() }

}

extension View {

    @available(iOS 17.0, xrOS 1.0, *)
    @available(macOS, unavailable)
    @available(watchOS, unavailable)
    @available(tvOS, unavailable)
    public func searchDictationBehavior(_ dictationBehavior: TextInputDictationBehavior) -> some View { return never() }

}

@available(iOS 15.0, macOS 12.0, *)
@available(watchOS, unavailable)
@available(tvOS, unavailable)
extension View {

    /// Generates a badge for the view from an integer value.
    ///
    /// Use a badge to convey optional, supplementary information about a
    /// view. Keep the contents of the badge as short as possible. Badges
    /// appear only in list rows, tab bars, and menus.
    ///
    /// The following example shows a ``List`` with the value of `recentItems.count`
    /// represented by a badge on one of the rows:
    ///
    ///     List {
    ///         Text("Recents")
    ///             .badge(recentItems.count)
    ///         Text("Favorites")
    ///     }
    ///
    /// ![A table with two rows, titled Recents and Favorites. The first row
    /// shows the number 10 at the trailing side of the row
    ///  cell.](View-badge-1)
    ///
    /// - Parameter count: An integer value to display in the badge.
    ///   Set the value to zero to hide the badge.
    public func badge(_ count: Int) -> some View { return never() }


    /// Generates a badge for the view from a text view.
    ///
    /// Use a badge to convey optional, supplementary information about a
    /// view. Keep the contents of the badge as short as possible. Badges
    /// appear only in list rows, tab bars, and menus.
    ///
    /// Use this initializer when you want to style a ``Text`` view for use as a
    /// badge. The following example customizes the badge with the
    /// ``Text/monospacedDigit()``, ``Text/foregroundColor(_:)``, and
    /// ``Text/bold()`` modifiers.
    ///
    ///     var body: some View {
    ///         let badgeView = Text("\(recentItems.count)")
    ///             .monospacedDigit()
    ///             .foregroundColor(.red)
    ///             .bold()
    ///
    ///         List {
    ///             Text("Recents")
    ///                 .badge(badgeView)
    ///             Text("Favorites")
    ///         }
    ///     }
    ///
    /// ![A table with two rows, titled Recents and Favorites. The first row
    /// shows the number 21 at the side of the row cell. The number badge
    /// appears in bold red text with monospaced digits.](View-badge-2)
    ///
    /// Styling the text view has no effect when the badge appears in
    /// a ``TabView``.
    ///
    /// - Parameter label: An optional ``Text`` view to display as a badge.
    ///   Set the value to `nil` to hide the badge.
    public func badge(_ label: Text?) -> some View { return never() }


    /// Generates a badge for the view from a localized string key.
    ///
    /// Use a badge to convey optional, supplementary information about a
    /// view. Keep the contents of the badge as short as possible. Badges
    /// appear only in list rows, tab bars, and menus.
    ///
    /// This modifier creates a ``Text`` view on your behalf, and treats the
    /// localized key similar to ``Text/init(_:tableName:bundle:comment:)``. For
    /// more information about localizing strings, see ``Text``. The following
    /// example shows a list with a "Default" badge on one of its rows.
    ///
    ///     NavigationView {
    ///         List(servers) { server in
    ///             Text(server.name)
    ///                 .badge(server.isDefault ? "Default" : nil)
    ///         }
    ///         .navigationTitle("Servers")
    ///     }
    ///
    /// ![A table with the navigation title Servers and four rows: North 1,
    /// North 2, East 1, and South 1. The North 2 row shows a badge with the
    /// text Default on its trailing side.](View-badge-3)
    ///
    /// - Parameter key: An optional string key to display as a badge.
    ///   Set the value to `nil` to hide the badge.
    public func badge(_ key: LocalizedStringKey?) -> some View { return never() }


    /// Generates a badge for the view from a string.
    ///
    /// Use a badge to convey optional, supplementary information about a
    /// view. Keep the contents of the badge as short as possible. Badges
    /// appear only in list rows, tab bars, and menus.
    ///
    /// This modifier creates a ``Text`` view on your behalf, and treats the
    /// localized key similar to ``Text/init(_:)-9d1g4``. The following
    /// example shows a list with a "Default" badge on one of its rows.
    ///
    ///     NavigationView {
    ///         List(servers) { server in
    ///             Text(server.name)
    ///                 .badge(server.defaultString())
    ///         }
    ///         .navigationTitle("Servers")
    ///     }
    ///
    /// ![A table with the navigation title Servers and four rows: North 1,
    /// North 2, East 1, and South 1. The North 2 row shows a badge with the
    /// text Default on its trailing side.](View-badge-3)
    ///
    /// - Parameter label: An optional string to display as a badge.
    ///   Set the value to `nil` to hide the badge.
    public func badge<S>(_ label: S?) -> some View where S : StringProtocol { return never() }

}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension View {

    /// Adds an accessibility scroll action to the view. Actions allow
    /// assistive technologies, such as the VoiceOver, to interact with the
    /// view by invoking the action.
    ///
    /// For example, this is how a scroll action to trigger
    /// a refresh could be added to a view.
    ///
    ///     var body: some View {
    ///         ScrollView {
    ///             ContentView()
    ///         }
    ///         .accessibilityScrollAction { edge in
    ///             if edge == .top {
    ///                 // Refresh content
    ///             }
    ///         }
    ///     }
    ///
    public func accessibilityScrollAction(_ handler: @escaping (Edge) -> Void) -> ModifiedContent<Self, AccessibilityAttachmentModifier> { fatalError() }
}

extension View {

    /// Sets this view's color scheme.
    ///
    /// Use `colorScheme(_:)` to set the color scheme for the view to which you
    /// apply it and any subviews. If you want to set the color scheme for all
    /// views in the presentation, use ``View/preferredColorScheme(_:)``
    /// instead.
    ///
    /// - Parameter colorScheme: The color scheme for this view.
    ///
    /// - Returns: A view that sets this view's color scheme.
    @available(iOS, introduced: 13.0, deprecated: 100000.0, renamed: "preferredColorScheme(_:)")
    @available(macOS, introduced: 10.15, deprecated: 100000.0, renamed: "preferredColorScheme(_:)")
    @available(tvOS, introduced: 13.0, deprecated: 100000.0, renamed: "preferredColorScheme(_:)")
    @available(watchOS, introduced: 6.0, deprecated: 100000.0, renamed: "preferredColorScheme(_:)")
    @available(xrOS, introduced: 1.0, deprecated: 100000.0, renamed: "preferredColorScheme(_:)")
    @inlinable public func colorScheme(_ colorScheme: ColorScheme) -> some View { return never() }

}

extension View {

    /// Assigns a name to the view's coordinate space, so other code can operate
    /// on dimensions like points and sizes relative to the named space.
    ///
    /// Use `coordinateSpace(name:)` to allow another function to find and
    /// operate on a view and operate on dimensions relative to that view.
    ///
    /// The example below demonstrates how a nested view can find and operate on
    /// its enclosing view's coordinate space:
    ///
    ///     struct ContentView: View {
    ///         @State private var location = CGPoint.zero
    ///
    ///         var body: some View {
    ///             VStack {
    ///                 Color.red.frame(width: 100, height: 100)
    ///                     .overlay(circle)
    ///                 Text("Location: \(Int(location.x)), \(Int(location.y))")
    ///             }
    ///             .coordinateSpace(name: "stack")
    ///         }
    ///
    ///         var circle: some View {
    ///             Circle()
    ///                 .frame(width: 25, height: 25)
    ///                 .gesture(drag)
    ///                 .padding(5)
    ///         }
    ///
    ///         var drag: some Gesture {
    ///             DragGesture(coordinateSpace: .named("stack"))
    ///                 .onChanged { info in location = info.location }
    ///         }
    ///     }
    ///
    /// Here, the ``VStack`` in the `ContentView` named “stack” is composed of a
    /// red frame with a custom ``Circle`` view ``View/overlay(_:alignment:)``
    /// at its center.
    ///
    /// The `circle` view has an attached ``DragGesture`` that targets the
    /// enclosing VStack's coordinate space. As the gesture recognizer's closure
    /// registers events inside `circle` it stores them in the shared `location`
    /// state variable and the ``VStack`` displays the coordinates in a ``Text``
    /// view.
    ///
    /// ![A screenshot showing an example of finding a named view and tracking
    /// relative locations in that view.](SkipUI-View-coordinateSpace.png)
    ///
    /// - Parameter name: A name used to identify this coordinate space.
    @available(iOS, introduced: 13.0, deprecated: 100000.0, message: "use coordinateSpace(_:) instead")
    @available(macOS, introduced: 10.15, deprecated: 100000.0, message: "use coordinateSpace(_:) instead")
    @available(tvOS, introduced: 13.0, deprecated: 100000.0, message: "use coordinateSpace(_:) instead")
    @available(watchOS, introduced: 6.0, deprecated: 100000.0, message: "use coordinateSpace(_:) instead")
    @available(xrOS, introduced: 1.0, deprecated: 100000.0, message: "use coordinateSpace(_:) instead")
    @inlinable public func coordinateSpace<T>(name: T) -> some View where T : Hashable { return never() }

}

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension View {

    /// Assigns a name to the view's coordinate space, so other code can operate
    /// on dimensions like points and sizes relative to the named space.
    ///
    /// Use `coordinateSpace(_:)` to allow another function to find and
    /// operate on a view and operate on dimensions relative to that view.
    ///
    /// The example below demonstrates how a nested view can find and operate on
    /// its enclosing view's coordinate space:
    ///
    ///     struct ContentView: View {
    ///         @State private var location = CGPoint.zero
    ///
    ///         var body: some View {
    ///             VStack {
    ///                 Color.red.frame(width: 100, height: 100)
    ///                     .overlay(circle)
    ///                 Text("Location: \(Int(location.x)), \(Int(location.y))")
    ///             }
    ///             .coordinateSpace(.named("stack"))
    ///         }
    ///
    ///         var circle: some View {
    ///             Circle()
    ///                 .frame(width: 25, height: 25)
    ///                 .gesture(drag)
    ///                 .padding(5)
    ///         }
    ///
    ///         var drag: some Gesture {
    ///             DragGesture(coordinateSpace: .named("stack"))
    ///                 .onChanged { info in location = info.location }
    ///         }
    ///     }
    ///
    /// Here, the ``VStack`` in the `ContentView` named “stack” is composed of a
    /// red frame with a custom ``Circle`` view ``View/overlay(_:alignment:)``
    /// at its center.
    ///
    /// The `circle` view has an attached ``DragGesture`` that targets the
    /// enclosing VStack's coordinate space. As the gesture recognizer's closure
    /// registers events inside `circle` it stores them in the shared `location`
    /// state variable and the ``VStack`` displays the coordinates in a ``Text``
    /// view.
    ///
    /// ![A screenshot showing an example of finding a named view and tracking
    /// relative locations in that view.](SkipUI-View-coordinateSpace.png)
    ///
    /// - Parameter name: A name used to identify this coordinate space.
    public func coordinateSpace(_ name: NamedCoordinateSpace) -> some View { return never() }

}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension View {

    /// Defines the content shape for hit testing.
    ///
    /// - Parameters:
    ///   - shape: The hit testing shape for the view.
    ///   - eoFill: A Boolean that indicates whether the shape is interpreted
    ///     with the even-odd winding number rule.
    ///
    /// - Returns: A view that uses the given shape for hit testing.
    @inlinable public func contentShape<S>(_ shape: S, eoFill: Bool = false) -> some View where S : Shape { return never() }

}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension View {

    /// Sets a value for the given preference.
    @inlinable public func preference<K>(key: K.Type = K.self, value: K.Value) -> some View where K : PreferenceKey { return never() }

}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension View {

    /// Applies the given transaction mutation function to all animations used
    /// within the view.
    ///
    /// Use this modifier to change or replace the animation used in a view.
    /// Consider three identical animations controlled by a
    /// button that executes all three animations simultaneously:
    ///
    ///  * The first animation rotates the "Rotation" ``Text`` view by 360
    ///    degrees.
    ///  * The second uses the `transaction(_:)` modifier to change the
    ///    animation by adding a delay to the start of the animation
    ///    by two seconds and then increases the rotational speed of the
    ///    "Rotation\nModified" ``Text`` view animation by a factor of 2.
    ///  * The third animation uses the `transaction(_:)` modifier to
    ///    replace the rotation animation affecting the "Animation\nReplaced"
    ///    ``Text`` view with a spring animation.
    ///
    /// The following code implements these animations:
    ///
    ///     struct TransactionExample: View {
    ///         @State private var flag = false
    ///
    ///         var body: some View {
    ///             VStack(spacing: 50) {
    ///                 HStack(spacing: 30) {
    ///                     Text("Rotation")
    ///                         .rotationEffect(Angle(degrees:
    ///                                                 self.flag ? 360 : 0))
    ///
    ///                     Text("Rotation\nModified")
    ///                         .rotationEffect(Angle(degrees:
    ///                                                 self.flag ? 360 : 0))
    ///                         .transaction { view in
    ///                             view.animation =
    ///                                 view.animation?.delay(2.0).speed(2)
    ///                         }
    ///
    ///                     Text("Animation\nReplaced")
    ///                         .rotationEffect(Angle(degrees:
    ///                                                 self.flag ? 360 : 0))
    ///                         .transaction { view in
    ///                             view.animation = .interactiveSpring(
    ///                                 response: 0.60,
    ///                                 dampingFraction: 0.20,
    ///                                 blendDuration: 0.25)
    ///                         }
    ///                 }
    ///
    ///                 Button("Animate") {
    ///                     withAnimation(.easeIn(duration: 2.0)) {
    ///                         self.flag.toggle()
    ///                     }
    ///                 }
    ///             }
    ///         }
    ///     }
    ///
    /// Use this modifier on leaf views such as ``Image`` or ``Button`` rather
    /// than container views such as ``VStack`` or ``HStack``. The
    /// transformation applies to all child views within this view; calling
    /// `transaction(_:)` on a container view can lead to unbounded scope of
    /// execution depending on the depth of the view hierarchy.
    ///
    /// - Parameter transform: The transformation to apply to transactions
    ///   within this view.
    ///
    /// - Returns: A view that wraps this view and applies a transformation to
    ///   all transactions used within the view.
    @inlinable public func transaction(_ transform: @escaping (inout Transaction) -> Void) -> some View { return never() }


    /// Applies the given transaction mutation function to all animations used
    /// within the view.
    ///
    /// Use this modifier to change or replace the animation used in a view.
    /// Consider three identical views controlled by a
    /// button that changes all three simultaneously:
    ///
    ///  * The first view animates rotating the "Rotation" ``Text`` view by 360
    ///    degrees.
    ///  * The second uses the `transaction(_:)` modifier to change the
    ///    animation by adding a delay to the start of the animation
    ///    by two seconds and then increases the rotational speed of the
    ///    "Rotation\nModified" ``Text`` view animation by a factor of 2.
    ///  * The third uses the `transaction(_:)` modifier to disable animations
    ///    affecting the "Animation\nReplaced" ``Text`` view.
    ///
    /// The following code implements these animations:
    ///
    ///     struct TransactionExample: View {
    ///         @State var flag = false
    ///
    ///         var body: some View {
    ///             VStack(spacing: 50) {
    ///                 HStack(spacing: 30) {
    ///                     Text("Rotation")
    ///                         .rotationEffect(Angle(degrees: flag ? 360 : 0))
    ///
    ///                     Text("Rotation\nModified")
    ///                         .rotationEffect(Angle(degrees: flag ? 360 : 0))
    ///                         .transaction(value: flag) { t in
    ///                             t.animation =
    ///                                 t.animation?.delay(2.0).speed(2)
    ///                         }
    ///
    ///                     Text("Animation\nReplaced")
    ///                         .rotationEffect(Angle(degrees: flag ? 360 : 0))
    ///                         .transaction(value: flag) { t in
    ///                             t.disableAnimations = true
    ///                         }
    ///                 }
    ///
    ///                 Button("Animate") {
    ///                     withAnimation(.easeIn(duration: 2.0)) {
    ///                         flag.toggle()
    ///                     }
    ///                 }
    ///             }
    ///         }
    ///     }
    ///
    /// - Parameters:
    ///   - value: A value to monitor for changes.
    ///   - transform: The transformation to apply to transactions
    ///     within this view.
    ///
    /// - Returns: A view that wraps this view and applies a transformation to
    ///   all transactions used within the view whenever `value` changes.
    @available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
    public func transaction(value: some Equatable, _ transform: @escaping (inout Transaction) -> Void) -> some View { return never() }


    /// Applies the given animation to all animatable values within this view.
    ///
    /// Use this modifier on leaf views rather than container views. The
    /// animation applies to all child views within this view; calling
    /// `animation(_:)` on a container view can lead to unbounded scope.
    ///
    /// - Parameter animation: The animation to apply to animatable values
    ///   within this view.
    ///
    /// - Returns: A view that wraps this view and applies `animation` to all
    ///   animatable values used within the view.
    @available(iOS, introduced: 13.0, deprecated: 15.0, message: "Use withAnimation or animation(_:value:) instead.")
    @available(macOS, introduced: 10.15, deprecated: 12.0, message: "Use withAnimation or animation(_:value:) instead.")
    @available(tvOS, introduced: 13.0, deprecated: 15.0, message: "Use withAnimation or animation(_:value:) instead.")
    @available(watchOS, introduced: 6.0, deprecated: 8.0, message: "Use withAnimation or animation(_:value:) instead.")
    @available(xrOS, introduced: 1.0, deprecated: 1.0, message: "Use withAnimation or animation(_:value:) instead.")
    @inlinable public func animation(_ animation: Animation?) -> some View { return never() }

}

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension View {

    /// Applies the given transaction mutation function to all animations used
    /// within the `body` closure.
    ///
    /// Any modifiers applied to the content of `body` will be applied to this
    /// view, and the changes to the transaction performed in the `transform`
    /// will only affect the modifiers defined in the `body`.
    ///
    /// The following code animates the opacity changing with a faster
    /// animation, while the contents of MyView are animated with the implicit
    /// transaction:
    ///
    ///     MyView(isActive: isActive)
    ///         .transaction { transaction in
    ///             transaction.animation = transaction.animation?.speed(2)
    ///         } body: { content in
    ///             content.opacity(isActive ? 1.0 : 0.0)
    ///         }
    ///
    /// - See Also: `Transaction.disablesAnimations`
    public func transaction<V>(_ transform: @escaping (inout Transaction) -> Void, @ViewBuilder body: (PlaceholderContentView<Self>) -> V) -> some View where V : View { return never() }


    /// Applies the given animation to all animatable values within the `body`
    /// closure.
    ///
    /// Any modifiers applied to the content of `body` will be applied to this
    /// view, and the `animation` will only be used on the modifiers defined in
    /// the `body`.
    ///
    /// The following code animates the opacity changing with an easeInOut
    /// animation, while the contents of MyView are animated with the implicit
    /// transaction's animation:
    ///
    ///     MyView(isActive: isActive)
    ///         .animation(.easeInOut) { content in
    ///             content.opacity(isActive ? 1.0 : 0.0)
    ///         }
    public func animation<V>(_ animation: Animation?, @ViewBuilder body: (PlaceholderContentView<Self>) -> V) -> some View where V : View { return never() }

}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension View {

    /// Creates a new accessibility element, or modifies the
    /// ``AccessibilityChildBehavior`` of the existing accessibility element.
    ///
    /// See also:
    /// - ``AccessibilityChildBehavior/ignore``
    /// - ``AccessibilityChildBehavior/combine``
    /// - ``AccessibilityChildBehavior/contain``
    ///
    /// - Parameters:
    ///     -   children: The behavior to use when creating or
    ///     transforming an accessibility element.
    ///     The default is ``AccessibilityChildBehavior/ignore``
    public func accessibilityElement(children: AccessibilityChildBehavior = .ignore) -> some View { return never() }

}

@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
extension View {

    /// Advertises a user activity type.
    ///
    /// You can use `userActivity(_:isActive:_:)` to start, stop, or modify the
    /// advertisement of a specific type of user activity.
    ///
    /// The scope of the activity applies only to the scene or window the
    /// view is in.
    ///
    /// - Parameters:
    ///   - activityType: The type of activity to advertise.
    ///   - isActive: When `false`, avoids advertising the activity. Defaults
    ///     to `true`.
    ///   - update: A function that modifies the passed-in activity for
    ///     advertisement.
    public func userActivity(_ activityType: String, isActive: Bool = true, _ update: @escaping (NSUserActivity) -> ()) -> some View { return never() }


    /// Advertises a user activity type.
    ///
    /// The scope of the activity applies only to the scene or window the
    /// view is in.
    ///
    /// - Parameters:
    ///   - activityType: The type of activity to advertise.
    ///   - element: If the element is `nil`, the handler will not be
    ///     associated with the activity (and if there are no handlers, no
    ///     activity is advertised). The method passes the non-`nil` element to
    ///     the handler as a convenience so the handlers don't all need to
    ///     implement an early exit with
    ///     `guard element = element else { return }`.
    ///    - update: A function that modifies the passed-in activity for
    ///    advertisement.
    public func userActivity<P>(_ activityType: String, element: P?, _ update: @escaping (P, NSUserActivity) -> ()) -> some View { return never() }


    /// Registers a handler to invoke when the view receives the specified
    /// activity type for the scene or window the view is in.
    ///
    /// - Parameters:
    ///   - activityType: The type of activity to handle.
    ///   - action: A function to call that takes a
    ///
    ///     object as its parameter
    ///     when delivering the activity to the scene or window the view is in.
    public func onContinueUserActivity(_ activityType: String, perform action: @escaping (NSUserActivity) -> ()) -> some View { return never() }


    /// Registers a handler to invoke when the view receives a url for the
    /// scene or window the view is in.
    ///
    /// > Note: This method handles the reception of Universal Links,
    ///   rather than a
    ///   .
    ///
    /// - Parameter action: A function that takes a
    ///
    ///  object as its parameter when delivering the URL to the scene or window
    ///  the view is in.
    public func onOpenURL(perform action: @escaping (URL) -> ()) -> some View { return never() }

}

@available(iOS 14.0, macOS 11.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension View {

    /// Specifies a modifier indicating the Scene this View
    /// is in can handle matching incoming External Events.
    ///
    /// If no modifier is set in any Views within a Scene, the behavior
    /// is platform dependent. On macOS, a new Scene will be created to
    /// use for the External Event. On iOS, the system will choose an
    /// existing Scene to use.
    ///
    /// On platforms that only allow a single Window/Scene, this method is
    /// ignored, and incoming External Events are always routed to the
    /// existing single Scene.
    ///
    /// - Parameter preferring: A Set of Strings that are checked to see
    /// if they are contained in the targetContentIdenfifier to see if
    /// the Scene this View is in prefers to handle the Exernal Event.
    /// The empty Set and empty Strings never match. The String value
    /// "*" always matches. The String comparisons are case/diacritic
    /// insensitive
    ///
    /// - Parameter allowing: A Set of Strings that are checked to see
    /// if they are contained in the targetContentIdenfifier to see if
    /// the Scene this View is in allows handling the External Event.
    /// The empty Set and empty Strings never match. The String value
    /// "*" always matches.
    public func handlesExternalEvents(preferring: Set<String>, allowing: Set<String>) -> some View { return never() }

}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension View {

    /// Sets the style for text fields within this view.
    public func textFieldStyle<S>(_ style: S) -> some View where S : TextFieldStyle { return never() }

}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
extension View {

    /// Masks this view using the alpha channel of the given view.
    ///
    /// Use `mask(_:)` when you want to apply the alpha (opacity) value of
    /// another view to the current view.
    ///
    /// This example shows an image masked by rectangle with a 10% opacity:
    ///
    ///     Image(systemName: "envelope.badge.fill")
    ///         .foregroundColor(Color.blue)
    ///         .font(.system(size: 128, weight: .regular))
    ///         .mask {
    ///             Rectangle().opacity(0.1)
    ///         }
    ///
    /// ![A screenshot of a view masked by a rectangle with 10%
    /// opacity.](SkipUI-View-mask.png)
    ///
    /// - Parameters:
    ///     - alignment: The alignment for `mask` in relation to this view.
    ///     - mask: The view whose alpha the rendering system applies to
    ///       the specified view.
    @inlinable public func mask<Mask>(alignment: Alignment = .center, @ViewBuilder _ mask: () -> Mask) -> some View where Mask : View { return never() }

}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension View {

    /// Masks this view using the alpha channel of the given view.
    ///
    /// Use `mask(_:)` when you want to apply the alpha (opacity) value of
    /// another view to the current view.
    ///
    /// This example shows an image masked by rectangle with a 10% opacity:
    ///
    ///     Image(systemName: "envelope.badge.fill")
    ///         .foregroundColor(Color.blue)
    ///         .font(.system(size: 128, weight: .regular))
    ///         .mask(Rectangle().opacity(0.1))
    ///
    /// ![A screenshot of a view masked by a rectangle with 10%
    /// opacity.](SkipUI-View-mask.png)
    ///
    /// - Parameter mask: The view whose alpha the rendering system applies to
    ///   the specified view.
    @available(iOS, deprecated: 100000.0, message: "Use overload where mask accepts a @ViewBuilder instead.")
    @available(macOS, deprecated: 100000.0, message: "Use overload where mask accepts a @ViewBuilder instead.")
    @available(tvOS, deprecated: 100000.0, message: "Use overload where mask accepts a @ViewBuilder instead.")
    @available(watchOS, deprecated: 100000.0, message: "Use overload where mask accepts a @ViewBuilder instead.")
    @available(xrOS, deprecated: 100000.0, message: "Use overload where mask accepts a @ViewBuilder instead.")
    @inlinable public func mask<Mask>(_ mask: Mask) -> some View where Mask : View { return never() }

}

@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
extension View {

    /// Configures the view's title for purposes of navigation.
    ///
    /// A view's navigation title is used to visually display
    /// the current navigation state of an interface.
    /// On iOS and watchOS, when a view is navigated to inside
    /// of a navigation view, that view's title is displayed
    /// in the navigation bar. On iPadOS, the primary destination's
    /// navigation title is reflected as the window's title in the
    /// App Switcher. Similarly on macOS, the primary destination's title
    /// is used as the window title in the titlebar, Windows menu
    /// and Mission Control.
    ///
    /// Refer to the <doc:Configure-Your-Apps-Navigation-Titles> article
    /// for more information on navigation title modifiers.
    ///
    /// - Parameter title: The title to display.
    public func navigationTitle(_ title: Text) -> some View { return never() }


    /// Configures the view's title for purposes of navigation,
    /// using a localized string.
    ///
    /// A view's navigation title is used to visually display
    /// the current navigation state of an interface.
    /// On iOS and watchOS, when a view is navigated to inside
    /// of a navigation view, that view's title is displayed
    /// in the navigation bar. On iPadOS, the primary destination's
    /// navigation title is reflected as the window's title in the
    /// App Switcher. Similarly on macOS, the primary destination's title
    /// is used as the window title in the titlebar, Windows menu
    /// and Mission Control.
    ///
    /// Refer to the <doc:Configure-Your-Apps-Navigation-Titles> article
    /// for more information on navigation title modifiers.
    ///
    /// - Parameter titleKey: The key to a localized string to display.
    public func navigationTitle(_ titleKey: LocalizedStringKey) -> some View { return never() }


    /// Configures the view's title for purposes of navigation, using a string.
    ///
    /// A view's navigation title is used to visually display
    /// the current navigation state of an interface.
    /// On iOS and watchOS, when a view is navigated to inside
    /// of a navigation view, that view's title is displayed
    /// in the navigation bar. On iPadOS, the primary destination's
    /// navigation title is reflected as the window's title in the
    /// App Switcher. Similarly on macOS, the primary destination's title
    /// is used as the window title in the titlebar, Windows menu
    /// and Mission Control.
    ///
    /// Refer to the <doc:Configure-Your-Apps-Navigation-Titles> article
    /// for more information on navigation title modifiers.
    ///
    /// - Parameter title: The string to display.
    public func navigationTitle<S>(_ title: S) -> some View where S : StringProtocol { return never() }

}

extension View {

    /// Configures the view's title for purposes of navigation, using a string
    /// binding.
    ///
    /// In iOS, iPadOS, and macOS, this allows editing the navigation title
    /// when the title is displayed in the toolbar.
    ///
    /// Refer to the <doc:Configure-Your-Apps-Navigation-Titles> article
    /// for more information on navigation title modifiers.
    ///
    /// - Parameter title: The text of the title.
    @available(iOS 16.0, macOS 13.0, watchOS 9.0, tvOS 16.0, *)
    public func navigationTitle(_ title: Binding<String>) -> some View { return never() }

}

@available(iOS 14.0, watchOS 8.0, *)
@available(macOS, unavailable)
@available(tvOS, unavailable)
extension View {

    /// Configures the title display mode for this view.
    ///
    /// - Parameter displayMode: The style to use for displaying the title.
    public func navigationBarTitleDisplayMode(_ displayMode: NavigationBarItem.TitleDisplayMode) -> some View { return never() }

}

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension View {

    /// Sets the behavior of this view for different layout directions.
    ///
    /// Use `layoutDirectionBehavior(_:)` when you need the system to
    /// horizontally mirror the contents of the view when presented in a
    /// layout direction.
    ///
    /// To override the layout direction for a specific view, use the
    /// ``View/environment(_:_:)`` view modifier to explicitly override
    /// the ``EnvironmentValues/layoutDirection`` environment value for
    /// the view.
    ///
    /// - Parameter behavior: A LayoutDirectionBehavior value that indicates
    ///   whether this view should mirror in a particular layout direction. By
    ///   default, views will adjust their layouts automatically in a
    ///   right-to-left context and do not need to be mirrored.
    ///
    /// - Returns: A view that conditionally mirrors its contents
    ///   horizontally in a given layout direction.
    @inlinable public func layoutDirectionBehavior(_ behavior: LayoutDirectionBehavior) -> some View { return never() }

}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
extension View {

    /// Sets a view's foreground elements to use a given style.
    ///
    /// Use this method to style
    /// foreground content like text, shapes, and template images
    /// (including symbols):
    ///
    ///     HStack {
    ///         Image(systemName: "triangle.fill")
    ///         Text("Hello, world!")
    ///         RoundedRectangle(cornerRadius: 5)
    ///             .frame(width: 40, height: 20)
    ///     }
    ///     .foregroundStyle(.teal)
    ///
    /// The example above creates a row of ``ShapeStyle/teal`` foreground
    /// elements:
    ///
    /// ![A screenshot of a teal triangle, string, and rounded
    /// rectangle.](View-foregroundStyle-1)
    ///
    /// You can use any style that conforms to the ``ShapeStyle`` protocol,
    /// like the ``ShapeStyle/teal`` color in the example above, or the
    /// ``ShapeStyle/linearGradient(colors:startPoint:endPoint:)`` gradient
    /// shown below:
    ///
    ///     Text("Gradient Text")
    ///         .font(.largeTitle)
    ///         .foregroundStyle(
    ///             .linearGradient(
    ///                 colors: [.yellow, .blue],
    ///                 startPoint: .top,
    ///                 endPoint: .bottom
    ///             )
    ///         )
    ///
    /// ![A screenshot of the words Gradient Text, with letters that
    ///   appear yellow at the top, and transition to blue
    ///   toward the bottom.](View-foregroundStyle-2)
    ///
    /// > Tip: If you want to fill a single ``Shape`` instance with a style,
    /// use the ``Shape/fill(style:)`` shape modifier instead because it's more
    /// efficient.
    ///
    /// SkipUI creates a context-dependent render for a given style.
    /// For example, a ``Color`` that you load from an asset catalog
    /// can have different light and dark appearances, while some styles
    /// also vary by platform.
    ///
    /// Hierarchical foreground styles like ``ShapeStyle/secondary``
    /// don't impose a style of their own, but instead modify other styles.
    /// In particular, they modify the primary
    /// level of the current foreground style to the degree given by
    /// the hierarchical style's name.
    /// To find the current foreground style to modify, SkipUI looks for
    /// the innermost containing style that you apply with the
    /// `foregroundStyle(_:)` or the ``View/foregroundColor(_:)`` modifier.
    /// If you haven't specified a style, SkipUI uses the default foreground
    /// style, as in the following example:
    ///
    ///     VStack(alignment: .leading) {
    ///         Label("Primary", systemImage: "1.square.fill")
    ///         Label("Secondary", systemImage: "2.square.fill")
    ///             .foregroundStyle(.secondary)
    ///     }
    ///
    /// ![A screenshot of two labels with the text primary and secondary.
    /// The first appears in a brighter shade than the
    /// second, both in a grayscale color.](View-foregroundStyle-3)
    ///
    /// If you add a foreground style on the enclosing
    /// ``VStack``, the hierarchical styling responds accordingly:
    ///
    ///     VStack(alignment: .leading) {
    ///         Label("Primary", systemImage: "1.square.fill")
    ///         Label("Secondary", systemImage: "2.square.fill")
    ///             .foregroundStyle(.secondary)
    ///     }
    ///     .foregroundStyle(.blue)
    ///
    /// ![A screenshot of two labels with the text primary and secondary.
    /// The first appears in a brighter shade than the
    /// second, both tinted blue.](View-foregroundStyle-4)
    ///
    /// When you apply a custom style to a view, the view disables the vibrancy
    /// effect for foreground elements in that view, or in any of its child
    /// views, that it would otherwise gain from adding a background material
    /// --- for example, using the ``View/background(_:ignoresSafeAreaEdges:)``
    /// modifier. However, hierarchical styles applied to the default foreground
    /// don't disable vibrancy.
    ///
    /// - Parameter style: The color or pattern to use when filling in the
    ///   foreground elements. To indicate a specific value, use ``Color`` or
    ///   ``ShapeStyle/image(_:sourceRect:scale:)``, or one of the gradient
    ///   types, like
    ///   ``ShapeStyle/linearGradient(colors:startPoint:endPoint:)``. To set a
    ///   style that’s relative to the containing view's style, use one of the
    ///   semantic styles, like ``ShapeStyle/primary``.
    ///
    /// - Returns: A view that uses the given foreground style.
    @inlinable public func foregroundStyle<S>(_ style: S) -> some View where S : ShapeStyle { return never() }


    /// Sets the primary and secondary levels of the foreground
    /// style in the child view.
    ///
    /// SkipUI uses these styles when rendering child views
    /// that don't have an explicit rendering style, like images,
    /// text, shapes, and so on.
    ///
    /// Symbol images within the view hierarchy use the
    /// ``SymbolRenderingMode/palette`` rendering mode when you apply this
    /// modifier, if you don't explicitly specify another mode.
    ///
    /// - Parameters:
    ///   - primary: The primary color or pattern to use when filling in
    ///     the foreground elements. To indicate a specific value, use ``Color``
    ///     or ``ShapeStyle/image(_:sourceRect:scale:)``, or one of the gradient
    ///     types, like
    ///     ``ShapeStyle/linearGradient(colors:startPoint:endPoint:)``. To set a
    ///     style that’s relative to the containing view's style, use one of the
    ///     semantic styles, like ``ShapeStyle/primary``.
    ///   - secondary: The secondary color or pattern to use when
    ///     filling in the foreground elements.
    ///
    /// - Returns: A view that uses the given foreground styles.
    @inlinable public func foregroundStyle<S1, S2>(_ primary: S1, _ secondary: S2) -> some View where S1 : ShapeStyle, S2 : ShapeStyle { return never() }


    /// Sets the primary, secondary, and tertiary levels of
    /// the foreground style.
    ///
    /// SkipUI uses these styles when rendering child views
    /// that don't have an explicit rendering style, like images,
    /// text, shapes, and so on.
    ///
    /// Symbol images within the view hierarchy use the
    /// ``SymbolRenderingMode/palette`` rendering mode when you apply this
    /// modifier, if you don't explicitly specify another mode.
    ///
    /// - Parameters:
    ///   - primary: The primary color or pattern to use when filling in
    ///     the foreground elements. To indicate a specific value, use ``Color``
    ///     or ``ShapeStyle/image(_:sourceRect:scale:)``, or one of the gradient
    ///     types, like
    ///     ``ShapeStyle/linearGradient(colors:startPoint:endPoint:)``. To set a
    ///     style that’s relative to the containing view's style, use one of the
    ///     semantic styles, like ``ShapeStyle/primary``.
    ///   - secondary: The secondary color or pattern to use when
    ///     filling in the foreground elements.
    ///   - tertiary: The tertiary color or pattern to use when
    ///     filling in the foreground elements.
    ///
    /// - Returns: A view that uses the given foreground styles.
    @inlinable public func foregroundStyle<S1, S2, S3>(_ primary: S1, _ secondary: S2, _ tertiary: S3) -> some View where S1 : ShapeStyle, S2 : ShapeStyle, S3 : ShapeStyle { return never() }

}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension View {

    /// Adds an accessibility adjustable action to the view. Actions allow
    /// assistive technologies, such as the VoiceOver, to interact with the
    /// view by invoking the action.
    ///
    /// For example, this is how an adjustable action to navigate
    /// through pages could be added to a view.
    ///
    ///     var body: some View {
    ///         PageControl()
    ///             .accessibilityAdjustableAction { direction in
    ///                 switch direction {
    ///                 case .increment:
    ///                     // Go to next page
    ///                 case .decrement:
    ///                     // Go to previous page
    ///                 }
    ///             }
    ///     }
    ///
    public func accessibilityAdjustableAction(_ handler: @escaping (AccessibilityAdjustmentDirection) -> Void) -> ModifiedContent<Self, AccessibilityAttachmentModifier> { fatalError() }
}

@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
extension View {

    /// The default store used by `AppStorage` contained within the view.
    ///
    /// If unspecified, the default store for a view hierarchy is
    /// `UserDefaults.standard`, but can be set a to a custom one. For example,
    /// sharing defaults between an app and an extension can override the
    /// default store to one created with `UserDefaults.init(suiteName:_)`.
    ///
    /// - Parameter store: The user defaults to use as the default
    ///   store for `AppStorage`.
    public func defaultAppStorage(_ store: UserDefaults) -> some View { return never() }

}

extension View {

    /// Sets the preferred order of items for menus presented from this view.
    ///
    /// Use this modifier to override the default menu order. On supported
    /// platforms, ``MenuOrder/priority`` order keeps the first items closer
    /// to the user’s point of interaction, whereas ``MenuOrder/fixed`` order
    /// always orders items from top to bottom.
    ///
    /// On iOS, the ``MenuOrder/automatic`` order resolves to
    /// ``MenuOrder/fixed`` for menus presented within scrollable content.
    /// Pickers that use the ``PickerStyle/menu`` style also default to
    /// ``MenuOrder/fixed`` order. In all other cases, menus default to
    /// ``MenuOrder/priority`` order.
    ///
    /// On macOS, tvOS and watchOS, the ``MenuOrder/automatic`` order always
    /// resolves to ``MenuOrder/fixed`` order.
    ///
    /// The following example creates a menu that presents its content in a
    /// fixed order from top to bottom:
    ///
    ///     Menu {
    ///         Button("Select", action: selectFolders)
    ///         Button("New Folder", action: createFolder)
    ///         Picker("Appearance", selection: $appearance) {
    ///             Label("Icons", systemImage: "square.grid.2x2").tag(Appearance.icons)
    ///             Label("List", systemImage: "list.bullet").tag(Appearance.list)
    ///         }
    ///     } label: {
    ///         Label("Settings", systemImage: "ellipsis.circle")
    ///     }
    ///     .menuOrder(.fixed)
    ///
    /// You can use this modifier on controls that present a menu.
    /// For example, the code below creates a ``Picker`` using the
    /// ``PickerStyle/menu`` style with a priority-based order:
    ///
    ///     Picker("Flavor", selection: $selectedFlavor) {
    ///         Text("Chocolate").tag(Flavor.chocolate)
    ///         Text("Vanilla").tag(Flavor.vanilla)
    ///         Text("Strawberry").tag(Flavor.strawberry)
    ///     }
    ///     .pickerStyle(.menu)
    ///     .menuOrder(.priority)
    ///
    /// You can also use this modifier on context menus. The example below
    /// creates a context menu that presents its content in a fixed order:
    ///
    ///     Text("Favorite Card Suit")
    ///         .padding()
    ///         .contextMenu {
    ///             Button("♥️ - Hearts", action: selectHearts)
    ///             Button("♣️ - Clubs", action: selectClubs)
    ///             Button("♠️ - Spades", action: selectSpades)
    ///             Button("♦️ - Diamonds", action: selectDiamonds)
    ///         }
    ///         .menuOrder(.fixed)
    ///
    /// The modifier has no effect when applied to a subsection or
    /// submenu of a menu.
    ///
    /// - Parameter order: The menu item ordering strategy to apply.
    ///
    /// - Returns: A view that uses the specified menu ordering strategy.
    @available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
    public func menuOrder(_ order: MenuOrder) -> some View { return never() }

}

@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
extension View {

    /// Sets the tint within this view.
    ///
    /// Use this method to override the default accent color for this view with
    /// a given styling. Unlike an app's accent color, which can be
    /// overridden by user preference, tint is always respected and should
    /// be used as a way to provide additional meaning to the control.
    ///
    /// Controls which are unable to style themselves using the given type of
    /// `ShapeStyle` will try to approximate the styling as best as they can
    /// (i.e. controls which can not style themselves using a gradient will
    /// attempt to use the color of the gradient's first stop).
    ///
    /// This example shows a linear dashboard styled gauge tinted with a
    /// gradient from  ``ShapeStyle/green`` to ``ShapeStyle/red``.
    ///
    ///     struct ControlTint: View {
    ///         var body: some View {
    ///             Gauge(value: 75, in: 0...100)
    ///                 .gaugeStyle(.linearDashboard)
    ///                 .tint(Gradient(colors: [.red, .yellow, .green]))
    ///         }
    ///     }
    ///
    /// - Parameter tint: The tint to apply.
    @inlinable public func tint<S>(_ tint: S?) -> some View where S : ShapeStyle { return never() }

}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
extension View {

    /// Sets the tint color within this view.
    ///
    /// Use this method to override the default accent color for this view.
    /// Unlike an app's accent color, which can be overridden by user
    /// preference, the tint color is always respected and should be used as a
    /// way to provide additional meaning to the control.
    ///
    /// This example shows Answer and Decline buttons with ``ShapeStyle/green``
    /// and ``ShapeStyle/red`` tint colors, respectively.
    ///
    ///     struct ControlTint: View {
    ///         var body: some View {
    ///             HStack {
    ///                 Button {
    ///                     // Answer the call
    ///                 } label: {
    ///                     Label("Answer", systemImage: "phone")
    ///                 }
    ///                 .tint(.green)
    ///                 Button {
    ///                     // Decline the call
    ///                 } label: {
    ///                     Label("Decline", systemImage: "phone.down")
    ///                 }
    ///                 .tint(.red)
    ///             }
    ///             .padding()
    ///         }
    ///     }
    ///
    /// - Parameter tint: The tint ``Color`` to apply.
    @inlinable public func tint(_ tint: Color?) -> some View { return never() }

}

extension View {

    /// Defines a region of the window in which default focus is evaluated by
    /// assigning a value to a given focus state binding.
    ///
    /// By default, SkipUI evaluates default focus when the window first
    /// appears, and when a focus state binding update moves focus
    /// automatically, but not when responding to user-driven navigation
    /// commands.
    ///
    /// Clients can override the default behavior by specifying an evaluation
    /// priority of ``DefaultFocusEvaluationPriority/userInitiated``, which
    /// causes SkipUI to use the client's preferred default focus in response
    /// to user-driven focus navigation as well as automatic changes.
    ///
    /// In the following example, focus automatically goes to the second of the
    /// two text fields when the view is first presented in the window.
    ///
    ///     WindowGroup {
    ///         VStack {
    ///             TextField(...)
    ///                 .focused($focusedField, equals: .firstField)
    ///             TextField(...)
    ///                 .focused($focusedField, equals: .secondField)
    ///         }
    ///         .defaultFocus($focusedField, .secondField)
    ///     }
    ///
    /// - Parameters:
    ///   - binding: A focus state binding to update when evaluating default
    ///     focus in the modified view hierarchy.
    ///   - value: The value to set the binding to during evaluation.
    ///   - priority: An indication of how to prioritize the preferred default
    ///     focus target when focus moves into the modified view hierarchy.
    ///     The default value is `automatic`, which means the preference will
    ///     be given priority when focus is being initialized or relocated
    ///     programmatically, but not when responding to user-directed
    ///     navigation commands.
    /// - Returns: The modified view.
    @available(iOS 17.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
    public func defaultFocus<V>(_ binding: FocusState<V>.Binding, _ value: V, priority: DefaultFocusEvaluationPriority = .automatic) -> some View where V : Hashable { return never() }

}

@available(iOS 17.0, macOS 14.0, *)
@available(watchOS, unavailable)
@available(tvOS, unavailable)
extension View {

    /// Specifies the prominence of badges created by this view.
    ///
    /// Badges can be used for different kinds of information, from the
    /// passive number of items in a container to the number of required
    /// actions. The prominence of badges in Lists can be adjusted to reflect
    /// this and be made to draw more or less attention to themselves.
    ///
    /// Badges will default to `standard` prominence unless specified.
    ///
    /// The following example shows a ``List`` displaying a list of folders
    /// with an informational badge with lower prominence, showing the number
    /// of items in the folder.
    ///
    ///     List(folders) { folder in
    ///         Text(folder.name)
    ///             .badge(folder.numberOfItems)
    ///     }
    ///     .badgeProminence(.decreased)
    ///
    /// - Parameter prominence: The prominence to apply to badges.
    @inlinable public func badgeProminence(_ prominence: BadgeProminence) -> some View { return never() }

}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
extension View {

    /// Sets an accessibility text content type.
    ///
    /// Use this modifier to set the content type of this accessibility
    /// element. Assistive technologies can use this property to choose
    /// an appropriate way to output the text. For example, when
    /// encountering a source coding context, VoiceOver could
    /// choose to speak all punctuation.
    ///
    /// The default content type ``AccessibilityTextContentType/plain``.
    ///
    /// - Parameter value: The accessibility content type from the available
    /// ``AccessibilityTextContentType`` options.
    public func accessibilityTextContentType(_ value: AccessibilityTextContentType) -> ModifiedContent<Self, AccessibilityAttachmentModifier> { fatalError() }

    /// Sets the accessibility level of this heading.
    ///
    /// Use this modifier to set the level of this heading in relation to other headings. The system speaks
    /// the level number of levels ``AccessibilityHeadingLevel/h1`` through
    ///  ``AccessibilityHeadingLevel/h6`` alongside the text.
    ///
    /// The default heading level if you don’t use this modifier
    /// is ``AccessibilityHeadingLevel/unspecified``.
    ///
    /// - Parameter level: The heading level to associate with this element
    ///   from the available ``AccessibilityHeadingLevel`` levels.
    public func accessibilityHeading(_ level: AccessibilityHeadingLevel) -> ModifiedContent<Self, AccessibilityAttachmentModifier> { fatalError() }
}


@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension View {

    /// Applies a projection transformation to this view's rendered output.
    ///
    /// Use `projectionEffect(_:)` to apply a 3D transformation to the view.
    ///
    /// The example below rotates the text 30˚ around the `z` axis, which is the
    /// axis pointing out of the screen:
    ///
    ///     // This transform represents a 30˚ rotation around the z axis.
    ///     let transform = CATransform3DMakeRotation(
    ///         -30 * (.pi / 180), 0.0, 0.0, 1.0)
    ///
    ///     Text("Projection effects using transforms")
    ///         .projectionEffect(.init(transform))
    ///         .border(Color.gray)
    ///
    /// ![A screenshot showing text rotated 30 degrees around the axis pointing
    /// out of the screen.](SkipUI-View-projectionEffect.png)
    ///
    /// - Parameter transform: A ``ProjectionTransform`` to apply to the view.
    @inlinable public func projectionEffect(_ transform: ProjectionTransform) -> some View { return never() }

}

@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
extension View {

    /// Adds a textual description of the value that the view contains.
    ///
    /// Use this method to describe the value represented by a view, but only if that's different than the
    /// view's label. For example, for a slider that you label as "Volume" using accessibilityLabel(),
    /// you can provide the current volume setting, like "60%", using accessibilityValue().
    public func accessibilityValue(_ valueDescription: Text) -> ModifiedContent<Self, AccessibilityAttachmentModifier> { fatalError() }

    /// Adds a textual description of the value that the view contains.
    ///
    /// Use this method to describe the value represented by a view, but only if that's different than the
    /// view's label. For example, for a slider that you label as "Volume" using accessibilityLabel(),
    /// you can provide the current volume setting, like "60%", using accessibilityValue().
    public func accessibilityValue(_ valueKey: LocalizedStringKey) -> ModifiedContent<Self, AccessibilityAttachmentModifier> { fatalError() }

    /// Adds a textual description of the value that the view contains.
    ///
    /// Use this method to describe the value represented by a view, but only if that's different than the
    /// view's label. For example, for a slider that you label as "Volume" using accessibilityLabel(),
    /// you can provide the current volume setting, like "60%", using accessibilityValue().
    public func accessibilityValue<S>(_ value: S) -> ModifiedContent<Self, AccessibilityAttachmentModifier> where S : StringProtocol { fatalError() }
}

extension View {

    /// Adds a textual description of the value that the view contains.
    ///
    /// Use this method to describe the value represented by a view, but only if that's different than the
    /// view's label. For example, for a slider that you label as "Volume" using accessibility(label:),
    /// you can provide the current volume setting, like "60%", using accessibility(value:).
    @available(iOS, introduced: 13.0, deprecated: 100000.0, renamed: "accessibilityValue(_:)")
    @available(macOS, introduced: 10.15, deprecated: 100000.0, renamed: "accessibilityValue(_:)")
    @available(tvOS, introduced: 13.0, deprecated: 100000.0, renamed: "accessibilityValue(_:)")
    @available(watchOS, introduced: 6, deprecated: 100000.0, renamed: "accessibilityValue(_:)")
    @available(xrOS, introduced: 1.0, deprecated: 100000.0, renamed: "accessibilityValue(_:)")
    public func accessibility(value: Text) -> ModifiedContent<Self, AccessibilityAttachmentModifier> { fatalError() }
}

@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
extension View {

    /// Adds help text to a view using a localized string that you provide.
    ///
    /// Adding help to a view configures the view's accessibility hint and
    /// its tooltip ("help tag") on macOS.
    ///
    ///     Button(action: composeMessage) {
    ///         Image(systemName: "square.and.pencil")
    ///     }
    ///     .help("Compose a new message")
    ///
    /// - Parameter textKey: The key for the localized text to use as help.
    public func help(_ textKey: LocalizedStringKey) -> some View { return never() }


    /// Adds help text to a view using a text view that you provide.
    ///
    /// Adding help to a view configures the view's accessibility hint and
    /// its tooltip ("help tag") on macOS.
    ///
    ///     Slider("Opacity", value: $selectedShape.opacity)
    ///         .help(Text("Adjust the opacity of the selected \(selectedShape.name)"))
    ///
    /// - Parameter text: The Text view to use as help.
    public func help(_ text: Text) -> some View { return never() }


    /// Adds help text to a view using a string that you provide.
    ///
    /// Adding help to a view configures the view's accessibility hint and
    /// its tooltip ("help tag") on macOS.
    ///
    ///     Image(systemName: "pin.circle")
    ///         .foregroundColor(pointOfInterest.tintColor)
    ///         .help(pointOfInterest.name)
    ///
    /// - Parameter text: The text to use as help.
    public func help<S>(_ text: S) -> some View where S : StringProtocol { return never() }

}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
extension View {

    /// Defines an explicit identifier tying an Accessibility element for this
    /// view to an entry in an Accessibility Rotor.
    ///
    /// Use this when creating an AccessibilityRotorEntry without a namespace
    /// does not allow SkipUI to automatically find and reveal the element,
    /// or when the Rotor entry should be associated with a sub-element of
    /// a complex view generated in a ForEach, for example.
    ///
    /// - Parameter id: An arbitrary hashable identifier. Pass this same value
    /// when initializing an AccessibilityRotorEntry.
    /// - Parameter namespace: A namespace created with `@Namespace()`. Pass this
    /// same namespace when initializing an `AccessibilityRotorEntry`.
    public func accessibilityRotorEntry<ID>(id: ID, in namespace: Namespace.ID) -> some View where ID : Hashable { return never() }

}

extension View {

    /// Configures the semantic role for the content populating the toolbar.
    ///
    /// Use this modifier to configure the semantic role for content
    /// populating your app's toolbar. SkipUI uses this role when
    /// rendering the content of your app's toolbar.
    ///
    ///     ContentView()
    ///         .navigationTitle("Browser")
    ///         .toolbarRole(.browser)
    ///         .toolbar {
    ///             ToolbarItem(placement: .primaryAction) {
    ///                 AddButton()
    ///             }
    ///          }
    ///
    /// - Parameter role: The role of the toolbar.
    @available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
    public func toolbarRole(_ role: ToolbarRole) -> some View { return never() }

}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
extension View {

    /// Sets the border shape for buttons in this view.
    ///
    /// The border shape is used to draw the platter for a bordered button.
    /// On macOS, the specified border shape is only applied to bordered
    /// buttons in widgets.
    ///
    /// - Parameter shape: the shape to use.
    /// - Note:This will only reflect on explicitly-set `.bordered` or
    ///   `borderedProminent` styles. Setting a shape without
    ///   explicitly setting the above styles will have no effect.
    @inlinable public func buttonBorderShape(_ shape: ButtonBorderShape) -> some View { return never() }

}

extension View {

    /// Sets the visibility of the status bar.
    ///
    /// - Parameter hidden: A Boolean value that indicates whether to hide the
    ///   status bar.
    @available(iOS 13.0, *)
    @available(macOS, unavailable)
    @available(tvOS, unavailable)
    @available(watchOS, unavailable)
    public func statusBarHidden(_ hidden: Bool = true) -> some View { return never() }

}

extension View {

    /// Sets the visibility of the status bar.
    ///
    /// Use `statusBar(hidden:)` to show or hide the status bar.
    ///
    /// - Parameter hidden: A Boolean value that indicates whether to hide the
    ///   status bar.
    @available(iOS, introduced: 13.0, deprecated: 100000.0, renamed: "statusBarHidden(_:)")
    @available(macOS, unavailable)
    @available(tvOS, unavailable)
    @available(watchOS, unavailable)
    @available(xrOS, introduced: 1.0, deprecated: 100000.0, renamed: "statusBarHidden(_:)")
    public func statusBar(hidden: Bool) -> some View { return never() }

}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension View {

    /// Supplies an `ObservableObject` to a view subhierarchy.
    ///
    /// The object can be read by any child by using `EnvironmentObject`.
    ///
    /// - Parameter object: the object to store and make available to
    ///     the view's subhierarchy.
    @inlinable public func environmentObject<T>(_ object: T) -> some View where T : ObservableObject { return never() }

}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension View {

    /// Presents an alert to the user.
    ///
    /// Use this method when you need to show an alert that contains
    /// information from a binding to an optional data source that you provide.
    /// The example below shows a custom data source `FileInfo` whose
    /// properties configure the alert's `message` field:
    ///
    ///     struct FileInfo: Identifiable {
    ///         var id: String { name }
    ///         let name: String
    ///         let fileType: UTType
    ///     }
    ///
    ///     struct ConfirmImportAlert: View {
    ///         @State private var alertDetails: FileInfo?
    ///         var body: some View {
    ///             Button("Show Alert") {
    ///                 alertDetails = FileInfo(name: "MyImageFile.png",
    ///                                         fileType: .png)
    ///             }
    ///             .alert(item: $alertDetails) { details in
    ///                 Alert(title: Text("Import Complete"),
    ///                       message: Text("""
    ///                         Imported \(details.name) \n File
    ///                         type: \(details.fileType.description).
    ///                         """),
    ///                       dismissButton: .default(Text("Dismiss")))
    ///             }
    ///         }
    ///     }
    ///
    ///
    /// ![An alert showing information from a data source that describes the
    /// result of a file import process. The alert displays the name of the
    /// file imported, MyImageFile.png and its file type, the PNG image
    /// file format along with a default OK button for dismissing the
    /// alert.](SkipUI-View-AlertItemContent.png)
    ///
    /// - Parameters:
    ///   - item: A binding to an optional source of truth for the alert.
    ///     if `item` is non-`nil`, the system passes the contents to
    ///     the modifier's closure. You use this content to populate the fields
    ///     of an alert that you create that the system displays to the user.
    ///     If `item` changes, the system dismisses the currently displayed
    ///     alert and replaces it with a new one using the same process.
    ///   - content: A closure returning the alert to present.
    @available(iOS, introduced: 13.0, deprecated: 100000.0, message: "use `alert(title:isPresented:presenting::actions:) instead.")
    @available(macOS, introduced: 10.15, deprecated: 100000.0, message: "use `alert(title:isPresented:presenting::actions:) instead.")
    @available(tvOS, introduced: 13.0, deprecated: 100000.0, message: "use `alert(title:isPresented:presenting::actions:) instead.")
    @available(watchOS, introduced: 6.0, deprecated: 100000.0, message: "use `alert(title:isPresented:presenting::actions:) instead.")
    public func alert<Item>(item: Binding<Item?>, content: (Item) -> Alert) -> some View where Item : Identifiable { return never() }


    /// Presents an alert to the user.
    ///
    /// Use this method when you need to show an alert to the user. The example
    /// below displays an alert that is shown when the user toggles a
    /// Boolean value that controls the presentation of the alert:
    ///
    ///     struct OrderCompleteAlert: View {
    ///         @State private var isPresented = false
    ///         var body: some View {
    ///             Button("Show Alert", action: {
    ///                 isPresented = true
    ///             })
    ///             .alert(isPresented: $isPresented) {
    ///                 Alert(title: Text("Order Complete"),
    ///                       message: Text("Thank you for shopping with us."),
    ///                       dismissButton: .default(Text("OK")))
    ///             }
    ///         }
    ///     }
    ///
    /// ![An alert whose title reads Order Complete, with the
    /// message, Thank you for shopping with us placed underneath. The alert
    /// also includes an OK button for dismissing the
    /// alert.](SkipUI-View-AlertIsPresentedContent.png)
    /// - Parameters:
    ///   - isPresented: A binding to a Boolean value that determines whether
    ///     to present the alert that you create in the modifier's `content` closure. When the
    ///      user presses or taps OK the system sets `isPresented` to `false`
    ///     which dismisses the alert.
    ///   - content: A closure returning the alert to present.
    @available(iOS, introduced: 13.0, deprecated: 100000.0, message: "use `alert(title:isPresented:presenting::actions:) instead.")
    @available(macOS, introduced: 10.15, deprecated: 100000.0, message: "use `alert(title:isPresented:presenting::actions:) instead.")
    @available(tvOS, introduced: 13.0, deprecated: 100000.0, message: "use `alert(title:isPresented:presenting::actions:) instead.")
    @available(watchOS, introduced: 6.0, deprecated: 100000.0, message: "use `alert(title:isPresented:presenting::actions:) instead.")
    public func alert(isPresented: Binding<Bool>, content: () -> Alert) -> some View { return never() }

}
