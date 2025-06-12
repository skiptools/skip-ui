// Copyright 2023–2025 Skip
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception
#if !SKIP_BRIDGE
import Foundation
#if SKIP
import androidx.compose.foundation.gestures.detectTapGestures
import androidx.compose.material3.LocalTextStyle
import androidx.compose.material3.MaterialTheme
import androidx.compose.runtime.Composable
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.rememberUpdatedState
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.DrawModifier
import androidx.compose.ui.graphics.Brush
import androidx.compose.ui.graphics.SolidColor
import androidx.compose.ui.graphics.drawOutline
import androidx.compose.ui.graphics.drawscope.ContentDrawScope
import androidx.compose.ui.graphics.Brush
import androidx.compose.ui.input.pointer.pointerInput
import androidx.compose.ui.text.AnnotatedString
import androidx.compose.ui.text.ExperimentalTextApi
import androidx.compose.ui.text.SpanStyle
import androidx.compose.ui.text.TextLayoutResult
import androidx.compose.ui.text.TextStyle
import androidx.compose.ui.text.UrlAnnotation
import androidx.compose.ui.text.buildAnnotatedString
import androidx.compose.ui.text.font.FontFamily
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.font.FontStyle
import androidx.compose.ui.text.style.LineHeightStyle
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.text.style.TextDecoration
import androidx.compose.ui.text.style.TextOverflow
import androidx.compose.ui.unit.TextUnit
import skip.foundation.LocalizedStringResource
import skip.foundation.Bundle
import skip.foundation.Locale
#elseif canImport(CoreGraphics)
import struct CoreGraphics.CGFloat
#endif

// SKIP @bridge
public struct Text: View, Equatable {
    private let textView: _Text
    private let modifiedView: any View

    // SKIP @bridge
    public init(verbatim: String) {
        textView = _Text(verbatim: verbatim)
        modifiedView = textView
    }

    public init(_ attributedContent: AttributedString) {
        textView = _Text(attributedString: attributedContent)
        modifiedView = textView
    }

    public init(_ key: LocalizedStringKey, tableName: String? = nil, bundle: Bundle? = Bundle.main, comment: StaticString? = nil) {
        textView = _Text(key: key, tableName: tableName, bundle: bundle)
        modifiedView = textView
    }

    public init(_ resource: LocalizedStringResource) {
        #if SKIP // LocalizedStringResource.keyAndValue is not accessible via Foundation
        textView = _Text(key: LocalizedStringKey(resource), tableName: resource.table, bundle: resource.bundle?.bundle ?? Bundle.main)
        #else
        textView = _Text(verbatim: "MissingLocalizedStringResource")
        #endif
        modifiedView = textView
    }

    public init(_ key: String, tableName: String? = nil, bundle: Bundle? = Bundle.main, comment: StaticString? = nil) {
        textView = _Text(key: LocalizedStringKey(stringLiteral: key), tableName: tableName, bundle: bundle)
        modifiedView = textView
    }

    public init(_ date: Date, style: Text.DateStyle) {
        self.init(verbatim: style.format(date))
    }

    // SKIP @bridge
    public init(keyPattern: String, keyValues: [Any]?, tableName: String?, bridgedBundle: Any?) {
        let interpolation = LocalizedStringKey.StringInterpolation(pattern: keyPattern, values: keyValues)
        textView = _Text(key: LocalizedStringKey(stringInterpolation: interpolation), tableName: tableName, bundle: bridgedBundle as? Bundle)
        modifiedView = textView
    }

    init(textView: _Text, modifiedView: any View) {
        self.textView = textView
        // Don't copy view
        // SKIP REPLACE: this.modifiedView = modifiedView
        self.modifiedView = modifiedView
    }

    #if SKIP
    /// Interpret the key against the given bundle and the environment's current locale.
    @Composable public func localizedTextString() -> String {
        return textView.localizedTextString()
    }

    @Composable public override func ComposeContent(context: ComposeContext) {
        modifiedView.Compose(context: context)
    }

    /// Gather text style information for the current environment.
    @Composable static func styleInfo(textEnvironment: TextEnvironment, redaction: RedactionReasons, context: ComposeContext) -> TextStyleInfo {
        var isUppercased = textEnvironment.textCase == Text.Case.uppercase
        let isLowercased = textEnvironment.textCase == Text.Case.lowercase
        var font: Font
        if let environmentFont = EnvironmentValues.shared.font {
            font = environmentFont
        } else if let sectionHeaderStyle = EnvironmentValues.shared._listSectionHeaderStyle {
            font = Font.callout
            if sectionHeaderStyle == .plain {
                font = font.bold()
            } else {
                isUppercased = true
            }
        } else if let sectionFooterStyle = EnvironmentValues.shared._listSectionFooterStyle, sectionFooterStyle != .plain {
            font = Font.footnote
        } else {
            font = Font(fontImpl: { LocalTextStyle.current })
        }
        if let weight = textEnvironment.fontWeight {
            font = font.weight(weight)
        }
        if let design = textEnvironment.fontDesign {
            font = font.design(design)
        }
        if textEnvironment.isItalic == true {
            font = font.italic()
        }

        var textColor: androidx.compose.ui.graphics.Color? = nil
        var textBrush: Brush? = nil
        if let foregroundStyle = EnvironmentValues.shared._foregroundStyle {
            if let color = foregroundStyle.asColor(opacity: 1.0, animationContext: context) {
                textColor = color
            } else if !redaction.isEmpty {
                textColor = Color.primary.colorImpl()
            } else {
                textBrush = foregroundStyle.asBrush(opacity: 1.0, animationContext: context)
            }
        } else if EnvironmentValues.shared._listSectionHeaderStyle != nil {
            textColor = Color.secondary.colorImpl()
        } else if let sectionFooterStyle = EnvironmentValues.shared._listSectionFooterStyle, sectionFooterStyle != .plain {
            textColor = Color.secondary.colorImpl()
        } else {
            textColor = EnvironmentValues.shared._placement.contains(ViewPlacement.systemTextColor) ? androidx.compose.ui.graphics.Color.Unspecified : Color.primary.colorImpl()
        }

        var style = font.fontImpl()
        // Trim the line height padding to mirror SwiftUI.Text layout. For now we only do this here on the Text component
        // rather than in Font to de-risk this aberration from Compose default text style behavior
        style = style.copy(lineHeightStyle: LineHeightStyle(alignment: LineHeightStyle.Alignment.Center, trim: LineHeightStyle.Trim.Both))
        if let textBrush {
            style = style.copy(brush: textBrush)
        }
        if redaction.contains(RedactionReasons.placeholder) {
            if let textColor {
                style = style.copy(background: textColor.copy(alpha: textColor.alpha * Float(Color.placeholderOpacity)))
            }
            textColor = androidx.compose.ui.graphics.Color.Transparent
        }
        return TextStyleInfo(style: style, color: textColor, isUppercased: isUppercased, isLowercased: isLowercased)
    }
    #else
    public var body: some View {
        stubView()
    }
    #endif

    // SKIP @bridge
    public static func ==(lhs: Text, rhs: Text) -> Bool {
        return lhs.textView == rhs.textView
    }

    // Text-specific implementations of View modifiers

    public func accessibilityLabel(_ label: Text) -> Text {
        return Text(textView: textView, modifiedView: modifiedView.accessibilityLabel(label))
    }

    public func accessibilityLabel(_ label: String) -> Text {
        return Text(textView: textView, modifiedView: modifiedView.accessibilityLabel(label))
    }

    public func foregroundColor(_ color: Color?) -> Text {
        return Text(textView: textView, modifiedView: modifiedView.foregroundColor(color))
    }

    public func foregroundStyle(_ style: any ShapeStyle) -> Text {
        return Text(textView: textView, modifiedView: modifiedView.foregroundStyle(style))
    }

    public func font(_ font: Font?) -> Text {
        return Text(textView: textView, modifiedView: modifiedView.font(font))
    }

    public func fontWeight(_ weight: Font.Weight?) -> Text {
        return Text(textView: textView, modifiedView: modifiedView.fontWeight(weight))
    }

    @available(*, unavailable)
    public func fontWidth(_ width: Font.Width?) -> Text {
        return self
    }

    public func bold(_ isActive: Bool = true) -> Text {
        return Text(textView: textView, modifiedView: modifiedView.bold(isActive))
    }

    public func italic(_ isActive: Bool = true) -> Text {
        return Text(textView: textView, modifiedView: modifiedView.italic(isActive))
    }

    public func monospaced(_ isActive: Bool = true) -> Text {
        return Text(textView: textView, modifiedView: modifiedView.monospaced(isActive))
    }

    public func fontDesign(_ design: Font.Design?) -> Text {
        return Text(textView: textView, modifiedView: modifiedView.fontDesign(design))
    }

    @available(*, unavailable)
    public func monospacedDigit() -> Text {
        return self
    }

    public func strikethrough(_ isActive: Bool = true, pattern: Text.LineStyle.Pattern = .solid, color: Color? = nil) -> Text {
        return Text(textView: textView, modifiedView: modifiedView.strikethrough(isActive, pattern: pattern, color: color))
    }

    public func underline(_ isActive: Bool = true, pattern: Text.LineStyle.Pattern = .solid, color: Color? = nil) -> Text {
        return Text(textView: textView, modifiedView: modifiedView.underline(isActive, pattern: pattern, color: color))
    }

    @available(*, unavailable)
    public func kerning(_ kerning: CGFloat) -> Text {
        return self
    }

    @available(*, unavailable)
    public func tracking(_ tracking: CGFloat) -> Text {
        return self
    }

    @available(*, unavailable)
    public func baselineOffset(_ baselineOffset: CGFloat) -> Text {
        return self
    }

    public enum Case : Int, Equatable {
        case uppercase = 0 // For bridging
        case lowercase = 1 // For bridging
    }

    public struct LineStyle : Hashable {
        public let pattern: Text.LineStyle.Pattern
        public let color: Color?

        public init(pattern: Text.LineStyle.Pattern = .solid, color: Color? = nil) {
            self.pattern = pattern
            self.color = color
        }

        public enum Pattern {
            case solid
            case dot
            case dash
            case dashot
            case dashDotDot
        }

        public static let single = Text.LineStyle()
    }

    public enum Scale : Hashable {
        case `default`
        case secondary
    }

    public enum TruncationMode {
        case head
        case tail
        case middle
    }

    public struct DateStyle {
        public static let time = DateStyle(format: { date in
            let formatter = DateFormatter()
            formatter.timeStyle = .medium
            return formatter.string(from: date)
        })

        public static let date = DateStyle(format: { date in
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            return formatter.string(from: date)
        })

        @available(*, unavailable)
        public static let relative = DateStyle(format: { _ in fatalError() })

        @available(*, unavailable)
        public static let offset = DateStyle(format: { _ in fatalError() })
        
        @available(*, unavailable)
        public static let timer = DateStyle(format: { _ in fatalError() })

        let format: (Date) -> String

        private init(format: @escaping (Date) -> String) {
            self.format = format
        }
    }

    public struct WritingDirectionStrategy : Hashable {
        @available(*, unavailable)
        public static let layoutBased = WritingDirectionStrategy()
        public static let contentBased = WritingDirectionStrategy()
        public static let `default` = WritingDirectionStrategy()
    }

    public struct AlignmentStrategy : Hashable {
        @available(*, unavailable)
        public static let layoutBased = AlignmentStrategy()
        @available(*, unavailable)
        public static let writingDirectionBased = AlignmentStrategy()
        public static let `default` = Text.AlignmentStrategy()
    }
}

struct _Text: View, Equatable {
    let verbatim: String?
    let attributedString: AttributedString?
    let key: LocalizedStringKey?
    let tableName: String?
    let bundle: Bundle?

    init(verbatim: String? = nil, attributedString: AttributedString? = nil, key: LocalizedStringKey? = nil, tableName: String? = nil, bundle: Bundle? = nil) {
        self.verbatim = verbatim
        self.attributedString = attributedString
        self.key = key
        self.tableName = tableName
        self.bundle = bundle
    }

    #if SKIP
    @Composable func localizedTextString() -> String {
        let (locfmt, _, interpolations) = localizedTextInfo()
        if let interpolations, !interpolations.isEmpty() {
            return locfmt.format(*interpolations.toTypedArray())
        } else {
            return locfmt
        }
    }

    @Composable private func localizedTextInfo() -> (String, MarkdownNode?, kotlin.collections.List<AnyHashable>?) {
        if let verbatim { return (verbatim, nil, nil) }
        if let attributedString { return (attributedString.string, attributedString.markdownNode, nil) }
        guard let key else { return ("", nil, nil) }

        // localize and Kotlin-ize the format string. the string is cached by the bundle, and we
        // cache the Kotlin-ized version too so that we don't have to convert it on every compose
        let locale = EnvironmentValues.shared.locale
        if let (_, locfmt, locnode) = (self.bundle ?? Bundle.main).localizedInfo(forKey: key.patternFormat, value: nil, table: self.tableName, locale: locale) {
            return (locfmt, locnode, key.stringInterpolation.values)
        } else {
            return (key.patternFormat.kotlinFormatString, MarkdownNode.from(string: key.patternFormat), key.stringInterpolation.values)
        }
    }

    // SKIP INSERT: @OptIn(ExperimentalTextApi::class)
    @Composable override func ComposeContent(context: ComposeContext) {
        let (locfmt, locnode, interpolations) = localizedTextInfo()
        let textEnvironment = EnvironmentValues.shared._textEnvironment
        let textDecoration = textEnvironment.textDecoration
        let textAlign = EnvironmentValues.shared.multilineTextAlignment.asTextAlign()
        let maxLines = max(1, EnvironmentValues.shared.lineLimit ?? Int.MAX_VALUE)
        let reservesSpace = EnvironmentValues.shared._lineLimitReservesSpace ?? false
        let minLines = reservesSpace ? maxLines : 1
        let redaction = EnvironmentValues.shared.redactionReasons
        let styleInfo = Text.styleInfo(textEnvironment: textEnvironment, redaction: redaction, context: context)
        let animatable = styleInfo.style.asAnimatable(context: context)
        var options: Material3TextOptions
        if let locnode {
            let layoutResult = remember { mutableStateOf<TextLayoutResult?>(nil) }
            let isPlaceholder = redaction.contains(RedactionReasons.placeholder)
            var linkColor = EnvironmentValues.shared._tint?.colorImpl() ?? Color.accentColor.colorImpl()
            if isPlaceholder {
                linkColor = linkColor.copy(alpha: linkColor.alpha * Float(Color.placeholderOpacity))
            }
            let annotatedText = annotatedString(markdown: locnode, interpolations: interpolations, linkColor: linkColor, isUppercased: styleInfo.isUppercased, isLowercased: styleInfo.isLowercased, isRedacted: isPlaceholder)
            let links = annotatedText.getUrlAnnotations(start: 0, end: annotatedText.length)
            var modifier = context.modifier
            if !links.isEmpty() {
                let currentText = rememberUpdatedState(annotatedText)
                let currentHandler = rememberUpdatedState(EnvironmentValues.shared.openURL)
                let currentIsEnabled = rememberUpdatedState(EnvironmentValues.shared.isEnabled)
                modifier = modifier.pointerInput(true) {
                    detectTapGestures { pos in
                        if currentIsEnabled.value, let offset = layoutResult.value?.getOffsetForPosition(pos), let urlString = currentText.value.getUrlAnnotations(offset, offset).firstOrNull()?.item.url, let url = URL(string: urlString) {
                            currentHandler.value.invoke(url)
                        }
                    }
                }
            }
            options = Material3TextOptions(annotatedText: annotatedText, modifier: modifier, color: styleInfo.color ?? androidx.compose.ui.graphics.Color.Unspecified, maxLines: maxLines, minLines: minLines, style: animatable.value, textDecoration: textDecoration, textAlign: textAlign, onTextLayout: { layoutResult.value = $0 })
        } else {
            var text: String
            if let interpolations {
                text = locfmt.format(*interpolations.toTypedArray())
            } else {
                text = locfmt
            }
            if styleInfo.isUppercased {
                text = text.uppercased()
            } else if styleInfo.isLowercased {
                text = text.lowercased()
            }
            options = Material3TextOptions(text: text, modifier: context.modifier, color: styleInfo.color ?? androidx.compose.ui.graphics.Color.Unspecified, maxLines: maxLines, minLines: minLines, style: animatable.value, textDecoration: textDecoration, textAlign: textAlign)
        }
        if let updateOptions = EnvironmentValues.shared._material3Text {
            options = updateOptions(options)
        }
        if let annotatedText = options.annotatedText, let onTextLayout = options.onTextLayout {
            androidx.compose.material3.Text(text: annotatedText, modifier: options.modifier, color: options.color, fontSize: options.fontSize, fontStyle: options.fontStyle, fontWeight: options.fontWeight, fontFamily: options.fontFamily, letterSpacing: options.letterSpacing, textDecoration: options.textDecoration, textAlign: options.textAlign, lineHeight: options.lineHeight, overflow: options.overflow, softWrap: options.softWrap, maxLines: options.maxLines, minLines: options.minLines, onTextLayout: onTextLayout, style: options.style)
        } else {
            androidx.compose.material3.Text(text: options.text ?? "", modifier: options.modifier, color: options.color, fontSize: options.fontSize, fontStyle: options.fontStyle, fontWeight: options.fontWeight, fontFamily: options.fontFamily, letterSpacing: options.letterSpacing, textDecoration: options.textDecoration, textAlign: options.textAlign, lineHeight: options.lineHeight, overflow: options.overflow, softWrap: options.softWrap, maxLines: options.maxLines, minLines: options.minLines, onTextLayout: options.onTextLayout, style: options.style)
        }
    }

    private func annotatedString(markdown: MarkdownNode, interpolations: kotlin.collections.List<AnyHashable>?, linkColor: androidx.compose.ui.graphics.Color, isUppercased: Bool, isLowercased: Bool, isRedacted: Bool) -> AnnotatedString {
        return buildAnnotatedString {
            append(markdown: markdown, to: self, interpolations: interpolations, linkColor: linkColor, isUppercased: isUppercased, isLowercased: isLowercased, isRedacted: isRedacted)
        }
    }

    // SKIP INSERT: @OptIn(ExperimentalTextApi::class)
    private func append(markdown: MarkdownNode, to builder: AnnotatedString.Builder, interpolations: kotlin.collections.List<AnyHashable>?, isFirstChild: Bool = true, linkColor: androidx.compose.ui.graphics.Color, isUppercased: Bool, isLowercased: Bool, isRedacted: Bool) {
        func appendChildren() {
            markdown.children?.forEachIndexed { append(markdown: $1, to: builder, interpolations: interpolations, isFirstChild: $0 == 0, linkColor: linkColor, isUppercased: isUppercased, isLowercased: isLowercased, isRedacted: isRedacted) }
        }

        switch markdown.type {
        case MarkdownNode.NodeType.bold:
            builder.pushStyle(SpanStyle(fontWeight: FontWeight.Bold))
            appendChildren()
            builder.pop()
        case MarkdownNode.NodeType.code:
            if let text = markdown.formattedString(interpolations) {
                builder.pushStyle(SpanStyle(fontFamily: FontFamily.Monospace))
                if isUppercased {
                    builder.append(text.uppercased())
                } else if isLowercased {
                    builder.append(text.lowercased())
                } else {
                    builder.append(text)
                }
                builder.pop()
            }
        case MarkdownNode.NodeType.italic:
            builder.pushStyle(SpanStyle(fontStyle: FontStyle.Italic))
            appendChildren()
            builder.pop()
        case MarkdownNode.NodeType.link:
            if isRedacted {
                builder.pushStyle(SpanStyle(background: linkColor))
            } else {
                builder.pushStyle(SpanStyle(color: linkColor))
            }
            builder.pushUrlAnnotation(UrlAnnotation(markdown.formattedString(interpolations) ?? ""))
            appendChildren()
            builder.pop()
            builder.pop()
        case MarkdownNode.NodeType.paragraph:
            if !isFirstChild {
                builder.append("\n\n")
            }
            appendChildren()
        case MarkdownNode.NodeType.root:
            appendChildren()
        case MarkdownNode.NodeType.strikethrough:
            builder.pushStyle(SpanStyle(textDecoration: TextDecoration.LineThrough))
            appendChildren()
            builder.pop()
        case MarkdownNode.NodeType.text:
            if let text = markdown.formattedString(interpolations) {
                if isUppercased {
                    builder.append(text.uppercased())
                } else if isLowercased {
                    builder.append(text.lowercased())
                } else {
                    builder.append(text)
                }
            }
        case MarkdownNode.NodeType.unknown:
            appendChildren()
        }
    }
    #else
    var body: some View {
        stubView()
    }
    #endif
}

public enum TextAlignment : Int, Hashable, CaseIterable {
    case leading = 0 // For bridging
    case center = 1 // For bridging
    case trailing = 2 // For bridging

    #if SKIP
    /// Convert this enum to a Compose `TextAlign` value.
    public func asTextAlign() -> TextAlign {
        return switch self {
        case .leading: TextAlign.Start
        case .center: TextAlign.Center
        case .trailing: TextAlign.End
        }
    }
    #endif
}

#if SKIP
struct TextEnvironment: Equatable {
    var fontWeight: Font.Weight?
    var fontDesign: Font.Design?
    var isItalic: Bool?
    var isUnderline: Bool?
    var isStrikethrough: Bool?
    var textCase: Text.Case?

    var textDecoration: TextDecoration? {
        if isUnderline == true, isStrikethrough == true {
            return TextDecoration.Underline + TextDecoration.LineThrough
        } else if isUnderline == true {
            return TextDecoration.Underline
        } else if isStrikethrough == true {
            return TextDecoration.LineThrough
        } else {
            return nil
        }
    }
}

func textEnvironment(for view: View, update: (inout TextEnvironment) -> Void) -> some View {
    return ComposeModifierView(contentView: view) { view, context in
        EnvironmentValues.shared.setValues {
            var textEnvironment = $0._textEnvironment
            update(&textEnvironment)
            $0.set_textEnvironment(textEnvironment)
        } in: {
            view.Compose(context: context)
        }
    }
}

struct TextStyleInfo {
    let style: TextStyle
    let color: androidx.compose.ui.graphics.Color?
    let isUppercased: Bool
    let isLowercased: Bool
}
#endif

extension View {
    @available(*, unavailable)
    public func allowsTightening(_ flag: Bool) -> some View {
        return self
    }

    @available(*, unavailable)
    public func baselineOffset(_ baselineOffset: CGFloat) -> some View {
        return self
    }

    public func bold(_ isActive: Bool = true) -> some View {
        return fontWeight(isActive ? Font.Weight.bold : nil)
    }

    @available(*, unavailable)
    public func dynamicTypeSize(_ size: DynamicTypeSize) -> some View {
        return self
    }

    @available(*, unavailable)
    public func dynamicTypeSize(_ range: Range<DynamicTypeSize>) -> some View {
        return self
    }

    // SKIP @bridge
    public func font(_ font: Font?) -> any View {
        #if SKIP
        return environment(\.font, font)
        #else
        return self
        #endif
    }

    public func fontDesign(_ design: Font.Design?) -> some View {
        #if SKIP
        return textEnvironment(for: self) { $0.fontDesign = design }
        #else
        return self
        #endif
    }

    // SKIP @bridge
    public func fontDesign(bridgedDesign: Int?) -> any View {
        let design = bridgedDesign == nil ? nil : Font.Design(rawValue: bridgedDesign!)
        return fontDesign(design)
    }

    public func fontWeight(_ weight: Font.Weight?) -> some View {
        #if SKIP
        return textEnvironment(for: self) { $0.fontWeight = weight }
        #else
        return self
        #endif
    }

    // SKIP @bridge
    public func fontWeight(bridgedWeight: Int?) -> any View {
        let weight = bridgedWeight == nil ? nil : Font.Weight(value: bridgedWeight!)
        return fontWeight(weight)
    }

    @available(*, unavailable)
    public func fontWidth(_ width: Font.Width?) -> some View {
        return self
    }

    @available(*, unavailable)
    public func invalidatableContent(_ invalidatable: Bool = true) -> some View {
        return self
    }

    // SKIP @bridge
    public func italic(_ isActive: Bool = true) -> any View {
        #if SKIP
        return textEnvironment(for: self) { $0.isItalic = isActive }
        #else
        return self
        #endif
    }

    @available(*, unavailable)
    public func kerning(_ kerning: CGFloat) -> some View {
        return self
    }

    // SKIP @bridge
    public func lineLimit(_ number: Int?) -> any View {
        #if SKIP
        return environment(\.lineLimit, number)
        #else
        return self
        #endif
    }

    @available(*, unavailable)
    public func lineLimit(_ limit: Range<Int>) -> some View {
        return self
    }

    // SKIP @bridge
    public func lineLimit(_ limit: Int, reservesSpace: Bool) -> any View {
        #if SKIP
        return environment(\.lineLimit, limit).environment(\._lineLimitReservesSpace, reservesSpace)
        #else
        return self
        #endif
    }

    @available(*, unavailable)
    public func lineHeight(_ lineHeight: Any? /* AttributedString.LineHeight? */) -> some View {
        return self
    }

    @available(*, unavailable)
    public func lineSpacing(_ lineSpacing: CGFloat) -> some View {
        return self
    }

    @available(*, unavailable)
    public func monospacedDigit() -> some View {
        return self
    }

    public func monospaced(_ isActive: Bool = true) -> some View {
        return fontDesign(isActive ? Font.Design.monospaced : nil)
    }

    @available(*, unavailable)
    public func minimumScaleFactor(_ factor: CGFloat) -> some View {
        return self
    }

    public func multilineTextAlignment(_ alignment: TextAlignment) -> some View {
        #if SKIP
        return environment(\.multilineTextAlignment, alignment)
        #else
        return self
        #endif
    }

    public func multilineTextAlignment(strategy: Text.AlignmentStrategy) -> some View {
        return self
    }

    // SKIP @bridge
    public func multilineTextAlignment(bridgedAlignment: Int) -> any View {
        return multilineTextAlignment(TextAlignment(rawValue: bridgedAlignment) ?? .center)
    }

    @available(*, unavailable)
    public func privacySensitive(_ sensitive: Bool = true) -> some View {
        return self
    }

    public func redacted(reason: RedactionReasons) -> some View {
        #if SKIP
        return environment(\.redactionReasons, reason)
        #else
        return self
        #endif
    }

    // SKIP @bridge
    public func redacted(bridgedReason: Int) -> any View {
        return redacted(reason: RedactionReasons(rawValue: bridgedReason))
    }

    @available(*, unavailable)
    public func speechAlwaysIncludesPunctuation(_ value: Bool = true) -> some View {
        return self
    }

    @available(*, unavailable)
    public func speechSpellsOutCharacters(_ value: Bool = true) -> some View {
        return self
    }

    @available(*, unavailable)
    public func speechAdjustedPitch(_ value: Double) -> some View {
        return self
    }

    @available(*, unavailable)
    public func speechAnnouncementsQueued(_ value: Bool = true) -> some View {
        return self
    }

    public func strikethrough(_ isActive: Bool = true, pattern: Text.LineStyle.Pattern = .solid, color: Color? = nil) -> some View {
        #if SKIP
        return textEnvironment(for: self) { $0.isStrikethrough = isActive }
        #else
        return self
        #endif
    }

    // SKIP @bridge
    public func bridgedStrikethrough(_ isActive: Bool) -> any View {
        return self.strikethrough(isActive)
    }

    public func textCase(_ textCase: Text.Case?) -> any View {
        #if SKIP
        return textEnvironment(for: self) { $0.textCase = textCase }
        #else
        return self
        #endif
    }

    // SKIP @bridge
    public func bridgedTextCase(_ textCase: Int?) -> any View {
        return self.textCase(textCase == nil ? nil : Text.Case(rawValue: textCase!))
    }

    @available(*, unavailable)
    public func textScale(_ scale: Text.Scale, isEnabled: Bool = true) -> some View {
        return self
    }

    @available(*, unavailable)
    public func textSelection(_ selectability: TextSelectability) -> some View {
        return self
    }

    @available(*, unavailable)
    public func tracking(_ tracking: CGFloat) -> some View {
        return self
    }

    @available(*, unavailable)
    public func truncationMode(_ mode: Text.TruncationMode) -> some View {
        return self
    }

    public func underline(_ isActive: Bool = true, pattern: Text.LineStyle.Pattern = .solid, color: Color? = nil) -> some View {
        #if SKIP
        return textEnvironment(for: self) { $0.isUnderline = isActive }
        #else
        return self
        #endif
    }

    // SKIP @bridge
    public func bridgedUnderline(_ isActive: Bool) -> any View {
        return underline(isActive)
    }

    @available(*, unavailable)
    public func unredacted() -> some View {
        return self
    }

    public func writingDirection(strategy: Text.WritingDirectionStrategy) -> some View {
        return self
    }

    #if SKIP
    /// Compose text field customization.
    public func material3Text(_ options: @Composable (Material3TextOptions) -> Material3TextOptions) -> View {
        return environment(\._material3Text, options)
    }
    #endif
}

#if SKIP
public struct Material3TextOptions {
    public var text: String? = nil
    public var annotatedText: AnnotatedString? = nil
    public var modifier: Modifier = Modifier
    public var color: androidx.compose.ui.graphics.Color = androidx.compose.ui.graphics.Color.Unspecified
    public var fontSize: TextUnit = TextUnit.Unspecified
    public var fontStyle: FontStyle? = nil
    public var fontWeight: FontWeight? = nil
    public var fontFamily: FontFamily? = nil
    public var letterSpacing: TextUnit = TextUnit.Unspecified
    public var textDecoration: TextDecoration? = nil
    public var textAlign: TextAlign? = nil
    public var lineHeight: TextUnit = TextUnit.Unspecified
    public var overflow: TextOverflow = TextOverflow.Clip
    public var softWrap = true
    public var maxLines = Int.max
    public var minLines = 1
    public var onTextLayout: ((TextLayoutResult) -> Void)? = nil
    public var style: TextStyle

    public func copy(
        text: String? = self.text,
        annotatedText: AnnotatedString? = self.annotatedText,
        modifier: Modifier = self.modifier,
        color: androidx.compose.ui.graphics.Color = self.color,
        fontSize: TextUnit = self.fontSize,
        fontStyle: FontStyle? = self.fontStyle,
        fontWeight: FontWeight? = self.fontWeight,
        fontFamily: FontFamily? = self.fontFamily,
        letterSpacing: TextUnit = self.letterSpacing,
        textDecoration: TextDecoration? = self.textDecoration,
        textAlign: TextAlign? = self.textAlign,
        lineHeight: TextUnit = self.lineHeight,
        overflow: TextOverflow = self.overflow,
        softWrap: Bool = self.softWrap,
        maxLines: Int = self.maxLines,
        minLines: Int = self.minLines,
        onTextLayout: ((TextLayoutResult) -> Void)? = self.onTextLayout,
        style: TextStyle = self.style
    ) -> Material3TextOptions {
        return Material3TextOptions(text: text, annotatedText: annotatedText, modifier: modifier, color: color, fontSize: fontSize, fontStyle: fontStyle, fontWeight: fontWeight, fontFamily: fontFamily, letterSpacing: letterSpacing, textDecoration: textDecoration, textAlign: textAlign, lineHeight: lineHeight, overflow: overflow, softWrap: softWrap, maxLines: maxLines, minLines: minLines, onTextLayout: onTextLayout, style: style)
    }
}
#endif

public struct RedactionReasons : OptionSet {
    public let rawValue: Int

    public init(rawValue: Int) {
        self.rawValue = rawValue
    }

    public static let placeholder = RedactionReasons(rawValue: 1 << 0)

    @available(*, unavailable)
    public static let privacy = RedactionReasons(rawValue: 1 << 1)

    @available(*, unavailable)
    public static let invalidated = RedactionReasons(rawValue: 1 << 2)
}

#if false
import struct Foundation.AttributedString
import struct Foundation.Date
import struct Foundation.DateInterval
import struct Foundation.Locale
import struct Foundation.LocalizedStringResource

import protocol Foundation.AttributeScope
import struct Foundation.AttributeScopeCodableConfiguration
import enum Foundation.AttributeScopes
import enum Foundation.AttributeDynamicLookup
import protocol Foundation.AttributedStringKey

import class Foundation.Bundle
import class Foundation.NSObject
import class Foundation.Formatter

import protocol Foundation.ParseableFormatStyle
import protocol Foundation.FormatStyle
import protocol Foundation.ReferenceConvertible

extension Text {

    /// Creates an instance that wraps an `Image`, suitable for concatenating
    /// with other `Text`
    @available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
    public init(_ image: Image) { fatalError() }
}

extension Text {

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
    /// - Returns: Text with the typesetting language set to the value you
    ///   supply.
    @available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
    public func typesettingLanguage(_ language: Locale.Language, isEnabled: Bool = true) -> Text { fatalError() }

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
    /// - Returns: Text with the typesetting language set to the value you
    ///   supply.
    @available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
    public func typesettingLanguage(_ language: TypesettingLanguage, isEnabled: Bool = true) -> Text { fatalError() }
}

@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
extension Text {

    /// Creates a text view that displays the formatted representation
    /// of a reference-convertible value.
    ///
    /// Use this initializer to create a text view that formats `subject`
    /// using `formatter`.
    /// - Parameters:
    ///   - subject: A
    ///   
    ///   instance compatible with `formatter`.
    ///   - formatter: A
    ///   
    ///   capable of converting `subject` into a string representation.
    public init<Subject>(_ subject: Subject, formatter: Formatter) where Subject : ReferenceConvertible { fatalError() }

    /// Creates a text view that displays the formatted representation
    /// of a Foundation object.
    ///
    /// Use this initializer to create a text view that formats `subject`
    /// using `formatter`.
    /// - Parameters:
    ///   - subject: An
    ///   
    ///   instance compatible with `formatter`.
    ///   - formatter: A
    ///   
    ///   capable of converting `subject` into a string representation.
    public init<Subject>(_ subject: Subject, formatter: Formatter) where Subject : NSObject { fatalError() }
}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
extension Text {

    /// Creates a text view that displays the formatted representation
    /// of a nonstring type supported by a corresponding format style.
    ///
    /// Use this initializer to create a text view backed by a nonstring
    /// value, using a
    /// to convert the type to a string representation. Any changes to the value
    /// update the string displayed by the text view.
    ///
    /// In the following example, three ``Text`` views present a date with
    /// different combinations of date and time fields, by using different
    /// options.
    ///
    ///     @State private var myDate = Date()
    ///     var body: some View {
    ///         VStack {
    ///             Text(myDate, format: Date.FormatStyle(date: .numeric, time: .omitted))
    ///             Text(myDate, format: Date.FormatStyle(date: .complete, time: .complete))
    ///             Text(myDate, format: Date.FormatStyle().hour(.defaultDigitsNoAMPM).minute())
    ///         }
    ///     }
    ///
    /// ![Three vertically stacked text views showing the date with different
    /// levels of detail: 4/1/1976; April 1, 1976; Thursday, April 1,
    /// 1976.](Text-init-format-1)
    ///
    /// - Parameters:
    ///   - input: The underlying value to display.
    ///   - format: A format style of type `F` to convert the underlying value
    ///     of type `F.FormatInput` to a string representation.
    public init<F>(_ input: F.FormatInput, format: F) where F : FormatStyle, F.FormatInput : Equatable, F.FormatOutput == String { fatalError() }
}

@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
extension Text {

    /// A predefined style used to display a `Date`.
    public struct DateStyle : Sendable {

        /// A style displaying only the time component for a date.
        ///
        ///     Text(event.startDate, style: .time)
        ///
        /// Example output:
        ///     11:23PM
        public static let time: Text.DateStyle = { fatalError() }()

        /// A style displaying a date.
        ///
        ///     Text(event.startDate, style: .date)
        ///
        /// Example output:
        ///     June 3, 2019
        public static let date: Text.DateStyle = { fatalError() }()

        /// A style displaying a date as relative to now.
        ///
        ///     Text(event.startDate, style: .relative)
        ///
        /// Example output:
        ///     2 hours, 23 minutes
        ///     1 year, 1 month
        public static let relative: Text.DateStyle = { fatalError() }()

        /// A style displaying a date as offset from now.
        ///
        ///     Text(event.startDate, style: .offset)
        ///
        /// Example output:
        ///     +2 hours
        ///     -3 months
        public static let offset: Text.DateStyle = { fatalError() }()

        /// A style displaying a date as timer counting from now.
        ///
        ///     Text(event.startDate, style: .timer)
        ///
        /// Example output:
        ///    2:32
        ///    36:59:01
        public static let timer: Text.DateStyle = { fatalError() }()
    }

    /// Creates an instance that displays localized dates and times using a specific style.
    ///
    /// - Parameters:
    ///     - date: The target date to display.
    ///     - style: The style used when displaying a date.
    public init(_ date: Date, style: Text.DateStyle) { fatalError() }

    /// Creates an instance that displays a localized range between two dates.
    ///
    /// - Parameters:
    ///     - dates: The range of dates to display
    public init(_ dates: ClosedRange<Date>) { fatalError() }

    /// Creates an instance that displays a localized time interval.
    ///
    ///     Text(DateInterval(start: event.startDate, duration: event.duration))
    ///
    /// Example output:
    ///     9:30AM - 3:30PM
    ///
    /// - Parameters:
    ///     - interval: The date interval to display
    public init(_ interval: DateInterval) { fatalError() }
}

@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
extension Text {

    /// Creates an instance that displays a timer counting within the provided
    /// interval.
    ///
    ///     Text(
    ///         timerInterval: Date.now...Date(timeInterval: 12 * 60, since: .now))
    ///         pauseTime: Date.now + (10 * 60))
    ///
    /// The example above shows a text that displays a timer counting down
    /// from "12:00" and will pause when reaching "10:00".
    ///
    /// - Parameters:
    ///     - timerInterval: The interval between where to run the timer.
    ///     - pauseTime: If present, the date at which to pause the timer.
    ///         The default is `nil` which indicates to never pause.
    ///     - countsDown: Whether to count up or down. The default is `true`.
    ///     - showsHours: Whether to include an hours component if there are
    ///         more than 60 minutes left on the timer. The default is `true`.
    public init(timerInterval: ClosedRange<Date>, pauseTime: Date? = nil, countsDown: Bool = true, showsHours: Bool = true) { fatalError() }
}

extension Text {

    /// Applies a text scale to the text.
    ///
    /// - Parameters:
    ///   - scale: The text scale to apply.
    ///   - isEnabled: If true the text scale is applied; otherwise text scale
    ///     is unchanged.
    /// - Returns: Text with the specified scale applied.
    @available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
    public func textScale(_ scale: Text.Scale, isEnabled: Bool = true) -> Text { fatalError() }
}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
extension Text {

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
    public func speechAlwaysIncludesPunctuation(_ value: Bool = true) -> Text { fatalError() }

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
    public func speechSpellsOutCharacters(_ value: Bool = true) -> Text { fatalError() }

    /// Raises or lowers the pitch of spoken text.
    ///
    /// Use this modifier when you want to change the pitch of spoken text.
    /// The value indicates how much higher or lower to change the pitch.
    ///
    /// - Parameter value: The amount to raise or lower the pitch.
    ///   Values between `-1` and `0` result in a lower pitch while
    ///   values between `0` and `1` result in a higher pitch.
    ///   The method clamps values to the range `-1` to `1`.
    public func speechAdjustedPitch(_ value: Double) -> Text { fatalError() }

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
    public func speechAnnouncementsQueued(_ value: Bool = true) -> Text { fatalError() }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension Text {

    /// Concatenates the text in two text views in a new text view.
    ///
    /// - Parameters:
    ///   - lhs: The first text view with text to combine.
    ///   - rhs: The second text view with text to combine.
    ///
    /// - Returns: A new text view containing the combined contents of the two
    ///   input text views.
    public static func + (lhs: Text, rhs: Text) -> Text { fatalError() }
}

extension Text {

    /// Creates a text view that displays a localized string resource.
    ///
    /// Use this initializer to display a localized string that is
    /// represented by a 
    ///
    ///     var object = LocalizedStringResource("pencil")
    ///     Text(object) // Localizes the resource if possible, or displays "pencil" if not.
    ///
    //@available(iOS 16.0, macOS 13, tvOS 16.0, watchOS 9.0, *)
    //public init(_ resource: LocalizedStringResource) { fatalError() }
}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
extension Text {

    /// Sets an accessibility text content type.
    ///
    /// Use this modifier to set the content type of this accessibility
    /// element. Assistive technologies can use this property to choose
    /// an appropriate way to output the text. For example, when
    /// encountering a source coding context, VoiceOver could
    /// choose to speak all punctuation.
    ///
    /// If you don't set a value with this method, the default content type
    /// is ``AccessibilityTextContentType/plain``.
    ///
    /// - Parameter value: The accessibility content type from the available
    /// ``AccessibilityTextContentType`` options.
    public func accessibilityTextContentType(_ value: AccessibilityTextContentType) -> Text { fatalError() }

    /// Sets the accessibility level of this heading.
    ///
    /// Use this modifier to set the level of this heading in relation to other headings. The system speaks
    /// the level number of levels ``AccessibilityHeadingLevel/h1`` through
    /// ``AccessibilityHeadingLevel/h6`` alongside the text.
    ///
    /// The default heading level if you don't use this modifier
    /// is ``AccessibilityHeadingLevel/unspecified``.
    ///
    /// - Parameter level: The heading level to associate with this element
    ///   from the available ``AccessibilityHeadingLevel`` levels.
    public func accessibilityHeading(_ level: AccessibilityHeadingLevel) -> Text { fatalError() }

    /// Use this method to provide an alternative accessibility label to the text that is displayed.
    /// For example, you can give an alternate label to a navigation title:
    ///
    ///     var body: some View {
    ///         NavigationView {
    ///             ContentView()
    ///                 .navigationTitle(Text("􀈤").accessibilityLabel("Inbox"))
    ///         }
    ///     }
    ///
    /// - Parameter labelKey: The string key for the alternative
    ///   accessibility label.
    public func accessibilityLabel(_ labelKey: LocalizedStringKey) -> Text { fatalError() }
}

//@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
//extension Text.Storage : @unchecked Sendable {
//}
//
//@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
//extension Text.Modifier : @unchecked Sendable {
//}

@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
extension Text.DateStyle : Equatable {

    
}

@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
extension Text.DateStyle : Codable {

    /// Encodes this value into the given encoder.
    ///
    /// If the value fails to encode anything, `encoder` will encode an empty
    /// keyed container in its place.
    ///
    /// This function throws an error if any values are invalid for the given
    /// encoder's format.
    ///
    /// - Parameter encoder: The encoder to write data to.
    public func encode(to encoder: Encoder) throws { fatalError() }

    /// Creates a new instance by decoding from the given decoder.
    ///
    /// This initializer throws an error if reading from the decoder fails, or
    /// if the data read is corrupted or otherwise invalid.
    ///
    /// - Parameter decoder: The decoder to read data from.
    public init(from decoder: Decoder) throws { fatalError() }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension Text.TruncationMode : Equatable {
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension Text.TruncationMode : Hashable {
}

@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
extension Text.Case : Equatable {
}

@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
extension Text.Case : Hashable {
}

/// A built-in group of commands for searching, editing, and transforming
/// selections of text.
///
/// These commands are optional and can be explicitly requested by passing a
/// value of this type to the `Scene.commands(_:)` modifier.
@available(iOS 14.0, macOS 11.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
public struct TextEditingCommands : Commands {

    /// A new value describing the built-in text-editing commands.
    public init() { fatalError() }

    /// The contents of the command hierarchy.
    ///
    /// For any commands that you create, provide a computed `body` property
    /// that defines the scene as a composition of other scenes. You can
    /// assemble a command hierarchy from built-in commands that SkipUI
    /// provides, as well as other commands that you've defined.
    public var body: Body { fatalError() }

    /// The type of commands that represents the body of this command hierarchy.
    ///
    /// When you create custom commands, Swift infers this type from your
    /// implementation of the required ``SkipUI/Commands/body-swift.property``
    /// property.
    public typealias Body = NeverView
}

extension AttributeScopes {

    /// A property for accessing the attribute scopes defined by SkipUI.
    @available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
    public var skipUI: AttributeScopes.SkipUIAttributes.Type { get { fatalError() } }

    /// Attribute scopes defined by SkipUI.
    @available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
    public struct SkipUIAttributes : AttributeScope {

//        /// A property for accessing a font attribute.
//        public let font: AttributeScopes.SwiftUI.FontAttribute = { fatalError() }()
//
//        /// A property for accessing a foreground color attribute.
//        public let foregroundColor: AttributeScopes.SkipUIAttributes.ForegroundColorAttribute = { fatalError() }()
//
//        /// A property for accessing a background color attribute.
//        public let backgroundColor: AttributeScopes.SkipUIAttributes.BackgroundColorAttribute = { fatalError() }()
//
//        /// A property for accessing a strikethrough style attribute.
//        public let strikethroughStyle: AttributeScopes.SkipUIAttributes.StrikethroughStyleAttribute = { fatalError() }()
//
//        /// A property for accessing an underline style attribute.
//        public let underlineStyle: AttributeScopes.SkipUIAttributes.UnderlineStyleAttribute = { fatalError() }()
//
//        /// A property for accessing a kerning attribute.
//        public let kern: AttributeScopes.SkipUIAttributes.KerningAttribute = { fatalError() }()
//
//        /// A property for accessing a tracking attribute.
//        public let tracking: AttributeScopes.SkipUIAttributes.TrackingAttribute = { fatalError() }()
//
//        /// A property for accessing a baseline offset attribute.
//        public let baselineOffset: AttributeScopes.SkipUIAttributes.BaselineOffsetAttribute = { fatalError() }()
//
//        /// A property for accessing attributes defined by the Accessibility framework.
//        public let accessibility: AttributeScopes.AccessibilityAttributes = { fatalError() }()

        /// A property for accessing attributes defined by the Foundation framework.
        public let foundation: AttributeScopes.FoundationAttributes = { fatalError() }()

        public typealias DecodingConfiguration = AttributeScopeCodableConfiguration

        public typealias EncodingConfiguration = AttributeScopeCodableConfiguration
    }
}

@available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
extension AttributeDynamicLookup {

    public subscript<T>(dynamicMember keyPath: KeyPath<AttributeScopes.SkipUIAttributes, T>) -> T where T : AttributedStringKey { get { fatalError() } }
}

#endif
#endif
