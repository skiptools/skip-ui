// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

#if SKIP
import androidx.compose.foundation.layout.fillMaxHeight
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier

extension Modifier {
    /// Fill available remaining width.
    ///
    /// This is a replacement for `fillMaxWidth` designed for situations when the composable may be in an `HStack` and does not want to push other items out.
    ///
    /// - Warning: Containers with child content should use the `ComposeContainer` composable instead.
    @Composable public func fillWidth(expandContainer: Bool = true) -> Modifier {
        guard let fill = EnvironmentValues.shared._fillWidth else {
            return fillMaxWidth()
        }
        return then(fill(expandContainer))
    }

    /// Fill available remaining height.
    ///
    /// This is a replacement for `fillMaxHeight` designed for situations when the composable may be in an `VStack` and does not want to push other items out.
    ///
    /// - Warning: Containers with child content should use the `ComposeContainer` composable instead.
    @Composable public func fillHeight(expandContainer: Bool = true) -> Modifier {
        guard let fill = EnvironmentValues.shared._fillHeight else {
            return fillMaxHeight()
        }
        return then(fill(expandContainer))
    }

    /// Fill available remaining size.
    ///
    /// This is a replacement for `fillMaxSize` designed for situations when the composable may be in an `HStack` or `VStack` and does not want to push other items out.
    ///
    /// - Warning: Containers with child content should use the `ComposeContainer` composable instead.
    @Composable public func fillSize(expandContainer: Bool = true) -> Modifier {
        return fillWidth(expandContainer: expandContainer).fillHeight(expandContainer: expandContainer)
    }
}
#endif
