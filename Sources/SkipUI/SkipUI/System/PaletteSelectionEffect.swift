// Copyright 2023–2025 Skip
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception
#if false
/// The selection effect to apply to a palette item.
///
/// You can configure the selection effect of a palette item by using the
/// ``View/paletteSelectionEffect(_:)`` view modifier.
@available(iOS 17.0, macOS 14.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
public struct PaletteSelectionEffect : Sendable, Equatable {

    /// Applies the system's default effect when selected.
    ///
    /// When using un-tinted SF Symbols or template images, the current tint
    /// color is applied to the selected items' image.
    /// If the provided SF Symbols have custom tints, a stroke is drawn around selected items.
    public static var automatic: PaletteSelectionEffect { get { fatalError() } }

    /// Applies the specified symbol variant when selected.
    ///
    /// - Note: This effect only applies to SF Symbols.
    //public static func symbolVariant(_ variant: SymbolVariants) -> PaletteSelectionEffect { fatalError() }

    /// Does not apply any system effect when selected.
    ///
    /// - Note: Make sure to manually implement a way to indicate selection when
    /// using this case. For example, you could dynamically resolve the item's
    /// image based on the selection state.
    public static var custom: PaletteSelectionEffect { get { fatalError() } }
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
    public func paletteSelectionEffect(_ effect: PaletteSelectionEffect) -> some View { return stubView() }
}
#endif
