// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

import Foundation
#if !SKIP
import struct CoreGraphics.CGFloat
import struct CoreGraphics.CGRect
import struct CoreGraphics.CGSize
#endif

// SKIP INSERT:
// import androidx.compose.foundation.layout.Arrangement
// import androidx.compose.foundation.layout.Row
// import androidx.compose.runtime.Composable
// import androidx.compose.ui.Modifier
// import androidx.compose.ui.unit.dp
// import androidx.compose.ui.graphics.vector.ImageVector
// import androidx.compose.material3.*
// import androidx.compose.material.icons.*
// import androidx.compose.material.icons.filled.*


/// A view that displays an image.
///
/// Use an `Image` instance when you want to add images to your SkipUI app.
/// You can create images from many sources:
///
/// * Image files in your app's asset library or bundle. Supported types include
/// PNG, JPEG, HEIC, and more.
/// * Instances of platform-specific image types, like
///  and
/// .
/// * A bitmap stored in a Core Graphics
///
///  instance.
/// * System graphics from the SF Symbols set.
///
/// The following example shows how to load an image from the app's asset
/// library or bundle and scale it to fit within its container:
///
///     Image("Landscape_4")
///         .resizable()
///         .aspectRatio(contentMode: .fit)
///     Text("Water wheel")
///
/// ![An image of a water wheel and its adjoining building, resized to fit the
/// width of an iPhone display. The words Water wheel appear under this
/// image.](Image-1.png)
///
/// You can use methods on the `Image` type as well as
/// standard view modifiers to adjust the size of the image to fit your app's
/// interface. Here, the `Image` type's
/// ``Image/resizable(capInsets:resizingMode:)`` method scales the image to fit
/// the current view. Then, the
/// ``View/aspectRatio(_:contentMode:)-771ow`` view modifier adjusts
/// this resizing behavior to maintain the image's original aspect ratio, rather
/// than scaling the x- and y-axes independently to fill all four sides of the
/// view. The article
/// <doc:Fitting-Images-into-Available-Space> shows how to apply scaling,
/// clipping, and tiling to `Image` instances of different sizes.
///
/// An `Image` is a late-binding token; the system resolves its actual value
/// only when it's about to use the image in an environment.
///
/// ### Making images accessible
///
/// To use an image as a control, use one of the initializers that takes a
/// `label` parameter. This allows the system's accessibility frameworks to use
/// the label as the name of the control for users who use features like
/// VoiceOver. For images that are only present for aesthetic reasons, use an
/// initializer with the `decorative` parameter; the accessibility systems
/// ignore these images.
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
public struct Image : Equatable {
    internal let image: ImageType

    internal enum ImageType : Equatable {
        case named(name: String, bundle: Bundle?, label: Text?)
        case decorative(name: String, bundle: Bundle?)
        case system(systemName: String)
    }
}


@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension Image {

    /// Creates a labeled image that you can use as content for controls.
    ///
    /// - Parameters:
    ///   - name: The name of the image resource to lookup, as well as the
    ///     localization key with which to label the image.
    ///   - bundle: The bundle to search for the image resource and localization
    ///     content. If `nil`, SkipUI uses the main `Bundle`. Defaults to `nil`.
    public init(_ name: String, bundle: Bundle? = nil) {
        self.image = .named(name: name, bundle: bundle, label: nil)
    }

    /// Creates a labeled image that you can use as content for controls, with
    /// the specified label.
    ///
    /// - Parameters:
    ///   - name: The name of the image resource to lookup
    ///   - bundle: The bundle to search for the image resource. If `nil`,
    ///     SkipUI uses the main `Bundle`. Defaults to `nil`.
    ///   - label: The label associated with the image. SkipUI uses the label
    ///     for accessibility.
    public init(_ name: String, bundle: Bundle? = nil, label: Text) {
        self.image = .named(name: name, bundle: bundle, label: label)
    }

    /// Creates an unlabeled, decorative image.
    ///
    /// SkipUI ignores this image for accessibility purposes.
    ///
    /// - Parameters:
    ///   - name: The name of the image resource to lookup
    ///   - bundle: The bundle to search for the image resource. If `nil`,
    ///     SkipUI uses the main `Bundle`. Defaults to `nil`.
    public init(decorative name: String, bundle: Bundle? = nil) {
        self.image = .decorative(name: name, bundle: bundle)
    }

    /// Creates a system symbol image.
    ///
    /// This initializer creates an image using a system-provided symbol. Use symbols
    /// to find symbols and their corresponding names.
    ///
    /// To create a custom symbol image from your app's asset catalog, use
    /// ``Image/init(_:bundle:)`` instead.
    ///
    /// - Parameters:
    ///   - systemName: The name of the system symbol image.
    ///     Use the SF Symbols app to look up the names of system symbol images.
    @available(macOS 11.0, *)
    public init(systemName: String) {
        self.image = .system(systemName: systemName)
    }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension Image : View {
    // TODO: implement compose view
    #if SKIP
    @Composable public override func ComposeContent(context: ComposeContext) {
        // The best way would be to switch here, but the generated closures are not @Composable, leading to:
        // error: @Composable invocations can only happen from the context of a @Composable function

        //switch image {
        //case .system(let systemName):
        //    androidx.compose.material3.Icon(modifier: context.modifier, imageVector: systemImage(named: systemName), contentDescription: systemName)
        //case .decorative(let name, let bundle): break // TODO: non-system images
        //case .named(let name, let bunle, let label): break // TODO: non-system images
        //}


        if case .system(let systemName) = self.image {
            androidx.compose.material3.Icon(modifier: context.modifier, imageVector: systemImage(named: systemName), contentDescription: systemName)
        }
    }

    private func systemImage(named name: String) -> ImageVector {
        switch name {
        case "accountbox": return Icons.Default.AccountBox
        case "accountcircle": return Icons.Default.AccountCircle
        case "addcircle": return Icons.Default.AddCircle
        case "add": return Icons.Default.Add
        case "arrowdropdown": return Icons.Default.ArrowDropDown
        case "build": return Icons.Default.Build
        case "call": return Icons.Default.Call
        case "checkcircle": return Icons.Default.CheckCircle
        case "check": return Icons.Default.Check
        case "clear": return Icons.Default.Clear
        case "close": return Icons.Default.Close
        case "create": return Icons.Default.Create
        case "daterange": return Icons.Default.DateRange
        case "delete": return Icons.Default.Delete
        case "done": return Icons.Default.Done
        case "edit": return Icons.Default.Edit
        case "email": return Icons.Default.Email
        case "face": return Icons.Default.Face
        case "favoriteborder": return Icons.Default.FavoriteBorder
        case "favorite": return Icons.Default.Favorite
        case "home": return Icons.Default.Home
        case "info": return Icons.Default.Info
        case "keyboardarrowdown": return Icons.Default.KeyboardArrowDown
        case "keyboardarrowup": return Icons.Default.KeyboardArrowUp
        case "locationon": return Icons.Default.LocationOn
        case "lock": return Icons.Default.Lock
        case "mailoutline": return Icons.Default.MailOutline
        case "menu": return Icons.Default.Menu
        case "morevert": return Icons.Default.MoreVert
        case "notifications": return Icons.Default.Notifications
        case "person": return Icons.Default.Person
        case "phone": return Icons.Default.Phone
        case "place": return Icons.Default.Place
        case "playarrow": return Icons.Default.PlayArrow
        case "refresh": return Icons.Default.Refresh
        case "search": return Icons.Default.Search
        case "settings": return Icons.Default.Settings
        case "share": return Icons.Default.Share
        case "shoppingcart": return Icons.Default.ShoppingCart
        case "star": return Icons.Default.Star
        case "thumbup": return Icons.Default.ThumbUp
        case "warning": return Icons.Default.Warning

        case "accountbox.filled": return Icons.Filled.AccountBox
        case "accountcircle.filled": return Icons.Filled.AccountCircle
        case "addcircle.filled": return Icons.Filled.AddCircle
        case "add.filled": return Icons.Filled.Add
        case "arrowdropdown.filled": return Icons.Filled.ArrowDropDown
        case "build.filled": return Icons.Filled.Build
        case "call.filled": return Icons.Filled.Call
        case "checkcircle.filled": return Icons.Filled.CheckCircle
        case "check.filled": return Icons.Filled.Check
        case "clear.filled": return Icons.Filled.Clear
        case "close.filled": return Icons.Filled.Close
        case "create.filled": return Icons.Filled.Create
        case "daterange.filled": return Icons.Filled.DateRange
        case "delete.filled": return Icons.Filled.Delete
        case "done.filled": return Icons.Filled.Done
        case "edit.filled": return Icons.Filled.Edit
        case "email.filled": return Icons.Filled.Email
        case "face.filled": return Icons.Filled.Face
        case "favoriteborder.filled": return Icons.Filled.FavoriteBorder
        case "favorite.filled": return Icons.Filled.Favorite
        case "home.filled": return Icons.Filled.Home
        case "info.filled": return Icons.Filled.Info
        case "keyboardarrowdown.filled": return Icons.Filled.KeyboardArrowDown
        case "keyboardarrowup.filled": return Icons.Filled.KeyboardArrowUp
        case "locationon.filled": return Icons.Filled.LocationOn
        case "lock.filled": return Icons.Filled.Lock
        case "mailoutline.filled": return Icons.Filled.MailOutline
        case "menu.filled": return Icons.Filled.Menu
        case "morevert.filled": return Icons.Filled.MoreVert
        case "notifications.filled": return Icons.Filled.Notifications
        case "person.filled": return Icons.Filled.Person
        case "phone.filled": return Icons.Filled.Phone
        case "place.filled": return Icons.Filled.Place
        case "playarrow.filled": return Icons.Filled.PlayArrow
        case "refresh.filled": return Icons.Filled.Refresh
        case "search.filled": return Icons.Filled.Search
        case "settings.filled": return Icons.Filled.Settings
        case "share.filled": return Icons.Filled.Share
        case "shoppingcart.filled": return Icons.Filled.ShoppingCart
        case "star.filled": return Icons.Filled.Star
        case "thumbup.filled": return Icons.Filled.ThumbUp
        case "warning.filled": return Icons.Filled.Warning

        default: return Icons.Default.Warning
        }
    }

    #else
    public var body: some View {
        stubView()
    }
    #endif
}

#if !SKIP

import class CoreGraphics.CGContext
import struct CoreGraphics.CGFloat
import class CoreGraphics.CGImage
import struct CoreGraphics.CGRect
import struct CoreGraphics.CGSize
import class Foundation.Bundle


//#if canImport(CoreTransferable)
//import protocol CoreTransferable.Transferable
//
//@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
//extension Image : Transferable {
//
//    /// The representation used to import and export the item.
//    ///
//    /// A ``transferRepresentation`` can contain multiple representations
//    /// for different content types.
//    public static var transferRepresentation: Representation { get { return never() } }
//
//    /// The type of the representation used to import and export the item.
//    ///
//    /// Swift infers this type from the return value of the
//    /// ``transferRepresentation`` property.
//    public typealias Representation = Never
//}
//#endif

@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
extension Image {

    /// Creates a system symbol image with a variable value.
    ///
    /// This initializer creates an image using a system-provided symbol. The
    /// rendered symbol may alter its appearance to represent the value
    /// provided in `variableValue`. Use symbols
    /// to find system symbols that support variable
    /// values and their corresponding names.
    ///
    /// The following example shows the effect of creating the `"chart.bar.fill"`
    /// symbol with different values.
    ///
    ///     HStack{
    ///         Image(systemName: "chart.bar.fill", variableValue: 0.3)
    ///         Image(systemName: "chart.bar.fill", variableValue: 0.6)
    ///         Image(systemName: "chart.bar.fill", variableValue: 1.0)
    ///     }
    ///     .font(.system(.largeTitle))
    ///
    /// ![Three instances of the bar chart symbol, arranged horizontally.
    /// The first fills one bar, the second fills two bars, and the last
    /// symbol fills all three bars.](Image-3)
    ///
    /// To create a custom symbol image from your app's asset
    /// catalog, use ``Image/init(_:variableValue:bundle:)`` instead.
    ///
    /// - Parameters:
    ///   - systemName: The name of the system symbol image.
    ///     Use the SF Symbols app to look up the names of system
    ///     symbol images.
    ///   - variableValue: An optional value between `0.0` and `1.0` that
    ///     the rendered image can use to customize its appearance, if
    ///     specified. If the symbol doesn't support variable values, this
    ///     parameter has no effect. Use the SF Symbols app to look up which
    ///     symbols support variable values.
    public init(systemName: String, variableValue: Double?) { fatalError() }

    /// Creates a labeled image that you can use as content for controls,
    /// with a variable value.
    ///
    /// This initializer creates an image using a using a symbol in the
    /// specified bundle. The rendered symbol may alter its appearance to
    /// represent the value provided in `variableValue`.
    ///
    /// - Parameters:
    ///   - name: The name of the image resource to lookup, as well as
    ///     the localization key with which to label the image.
    ///   - variableValue: An optional value between `0.0` and `1.0` that
    ///     the rendered image can use to customize its appearance, if
    ///     specified. If the symbol doesn't support variable values, this
    ///     parameter has no effect.
    ///   - bundle: The bundle to search for the image resource and
    ///     localization content. If `nil`, SkipUI uses the main
    ///     `Bundle`. Defaults to `nil`.
    ///
    public init(_ name: String, variableValue: Double?, bundle: Bundle? = nil) { fatalError() }

    /// Creates a labeled image that you can use as content for controls, with
    /// the specified label and variable value.
    ///
    /// This initializer creates an image using a using a symbol in the
    /// specified bundle. The rendered symbol may alter its appearance to
    /// represent the value provided in `variableValue`.
    ///
    /// - Parameters:
    ///   - name: The name of the image resource to lookup.
    ///   - variableValue: An optional value between `0.0` and `1.0` that
    ///     the rendered image can use to customize its appearance, if
    ///     specified. If the symbol doesn't support variable values, this
    ///     parameter has no effect.
    ///   - bundle: The bundle to search for the image resource. If
    ///     `nil`, SkipUI uses the main `Bundle`. Defaults to `nil`.
    ///   - label: The label associated with the image. SkipUI uses
    ///     the label for accessibility.
    ///
    public init(_ name: String, variableValue: Double?, bundle: Bundle? = nil, label: Text) { fatalError() }

    /// Creates an unlabeled, decorative image, with a variable value.
    ///
    /// This initializer creates an image using a using a symbol in the
    /// specified bundle. The rendered symbol may alter its appearance to
    /// represent the value provided in `variableValue`.
    ///
    /// SkipUI ignores this image for accessibility purposes.
    ///
    /// - Parameters:
    ///   - name: The name of the image resource to lookup.
    ///   - variableValue: An optional value between `0.0` and `1.0` that
    ///     the rendered image can use to customize its appearance, if
    ///     specified. If the symbol doesn't support variable values, this
    ///     parameter has no effect.
    ///   - bundle: The bundle to search for the image resource. If
    ///     `nil`, SkipUI uses the main `Bundle`. Defaults to `nil`.
    ///
    public init(decorative name: String, variableValue: Double?, bundle: Bundle? = nil) { fatalError() }
}

#if canImport(UIKit)
import struct UIKit.ImageResource

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension Image {

    /// Initialize an `Image` with an image resource.
    public init(_ resource: ImageResource) { fatalError() }
}
#endif

@available(iOS 17.0, macOS 14.0, tvOS 17.0, *)
@available(watchOS, unavailable)
extension Image {

    public struct DynamicRange : Hashable, Sendable {

        /// Restrict the image content dynamic range to the standard range.
        public static let standard: Image.DynamicRange = { fatalError() }()

        /// Allow image content to use some extended range. This is
        /// appropriate for placing HDR content next to SDR content.
        public static let constrainedHigh: Image.DynamicRange = { fatalError() }()

        /// Allow image content to use an unrestricted extended range.
        public static let high: Image.DynamicRange = { fatalError() }()

    
        

        }

    /// Returns a new image configured with the specified allowed
    /// dynamic range.
    ///
    /// The following example enables HDR rendering for a specific
    /// image view, assuming that the image has an HDR (ITU-R 2100)
    /// color space and the output device supports it:
    ///
    ///     Image("hdr-asset").allowedDynamicRange(.high)
    ///
    /// - Parameter range: the requested dynamic range, or nil to
    ///   restore the default allowed range.
    ///
    /// - Returns: a new image.
    public func allowedDynamicRange(_ range: Image.DynamicRange?) -> Image { fatalError() }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension Image {

    /// Indicates whether SkipUI renders an image as-is, or
    /// by using a different mode.
    ///
    /// The ``TemplateRenderingMode`` enumeration has two cases:
    /// ``TemplateRenderingMode/original`` and ``TemplateRenderingMode/template``.
    /// The original mode renders pixels as they appear in the original source
    /// image. Template mode renders all nontransparent pixels as the
    /// foreground color, which you can use for purposes like creating image
    /// masks.
    ///
    /// The following example shows both rendering modes, as applied to an icon
    /// image of a green circle with darker green border:
    ///
    ///     Image("dot_green")
    ///         .renderingMode(.original)
    ///     Image("dot_green")
    ///         .renderingMode(.template)
    ///
    /// ![Two identically-sized circle images. The circle on top is green
    /// with a darker green border. The circle at the bottom is a solid color,
    /// either white on a black background, or black on a white background,
    /// depending on the system's current dark mode
    /// setting.](SkipUI-Image-TemplateRenderingMode-dots.png)
    ///
    /// You also use `renderingMode` to produce multicolored system graphics
    /// from the SF Symbols set. Use the ``TemplateRenderingMode/original``
    /// mode to apply a foreground color to all parts of the symbol except
    /// those that have a distinct color in the graphic. The following
    /// example shows three uses of the `person.crop.circle.badge.plus` symbol
    /// to achieve different effects:
    ///
    /// * A default appearance with no foreground color or template rendering
    /// mode specified. The symbol appears all black in light mode, and all
    /// white in Dark Mode.
    /// * The multicolor behavior achieved by using `original` template
    /// rendering mode, along with a blue foreground color. This mode causes the
    /// graphic to override the foreground color for distinctive parts of the
    /// image, in this case the plus icon.
    /// * A single-color template behavior achieved by using `template`
    /// rendering mode with a blue foreground color. This mode applies the
    /// foreground color to the entire image, regardless of the user's Appearance preferences.
    ///
    ///```swift
    ///HStack {
    ///    Image(systemName: "person.crop.circle.badge.plus")
    ///    Image(systemName: "person.crop.circle.badge.plus")
    ///        .renderingMode(.original)
    ///        .foregroundColor(.blue)
    ///    Image(systemName: "person.crop.circle.badge.plus")
    ///        .renderingMode(.template)
    ///        .foregroundColor(.blue)
    ///}
    ///.font(.largeTitle)
    ///```
    ///
    /// ![A horizontal layout of three versions of the same symbol: a person
    /// icon in a circle with a plus icon overlaid at the bottom left. Each
    /// applies a diffent set of colors based on its rendering mode, as
    /// described in the preceding
    /// list.](SkipUI-Image-TemplateRenderingMode-sfsymbols.png)
    ///
    /// Use the SF Symbols app to find system images that offer the multicolor
    /// feature. Keep in mind that some multicolor symbols use both the
    /// foreground and accent colors.
    ///
    /// - Parameter renderingMode: The mode SkipUI uses to render images.
    /// - Returns: A modified ``Image``.
    public func renderingMode(_ renderingMode: Image.TemplateRenderingMode?) -> Image { fatalError() }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension Image {

    /// The orientation of an image.
    ///
    /// Many image formats such as JPEG include orientation metadata in the
    /// image data. In other cases, you can specify image orientation
    /// in code. Properly specifying orientation is often important both for
    /// displaying the image and for certain kinds of image processing.
    ///
    /// In SkipUI, you provide an orientation value when initializing an
    /// ``Image`` from an existing
    /// .
    @frozen public enum Orientation : UInt8, CaseIterable, Hashable {

        /// A value that indicates the original pixel data matches the image's
        /// intended display orientation.
        case up

        /// A value that indicates a horizontal flip of the image from the
        /// orientation of its original pixel data.
        case upMirrored

        /// A value that indicates a 180° rotation of the image from the
        /// orientation of its original pixel data.
        case down

        /// A value that indicates a vertical flip of the image from the
        /// orientation of its original pixel data.
        case downMirrored

        /// A value that indicates a 90° counterclockwise rotation from the
        /// orientation of its original pixel data.
        case left

        /// A value that indicates a 90° clockwise rotation and horizontal
        /// flip of the image from the orientation of its original pixel
        /// data.
        case leftMirrored

        /// A value that indicates a 90° clockwise rotation of the image from
        /// the orientation of its original pixel data.
        case right

        /// A value that indicates a 90° counterclockwise rotation and
        /// horizontal flip from the orientation of its original pixel data.
        case rightMirrored

        /// Creates a new instance with the specified raw value.
        ///
        /// If there is no value of the type that corresponds with the specified raw
        /// value, this initializer returns `nil`. For example:
        ///
        ///     enum PaperSize: String {
        ///         case A4, A5, Letter, Legal
        ///     }
        ///
        ///     print(PaperSize(rawValue: "Legal"))
        ///     // Prints "Optional("PaperSize.Legal")"
        ///
        ///     print(PaperSize(rawValue: "Tabloid"))
        ///     // Prints "nil"
        ///
        /// - Parameter rawValue: The raw value to use for the new instance.
        public init?(rawValue: UInt8) { fatalError() }

        /// A type that can represent a collection of all values of this type.
        public typealias AllCases = [Image.Orientation]

        /// The raw type that can be used to represent all values of the conforming
        /// type.
        ///
        /// Every distinct value of the conforming type has a corresponding unique
        /// value of the `RawValue` type, but there may be values of the `RawValue`
        /// type that don't have a corresponding value of the conforming type.
        public typealias RawValue = UInt8

        /// A collection of all values of this type.
        public static var allCases: [Image.Orientation] { get { fatalError() } }

        /// The corresponding value of the raw type.
        ///
        /// A new instance initialized with `rawValue` will be equivalent to this
        /// instance. For example:
        ///
        ///     enum PaperSize: String {
        ///         case A4, A5, Letter, Legal
        ///     }
        ///
        ///     let selectedSize = PaperSize.Letter
        ///     print(selectedSize.rawValue)
        ///     // Prints "Letter"
        ///
        ///     print(selectedSize == PaperSize(rawValue: selectedSize.rawValue)!)
        ///     // Prints "true"
        public var rawValue: UInt8 { get { fatalError() } }
    }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension Image {

    /// A type that indicates how SkipUI renders images.
    public enum TemplateRenderingMode : Sendable {

        /// A mode that renders all non-transparent pixels as the foreground
        /// color.
        case template

        /// A mode that renders pixels of bitmap images as-is.
        ///
        /// For system images created from the SF Symbol set, multicolor symbols
        /// respect the current foreground and accent colors.
        case original

        

    
        }

    /// A scale to apply to vector images relative to text.
    ///
    /// Use this type with the ``View/imageScale(_:)`` modifier, or the
    /// ``EnvironmentValues/imageScale`` environment key, to set the image scale.
    ///
    /// The following example shows the three `Scale` values as applied to
    /// a system symbol image, each set against a text view:
    ///
    ///     HStack { Image(systemName: "swift").imageScale(.small); Text("Small") }
    ///     HStack { Image(systemName: "swift").imageScale(.medium); Text("Medium") }
    ///     HStack { Image(systemName: "swift").imageScale(.large); Text("Large") }
    ///
    /// ![Vertically arranged text views that read Small, Medium, and
    /// Large. On the left of each view is a system image that uses the Swift symbol.
    /// The image next to the Small text is slightly smaller than the text.
    /// The image next to the Medium text matches the size of the text. The
    /// image next to the Large text is larger than the
    /// text.](SkipUI-EnvironmentAdditions-Image-scale.png)
    ///
    @available(macOS 11.0, *)
    public enum Scale : Sendable {

        /// A scale that produces small images.
        case small

        /// A scale that produces medium-sized images.
        case medium

        /// A scale that produces large images.
        case large

        

    
        }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension Image {

    /// The level of quality for rendering an image that requires interpolation,
    /// such as a scaled image.
    ///
    /// The ``Image/interpolation(_:)`` modifier specifies the interpolation
    /// behavior when using the ``Image/resizable(capInsets:resizingMode:)``
    /// modifier on an ``Image``. Use this behavior to prioritize rendering
    /// performance or image quality.
    public enum Interpolation : Sendable {

        /// A value that indicates SkipUI doesn't interpolate image data.
        case none

        /// A value that indicates a low level of interpolation quality, which may
        /// speed up image rendering.
        case low

        /// A value that indicates a medium level of interpolation quality,
        /// between the low- and high-quality values.
        case medium

        /// A value that indicates a high level of interpolation quality, which
        /// may slow down image rendering.
        case high

        

    
        }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension Image {

    /// Specifies the current level of quality for rendering an
    /// image that requires interpolation.
    ///
    /// See the article <doc:Fitting-Images-into-Available-Space> for examples
    /// of using `interpolation(_:)` when scaling an ``Image``.
    /// - Parameter interpolation: The quality level, expressed as a value of
    /// the `Interpolation` type, that SkipUI applies when interpolating
    /// an image.
    /// - Returns: An image with the given interpolation value set.
    public func interpolation(_ interpolation: Image.Interpolation) -> Image { fatalError() }

    /// Specifies whether SkipUI applies antialiasing when rendering
    /// the image.
    /// - Parameter isAntialiased: A Boolean value that specifies whether to
    /// allow antialiasing. Pass `true` to allow antialising, `false` otherwise.
    /// - Returns: An image with the antialiasing behavior set.
    public func antialiased(_ isAntialiased: Bool) -> Image { fatalError() }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension Image {

    /// Creates a labeled image based on a Core Graphics image instance, usable
    /// as content for controls.
    ///
    /// - Parameters:
    ///   - cgImage: The base graphical image.
    ///   - scale: The scale factor for the image,
    ///     with a value like `1.0`, `2.0`, or `3.0`.
    ///   - orientation: The orientation of the image. The default is
    ///     ``Image/Orientation/up``.
    ///   - label: The label associated with the image. SkipUI uses the label
    ///     for accessibility.
    public init(_ cgImage: CGImage, scale: CGFloat, orientation: Image.Orientation = .up, label: Text) { fatalError() }

    /// Creates an unlabeled, decorative image based on a Core Graphics image
    /// instance.
    ///
    /// SkipUI ignores this image for accessibility purposes.
    ///
    /// - Parameters:
    ///   - cgImage: The base graphical image.
    ///   - scale: The scale factor for the image,
    ///     with a value like `1.0`, `2.0`, or `3.0`.
    ///   - orientation: The orientation of the image. The default is
    ///     ``Image/Orientation/up``.
    public init(decorative cgImage: CGImage, scale: CGFloat, orientation: Image.Orientation = .up) { fatalError() }
}

#if canImport(UIKit)
import class UIKit.UIImage

@available(iOS 13.0, tvOS 13.0, watchOS 6.0, *)
@available(macOS, unavailable)
extension Image {

    /// Creates a SkipUI image from a UIKit image instance.
    /// - Parameter uiImage: The UIKit image to wrap with a SkipUI ``Image``
    /// instance.
    public init(uiImage: UIImage) { fatalError() }
}
#endif

@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
extension Image {

    /// Initializes an image of the given size, with contents provided by a
    /// custom rendering closure.
    ///
    /// Use this initializer to create an image by calling drawing commands on a
    /// ``GraphicsContext`` provided to the `renderer` closure.
    ///
    /// The following example shows a custom image created by passing a
    /// `GraphicContext` to draw an ellipse and fill it with a gradient:
    ///
    ///     let mySize = CGSize(width: 300, height: 200)
    ///     let image = Image(size: mySize) { context in
    ///         context.fill(
    ///             Path(
    ///                 ellipseIn: CGRect(origin: .zero, size: mySize)),
    ///                 with: .linearGradient(
    ///                     Gradient(colors: [.yellow, .orange]),
    ///                     startPoint: .zero,
    ///                     endPoint: CGPoint(x: mySize.width, y:mySize.height))
    ///         )
    ///     }
    ///
    /// ![An ellipse with a gradient that blends from yellow at the upper-
    /// left to orange at the bottom-right.](Image-2)
    ///
    /// - Parameters:
    ///   - size: The size of the newly-created image.
    ///   - label: The label associated with the image. SkipUI uses the label
    ///     for accessibility.
    ///   - opaque: A Boolean value that indicates whether the image is fully
    ///     opaque. This may improve performance when `true`. Don't render
    ///     non-opaque pixels to an image declared as opaque. Defaults to `false`.
    ///   - colorMode: The working color space and storage format of the image.
    ///     Defaults to ``ColorRenderingMode/nonLinear``.
    ///   - renderer: A closure to draw the contents of the image. The closure
    ///     receives a ``GraphicsContext`` as its parameter.
    public init(size: CGSize, label: Text? = nil, opaque: Bool = false, colorMode: ColorRenderingMode = .nonLinear, renderer: @escaping (inout GraphicsContext) -> Void) { fatalError() }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension Image {

    /// The modes that SkipUI uses to resize an image to fit within
    /// its containing view.
    public enum ResizingMode : Sendable {

        /// A mode to repeat the image at its original size, as many
        /// times as necessary to fill the available space.
        case tile

        /// A mode to enlarge or reduce the size of an image so that it
        /// fills the available space.
        case stretch

        

    
        }

    /// Sets the mode by which SkipUI resizes an image to fit its space.
    /// - Parameters:
    ///   - capInsets: Inset values that indicate a portion of the image that
    ///   SkipUI doesn't resize.
    ///   - resizingMode: The mode by which SkipUI resizes the image.
    /// - Returns: An image, with the new resizing behavior set.
    public func resizable(capInsets: EdgeInsets = EdgeInsets(), resizingMode: Image.ResizingMode = .stretch) -> Image { fatalError() }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension Image.Orientation : RawRepresentable {
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension Image.Orientation : Sendable {
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension Image.TemplateRenderingMode : Equatable {
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension Image.TemplateRenderingMode : Hashable {
}

@available(iOS 13.0, tvOS 13.0, watchOS 6.0, macOS 11.0, *)
extension Image.Scale : Equatable {
}

@available(iOS 13.0, tvOS 13.0, watchOS 6.0, macOS 11.0, *)
extension Image.Scale : Hashable {
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension Image.Interpolation : Equatable {
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension Image.Interpolation : Hashable {
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension Image.ResizingMode : Equatable {
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension Image.ResizingMode : Hashable {
}

/// A shape style that fills a shape by repeating a region of an image.
///
/// You can also use ``ShapeStyle/image(_:sourceRect:scale:)`` to construct this
/// style.
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
@frozen public struct ImagePaint : ShapeStyle {

    /// The image to be drawn.
    public var image: Image { get { fatalError() } }

    /// A unit-space rectangle defining how much of the source image to draw.
    ///
    /// The results are undefined if this rectangle selects areas outside the
    /// `[0, 1]` range in either axis.
    public var sourceRect: CGRect { get { fatalError() } }

    /// A scale factor applied to the image while being drawn.
    public var scale: CGFloat { get { fatalError() } }

    /// Creates a shape-filling shape style.
    ///
    /// - Parameters:
    ///   - image: The image to be drawn.
    ///   - sourceRect: A unit-space rectangle defining how much of the source
    ///     image to draw. The results are undefined if `sourceRect` selects
    ///     areas outside the `[0, 1]` range in either axis.
    ///   - scale: A scale factor applied to the image during rendering.
    public init(image: Image, sourceRect: CGRect = CGRect(x: 0, y: 0, width: 1, height: 1), scale: CGFloat = 1) { fatalError() }

    /// The type of shape style this will resolve to.
    ///
    /// When you create a custom shape style, Swift infers this type
    /// from your implementation of the required `resolve` function.
    public typealias Resolved = Never
}

#if canImport(Combine)
import protocol Combine.ObservableObject
import class Combine.PassthroughSubject

/// An object that creates images from SkipUI views.
///
/// Use `ImageRenderer` to export bitmap image data from a SkipUI view. You
/// initialize the renderer with a view, then render images on demand,
/// either by calling the ``render(rasterizationScale:renderer:)`` method, or
/// by using the renderer's properties to create a
/// ,
/// , or
/// .
///
/// By drawing to a ``Canvas`` and exporting with an `ImageRenderer`,
/// you can generate images from any progammatically-rendered content, like
/// paths, shapes, gradients, and more. You can also render standard SkipUI
/// views like ``Text`` views, or containers of multiple view types.
///
/// The following example uses a private `createAwardView(forUser:date:)` method
/// to create a game app's view of a trophy symbol with a user name and date.
/// This view combines a ``Canvas`` that applies a shadow filter with
/// two ``Text`` views into a ``VStack``. A ``Button`` allows the person to
/// save this view. The button's action uses an `ImageRenderer` to rasterize a
/// `CGImage` and then calls a private `uploadAchievementImage(_:)` method to
/// encode and upload the image.
///
///     var body: some View {
///         let trophyAndDate = createAwardView(forUser: playerName,
///                                              date: achievementDate)
///         VStack {
///             trophyAndDate
///             Button("Save Achievement") {
///                 let renderer = ImageRenderer(content: trophyAndDate)
///                 if let image = renderer.cgImage {
///                     uploadAchievementImage(image)
///                 }
///             }
///         }
///     }
///
///     private func createAwardView(forUser: String, date: Date) -> some View {
///         VStack {
///             Image(systemName: "trophy")
///                 .resizable()
///                 .frame(width: 200, height: 200)
///                 .frame(maxWidth: .infinity, maxHeight: .infinity)
///                 .shadow(color: .mint, radius: 5)
///             Text(playerName)
///                 .font(.largeTitle)
///             Text(achievementDate.formatted())
///         }
///         .multilineTextAlignment(.center)
///         .frame(width: 200, height: 290)
///     }
///
/// ![A large trophy symbol, drawn with a mint-colored shadow. Below this, a
/// user name and the date and time. At the bottom, a button with the title
/// Save Achievement allows people to save and upload an image of this
/// view.](ImageRenderer-1)
///
/// Because `ImageRenderer` conforms to
/// , you
/// can use it to produce a stream of images as its properties change. Subscribe
/// to the renderer's ``ImageRenderer/objectWillChange`` publisher, then use the
/// renderer to rasterize a new image each time the subscriber receives an
/// update.
///
/// - Important: `ImageRenderer` output only includes views that SkipUI renders,
/// such as text, images, shapes, and composite views of these types. It
/// does not render views provided by native platform frameworks (AppKit and
/// UIKit) such as web views, media players, and some controls. For these views,
/// `ImageRenderer` displays a placeholder image, similar to the behavior of
/// ``View/drawingGroup(opaque:colorMode:)``.
///
/// ### Rendering to a PDF context
///
/// The ``render(rasterizationScale:renderer:)`` method renders the specified
/// view to any
/// . That
/// means you aren't limited to creating a rasterized `CGImage`. For
/// example, you can generate PDF data by rendering to a PDF context. The
/// resulting PDF maintains resolution-independence for supported members of the
/// view hierarchy, such as text, symbol images, lines, shapes, and fills.
///
/// The following example uses the `createAwardView(forUser:date:)` method from
/// the previous example, and exports its contents as an 800-by-600 point PDF to
/// the file URL `renderURL`. It uses the `size` parameter sent to the
/// rendering closure to center the `trophyAndDate` view vertically and
/// horizontally on the page.
///
///     var body: some View {
///         let trophyAndDate = createAwardView(forUser: playerName,
///                                             date: achievementDate)
///         VStack {
///             trophyAndDate
///             Button("Save Achievement") {
///                 let renderer = ImageRenderer(content: trophyAndDate)
///                 renderer.render { size, renderer in
///                     var mediaBox = CGRect(origin: .zero,
///                                           size: CGSize(width: 800, height: 600))
///                     guard let consumer = CGDataConsumer(url: renderURL as CFURL),
///                           let pdfContext =  CGContext(consumer: consumer,
///                                                       mediaBox: &mediaBox, nil)
///                     else {
///                         return
///                     }
///                     pdfContext.beginPDFPage(nil)
///                     pdfContext.translateBy(x: mediaBox.size.width / 2 - size.width / 2,
///                                            y: mediaBox.size.height / 2 - size.height / 2)
///                     renderer(pdfContext)
///                     pdfContext.endPDFPage()
///                     pdfContext.closePDF()
///                 }
///             }
///         }
///     }
///
/// ### Creating an image from drawing instructions
///
/// `ImageRenderer` makes it possible to create a custom image by drawing into a
/// ``Canvas``, rendering a `CGImage` from it, and using that to initialize an
/// ``Image``. To simplify this process, use the `Image`
/// initializer ``Image/init(size:label:opaque:colorMode:renderer:)``, which
/// takes a closure whose argument is a ``GraphicsContext`` that you can
/// directly draw into.
@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
final public class ImageRenderer<Content> : ObservableObject where Content : View {

    /// A publisher that informs subscribers of changes to the image.
    ///
    /// The renderer's
    /// publishes `Void` elements.
    /// Subscribers should interpret any event as indicating that the contents
    /// of the image may have changed.
    final public let objectWillChange: PassthroughSubject<Void, Never>

    /// The root view rendered by this image renderer.
    @MainActor final public var content: Content { get { fatalError() } }

    /// The size proposed to the root view.
    ///
    /// The default value of this property, ``ProposedViewSize/unspecified``,
    /// produces an image that matches the original view size. You can provide
    /// a custom ``ProposedViewSize`` to override the view's size in one or
    /// both dimensions.
    @MainActor final public var proposedSize: ProposedViewSize { get { fatalError() } }

    /// The scale at which to render the image.
    ///
    /// This value is a ratio of view points to image pixels. This relationship
    /// means that values greater than `1.0` create an image larger than the
    /// original content view, and less than `1.0` creates a smaller image. The
    /// following example shows a 100 x 50 rectangle view and an image rendered
    /// from it with a `scale` of `2.0`, resulting in an image size of
    /// 200 x 100.
    ///
    ///     let rectangle = Rectangle()
    ///         .frame(width: 100, height: 50)
    ///     let renderer = ImageRenderer(content: rectangle)
    ///     renderer.scale = 2.0
    ///     if let rendered = renderer.cgImage {
    ///         print("Scaled image: \(rendered.width) x \(rendered.height)")
    ///     }
    ///     // Prints "Scaled image: 200 x 100"
    ///
    /// The default value of this property is `1.0`.
    @MainActor final public var scale: CGFloat { get { fatalError() } }

    /// A Boolean value that indicates whether the alpha channel of the image is
    /// fully opaque.
    ///
    /// Setting this value to `true`, meaning the alpha channel is opaque, may
    /// improve performance. Don't render non-opaque pixels to a renderer
    /// declared as opaque. This property defaults to `false`.
    @MainActor final public var isOpaque: Bool { get { fatalError() } }

    /// The working color space and storage format of the image.
    @MainActor final public var colorMode: ColorRenderingMode { get { fatalError() } }

    /// Creates a renderer object with a source content view.
    ///
    /// - Parameter view: A ``View`` to render.
    @MainActor public init(content view: Content) { fatalError() }

    /// The current contents of the view, rasterized as a Core Graphics image.
    ///
    /// The renderer notifies its `objectWillChange` publisher when
    /// the contents of the image may have changed.
    @MainActor final public var cgImage: CGImage? { get { fatalError() } }

    #if canImport(UIKit)
    /// The current contents of the view, rasterized as a UIKit image.
    ///
    /// The renderer notifies its `objectWillChange` publisher when
    /// the contents of the image may have changed.
    @MainActor final public var uiImage: UIImage? { get { fatalError() } }
    #endif
    
    /// Draws the renderer's current contents to an arbitrary Core Graphics
    /// context.
    ///
    /// Use this method to rasterize the renderer's content to a
    /// you provide. The `renderer` closure receives two parameters: the current
    /// size of the view, and a function that renders the view to your
    /// `CGContext`. Implement the closure to provide a suitable `CGContext`,
    /// then invoke the function to render the content to that context.
    ///
    /// - Parameters:
    ///   - rasterizationScale: The scale factor for converting user
    ///     interface points to pixels when rasterizing parts of the
    ///     view that can't be represented as native Core Graphics drawing
    ///     commands.
    ///   - renderer: The closure that sets up the Core Graphics context and
    ///     renders the view. This closure receives two parameters: the size of
    ///     the view and a function that you invoke in the closure to render the
    ///     view at the reported size. This function takes a
    ///     
    ///     parameter, and assumes a bottom-left coordinate space origin.
    @MainActor final public func render(rasterizationScale: CGFloat = 1, renderer: (CGSize, (CGContext) -> Void) -> Void) { fatalError() }

    /// The type of publisher that emits before the object has changed.
    public typealias ObjectWillChangePublisher = PassthroughSubject<Void, Never>
}
#endif

#endif
