// Copyright 2023–2025 Skip
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception
#if !SKIP_BRIDGE
import Foundation
#if SKIP
import android.graphics.Bitmap
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.aspectRatio
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.layout.wrapContentSize
import androidx.compose.material.icons.__
import androidx.compose.material.icons.filled.__
import androidx.compose.material.icons.outlined.__
import androidx.compose.material.icons.rounded.__
import androidx.compose.material.icons.sharp.__
import androidx.compose.material.icons.twotone.__
import androidx.compose.material3.Icon
import androidx.compose.material3.LocalTextStyle
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.paint
import androidx.compose.ui.geometry.Rect
import androidx.compose.ui.geometry.Size
import androidx.compose.ui.geometry.isUnspecified
import androidx.compose.ui.graphics.ColorFilter
import androidx.compose.ui.graphics.ColorMatrix
import androidx.compose.ui.graphics.PathFillType
import androidx.compose.ui.graphics.SolidColor
import androidx.compose.ui.graphics.StrokeCap
import androidx.compose.ui.graphics.StrokeJoin
import androidx.compose.ui.graphics.asImageBitmap
import androidx.compose.ui.graphics.painter.BitmapPainter
import androidx.compose.ui.graphics.painter.ColorPainter
import androidx.compose.ui.graphics.painter.Painter
import androidx.compose.ui.graphics.vector.ImageVector
import androidx.compose.ui.graphics.vector.PathParser
import androidx.compose.ui.graphics.vector.group
import androidx.compose.ui.graphics.vector.path
import androidx.compose.ui.graphics.vector.rememberVectorPainter
import androidx.compose.ui.layout.ContentScale
import androidx.compose.ui.layout.Layout
import androidx.compose.ui.layout.Placeable
import androidx.compose.ui.layout.ScaleFactor
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.platform.LocalDensity
import androidx.compose.ui.unit.dp
import coil3.compose.SubcomposeAsyncImage
import coil3.request.ImageRequest
#elseif canImport(CoreGraphics)
import struct CoreGraphics.CGFloat
import struct CoreGraphics.CGRect
import struct CoreGraphics.CGSize
#endif

// SKIP @bridge
public struct Image : View, Renderable, Equatable {
    let image: ImageType
    var resizingMode: ResizingMode?
    // SKIP @bridge
    public var templateRenderingMode: TemplateRenderingMode?
    let scale = 1.0

    enum ImageType : Equatable {
        case named(name: String, bundle: Bundle?, label: Text?)
        case decorative(name: String, bundle: Bundle?)
        case system(systemName: String)
        #if SKIP
        case bitmap(bitmap: Bitmap, scale: CGFloat)
        case painter(painter: Painter, scale: CGFloat)
        #endif
    }

    public init(_ name: String, bundle: Bundle? = nil) {
        self.image = .named(name: name, bundle: bundle, label: nil)
    }

    public init(_ name: String, bundle: Bundle? = nil, label: Text) {
        self.image = .named(name: name, bundle: bundle, label: label)
    }

    public init(decorative name: String, bundle: Bundle? = nil) {
        self.image = .decorative(name: name, bundle: bundle)
    }

    public init(systemName: String, unusedp0: Any? = nil, unusedp1: Any? = nil) {
        self.image = .system(systemName: systemName)
    }

    // SKIP @bridge
    public init(name: String, isSystem: Bool, isDecorative: Bool, bridgedBundle: Any?, label: Text?) {
        if isSystem {
            self.image = .system(systemName: name)
        } else if isDecorative {
            self.image = .decorative(name: name, bundle: bridgedBundle as? Bundle)
        } else {
            self.image = .named(name: name, bundle: bridgedBundle as? Bundle, label: label)
        }
    }

    // SKIP @bridge
    public init(uiImage: UIImage) {
        #if SKIP
        self.image = .bitmap(bitmap: uiImage.bitmap!, scale: uiImage.scale)
        #else
        fatalError()
        #endif
    }

    #if SKIP
    public init(painter: Painter, scale: CGFloat) {
        self.image = .painter(painter: painter, scale: scale)
    }

    @Composable override func Render(context: ComposeContext) {
        let aspect = EnvironmentValues.shared._aspectRatio
        let colorScheme = EnvironmentValues.shared.colorScheme

        // Put given modifiers on the containing Box so that the image can scale itself without affecting them
        Box(modifier: context.modifier, contentAlignment: androidx.compose.ui.Alignment.Center) {
            switch image {
            case .bitmap(let bitmap, let scale):
                RenderBitmap(bitmap: bitmap, scale: scale, aspectRatio: aspect?.0, contentMode: aspect?.1, context: context)
            case .painter(let painter, let scale):
                RenderPainter(painter: painter, scale: scale, aspectRatio: aspect?.0, contentMode: aspect?.1, context: context)
            case .system(let systemName):
                RenderSystem(systemName: systemName, aspectRatio: aspect?.0, contentMode: aspect?.1, context: context)
            case .named(let name, let bundle, let label):
                RenderNamedImage(name: name, bundle: bundle, label: label, aspectRatio: aspect?.0, contentMode: aspect?.1, colorScheme: colorScheme, context: context)
            case .decorative(let name, let bundle):
                RenderNamedImage(name: name, bundle: bundle, label: nil, aspectRatio: aspect?.0, contentMode: aspect?.1, colorScheme: colorScheme, context: context)
            }
        }
    }

    @Composable private func RenderNamedImage(name: String, bundle: Bundle?, label: Text?, aspectRatio: Double?, contentMode: ContentMode?, colorScheme: ColorScheme, context: ComposeContext) {
        if let assetImageInfo = rememberCachedAsset(assetImageCache, AssetKey(name: name, bundle: bundle, colorScheme: colorScheme)) { _ in assetImageInfo(name: name, colorScheme: colorScheme, bundle: bundle ?? Bundle.main) } {
            RenderAssetImage(asset: assetImageInfo, label: label, aspectRatio: aspectRatio, contentMode: contentMode, context: context)
        } else if let symbolResourceURL = rememberCachedAsset(contentsCache, AssetKey(name: name, bundle: bundle)) { _ in symbolResourceURL(name: name, bundle: bundle ?? Bundle.main) } {
            RenderSymbolImage(name: name, url: symbolResourceURL, label: label, aspectRatio: aspectRatio, contentMode: contentMode, context: context)
        }
    }

    @Composable private func RenderAssetImage(asset: AssetImageInfo, label: Text?, aspectRatio: Double?, contentMode: ContentMode?, context: ComposeContext) {
        let url = asset.url
        let model = ImageRequest.Builder(LocalContext.current)
            .fetcherFactory(AssetURLFetcher.Factory()) // handler for asset:/ and jar:file:/ URLs
            .decoderFactory(coil3.svg.SvgDecoder.Factory())
            //.decoderFactory(coil3.gif.GifDecoder.Factory())
            .decoderFactory(PdfDecoder.Factory())
            .data(url)
            .size(coil3.size.Size.ORIGINAL)
            .memoryCacheKey(url.description)
            .diskCacheKey(url.description)
            .build()

        let shouldTint = (templateRenderingMode == .template) || (templateRenderingMode == nil && asset.isTemplateImage)
        let tintColor = shouldTint ? EnvironmentValues.shared._foregroundStyle?.asColor(opacity: 1.0, animationContext: context) ?? Color.primary.colorImpl() : nil

        SubcomposeAsyncImage(model: model, contentDescription: nil, loading: { _ in

        }, success: { state in
            RenderPainter(painter: self.painter, tintColor: tintColor, scale: scale, aspectRatio: aspectRatio, contentMode: contentMode, context: context)
        }, error: { state in
        })
    }

    @Composable private func RenderSymbolImage(name: String, url: URL, label: Text?, aspectRatio: Double?, contentMode: ContentMode?, context: ComposeContext) {

        func symbolToImageVector(_ symbol: SymbolInfo, tintColor: androidx.compose.ui.graphics.Color) -> ImageVector {
            // this is the default size for material icons (24f), defined in the internal MaterialIconDimension variable with the comment "All Material icons (currently) are 24dp by 24dp, with a viewport size of 24 by 24" at:
            // https://github.com/androidx/androidx/blob/androidx-main/compose/material/material-icons-core/src/commonMain/kotlin/androidx/compose/material/icons/Icons.kt#L257
            //let size = androidx.compose.ui.geometry.Size(Float(24), Float(24))

            // manually create the bounding rect for all the symbols so we know how to size the viewport and offset the group
            // note that this does not take into account symbols that are designed to be smaller than their bounds, and ignores any baseline accommodation
            var symbolBounds = symbol.paths.first?.pathParser.toPath().getBounds() ?? Rect.Zero
            for symbolPath in symbol.paths.dropFirst() {
                let bounds = symbolPath.pathParser.toPath().getBounds()
                symbolBounds = Rect(
                    minOf(symbolBounds.left, bounds.left),
                    minOf(symbolBounds.top, bounds.top),
                    maxOf(symbolBounds.right, bounds.right),
                    maxOf(symbolBounds.bottom, bounds.bottom)
                )
            }

            let symbolWidth = symbolBounds.right - symbolBounds.left
            let symbolHeight = symbolBounds.bottom - symbolBounds.top
            let symbolSpan = maxOf(symbolWidth, symbolHeight)

            // the offsets are adjusted to center the symbol in the viewport
            let symbolOffsetX = -symbolBounds.left + (symbolHeight > symbolWidth ? ((symbolHeight - symbolWidth) / Float(2.0)) : Float(0.0))
            let symbolOffsetY = -symbolBounds.top + (symbolWidth > symbolHeight ? ((symbolWidth - symbolHeight) / Float(2.0)) : Float(0.0))

            //logger.debug("created union path symbolSpan=\(symbolSpan) bounds=\(symbolBounds)")

            let imageVector = ImageVector.Builder(
                name = name,
                defaultWidth: symbolSpan.dp,
                defaultHeight: symbolSpan.dp,
                viewportWidth: symbolSpan,
                viewportHeight: symbolSpan,
                autoMirror: true).apply {
                    group(translationX: symbolOffsetX, translationY: symbolOffsetY) {
                        path(
                            fill: SolidColor(tintColor),
                            fillAlpha: Float(1.0),
                            stroke: SolidColor(tintColor),
                            strokeAlpha: Float(1.0),
                            strokeLineWidth: Float(1.0),
                            strokeLineCap: StrokeCap.Butt,
                            strokeLineJoin: StrokeJoin.Bevel,
                            strokeLineMiter: Float(1.0),
                            pathFillType: PathFillType.NonZero,
                            pathBuilder: {
                                for symbolPath in symbol.paths {
                                    let pathParser = symbolPath.pathParser
                                    let bounds = pathParser.toPath().getBounds()
                                    let pathData = pathParser.toNodes()
                                    //logger.debug("parsed path bounds=\(bounds) nodes=\(pathData)")
                                    addPath(pathData, fill: SolidColor(tintColor), stroke: SolidColor(tintColor))
                                }
                            }
                        )
                    }
                }.build()

            return imageVector
        }

        // parse the Symbol Export XML and extract the SVG path representation that most closely matches the current font weight (e.g., "Black-S", "Regular-S", "Ultralight-S")
        func parseSymbolXML(_ url: URL) -> [SymbolSize: SymbolInfo] {
            logger.debug("parsing symbol SVG at: \(url)")
            let factory = javax.xml.parsers.DocumentBuilderFactory.newInstance()
            let builder = factory.newDocumentBuilder()
            let document = builder.parse(url.kotlin().toURL().openStream())

            // filter a NodeList into an array of Elements
            func elements(_ list: org.w3c.dom.NodeList) -> [org.w3c.dom.Element] {
                Array(0..<list.length).compactMap({ i in list.item(i) as? org.w3c.dom.Element })
            }

            var symbolInfos: [SymbolSize: SymbolInfo] = [:]

            let gnodes = document.getElementsByTagName("g")
            for symbolG in elements(gnodes) {
                if symbolG.getAttribute("id") != "Symbols" {
                    continue // there are also "Notes" and "Guides"
                }

                for subG in elements(symbolG.childNodes) {
                    let subGID = subG.getAttribute("id") // e.g., "Black-S", "Regular-S", "Ultralight-S"
                    guard let symbolSize = SymbolSize(rawValue: subGID) else {
                        logger.warning("could not parse symbol size: \(subGID)")
                        continue
                    }
                    var paths: [SymbolPath] = []

                    for pathNode in elements(subG.childNodes).filter { $0.nodeName == "path" } {
                        // TODO: use the layers line multicolor-0:tintColor hierarchical-0:secondary to translate into compose equivalents
                        let pathClass = pathNode.getAttribute("class") ?? "" // e.g., monochrome-0 multicolor-0:tintColor hierarchical-0:secondary SFSymbolsPreviewWireframe
                        let pathD = pathNode.getAttribute("d")
                        if !pathD.isEmpty {
                            let pathParser = PathParser().parsePathString(pathD)
                            paths.append(SymbolPath(pathParser: pathParser, attrs: Array(pathClass.split(" "))))
                        }
                    }

                    symbolInfos[symbolSize] = SymbolInfo(size: symbolSize, paths: paths)
                }
            }

            return symbolInfos
        }

        let symbolInfos = rememberCachedAsset(symbolXMLCache, url) { url in
            parseSymbolXML(url)
        }

        // match the best symbol for the current font weight
        let fontWeight = EnvironmentValues.shared._textEnvironment.fontWeight ?? Font.Weight.regular

        // Exporting as "Static" will contain all 27 variants (9 weights * 3 sizes),
        // but "Variable" will only have 3: Ultralight-S, Regular-S, and Black-S
        // in theory, we should interpolate the paths for in-between weights (like "light"),
        // but in absence of that logic, we just try to pick the closest variant for the current font weight

        let ultraLight: [SymbolSize] = [.UltralightM, .UltralightS, .UltralightL]
        let thin: [SymbolSize] = [.ThinM, .ThinS, .ThinL]
        let light: [SymbolSize] = [.LightM, .LightS, .LightL]
        let regular: [SymbolSize] = [.RegularM, .RegularS, .RegularL]
        let medium: [SymbolSize] = [.MediumM, .MediumS, .MediumL]
        let semibold: [SymbolSize] = [.SemiboldM, .SemiboldS, .SemiboldL]
        let bold: [SymbolSize] = [.BoldM, .BoldS, .BoldL]
        let heavy: [SymbolSize] = [.HeavyM, .HeavyS, .HeavyL]
        let black: [SymbolSize] = [.BlackM, .BlackS, .BlackL]

        var weightPriority: [SymbolSize] = []

        switch fontWeight {
        case Font.Weight.ultraLight: weightPriority = ultraLight + thin + light + regular + medium + semibold + bold + heavy + black
        case Font.Weight.thin:       weightPriority = thin + ultraLight + light + regular + medium + semibold + bold + heavy + black
        case Font.Weight.light:      weightPriority = light + thin + ultraLight + regular + medium + semibold + bold + heavy + black
        case Font.Weight.regular:    weightPriority = regular + medium + light + thin + semibold + bold + ultraLight + heavy + black
        case Font.Weight.medium:     weightPriority = medium + regular + semibold + light + bold + thin + heavy + black + ultraLight
        case Font.Weight.semibold:   weightPriority = semibold + medium + regular + bold + light + thin + heavy + ultraLight + black
        case Font.Weight.bold:       weightPriority = bold + heavy + black + semibold + medium + regular + light + thin + ultraLight
        case Font.Weight.heavy:      weightPriority = heavy + black + bold + semibold + medium + regular + light + thin + ultraLight
        case Font.Weight.black:      weightPriority = black + heavy + bold + semibold + medium + regular + light + thin + ultraLight
        }

        let tintColor = EnvironmentValues.shared._foregroundStyle?.asColor(opacity: 1.0, animationContext: context) ?? Color.primary.colorImpl()

        if let symbolInfo = weightPriority.compactMap({ symbolInfos[$0] }).first {
            let imageVector = symbolToImageVector(symbolInfo, tintColor: tintColor)
            RenderScaledImageVector(image: imageVector, name: name, aspectRatio: aspectRatio, contentMode: contentMode, context: context)
        }
    }

    @Composable private func RenderBitmap(bitmap: Bitmap, scale: CGFloat, aspectRatio: Double?, contentMode: ContentMode?, context: ComposeContext) {
        let imageBitmap = bitmap.asImageBitmap()
        let painter = BitmapPainter(imageBitmap)
        RenderPainter(painter: painter, scale: scale, aspectRatio: aspectRatio, contentMode: contentMode, context: context)
    }

    @Composable private func RenderPainter(painter: Painter, scale: CGFloat = 1.0, tintColor: androidx.compose.ui.graphics.Color? = nil, aspectRatio: Double?, contentMode: ContentMode?, context: ComposeContext) {
        let isPlaceholder = EnvironmentValues.shared.redactionReasons.contains(.placeholder)
        let colorFilter: ColorFilter?

        var templateColor: androidx.compose.ui.graphics.Color?
        if self.templateRenderingMode == .template {
            templateColor = EnvironmentValues.shared._foregroundStyle?.asColor(opacity: 1.0, animationContext: context)
        }

        if let tintColor = tintColor ?? templateColor {
            colorFilter = isPlaceholder ? placeholderColorFilter(color: tintColor.copy(alpha: Float(Color.placeholderOpacity))) : ColorFilter.tint(tintColor)
        } else if isPlaceholder {
            colorFilter = placeholderColorFilter(color: Color.placeholder.colorImpl())
        } else {
            colorFilter = nil
        }
        switch resizingMode {
        case .stretch:
            if painter.intrinsicSize.isUnspecified || painter.intrinsicSize.width.isNaN() || painter.intrinsicSize.width <= 0 || painter.intrinsicSize.height.isNaN() || painter.intrinsicSize.height <= 0 {
                var modifier = Modifier.fillSize()
                if let aspectRatio {
                    modifier = modifier.aspectRatio(Float(aspectRatio))
                }
                androidx.compose.foundation.Image(painter: painter, modifier: modifier, contentDescription: nil, contentScale: ContentScale.FillBounds, colorFilter: colorFilter)
            } else {
                ImageLayout(intrinsicWidth: painter.intrinsicSize.width, intrinsicHeight: painter.intrinsicSize.height, aspectRatio: aspectRatio, contentMode: contentMode) {
                    androidx.compose.foundation.Image(painter: painter, contentDescription: nil, contentScale: ContentScale.FillBounds, colorFilter: colorFilter)
                }
            }
        default: // TODO: .tile
            let modifier = Modifier.wrapContentSize(unbounded: true).size((painter.intrinsicSize.width / scale).dp, (painter.intrinsicSize.height / scale).dp)
            androidx.compose.foundation.Image(painter: painter, contentDescription: nil, modifier: modifier, colorFilter: colorFilter)
        }
    }

    @Composable private func RenderSystem(systemName: String, aspectRatio: Double?, contentMode: ContentMode?, context: ComposeContext) {
        // we first check to see if there is a bundled symbol with the name in any of the asset catalogs, in which case we will use that symbol
        // note that we can only use the `main` (i.e., top-level) bundle to look up image resources, since Image(systemName:) does not accept a bundle
        if let symbolResourceURL = rememberCachedAsset(contentsCache, AssetKey(name: systemName)) { _ in symbolResourceURL(name: systemName, bundle: Bundle.main) } {
            RenderSymbolImage(name: systemName, url: symbolResourceURL, label: nil, aspectRatio: aspectRatio, contentMode: contentMode, context: context)
            return
       }

        // fall back to default symbol names
        guard let image = Self.composeImageVector(named: systemName) else {
            logger.warning("Unable to find system image named: \(systemName)")
            Icon(imageVector: Icons.Default.Warning, contentDescription: "missing icon")
            return
        }

        RenderScaledImageVector(image: image, name: systemName, aspectRatio: aspectRatio, contentMode: contentMode, context: context)
    }

    @Composable private func RenderScaledImageVector(image: ImageVector, name: String, aspectRatio: Double?, contentMode: ContentMode?, context: ComposeContext) {

        let tintColor = EnvironmentValues.shared._foregroundStyle?.asColor(opacity: 1.0, animationContext: context) ?? Color.primary.colorImpl()
        switch resizingMode {
        case .stretch:
            let painter = rememberVectorPainter(image)
            RenderPainter(painter: painter, tintColor: tintColor, aspectRatio: aspectRatio, contentMode: contentMode, context: context)
        default: // TODO: .tile
            let textStyle = EnvironmentValues.shared.font?.fontImpl() ?? LocalTextStyle.current
            var modifier: Modifier
            if textStyle.fontSize.isSp {
                let textSizeDp = with(LocalDensity.current) {
                    textStyle.fontSize.toDp()
                }
                // Apply a multiplier to more closely match SwiftUI's relative text and system image sizes
                modifier = Modifier.size(textSizeDp * Float(1.5))
            } else {
                modifier = Modifier
            }
            let isPlaceholder = EnvironmentValues.shared.redactionReasons.contains(RedactionReasons.placeholder)
            if isPlaceholder {
                let placeholderColor = tintColor ?? Color.primary.colorImpl()
                modifier = modifier.paint(ColorPainter(placeholderColor.copy(alpha: Float(Color.placeholderOpacity))))
            }
            let iconTint = if isPlaceholder {
                androidx.compose.ui.graphics.Color.Transparent
            } else {
                tintColor ?? Color.primary.colorImpl()
            }
            Icon(imageVector: image, contentDescription: name, modifier: modifier, tint: iconTint)
        }
    }

    private func placeholderColorFilter(color: androidx.compose.ui.graphics.Color) -> ColorFilter {
        let matrix = ColorMatrix().apply {
            set(0, 0, Float(0)) // Do not preserve original R
            set(1, 1, Float(0)) // Do not preserve original G
            set(2, 2, Float(0)) // Do not preserve original B
            set(3, 3, Float(0)) // Do not preserve original A

            set(0, 4, color.red * 255) // Use given color's R
            set(1, 4, color.green * 255) // Use given color's G
            set(2, 4, color.blue * 255) // Use given color's B
            set(3, 4, color.alpha * 255) // Use given color's A
        }
        return ColorFilter.colorMatrix(matrix)
    }

    private static func composeSymbolName(for symbolName: String) -> String? {
        switch symbolName {
        case "person.crop.square": return "Icons.Outlined.AccountBox" //􀉹
        case "person.crop.circle": return "Icons.Outlined.AccountCircle" //􀉭
        case "plus.circle.fill": return "Icons.Outlined.AddCircle" //􀁍
        case "plus": return "Icons.Outlined.Add" //􀅼
        case "arrow.left": return "Icons.Outlined.ArrowBack" //􀄪
        case "arrowtriangle.down.fill": return "Icons.Outlined.ArrowDropDown" //􀄥
        case "arrow.forward": return "Icons.Outlined.ArrowForward" //􀰑
        case "wrench": return "Icons.Outlined.Build" //􀎕
        case "phone": return "Icons.Outlined.Call" //􀌾
        case "checkmark.circle": return "Icons.Outlined.CheckCircle" //􀁢
        case "checkmark": return "Icons.Outlined.Check" //􀆅
        case "xmark": return "Icons.Outlined.Clear" //􀆄
        case "pencil": return "Icons.Outlined.Create" //􀈊
        case "calendar": return "Icons.Outlined.DateRange" //􀉉
        case "trash": return "Icons.Outlined.Delete" //􀈑
        case "envelope": return "Icons.Outlined.Email" //􀍕
        case "arrow.forward.square": return "Icons.Outlined.ExitToApp" //􀰔
        case "face.smiling": return "Icons.Outlined.Face" //􀎸
        case "heart": return "Icons.Outlined.FavoriteBorder" //􀊴
        case "heart.fill": return "Icons.Outlined.Favorite" //􀊵
        case "house": return "Icons.Outlined.Home" //􀎞
        case "info.circle": return "Icons.Outlined.Info" //􀅴
        case "chevron.down": return "Icons.Outlined.KeyboardArrowDown" //􀆈
        case "chevron.left": return "Icons.Outlined.KeyboardArrowLeft" //􀆉
        case "chevron.right": return "Icons.Outlined.KeyboardArrowRight" //􀆊
        case "chevron.up": return "Icons.Outlined.KeyboardArrowUp" //􀆇
        case "list.bullet": return "Icons.Outlined.List" //􀋲
        case "location": return "Icons.Outlined.LocationOn" //􀋑
        case "lock": return "Icons.Outlined.Lock" //􀎠
        case "line.3.horizontal": return "Icons.Outlined.Menu" //􀌇
        case "ellipsis": return "Icons.Outlined.MoreVert" //􀍠
        case "bell": return "Icons.Outlined.Notifications" //􀋙
        case "person": return "Icons.Outlined.Person" //􀉩
        case "mappin.circle": return "Icons.Outlined.Place" //􀎪
        case "play": return "Icons.Outlined.PlayArrow" //􀊃
        case "arrow.clockwise.circle": return "Icons.Outlined.Refresh" //􀚁
        case "magnifyingglass": return "Icons.Outlined.Search" //􀊫
        case "paperplane": return "Icons.Outlined.Send" //􀈟
        case "gearshape": return "Icons.Outlined.Settings" //􀣋
        case "square.and.arrow.up": return "Icons.Outlined.Share" //􀈂
        case "cart": return "Icons.Outlined.ShoppingCart" //􀍩
        // #148 Icons.Outlined.Star is not actually outlined!
        // case "star": return "Icons.Outlined.Star" //􀋃
        case "hand.thumbsup": return "Icons.Outlined.ThumbUp" //􀉿
        case "exclamationmark.triangle": return "Icons.Outlined.Warning" //􀇿

        case "person.crop.square.fill": return "Icons.Filled.AccountBox" //􀉺
        case "person.crop.circle.fill": return "Icons.Filled.AccountCircle" //􀉮
        case "wrench.fill": return "Icons.Filled.Build" //􀎖
        case "phone.fill": return "Icons.Filled.Call" //􀌿
        case "checkmark.circle.fill": return "Icons.Filled.CheckCircle" //􀁣
        case "trash.fill": return "Icons.Filled.Delete" //􀈒
        case "envelope.fill": return "Icons.Filled.Email" //􀍖
        case "house.fill": return "Icons.Filled.Home" //􀎟
        case "info.circle.fill": return "Icons.Filled.Info" //􀅵
        case "location.fill": return "Icons.Filled.LocationOn" //􀋒
        case "lock.fill": return "Icons.Filled.Lock" //􀎡
        case "bell.fill": return "Icons.Filled.Notifications" //􀋚
        case "person.fill": return "Icons.Filled.Person" //􀉪
        case "mappin.circle.fill": return "Icons.Filled.Place" //􀜈
        case "play.fill": return "Icons.Filled.PlayArrow" //􀊄
        case "paperplane.fill": return "Icons.Filled.Send" //􀈠
        case "gearshape.fill": return "Icons.Filled.Settings" //􀣌
        case "square.and.arrow.up.fill": return "Icons.Filled.Share" //􀈃
        case "cart.fill": return "Icons.Filled.ShoppingCart" //􀍪
        case "star.fill": return "Icons.Filled.Star" //􀋃
        case "hand.thumbsup.fill": return "Icons.Filled.ThumbUp" //􀊀
        case "exclamationmark.triangle.fill": return "Icons.Filled.Warning" //􀇿

        default: return nil
        }
    }

    /// Returns the `androidx.compose.ui.graphics.vector.ImageVector` for the given constant name.
    ///
    /// See: https://developer.android.com/reference/kotlin/androidx/compose/material/icons/Icons.Outlined
    static func composeImageVector(named name: String) -> ImageVector? {
        switch composeSymbolName(for: name) ?? name {
        case "Icons.Outlined.AccountBox": return Icons.Outlined.AccountBox
        case "Icons.Outlined.AccountCircle": return Icons.Outlined.AccountCircle
        case "Icons.Outlined.AddCircle": return Icons.Outlined.AddCircle
        case "Icons.Outlined.Add": return Icons.Outlined.Add
        case "Icons.Outlined.ArrowBack": return Icons.Outlined.ArrowBack // Compose 1.6 TODO: Icons.AutoMirrored.Outlined.ArrowBack
        case "Icons.Outlined.ArrowDropDown": return Icons.Outlined.ArrowDropDown
        case "Icons.Outlined.ArrowForward": return Icons.Outlined.ArrowForward // Compose 1.6 TODO: Icons.AutoMirrored.Outlined.ArrowForward
        case "Icons.Outlined.Build": return Icons.Outlined.Build
        case "Icons.Outlined.Call": return Icons.Outlined.Call
        case "Icons.Outlined.CheckCircle": return Icons.Outlined.CheckCircle
        case "Icons.Outlined.Check": return Icons.Outlined.Check
        case "Icons.Outlined.Clear": return Icons.Outlined.Clear
        case "Icons.Outlined.Close": return Icons.Outlined.Close
        case "Icons.Outlined.Create": return Icons.Outlined.Create
        case "Icons.Outlined.DateRange": return Icons.Outlined.DateRange
        case "Icons.Outlined.Delete": return Icons.Outlined.Delete
        case "Icons.Outlined.Done": return Icons.Outlined.Done
        case "Icons.Outlined.Edit": return Icons.Outlined.Edit
        case "Icons.Outlined.Email": return Icons.Outlined.Email
        case "Icons.Outlined.ExitToApp": return Icons.Outlined.ExitToApp // Compose 1.6 TODO: Icons.AutoMirrored.Outlined.ExitToApp
        case "Icons.Outlined.Face": return Icons.Outlined.Face
        case "Icons.Outlined.FavoriteBorder": return Icons.Outlined.FavoriteBorder
        case "Icons.Outlined.Favorite": return Icons.Outlined.Favorite
        case "Icons.Outlined.Home": return Icons.Outlined.Home
        case "Icons.Outlined.Info": return Icons.Outlined.Info
        case "Icons.Outlined.KeyboardArrowDown": return Icons.Outlined.KeyboardArrowDown
        case "Icons.Outlined.KeyboardArrowLeft": return Icons.Outlined.KeyboardArrowLeft // Compose 1.6 TODO: Icons.AutoMirrored.Outlined.KeyboardArrowLeft
        case "Icons.Outlined.KeyboardArrowRight": return Icons.Outlined.KeyboardArrowRight // Compose 1.6 TODO: Icons.AutoMirrored.Outlined.KeyboardArrowRight
        case "Icons.Outlined.KeyboardArrowUp": return Icons.Outlined.KeyboardArrowUp
        case "Icons.Outlined.List": return Icons.Outlined.List // Compose 1.6 TODO: Icons.AutoMirrored.Outlined.List
        case "Icons.Outlined.LocationOn": return Icons.Outlined.LocationOn
        case "Icons.Outlined.Lock": return Icons.Outlined.Lock
        case "Icons.Outlined.MailOutline": return Icons.Outlined.MailOutline
        case "Icons.Outlined.Menu": return Icons.Outlined.Menu
        case "Icons.Outlined.MoreVert": return Icons.Outlined.MoreVert
        case "Icons.Outlined.Notifications": return Icons.Outlined.Notifications
        case "Icons.Outlined.Person": return Icons.Outlined.Person
        case "Icons.Outlined.Phone": return Icons.Outlined.Phone
        case "Icons.Outlined.Place": return Icons.Outlined.Place
        case "Icons.Outlined.PlayArrow": return Icons.Outlined.PlayArrow
        case "Icons.Outlined.Refresh": return Icons.Outlined.Refresh
        case "Icons.Outlined.Search": return Icons.Outlined.Search
        case "Icons.Outlined.Send": return Icons.Outlined.Send // Compose 1.6 TODO: Icons.AutoMirrored.Outlined.Send
        case "Icons.Outlined.Settings": return Icons.Outlined.Settings
        case "Icons.Outlined.Share": return Icons.Outlined.Share
        case "Icons.Outlined.ShoppingCart": return Icons.Outlined.ShoppingCart
        case "Icons.Outlined.Star": return Icons.Outlined.Star
        case "Icons.Outlined.ThumbUp": return Icons.Outlined.ThumbUp
        case "Icons.Outlined.Warning": return Icons.Outlined.Warning

        case "Icons.Filled.AccountBox": return Icons.Filled.AccountBox
        case "Icons.Filled.AccountCircle": return Icons.Filled.AccountCircle
        case "Icons.Filled.AddCircle": return Icons.Filled.AddCircle
        case "Icons.Filled.Add": return Icons.Filled.Add
        case "Icons.Filled.ArrowBack": return Icons.Filled.ArrowBack // Compose 1.6 TODO: Icons.AutoMirrored.Filled.ArrowBack
        case "Icons.Filled.ArrowDropDown": return Icons.Filled.ArrowDropDown
        case "Icons.Filled.ArrowForward": return Icons.Filled.ArrowForward // Compose 1.6 TODO: Icons.AutoMirrored.Filled.ArrowForward
        case "Icons.Filled.Build": return Icons.Filled.Build
        case "Icons.Filled.Call": return Icons.Filled.Call
        case "Icons.Filled.CheckCircle": return Icons.Filled.CheckCircle
        case "Icons.Filled.Check": return Icons.Filled.Check
        case "Icons.Filled.Clear": return Icons.Filled.Clear
        case "Icons.Filled.Close": return Icons.Filled.Close
        case "Icons.Filled.Create": return Icons.Filled.Create
        case "Icons.Filled.DateRange": return Icons.Filled.DateRange
        case "Icons.Filled.Delete": return Icons.Filled.Delete
        case "Icons.Filled.Done": return Icons.Filled.Done
        case "Icons.Filled.Edit": return Icons.Filled.Edit
        case "Icons.Filled.Email": return Icons.Filled.Email
        case "Icons.Filled.ExitToApp": return Icons.Filled.ExitToApp // Compose 1.6 TODO: Icons.AutoMirrored.Filled.ExitToApp
        case "Icons.Filled.Face": return Icons.Filled.Face
        case "Icons.Filled.FavoriteBorder": return Icons.Filled.FavoriteBorder
        case "Icons.Filled.Favorite": return Icons.Filled.Favorite
        case "Icons.Filled.Home": return Icons.Filled.Home
        case "Icons.Filled.Info": return Icons.Filled.Info
        case "Icons.Filled.KeyboardArrowDown": return Icons.Filled.KeyboardArrowDown
        case "Icons.Filled.KeyboardArrowLeft": return Icons.Filled.KeyboardArrowLeft // Compose 1.6 TODO: Icons.AutoMirrored.Filled.KeyboardArrowLeft
        case "Icons.Filled.KeyboardArrowRight": return Icons.Filled.KeyboardArrowRight // Compose 1.6 TODO: Icons.AutoMirrored.Filled.KeyboardArrowRight
        case "Icons.Filled.KeyboardArrowUp": return Icons.Filled.KeyboardArrowUp
        case "Icons.Filled.List": return Icons.Filled.List // Compose 1.6 TODO: Icons.AutoMirrored.Filled.List
        case "Icons.Filled.LocationOn": return Icons.Filled.LocationOn
        case "Icons.Filled.Lock": return Icons.Filled.Lock
        case "Icons.Filled.MailOutline": return Icons.Filled.MailOutline
        case "Icons.Filled.Menu": return Icons.Filled.Menu
        case "Icons.Filled.MoreVert": return Icons.Filled.MoreVert
        case "Icons.Filled.Notifications": return Icons.Filled.Notifications
        case "Icons.Filled.Person": return Icons.Filled.Person
        case "Icons.Filled.Phone": return Icons.Filled.Phone
        case "Icons.Filled.Place": return Icons.Filled.Place
        case "Icons.Filled.PlayArrow": return Icons.Filled.PlayArrow
        case "Icons.Filled.Refresh": return Icons.Filled.Refresh
        case "Icons.Filled.Search": return Icons.Filled.Search
        case "Icons.Filled.Send": return Icons.Filled.Send // Compose 1.6 TODO: Icons.AutoMirrored.Filled.Send
        case "Icons.Filled.Settings": return Icons.Filled.Settings
        case "Icons.Filled.Share": return Icons.Filled.Share
        case "Icons.Filled.ShoppingCart": return Icons.Filled.ShoppingCart
        case "Icons.Filled.Star": return Icons.Filled.Star
        case "Icons.Filled.ThumbUp": return Icons.Filled.ThumbUp
        case "Icons.Filled.Warning": return Icons.Filled.Warning

        case "Icons.Rounded.AccountBox": return Icons.Rounded.AccountBox
        case "Icons.Rounded.AccountCircle": return Icons.Rounded.AccountCircle
        case "Icons.Rounded.AddCircle": return Icons.Rounded.AddCircle
        case "Icons.Rounded.Add": return Icons.Rounded.Add
        case "Icons.Rounded.ArrowBack": return Icons.Rounded.ArrowBack // Compose 1.6 TODO: Icons.AutoMirrored.Rounded.ArrowBack
        case "Icons.Rounded.ArrowDropDown": return Icons.Rounded.ArrowDropDown
        case "Icons.Rounded.ArrowForward": return Icons.Rounded.ArrowForward // Compose 1.6 TODO: Icons.AutoMirrored.Rounded.ArrowForward
        case "Icons.Rounded.Build": return Icons.Rounded.Build
        case "Icons.Rounded.Call": return Icons.Rounded.Call
        case "Icons.Rounded.CheckCircle": return Icons.Rounded.CheckCircle
        case "Icons.Rounded.Check": return Icons.Rounded.Check
        case "Icons.Rounded.Clear": return Icons.Rounded.Clear
        case "Icons.Rounded.Close": return Icons.Rounded.Close
        case "Icons.Rounded.Create": return Icons.Rounded.Create
        case "Icons.Rounded.DateRange": return Icons.Rounded.DateRange
        case "Icons.Rounded.Delete": return Icons.Rounded.Delete
        case "Icons.Rounded.Done": return Icons.Rounded.Done
        case "Icons.Rounded.Edit": return Icons.Rounded.Edit
        case "Icons.Rounded.Email": return Icons.Rounded.Email
        case "Icons.Rounded.ExitToApp": return Icons.Rounded.ExitToApp // Compose 1.6 TODO: Icons.AutoMirrored.Rounded.ExitToApp
        case "Icons.Rounded.Face": return Icons.Rounded.Face
        case "Icons.Rounded.FavoriteBorder": return Icons.Rounded.FavoriteBorder
        case "Icons.Rounded.Favorite": return Icons.Rounded.Favorite
        case "Icons.Rounded.Home": return Icons.Rounded.Home
        case "Icons.Rounded.Info": return Icons.Rounded.Info
        case "Icons.Rounded.KeyboardArrowDown": return Icons.Rounded.KeyboardArrowDown
        case "Icons.Rounded.KeyboardArrowLeft": return Icons.Rounded.KeyboardArrowLeft // Compose 1.6 TODO: Icons.AutoMirrored.Rounded.KeyboardArrowLeft
        case "Icons.Rounded.KeyboardArrowRight": return Icons.Rounded.KeyboardArrowRight // Compose 1.6 TODO: Icons.AutoMirrored.Rounded.KeyboardArrowRight
        case "Icons.Rounded.KeyboardArrowUp": return Icons.Rounded.KeyboardArrowUp
        case "Icons.Rounded.List": return Icons.Rounded.List // Compose 1.6 TODO: Icons.AutoMirrored.Rounded.List
        case "Icons.Rounded.LocationOn": return Icons.Rounded.LocationOn
        case "Icons.Rounded.Lock": return Icons.Rounded.Lock
        case "Icons.Rounded.MailOutline": return Icons.Rounded.MailOutline
        case "Icons.Rounded.Menu": return Icons.Rounded.Menu
        case "Icons.Rounded.MoreVert": return Icons.Rounded.MoreVert
        case "Icons.Rounded.Notifications": return Icons.Rounded.Notifications
        case "Icons.Rounded.Person": return Icons.Rounded.Person
        case "Icons.Rounded.Phone": return Icons.Rounded.Phone
        case "Icons.Rounded.Place": return Icons.Rounded.Place
        case "Icons.Rounded.PlayArrow": return Icons.Rounded.PlayArrow
        case "Icons.Rounded.Refresh": return Icons.Rounded.Refresh
        case "Icons.Rounded.Search": return Icons.Rounded.Search
        case "Icons.Rounded.Send": return Icons.Rounded.Send // Compose 1.6 TODO: Icons.AutoMirrored.Rounded.Send
        case "Icons.Rounded.Settings": return Icons.Rounded.Settings
        case "Icons.Rounded.Share": return Icons.Rounded.Share
        case "Icons.Rounded.ShoppingCart": return Icons.Rounded.ShoppingCart
        case "Icons.Rounded.Star": return Icons.Rounded.Star
        case "Icons.Rounded.ThumbUp": return Icons.Rounded.ThumbUp
        case "Icons.Rounded.Warning": return Icons.Rounded.Warning

        case "Icons.Sharp.AccountBox": return Icons.Sharp.AccountBox
        case "Icons.Sharp.AccountCircle": return Icons.Sharp.AccountCircle
        case "Icons.Sharp.AddCircle": return Icons.Sharp.AddCircle
        case "Icons.Sharp.Add": return Icons.Sharp.Add
        case "Icons.Sharp.ArrowBack": return Icons.Sharp.ArrowBack // Compose 1.6 TODO: Icons.AutoMirrored.Sharp.ArrowBack
        case "Icons.Sharp.ArrowDropDown": return Icons.Sharp.ArrowDropDown
        case "Icons.Sharp.ArrowForward": return Icons.Sharp.ArrowForward // Compose 1.6 TODO: Icons.AutoMirrored.Sharp.ArrowForward
        case "Icons.Sharp.Build": return Icons.Sharp.Build
        case "Icons.Sharp.Call": return Icons.Sharp.Call
        case "Icons.Sharp.CheckCircle": return Icons.Sharp.CheckCircle
        case "Icons.Sharp.Check": return Icons.Sharp.Check
        case "Icons.Sharp.Clear": return Icons.Sharp.Clear
        case "Icons.Sharp.Close": return Icons.Sharp.Close
        case "Icons.Sharp.Create": return Icons.Sharp.Create
        case "Icons.Sharp.DateRange": return Icons.Sharp.DateRange
        case "Icons.Sharp.Delete": return Icons.Sharp.Delete
        case "Icons.Sharp.Done": return Icons.Sharp.Done
        case "Icons.Sharp.Edit": return Icons.Sharp.Edit
        case "Icons.Sharp.Email": return Icons.Sharp.Email
        case "Icons.Sharp.ExitToApp": return Icons.Sharp.ExitToApp // Compose 1.6 TODO: Icons.AutoMirrored.Sharp.ExitToApp
        case "Icons.Sharp.Face": return Icons.Sharp.Face
        case "Icons.Sharp.FavoriteBorder": return Icons.Sharp.FavoriteBorder
        case "Icons.Sharp.Favorite": return Icons.Sharp.Favorite
        case "Icons.Sharp.Home": return Icons.Sharp.Home
        case "Icons.Sharp.Info": return Icons.Sharp.Info
        case "Icons.Sharp.KeyboardArrowDown": return Icons.Sharp.KeyboardArrowDown
        case "Icons.Sharp.KeyboardArrowLeft": return Icons.Sharp.KeyboardArrowLeft // Compose 1.6 TODO: Icons.AutoMirrored.Sharp.KeyboardArrowLeft
        case "Icons.Sharp.KeyboardArrowRight": return Icons.Sharp.KeyboardArrowRight // Compose 1.6 TODO: Icons.AutoMirrored.Sharp.KeyboardArrowRight
        case "Icons.Sharp.KeyboardArrowUp": return Icons.Sharp.KeyboardArrowUp
        case "Icons.Sharp.List": return Icons.Sharp.List // Compose 1.6 TODO: Icons.AutoMirrored.Sharp.List
        case "Icons.Sharp.LocationOn": return Icons.Sharp.LocationOn
        case "Icons.Sharp.Lock": return Icons.Sharp.Lock
        case "Icons.Sharp.MailOutline": return Icons.Sharp.MailOutline
        case "Icons.Sharp.Menu": return Icons.Sharp.Menu
        case "Icons.Sharp.MoreVert": return Icons.Sharp.MoreVert
        case "Icons.Sharp.Notifications": return Icons.Sharp.Notifications
        case "Icons.Sharp.Person": return Icons.Sharp.Person
        case "Icons.Sharp.Phone": return Icons.Sharp.Phone
        case "Icons.Sharp.Place": return Icons.Sharp.Place
        case "Icons.Sharp.PlayArrow": return Icons.Sharp.PlayArrow
        case "Icons.Sharp.Refresh": return Icons.Sharp.Refresh
        case "Icons.Sharp.Search": return Icons.Sharp.Search
        case "Icons.Sharp.Send": return Icons.Sharp.Send // Compose 1.6 TODO: Icons.AutoMirrored.Sharp.Send
        case "Icons.Sharp.Settings": return Icons.Sharp.Settings
        case "Icons.Sharp.Share": return Icons.Sharp.Share
        case "Icons.Sharp.ShoppingCart": return Icons.Sharp.ShoppingCart
        case "Icons.Sharp.Star": return Icons.Sharp.Star
        case "Icons.Sharp.ThumbUp": return Icons.Sharp.ThumbUp
        case "Icons.Sharp.Warning": return Icons.Sharp.Warning

        case "Icons.TwoTone.AccountBox": return Icons.TwoTone.AccountBox
        case "Icons.TwoTone.AccountCircle": return Icons.TwoTone.AccountCircle
        case "Icons.TwoTone.AddCircle": return Icons.TwoTone.AddCircle
        case "Icons.TwoTone.Add": return Icons.TwoTone.Add
        case "Icons.TwoTone.ArrowBack": return Icons.TwoTone.ArrowBack // Compose 1.6 TODO: Icons.AutoMirrored.TwoTone.ArrowBack
        case "Icons.TwoTone.ArrowDropDown": return Icons.TwoTone.ArrowDropDown
        case "Icons.TwoTone.ArrowForward": return Icons.TwoTone.ArrowForward // Compose 1.6 TODO: Icons.AutoMirrored.TwoTone.ArrowForward
        case "Icons.TwoTone.Build": return Icons.TwoTone.Build
        case "Icons.TwoTone.Call": return Icons.TwoTone.Call
        case "Icons.TwoTone.CheckCircle": return Icons.TwoTone.CheckCircle
        case "Icons.TwoTone.Check": return Icons.TwoTone.Check
        case "Icons.TwoTone.Clear": return Icons.TwoTone.Clear
        case "Icons.TwoTone.Close": return Icons.TwoTone.Close
        case "Icons.TwoTone.Create": return Icons.TwoTone.Create
        case "Icons.TwoTone.DateRange": return Icons.TwoTone.DateRange
        case "Icons.TwoTone.Delete": return Icons.TwoTone.Delete
        case "Icons.TwoTone.Done": return Icons.TwoTone.Done
        case "Icons.TwoTone.Edit": return Icons.TwoTone.Edit
        case "Icons.TwoTone.Email": return Icons.TwoTone.Email
        case "Icons.TwoTone.ExitToApp": return Icons.TwoTone.ExitToApp // Compose 1.6 TODO: Icons.AutoMirrored.TwoTone.ExitToApp
        case "Icons.TwoTone.Face": return Icons.TwoTone.Face
        case "Icons.TwoTone.FavoriteBorder": return Icons.TwoTone.FavoriteBorder
        case "Icons.TwoTone.Favorite": return Icons.TwoTone.Favorite
        case "Icons.TwoTone.Home": return Icons.TwoTone.Home
        case "Icons.TwoTone.Info": return Icons.TwoTone.Info
        case "Icons.TwoTone.KeyboardArrowDown": return Icons.TwoTone.KeyboardArrowDown
        case "Icons.TwoTone.KeyboardArrowLeft": return Icons.TwoTone.KeyboardArrowLeft // Compose 1.6 TODO: Icons.AutoMirrored.TwoTone.KeyboardArrowLeft
        case "Icons.TwoTone.KeyboardArrowRight": return Icons.TwoTone.KeyboardArrowRight // Compose 1.6 TODO: Icons.AutoMirrored.TwoTone.KeyboardArrowRight
        case "Icons.TwoTone.KeyboardArrowUp": return Icons.TwoTone.KeyboardArrowUp
        case "Icons.TwoTone.List": return Icons.TwoTone.List // Compose 1.6 TODO: Icons.AutoMirrored.TwoTone.List
        case "Icons.TwoTone.LocationOn": return Icons.TwoTone.LocationOn
        case "Icons.TwoTone.Lock": return Icons.TwoTone.Lock
        case "Icons.TwoTone.MailOutline": return Icons.TwoTone.MailOutline
        case "Icons.TwoTone.Menu": return Icons.TwoTone.Menu
        case "Icons.TwoTone.MoreVert": return Icons.TwoTone.MoreVert
        case "Icons.TwoTone.Notifications": return Icons.TwoTone.Notifications
        case "Icons.TwoTone.Person": return Icons.TwoTone.Person
        case "Icons.TwoTone.Phone": return Icons.TwoTone.Phone
        case "Icons.TwoTone.Place": return Icons.TwoTone.Place
        case "Icons.TwoTone.PlayArrow": return Icons.TwoTone.PlayArrow
        case "Icons.TwoTone.Refresh": return Icons.TwoTone.Refresh
        case "Icons.TwoTone.Search": return Icons.TwoTone.Search
        case "Icons.TwoTone.Send": return Icons.TwoTone.Send // Compose 1.6 TODO: Icons.AutoMirrored.TwoTone.Send
        case "Icons.TwoTone.Settings": return Icons.TwoTone.Settings
        case "Icons.TwoTone.Share": return Icons.TwoTone.Share
        case "Icons.TwoTone.ShoppingCart": return Icons.TwoTone.ShoppingCart
        case "Icons.TwoTone.Star": return Icons.TwoTone.Star
        case "Icons.TwoTone.ThumbUp": return Icons.TwoTone.ThumbUp
        case "Icons.TwoTone.Warning": return Icons.TwoTone.Warning

        default: return nil
        }
    }
#else
    public var body: some View {
        stubView()
    }
#endif

    public enum ResizingMode : Int, Hashable {
        case tile = 0 // For bridging
        case stretch = 1 // For bridging
    }

    // SKIP @bridge
    public func resizable() -> Image {
        var image = self
        image.resizingMode = .stretch
        return image
    }

    @available(*, unavailable) // No capInsets support yet
    public func resizable(capInsets: EdgeInsets) -> Image {
        fatalError()
    }

    @available(*, unavailable) // No resizingMode support yet
    public func resizable(capInsets: EdgeInsets = EdgeInsets(), resizingMode: Image.ResizingMode) -> Image {
        fatalError()
    }

    public enum Interpolation : Hashable {
        case none
        case low
        case medium
        case high
    }

    public func interpolation(_ interpolation: Interpolation) -> Image {
        return self
    }

    public func antialiased(_ isAntialiased: Bool) -> Image {
        return self
    }

    public enum DynamicRange : Hashable {
        case standard
        case constrainedHigh
        case high
    }

    // SKIP @bridge
    public enum TemplateRenderingMode : Hashable {
        case template
        case original
    }

    // SKIP @bridge
    public func renderingMode(_ renderingMode: TemplateRenderingMode?) -> Image {
        var image = self
        image.templateRenderingMode = renderingMode
        return image
    }

    public enum Orientation : UInt8, CaseIterable, Hashable {
        case up
        case upMirrored
        case down
        case downMirrored
        case left
        case leftMirrored
        case right
        case rightMirrored
    }

    public enum Scale : Hashable {
        case small
        case medium
        case large
    }

    #if SKIP
    private func assetImageInfo(name: String, colorScheme: ColorScheme, bundle: Bundle) -> AssetImageInfo? {
        for dataURL in assetContentsURLs(name: "\(name).imageset", bundle: bundle) {
            do {
                let data = try Data(contentsOf: dataURL)
                logger.debug("loading imageset asset contents from: \(dataURL)")
                let imageSet = try JSONDecoder().decode(ImageSet.self, from: data)
                let images = imageSet.images.sortedByAssetFit(colorScheme: colorScheme)
                // fall-back to load the highest-resolution image that is set (e.g., 3x before 2x before 1x)
                if let fileName = images.compactMap(\.filename).last {
                    // get the image filename and append it to the end
                    let resURL = dataURL.deletingLastPathComponent().appendingPathComponent(fileName)
                    logger.debug("loading imageset data from: \(resURL)")
                    return AssetImageInfo(url: resURL, imageSet: imageSet)
                }
            } catch {
                logger.warning("error loading image data from \(name): \(error)")
            }
        }

        return nil
    }

    private func symbolResourceURL(name: String, bundle: Bundle) -> URL? {
        for dataURL in assetContentsURLs(name: "\(name).symbolset", bundle: bundle) {
            do {
                let data = try Data(contentsOf: dataURL)
                logger.debug("loading symbolset asset contents from \(dataURL)")
                let symbolSet = try JSONDecoder().decode(SymbolSet.self, from: data)
                if let fileName = symbolSet.symbols.compactMap(\.filename).last {
                    // get the symbol filename and append it to the end
                    let resURL = dataURL.deletingLastPathComponent().appendingPathComponent(fileName)
                    return resURL
                }
            } catch {
                logger.warning("error loading symbol data from \(name): \(error)")
            }
        }

        return nil
    }
    #endif
}

// SKIP NOWARN
extension View {
    @available(*, unavailable)
    public func imageScale(_ scale: Image.Scale) -> some View {
        return self
    }

    @available(*, unavailable)
    public func allowedDynamicRange(_ range: Image.DynamicRange?) -> some View {
        return self
    }
}

#if SKIP
private struct SymbolInfo {
    let size: SymbolSize
    let paths: [SymbolPath]
}

private struct SymbolPath {
    let pathParser: PathParser
    let attrs: [String]
}

private let symbolXMLCache : [URL: [SymbolSize: SymbolInfo]] = [:]
private let assetImageCache: [AssetKey: AssetImageInfo?] = [:]
private let contentsCache: [AssetKey: URL?] = [:]

@Composable private func ImageLayout(intrinsicWidth: Float, intrinsicHeight: Float, aspectRatio: Double?, contentMode: ContentMode?, image: @Composable () -> Void) {
    Layout(content = {
        image()
    }) { measurables, constraints in
        guard !measurables.isEmpty() else {
            return layout(width: 0, height: 0) {}
        }

        let ratio = aspectRatio ?? Double(intrinsicWidth / intrinsicHeight)
        let placeable: Placeable
        let width: Int
        let height: Int
        if constraints.hasBoundedWidth && constraints.maxWidth > 0 && constraints.hasBoundedHeight && constraints.maxHeight > 0 {
            if contentMode == nil {
                height = constraints.maxHeight
                width = constraints.maxWidth
            } else {
                let constraintsRatio =
                     Double(constraints.maxWidth) / Double(constraints.maxHeight)
                let fitToWidth =
                contentMode == .fill ? ratio < constraintsRatio : ratio > constraintsRatio
                if fitToWidth {
                    width = constraints.maxWidth
                    height = Int(width / ratio)
                } else {
                    height = constraints.maxHeight
                    width = Int(height * ratio)
                }
            }
            placeable = measurables[0].measure(constraints.copy(minWidth: width, maxWidth: width, minHeight: height, maxHeight: height))
        } else if constraints.hasBoundedWidth && constraints.maxWidth > 0 {
            width = constraints.maxWidth
            height = Int(width / ratio)
            placeable = measurables[0].measure(constraints.copy(minWidth: width, maxWidth: width, minHeight: height, maxHeight: height))
        } else if (constraints.hasBoundedHeight && constraints.maxHeight > 0) {
            height = constraints.maxHeight
            width = Int(height * ratio)
            placeable = measurables[0].measure(constraints.copy(minWidth: width, maxWidth: width, minHeight: height, maxHeight: height))
        } else {
            placeable = measurables[0].measure(constraints)
            width = placeable.width
            height = placeable.height
        }
        let layoutWidth = min(constraints.maxWidth, width)
        let layoutHeight = min(constraints.maxHeight, height)
        layout(width: layoutWidth, height: layoutHeight) {
            placeable.placeRelative(x: (layoutWidth - placeable.width) / 2, y: (layoutHeight - placeable.height) / 2)
        }
    }
}

/// Custom scale to handle fitting or filling a user-specified aspect ratio.
private struct AspectRatioContentScale: ContentScale {
    let aspectRatio: Double
    let contentMode: ContentMode

    override func computeScaleFactor(srcSize: Size, dstSize: Size) -> ScaleFactor {
        let dstAspectRatio = dstSize.width / dstSize.height
        switch contentMode {
        case .fit:
            return aspectRatio > dstAspectRatio ? fitToWidth(srcSize, dstSize) : fitToHeight(srcSize, dstSize)
        case .fill:
            return aspectRatio < dstAspectRatio ? fitToWidth(srcSize, dstSize) : fitToHeight(srcSize, dstSize)
        }
    }

    private func fitToWidth(srcSize: Size, dstSize: Size) -> ScaleFactor {
        return ScaleFactor(scaleX: dstSize.width / srcSize.width, scaleY: dstSize.width / Float(aspectRatio) / srcSize.height)
    }

    private func fitToHeight(srcSize: Size, dstSize: Size) -> ScaleFactor {
        return ScaleFactor(scaleX: dstSize.height * Float(aspectRatio) / srcSize.width, scaleY: dstSize.height / srcSize.height)
    }
}
#endif

/// The Symbols layer contains up to 27 sublayers, each representing a symbol image variant. Identifiers of symbol variants have the form <weight>-<{S, M, L}>, where weight corresponds to a weight of the system font and S, M, or L matches the small, medium, or large symbol scale.
private enum SymbolSize : String {
    case UltralightS = "Ultralight-S"
    case ThinS = "Thin-S"
    case LightS = "Light-S"
    case RegularS = "Regular-S"
    case MediumS = "Medium-S"
    case SemiboldS = "Semibold-S"
    case BoldS = "Bold-S"
    case HeavyS = "Heavy-S"
    case BlackS = "Black-S"

    case UltralightM = "Ultralight-M"
    case ThinM = "Thin-M"
    case LightM = "Light-M"
    case RegularM = "Regular-M"
    case MediumM = "Medium-M"
    case SemiboldM = "Semibold-M"
    case BoldM = "Bold-M"
    case HeavyM = "Heavy-M"
    case BlackM = "Black-M"

    case UltralightL = "Ultralight-L"
    case ThinL = "Thin-L"
    case LightL = "Light-L"
    case RegularL = "Regular-L"
    case MediumL = "Medium-L"
    case SemiboldL = "Semibold-L"
    case BoldL = "Bold-L"
    case HeavyL = "Heavy-L"
    case BlackL = "Black-L"

    var fontWeight: Font.Weight {
        switch self {
        case .UltralightS, .UltralightM, .UltralightL: return Font.Weight.ultraLight
        case .ThinS, .ThinM, .ThinL: return Font.Weight.thin
        case .LightS, .LightM, .LightL: return Font.Weight.light
        case .RegularS, .RegularM, .RegularL: return Font.Weight.regular
        case .MediumS, .MediumM, .MediumL: return Font.Weight.medium
        case .SemiboldS, .SemiboldM, .SemiboldL: return Font.Weight.semibold
        case .BoldS, .BoldM, .BoldL: return Font.Weight.bold
        case .HeavyS, .HeavyM, .HeavyL: return Font.Weight.heavy
        case .BlackS, .BlackM, .BlackL: return Font.Weight.black
        }
    }
}

#if SKIP
fileprivate struct AssetImageInfo {
    /// The URL to the asset image
    let url: URL
    /// The ImageSet that was loaded for the given info
    let imageSet: ImageSet

    var isTemplateImage: Bool {
        imageSet.properties?.templateRenderingIntent == "template"
    }
}

/* The `Contents.json` in a `*.imageset` folder for an image
 https://developer.apple.com/library/archive/documentation/Xcode/Reference/xcode_ref-Asset_Catalog_Format/ImageSetType.html
 {
   "images" : [
     {
       "filename" : "Cat.jpg",
       "idiom" : "universal",
       "scale" : "1x"
     },
     {
       "idiom" : "universal",
       "scale" : "2x"
     },
     {
       "idiom" : "universal",
       "scale" : "3x"
     }
   ],
   "info" : {
     "author" : "xcode",
     "version" : 1
   }
 }
 */
private struct ImageSet : Decodable {
    let images: [ImageInfo]
    let info: AssetContentsInfo
    let properties: ImageAssetProperties?

    struct ImageInfo : Decodable, AssetSortable {
        let filename : String?
        let idiom: String? // e.g. "universal"
        let scale: String? // e.g. "3x"
        let appearances: [AssetAppearance]?
    }

    struct ImageAssetProperties: Decodable {
        let preservesVectorRepresentation: Bool?
        let templateRenderingIntent: String?

        enum CodingKeys : String, CodingKey {
            case preservesVectorRepresentation = "preserves-vector-representation"
            case templateRenderingIntent = "template-rendering-intent"
        }
    }
}

/* The `Contents.json` in a `*.symbolset` folder for a symbol, which looks like:
 {
   "info" : {
     "author" : "xcode",
     "version" : 1
   },
   "symbols" : [
     {
       "filename" : "face.dashed.fill.svg",
       "idiom" : "universal"
     }
   ]
 }
 */
private struct SymbolSet : Decodable {
    let symbols: [Symbol]
    let info: AssetContentsInfo

    struct Symbol : Decodable {
        let filename : String?
        let idiom: String? // e.g. "universal"
    }
}
#endif

#if false
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
    public init(_ name: String, variableValue: Double?, bundle: Bundle? = Bundle.main) { fatalError() }

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
    public init(_ name: String, variableValue: Double?, bundle: Bundle? = Bundle.main, label: Text) { fatalError() }

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
    public init(decorative name: String, variableValue: Double?, bundle: Bundle? = Bundle.main) { fatalError() }
}

#if canImport(UIKit)
import struct UIKit.ImageResource

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension Image {

    /// Initialize an `Image` with an image resource.
    public init(_ resource: ImageResource) { fatalError() }
}
#endif

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
#endif
