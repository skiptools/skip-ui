// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

import Foundation
#if SKIP
import androidx.appcompat.app.AppCompatActivity
import android.content.Intent
import androidx.compose.runtime.DisposableEffect
import androidx.compose.runtime.MutableState
import androidx.compose.runtime.SideEffect
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.ui.platform.LocalContext
import androidx.core.util.Consumer
#endif

extension View {
    @available(*, unavailable)
    public func userActivity(_ activityType: String, isActive: Bool = true, _ update: @escaping (Any /* NSUserActivity */) -> ()) -> some View {
        return self
    }

    @available(*, unavailable)
    public func userActivity<P>(_ activityType: String, element: P?, _ update: @escaping (P, Any /* NSUserActivity */) -> ()) -> some View {
        return self
    }

    @available(*, unavailable)
    public func onContinueUserActivity(_ activityType: String, perform action: @escaping (Any /* NSUserActivity */) -> ()) -> some View {
        return self
    }

    public func onOpenURL(perform action: @escaping (URL) -> Void) -> some View {
        #if SKIP
        return ComposeModifierView(targetView: self) { context in
            guard let activity = LocalContext.current as? AppCompatActivity else {
                return ComposeResult.ok
            }
            let newIntent = remember { mutableStateOf<Intent?>(nil) }
            let listener = remember {
                let listener = OnNewIntentListener(newIntent)
                activity.addOnNewIntentListener(listener)
                return listener
            }
            DisposableEffect(true) {
                onDispose {
                    activity.removeOnNewIntentListener(listener)
                }
            }

            guard let intent = newIntent.value ?? activity.intent else {
                return ComposeResult.ok
            }
            newIntent.value = nil
            guard intent.action == Intent.ACTION_VIEW, let dataString = intent.dataString, let url = URL(string: dataString) else {
                return ComposeResult.ok
            }
            SideEffect {
                action(url)
                // Clear the intent so that we don't process it on recompose. We also considered remembering the last
                // processed intent in each `onOpenURL`, but then navigation to a new `onOpenURL` modifier would process
                // any existing intent as new because it wouldn't be remembered for that modifier
                activity.intent = nil
            }
            return ComposeResult.ok
        }
        #else
        return self
        #endif
    }
}

#if SKIP
struct OnNewIntentListener : Consumer<Intent> {
    let newIntent: MutableState<Intent?>

    override func accept(value: Intent) {
        newIntent.value = value
    }
}
#endif

#if false

// TODO: Process for use in SkipUI

#if canImport(Foundation)
import class Foundation.NSUserActivity

@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
extension NSUserActivity {

//    /// Error types when getting/setting typed payload
//    @available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
//    public enum TypedPayloadError : Error {
//
//        /// UserInfo is empty or invalid
//        case invalidContent
//
//        /// Content failed to encode into a valid Dictionary
//        case encodingError
//    //    }

    /// Given a Codable Swift type, return an instance decoded from the
    /// NSUserActivity's userInfo dictionary
    ///
    /// - Parameter type: the instance type to be decoded from userInfo
    /// - Returns: the type safe instance or raises if it can't be decoded
    public func typedPayload<T>(_ type: T.Type) throws -> T where T : Decodable, T : Encodable { fatalError() }

    /// Given an instance of a Codable Swift type, encode it into the
    /// NSUserActivity's userInfo dictionary
    ///
    /// - Parameter payload: the instance to be converted to userInfo
    public func setTypedPayload<T>(_ payload: T) throws where T : Decodable, T : Encodable { fatalError() }
}

#endif

#endif
