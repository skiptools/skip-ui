// Copyright 2023–2025 Skip
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception
#if !SKIP_BRIDGE
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

public enum ColorScheme : Int, CaseIterable, Hashable {
    case light = 0 // For bridging
    case dark = 1 // For bridging

    #if SKIP
    /// Return the color scheme for the current material color scheme.
    @Composable public static func fromMaterialTheme(colorScheme: androidx.compose.material3.ColorScheme = MaterialTheme.colorScheme) -> ColorScheme {
        // Material3 doesn't have a built-in light vs dark property, so use the luminance of the background
        return colorScheme.background.luminance() > Float(0.5) ? ColorScheme.light : ColorScheme.dark
    }

    /// Return the material color scheme for this scheme.
    @Composable public func asMaterialTheme() -> androidx.compose.material3.ColorScheme {
        let context = LocalContext.current
        let isDarkMode = self == ColorScheme.dark
        // Dynamic color is available on Android 12+
        let isDynamicColor = android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.S
        var colorScheme: androidx.compose.material3.ColorScheme
        if isDarkMode {
            colorScheme = isDynamicColor ? dynamicDarkColorScheme(context) : darkColorScheme()
        } else {
            colorScheme = isDynamicColor ? dynamicLightColorScheme(context) : lightColorScheme()
        }
        if let primary = Color.assetAccentColor(colorScheme: isDarkMode ? ColorScheme.dark : ColorScheme.light) {
            colorScheme = colorScheme.copy(primary: primary)
        }
        guard let customization = EnvironmentValues.shared._material3ColorScheme else {
            return colorScheme
        }
        return customization(colorScheme, isDarkMode)
    }
    #endif
}

extension View {
    public func colorScheme(_ colorScheme: ColorScheme) -> any View {
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

    // SKIP @bridge
    public func colorScheme(bridgedColorScheme: Int) -> any View {
        return colorScheme(ColorScheme(rawValue: bridgedColorScheme)!)
    }

    public func preferredColorScheme(_ colorScheme: ColorScheme?) -> any View {
        #if SKIP
        return preference(key: PreferredColorSchemePreferenceKey.self, value: PreferredColorScheme(colorScheme: colorScheme))
        #else
        return self
        #endif
    }

    // SKIP @bridge
    public func preferredColorScheme(bridgedColorScheme: Int?) -> any View {
        return preferredColorScheme(bridgedColorScheme == nil ? nil : ColorScheme(rawValue: bridgedColorScheme!))
    }

    #if SKIP
    public func materialColorScheme(_ scheme:  (@Composable (androidx.compose.material3.ColorScheme, Bool) -> androidx.compose.material3.ColorScheme)?) -> some View {
        return material3ColorScheme(scheme)
    }

    public func material3ColorScheme(_ scheme:  (@Composable (androidx.compose.material3.ColorScheme, Bool) -> androidx.compose.material3.ColorScheme)?) -> some View {
        return environment(\._material3ColorScheme, scheme)
    }
    #endif
}

#if SKIP
@Composable public func MaterialColorScheme(_ scheme: (@Composable (androidx.compose.material3.ColorScheme, Bool) -> androidx.compose.material3.ColorScheme)?, content: @Composable () -> Void) {
    return Material3ColorScheme(scheme, content: content)
}

@Composable public func Material3ColorScheme(_ scheme: (@Composable (androidx.compose.material3.ColorScheme, Bool) -> androidx.compose.material3.ColorScheme)?, content: @Composable () -> Void) {
    EnvironmentValues.shared.setValues {
        $0.set_material3ColorScheme(scheme)
    } in: {
        content()
    }
}

struct PreferredColorSchemePreferenceKey: PreferenceKey {
    typealias Value = PreferredColorScheme

    // SKIP DECLARE: companion object: PreferenceKeyCompanion<PreferredColorScheme>
    final class Companion: PreferenceKeyCompanion {
        let defaultValue = PreferredColorScheme(colorScheme: nil)
        func reduce(value: inout PreferredColorScheme, nextValue: () -> PreferredColorScheme) {
            value = nextValue()
        }
    }
}

struct PreferredColorScheme: Equatable {
    let colorScheme: ColorScheme?
}
#endif
#endif
