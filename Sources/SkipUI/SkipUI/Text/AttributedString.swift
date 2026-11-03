// Copyright 2026 Skip
// SPDX-License-Identifier: MPL-2.0
#if SKIP
import Foundation

// Concrete properties preserve SwiftUI's call syntax without relying on dynamic
// attribute scopes or key paths, which Skip Lite cannot transpile. The values
// live in Foundation's attribute storage; Foundation has no UI dependency.

extension AttributedString {
    /// The font applied to the text.
    public var font: Font? {
        get { attribute(named: "SwiftUI.Font") as? Font }
        set { setAttribute(named: "SwiftUI.Font", value: newValue) }
    }
    /// The foreground color applied to the text.
    public var foregroundColor: Color? {
        get { attribute(named: "SwiftUI.ForegroundColor") as? Color }
        set { setAttribute(named: "SwiftUI.ForegroundColor", value: newValue) }
    }
    /// The underline style. Rendering currently supports a single solid line.
    public var underlineStyle: Text.LineStyle? {
        get { attribute(named: "SwiftUI.UnderlineStyle") as? Text.LineStyle }
        set { setAttribute(named: "SwiftUI.UnderlineStyle", value: newValue) }
    }
    /// The strikethrough style. Rendering currently supports a single solid line.
    public var strikethroughStyle: Text.LineStyle? {
        get { attribute(named: "SwiftUI.StrikethroughStyle") as? Text.LineStyle }
        set { setAttribute(named: "SwiftUI.StrikethroughStyle", value: newValue) }
    }
    /// The baseline offset in points. Negative values lower the text.
    public var baselineOffset: CGFloat? {
        get { attribute(named: "SwiftUI.BaselineOffset") as? CGFloat }
        set { setAttribute(named: "SwiftUI.BaselineOffset", value: newValue) }
    }
}

extension AttributedSubstring {
    /// The font applied to the text.
    public var font: Font? {
        get { attribute(named: "SwiftUI.Font") as? Font }
        set { setAttribute(named: "SwiftUI.Font", value: newValue) }
    }
    /// The foreground color applied to the text.
    public var foregroundColor: Color? {
        get { attribute(named: "SwiftUI.ForegroundColor") as? Color }
        set { setAttribute(named: "SwiftUI.ForegroundColor", value: newValue) }
    }
    /// The underline style. Rendering currently supports a single solid line.
    public var underlineStyle: Text.LineStyle? {
        get { attribute(named: "SwiftUI.UnderlineStyle") as? Text.LineStyle }
        set { setAttribute(named: "SwiftUI.UnderlineStyle", value: newValue) }
    }
    /// The strikethrough style. Rendering currently supports a single solid line.
    public var strikethroughStyle: Text.LineStyle? {
        get { attribute(named: "SwiftUI.StrikethroughStyle") as? Text.LineStyle }
        set { setAttribute(named: "SwiftUI.StrikethroughStyle", value: newValue) }
    }
    /// The baseline offset in points. Negative values lower the text.
    public var baselineOffset: CGFloat? {
        get { attribute(named: "SwiftUI.BaselineOffset") as? CGFloat }
        set { setAttribute(named: "SwiftUI.BaselineOffset", value: newValue) }
    }
}

extension AttributeContainer {
    /// The font applied to the text.
    public var font: Font? {
        get { attribute(named: "SwiftUI.Font") as? Font }
        set { setAttribute(named: "SwiftUI.Font", value: newValue) }
    }
    /// The foreground color applied to the text.
    public var foregroundColor: Color? {
        get { attribute(named: "SwiftUI.ForegroundColor") as? Color }
        set { setAttribute(named: "SwiftUI.ForegroundColor", value: newValue) }
    }
    /// The underline style. Rendering currently supports a single solid line.
    public var underlineStyle: Text.LineStyle? {
        get { attribute(named: "SwiftUI.UnderlineStyle") as? Text.LineStyle }
        set { setAttribute(named: "SwiftUI.UnderlineStyle", value: newValue) }
    }
    /// The strikethrough style. Rendering currently supports a single solid line.
    public var strikethroughStyle: Text.LineStyle? {
        get { attribute(named: "SwiftUI.StrikethroughStyle") as? Text.LineStyle }
        set { setAttribute(named: "SwiftUI.StrikethroughStyle", value: newValue) }
    }
    /// The baseline offset in points. Negative values lower the text.
    public var baselineOffset: CGFloat? {
        get { attribute(named: "SwiftUI.BaselineOffset") as? CGFloat }
        set { setAttribute(named: "SwiftUI.BaselineOffset", value: newValue) }
    }
}

extension AttributedString.Run {
    /// The font applied to the text.
    public var font: Font? { attributes.font }
    /// The foreground color applied to the text.
    public var foregroundColor: Color? { attributes.foregroundColor }
    /// The underline style. Rendering currently supports a single solid line.
    public var underlineStyle: Text.LineStyle? { attributes.underlineStyle }
    /// The strikethrough style. Rendering currently supports a single solid line.
    public var strikethroughStyle: Text.LineStyle? { attributes.strikethroughStyle }
    /// The baseline offset in points. Negative values lower the text.
    public var baselineOffset: CGFloat? { attributes.baselineOffset }
}
#endif
