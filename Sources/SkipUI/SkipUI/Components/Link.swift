// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

#if !SKIP_BRIDGE
import Foundation
#if SKIP
import androidx.compose.runtime.Composable
#endif

// Use a class to be able to update our openURL action on compose by reference.
public final class Link : View {
    let content: Button
    var openURL = OpenURLAction.default

    public init(destination: URL, @ViewBuilder label: () -> any View) {
        #if SKIP
        content = Button(action: { self.openURL(destination) }, label: label)
        #else
        content = Button("", action: {})
        #endif
    }

    public convenience init(_ titleKey: LocalizedStringKey, destination: URL) {
        self.init(destination: destination, label: { Text(titleKey) })
    }

    public convenience init(_ title: String, destination: URL) {
        self.init(destination: destination, label: { Text(verbatim: title) })
    }

    #if SKIP
    @Composable override func ComposeContent(context: ComposeContext) {
        openURL = EnvironmentValues.shared.openURL
        content.Compose(context: context)
    }
    #else
    public var body: some View {
        stubView()
    }
    #endif
}

#endif
