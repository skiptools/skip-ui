// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

#if SKIP
// SKIP INSERT: import android.os.Parcel
// SKIP INSERT: import android.os.Parcelable
// SKIP INSERT: import androidx.compose.runtime.saveable.Saver
// SKIP INSERT: import androidx.compose.runtime.saveable.SaverScope

/// Used in conjunction with `rememberSaveable` to save and restore state with SwiftUI-like behavior.
struct ComposeStateSaver: Saver<Any, Any> {
    // TODO: Discard state when popped / dismissed
    private let state: MutableMap<Key, Any> = mutableMapOf()

    override func restore(value: Any) -> Any? {
        if let key = value as? Key {
            return state[key]
        } else {
            return value
        }
    }

    // SKIP DECLARE: override fun SaverScope.save(value: Any): Any?
    override func save(value: Any) -> Any? {
        if value is Boolean || value is Number || value is String || value is Char {
            return value
        } else {
            let key = Key.next()
            state[key] = value
            return key
        }
    }

    /// Key under which to save values that cannot be stored directly in the Bundle.
    private struct Key: Parcelable {
        private static var keyValue = 0

        static func next() -> Key {
            keyValue += 1
            return Key(value: keyValue)
        }

        private let value: Int

        private init(value: Int) {
            self.value = value
        }

        init(parcel: Parcel) {
            self.init(parcel.readInt())
        }

        override func writeToParcel(parcel: Parcel, flags: Int) {
            parcel.writeInt(value)
        }

        override func describeContents() -> Int {
            return 0
        }

        static let CREATOR: Parcelable.Creator<Key> = Creator()

        private class Creator: Parcelable.Creator<Key> {
            override func createFromParcel(parcel: Parcel) -> Key {
                return Key(parcel)
            }
            override func newArray(size: Int) -> kotlin.Array<Key?> {
                return arrayOfNulls(size)
            }
        }
    }
}
#endif
