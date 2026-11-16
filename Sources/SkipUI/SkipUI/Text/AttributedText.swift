// Copyright 2026 Skip
#if !SKIP_BRIDGE
import Foundation

/// One attributed text segment shared by native and transpiled clients. Text, rather than offsets,
/// keeps Swift string indices independent of Kotlin's UTF-16 indices.
// SKIP @bridgeMembers
public struct AttributedTextRun: Equatable {
    /// The literal text of this segment.
    public let text: String
    /// Whether strong emphasis applies.
    public let bold: Bool
    /// Whether emphasis applies.
    public let italic: Bool
    /// Whether to use a monospaced font for inline code.
    public let code: Bool
    /// Whether to draw a single strikethrough.
    public let strikethrough: Bool
    /// Whether to draw a single underline.
    public let underline: Bool
    /// The optional link destination, independent of text styling.
    public let link: String?
    /// The optional font overriding the surrounding text font.
    public let font: Font?
    /// The optional foreground color overriding inherited color or link tint.
    public let color: Color?
    /// The distance in points to raise this segment. Negative values lower it.
    public let baselineOffset: Double

    /// Create a segment with explicit inline attributes.
    public init(text: String, bold: Bool = false, italic: Bool = false, code: Bool = false, strikethrough: Bool = false, underline: Bool = false, link: String? = nil, font: Font? = nil, color: Color? = nil, baselineOffset: Double = 0.0) {
        self.text = text
        self.bold = bold
        self.italic = italic
        self.code = code
        self.strikethrough = strikethrough
        self.underline = underline
        self.link = link
        self.font = font
        self.color = color
        self.baselineOffset = baselineOffset
    }

    #if SKIP
    /// Snapshot the current attributes after any range edits. Segment text keeps
    /// the renderer independent of the attributed value's index representation.
    static func runs(from content: AttributedString) -> [AttributedTextRun] {
        content.runs.map { run in
            let intent: InlinePresentationIntent = run.inlinePresentationIntent ?? []
            return AttributedTextRun(
                text: String(content[run.range].characters),
                bold: intent.contains(.stronglyEmphasized),
                italic: intent.contains(.emphasized),
                code: intent.contains(.code),
                strikethrough: intent.contains(.strikethrough) || run.strikethroughStyle != nil,
                underline: run.underlineStyle != nil,
                link: run.link?.absoluteString,
                font: run.font,
                color: run.foregroundColor,
                baselineOffset: run.baselineOffset ?? 0.0
            )
        }
    }
    #endif

    /// Parse inline Markdown with the CommonMark engine already used by SkipFoundation,
    /// preserving whitespace before native Swift assembles the attributed value.
    public static func markdownRuns(_ markdown: String) -> [AttributedTextRun] {
        #if SKIP
        return runs(from: try! AttributedString(markdown: markdown))
        #else
        return [AttributedTextRun(text: markdown)]
        #endif
    }
}
#endif
