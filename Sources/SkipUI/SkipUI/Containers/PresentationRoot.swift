// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

#if SKIP
import androidx.compose.material3.MaterialTheme
import androidx.compose.runtime.Composable
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue

/// The root of a presentation, such as the root presntation or a sheet.
@Composable public func PresentationRoot(defaultColorScheme: ColorScheme? = nil, content: @Composable () -> Void) {
    // We should be able to get by without using a Saver because this is the root of the presentation and won't
    // be removed from composition until the sheet, etc is dismissed
    let preferredColorScheme = remember { mutableStateOf<ColorScheme?>(nil) }
    let preferredColorSchemePreference = Preference<ColorSchemeHolder>(key: PreferredColorSchemePreferenceKey.self, update: { preferredColorScheme.value = $0.colorScheme })
    PreferenceValues.shared.collectPreferences([preferredColorSchemePreference]) {
        if let colorScheme = preferredColorScheme.value ?? defaultColorScheme {
            MaterialTheme(colorScheme: colorScheme.asMaterialTheme()) {
                content()
            }
        } else {
            content()
        }
    }
}
#endif
