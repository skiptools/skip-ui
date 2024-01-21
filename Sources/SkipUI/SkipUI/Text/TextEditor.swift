// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

public struct TextEditor : View {
    @available(*, unavailable)
    public init(text: Binding<String>) {
    }

    #if !SKIP
    public var body: some View {
        stubView()
    }
    #endif
}

public struct TextEditorStyle: RawRepresentable, Equatable {
    public let rawValue: Int

    public init(rawValue: Int) {
        self.rawValue = rawValue
    }

    public static let automatic = TextEditorStyle(rawValue: 0)
    public static let plain = TextEditorStyle(rawValue: 1)
}

extension View {
    public func textEditorStyle(_ style: TextEditorStyle) -> some View {
        return self
    }

    @available(*, unavailable)
    public func findNavigator(isPresented: Binding<Bool>) -> some View {
        return self
    }

    @available(*, unavailable)
    public func findDisabled(_ isDisabled: Bool = true) -> some View {
        return self
    }

    @available(*, unavailable)
    public func replaceDisabled(_ isDisabled: Bool = true) -> some View {
        return self
    }
}

#if !SKIP

// TODO: Process for use in SkipUI

/// The properties of a text editor.
@available(iOS 17.0, macOS 14.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
public struct TextEditorStyleConfiguration {
}

#endif
