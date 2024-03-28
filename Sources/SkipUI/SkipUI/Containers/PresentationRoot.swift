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
import androidx.compose.runtime.saveable.Saver
import androidx.compose.runtime.saveable.rememberSaveable

/// The root of a presentation, such as the root presntation or a sheet.
@Composable public func PresentationRoot(defaultColorScheme: ColorScheme? = nil, context: ComposeContext, content: @Composable (ComposeContext) -> Void) {
    let preferenceUpdates = remember { mutableStateOf(0) }
    let _ = preferenceUpdates.value // Read so that it can trigger recompose on change
    let recompose = { preferenceUpdates.value += 1 }

    let preferredColorScheme = rememberSaveable(stateSaver: context.stateSaver as! Saver<PreferredColorScheme, Any>) { mutableStateOf(PreferredColorSchemePreferenceKey.defaultValue) }
    let preferredColorSchemePreference = Preference<PreferredColorScheme>(key: PreferredColorSchemePreferenceKey.self, update: { preferredColorScheme.value = $0 }, recompose: recompose)
    PreferenceValues.shared.collectPreferences([preferredColorSchemePreference]) {
        let materialColorScheme = preferredColorScheme.value.colorScheme?.asMaterialTheme() ?? defaultColorScheme?.asMaterialTheme() ?? MaterialTheme.colorScheme
        MaterialTheme(colorScheme: materialColorScheme) {
            content(context)
        }
    }
}
#endif
