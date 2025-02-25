// Copyright 2023–2025 Skip
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception
#if !SKIP_BRIDGE
import Foundation
#if SKIP
import android.graphics.Bitmap
import android.graphics.BitmapFactory
#endif

public class UIImage {
    #if SKIP
    let bitmap: Bitmap?
    #endif

    @available(*, unavailable)
    public init?(named: String, in bundle: Bundle? = nil, compatibleWith traitCollection: Any? = nil) {
        #if SKIP
        self.bitmap = nil
        #endif
        self.scale = 1.0
    }
    @available(*, unavailable)
    public init?(named: String, in bundle: Bundle?, with configuration: UIImage.Configuration?, unusedp: Void? = nil) {
        #if SKIP
        self.bitmap = nil
        #endif
        self.scale = 1.0
    }
    @available(*, unavailable)
    public init?(named: String, in bundle: Bundle? = nil, variableValue: Double, configuration: UIImage.Configuration? = nil) {
        #if SKIP
        self.bitmap = nil
        #endif
        self.scale = 1.0
    }
    @available(*, unavailable)
    public init(imageLiteralResourceName: String, unusedp_0: Void? = nil, unusedp_1: Void? = nil) {
        #if SKIP
        self.bitmap = nil
        #endif
        self.scale = 1.0
    }
    @available(*, unavailable)
    public init?(systemName: String, withConfiguration configuration: UIImage.Configuration? = nil, unusedp_0: Void? = nil, unusedp_1: Void? = nil, unusedp_2: Void? = nil) {
        #if SKIP
        self.bitmap = nil
        #endif
        self.scale = 1.0
    }
    @available(*, unavailable)
    public init?(systemName: String, variableValue: Double, configuration: UIImage.Configuration? = nil, unusedp: Void? = nil) {
        #if SKIP
        self.bitmap = nil
        #endif
        self.scale = 1.0
    }
    @available(*, unavailable)
    public init?(systemName: String, compatibleWith traitCollection: Any?, unusedp_0: Void? = nil, unusedp_1: Void? = nil, unusedp_2: Void? = nil, unusedp_3: Void? = nil) {
        #if SKIP
        self.bitmap = nil
        #endif
        self.scale = 1.0
    }
    @available(*, unavailable)
    public init(resource: Any, unusedp_0: Void? = nil, unusedp_1: Void? = nil, unusedp_2: Void? = nil, unusedp_3: Void? = nil) {
        #if SKIP
        self.bitmap = nil
        #endif
        self.scale = 1.0
    }
    @available(*, unavailable)
    public func preparingForDisplay() -> UIImage? {
        fatalError()
    }
    @available(*, unavailable)
    public func prepareForDisplay(completionHandler: @escaping (UIImage?) -> Void) {
        fatalError()
    }
    @available(*, unavailable)
    public func preparingThumbnail(of size: CGSize) -> UIImage? {
        fatalError()
    }
    @available(*, unavailable)
    public func prepareThumbnail(of size: CGSize, completionHandler: @escaping (UIImage?) -> Void) {
        fatalError()
    }

    public init?(contentsOfFile path: String) {
        #if SKIP
        guard let bitmap = BitmapFactory.decodeFile(path) else {
            return nil
        }
        self.bitmap = bitmap
        #endif
        self.scale = 1.0
    }

    public init?(data: Data, scale: CGFloat = 1.0) {
        #if SKIP
        let bytes = data.kotlin(nocopy: true)
        guard let bitmap = BitmapFactory.decodeByteArray(bytes, 0, bytes.count()) else {
            return nil
        }
        self.bitmap = bitmap
        #endif
        self.scale = scale
    }

    @available(*, unavailable)
    public struct UIImageReader {
    }
    @available(*, unavailable)
    public static func animatedImageNamed(_ name: String, duration: TimeInterval) -> UIImage? {
        fatalError()
    }
    @available(*, unavailable)
    public static func animatedImage(with images: [UIImage], duration: TimeInterval) -> UIImage? {
        fatalError()
    }
    @available(*, unavailable)
    public static func animatedResizableImageNamed(_ name: String, capInsets: Any, resizingMode: Any? = nil, duration: TimeInterval) -> UIImage? {
        fatalError()
    }
    @available(*, unavailable)
    public func withConfiguration(_ configuration: UIImage.Configuration) -> UIImage {
        fatalError()
    }
    @available(*, unavailable)
    public func applyingSymbolConfiguration(_ configuration: Any) -> UIImage? {
        fatalError()
    }
    @available(*, unavailable)
    public func imageFlippedForRightToLeftLayoutDirection() -> UIImage {
        fatalError()
    }
    @available(*, unavailable)
    public func withHorizontallyFlippedOrientation() -> UIImage {
        fatalError()
    }
    @available(*, unavailable)
    public func withRenderingMode(_ renderingMode: Any) -> UIImage {
        fatalError()
    }
    @available(*, unavailable)
    public func withAlignmentRectInsets(_ insets: Any) -> UIImage {
        fatalError()
    }
    @available(*, unavailable)
    public func resizableImage(withCapInsets insets: Any, resizingMode: Any? = nil) -> UIImage {
        fatalError()
    }
    @available(*, unavailable)
    public func imageWithoutBaseline() -> UIImage {
        fatalError()
    }
    @available(*, unavailable)
    public func withBaselineOffset(fromBottom offset: CGFloat) -> UIImage {
        fatalError()
    }
    @available(*, unavailable)
    public static var add: UIImage {
        fatalError()
    }
    @available(*, unavailable)
    public static var remove: UIImage {
        fatalError()
    }
    @available(*, unavailable)
    public static var actions: UIImage {
        fatalError()
    }
    @available(*, unavailable)
    public static var checkmark: UIImage {
        fatalError()
    }
    @available(*, unavailable)
    public static var strokedCheckmark: UIImage {
        fatalError()
    }

    public let scale: CGFloat

    @available(*, unavailable)
    public var size: CGSize {
        fatalError()
    }
    @available(*, unavailable)
    public var imageOrientation: Any {
        fatalError()
    }
    @available(*, unavailable)
    public var flipsForRightToLeftLayoutDirection: Bool {
        fatalError()
    }
    @available(*, unavailable)
    public var resizingMode: Any {
        fatalError()
    }
    @available(*, unavailable)
    public var duration: TimeInterval {
        fatalError()
    }
    @available(*, unavailable)
    public var capInsets: Any {
        fatalError()
    }
    @available(*, unavailable)
    public var alignmentRectInsets: Any {
        fatalError()
    }
    @available(*, unavailable)
    public var isSymbolImage: Bool {
        fatalError()
    }
    @available(*, unavailable)
    public var configuration: Any? {
        fatalError()
    }
    @available(*, unavailable)
    public var symbolConfiguration: Any? {
        fatalError()
    }
    @available(*, unavailable)
    public var traitCollection: Any {
        fatalError()
    }
    @available(*, unavailable)
    public var isHighDynamicRange: Bool {
        fatalError()
    }
    @available(*, unavailable)
    public func imageRestrictedToStandardDynamicRange() -> UIImage {
        fatalError()
    }
    @available(*, unavailable)
    public func heicData() -> Data? {
        fatalError()
    }
    @available(*, unavailable)
    public var baselineOffsetFromBottom: CGFloat? {
        fatalError()
    }
    @available(*, unavailable)
    public var renderingMode: Any {
        fatalError()
    }
    @available(*, unavailable)
    public func withTintColor(_ color: Any, renderingMode: Any? = nil) -> UIImage {
        fatalError()
    }
    @available(*, unavailable)
    public func draw(at point: CGPoint, blendMode: Any? = nil, alpha: CGFloat? = nil) {
    }
    @available(*, unavailable)
    func draw(in rect: CGRect, blendMode: Any? = nil, alpha: CGFloat? = nil) {
    }
    @available(*, unavailable)
    public func drawAsPattern(in rect: CGRect) {
    }
    public func jpegData(compressionQuality: CGFloat) -> Data? {
        #if !SKIP
        return nil
        #else
        guard let bitmap else { return nil }
        let outputStream = java.io.ByteArrayOutputStream()
        bitmap.compress(Bitmap.CompressFormat.JPEG, Int(compressionQuality * 100.0), outputStream)
        let bytes = outputStream.toByteArray()
        return Data(platformValue: bytes)
        #endif
    }
    public func pngData() -> Data? {
        #if !SKIP
        return nil
        #else
        guard let bitmap else { return nil }
        let outputStream = java.io.ByteArrayOutputStream()
        bitmap.compress(Bitmap.CompressFormat.PNG, 100, outputStream)
        let bytes = outputStream.toByteArray()
        return Data(platformValue: bytes)
        #endif
    }

    public struct Configuration {
    }
}

#endif
