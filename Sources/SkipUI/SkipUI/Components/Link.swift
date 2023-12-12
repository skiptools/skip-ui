// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

import Foundation
#if SKIP
import androidx.compose.runtime.Composable
#endif

// Erase the generic Label to facilitate specialized constructor support.
public struct Link : View {
    let content: any View
    var openURL: ((URL) -> Void)!

    public init(destination: URL, @ViewBuilder label: () -> any View) {
        // Swift closure cannot capture mutating self
        #if SKIP
        content = Button(action: { openURL(destination) }, label: label)
        #else
        content = stubView()
        #endif
    }

    public init(_ titleKey: LocalizedStringKey, destination: URL) {
        self.init(destination: destination, label: { Text(titleKey) })
    }

    public init(_ title: String, destination: URL) {
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
