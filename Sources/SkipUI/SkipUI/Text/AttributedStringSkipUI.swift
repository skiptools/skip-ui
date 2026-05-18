// Copyright 2023–2026 Skip
// SPDX-License-Identifier: MPL-2.0
#if SKIP
import Foundation

/// SkipUI font attribute for attributed strings.
public enum SkipUIFontAttribute : AttributedStringKey {
    public typealias Value = Font
    public static let name = "Font"
}

/// SkipUI foreground color attribute for attributed strings.
public enum SkipUIForegroundColorAttribute : AttributedStringKey {
    public typealias Value = Color
    public static let name = "ForegroundColor"
}

/// SkipUI background color attribute for attributed strings.
public enum SkipUIBackgroundColorAttribute : AttributedStringKey {
    public typealias Value = Color
    public static let name = "BackgroundColor"
}

/// SkipUI underline style attribute for attributed strings.
public enum SkipUIUnderlineStyleAttribute : AttributedStringKey {
    public typealias Value = Text.LineStyle?
    public static let name = "UnderlineStyle"
}

/// SkipUI strikethrough style attribute for attributed strings.
public enum SkipUIStrikethroughStyleAttribute : AttributedStringKey {
    public typealias Value = Text.LineStyle?
    public static let name = "StrikethroughStyle"
}

extension AttributeContainer {
    public var font: Font? {
        get { value(key: SkipUIFontAttribute.name) as? Font }
        set { setValue(newValue, key: SkipUIFontAttribute.name) }
    }

    public var foregroundColor: Color? {
        get { value(key: SkipUIForegroundColorAttribute.name) as? Color }
        set { setValue(newValue, key: SkipUIForegroundColorAttribute.name) }
    }

    public var backgroundColor: Color? {
        get { value(key: SkipUIBackgroundColorAttribute.name) as? Color }
        set { setValue(newValue, key: SkipUIBackgroundColorAttribute.name) }
    }

    public var underlineStyle: Text.LineStyle? {
        get { value(key: SkipUIUnderlineStyleAttribute.name) as? Text.LineStyle }
        set { setValue(newValue, key: SkipUIUnderlineStyleAttribute.name) }
    }

    public var strikethroughStyle: Text.LineStyle? {
        get { value(key: SkipUIStrikethroughStyleAttribute.name) as? Text.LineStyle }
        set { setValue(newValue, key: SkipUIStrikethroughStyleAttribute.name) }
    }
}

extension AttributedString {
    public var font: Font? {
        get { attributeValue(key: SkipUIFontAttribute.name) as? Font }
        mutating set { setAttributeValue(newValue, key: SkipUIFontAttribute.name) }
    }

    public var foregroundColor: Color? {
        get { attributeValue(key: SkipUIForegroundColorAttribute.name) as? Color }
        mutating set { setAttributeValue(newValue, key: SkipUIForegroundColorAttribute.name) }
    }

    public var backgroundColor: Color? {
        get { attributeValue(key: SkipUIBackgroundColorAttribute.name) as? Color }
        mutating set { setAttributeValue(newValue, key: SkipUIBackgroundColorAttribute.name) }
    }

    public var underlineStyle: Text.LineStyle? {
        get { attributeValue(key: SkipUIUnderlineStyleAttribute.name) as? Text.LineStyle }
        mutating set { setAttributeValue(newValue, key: SkipUIUnderlineStyleAttribute.name) }
    }

    public var strikethroughStyle: Text.LineStyle? {
        get { attributeValue(key: SkipUIStrikethroughStyleAttribute.name) as? Text.LineStyle }
        mutating set { setAttributeValue(newValue, key: SkipUIStrikethroughStyleAttribute.name) }
    }
}

#endif
