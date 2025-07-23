// Copyright 2023–2025 Skip
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception
#if !SKIP_BRIDGE
import Foundation
#if SKIP
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.padding
import androidx.compose.material.ContentAlpha
import androidx.compose.material3.MaterialTheme
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.scale
import androidx.compose.ui.unit.dp
#endif

// SKIP @bridge
public struct Label : View, Renderable {
    let title: ComposeBuilder
    let image: ComposeBuilder

    public init(@ViewBuilder title: () -> any View, @ViewBuilder icon: () -> any View) {
        self.title = ComposeBuilder.from(title)
        self.image = ComposeBuilder.from(icon)
    }

    // SKIP @bridge
    public init(bridgedTitle: any View, bridgedImage: any View) {
        self.title = ComposeBuilder.from { bridgedTitle }
        self.image = ComposeBuilder.from { bridgedImage  }
    }

    public init(_ titleKey: LocalizedStringKey, image: String) {
        self.init(title: { Text(titleKey) }, icon: { Image(image, bundle: .main) })
    }

    public init(_ titleResource: LocalizedStringResource, image: String) {
        self.init(title: { Text(titleResource) }, icon: { Image(image, bundle: .main) })
    }

    public init(_ titleKey: LocalizedStringKey, systemImage: String) {
        self.init(title: { Text(titleKey) }, icon: { Image(systemName: systemImage) })
    }

    public init(_ titleResource: LocalizedStringResource, systemImage: String) {
        self.init(title: { Text(titleResource) }, icon: { Image(systemName: systemImage) })
    }

    public init(_ title: String, image: String) {
        self.init(title: { Text(verbatim: title) }, icon: { Image(image, bundle: .main) })
    }

    public init(_ title: String, systemImage: String) {
        self.init(title: { Text(verbatim: title) }, icon: { Image(systemName: systemImage) })
    }

    #if SKIP
    @Composable override func Render(context: ComposeContext) {
        var style = EnvironmentValues.shared._labelStyle ?? LabelStyle.automatic
        let placement = EnvironmentValues.shared._placement
        if style == .automatic {
            if placement.contains(ViewPlacement.toolbar) {
                style = .iconOnly
            } else {
                style = .titleAndIcon
            }
        }
        var imageColor: Color?
        var titlePadding = 0.0
        if placement.contains(ViewPlacement.systemTextColor) && !EnvironmentValues.shared.isEnabled && EnvironmentValues.shared._foregroundStyle == nil {
            imageColor = Color.primary.opacity(Double(ContentAlpha.disabled))
        } else if placement.contains(ViewPlacement.onPrimaryColor) && EnvironmentValues.shared._foregroundStyle == nil {
            var imageColor = Color(colorImpl: { MaterialTheme.colorScheme.onPrimary })
            if !EnvironmentValues.shared.isEnabled {
                imageColor = imageColor.opacity(Double(ContentAlpha.disabled))
            }
        } else if placement.contains(ViewPlacement.listItem) {
            imageColor = EnvironmentValues.shared._foregroundStyle as? Color ?? EnvironmentValues.shared._listItemTint ?? Color.accentColor
            titlePadding = 6.0
        }
        switch style {
        case .titleOnly:
            RenderTitle(context: context)
        case .iconOnly:
            RenderImage(context: context, imageColor: imageColor)
        default:
            RenderLabel(context: context, imageColor: imageColor, titlePadding: titlePadding)
        }
    }

    @Composable private func RenderLabel(context: ComposeContext, imageColor: Color?, titlePadding: Double) {
        Row(modifier: context.modifier, horizontalArrangement: Arrangement.spacedBy(8.dp), verticalAlignment: androidx.compose.ui.Alignment.CenterVertically) {
            RenderImage(context: context.content(), imageColor: imageColor)
            Box(modifier: Modifier.padding(start: titlePadding.dp)) {
                RenderTitle(context: context.content())
            }
        }
    }

    /// Render only the title of this label.
    @Composable func RenderTitle(context: ComposeContext) {
        title.Compose(context: context)
    }

    /// Render only the image of this label.
    @Composable func RenderImage(context: ComposeContext, imageColor: Color? = nil) {
        if let imageColor {
            EnvironmentValues.shared.setValues {
                $0.set_foregroundStyle(imageColor)
                return ComposeResult.ok
            } in: {
                image.Compose(context: context)
            }
        } else {
            image.Compose(context: context)
        }
    }
    #else
    public var body: some View {
        stubView()
    }
    #endif
}

public struct LabelStyle: RawRepresentable, Equatable {
    public let rawValue: Int

    public init(rawValue: Int) {
        self.rawValue = rawValue
    }

    public static let automatic = LabelStyle(rawValue: 0) // For bridging
    public static let titleOnly = LabelStyle(rawValue: 1) // For bridging
    public static let iconOnly = LabelStyle(rawValue: 2) // For bridging
    public static let titleAndIcon = LabelStyle(rawValue: 3) // For bridging
}

public struct LabeledContent {
    @available(*, unavailable)
    public init(@ViewBuilder content: () -> any View, @ViewBuilder label: () -> any View) {
    }

    @available(*, unavailable)
    public init(_ titleKey: LocalizedStringKey, @ViewBuilder content: () -> any View) {
    }

    @available(*, unavailable)
    public init(_ titleResource: LocalizedStringResource, @ViewBuilder content: () -> any View) {
    }

    @available(*, unavailable)
    public init(_ title: String, @ViewBuilder content: () -> any View) {
    }

    @available(*, unavailable)
    public init(_ titleKey: LocalizedStringKey, value: String) {
    }

    @available(*, unavailable)
    public init(_ titleResource: LocalizedStringResource, value: String) {
    }

    @available(*, unavailable)
    public init(_ title: String, value: String) {
    }
}

public struct LabeledContentStyle: RawRepresentable, Equatable {
    public let rawValue: Int

    public init(rawValue: Int) {
        self.rawValue = rawValue
    }

    public static let automatic = LabeledContentStyle(rawValue: 0)
}

extension View {
    public func labelStyle(_ style: LabelStyle) -> some View {
        #if SKIP
        return environment(\._labelStyle, style, affectsEvaluate: false)
        #else
        return self
        #endif
    }

    // SKIP @bridge
    public func labelStyle(bridgedStyle: Int) -> any View {
        return labelStyle(LabelStyle(rawValue: bridgedStyle))
    }

    public func labeledContentStyle(_ style: LabeledContentStyle) -> some View {
        return self
    }

    @available(*, unavailable)
    public func labelReservedIconWidth(_ value: CGFloat) -> some View {
        return self
    }

    @available(*, unavailable)
    public func labelIconToTitleSpacing(_ value: CGFloat) -> some View {
        return self
    }
}

/*
import protocol Foundation.ParseableFormatStyle
import protocol Foundation.FormatStyle
import protocol Foundation.ReferenceConvertible

@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
extension Label /* where Title == LabelStyleConfiguration.Title, Icon == LabelStyleConfiguration.Icon */ {

    /// Creates a label representing the configuration of a style.
    ///
    /// You can use this initializer within the ``LabelStyle/makeBody(configuration:)``
    /// method of a ``LabelStyle`` instance to create an instance of the label
    /// that's being styled. This is useful for custom label styles that only
    /// wish to modify the current style, as opposed to implementing a brand new
    /// style.
    ///
    /// For example, the following style adds a red border around the label,
    /// but otherwise preserves the current style:
    ///
    ///     struct RedBorderedLabelStyle: LabelStyle {
    ///         func makeBody(configuration: Configuration) -> some View {
    ///             Label(configuration)
    ///                 .border(Color.red)
    ///         }
    ///     }
    ///
    /// - Parameter configuration: The label style to use.
    public init(_ configuration: LabelStyleConfiguration) { fatalError() }
}

/// The properties of a label.
@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
public struct LabelStyleConfiguration {

    /// A type-erased title view of a label.
    public struct Title {

        /// The type of view representing the body of this view.
        ///
        /// When you create a custom view, Swift infers this type from your
        /// implementation of the required ``View/body-swift.property`` property.
        public typealias Body = NeverView
    }

    /// A type-erased icon view of a label.
    public struct Icon {

        /// The type of view representing the body of this view.
        ///
        /// When you create a custom view, Swift infers this type from your
        /// implementation of the required ``View/body-swift.property`` property.
        public typealias Body = NeverView
    }

    /// A description of the labeled item.
    public var title: LabelStyleConfiguration.Title { get { fatalError() } }

    /// A symbolic representation of the labeled item.
    public var icon: LabelStyleConfiguration.Icon { get { fatalError() } }
}

@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
extension LabelStyleConfiguration.Title : View {
    public var body: Body { fatalError() }
}

@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
extension LabelStyleConfiguration.Icon : View {
    public var body: Body { fatalError() }
}

//@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
//extension LabeledContent where Label == Text, Content == Text {
    /// Creates a labeled informational view from a formatted value.
    ///
    /// This initializer creates a ``Text`` label on your behalf, and treats the
    /// localized key similar to ``Text/init(_:tableName:bundle:comment:)``. See
    /// `Text` for more information about localizing strings.
    ///
    ///     Form {
    ///         LabeledContent("Age", value: person.age, format: .number)
    ///         LabeledContent("Height", value: person.height,
    ///             format: .measurement(width: .abbreviated))
    ///     }
    ///
    /// - Parameters:
    ///   - titleKey: The key for the view's localized title, that describes
    ///     the purpose of the view.
    ///   - value: The value being labeled.
    ///   - format: A format style of type `F` to convert the underlying value
    ///     of type `F.FormatInput` to a string representation.
//    public init<F>(_ titleKey: LocalizedStringKey, value: F.FormatInput, format: F) where F : FormatStyle, F.FormatInput : Equatable, F.FormatOutput == String { fatalError() }

    /// Creates a labeled informational view from a formatted value.
    ///
    /// This initializer creates a ``Text`` label on your behalf, and treats the
    /// title similar to ``Text/init(_:)-9d1g4``. See `Text` for more
    /// information about localizing strings.
    ///
    ///     Form {
    ///         Section("Downloads") {
    ///             ForEach(download) { file in
    ///                 LabeledContent(file.name, value: file.downloadSize,
    ///                     format: .byteCount(style: .file))
    ///            }
    ///         }
    ///     }
    ///
    /// - Parameters:
    ///   - title: A string that describes the purpose of the view.
    ///   - value: The value being labeled.
    ///   - format: A format style of type `F` to convert the underlying value
    ///     of type `F.FormatInput` to a string representation.
//    public init<S, F>(_ title: S, value: F.FormatInput, format: F) where S : StringProtocol, F : FormatStyle, F.FormatInput : Equatable, F.FormatOutput == String { fatalError() }
//}

//@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
//extension LabeledContent where Label == LabeledContentStyleConfiguration.Label, Content == LabeledContentStyleConfiguration.Content {

    /// Creates labeled content based on a labeled content style configuration.
    ///
    /// You can use this initializer within the
    /// ``LabeledContentStyle/makeBody(configuration:)`` method of a
    /// ``LabeledContentStyle`` to create a labeled content instance.
    /// This is useful for custom styles that only modify the current style,
    /// as opposed to implementing a brand new style.
    ///
    /// For example, the following style adds a red border around the labeled
    /// content, but otherwise preserves the current style:
    ///
    ///     struct RedBorderLabeledContentStyle: LabeledContentStyle {
    ///         func makeBody(configuration: Configuration) -> some View {
    ///             LabeledContent(configuration)
    ///                 .border(.red)
    ///         }
    ///     }
    ///
    /// - Parameter configuration: The properties of the labeled content
//    public init(_ configuration: LabeledContentStyleConfiguration) { fatalError() }
//}

/// The properties of a labeled content instance.
@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
public struct LabeledContentStyleConfiguration {

    /// A type-erased label of a labeled content instance.
    public struct Label : View {

        /// The type of view representing the body of this view.
        ///
        /// When you create a custom view, Swift infers this type from your
        /// implementation of the required ``View/body-swift.property`` property.
        public typealias Body = NeverView
        public var body: Body { fatalError() }
    }

    /// A type-erased content of a labeled content instance.
    public struct Content : View {

        /// The type of view representing the body of this view.
        ///
        /// When you create a custom view, Swift infers this type from your
        /// implementation of the required ``View/body-swift.property`` property.
        public typealias Body = NeverView
        public var body: Body { fatalError() }
    }

    /// The label of the labeled content instance.
    public let label: LabeledContentStyleConfiguration.Label = { fatalError() }()

    /// The content of the labeled content instance.
    public let content: LabeledContentStyleConfiguration.Content = { fatalError() }()
}

/// A view that represents the body of a control group with a specified
/// label.
///
/// You don't create this type directly. SkipUI creates it when you build
/// a ``ControlGroup``.
@available(iOS 16.0, macOS 13.0, tvOS 17.0, *)
@available(watchOS, unavailable)
public struct LabeledControlGroupContent<Content, Label> : View where Content : View, Label : View {

    @MainActor public var body: some View { get { return stubView() } }

//    public typealias Body = some View
}

/// A view that represents the view of a toolbar item group with a specified
/// label.
///
/// You don't create this type directly. SkipUI creates it when you build
/// a ``ToolbarItemGroup``.
@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
public struct LabeledToolbarItemGroupContent<Content, Label> : View where Content : View, Label : View {

    @MainActor public var body: some View { get { return stubView() } }

//    public typealias Body = some View
}
*/
#endif
