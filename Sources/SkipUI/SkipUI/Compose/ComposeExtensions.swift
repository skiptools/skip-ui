// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

#if SKIP
import androidx.compose.foundation.layout.fillMaxHeight
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.runtime.Composable
import androidx.compose.runtime.saveable.Saver
import androidx.compose.ui.Modifier

extension Modifier {
    /// Fill available remaining width.
    ///
    /// This is a replacement for `fillMaxWidth` designed for situations when the composable may be in an `HStack` and does not want to push other items out.
    @Composable public func fillWidth() -> Modifier {
        guard let fill = EnvironmentValues.shared._fillWidth else {
            return fillMaxWidth()
        }
        return then(fill)
    }

    /// Fill available remaining height.
    ///
    /// This is a replacement for `fillMaxHeight` designed for situations when the composable may be in an `VStack` and does not want to push other items out.
    @Composable public func fillHeight() -> Modifier {
        guard let fill = EnvironmentValues.shared._fillHeight else {
            return fillMaxHeight()
        }
        return then(fill)
    }

    /// Fill available remaining height.
    ///
    /// This is a replacement for `fillMaxHeight` designed for situations when the composable may be in an `VStack` and does not want to push other items out.
    @Composable public func fillSize() -> Modifier {
        return fillWidth().fillHeight()
    }
}
#endif
