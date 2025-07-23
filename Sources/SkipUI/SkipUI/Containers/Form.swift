// Copyright 2023–2025 Skip
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception
#if !SKIP_BRIDGE
#if SKIP
import androidx.compose.runtime.Composable
#endif

// SKIP @bridge
public struct Form : View {
    // It appears that on iOS, List and Form render the same
    let list: List

    public init(@ViewBuilder content: () -> any View) {
        self.list = List(content: content)
    }

    // SKIP @bridge
    public init(bridgedContent: any View) {
        self.list = List(bridgedContent: bridgedContent)
    }

    #if SKIP
    @Composable override func Evaluate(context: ComposeContext, options: Int) -> kotlin.collections.List<Renderable> {
        return list.Evaluate(context: context, options: options)
    }
    #else
    public var body: some View {
        stubView()
    }
    #endif
}

public struct FormStyle: RawRepresentable, Equatable {
    public let rawValue: Int

    public init(rawValue: Int) {
        self.rawValue = rawValue
    }

    public static let automatic = FormStyle(rawValue: 0)

    @available(*, unavailable)
    public static let columns = FormStyle(rawValue: 1)

    @available(*, unavailable)
    public static let grouped = FormStyle(rawValue: 2)
}

extension View {
    public func formStyle(_ style: FormStyle) -> some View {
        return self
    }
}

/*
@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
extension Form where Content == FormStyleConfiguration.Content {

    /// Creates a form based on a form style configuration.
    ///
    /// - Parameter configuration: The properties of the form.
    public init(_ configuration: FormStyleConfiguration) { fatalError() }
}

/// The properties of a form instance.
@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
public struct FormStyleConfiguration {

    /// A type-erased content of a form.
    public struct Content : View {

        /// The type of view representing the body of this view.
        ///
        /// When you create a custom view, Swift infers this type from your
        /// implementation of the required ``View/body-swift.property`` property.
        public typealias Body = NeverView
        public var body: Body { fatalError() }
    }

    /// A view that is the content of the form.
    public let content: FormStyleConfiguration.Content = { fatalError() }()
}
*/
#endif
