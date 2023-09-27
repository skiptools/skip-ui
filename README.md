# SkipUI

SwiftUI support for [Skip](https://skip.tools) apps.

## About 

SkipUI vends the `skip.ui` Kotlin package. It is a reimplementation of SwiftUI for Kotlin on Android using Jetpack Compose. Its goal is to mirror as much of SwiftUI as possible, allowing Skip developers to use SwiftUI with confidence.

## Dependencies

SkipUI depends on the [skip](https://source.skip.tools/skip) transpiler plugin. The transpiler must transpile SkipUI's own source code, and SkipUI relies on the Transpiler's transformation of SwiftUI code. See [Implementation Strategy](#implementation-strategy) for details.

SkipUI is part of the core Skip stack and is not intended to be imported directly.
The module is transparently adopted through the translation of `import SwiftUI` into `import skip.ui.*` by the Skip transpiler.

## Status

SkipUI - together with the Skip transpiler - has robust support for the building blocks of SwiftUI, including its state flow and declarative syntax. SkipUI also implements many of SwiftUI's basic layout and control views, as well as many core modifiers. It is possible to write an Android app entirely in SwiftUI utilizing SkipUI's current component set.

SkipUI is a young library, however, and much of SwiftUI's vast surface area is not yet implemented. You are likely to run into limitations while writing real-world apps. See [Supported SwiftUI](#supported-swiftui) for a full list of supported components and constructs. Anything not listed there is likely not yet ported.

When you want to use a SwiftUI construct that has not been implemented, you have options. You can try to find a workaround using only supported components, [embed Compose code directly](#composeview), or [add support to SkipUI](#implementation-strategy). If you choose to enhance SkipUI itself, please consider [contributing](#contributing) your code back for inclusion in the official release.

## Contributing

We welcome contributions to SkipUI. The Skip product documentation includes helpful instructions on [local Skip library development](https://skip.tools/docs/#local-libraries). 

The most pressing need is to implement more core components and view modifiers.
To help fill in unimplemented API in SkipUI:

1. Find unimplemented API. Unimplemented API will either be within `#if !SKIP` blocks, or will be marked with `@available(unavailable, *)`.
1. Write an appropriate Compose implementation. See [Implementation Strategy](#implementation-strategy) below.
1. Write tests and/or playground code to exercise your component. See [Tests](#tests).
1. [Submit a PR.](https://github.com/skiptools/skip-ui/pulls)

Other forms of contributions such as test cases, comments, and documentation are also welcome!

## Implementation Strategy

SkipUI contains stubs for the entire SwiftUI framework. API generally goes through three phases:

1. Code that no one has begun to port to Skip starts in `#if !SKIP` blocks. This hides it from the Skip transpiler.
1. The first implementation step is to move code out of `#if !SKIP` blocks so that it will be transpiled. This is helpful on its own, even if you just mark the API `@available(unavailable, *)` because you are not ready to implement it for Compose. An `unavailable` attribute will provide Skip users with a clear error message, rather than relying on the Kotlin compiler to complain about unfound API.
    - When moving code out of a `#if !SKIP` block, please strip Apple's extensive API comments. There is no reason for Skip to duplicate the official SwiftUI documentation, and it obscures any Skip-specific implementation comments we may add.
    - SwiftUI uses complex generics extensively, and the generics systems of Swift and Kotlin have significant differences. You may have to replace some generics or generic constraints with looser typing in order to transpile successfully.
    - Reducing the number of Swift extensions and instead folding API into the primary declaration of a type can make Skip's internal symbol storage more efficient.
1. Finally, we add a Compose implementation and remove any `unavailable` attribute.

Note that SkipUI should remain buildable in Xcode throughout this process. Being able to successfully compile SkipUI in Swift helps us validate that our ported components still mesh with the rest of the framework.

Documentation in progress

## Topics

### ComposeView

`ComposeView` is an Android-only SwiftUI view that you can use to embed Compose code directly into your SwiftUI view tree. In the following example, we use a SwiftUI `Text` to write "Hello from SwiftUI", followed by calling the `androidx.compose.material3.Text()` Compose function to write "Hello from Compose" below it:

```swift
VStack {
    Text("Hello from SwiftUI")
    ComposeView { _ in
        androidx.compose.material3.Text("Hello from Compose")
    }
}
```

Skip also enhances all SwiftUI views with a `Compose()` method, allowing you to use SwiftUI views from within Compose. The following example again uses a SwiftUI `Text` to write "Hello from SwiftUI", but this time from within a `ComposeView`:

```swift
ComposeView { _ in 
    androidx.compose.foundation.layout.Column {
        Text("Hello from SwiftUI").Compose()
        androidx.compose.material3.Text("Hello from Compose")
    }
}
```

Or:

```swift
ComposeView { _ in 
    VStack {
        Text("Hello from SwiftUI").Compose()
        androidx.compose.material3.Text("Hello from Compose")
    }.Compose()
}
```

With `ComposeView` and the `Compose()` function, you can move fluidly between SwiftUI and Compose code. These techniques work not only with standard SwiftUI and Compose components, but with your own custom SwiftUI views and Compose functions as well.

Note that `ComposeView` and the `Compose()` function are only available in Android, so you must guard all uses with the `#if SKIP` or `#if os(Android)` compiler directives. 

### Images

Documentation in progress

### Lists

Documentation in progress

### Navigation

Documentation in progress

## Tests

SkipUI utilizes a combination of unit tests, UI tests, and basic snapshot tests in which the snapshots are converted into ASCII art for easy processing. 

Perhaps the most common way to test SkipUI's support for a SwiftUI component, however, is through the [Skip playground app](https://github.com/skiptools/skipapp-playground). Whenever you add or update support for a visible element of SwiftUI, make sure there is a playground that exercises the element. This not only gives us a mechanism to test appearance and behavior, but the playground app becomes a showcase of supported SwiftUI components on Android over time.

## Supported SwiftUI

|Component|Support Level|Notes|
|---------|-------------|-----|
|`@AppStorage`|Medium||
|`@Bindable`|Full||
|`@Binding`|Full||
|`@Environment`|Full|Custom keys supported, but most builtin keys not yet available|
|`@EnvironmentObject`|Full||
|`@ObservedObject`|Full||
|`@State`|Full||
|`@StateObject`|Full||
|Custom Views|Full||
|`Button`|High||
|`Color`|High||
|`Divider`|Full||
|`EmptyView`|Full||
|`Font`|Medium||
|`Group`|Full||
|`HStack`|Full||
|`Image`|Low|See [Images](#images)|
|`Label`|Low|See [Images](#images)|
|`List`|Medium|See [Lists](#lists)|
|`NavigationLink`|Medium|See [Navigation](#navigation)|
|`NavigationStack`|Medium|See [Navigation](#navigation)|
|`ScrollView`|Full||
|`Slider`|Medium|Labels, `onEditingChanged` not supported|
|`Spacer`|Medium|`minLength` not supported|
|`TabView`|Medium|See [Navigation](#navigation)|
|`Text`|High|Formatting not supported|
|`TextField`|High|Formatting not supported|
|`Toggle`|Medium|Styling, `sources` not supported|
|`VStack`|Full||
|`ZStack`|Full||
|`.background`|Low|Only color supported|
|`.bold`|Full||
|`.border`|Full||
|`.buttonStyle`|High|Custom styles not supported|
|`.environment`|Full||
|`.environmentObject`|Full||
|`.font`|Full||
|`.foregroundColor`|Full||
|`.foregroundStyle`|Medium|Only color supported|
|`.frame`|Low|Only fixed dimensions supported|
|`.italic`|Full||
|`.labelsHidden`|Full||
|`.listStyle`|Full||
|`.navigationDestination`|Medium|See [Navigation](#navigation)|
|`.navigationTitle`|Full||
|`.opacity`|Full||
|`.padding`|Full||
|`.rotationEffect`|Medium||
|`.scaleEffect`|Medium||
|`.tabItem`|Full||
|`.task`|Full||

## Helpful Compose components

[androidx.compose.material package](https://developer.android.com/reference/kotlin/androidx/compose/material3/package-summary)
[androidx.compose.ui.Modifier list](https://developer.android.com/jetpack/compose/modifiers-list)

- Text (androidx.compose.material3.Text): Displays a text element on the screen.
- Button (androidx.compose.material3.Button): Creates a clickable button.
- Surface (androidx.compose.material3.Surface): Defines a surface with a background color and elevation.
- Image (androidx.compose.foundation.Image): Displays an image.
- Box (androidx.compose.foundation.Box): A composable that places its children in a box layout.
- Row (androidx.compose.foundation.layout.Row): Lays out its children in a horizontal row.
- Column (androidx.compose.foundation.layout.Column): Lays out its children in a vertical column.
- Spacer (androidx.compose.ui.layout.Spacer): Adds empty space between composables.
- Card (androidx.compose.material3.Card): Creates a Material Design card.
- TextField (androidx.compose.material3.TextField): Creates an editable text field.
- TopAppBar (androidx.compose.material3.TopAppBar): Creates a Material Design top app bar.
- BottomAppBar (androidx.compose.material3.BottomAppBar): Creates a Material Design bottom app bar.
- FloatingActionButton (androidx.compose.material3.FloatingActionButton): Creates a floating action button.
- AlertDialog (androidx.compose.material3.AlertDialog): Creates a Material Design alert dialog.
- ModalBottomSheetLayout (androidx.compose.material3.ModalBottomSheetLayout): Creates a modal bottom sheet.
- IconButton (androidx.compose.material3.IconButton): Creates an icon button.
- OutlinedTextField (androidx.compose.material3.OutlinedTextField): Creates an outlined text field.
- LazyColumn (androidx.compose.foundation.lazy.LazyColumn): Creates a lazily laid out column.
- LazyRow (androidx.compose.foundation.lazy.LazyRow): Creates a lazily laid out row.
- LazyVerticalGrid (androidx.compose.foundation.lazy.LazyVerticalGrid): Creates a lazily laid out vertical grid.
- LazyRow (androidx.compose.foundation.lazy.LazyRow): Creates a lazily laid out row with horizontally scrolling items.
- LazyColumnFor (androidx.compose.foundation.lazy.LazyColumnFor): Creates a lazily laid out column for a list of items.
- LazyRowFor (androidx.compose.foundation.lazy.LazyRowFor): Creates a lazily laid out row for a list of items.
- LazyVerticalGridFor (androidx.compose.foundation.lazy.LazyVerticalGridFor): Creates a lazily laid out vertical grid for a list of items.
- Clickable (androidx.compose.ui.Modifier.clickable): Adds a click listener to a composable.
- Icon (androidx.compose.material3.Icon): Displays an icon from the Material Icons font.
- IconButton (androidx.compose.material3.IconButton): Creates an icon button with optional click listener.
- Checkbox (androidx.compose.material3.Checkbox): Creates a checkbox.
- RadioButton (androidx.compose.material3.RadioButton): Creates a radio button.
- Switch (androidx.compose.material3.Switch): Creates a switch (on/off toggle).
- Slider (androidx.compose.material3.Slider): Creates a slider for selecting a value within a range.
- LinearProgressIndicator (androidx.compose.material3.LinearProgressIndicator): Creates a linear progress indicator.
- CircularProgressIndicator (androidx.compose.material3.CircularProgressIndicator): Creates a circular progress indicator.
- Divider (androidx.compose.material3.Divider): Creates a horizontal divider.
- Spacer (androidx.compose.foundation.layout.Spacer): Adds empty space between composables.
- AlertDialog (androidx.compose.material3.AlertDialog): Creates an alert dialog with customizable buttons and content.
- Snackbar (androidx.compose.material3.SnackbarHost): Creates a snackbar to display short messages.
- DropdownMenu (androidx.compose.material3.DropdownMenu): Creates a dropdown menu with a list of items.
- Drawer (androidx.compose.material3.Drawer): Creates a sliding drawer panel for navigation.
- MaterialTheme (androidx.compose.material3.MaterialTheme): Applies Material Design styles to its children.
