// Copyright 2023–2025 Skip
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception
#if !SKIP_BRIDGE
import Foundation
#if SKIP
import androidx.compose.runtime.Composable
import androidx.compose.ui.platform.LocalContext
import android.webkit.MimeTypeMap
import coil3.compose.SubcomposeAsyncImage
import coil3.request.ImageRequest
import coil3.size.Size
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
#endif

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
                return Self.defaultPlaceholder()
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
                return placeholder()
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
    public init(scale: CGFloat, url: URL?, bridgedContent: ((Image?, (any Error)?) -> any View)?) {
        self.url = url
        self.scale = scale
        self.content = { phase in
            switch phase {
            case .empty:
                if let bridgedContent {
                    return bridgedContent(nil, nil)
                } else {
                    return Self.defaultPlaceholder()
                }
            case .failure(let error):
                if let bridgedContent {
                    return bridgedContent(nil, error)
                } else {
                    return Self.defaultPlaceholder()
                }
            case .success(let image):
                if let bridgedContent {
                    return bridgedContent(image, nil)
                } else {
                    return image
                }
            }
        }
    }

    #if SKIP
    @Composable public func Render(context: ComposeContext) {
        guard let url else {
            let _ = self.content(AsyncImagePhase.empty).Compose(context)
            return
        }

        let urlString = url.absoluteString
        // Coil does not automatically handle embedded jar URLs like
        // jar:file:/data/app/…/base.apk!/showcase/module/Resources/swift-logo.png or
        // asset:/showcase/module/Resources/swift-logo.png, so
        // we add a custom fetchers that will handle loading the URL.
        // Otherwise use Coil's default URL string handling
        let requestSource: Any = AssetURLFetcher.handlesURL(url) ? url : urlString
        let model = ImageRequest.Builder(LocalContext.current)
            .fetcherFactory(AssetURLFetcher.Factory()) // handler for asset:/ and jar:file:/ URLs
            .decoderFactory(coil3.svg.SvgDecoder.Factory())
            //.decoderFactory(coil3.gif.GifDecoder.Factory())
            .decoderFactory(PdfDecoder.Factory())
            .data(requestSource)
            .size(Size.ORIGINAL)
            .memoryCacheKey(urlString)
            .diskCacheKey(urlString)
            .build()
        SubcomposeAsyncImage(model: model, contentDescription: nil, loading: { _ in
            content(AsyncImagePhase.empty).Compose(context: context)
        }, success: { state in
            let image = Image(painter: self.painter, scale: scale)
            content(AsyncImagePhase.success(image)).Compose(context: context)
        }, error: { state in
            content(AsyncImagePhase.failure(ErrorException(cause: state.result.throwable))).Compose(context: context)
        })
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
