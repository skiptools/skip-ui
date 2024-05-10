// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

import Combine
#if SKIP
import androidx.compose.runtime.DisposableEffect
import androidx.compose.runtime.remember
import androidx.compose.runtime.rememberUpdatedState
#endif

extension View {
    // SKIP DECLARE: fun <P, Output> onReceive(publisher: P, perform: (Output) -> Unit): View where P: Publisher<Output, *>
    public func onReceive<P>(_ publisher: P, perform action: @escaping (P.Output) -> Void) -> some View where P : Publisher {
        #if SKIP
        return ComposeModifierView(targetView: self) { _ in
            let latestAction = rememberUpdatedState(action)
            let subscription = remember {
                publisher.sink { output in
                    latestAction.value(output)
                }
            }
            DisposableEffect(subscription) {
                onDispose {
                    subscription.cancel()
                }
            }
            return ComposeResult.ok
        }
        #else
        return self
        #endif
    }
}

public struct SubscriptionView<PublisherType, Content> : View where /* PublisherType : Publisher, */ Content : View /*, PublisherType.Failure == Never */ {
    public let content: Content
    public let publisher: PublisherType
    public let action: (Any /* PublisherType.Output */) -> Void

    @available(*, unavailable)
    public init(content: Content, publisher: PublisherType, action: @escaping (Any /* PublisherType.Output */) -> Void) {
        self.content = content
        self.publisher = publisher
        self.action = action
    }

    #if !SKIP
    public var body: some View {
        stubView()
    }
    #endif
}
