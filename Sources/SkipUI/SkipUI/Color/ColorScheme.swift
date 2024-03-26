// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

#if SKIP
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.darkColorScheme
import androidx.compose.material3.dynamicDarkColorScheme
import androidx.compose.material3.dynamicLightColorScheme
import androidx.compose.material3.lightColorScheme
import androidx.compose.runtime.Composable
import androidx.compose.ui.graphics.luminance
import androidx.compose.ui.platform.LocalContext
#endif

public enum ColorScheme : CaseIterable, Hashable, Sendable {
    case light
    case dark

    #if SKIP
    /// Return the color scheme for the current material color scheme.
    @Composable public static func fromMaterialTheme() -> ColorScheme {
        // Material3 doesn't have a built-in light vs dark property, so use the luminance of the background
        return MaterialTheme.colorScheme.background.luminance() > Float(0.5) ? ColorScheme.light : ColorScheme.dark
    }

    /// Return the material color scheme for this scheme.
    @Composable public func asMaterialTheme() -> androidx.compose.material3.ColorScheme {
        let context = LocalContext.current
        let isDarkMode = self == ColorScheme.dark
        // Dynamic color is available on Android 12+
        let isDynamicColor = android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.S
        if isDynamicColor {
            return self == ColorScheme.dark ? dynamicDarkColorScheme(context) : dynamicLightColorScheme(context)
        } else {
            return self == ColorScheme.dark ? darkColorScheme() : lightColorScheme()
        }
    }
    #endif
}

extension View {
    public func colorScheme(_ colorScheme: ColorScheme) -> some View {
        #if SKIP
        return ComposeModifierView(contentView: self) { view, context in
            MaterialTheme(colorScheme: colorScheme.asMaterialTheme()) {
                view.Compose(context: context)
            }
        }
        #else
        return self
        #endif
    }

    public func preferredColorScheme(_ colorScheme: ColorScheme?) -> some View {
        #if SKIP
        return preference(key: PreferredColorSchemePreferenceKey.self, value: ColorSchemeHolder(colorScheme: colorScheme))
        #else
        return self
        #endif
    }
}

#if SKIP
struct PreferredColorSchemePreferenceKey: PreferenceKey {
    typealias Value = ColorSchemeHolder

    // SKIP DECLARE: companion object: PreferenceKeyCompanion<ColorSchemeHolder>
    final class Companion: PreferenceKeyCompanion {
        let defaultValue = ColorSchemeHolder(colorScheme: nil)
        func reduce(value: inout ColorSchemeHolder, nextValue: () -> ColorSchemeHolder) {
            value = nextValue()
        }
    }
}

struct ColorSchemeHolder: Equatable {
    let colorScheme: ColorScheme?
}
#endif
