// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

#if !SKIP_BRIDGE
#if SKIP
import androidx.compose.runtime.Composable
#endif

public struct Form : View {
    #if SKIP
    // It appears that on iOS, List and Form render the same
    let list: List

    public init(@ViewBuilder content: () -> any View) {
        list = List(content: content)
    }

    @Composable public override func ComposeContent(context: ComposeContext) {
        let _ = list.Compose(context: context)
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

#if false
//@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
//extension Form where Content == FormStyleConfiguration.Content {
//
//    /// Creates a form based on a form style configuration.
//    ///
//    /// - Parameter configuration: The properties of the form.
//    public init(_ configuration: FormStyleConfiguration) { fatalError() }
//}

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

#endif
#endif
