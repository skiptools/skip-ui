// Copyright 2023–2026 Skip
// SPDX-License-Identifier: MPL-2.0
#if !SKIP_BRIDGE
import Foundation
#if SKIP
import androidx.compose.foundation.layout.Box
import androidx.compose.runtime.Composable
import androidx.compose.runtime.collectAsState
import androidx.compose.runtime.remember
import androidx.compose.ui.layout.ContentScale
import androidx.compose.ui.platform.LocalContext
import android.webkit.MimeTypeMap
import coil3.compose.AsyncImagePainter
import coil3.compose.SubcomposeAsyncImage
import coil3.compose.rememberAsyncImagePainter
import coil3.compose.rememberConstraintsSizeResolver
import coil3.request.ImageRequest
import coil3.fetch.Fetcher
import coil3.fetch.FetchResult
import coil3.ImageLoader
import coil3.decode.DataSource
import coil3.decode.ImageSource
import coil3.PlatformContext
import coil3.asImage
import kotlin.math.roundToInt
import okio.buffer
import okio.source

/// Composes AsyncImage placeholder views (empty / error / nil URL) with optional ``EnvironmentValues/_aspectRatio`` from the environment.
@Composable
private func composePlaceholder(_ view: any View, context: ComposeContext) {
    if let (aspectRatio, contentMode) = EnvironmentValues.shared._aspectRatio {
        view.aspectRatio(aspectRatio, contentMode: contentMode).Compose(context: context)
    } else {
        view.Compose(context: context)
    }
}
#endif

// SKIP @bridgeMembers
public struct AsyncImageBridgedContentArguments {
    public var image: Image?
    public var error: (any Error)?
    public var isEmpty: Bool
}

// SKIP @bridge
public struct AsyncImage : View, Renderable {
    let url: URL?
    let scale: CGFloat
    let content: (AsyncImagePhase) -> any View

    public init(url: URL?, scale: CGFloat = 1.0) {
        self.url = url
        self.scale = scale
        self.content = { phase in
            switch phase {
            case .empty:
                #if SKIP
                if let image = phase.image {
                    return ZStack {
                        Color.clear // Showing a placeholder here prevents layout shift if the image is 0x0 on the first frame
                        image
                    }
                } else {
                    return Self.defaultPlaceholder()
                }
                #else
                return Self.defaultPlaceholder()
                #endif
            case .failure:
                return Self.defaultPlaceholder()
            case .success(let image):
                return image
            }
        }
    }

    public init(url: URL?, scale: CGFloat = 1.0, @ViewBuilder content: @escaping (Image) -> any View, @ViewBuilder placeholder: @escaping () -> any View) {
        self.url = url
        self.scale = scale
        self.content = { phase in
            switch phase {
            case .empty:
                #if SKIP
                if let image = phase.image {
                    return ZStack {
                        Color.clear // Showing a placeholder here prevents layout shift if the image is 0x0 on the first frame
                        content(image)
                    }
                } else {
                    return placeholder()
                }
                #else
                return placeholder()
                #endif
            case .failure:
                return placeholder()
            case .success(let image):
                return content(image)
            }
        }
    }

    public init(url: URL?, scale: CGFloat = 1.0, transaction: Any? = nil /* Transaction = Transaction() */, @ViewBuilder content: @escaping (AsyncImagePhase) -> any View) {
        self.url = url
        self.scale = scale
        self.content = content
    }

    // Note that we reverse the `url` and `scale` parameter order just to create a unique JVM signature
    // SKIP @bridge
    public init(scale: CGFloat, url: URL?, bridgedContent: ((AsyncImageBridgedContentArguments) -> any View)?) {
        self.url = url
        self.scale = scale
        self.content = { phase in
            if let bridgedContent {
                switch phase {
                case .empty:
                    return bridgedContent(.init(image: phase.image, error: nil, isEmpty: true))
                case .failure(let error):
                    return bridgedContent(.init(image: nil, error: error, isEmpty: false))
                case .success(let image):
                    return bridgedContent(.init(image: image, error: nil, isEmpty: false))
                }
            } else {
                switch phase {
                case .empty:
                    #if SKIP
                    if let image = phase.image {
                        return ZStack {
                            Color.clear // Showing a placeholder here prevents layout shift if the image is 0x0 on the first frame
                            image
                        }
                    } else {
                        return Self.defaultPlaceholder()
                    }
                    #else
                    return Self.defaultPlaceholder()
                    #endif
                case .failure(let error):
                    return Self.defaultPlaceholder()
                case .success(let image):
                    return image
                }
            }
        }
    }

    #if SKIP
    @Composable public func Render(context: ComposeContext) {
        // Skip's aspectRatio modifier doesn't apply androidx.compose.foundation.layout.aspectRatio to AsyncImage
        // Instead, we set it in the environment, so the Image can consume it
        // If we're showing a placeholder, and the aspectRatio is in the environment, we need to apply it to the placeholder
        guard let url else {
            let placeholderView = self.content(AsyncImagePhase.empty(nil))
            composePlaceholder(placeholderView, context: context)
            return
        }

        let urlString = url.absoluteString
        // Coil does not automatically handle embedded jar URLs like
        // jar:file:/data/app/…/base.apk!/showcase/module/Resources/swift-logo.png or
        // asset:/showcase/module/Resources/swift-logo.png, so
        // we add a custom fetchers that will handle loading the URL.
        // Otherwise use Coil's default URL string handling
        let requestSource: Any = AssetURLFetcher.handlesURL(url) ? url : urlString
        let androidContext = LocalContext.current

        if EnvironmentValues.shared._subcomposeAsyncImage {
            let dm = androidContext.resources.displayMetrics
            let maxPx = max(Int(dm.widthPixels), Int(dm.heightPixels))
            let cacheKey = "\(urlString)#\(maxPx)x\(maxPx)"

            let model = remember(urlString, maxPx) {
                // Coil refuses to use its memory cache for .size(Size.ORIGINAL) requests!
                // We're using maxPx as an arbitrary bound to force it to cache properly
                // Coil memory-cache size validation is in MemoryCacheService.isCacheValueValidForSize:
                // See compose-source/io-coil-kt-coil3/coil-core-android/commonMain/coil3/memory/MemoryCacheService.kt:127.
                return ImageRequest.Builder(androidContext)
                    .fetcherFactory(AssetURLFetcher.Factory()) // handler for asset:/ and jar:file:/ URLs
                    .decoderFactory(coil3.svg.SvgDecoder.Factory())
                    //.decoderFactory(coil3.gif.GifDecoder.Factory())
                    .decoderFactory(PdfDecoder.Factory())
                    .data(requestSource)
                    .size(coil3.size.Size(width: maxPx, height: maxPx))
                    .memoryCacheKey(cacheKey)
                    .diskCacheKey(cacheKey)
                    .build()
            }

            SubcomposeAsyncImage(model: model, contentDescription: nil, loading: { _ in
                let placeholderView = content(AsyncImagePhase.empty(nil))
                composePlaceholder(placeholderView, context: context)
            }, success: { state in
                let image = Image(painter: self.painter, scale: scale)
                let content = content(AsyncImagePhase.success(image))
                content.Compose(context: context)
            }, error: { state in
                let placeholderView = content(AsyncImagePhase.failure(ErrorException(cause: state.result.throwable)))
                composePlaceholder(placeholderView, context: context)
            })
            return
        }

        let sizeResolver = rememberConstraintsSizeResolver()
        let cacheKey = "\(urlString)#layout"
        let model = remember(urlString, sizeResolver) {
            return ImageRequest.Builder(androidContext)
                .fetcherFactory(AssetURLFetcher.Factory()) // handler for asset:/ and jar:file:/ URLs
                .decoderFactory(coil3.svg.SvgDecoder.Factory())
                //.decoderFactory(coil3.gif.GifDecoder.Factory())
                .decoderFactory(PdfDecoder.Factory())
                .data(requestSource)
                .size(sizeResolver)
                .memoryCacheKey(cacheKey)
                .diskCacheKey(cacheKey)
                .build()
        }
        let painter = rememberAsyncImagePainter(model: model, contentScale: ContentScale.Fit)
        let asyncImageState = painter.state.collectAsState()

        let innerContext = context.content()
        Box(modifier: context.modifier.then(sizeResolver), contentAlignment: androidx.compose.ui.Alignment.Center) {
            let state = asyncImageState.value
            if state == AsyncImagePainter.State.Empty {
                // In this case, Coil doesn't yet know the true state
                // If the image is cached in memory, we can render it right away
                // If not, we'd want to show a placeholder
                let coilImage = Image(painter: painter, scale: scale)
                let placeholderView = content(AsyncImagePhase.empty(coilImage))
                composePlaceholder(placeholderView, context: innerContext)
            } else if state is AsyncImagePainter.State.Loading {
                let placeholderView = content(AsyncImagePhase.empty(nil))
                composePlaceholder(placeholderView, context: innerContext)
            } else if state is AsyncImagePainter.State.Success {
                let image = Image(painter: painter, scale: scale)
                let successContent = content(AsyncImagePhase.success(image))
                successContent.Compose(context: innerContext)
            } else if state is AsyncImagePainter.State.Error {
                let errorState = state as! AsyncImagePainter.State.Error
                let placeholderView = content(AsyncImagePhase.failure(ErrorException(cause: errorState.result.throwable)))
                composePlaceholder(placeholderView, context: innerContext)
            }
        }
    }
    #else
    public var body: some View {
        stubView()
    }
    #endif

    @ViewBuilder private static func defaultPlaceholder() -> some View {
        #if SKIP
        Color.placeholder
        #else
        stubView()
        #endif
    }
}

public enum AsyncImagePhase {
    // This is either Coil's `Loading` state with a nil image, or `Empty` state with a painter-backed image
    // In Coil's `Empty` state, Coil doesn't yet know whether the image is in memory cache or not
    case empty(Image?)
    case success(Image)
    case failure(Error)

    public var image: Image? {
        switch self {
        case .success(let image):
            return image
        case .empty(let image):
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

#if SKIP
/// A Coil fetcher that handles `skip.foundation.URL` instances for known custom URL schemes.
final class AssetURLFetcher : Fetcher {
    private let url: URL
    private let options: coil3.request.Options
    static let handledURLSchemes: Set<String> = ["asset", "jar", "jarfile", "jar:file"]

    static func handlesURL(_ url: URL) -> Bool {
        guard let scheme = url.scheme else { return false }
        return handledURLSchemes.contains(scheme)
    }

    init(url: URL, options: coil3.request.Options) {
        self.url = url
        self.options = options
    }

    override func fetch() async -> FetchResult {
        let ctx = options.context
        let stream = url.kotlin().toURL().openConnection().getInputStream().source().buffer()
        let source = coil3.decode.ImageSource(source: stream, fileSystem: okio.FileSystem.SYSTEM)
        let mimeType = MimeTypeMap.getSingleton().getMimeTypeFromExtension(MimeTypeMap.getFileExtensionFromUrl(url.absoluteString))
        let dataSource: coil3.decode.DataSource = coil3.decode.DataSource.DISK
        return coil3.fetch.SourceFetchResult(source: source, mimeType: mimeType, dataSource: dataSource)
    }

    final class Factory : Fetcher.Factory<URL> {
        override func create(data: URL, options: coil3.request.Options, imageLoader: ImageLoader) -> Fetcher? {
            if (!AssetURLFetcher.handlesURL(data)) { return nil }
            return AssetURLFetcher(url: data, options: options)
        }
    }
}

class PdfDecoder : coil3.decode.Decoder {
    let sourceResult: coil3.fetch.SourceFetchResult
    let options: coil3.request.Options

    final class Factory : coil3.decode.Decoder.Factory {
        override func create(result: coil3.fetch.SourceFetchResult, options: coil3.request.Options, imageLoader: coil3.ImageLoader) -> coil3.decode.Decoder? {
            //logger.debug("PdfDecoder.Factory.create result=\(result) options=\(options) imageLoader=\(imageLoader)")
            return PdfDecoder(sourceResult: result, options: options)
        }
    }

    init(sourceResult: coil3.fetch.SourceFetchResult, options: coil3.request.Options) {
        self.sourceResult = sourceResult
        self.options = options
    }

    override func decode() async -> coil3.decode.DecodeResult? {
        let src: coil3.decode.ImageSource = sourceResult.source
        let source: okio.BufferedSource = src.source()

        // make sure it is a PDF image by scanning for "%PDF-" (25 50 44 46 2D)
        let peek = source.peek()
        // logger.debug("PdfDecoder.decode peek \(peek.readByte()) \(peek.readByte()) \(peek.readByte()) \(peek.readByte()) \(peek.readByte())")

        if peek.readByte() != Byte(0x25) { return nil } // %
        if peek.readByte() != Byte(0x50) { return nil } // P
        if peek.readByte() != Byte(0x44) { return nil } // D
        if peek.readByte() != Byte(0x46) { return nil } // F
        if peek.readByte() != Byte(0x2D) { return nil } // -

        // Unfortunately, PdfRenderer requires a ParcelFileDescriptor, which can only be created from an actual file, and not the JarInputStream from which we load assets from the .apk; so we need to write the PDF out to a temporary file in order to be able to render the PDF to a Bitmap that Coil can use
        // Fortunately, even through we are loading from a buffer, Coil's ImageSource.file() function will: “Return a Path that resolves to a file containing this ImageSource's data. If this image source is backed by a BufferedSource, a temporary file containing this ImageSource's data will be created.”
        let imageFile = src.file().toFile()

        let parcelFileDescriptor = android.os.ParcelFileDescriptor.open(imageFile, android.os.ParcelFileDescriptor.MODE_READ_ONLY)
        defer { parcelFileDescriptor.close() }

        let pdfRenderer = android.graphics.pdf.PdfRenderer(parcelFileDescriptor)
        defer { pdfRenderer.close() }

        let page = pdfRenderer.openPage(0)
        defer { page.close() }

        let density = options.context.resources.displayMetrics.density

        let srcWidth = Double(page.width * density)
        let srcHeight = Double(page.height * density)

        let optionsWidth = (options.size.width as? coil3.size.Dimension.Pixels)?.px.toDouble()
        let optionsHeight = (options.size.height as? coil3.size.Dimension.Pixels)?.px.toDouble()

        let dstWidth: Double = optionsWidth ?? srcWidth
        let dstHeight: Double = optionsHeight ?? srcHeight

        let scale = coil3.decode.DecodeUtils.computeSizeMultiplier(srcWidth: srcWidth, srcHeight: srcHeight, dstWidth: dstWidth, dstHeight: dstHeight, scale: options.scale)

        let width = (scale * srcWidth).roundToInt()
        let height = (scale * srcHeight).roundToInt()

        logger.debug("PdfDecoder.decode result=\(sourceResult) options=\(options) imageFile=\(imageFile) width=\(width) height=\(height)")
        let bitmap = android.graphics.Bitmap.createBitmap(width, height, android.graphics.Bitmap.Config.ARGB_8888)
        page.render(bitmap, nil, nil, android.graphics.pdf.PdfRenderer.Page.RENDER_MODE_FOR_DISPLAY)

        let drawable = android.graphics.drawable.BitmapDrawable(options.context.resources, bitmap)
        return coil3.decode.DecodeResult(image: drawable.asImage(), isSampled: true)
    }
}
#endif
#endif
