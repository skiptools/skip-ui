// Copyright 2023–2025 Skip
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception
#if SKIP
import android.os.Parcel
import android.os.Parcelable
import androidx.compose.runtime.saveable.Saver
import androidx.compose.runtime.saveable.SaverScope

/// Use to make a Bundle-saveable string from a SwiftUI value.
///
/// We typically use a `ComposeStateSaver` to save state, but when working with Compose internal state like `LazyList` state, use this function
/// to turn user-supplied values into strings that Compose can save natively.
///
/// - Seealso: `SkipFuseUI.Java_composeBundleString(for:)`
func composeBundleString(for value: Any?) -> String {
    if let identifiable = value as? Identifiable {
        return String(describing: identifiable.id)
    } else if let rawRepresentable = value as? RawRepresentable {
        return String(describing: rawRepresentable.rawValue)
    } else {
        return String(describing: value)
    }
}

/// Used in conjunction with `rememberSaveable` to save and restore state with SwiftUI-like behavior.
struct ComposeStateSaver: Saver<Any?, Any> {
    private static let nilMarker = "__SkipUI.ComposeStateSaver.nilMarker"
    private let state: MutableMap<Key, Any> = mutableMapOf()

    override func restore(value: Any) -> Any? {
        if value == Self.nilMarker {
            return nil
        } else if let key = value as? Key {
            return state[key]
        } else {
            return value
        }
    }

    // SKIP DECLARE: override fun SaverScope.save(value: Any?): Any
    override func save(value: Any?) -> Any {
        if value == nil {
            return Self.nilMarker
        } else if value is Boolean || value is Number || value is String || value is Char {
            return value
        } else {
            let key = Key.next()
            state[key] = value
            return key
        }
    }

    /// Key under which to save values that cannot be stored directly in the Bundle.
    struct Key: Parcelable {
        private let value: Int

        init(value: Int) {
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

        // We must use a companion CREATOR to meet the Java Parcelable contract. Note that if this code breaks, it may have no
        // immediate noticable effect. However, we've had dev reports that it can cause crashes on a high percentage of user
        // devices, even though we don't know how to exercise it. We can manually test for contract compatibility with:
        /*
        val key = ComposeStateSaver.Key(99999)
        val bundle = android.os.Bundle()
        bundle.putParcelable(key::class.java.name, key)
        val parcel = Parcel.obtain()
        parcel.writeBundle(bundle)
        val bytes = parcel.marshall()
        val rparcel = Parcel.obtain()
        rparcel.unmarshall(bytes, 0, bytes.size)
        rparcel.setDataPosition(0)
        val rbundle = rparcel.readBundle()
        rbundle?.classLoader = key::class.java.classLoader
        val rkey: ComposeStateSaver.Key? = rbundle?.getParcelable(key::class.java.name)
        android.util.Log.e("", "Roundtripped: $rkey")
         */

        // SKIP DECLARE: companion object CREATOR: Parcelable.Creator<Key>
        private final class CREATOR: Parcelable.Creator<Key> {
            private var keyValue = 0

            func next() -> Key {
                keyValue += 1
                return Key(value: keyValue)
            }
            
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
