# SkipUI

SwiftUI support for [Skip](https://skip.tools) apps.

## Setup

To include this framework in your project, add the following
dependency to your `Package.swift` file:

```swift
let package = Package(
    name: "my-package",
    products: [
        .library(name: "MyProduct", targets: ["MyTarget"]),
    ],
    dependencies: [
        .package(url: "https://source.skip.tools/skip-ui.git", from: "1.0.0"),
    ],
    targets: [
        .target(name: "MyTarget", dependencies: [
            .product(name: "SkipUI", package: "skip-ui")
        ])
    ]
)
```

## About SkipUI

SkipUI vends the `skip.ui` Kotlin package. It is a reimplementation of SwiftUI for Kotlin on Android using Jetpack Compose. Its goal is to mirror as much of SwiftUI as possible, allowing Skip developers to use SwiftUI with confidence.

![SkipUI Diagram](https://assets.skip.tools/diagrams/skip-diagrams-ui.svg)
{: .diagram-vector }

SkipUI is used directly by [Skip Lite](https://skip.tools/docs/status/#skip_fuse) transpiled Swift, and it is used indirectly by [Skip Fuse](https://skip.tools/docs/status/#skip_fuse) compiled Swift through the SkipFuseUI native framework.

## Dependencies

SkipUI depends on the [skip](https://source.skip.tools/skip) transpiler plugin. The transpiler must transpile SkipUI's own source code, and SkipUI relies on the transpiler's transformation of SwiftUI code. See [Implementation Strategy](#implementation-strategy) for details. SkipUI also depends on the [SkipFoundation](https://github.com/skiptools/skip-foundation) and [SkipModel](https://github.com/skiptools/skip-model) packages.

SkipUI is part of the core *SkipStack* and is not intended to be imported directly.
The module is transparently adopted by importing SwiftUI in compiled Swift, and through the translation of `import SwiftUI` into `import skip.ui.*` for transpiled code.

### Android Libraries

- SkipUI adds an Android dependency on [Coil](https://coil-kt.github.io/coil/) to implement `AsyncImage`.
- SkipUI includes source code from the [ComposeReorderable](https://github.com/aclassen/ComposeReorderable) project to implement drag-to-reorder in `Lists`.

## Status

SkipUI has robust support for the building blocks of SwiftUI, including its state flow and declarative syntax. SkipUI also implements a large percentage of SwiftUI's components and modifiers. It is possible to write an Android app entirely in SwiftUI utilizing SkipUI's current component set.

Some of SwiftUI's vast surface area, however, is not yet implemented. See [Supported SwiftUI](#supported-swiftui) for a full list of supported API.

When you want to use a SwiftUI construct that has not been implemented, you have options. You can try to find a workaround using only supported components, [embed Compose code directly](#composeview), or [add support to SkipUI](#implementation-strategy). If you choose to enhance SkipUI itself, please consider [contributing](#contributing) your code back for inclusion in the official release.

## ComposeView

`ComposeView` is an Android-only SwiftUI view that you can use to embed Compose directly into your SwiftUI view tree. Its use differs for Skip Fuse compiled code and Skip Lite transpiled code.

### Skip Fuse

In the following SkipFuseUI example, we use a SwiftUI `Text` to write "Hello from SwiftUI", followed by calling the `androidx.compose.material3.Text()` Compose function to write "Hello from Compose" below it. Notice that integrating Compose functions in Skip Fuse has two parts:

1. Define a `ContentComposer` in a transpiled `#if SKIP` block.
1. Use a `ComposeView` to render the `ContentComposer` in the SwiftUI view tree.

```swift
import SwiftUI

...

VStack {
    Text("Hello from SwiftUI")
    #if os(Android)
    ComposeView { MessageComposer(message: "Hello from Compose") }
    #endif
}

#if SKIP
struct MessageComposer : ContentComposer {
    let message: String
 
    @Composable func Compose(context: ComposeContext) {
        androidx.compose.material3.Text(message)
    }
}
#endif
```

The `ContentComposer` protocol consists of a single function:

```swift
public protocol ContentComposer {
    @Composable func Compose(context: ComposeContext)
}
```

#### Passing State

Remember that any data you pass to your `ContentComposer` must be bridged from your compiled Swift to your `#if SKIP` block's transpiled Kotlin. Simple data types like the `String` used in the example above bridge automatically. 

Skip also allows you to pass many built-in SwiftUI types. These types will bridge to their `SkipUI` implementations, which have been enhanced to allow you to use them in Compose. Examples include:

- `Color`: Pass any `Color` value to your `ContentComposer`, then use the `SkipUI.Color.asComposeColor()` function within your Compose code to get an `androidx.compose.ui.graphics.Color` value.
- `Font`: Similarly, pass any `Font` value and use the `SkipUI.Font.asComposeTextStyle()` function to get an `androidx.compose.ui.text.TextStyle`.
- `Image`: You can pass a native `Image` to your `ContentComposer` and receive the equivalent `SkipUI.Image`. Images, however, do not have a one-to-one equivalent Compose value type. You can still call `Image.Compose(context:)` to render it in your Compose code.
- `Text`: Passing a `Text` is a useful way to encapsulate a localizable string value. Call `SkipUI.Text.localizedTextString()` within your Compose code to get the localized value.

Here is sample code using some of these techniques:

```swift

...

#if os(Android)
ComposeView {
    MessageComposer(message: Text("Welcome"), textColor: .red)
}
#endif

...

#if SKIP
struct MessageComposer : ContentComposer {
    let message: Text
    let textColor: Color

    @Composable override func Compose(context: ComposeContext) {
        androidx.compose.material3.Text(message.localizedTextString(), color: textColor.asComposeColor())
    }
}
#endif

```

See the [bridging](https://skip.tools/docs/modes/#bridging) documentation for information on bridging your own data types.

### Skip Lite

In the following transpiled example, we use a SwiftUI `Text` to write "Hello from SwiftUI", followed by calling the `androidx.compose.material3.Text()` Compose function to write "Hello from Compose" below it:

```swift
import SwiftUI

...

VStack {
    Text("Hello from SwiftUI")
    #if SKIP
    ComposeView { _ in
        androidx.compose.material3.Text("Hello from Compose")
    }
    #endif
}
```

Unlike Skip Fuse, Skip Lite transpiled Swift can invoke Compose functions directly within the `ComposeView` body.

### Compose(context:)

SkipUI enhances all SwiftUI views with a `Compose(context:)` method, allowing you to use SwiftUI views from within Compose. The following example again uses a SwiftUI `Text` to write "Hello from SwiftUI", but this time from within a `ComposeView`.

Skip Fuse:

```swift
#if os(Android)
ComposeView { ColumnComposer() }
#endif

...

#if SKIP
struct ColumnComposer : ContentComposer {
    @Composable func Compose(context: ComposeContext) {
        androidx.compose.foundation.layout.Column(modifier: context.modifier) {
            Text("Hello from SwiftUI").Compose(context: context.content())
            androidx.compose.material3.Text("Hello from Compose")
        }
    }
}
#endif
```

Skip Lite:

```swift
#if SKIP
ComposeView { context in 
    androidx.compose.foundation.layout.Column(modifier: context.modifier) {
        Text("Hello from SwiftUI").Compose(context: context.content())
        androidx.compose.material3.Text("Hello from Compose")
    }
}
#endif
```

With `ComposeView` and the `Compose(context:)` function, you can move fluidly between SwiftUI and Compose code. These techniques work not only with standard SwiftUI and Compose components, but with your own custom SwiftUI views and Compose functions as well.

### Additional Considerations

There are additional considerations when integrating SwiftUI into a Compose application that is **not** managed by Skip. SwiftUI relies on its own mechanisms to save and restore `Activity` UI state, such as `@AppStorage` and navigation path bindings. It is not compatible with Android's `Activity` UI state restoration. Use a pattern like the following to exclude SwiftUI from `Activity` state restoration when integrating SwiftUI views:

```kotlin
val stateHolder = rememberSaveableStateHolder()
stateHolder.SaveableStateProvider("myKey") {
    MySwiftUIRootView().Compose()
    SideEffect { stateHolder.removeState("myKey") }
}
```

This pattern allows SkipUI to take advantage of Compose's UI state mechanisms internally while excluding it from `Activity` state restoration.

## composeModifier

In addition to `ComposeView` above, SkipUI offers the `composeModifier` SwiftUI modifier. This modifier allows you to apply any Compose modifiers to the underlying Compose view.

### Skip Fuse

Using `composeModifier` from Skip Fuse is much like using `ComposeView`:

1. Define a `ContentModifier` in a transpiled `#if SKIP` block.
1. Use `.composeModifier` to apply the `ContentModifier ` to the target SwiftUI view.

Within your `ContentModifier`, apply any SkipUI modifiers to the given target view. This includes the [Material](#material) modifiers we describe below, or the same-named transpiled `composeModifier`, which takes a block that accepts a single `androidx.compose.ui.Modifier` parameter and returns a `Modifier` as well. The following example applies Compose's `imePadding` modifier our SwiftUI on Android:

```swift
import SwiftUI

...

VStack {
    TextField("Enter username:", text: $username)
        #if os(Android)
        .composeModifier { IMEPaddingModifier() }
        #endif
}

#if SKIP
import androidx.compose.foundation.layout.imePadding

struct IMEPaddingModifier : ContentModifier {
    func modify(view: any View) -> any View {
        view.composeModifier { $0.imePadding() } 
    }
}
#endif
```

The `ContentModfiier` protocol consists of a single function:

```swift
public protocol ContentModifier {
    func modify(view: any View) -> any View
}
```

### Skip Lite

If you are writing your SwiftUI using Skip Lite, you don't need to define a `ContentModfifier`. You can apply [Material](#material) modifiers or `.composeModifier` directly:

```swift
#if SKIP
import androidx.compose.foundation.layout.imePadding
#endif

...

TextField("Enter username:", text: $username)
    #if SKIP
    .composeModifier { $0.imePadding() }
    #endif
```

## Material

Under the hood, SkipUI uses Android's Material 3 colors and components. While we expect you to use SwiftUI's built-in color schemes (`.preferredColorScheme`) and modifiers (`.background`, `.foregroundStyle`, `.tint`, and so on) for most UI styling, there are some Android customizations that have no SwiftUI equivalent. Skip therefore adds additional, Android-only API for manipulating Material colors and components.

### Material Colors

By default, Skip uses Material 3's dynamic colors on devices that support them, and falls back to Material 3's standard colors otherwise. You can customize these colors in Compose code using the following function: 

```kotlin
Material3ColorScheme(scheme: (@Composable (ColorScheme, Boolean) -> ColorScheme)?, content: @Composable () -> Unit)
```

The `scheme` argument takes a closure with two arguments: Skip's default `androidx.compose.material3.ColorScheme`, and whether dark mode is being requested. Your closure returns the `androidx.compose.material3.ColorScheme` to use for the supplied content.

For example, to customize the surface colors for your entire app, you could edit `Main.kt` as follows:

```kotlin
@Composable
internal fun PresentationRootView(context: ComposeContext) {
    Material3ColorScheme({ colors, isDark ->
        colors.copy(surface = if (isDark) Color.purple.asComposeColor() else Color.yellow.asComposeColor())
    }, content = {
        // ... Original content of this function ...
    })
}
```

Skip also provides the SwiftUI `.material3ColorScheme(_:)` modifier to customize a SwiftUI view hierarchy. The modifier takes the same closure as the `Material3ColorScheme` Kotlin function. Apply this modifier using the `.composeModifier` techniques discussed in the previous section. For example:

Skip Fuse:

```swift
MyView()
    #if os(Android)
    .composeModifier { ColorSchemeModifier() }
    #endif

...

#if SKIP
struct ColorSchemeModifier : ContentModifier {
    func modify(view: any View) -> any View {
        view.material3ColorScheme { colors, isDark in
            colors.copy(surface: isDark ? Color.purple.asComposeColor() : Color.yellow.asComposeColor())
        } 
    }  
}
#endif
```

Skip Lite: 

```swift
MyView()
    #if SKIP
    .material3ColorScheme { colors, isDark in
        colors.copy(surface: isDark ? Color.purple.asComposeColor() : Color.yellow.asComposeColor())
    }
    #endif
```

Skip's built-in components use the following Material 3 colors, if you'd like to customize them:

- `surface`
- `primary`
- `onBackground`
- `outline`
- `outlineVariant`

### Material Components

In addition to the `.material3ColorScheme` modifier detailed above, Skip includes many other `.material3` modifiers for its underlying Material 3 components. This family of modifiers share a common API pattern:

- The modifiers take a closure argument. This closure receives a `Material3<Component>Options` struct configured with Skip's defaults, and it returns a struct with any desired modifications.
- Every `Material3<Component>Options` struct implements a conventional Kotlin `copy` method. This allows you to copy and modify the struct in a single call.
- The modifiers place your closure into the SwiftUI `Environment`. This means that you can apply the modifier on a root view, and it will affect all subviews. While you may be used to placing navigation and tab bar modifiers on the views *within* the `NavigationStack` or `TabView`, the `.material3` family of modifiers always go *on or outside* the views you want to affect.
- Because they are designed to reach beneath Skip's SwiftUI covers, the modifiers use Compose terminology and types. In fact the properties of the supplied `Material3<Component>Options` structs typically exactly match the corresponding `androidx.compose.material3` component function parameters.

You can find details on Material 3 component API in [this Android API documentation](https://developer.android.com/reference/kotlin/androidx/compose/material3/package-summary).
{: class="callout info"}

Here is an example of changing the selected indicator color on your Android tab bar, which is implemented by the Material 3 `NavigationBar` component:

Skip Fuse:

```swift
TabView {
    ...
}
#if os(Android)
.composeModifier { NavigationBarModifier() }
#endif

...

#if SKIP
struct NavigationBarModifier : ContentModifier {
    func modify(view: any View) -> any View {
        view.material3NavigationBar { options in 
            let updatedColors = options.itemColors.copy(selectedIndicatorColor: Color.green.asComposeColor())
            return options.copy(itemColors: updatedColors) 
        }
    } 
} 
#endif
```

Skip Lite:

```swift
TabView {
    ...
}
#if SKIP
.material3NavigationBar { options in 
    let updatedColors = options.itemColors.copy(selectedIndicatorColor: Color.green.asComposeColor())
    return options.copy(itemColors: updatedColors) 
}
#endif
```

SkipUI currently includes the following Material modifiers:

```swift
extension View {
    public func material3BottomAppBar(_ options: @Composable (Material3BottomAppBarOptions) -> Material3BottomAppBarOptions) -> some View
}

public struct Material3BottomAppBarOptions {
    public var modifier: androidx.compose.ui.Modifier
    public var containerColor: androidx.compose.ui.graphics.Color
    public var contentColor: androidx.compose.ui.graphics.Color
    public var tonalElevation: androidx.compose.ui.unit.Dp
    public var contentPadding: androidx.compose.foundation.layout.PaddingValues
}

extension View {
    public func material3Button(_ options: @Composable (Material3ButtonOptions) -> Material3ButtonOptions) -> some View
}

public struct Material3ButtonOptions {
    public var onClick: () -> Void
    public var modifier: androidx.compose.ui.Modifier
    public var enabled: Bool
    public var shape: androidx.compose.ui.graphics.Shape
    public var colors: androidx.compose.material3.ButtonColors
    public var elevation: androidx.compose.material3.ButtonElevation?
    public var border: androidx.compose.foundation.BorderStroke?
    public var contentPadding: androidx.compose.foundation.layout.PaddingValues
    public var interactionSource: androidx.compose.foundation.interaction.MutableInteractionSource?
}

extension View {
    public func material3NavigationBar(_ options: @Composable (Material3NavigationBarOptions) -> Material3NavigationBarOptions) -> some View
}

public struct Material3NavigationBarOptions {
    public var modifier: androidx.compose.ui.Modifier
    public var containerColor: androidx.compose.ui.graphics.Color
    public var contentColor: androidx.compose.ui.graphics.Color
    public var tonalElevation: androidx.compose.ui.unit.Dp
    public var onItemClick: (Int) -> Void
    public var itemIcon: @Composable (Int) -> Void
    public var itemModifier: @Composable (Int) -> androidx.compose.ui.Modifier
    public var itemEnabled: (Int) -> Boolean
    public var itemLabel: (@Composable (Int) -> Void)?
    public var alwaysShowItemLabels: Bool
    public var itemColors: androidx.compose.material3.NavigationBarItemColors
    public var itemInteractionSource: androidx.compose.foundation.interaction.MutableInteractionSource?
}

extension View {
    public func material3SegmentedButton(_ options: @Composable (Material3SegmentedButtonOptions) -> Material3SegmentedButtonOptions) -> some View
}

public struct Material3SegmentedButtonOptions {
    public let index: Int
    public let count: Int
    public var selected: Boolean
    public var onClick: () -> Void
    public var modifier: androidx.compose.ui.Modifier
    public var enabled: Bool
    public var shape: androidx.compose.ui.graphics.Shape
    public var colors: androidx.compose.material3.SegmentedButtonColors
    public var border: androidx.compose.foundation.BorderStroke?
    public var contentPadding: androidx.compose.foundation.layout.PaddingValues
    public var interactionSource: androidx.compose.foundation.interaction.MutableInteractionSource?
    public var icon: @Composable () -> Void
}

extension View {
    public func material3Text(_ options: @Composable (Material3TextOptions) -> Material3TextOptions) -> some View
}

public struct Material3TextOptions {
    public var text: String?
    public var annotatedText: AnnotatedString?
    public var modifier: androidx.compose.ui.Modifier
    public var color: androidx.compose.ui.graphics.Color
    public var fontSize: androidx.compose.ui.unit.TextUnit
    public var fontStyle: androidx.compose.ui.text.font.FontStyle?
    public var fontWeight: androidx.compose.ui.text.font.FontWeight?
    public var fontFamily: androidx.compose.ui.text.font.FontFamily?
    public var letterSpacing: androidx.compose.ui.unit.TextUnit
    public var textDecoration: androidx.compose.ui.text.style.TextDecoration?
    public var textAlign: androidx.compose.ui.text.style.TextAlign?
    public var lineHeight: androidx.compose.ui.unit.TextUnit
    public var overflow: androidx.compose.ui.text.style.TextOverflow
    public var softWrap: Bool
    public var maxLines: Int
    public var minLines: Int
    public var onTextLayout: ((androidx.compose.ui.text.TextLayoutResult) -> Void)?
    public var style: androidx.compose.ui.text.style.TextStyle
}

extension View {
    public func material3TextField(_ options: @Composable (Material3TextFieldOptions) -> Material3TextFieldOptions) -> some View
}

public struct Material3TextFieldOptions {
    public var value: androidx.compose.ui.text.input.TextFieldValue
    public var onValueChange: (androidx.compose.ui.text.input.TextFieldValue) -> Void
    public var modifier: androidx.compose.ui.Modifier
    public var enabled: Bool
    public var readOnly: Bool
    public var textStyle: androidx.compose.ui.text.TextStyle
    public var label: (@Composable () -> Void)?
    public var placeholder: (@Composable () -> Void)?
    public var leadingIcon: (@Composable () -> Void)?
    public var trailingIcon: (@Composable () -> Void)?
    public var prefix: (@Composable () -> Void)?
    public var suffix: (@Composable () -> Void)? 
    public var supportingText: (@Composable () -> Void)?
    public var isError: Bool
    public var visualTransformation: androidx.compose.ui.text.input.VisualTransformation
    public var keyboardOptions: androidx.compose.foundation.text.KeyboardOptions
    public var keyboardActions: androidx.compose.foundation.text.KeyboardActions
    public var singleLine: Bool
    public var maxLines: Int
    public var minLines: Int
    public var interactionSource: androidx.compose.foundation.interaction.MutableInteractionSource?
    public var shape: androidx.compose.ui.graphics.Shape
    public var colors: androidx.compose.material3.TextFieldColors
}

extension View {
    public func material3TopAppBar(_ options: @Composable (Material3TopAppBarOptions) -> Material3TopAppBarOptions) -> some View
}

public struct Material3TopAppBarOptions {
    public var title: @Composable () -> Void
    public var modifier: androidx.compose.ui.Modifier
    public var navigationIcon: @Composable () -> Void
    public var colors: androidx.compose.material3.TopAppBarColors
    public var scrollBehavior: androidx.compose.material3.TopAppBarScrollBehavior?
    public var preferCenterAlignedStyle: Bool
    public var preferLargeStyle: Bool
}
```

Note that `.material3TopAppBar` involves API that Compose deems experimental, so you must add the following to any Skip Fuse `ContentModfifier` or Skip Lite `View` where you use it:

```swift
// SKIP INSERT: @OptIn(androidx.compose.material3.ExperimentalMaterial3Api::class)
struct MyContentModifier : ContentModifier {
    ...
}
```

### Material Effects

Compose applies an automatic "ripple" effect to components on tap. You can customize the color and alpha of this effect with the `material3Ripple` modifier. To disable the effect altogether, return `nil` from your modifier closure.

```swift
extension View {
    public func material3Ripple(_ options: @Composable (Material3RippleOptions?) -> Material3RippleOptions?) -> some View
}

public struct Material3RippleOptions {
    public var color: androidx.compose.ui.graphics.Color = androidx.compose.ui.graphics.Color.Unspecified
    public var rippleAlpha: androidx.compose.material.ripple.RippleAlpha? = nil
}
```

## Supported SwiftUI

The following table summarizes SkipUI's SwiftUI support on Android. Anything not listed here is likely not supported. Note that in your iOS-only code - i.e. code within `#if !os(Android)` blocks - you can use any SwiftUI you want.

Support levels:

  - ✅ – Full
  - 🟢 – High
  - 🟡 – Medium 
  - 🟠 – Low

<table>
  <thead><th>Support</th><th>API</th></thead>
  <tbody>
    <tr>
      <td>🟢</td>
      <td>
            <details>
              <summary><code>@AppStorage</code> (<a href="https://skip.tools/docs/components/storage/">example</a>)</summary>
              <ul>
                  <li>Optional values are not supported</li>
              </ul>
          </details> 
      </td>
    </tr>
    <tr>
      <td>✅</td>
      <td><code>@Bindable</code></td>
    </tr>
    <tr>
      <td>✅</td>
      <td><code>@Binding</code> (<a href="https://skip.tools/docs/components/state/">example</a>)</td>
    </tr>
    <tr>
      <td>✅</td>
      <td>
         <details>
              <summary><code>@Environment</code> (<a href="https://skip.tools/docs/components/modifier/">example</a>)</summary>
              <ul>
                  <li>See <a href="#environment-keys">Environment Keys</a></li>
              </ul>
          </details> 
      </td>
    </tr>
    <tr>
      <td>✅</td>
      <td><code>@EnvironmentObject</code> (<a href="https://skip.tools/docs/components/observable/">example</a>)</td>
    </tr>
    <tr>
      <td>🟢</td>
      <td>
         <details>
              <summary><code>@FocusState</code></summary>
              <ul>
                  <li><code>FocusState.Binding</code> is not supported, though you can manually create a <code>Binding(get: { myFocusState.wrappedValue }, set: { myFocusState.wrappedValue = $0 })</code></li>
              </ul>
          </details> 
      </td>
    </tr>
    <tr>
      <td>🟡</td>
      <td>
         <details>
              <summary><code>@GestureState</code></summary>
              <ul>
                  <li>Only supported in SkipFuseUI compiled Swift</li>
              </ul>
          </details> 
      </td>
    </tr>
    <tr>
      <td>✅</td>
      <td><code>@ObservedObject</code> (<a href="https://skip.tools/docs/components/observable/">example</a>)</td>
    </tr>
    <tr>
      <td>✅</td>
      <td><code>@State</code> (<a href="https://skip.tools/docs/components/state/">example</a>)</td>
    </tr>
    <tr>
      <td>✅</td>
      <td><code>@StateObject</code> (<a href="https://skip.tools/docs/components/state/">example</a>)</td>
    </tr>
    <tr>
      <td>✅</td>
      <td><code>AsyncImage</code> (<a href="https://skip.tools/docs/components/image/">example</a>)</td>
    </tr>
    <tr>
      <td>✅</td>
      <td><code>Button</code> (<a href="https://skip.tools/docs/components/button/">example</a>)</td>
    </tr>
    <tr>
      <td>✅</td>
      <td><code>Capsule</code> (<a href="https://skip.tools/docs/components/shape/">example</a>)</td>
    </tr>
    <tr>
      <td>✅</td>
      <td><code>Circle</code> (<a href="https://skip.tools/docs/components/shape/">example</a>)</td>
    </tr>
    <tr>
      <td>🟢</td>
      <td>
          <details>
              <summary><code>Color</code> (<a href="https://skip.tools/docs/components/color/">example</a>)</summary>
              <ul>
                  <li><code>init(red: Double, green: Double, blue: Double, opacity: Double = 1.0)</code></li>
                  <li><code>init(white: Double, opacity: Double = 1.0)</code></li>
                  <li><code>init(hue: Double, saturation: Double, brightness: Double, opacity: Double = 1.0)</code></li>
                  <li><code>init(_ color: UIColor)</code></li>
                  <li><code>init(uiColor: UIColor)</code></li>
                  <li><code>init(_ name: String, bundle: Bundle? = nil)</code></li>
                  <li><code>static let accentColor: Color</code></li>
                  <li><code>static let primary: Color</code></li>
                  <li><code>static let secondary: Color</code></li>
                  <li><code>static let clear: Color</code></li>
                  <li><code>static let white: Color</code></li>
                  <li><code>static let black: Color</code></li>
                  <li><code>static let gray: Color</code></li>
                  <li><code>static let red: Color</code></li>
                  <li><code>static let orange: Color</code></li>
                  <li><code>static let yellow: Color</code></li>
                  <li><code>static let green: Color</code></li>
                  <li><code>static let mint: Color</code></li>
                  <li><code>static let teal: Color</code></li>
                  <li><code>static let cyan: Color</code></li>
                  <li><code>static let blue: Color</code></li>
                  <li><code>static let indigo: Color</code></li>
                  <li><code>static let purple: Color</code></li>
                  <li><code>static let pink: Color</code></li>
                  <li><code>static let brown: Color</code></li>
                  <li><code>func opacity(_ opacity: Double) -> Color</code></li>
                  <li><code>var gradient: AnyGradient</code></li>
                  <li>See <a href="#colors">Colors</a></li>
              </ul>
          </details>      
       </td>
    </tr>
    <tr>
      <td>🟡</td>
      <td>
          <details>
              <summary><code>DatePicker</code> (<a href="https://skip.tools/docs/components/datepicker/">example</a>)</summary>
              <ul>
                  <li><code>init(selection: Binding&lt;Date>, displayedComponents: DatePickerComponents = [.hourAndMinute, .date], @ViewBuilder label: () -> any View)</code></li>
                  <li><code>init(_ title: String, selection: Binding&lt;Date>, displayedComponents: DatePickerComponents = [.hourAndMinute, .date])</code></li>
              </ul>
          </details>      
       </td>
    </tr>
    <tr>
      <td>🟡</td>
      <td>
          <details>
              <summary><code>DisclosureGroup</code> (<a href="https://skip.tools/docs/components/disclosuregroup/">example</a>)</summary>
              <ul>
                  <li><code>init(isExpanded: Binding&lt;Bool&gt;, @ViewBuilder content: @escaping () -> any View, @ViewBuilder label: () -> any View)</code></li>
                  <li><code>init(_ titleKey: LocalizedStringKey, isExpanded: Binding&lt;Bool&gt;, @ViewBuilder content: @escaping () -> any View)</code></li>
                    <li><code>init(_ titleResource: LocalizedStringResource, isExpanded: Binding&lt;Bool&gt;, @ViewBuilder content: @escaping () -> any View)</code></li>
                  <li><code>init(_ label: String, isExpanded: Binding&lt;Bool&gt;, @ViewBuilder content: @escaping () -> any View)</code></li>
                  <li>Does not animate when used as a <code>List</code> or <code>Form</code> item</li>
                  <li>Always animates when **not** used as a <code>List</code> or <code>Form</code> item</li>
              </ul>
          </details>      
       </td>
    </tr>
    <tr>
      <td>✅</td>
      <td><code>Divider</code> (<a href="https://skip.tools/docs/components/divider/">example</a>)</td>
    </tr>
    <tr>
      <td>🟢</td>
      <td>
          <details>
              <summary><code>DragGesture</code> (<a href="https://skip.tools/docs/components/gesture/">example</a>)</summary>
              <ul>
                  <li>See <a href="#gestures">Gestures</a></li>
              </ul>
          </details>      
       </td>
    </tr>
    <tr>
      <td>🟡</td>
      <td>
          <details>
              <summary><code>EllipticalGradient</code> (<a href="https://skip.tools/docs/components/gradient/">example</a>)</summary>
              <ul>
                  <li>Fills as a circular gradient instead of elliptical unless the gradient is used as its own <code>View</code></li>
              </ul>
          </details>      
       </td>
    </tr>
    <tr>
      <td>✅</td>
      <td><code>EmptyModifier</code></td>
    </tr>
    <tr>
      <td>✅</td>
      <td><code>EmptyView</code></td>
    </tr>
    <tr>
      <td>🟡</td>
      <td>
          <details>
              <summary><code>Font</code></summary>
              <ul>
                  <li><code>static let largeTitle: Font</code></li>
                  <li><code>static let title: Font</code></li>
                  <li><code>static let title2: Font</code></li>
                  <li><code>static let title3: Font</code></li>
                  <li><code>static let headline: Font</code></li>
                  <li><code>static let subheadline: Font</code></li>
                  <li><code>static let body: Font</code></li>
                  <li><code>static let callout: Font</code></li>
                  <li><code>static let footnote: Font</code></li>
                  <li><code>static let caption: Font</code></li>
                  <li><code>static let caption2: Font</code></li>
                  <li><code>static func system(_ style: Font.TextStyle, design: Font.Design? = nil, weight: Font.Weight? = nil) -> Font</code></li>
                  <li><code>static func system(size: CGFloat, weight: Font.Weight? = nil, design: Font.Design? = nil) -> Font</code></li>
                  <li><code>static func custom(_ name: String, size: CGFloat) -> Font</code></li>
                  <li><code>static func custom(_ name: String, size: CGFloat, relativeTo textStyle: Font.TextStyle) -> Font</code></li>
                  <li><code>static func custom(_ name: String, fixedSize: CGFloat) -> Font</code></li>
                  <li><code>func italic(_ isActive: Bool = true) -> Font</code></li>
                  <li><code>func weight(_ weight: Font.Weight) -> Font</code></li>
                  <li><code>func bold(_ isActive: Bool = true) -> Font</code></li>
                  <li><code>func monospaced(_ isActive: Bool = true) -> Font</code></li>
                  <li><code>func pointSize(_ size: CGFloat) -> Font</code></li>
                  <li><code>func scaledBy(_ factor: CGFloat) -> Font</code></li>
              </ul>
          </details>      
       </td>
    </tr>
    <tr>
      <td>🟢</td>
      <td>
          <details>
              <summary><code>ForEach</code></summary>
              <ul>
                  <li>See <a href="#foreach">ForEach</a></li>
              </ul>
          </details>      
       </td>
    </tr>
    <tr>
      <td>✅</td>
      <td><code>Form</code> (<a href="https://skip.tools/docs/components/form/">example</a>)</td>
    </tr>
    <tr>
      <td>🟡</td>
      <td>
          <details>
              <summary><code>GeometryProxy</code></summary>
              <ul>
                  <li><code>var size: CGSize</code></li>
                  <li><code>func frame(in coordinateSpace: some CoordinateSpaceProtocol) -> CGRect</code></li>
                  <li><code>var safeAreaInsets: EdgeInsets</code></li>
                  <li>Only <code>.local</code> and <code>.global</code> coordinate spaces are supported</li>
              </ul>
          </details>      
       </td>
    </tr>
    <tr>
      <td>🟡</td>
      <td>
          <details>
              <summary><code>GeometryReader</code></summary>
              <ul>
                  <li>See <code>GeometryProxy</code></li>
              </ul>
          </details>      
       </td>
    </tr>
    <tr>
      <td>✅</td>
      <td><code>Group</code></td>
    </tr>
    <tr>
      <td>✅</td>
      <td><code>HStack</code> (<a href="https://skip.tools/docs/components/stack/">example</a>)</td>
    </tr>
    <tr>
      <td>🟢</td>
      <td>
          <details>
              <summary><code>Image</code> (<a href="https://skip.tools/docs/components/image/">example</a>)</summary>
              <ul>
                  <li><code>init(_ name: String, bundle: Bundle? = Bundle.main)</code></li>
                  <li><code>init(_ name: String, bundle: Bundle? = Bundle.main, label: Text)</code></li>
                  <li><code>init(systemName: String)</code></li>
                  <li><code>init(uiImage: UIImage)</code></li>
                  <li>See <a href="#images">Images</a></li>
              </ul>
          </details>      
       </td>
    </tr>
    <tr>
      <td>🟢</td>
      <td>
          <details>
              <summary><code>Label</code> (<a href="https://skip.tools/docs/components/label/">example</a>)</summary>
              <ul>
                  <li><code>init(@ViewBuilder title: () -> any View, @ViewBuilder icon: () -> any View)</code></li>
                  <li><code>init(_ title: String, systemImage: String)</code></li>
                  <li><code>init(_ title: String, image: String)</code></li>
                  <li>See <a href="#images">Images</a></li>
              </ul>
          </details>      
       </td>
    </tr>
    <tr>
      <td>🟡</td>
      <td>
          <details>
              <summary><code>LazyHGrid</code></summary>
              <ul>
                  <li>See <a href="#grids">Grids</a></li>
              </ul>
          </details>      
       </td>
    </tr>
    <tr>
      <td>🟡</td>
      <td>
          <details>
              <summary><code>LazyHStack</code></summary>
              <ul>
                  <li>Does not support pinned headers and footers</li>
                  <li>When placed in a <code>ScrollView</code>, it must be the only child of that view</li>
              </ul>
          </details>      
       </td>
    </tr>
    <tr>
      <td>🟡</td>
      <td>
          <details>
              <summary><code>LazyVGrid</code></summary>
              <ul>
                  <li>See <a href="#grids">Grids</a></li>
              </ul>
          </details>      
       </td>
    </tr>
    <tr>
      <td>🟡</td>
      <td>
          <details>
              <summary><code>LazyVStack</code></summary>
              <ul>
                  <li>Does not support pinned headers and footers</li>
                  <li>When placed in a <code>ScrollView</code>, it must be the only child of that view</li>
              </ul>
          </details>      
       </td>
    </tr>
    <tr>
      <td>✅</td>
      <td><code>LinearGradient</code> (<a href="https://skip.tools/docs/components/gradient/">example</a>)</td>
    </tr>
    <tr>
      <td>✅</td>
      <td><code>Link</code> (<a href="https://skip.tools/docs/components/link/">example</a>)</td>
    </tr>
    <tr>
      <td>🟢</td>
      <td>
          <details>
              <summary><code>List</code> (<a href="https://skip.tools/docs/components/list/">example</a>)</summary>
              <ul>
                  <li>See <a href="#lists">Lists</a></li>
              </ul>
          </details>      
       </td>
    </tr>
    <tr>
      <td>🟢</td>
      <td>
          <details>
              <summary><code>LongPressGesture</code> (<a href="https://skip.tools/docs/components/gesture/">example</a>)</summary>
              <ul>
                  <li>See <a href="#gestures">Gestures</a></li>
              </ul>
          </details>      
       </td>
    </tr>
    <tr>
      <td>🟢</td>
      <td>
          <details>
              <summary><code>MagnifyGesture</code> (<a href="https://skip.tools/docs/components/gesture/">example</a>)</summary>
              <ul>
                  <li>See <a href="#gestures">Gestures</a></li>
              </ul>
          </details>      
       </td>
    </tr>
    <tr>
      <td>✅</td>
      <td><code>Menu</code> (<a href="https://skip.tools/docs/components/menu/">example</a>)</td>
    </tr>
    <tr>
      <td>🟢</td>
      <td>
          <details>
              <summary><code>NavigationLink</code> (<a href="https://skip.tools/docs/components/list/">example</a>)</summary>
              <ul>
                  <li>See <a href="#navigation">Navigation</a></li>
              </ul>
          </details>      
       </td>
    </tr>
    <tr>
      <td>🟢</td>
      <td>
          <details>
              <summary><code>NavigationPath</code></summary>
              <ul>
                  <li><code>init()</code></li>
                  <li><code>init(_ elements: any Sequence)</code></li>
                  <li><code>var count: Int</code></li>
                  <li><code>var isEmpty: Bool</code></li>
                  <li><code>mutating func append(_ value: Any)</code></li>
                  <li><code>mutating func removeLast(_ k: Int = 1)</code></li>
                  <li>Does not support `codable` property</li>
              </ul>
          </details>      
       </td>
    </tr>
    <tr>
      <td>🟢</td>
      <td>
          <details>
              <summary><code>NavigationStack</code> (<a href="https://skip.tools/docs/components/navigationstack/">example</a>)</summary>
              <ul>
                  <li>See <a href="#navigation">Navigation</a></li>
              </ul>
          </details>      
       </td>
    </tr>
    <tr>
      <td>✅</td>
      <td><code>Oval</code> (<a href="https://skip.tools/docs/components/shape/">example</a>)</td>
    </tr>
    <tr>
      <td>✅</td>
      <td><code>Picker</code> (<a href="https://skip.tools/docs/components/picker/">example</a>)</td>
    </tr>
    <tr>
      <td>🟢</td>
      <td>
          <details>
              <summary><code>ProgressView</code> (<a href="https://skip.tools/docs/components/progressview/">example</a>)</summary>
              <ul>
                  <li><code>init()</code></li>
                  <li><code>init(value: Double?, total: Double = 1.0)</code></li>
                  <li><code>init(@ViewBuilder label: () -> any View)</code></li>
                  <li><code>init(_ titleKey: LocalizedStringKey)</code></li>
                  <li><code>init(_ titleResource: LocalizedStringResource)</code></li>
                  <li><code>init(_ title: String)</code></li>
                  <li><code>init(value: Double?, total: Double = 1.0, @ViewBuilder label: () -> any View)</code></li>
                  <li><code>init(_ titleKey: LocalizedStringKey, value: Double?, total: Double = 1.0)</code></li>
                  <li><code>init(_ titleResource: LocalizedStringResource, value: Double?, total: Double = 1.0)</code></li>
                  <li><code>init(_ title: String, value: Double?, total: Double = 1.0)</code></li>
              </ul>
          </details>      
       </td>
    </tr>
    <tr>
      <td>✅</td>
      <td><code>RadialGradient</code> (<a href="https://skip.tools/docs/components/gradient/">example</a>)</td>
    </tr>
    <tr>
      <td>✅</td>
      <td><code>Rectangle</code> (<a href="https://skip.tools/docs/components/shape/">example</a>)</td>
    </tr>
    <tr>
      <td>🟢</td>
      <td>
          <details>
              <summary><code>RotateGesture</code> (<a href="https://skip.tools/docs/components/gesture/">example</a>)</summary>
              <ul>
                  <li>See <a href="#gestures">Gestures</a></li>
              </ul>
          </details>      
       </td>
    </tr>
    <tr>
      <td>✅</td>
      <td><code>RoundedRectangle</code> (<a href="https://skip.tools/docs/components/shape/">example</a>)</td>
    </tr>
    <tr>
      <td>✅</td>
      <td><code>ScrollView</code> (<a href="https://skip.tools/docs/components/frame/">example</a>)</td>
    </tr>
    <tr>
      <td>✅</td>
      <td>
          <details>
              <summary><code>ScrollView</code></summary>
              <ul>
                  <li>See <a href="#scrolling">Scrolling</a></li>
              </ul>
          </details>      
       </td>
    </tr>
    <tr>
      <td>🟡</td>
      <td>
          <details>
              <summary><code>ScrollViewProxy</code></summary>
              <ul>
                  <li>See <a href="#scrolling">Scrolling</a></li>
              </ul>
          </details>      
       </td>
    </tr>
    <tr>
      <td>🟡</td>
      <td>
          <details>
              <summary><code>ScrollViewReader</code></summary>
              <ul>
                  <li>See <a href="#scrolling">Scrolling</a></li>
              </ul>
          </details>      
       </td>
    </tr>
    <tr>
      <td>🟢</td>
      <td>
          <details>
              <summary><code>Section</code> (<a href="https://skip.tools/docs/components/list/">example</a>)</summary>
              <ul>
                  <li>See <a href="#lists">Lists</a></li>
              </ul>
          </details>      
       </td>
    </tr>
    <tr>
      <td>✅</td>
      <td><code>SecureField</code> (<a href="https://skip.tools/docs/components/securefield/">example</a>)</td>
    </tr>
    <tr>
      <td>🟠</td>
      <td>
          <details>
              <summary><code>ShareLink</code> (<a href="https://skip.tools/docs/components/sharelink/">example</a>)</summary>
              <ul>
                  <li>Supports sharing <code>String</code> or <code>URL</code> data only</li>
              </ul>
          </details>      
       </td>
    </tr>
    <tr>
      <td>🟡</td>
      <td>
          <details>
              <summary><code>Slider</code> (<a href="https://skip.tools/docs/components/slider/">example</a>)</summary>
              <ul>
                  <li><code>init(value: Binding&lt;Double>, in bounds: ClosedRange&lt;Double> = 0.0...1.0, step: Double? = nil)</code></li>
              </ul>
          </details>      
       </td>
    </tr>
    <tr>
      <td>🟢</td>
      <td>
          <details>
              <summary><code>Spacer</code> (<a href="https://skip.tools/docs/components/border/">example</a>)</summary>
              <ul>
                  <li>In Compose, when multiple elements want to expand they will share the available space equally</li>
              </ul>
          </details>      
       </td>
    </tr>
    <tr>
      <td>🟢</td>
      <td>
          <details>
              <summary><code>Tab</code> (<a href="https://skip.tools/docs/components/tabview/">example</a>)</summary>
              <ul>
                  <li>See <a href="#navigation">Navigation</a></li>
              </ul>
          </details>      
       </td>
    </tr>
    <tr>
      <td>🟠</td>
      <td>
          <details>
              <summary><code>Table</code></summary>
              <ul>
                  <li><code>init(_ data: any RandomAccessCollection&lt;ObjectType&gt;, @ViewBuilder content: () -> some View)</code></li>
                  <li><code>init(_ data: any RandomAccessCollection&lt;ObjectType&gt;, selection: Binding&lt;ObjectType?&gt;, @ViewBuilder columns: () -> some View)</code></li>
                  <li><code>init(_ data: any RandomAccessCollection&lt;ObjectType&gt;, selection: Binding&lt;Set&lt;ObjectType&gt;&gt;, @ViewBuilder columns: () -> some View)</code></li>
                  <li>All <code>TableColumns</code> must be directly nested in the parent <code>Table</code> content block</li>
		  <li>Multiple selection is not supported</li>
              </ul>
          </details>      
       </td>
    </tr>
    <tr>
      <td>🟠</td>
      <td>
          <details>
              <summary><code>TableColumn</code></summary>
              <ul>
                  <li><code>init(_ title: String, value: (ObjectType) -> String, comparator: Comparator? = nil)</code></li>
                  <li><code>init(_ title: String, value: Value? = nil, comparator: Comparator? = nil, @ViewBuilder content: @escaping (ObjectType) -> some View)</code></li>
                 <li><code>init(_ title: Text, value: (ObjectType) -> String, comparator: Comparator? = nil)</code></li>
                  <li><code>init(_ title: Text, value: Value? = nil, comparator: Comparator? = nil, @ViewBuilder content: @escaping (ObjectType) -> some View)</code></li>
                  <li><code>func width(_ value: CGFloat? = nil)</code></li>
                  <li><code>func width(min: CGFloat? = nil, ideal: CGFloat? = nil, max: CGFloat? = nil)</code></li>
              </ul>
          </details>      
       </td>
    </tr>
    <tr>
      <td>🟠</td>
      <td>
          <details>
              <summary><code>TabSection</code></summary>
              <ul>
                  <li>See <a href="#navigation">Navigation</a></li>
              </ul>
          </details>      
       </td>
    </tr>
    <tr>
      <td>🟢</td>
      <td>
          <details>
              <summary><code>TabView</code> (<a href="https://skip.tools/docs/components/tabview/">example</a>)</summary>
              <ul>
                  <li>See <a href="#navigation">Navigation</a></li>
              </ul>
          </details>      
       </td>
    </tr>
    <tr>
      <td>🟢</td>
      <td>
          <details>
              <summary><code>TapGesture</code> (<a href="https://skip.tools/docs/components/gesture/">example</a>)</summary>
              <ul>
                  <li>See <a href="#gestures">Gestures</a></li>
              </ul>
          </details>      
       </td>
    </tr>
    <tr>
      <td>🟢</td>
      <td>
          <details>
              <summary><code>Text</code> (<a href="https://skip.tools/docs/components/text/">example</a>)</summary>
              <ul>
                  <li><code>Text(...) + Text(...)</code> is not supported</li>
                  <li>For formatters, only <code>Text.DateStyle.date</code> and <code>Text.DateStyle.time</code> are supported</li>
              </ul>
          </details>      
       </td>
    </tr>
    <tr>
      <td>🟢</td>
      <td>
          <details>
              <summary><code>TextEditor</code></summary>
              <ul>
                  <li><code>.font</code>, <code>.lineSpacing</code>, etc modifiers have no effect</li>
              </ul>
          </details>      
       </td>
    </tr>
    <tr>
      <td>🟢</td>
      <td>
          <details>
              <summary><code>TextField</code> (<a href="https://skip.tools/docs/components/textfield/">example</a>)</summary>
              <ul>
                  <li><code>init(_ title: String, text: Binding&lt;String>, selection: Binding&lt;TextSelection?>? = nil, prompt: Text? = nil)</code></li>
              </ul>
          </details>      
       </td>
    </tr>
    <tr>
      <td>🟡</td>
      <td>
          <details>
              <summary><code>Toggle</code> (<a href="https://skip.tools/docs/components/toggle/">example</a>)</summary>
              <ul>
                  <li><code>init(isOn: Binding&lt;Bool>, @ViewBuilder label: () -> any View)</code></li>
              </ul>
          </details>      
       </td>
    </tr>
    <tr>
      <td>🟢</td>
      <td>
         <details>
              <summary><code>ToolbarContent</code></summary>
              <ul>
                  <li>All of the items in a given custom <code>ToolbarContent</code> view must have the same <code>ToolbarItemPlacement</code></li>
              </ul>
          </details> 
      </td>
    </tr>
    <tr>
      <td>✅</td>
      <td><code>ToolbarItem</code> (<a href="https://skip.tools/docs/components/toolbar/">example</a>)</td>
    </tr>
    <tr>
      <td>✅</td>
      <td><code>ToolbarItemGroup</code> (<a href="https://skip.tools/docs/components/toolbar/">example</a>)</td>
    </tr>
    <tr>
      <td>✅</td>
      <td><code>ToolbarSpacer</code></td>
    </tr>
    <tr>
      <td>✅</td>
      <td><code>ToolbarTitleMenu</code></td>
    </tr>
    <tr>
      <td>🟠</td>
      <td>
          <details>
              <summary><code>UIKit</code></summary>
              <ul>
                  <li>See <a href="#supported-uikit">Supported UIKit</a></li>
              </ul>
          </details>      
       </td>
    </tr>
    <tr>
      <td>✅</td>
      <td><code>UnevenRoundedRectangle</code> (<a href="https://skip.tools/docs/components/shape/">example</a>)</td>
    </tr>
    <tr>
      <td>✅</td>
      <td>Custom <code>Views</code></td>
    </tr>
    <tr>
      <td>✅</td>
      <td>Custom <code>ViewModifiers</code></td>
    </tr>
    <tr>
      <td>✅</td>
      <td>Custom <code>ViewThatFits</code></td>
    </tr>
    <tr>
      <td>✅</td>
      <td>
          <details>
              <summary><code>VStack</code> (<a href="https://skip.tools/docs/components/stack/">example</a>)</summary>
              <ul>
                  <li>See <a href="#layout">Layout</a></li>
              </ul>
          </details>      
       </td>
    </tr>
    <tr>
      <td>🟡</td>
      <td>
            <details>
              <summary><code>withAnimation</code></summary>
              <ul>
                  <li>See <a href="#animation">Animation</a></li>
              </ul>
          </details> 
      </td>
    </tr>
    <tr>
      <td>✅</td>
      <td><code>ZStack</code> (<a href="https://skip.tools/docs/components/stack/">example</a>)</td>
    </tr>
    <tr>
      <td>🟢</td>
      <td>
          <details>
              <summary><code>.accessibilityAddTraits</code></summary>
              <ul>
                  <li>Only traits that map to Compose accessibility roles are used</li>
              </ul>
          </details>      
       </td>
    </tr>
   <tr>
      <td>✅</td>
      <td><code>.accessibilityHeading</code></td>
    </tr>
    <tr>
      <td>✅</td>
      <td><code>.accessibilityHidden</code></td>
    </tr>
    <tr>
      <td>✅</td>
      <td><code>.accessibilityIdentifier</code></td>
    </tr>
    <tr>
      <td>✅</td>
      <td><code>.accessibilityLabel</code></td>
    </tr>
    <tr>
      <td>✅</td>
      <td><code>.accessibilityValue</code></td>
    </tr>
   <tr>
      <td>✅</td>
      <td><code>.alert</code></td>
    </tr>
    <tr>
      <td>🟡</td>
      <td>
            <details>
              <summary><code>.animation</code></summary>
              <ul>
                  <li>See <a href="#animation">Animation</a></li>
              </ul>
          </details> 
      </td>
    </tr>
    <tr>
      <td>🟡</td>
      <td>
          <details>
              <summary><code>.aspectRatio</code></summary>
              <ul>
                  <li><code>contentMode</code> is only supported for images</li>
              </ul>
          </details>      
       </td>
    </tr>
    <tr>
      <td>✅</td>
      <td><code>.autocorrectionDisabled</code></td>
    </tr>
    <tr>
      <td>🟢</td>
      <td>
          <details>
              <summary><code>.background</code> (<a href="https://skip.tools/docs/components/background/">example</a>)</summary>
              <ul>
                  <li>See <a href="#safe-area">Safe Area</a></li>
              </ul>
          </details>      
       </td>
    </tr>
    <tr>
      <td>✅</td>
      <td><code>.backgroundStyle</code></td>
    </tr>
    <tr>
      <td>🟢</td>
      <td>
          <details>
              <summary><code>.blur</code></summary>
              <ul>
                  <li><code>opaque</code> parameter is ignored</li>
              </ul>
          </details>      
       </td>
    </tr>
    <tr>
      <td>✅</td>
      <td><code>.bold</code></td>
    </tr>
    <tr>
      <td>✅</td>
      <td><code>.border</code> (<a href="https://skip.tools/docs/components/border/">example</a>)</td>
    </tr>
    <tr>
      <td>🟢</td>
      <td>
          <details>
              <summary><code>.buttonStyle</code></summary>
              <ul>
                  <li><code>.automatic</code></li>
                  <li><code>.plain</code></li>
                  <li><code>.borderless</code></li>
                  <li><code>.bordered</code></li>
                  <li><code>.borderedProminent</code></li>
                  <li>Custom styles are not supported</li>
              </ul>
          </details>      
       </td>
    </tr>
    <tr>
      <td>🟡</td>
      <td>
          <details>
              <summary><code>.clipped</code></summary>
              <ul>
                  <li>Most content in Compose clips automatically</li>
              </ul>
          </details>      
       </td>
    </tr>
    <tr>
      <td>✅</td>
      <td><code>.clipShape</code></td>
    </tr>
    <tr>
      <td>✅</td>
      <td>
            <details>
              <summary><code>.colorScheme </code></summary>
              <ul>
                  <li>See also <a href="#colorscheme">ColorScheme</a></li>
              </ul>
          </details> 
      </td>
    </tr>
    <tr>
      <td>✅</td>
      <td><code>.confirmationDialog</code> (<a href="https://skip.tools/docs/components/confirmationdialog/">example</a>)</td>
    </tr>
    <tr>
      <td>✅</td>
      <td><code>.cornerRadius</code></td>
    </tr>
    <tr>
      <td>🟠</td>
      <td>
          <details>
              <summary><code>.datePickerStyle</code></summary>
              <ul>
                  <li><code>.automatic</code></li>
                  <li><code>.compact</code></li>
                  <li>Custom styles are not supported</li>
              </ul>
          </details>      
       </td>
    </tr>
    <tr>
      <td>✅</td>
      <td><code>.deleteDisabled</code></td>
    </tr>
    <tr>
      <td>✅</td>
      <td><code>.disabled</code></td>
    </tr>
    <tr>
      <td>✅</td>
      <td><code>.environment</code></td>
    </tr>
    <tr>
      <td>✅</td>
      <td><code>.environmentObject</code></td>
    </tr>
    <tr>
      <td>✅</td>
      <td><code>.fill</code></td>
    </tr>
    <tr>
      <td>✅</td>
      <td><code>.focused</code></td>
    </tr>
    <tr>
      <td>✅</td>
      <td><code>.font</code> (<a href="https://skip.tools/docs/components/text/">example</a>)</td>
    </tr>
    <tr>
      <td>✅</td>
      <td><code>.foregroundColor</code></td>
    </tr>
    <tr>
      <td>✅</td>
      <td><code>.foregroundStyle</code></td>
    </tr>
    <tr>
      <td>🟢</td>
      <td>
          <details>
              <summary><code>.frame</code> (<a href="https://skip.tools/docs/components/frame/">example</a>)</summary>
              <ul>
                  <li>See <a href="#layout">Layout</a></li>
              </ul>
          </details>      
       </td>
    </tr>
    <tr>
      <td>🟢</td>
      <td>
          <details>
              <summary><code>.fullScreenCover</code></summary>
              <ul>
                  <li><code>func fullScreenCover(isPresented: Binding&lt;Bool>, onDismiss: (() -> Void)? = nil, @ViewBuilder content: @escaping () -> any View) -> some View</code></li>
                  <li>See <a href="#modals">Modals</a></li>
              </ul>
          </details>      
       </td>
    </tr>
    <tr>
      <td>🟢</td>
      <td>
          <details>
              <summary><code>.gesture</code> (<a href="https://skip.tools/docs/components/gesture/">example</a>)</summary>
              <ul>
                  <li>See <a href="#gestures">Gestures</a></li>
              </ul>
          </details>      
       </td>
    </tr>
    <tr>
      <td>✅</td>
      <td><code>.gradient</code> (<a href="https://skip.tools/docs/components/gradient/">example</a>)</td>
    </tr>
    <tr>
      <td>✅</td>
      <td><code>.grayscale</code></td>
    </tr>
    <tr>
      <td>✅</td>
      <td><code>.hidden</code></td>
    </tr>
    <tr>
      <td>🟢</td>
      <td>
          <details>
              <summary><code>.ignoresSafeArea</code></summary>
              <ul>
                  <li>See <a href="#safe-area">Safe Area</a></li>
              </ul>
          </details>      
       </td>
    </tr>
    <tr>
      <td>✅</td>
      <td><code>.inset</code></td>
    </tr>
    <tr>
      <td>✅</td>
      <td>
          <details>
              <summary><code>.interactiveDismissDisabled</code></summary>
              <ul>
                  <li>See <a href="#modals">Modals</a></li>
              </ul>
          </details>      
       </td>
    </tr>
    <tr>
      <td>✅</td>
      <td><code>.italic</code></td>
    </tr>
    <tr>
      <td>✅</td>
      <td><code>.keyboardType</code> (<a href="https://skip.tools/docs/components/keyboard/">example</a>)</td>
    </tr>
    <tr>
      <td>✅</td>
      <td><code>.labelsHidden</code></td>
    </tr>
    <tr>
      <td>✅</td>
      <td>
          <details>
              <summary><code>.labelStyle</code></summary>
              <ul>
                  <li><code>.automatic</code></li>
                  <li><code>.titleOnly</code></li>
                  <li><code>.iconOnly</code></li>
                  <li><code>.titleAndIcon</code></li>
                  <li>Custom styles are not supported</li>
              </ul>
          </details>
       </td>
    </tr>
    <tr>
      <td>🟢</td>
      <td>
          <details>
              <summary><code>.lineLimit</code></summary>
              <ul>
                  <li>func lineLimit(_ number: Int?) -> some View</li>
                  <li>func lineLimit(_ number: Int, reservesSpace: Bool) -> some View</li>
              </ul>
          </details>      
       </td>
    </tr>
    <tr>
      <td>✅</td>
      <td><code>.linespacing</code></td>
    </tr>
    <tr>
      <td>✅</td>
      <td><code>.listItemTint</code></td>
    </tr>
    <tr>
      <td>✅</td>
      <td><code>.listRowBackground</code></td>
    </tr>
    <tr>
      <td>✅</td>
      <td><code>.listRowSeparator</code></td>
    </tr>
    <tr>
      <td>✅</td>
      <td><code>.listStyle</code></td>
    </tr>
    <tr>
      <td>✅</td>
      <td><code>.mask</code></td>
    </tr>
    <tr>
      <td>✅</td>
      <td><code>.minimumScaleFactor</code></td>
    </tr>
    <tr>
      <td>✅</td>
      <td><code>.modifier</code> (<a href="https://skip.tools/docs/components/modifier/">example</a>)</td>
    </tr>
    <tr>
      <td>✅</td>
      <td><code>.monospaced</code></td>
    </tr>
    <tr>
      <td>✅</td>
      <td><code>.moveDisabled</code></td>
    </tr>
    <tr>
      <td>✅</td>
      <td><code>.multilineTextAlignment</code></td>
    </tr>
    <tr>
      <td>✅</td>
      <td><code>.navigationBarBackButtonHidden</code></td>
    </tr>
    <tr>
      <td>✅</td>
      <td><code>.navigationBarTitleDisplayMode</code></td>
    </tr>
    <tr>
      <td>✅</td>
      <td><code>.navigationDestination</code></td>
    </tr>
    <tr>
      <td>🟢</td>
      <td>
          <details>
              <summary><code>.navigationTitle</code></summary>
              <ul>
                  <li><code>func navigationTitle(_ title: String) -> some View</code></li>
                  <li><code>func navigationTitle(_ title: Text) -> some View</code></li>
              </ul>
          </details>      
       </td>
    </tr>
    <tr>
      <td>✅</td>
      <td><code>.offset</code> (<a href="https://skip.tools/docs/components/offset/">example</a>)</td>
    </tr>
    <tr>
      <td>✅</td>
      <td><code>.onAppear</code></td>
    </tr>
    <tr>
      <td>✅</td>
      <td><code>.onChange</code></td>
    </tr>
    <tr>
      <td>✅</td>
      <td><code>.onDelete</code></td>
    </tr>
    <tr>
      <td>✅</td>
      <td><code>.onDisappear</code></td>
    </tr>
    <tr>
      <td>🟢</td>
      <td>
          <details>
              <summary><code>.onLongPressGesture</code> (<a href="https://skip.tools/docs/components/gesture/">example</a>)</summary>
              <ul>
                  <li>See <a href="#gestures">Gestures</a></li>
              </ul>
          </details>      
       </td>
    </tr>
    <tr>
      <td>✅</td>
      <td><code>.onMove</code></td>
    </tr>
    <tr>
      <td>✅</td>
      <td><code>.onOpenURL</code></td>
    </tr>
    <tr>
      <td>✅</td>
      <td><code>.onPreferenceChange</code></td>
    </tr>
    <tr>
      <td>✅</td>
      <td><code>.onReceive</code></td>
    </tr>
    <tr>
      <td>✅</td>
      <td><code>.onSubmit</code></td>
    </tr>
    <tr>
      <td>🟢</td>
      <td>
          <details>
              <summary><code>.onTapGesture</code></summary>
              <ul>
                  <li>See <a href="#gestures">Gestures</a></li>
              </ul>
          </details>      
       </td>
    </tr>
    <tr>
      <td>✅</td>
      <td><code>.opacity</code></td>
    </tr>
    <tr>
      <td>✅</td>
      <td><code>.overlay</code> (<a href="https://skip.tools/docs/components/overlay/">example</a>)</td>
    </tr>
    <tr>
      <td>✅</td>
      <td><code>.padding</code></td>
    </tr>
    <tr>
      <td>🟡</td>
      <td>
          <details>
              <summary><code>.pickerStyle</code></summary>
              <ul>
                  <li><code>.automatic</code></li>
                  <li><code>.navigationLink</code></li>
                  <li><code>.menu</code></li>
                  <li><code>.segmented</code></li>
                  <li>Custom styles are not supported</li>
              </ul>
          </details>      
       </td>
    </tr>
    <tr>
      <td>✅</td>
      <td><code>.position</code></td>
    </tr>
    <tr>
      <td>✅</td>
      <td><code>.preference</code></td>
    </tr>
   <tr>
      <td>✅</td>
      <td>
            <details>
              <summary><code>.preferredColorScheme</code></summary>
              <ul>
                  <li>See also <a href="#colorscheme">ColorScheme</a></li>
              </ul>
          </details> 
      </td>
    </tr>
    <tr>
      <td>🟢</td>
      <td>
          <details>
              <summary><code>.progressViewStyle</code></summary>
              <ul>
                  <li><code>.automatic</code></li>
                  <li><code>.linear</code></li>
                  <li><code>.circular</code></li>
                  <li>Custom styles are not supported</li>
              </ul>
          </details>      
       </td>
    </tr>
    <tr>
      <td>🟡</td>
      <td>
          <details>
              <summary><code>.redacted</code></summary>
              <ul>
                  <li>Only <code>RedactionReasons.placeholder</code> is supported</li>
              </ul>
          </details>      
       </td>
    </tr>
    <tr>
      <td>✅</td>
      <td><code>.refreshable</code></td>
    </tr>
    <tr>
      <td>🟠</td>
      <td>
          <details>
              <summary><code>.resizable</code></summary>
              <ul>
                  <li><code>func resizable() -> Image</code></li>
              </ul>
          </details>      
       </td>
    </tr>
    <tr>
      <td>🟢</td>
      <td>
          <details>
              <summary><code>.rotation</code></summary>
              <ul>
                  <li><code>func rotation(_ angle: Angle) -> any Shape</code></li>
              </ul>
          </details>      
       </td>
    </tr>
    <tr>
      <td>🟢</td>
       <td>
          <details>
              <summary><code>.rotationEffect</code></summary>
              <ul>
                  <li><code>func rotationEffect(_ angle: Angle) -> some View</code></li>
              </ul>
          </details>      
       </td>
    </tr>
    <tr>
      <td>🟢</td>
       <td>
          <details>
              <summary><code>.rotation3DEffect</code></summary>
              <ul>
                  <li><code>func rotation3DEffect(_ angle: Angle, axis: (x: CGFloat, y: CGFloat, z: CGFloat), perspective: CGFloat = 1.0) -> some View</code></li>
              </ul>
          </details>      
       </td>
    </tr>
    <tr>
      <td>🟢</td>
      <td>
          <details>
              <summary><code>.scale</code></summary>
              <ul>
                  <li><code>func scale(_ scale: CGFloat) -> any Shape</code></li>
                  <li><code>func scale(x: CGFloat = 1.0, y: CGFloat = 1.0) -> any Shape</code></li>
              </ul>
          </details>      
       </td>
    </tr>
    <tr>
      <td>🟡</td>
      <td>
          <details>
              <summary><code>.scaledToFill</code></summary>
              <ul>
                  <li>Only supported for images</li>
              </ul>
          </details>      
       </td>
    </tr>
    <tr>
      <td>🟡</td>
      <td>
          <details>
              <summary><code>.scaledToFit</code></summary>
              <ul>
                  <li>Only supported for images</li>
              </ul>
          </details>      
       </td>
    </tr>
    <tr>
      <td>🟡</td>
      <td>
          <details>
              <summary><code>.scaleEffect</code></summary>
              <ul>
                  <li><code>func scaleEffect(_ scale: CGSize) -> some View</code></li>
                  <li><code>func scaleEffect(_ s: CGFloat) -> some View</code></li>
                  <li><code>func scaleEffect(x: CGFloat = 1.0, y: CGFloat = 1.0) -> some View</code></li>
              </ul>
          </details>      
       </td>
    </tr>
    <tr>
      <td>✅</td>
      <td><code>.scrollContentBackground</code></td>
    </tr>
    <tr>
      <td>🟢</td>
      <td>
          <details>
              <summary><code>.scrollDismissesKeyboard</code></summary>
              <ul>
		    <li>In Compose, the default behavior (<code>.automatic</code>) is to never dismiss on scroll</li>
                  <li><code>.interactively</code> behaves like <code>.immediately</code></li>
              </ul>
          </details>      
       </td>
    </tr>	  
    <tr>
      <td>🟠</td>
      <td>
          <details>
              <summary><code>.scrollTargetBehavior</code></summary>
              <ul>
                <li>Only <code>.viewAligned</code> is supported</li>
                <li>See <a href="#scrolling">Scrolling</a></li>
              </ul>
          </details>      
       </td>
    </tr>
    <tr>
      <td>🟠</td>
      <td>
          <details>
              <summary><code>.scrollTargetLayout</code></summary>
              <ul>
                <li>See <a href="#scrolling">Scrolling</a></li>
              </ul>
          </details>      
       </td>
    </tr>
    <tr>
      <td>🟡</td>
      <td>
          <details>
              <summary><code>.searchable</code> (<a href="https://skip.tools/docs/components/searchable/">example</a>)</summary>
              <ul>
                <li><code>func searchable(text: Binding&lt;String>, prompt: Text? = nil) -> some View</code></li>
                <li><code>func searchable(text: Binding&lt;String>, prompt: String) -> some View</code></li>
              </ul>
          </details>      
       </td>
    </tr>
    <tr>
      <td>🟢</td>
      <td>
          <details>
              <summary><code>.shadow</code> (<a href="https://skip.tools/docs/components/shadow/">example</a>)</summary>
              <ul>
                  <li>Place this modifier before <code>.background</code>, <code>.overlay</code> modifiers</li>
              </ul>
          </details>      
       </td>
    </tr>
    <tr>
      <td>🟢</td>
      <td>
          <details>
              <summary><code>.sheet</code> (<a href="https://skip.tools/docs/components/sheet/">example</a>)</summary>
              <ul>
                  <li><code>func sheet(isPresented: Binding&lt;Bool>, onDismiss: (() -> Void)? = nil, @ViewBuilder content: @escaping () -> any View) -> some View</code></li>
                  <li>See <a href="#modals">Modals</a></li>
              </ul>
          </details>      
       </td>
    </tr>
    <tr>
      <td>🟢</td>
      <td>
          <details>
              <summary><code>.strikethrough</code></summary>
              <ul>
                  <li><code>pattern</code> and <code>color</code> are ignored</li>
              </ul>
          </details>      
       </td>
    </tr>
    <tr>
      <td>✅</td>
      <td><code>.stroke</code></td>
    </tr>
    <tr>
      <td>✅</td>
      <td><code>.strokeBorder</code></td>
    </tr>
    <tr>
      <td>✅</td>
      <td><code>.submitLabel</code></td>
    </tr>
    <tr>
      <td>✅</td>
      <td>
          <details>
              <summary><code>.tabItem</code></summary>
              <ul>
                  <li>See <a href="#navigation">Navigation</a></li>
              </ul>
          </details> 
      </td>
    </tr>
    <tr>
      <td>✅</td>
      <td>
          <details>
              <summary><code>.tabViewStyle</code></summary>
              <ul>
                  <li><code>.automatic</code></li>
                  <li><code>.page</code></li>
                  <li><code>.tabBarOnly</code></li>
                  <li>Custom styles are not supported</li>
              </ul>
          </details>      
       </td>
    </tr>
    <tr>
      <td>✅</td>
      <td><code>.tag</code></td>
    </tr>
    <tr>
      <td>✅</td>
      <td><code>.task</code></td>
    </tr>
    <tr>
      <td>✅</td>
      <td><code>.textCase</code></td>
    </tr>
    <tr>
      <td>🟢</td>
      <td><code>.textContentType</code></td>
    </tr>
    <tr>
      <td>✅</td>
      <td><code>.textEditorStyle</code></td>
    </tr>
    <tr>
      <td>🟡</td>
      <td>
          <details>
              <summary><code>.textFieldStyle</code></summary>
              <ul>
                  <li><code>.automatic</code></li>
                  <li><code>.roundedBorder</code></li>
              </ul>
          </details>      
       </td>
    </tr>
    <tr>
      <td>✅</td>
      <td><code>.textInputAutocapitalization</code></td>
    </tr>
    <tr>
      <td>✅</td>
      <td><code>.tint</code></td>
    </tr>
    <tr>
      <td>🟢</td>
      <td>
          <details>
              <summary><code>.toolbar</code></summary>
              <ul>
                  <li><code>func toolbar(@ViewBuilder content: () -> any View) -> some View</code></li>
                  <li><code>func toolbar(_ visibility: Visibility, for bars: ToolbarPlacement...) -> some View</code></li>
              </ul>
          </details>      
       </td>
    </tr>
    <tr>
      <td>✅</td>
      <td><code>.toolbarBackground</code></td>
    </tr>
    <tr>
      <td>✅</td>
      <td><code>.toolbarColorScheme</code></td>
    </tr>
    <tr>
      <td>✅</td>
      <td><code>.toolbarTitleDisplayMode</code></td>
    </tr>
    <tr>
      <td>✅</td>
      <td><code>.toolbarTitleMenu</code></td>
    </tr>
    <tr>
      <td>✅</td>
      <td><code>.tracking</code></td>
    </tr>
    <tr>
      <td>🟢</td>
      <td>
            <details>
              <summary><code>.transition</code></summary>
              <ul>
                  <li>See <a href="#animation">Animation</a></li>
              </ul>
          </details> 
      </td>
    </tr>
    <tr>
      <td>🟢</td>
      <td>
          <details>
              <summary><code>.underline</code></summary>
              <ul>
                  <li><code>pattern</code> and <code>color</code> are ignored</li>
              </ul>
          </details>      
       </td>
    </tr>
    <tr>
      <td>✅</td>
      <td><code>.truncationMode</code></td>
    </tr>
    <tr>
      <td>✅</td>
      <td><code>.zIndex</code> (<a href="https://skip.tools/docs/components/zindex/">example</a>)</td>
    </tr>
  </tbody>
</table>


## Supported UIKit

SkipUI does not support UIKit views themselves, but it does support a subset of the UIKit framework, such as the pasteboard and haptic feedback classes, that act as interfaces to the underlying services on Android.

The following table summarizes SkipUI's UIKit support on Android. Anything not listed here is likely not supported. Note that in your iOS-only code - i.e. code within `#if !SKIP` blocks - you can use any UIKit you want.

Support levels:

  - ✅ – Full
  - 🟢 – High
  - 🟡 – Medium 
  - 🟠 – Low

<table>
  <thead><th>Support</th><th>API</th></thead>
  <tbody>
    <tr>
      <td>🟠</td>
      <td>
          <details>
              <summary><code>UIApplication</code></summary>
              <ul>
                  <li><code>static var shared: UIApplication</code></li>
                  <li><code>var applicationState: UIApplication.State</code></li>
                  <li><code>var isIdleTimerDisabled: Bool</code></li>
                  <li><code>func open(_ url: URL, options: [UIApplication.OpenExternalURLOptionsKey : Any] = [:]) async -> Bool</code></li>
              </ul>
          </details>      
       </td>
    </tr>
    <tr>
   <tr>
      <td>✅</td>
      <td><code>#colorLiteral()</code></td>
    </tr>
      <td>🟠</td>
      <td>
          <details>
              <summary><code>UIColor</code></summary>
              <ul>
                  <li><code>init(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat)</code></li>
              </ul>
          </details>      
       </td>
    </tr>
    <tr>
      <td>🟠</td>
      <td>
          <details>
              <summary><code>UIImage</code></summary>
              <ul>
                  <li><code>init?(contentsOfFile: String)</code></li>
                  <li><code>init?(data: Data)</code></li>
                  <li><code>init?(data: Data, scale: CGFloat)</code></li>
              </ul>
          </details>      
       </td>
    </tr>
    <tr>
      <td>✅</td>
      <td><code>UIImpactFeedbackGenerator</code></td>
    </tr>
    <tr>
      <td>✅</td>
      <td><code>UINotificationFeedbackGenerator</code></td>
    </tr>
    <tr>
      <td>🟠</td>
      <td>
          <details>
              <summary><code>UIPasteboard</code></summary>
              <ul>
                  <li><code>static var general: UIPasteboard</code></li>
                  <li><code>static var changedNotification: Notification.Name</code></li>
                  <li><code>var numberOfItems: Int</code></li>
                  <li><code>var hasStrings: Bool</code></li>
                  <li><code>var string: String?</code></li>
                  <li><code>var strings: [String]?</code></li>
                  <li><code>var hasURLs: Bool</code></li>
                  <li><code>var url: URL?</code></li>
                  <li><code>var urls: [URL]?</code></li>
              </ul>
          </details>      
       </td>
    </tr>
    <tr>
      <td>✅</td>
      <td><code>UISelectionFeedbackGenerator</code></td>
    </tr>
  </tbody>
</table>

## Supported UserNotifications

Skip integrates its support for the UserNotifications framework into SkipUI.

**Important:** on Android devices to properly display notification icons in the status bar they must have specific properites. The icon must have a transparent background and a solid shape (usually white). It's recommended to use a specific icon for that and it must be specified in the AndroidManifest.xml with the following code inside the application tag:

```xml
<meta-data
            android:name="com.google.firebase.messaging.default_notification_icon"
            android:resource="@drawable/ic_notification" />
```

SKIP assume that the icon is called `ic_notification` and it's available inside the drawable resources. Otherwise it will fall back to use the app icon (eg. @mipmap/ic_launcher). Note that in this case it will most likely be displayed as solid white dot instead of the usual app icon.

The following table summarizes SkipUI's UserNotifications support on Android. Anything not listed here is likely not supported. Note that in your iOS-only code - i.e. code within `#if !SKIP` blocks - you can use any UserNotifications API you want.

Support levels:

  - ✅ – Full
  - 🟢 – High
  - 🟡 – Medium 
  - 🟠 – Low

<table>
  <thead><th>Support</th><th>API</th></thead>
  <tbody>
    <tr>
      <td>🟡</td>
      <td>
          <details>
              <summary><code>UNAuthorizationOptions</code></summary>
              <ul>
                  <li>Ignored on Android</li>
              </ul>
          </details>      
       </td>
    </tr>
    <tr>
      <td>🟡</td>
      <td>
          <details>
              <summary><code>UNMutableNotificationContent</code></summary>
              <ul>
                  <li>See `UNNotificationContent`</li>
              </ul>
          </details>      
       </td>
    </tr>
    <tr>
      <td>✅</td>
      <td><code>UNNotification</code></td>
    </tr>
    <tr>
      <td>🟡</td>
      <td>
          <details>
              <summary><code>UNNotificationContent</code></summary>
              <ul>
                  <li>Only `title`, `body`, `userInfo`, and `public.image`-type attachments are used</li>
              </ul>
          </details>      
       </td>
    </tr>
    <tr>
      <td>🟡</td>
      <td>
          <details>
              <summary><code>UNNotificationPresentationOptions</code></summary>
              <ul>
                  <li>Only `.banner` and `.alert` are used</li>
              </ul>
          </details>      
       </td>
    </tr>
    <tr>
      <td>✅</td>
      <td><code>UNNotificationRequest</code></td>
    </tr>
    <tr>
      <td>✅</td>
      <td><code>UNNotificationResponse</code></td>
    </tr>
    <tr>
      <td>🟡</td>
      <td>
          <details>
              <summary><code>UNNotificationSound</code></summary>
              <ul>
                  <li>Ignored on Android</li>
              </ul>
          </details>      
       </td>
    </tr>
    <tr>
      <td>🟡</td>
      <td>
          <details>
              <summary><code>UNNotificationTrigger</code></summary>
              <ul>
                  <li>Ignored on Android</li>
              </ul>
          </details>      
       </td>
    </tr>
   <tr>
      <td>🟠</td>
      <td>
          <details>
              <summary><code>UNUserNotificationCenter</code></summary>
              <ul>
                  <li><code>static func current() -> UNUserNotificationCenter</code></li>
                  <li><code>func requestAuthorization(options: UNAuthorizationOptions) async throws -> Bool</code></li>
                  <li><code>var delegate: (any UNUserNotificationCenterDelegate)?</code></li>
                  <li><code>func add(_ request: UNNotificationRequest) async throws</code></li>
                  <li>The `add` function ignores all scheduling and repeat options and simply delivers the notification immediately.</li>
              </ul>
          </details>      
       </td>
    </tr>
    <tr>
      <td>✅</td>
      <td><code>UNUserNotificationCenterDelegate</code></td>
    </tr>
  </tbody>
</table>

## Topics

### Animation

Skip supports SwiftUI's `.animation` and `.transition` modifiers as well as its `withAnimation` function on Android. 

The following properties are currently animatable:

- `.background` color
- `.border` color
- `.fill` color
- `.font` size
- `.foregroundColor`
- `.foregroundStyle` color
- `.frame` width and height
- `.offset`
- `.opacity`
- `.rotationEffect`
- `.scaleEffect`
- `.stroke` color

All of SwiftUI's built-in transitions are supported on Android. To use transitions or to animate views being added or removed in general, however, you **must** assign a unique `.id` value to every view in the parent `HStack`, `VStack`, or `ZStack`:

```swift
VStack {
    FirstView()
        .id(100)
    if condition {
        SecondView()
            .transition(.scale)
            .id(200)
    }
}
.animation(.default)
``` 

Skip converts the various SwiftUI animation types to their Compose equivalents. For many SwiftUI spring animations, though, Skip uses Compose's simple `EaseInOutBack` easing function rather than a true spring. Only constructing a spring with `SwiftUI.Spring(mass:stiffness:damping:)` creates a true Compose spring animation. Using an easing function rather than a true spring allows us to overcome Compose's limitations on springs:

- True spring animations cannot set a duration
- True spring animations cannot have a delay
- True spring animations cannot repeat

Custom `Animatables` and `Transitions` are not supported. Finally, if you nest `withAnimation` blocks, Android will apply the innermost animation to all block actions.

### Colors

#### Accent Color

In addition to programmatically using SwiftUI's `.tint` modifier, iOS allows you to set your application's accent color via the `AccentColor` resource in your app's `Assets` asset catalog. In a Skip app, you can find `Assets` in the `Darwin` folder. 

Skip also supports these mechanisms, but your generated Android app can't access the `Darwin` folder contents. To define an accent color resource for your Android app, create a color set called `AccentColor` in the `Sources/<YourAppModule>/Resources/Module` asset catalog. See the section on Named Colors below for additional details. 

#### Named Colors

Named colors can be bundled in asset catalogs provided in the `Resources` folder of your SwiftPM modules. Your `Package.swift` project should have the module's `.target` include the `Resources` folder for resource processing (which is the default for projects created with `skip init`):

```swift
.target(name: "MyModule", dependencies: ..., resources: [.process("Resources")], plugins: skipstone)
```

Once an asset catalog is added to your `Resources` folder, any named colors can be loaded and displayed using the `Color(_:bundle:)` constructor. For example:

```swift
Color("WarningYellow", bundle: .module)
```

Your named colors must use Xcode's "Floating point (0.0-1.0)" input method. You can convert named colors using other methods by selecting them in Xcode and using the UI picker to update the input method. The values will be preserved.
{: class="callout warning"}

See the [Skip Showcase app](https://github.com/skiptools/skipapp-showcase) `ColorPlayground` for a concrete example of using a named color in an asset catalog, and see that project's Xcode project file ([screenshot](https://assets.skip.tools/screens/SkipUI_Asset_Image.png)) to see the configuration of the `.xcassets` file for the app module.

When an app project is first created with `skip init`, it will contain two separate asset catalogs: a project-level `Assets.xcassets` catalog that contains the app's icons, and an empty module-level `Module.xcassets` catalog. **Add your assets to `Module.xcassets`.** Only the module-level catalog will be transpiled, since the project-level catalog is not processed by the skip transpiler.
Note that you also **must** specify the `bundle` parameter for colors explicitly, since a Skip project uses per-module resources, rather than the default `Bundle.main` bundle that would be assumed of the parameter were omitted.
{: class="callout warning"}

For Android, Skip only uses named colors that you've set for "Universal" devices. You can define the color using RGB values or use any of the "Universal System Color" constants.

### ColorScheme

SkipUI fully supports the `.preferredColorScheme` modifier. If you created your app with the `skip` tool prior to v0.8.26, however, you will have to update the included `Android/app/src/main/kotlin/.../Main.kt` file in order for the modifier to work correctly. Using the latest [`Main.kt`](https://github.com/skiptools/skipapp-hello/blob/main/Android/app/src/main/kotlin/hello/skip/Main.kt) as your template, please do the following:

1. Replace the all of the import statements with ones from latest `Main.kt`
1. Replace the contents of the `setContent { ... }` block with the content from the latest `Main.kt`
1. Replace the `MaterialThemeRootView()` function with the `PresentationRootView(context:)` function from the latest `Main.kt`

With these updates in place, you should be able to use `.preferredColorScheme` successfully.

### Custom Fonts

Custom fonts can be embedded and referenced using `Font.custom`. Fonts are loaded differently depending on the platform. On iOS the custom font name is the full Postscript name of the font, and on Android the name is the font's file name without the extension.

Android requires that font file names contain only alphanumeric characters and underscores, so you should manually name your embedded font to the lowercased and underscore-separated form of the Postscript name of the font. SkipUI's `Font.custom` call will accommodate this by translating your custom font name like "Protest Guerrilla" into an Android-compatible name like "protest_guerrilla.ttf". 

```swift
Text("Custom Font")
    .font(Font.custom("Protest Guerrilla", size: 30.0)) // protest_guerrilla.ttf
```

Custom fonts are embedded differently for each platform. On Android you should create a folder `Android/app/src/main/res/font/` and add the font file, which will cause Android to automatically embed any fonts in that folder as resources. 

For iOS, you must add the font by adding to the Xcode project's app target and ensure the font file is included in the file list in the app target's "Build Phases" tab's "Copy Bundle Resources" phase. In addition, iOS needs to have the font explicitly listed in the Xcode project target's "Info" tab under "Custom Application Target Properties" by adding a new key for the "Fonts provided by application" (whose raw name is "UIAppFonts") and adding each font's file name to the string array.

See the [Skip Showcase app](https://github.com/skiptools/skipapp-showcase) `TextPlayground` for a concrete example of using a custom font, and see that project's Xcode project file ([screenshot](https://assets.skip.tools/screens/SkipUI_Custom_Font.png)) to see how the font is included on both the iOS and Android sides of the app.

### Environment Keys

SwiftUI has many built-in environment keys. These keys are defined in `EnvironmentValues` and typically accessed with the `@Environment` property wrapper. In additional to supporting your custom environment keys, SkipUI exposes the following built-in environment keys:

- `autocorrectionDisabled` (read-only)
- `backgroundStyle`
- `dismiss`
- `font`
- `horizontalSizeClass`
- `isEnabled`
- `isSearching` (read-only)
- `layoutDirection`
- `lineLimit`
- `locale`
- `openURL`
- `refresh`
- `scenePhase`
- `scrollDismissesKeyboardMode`
- `timeZone`
- `truncationMode`
- `verticalSizeClass`

### ForEach

The SwiftUI `ForEach` view allows you to generate views for a range or collection of content. SkipUI support any `Int` range or any `RandomAccessCollection`. If the collection elements do not implement the `Identifiable` protocol, specify the key path to a property that can be used to uniquely identify each element. These `id` values must follow our [Restrictions on Identifiers](#restrictions-on-identifiers).

```swift
ForEach([person1, person2, person3], id: \.fullName) { person in
    HStack {
        Text(person.fullName)
        Spacer()
        Text(person.age)
    } 
}
```

**Important**: When the body of your `ForEach` contains multiple top-level views (e.g. a full row of a `VGrid`), or any single view that expands to additional views (like a `Section` or a nested `ForEach`), SkipUI must "unroll" the loop in order to supply all its views individually to Compose. This means that the `ForEach` will be entirely iterated up front, though the views it produces won't yet be rendered.

### Gestures

SkipUI currently supports tap, long press, drag, magnify, and rotate gestures. You can use either the general `.gesture` modifier or the specialized modifiers like `.onTapGesture` to add gesture support to your views. The following limitations apply:

- `@GestureState` is only supported in Skip Fuse. Use the `Gesture.onEnded` modifier to reset your state.
- Tap counts > 2 are not supported.
- Gesture velocity and predicted end location are always reported as zero and the current location, respectively.
- Only the `onChanged` and `onEnded` gesture modifiers are supported.
- Customization of minimum touch duration, distance, etc. is generally not supported.
- When applying gestures to an offset view, place any gesture modifiers **before** the `.offset` modifier.

There is one exception to the last limitation: you **can** create a `DragGesture(minimumDistance: 0)` in order to detect touch down events immediately.

#### Shapes and Paths

SwiftUI automatically applies a mask to shapes and paths so that touches outside the shape do not trigger its gestures. SkipUI emulates this feature, but it is **not** supported on custom shapes and paths that have a `.stroke` applied. These shapes will register touches anywhere in their bounds. Consider using `.strokeBorder` instead of `.stroke` when a gesture mask is needed on a custom shape.

### Grids

SkipUI renders SwiftUI grid views using native Compose grids. This provides maximum performance and a native feel on Android. The different capabilities of SwiftUI and Compose grids, however, imposes restrictions on SwiftUI grid support in Android:

- Pinned headers and footers are not supported.
- When you place a `LazyHGrid` or `LazyVGrid` in a `ScrollView`, it must be the only child of that view.
- When you define your grid with an array of `GridItem` specs, your Android grid is **based on the first `GridItem`**. Compose does not support different specs for different rows or columns, so SkipUI applies the first spec to all of them.
- Maximum `GridItem` sizes are ignored.
- Also see the `ForEach` [topic](#foreach).

### Haptics

SkipUI supports UIKit's `UIFeedbackGenerator` API for generating haptic feedback on the device, typically as a result of user interaction. Some examples are as follows:

```swift
// impact haptic feedback
UIImpactFeedbackGenerator(style: .light).impactOccurred()
UIImpactFeedbackGenerator(style: .medium).impactOccurred()
UIImpactFeedbackGenerator(style: .heavy).impactOccurred()

UIImpactFeedbackGenerator().impactOccurred(intensity: 0.5)

// notification haptic feedback
UINotificationFeedbackGenerator().notificationOccurred(.success)
UINotificationFeedbackGenerator().notificationOccurred(.warning)
UINotificationFeedbackGenerator().notificationOccurred(.error)

// selection haptic feedback
UISelectionFeedbackGenerator().selectionChanged()
```

Android requires adding a permission in order to be able to utilize the device's haptic feedback service (`android.content.Context.VIBRATOR_MANAGER_SERVICE`) by adding to the `Android/app/src/main/AndroidMetadata.xml` file's manifest section: `<uses-permission android:name="android.permission.VIBRATE"/>`
{: class="callout warning"}


### Images

#### Network Images

SkipUI supports loading images from network URLs using SwiftUI's `AsyncImage`. Our implementation uses the [Coil](https://coil-kt.github.io/coil/) library to download images on Android. This includes support for a loading indicator, such as:

```swift
AsyncImage(url: URL(string: "https://picsum.photos/id/237/200/300")) { image in
    image.resizable()
} placeholder: {
    ProgressView()
}
```

#### Image Assets

Images can be bundled in asset catalogs provided in the `Resources` folder of your SwiftPM modules. Your `Package.swift` project should have the module's `.target` include the `Resources` folder for resource processing (which is the default for projects created with `skip init`):

```swift
.target(name: "MyModule", dependencies: ..., resources: [.process("Resources")], plugins: skipstone)
```

Once an asset catalog is added to your `Resources` folder, any bundled images can be loaded and displayed using the `Image(name:bundle:)` constructor. For example:

```swift
Image("Cat", bundle: .module, label: Text("Cat JPEG image"))
```

When an app project is first created with `skip init`, it will contain two separate asset catalogs: a project-level `Assets.xcassets` catalog that contains the app's icons, and an empty module-level `Module.xcassets` catalog. **Add your assets to `Module.xcassets`.** Only the module-level catalog will be transpiled, since the project-level catalog is not processed by the skip transpiler.
{: class="callout warning"}

See the [Skip Showcase app](https://github.com/skiptools/skipapp-showcase) `ImagePlayground` for a concrete example of using a bundled image in an asset catalog, and see that project's Xcode project file ([screenshot](https://assets.skip.tools/screens/SkipUI_Asset_Image.png)) to see the configuration of the `.xcassets` file for the app module.

Note that you **must** specify the `bundle` parameter for images explicitly, since a Skip project uses per-module resources, rather than the default `Bundle.main` bundle that would be assumed of the parameter were omitted.
{: class="callout info"}

In addition to raster image formats like .png and .jpg, vector images in the .svg and .pdf formats are also supported in asset catalogs. This can be useful for providing images that can scale up or down with losing quality, and are commonly used for icons. Supported .svg sources are discussed in the [System Symbols](#system-symbols) documentation below. PDF images must have the "Preserve Vector Data" flag set in the asset in Xcode ([screenshot](https://assets.skip.tools/screens/SkipUI_PDF_Image.png)) in order to support tinting with the `.foregroundStyle(color)` modifier. Otherwise, the colors set in the PDF itself will always be used when displaying the image.

```swift
Image("baseball-icon", bundle: .module, label: Text("Baseball Icon"))
    .resizable()
    .aspectRatio(contentMode: .fit)
    .foregroundStyle(Color.cyan)
    .frame(width: 30, height: 30)
```

Skip currently supports Light and Dark variants of images in an asset catalog, and will display the appropriate image depending on the active color scheme. Other image asset variants like size classes are currently unsupported.
{: class="callout warning"}


#### Bundled Images

In addition to using asset catalogs, images may be included in the `Resources` folder and referenced directly using `AsyncImage` to display local image resources. This works on both iOS and through Skip on Android. So if you have an image `Sources/MyModule/Resources/sample.jpg` then the following SwiftUI will display the image on both platforms:

```swift
AsyncImage(url: Bundle.module.url(forResource: "sample", withExtension: "jpg"))
```

#### System Symbols

The `Image(systemName:)` constructor is used to display a standard system symbol name that is provided on Darwin platforms. There is no built-in equivalent to these symbols on Android, but you can add same-named vector symbols manually, so that code like `Image(systemName: "folder.fill")` will use the built-in "folder.fill" symbol on iOS, but will use your included `folder.fill.svg` vector asset on Android. 

1. If it doesn't already exist, create a `Module.xcassets` asset catalog in your top-level app module's `Resources` folder.
1. Download the desired symbol from the [Google Material Icons](https://fonts.google.com/icons) catalog. Make sure to download in the iOS SVG format (see the [documentation](https://developers.google.com/fonts/docs/material_icons#icons_for_ios)). You can also export symbols from the [SF Symbols app](https://developer.apple.com/sf-symbols/). 
1. Give the downloaded symbol file the same name as the iOS symbol you want it to represent on Android. Keep the `.svg` file extension.
1. Drag the file to your `Module.xcassets` asset catalog.

When exporting from the SF Symbols app, selecting "Export for: Xcode 12" may result in sharper rendering on Android.  
{: class="callout info"}

See the [Skip Showcase app](https://github.com/skiptools/skipapp-showcase) `ImagePlayground` for a concrete example of using a system symbol with an exported symbol image, and see that project's Xcode project file ([screenshot](https://assets.skip.tools/screens/SkipUI_Custom_Symbol.png)) to see how the symbol is included in the `.xcassets` file for the app module.

SkipUI currently supports using the view's `foregroundStyle` and `fontWeight` to customize the color and weight of the symbol, but other symbol modifiers such as `symbolVariant` and `symbolRenderingMode` are currently unsupported. 
{: class="callout warning"}

Downloaded symbols can be used directly, or they can be edited using an SVG editor to provide custom vector symbols for you app, as described at [Creating custom symbol images for your app](https://developer.apple.com/documentation/uikit/uiimage/creating_custom_symbol_images_for_your_app). You use `Image(systemName:)` to load a system symbol image and `Image(_:bundle)` to load your custom symbol, as the following code shows:

```swift
// Display a system symbol image
Image(systemName: "multiply.circle.fill")

// Display a custom symbol image that is included in the module's asset catalog
Image("custom.multiply.circle", bundle: .module)
```

This is discussed further in the documentation for [Loading a symbol image](https://developer.apple.com/documentation/uikit/uiimage/configuring_and_displaying_symbol_images_in_your_ui#3234560).

#### Fallback Symbols

If a matching system symbol with the same name is not found in any of the asset catalog files for the top-level app module, SkipUI will fallback to a small subset of pre-defined symbol names that map to the equivalent Compose material symbols (as seen at [https://developer.android.com/reference/kotlin/androidx/compose/material/icons/Icons](https://developer.android.com/reference/kotlin/androidx/compose/material/icons/Icons)). The fallback symbols will not match the iOS equivalents exactly, but will provide a rough approximation of the symbol's shape and meaning.


| iOS | Android |
|---|-------|
| arrow.clockwise.circle | Icons.Outlined.Refresh |
| arrow.forward | Icons.Outlined.ArrowForward |
| arrow.forward.square | Icons.Outlined.ExitToApp |
| arrow.left | Icons.Outlined.ArrowBack |
| arrowtriangle.down.fill | Icons.Outlined.ArrowDropDown |
| bell | Icons.Outlined.Notifications |
| bell.fill | Icons.Filled.Notifications |
| calendar | Icons.Outlined.DateRange |
| cart | Icons.Outlined.ShoppingCart |
| cart.fill | Icons.Filled.ShoppingCart |
| checkmark | Icons.Outlined.Check |
| checkmark.circle | Icons.Outlined.CheckCircle |
| checkmark.circle.fill | Icons.Filled.CheckCircle |
| chevron.down | Icons.Outlined.KeyboardArrowDown |
| chevron.left | Icons.Outlined.KeyboardArrowLeft |
| chevron.right | Icons.Outlined.KeyboardArrowRight |
| chevron.up | Icons.Outlined.KeyboardArrowUp |
| ellipsis | Icons.Outlined.MoreVert |
| envelope | Icons.Outlined.Email |
| envelope.fill | Icons.Filled.Email |
| exclamationmark.triangle | Icons.Outlined.Warning |
| exclamationmark.triangle.fill | Icons.Filled.Warning |
| face.smiling | Icons.Outlined.Face |
| gearshape | Icons.Outlined.Settings |
| gearshape.fill | Icons.Filled.Settings |
| hand.thumbsup | Icons.Outlined.ThumbUp |
| hand.thumbsup.fill | Icons.Filled.ThumbUp |
| heart | Icons.Outlined.FavoriteBorder |
| heart.fill | Icons.Outlined.Favorite |
| house | Icons.Outlined.Home |
| house.fill | Icons.Filled.Home |
| info.circle | Icons.Outlined.Info |
| info.circle.fill | Icons.Filled.Info |
| line.3.horizontal | Icons.Outlined.Menu |
| list.bullet | Icons.Outlined.List |
| location | Icons.Outlined.LocationOn |
| location.fill | Icons.Filled.LocationOn |
| lock | Icons.Outlined.Lock |
| lock.fill | Icons.Filled.Lock |
| magnifyingglass | Icons.Outlined.Search |
| mappin.circle | Icons.Outlined.Place |
| mappin.circle.fill | Icons.Filled.Place |
| paperplane | Icons.Outlined.Send |
| paperplane.fill | Icons.Filled.Send |
| pencil | Icons.Outlined.Create |
| person | Icons.Outlined.Person |
| person.crop.circle | Icons.Outlined.AccountCircle |
| person.crop.circle.fill | Icons.Filled.AccountCircle |
| person.crop.square | Icons.Outlined.AccountBox |
| person.crop.square.fill | Icons.Filled.AccountBox |
| person.fill | Icons.Filled.Person |
| phone | Icons.Outlined.Call |
| phone.fill | Icons.Filled.Call |
| play | Icons.Outlined.PlayArrow |
| play.fill | Icons.Filled.PlayArrow |
| plus | Icons.Outlined.Add |
| plus.circle.fill | Icons.Outlined.AddCircle |
| square.and.arrow.up | Icons.Outlined.Share |
| square.and.arrow.up.fill | Icons.Filled.Share |
| star.fill | Icons.Filled.Star |
| trash | Icons.Outlined.Delete |
| trash.fill | Icons.Filled.Delete |
| wrench | Icons.Outlined.Build |
| wrench.fill | Icons.Filled.Build |
| xmark | Icons.Outlined.Clear |

In Android-only code, you can also supply any `androidx.compose.material.icons.Icons` image name as the `systemName`. For example:

```swift
#if SKIP
Image(systemName: "Icons.Filled.Settings")
#endif
```

### Layout

SkipUI fully supports SwiftUI's various layout mechanisms, including `HStack`, `VStack`, `ZStack`, and the `.frame` modifier. If you discover layout edge cases where the result on Android does not match the result on iOS, please file an Issue. The following is a list of known cases where results may not match:

- Skip never places content in an implicit `VStack`, like SwiftUI sometimes does. Always place multiple views in an explicit stack of the desired type.
- Expanding elements such as `Spacer` or `.frame(maxWidth: .infinity)` within nested `HStacks` or `VStacks` may measure differently. Try un-nesting stacks to get more SwiftUI-like layout.

Note: if your app was developed under an earlier version of Skip and it relies on nuances of older layout behavior, you can apply the Android-only `.layoutImplementationVersion()` modifier. Set this modifier on a `View` hierarchy to simulate the previous behavior:

```swift
SomeRootView()
    #if os(Android)
    .layoutImplementationVersion(0)
    #endif
```

### Lists

SwiftUI `Lists` are powerful and flexible components. SkipUI currently supports the following patterns for specifying `List` content.

Static content. Embed a child view for each row directly within the `List`:

```swift
List {
    Text("Row 1")
    Text("Row 2")
    Text("Row 3")
}
```

Indexed content. Specify an `Int` range and a closure to create a row for each index:

```swift
List(1...100) { index in 
    Text("Row \(index)")
}
```

Collection content. Supply any `RandomAccessCollection` - typically an `Array` - and a closure to create a row for each element. If the elements do not implement the `Identifiable` protocol, specify the key path to a property that can be used to uniquely identify each element:

```swift
List([person1, person2, person3], id: \.fullName) { person in
    HStack {
        Text(person.fullName)
        Spacer()
        Text(person.age)
    } 
}
```

`ForEach` content. Use `ForEach` to specify indexed or collection content. This allows you to mix content types.

```swift
List {
    Text("People").bold()
    ForEach([person1, person2, person3], id: \.fullName) { person in
        HStack {
            Text(person.fullName)
            Spacer()
            Text(person.age)
        }
    }
}
```

When using collection content or a `ForEach` with collection content, you can enable swipe-to-delete and drag-to-reorder by supplying a binding to the collection and the appropriate set of edit actions.

```swift
List($people, id: \.fullName, editActions: .all) { $person in
    Text(person.fullName)
        .deleteDisabled(!person.isDeletable)
    }
}
```

You can also enable editing by using a `ForEach` with the `.onDelete` and `.onMove` modifiers. Make sure your `ForEach` also supplies an `id` for each item.

#### List Limitations

- Compose requires that every `id` value in a `List` is unique. This applies even if your list consists of multiple `Sections` or uses multiple `ForEach` components to define its content.
- Additionally, `id` values must follow our [Restrictions on Identifiers](#restrictions-on-identifiers).
- Nesting of `ForEach` and `Section` views is limited.
- See also the `ForEach` view [topic](#foreach).

### Navigation

SwiftUI has three primary forms of navigation: `TabView`, `NavigationStack`, and modal presentations. SkipUI has implemented all three, albeit with the restrictions explained below.

SkipUI's `TabView` does yet not support SwiftUI's overflow tab behavior. Adding too many tabs will just result in too many tabs rather than SwiftUI's automatic "More" tab. Similarly, `TabSections` and other features meant for top or sidebar tab placements are ignored. Otherwise, `TabView` acts as you would expect.

In SwiftUI, you push views onto a `NavigationStack` with `NavigationLink`. `NavigationLink` has two ways to specify its destination view: embedding the view directly, or specifying a value that is mapped to a view through the `.navigationDestination` modifier, as in the following code sample:

```swift
NavigationStack {
    ListView()
        .navigationTitle(Self.title)
}

struct ListView : View {
    var body: some View {
        List(City.allCases) { city in
            NavigationLink(value: city) {
                rowView(city: city)
            }
        }
        .navigationDestination(for: City.self) { city in
            CityView(city: city)
        }
    }
}
```

There is another form of `.navigationDestination` that takes a binding and a destination:

```swift
func navigationDestination(isPresented: Binding<Bool>, @ViewBuilder destination: () -> any View) -> some View
```

SkipUI supports all of these models. When using `.navigationDestination(isPresented:destination:)`, note that manually setting `isPresented` to `false` will **not** dismiss your view. Prefer standard dismissing mechanisms. Using `.navigationDestination(for:destination:)` to bind data types to destinations also requires some care. It is currently the case that if a pushed view defines a new `.navigationDestination` for key type `T`, it will overwrite any previous stack view's `T` destination mapping. **Take care not to unintentionally re-map the same key type in the same navigation stack.**

Compose imposes an additional restriction as well: we must be able to stringify `.navigationDestination` data key types. See [Restrictions on Identifiers](#restrictions-on-identifiers) below.

#### Modals

Skip supports standard modal presentations. Android apps typically allow users to dismiss modals with the Android back button. Skip allows you to selectively disable this behavior with the Android-only `backDismissDisabled(_ isDisabled: Bool = true)` SwiftUI modifier. If you use this modifier, you **must** put it on the top-level view embedded in your `.sheet` or `.fullScreenCover`, as in the following example:

```swift
SomeContentView()
    .sheet(isPresented: $isSheetPresented) {
        SheetContentView()
            #if os(Android)
            .backDismissDisabled()
            #endif
    }
```

Due to Compose limitations, changing the value passed to `.backDismissDisabled(_: Bool = true)` while the modal is presented has no effect. Only the value at the time of presentation is considered.
{: class="callout warning"}

Note that you might want to pair `backDismissDisabled` with SwiftUI's `.interactiveDismissDisabled` modifier to also disable dismissing via dragging the sheet down.

### Restrictions on Identifiers

Compose requires all state values to be serializable. This restriction is typically transparent to your code, because when you use property wrappers like `@State`, SkipUI automatically tracks your state objects and gives Compose serializable identifiers in their place. Some SwiftUI values, however, must be stored directly in Compose, including `navigationDestination` values and `List` item identifiers. When this is the case, SkipUI creates a `String` from the value you supply using the following algorithm:

- If the value is `Identifiable`, use `String(describing: value.id)`
- If the value is `RawRepresentable`, use `String(describing: value.rawValue)`
- Else use `String(describing: value)`

Please ensure that when using these API, the above algorithm will create unique, stable strings for unique values.

### Safe Area

Like the iPhone, Android devices can render content behind system bars like the top status bar and bottom gesture area. SwiftUI code using the `.ignoresSafeArea` modifier to extend content behind system bars will work the same across SwiftUI and SkipUI, with two exceptions: 

- SkipUI ignores the `SafeAreaRegions.keyboard` region. SkipUI does not represent the onscreen keyboard as a safe area. Rather, it follows the typical Android practice of shrinking the content area to fit above the keyboard.
- The `.background(_ style: any ShapeStyle, ignoresSafeAreaEdges edges: Edge.Set = .all)` modifier currently defaults the second argument to `[]` rather than `.all`. Specify the desired edges explicitly if you want to ignore the safe area, as in:

```swift
MyView()
    .background(.yellow, ignoresSafeAreaEdges: .all)
``` 

Remember that you can use `#if SKIP` blocks to confine your `.ignoresSafeArea` calls for iOS or Android only.

#### Enabling or Disabling Edge-to-Edge

Modern SkipUI versions enable Jetpack Compose's "edgeToEdge" mode by default. If you created your app with the `skip` tool prior to v0.8.32, however, you will have to update the included `Android/app/src/main/kotlin/.../Main.kt` file to render content behind system bars. Using the latest [`Main.kt`](https://github.com/skiptools/skipapp-hello/blob/main/Android/app/src/main/kotlin/hello/skip/Main.kt) as your template, please do the following:

1. Add the following import: `import androidx.activity.enableEdgeToEdge`
1. Add the following line to the `MainActivity.onCreate(savedInstanceState:)` function:

```swift
override fun onCreate(savedInstanceState: android.os.Bundle?) {
    super.onCreate(savedInstanceState)
    enableEdgeToEdge() // <--- Add this line
    ...
```

With these updates in place, your app should extend below the system bars. If you're running a modern SkipUI version and want to *disable* edge-to-edge mode, simply remove the `enableEdgeToEdge()` call.

### Scrolling

`ScrollView` generally works just as on iOS, but is subject to several limitations on its content. While you must be aware of these limitations, they should not prove too difficult to work with in practice:

- The `UnitRect` parameter to `ScrollView` and `ScrollViewProxy` is ignored.
- `ScrollViewProxy` works only for `List` and lazy containers: `LazyHStack`, `LazyVStack`, `LazyHGrid`, and `LazyVGrid`.
- If you place a lazy container in a `ScrollView`, it must be the **only** content of that `ScrollView`.
- The content of any `ScrollView` with the `.scrollTargetBehavior` modifier applied must be a single lazy container with the `.scrollTargetLayout` modifier applied, as in the following example:

```swift
ScrollView(.horizontal) {
    LazyHStack {
        ...
    }
    .scrollTargetLayout()
}
.scrollTargetBehavior(.viewAligned)
```

### Custom Intents

The implementation for `UIApplication.open(_ url: URL, options: [UIApplication.OpenExternalURLOptionsKey : Any] = [:])` uses the [Android Intents](https://developer.android.com/guide/components/intents-filters#Types) system to launch the service associated with the given URL.

As well as handling the standard link types like "https://", "tel:", and "sms:", Skip also enables specifying a custom intent name as the special `OpenExternalURLOptionsKey` value "intent", so that you can easily launch a particular intent on Android. For example:

```swift
#if os(Android)
Button("Send Email") {
    let mailto = URL(string: "mailto:hello@example.com")!

    var options: [UIApplication.OpenExternalURLOptionsKey : Any] = [:]
    // specify the exact intent to use
    options[UIApplication.OpenExternalURLOptionsKey(rawValue: "intent")] = "android.intent.action.SENDTO"
    // add values for the keys supported by the intent
    // https://developer.android.com/reference/android/content/Intent#EXTRA_SUBJECT
    options[UIApplication.OpenExternalURLOptionsKey(rawValue: "android.intent.extra.SUBJECT")] = "Email Subject Line"
    options[UIApplication.OpenExternalURLOptionsKey(rawValue: "android.intent.extra.TEXT")] = "Email body"

    Task {
        await UIApplication.shared.open(mailto, options: options)
    }
}
#endif
```


## Contributing

We welcome contributions to SkipUI. The Skip product [documentation](https://skip.tools/docs/contributing/) includes helpful instructions and tips on local Skip library development. 

The most pressing need is to implement more core components and view modifiers. View modifiers in particular are a ripe source of low-hanging fruit. The Compose `Modifier` type often has built-in functions that replicate SwiftUI modifiers, making these SwiftUI modifiers easy to implement.
To help fill in unimplemented API in SkipUI:

1. Find unimplemented API. Unimplemented API will either be within `#if !SKIP` blocks, or will be marked with `@available(*, unavailable)`. Note that most unimplemented `View` modifiers are in the `View.swift` source file.
1. Write an appropriate Compose implementation. See [Implementation Strategy](#implementation-strategy) below.
1. Add a compiled Swift wrapper to SkipFuseUI.
1. Write Showcase code to exercise your component. See [Tests](#tests).
1. [Submit a PR](https://github.com/skiptools/skip-ui/pulls).

Other forms of contributions such as test cases, comments, and documentation are also welcome!

## Tests

The most common way to test SkipUI's support for a SwiftUI component is through the [Skip Showcase](https://github.com/skiptools/skipapp-showcase) and [Skip Showcase Fuse](https://github.com/skiptools/skipapp-showcase-fuse) apps. Whenever you add or update support for a visible element of SwiftUI, make sure there is a showcase view that exercises the element. This not only gives us a mechanism to test appearance and behavior, but the showcase app becomes a demonstration of supported SwiftUI components on Android over time.

## Implementation Strategy

### SkipLite Code Transformations

SkipUI does not work in isolation. When used from Skip Lite transpiled Swift, it depends on transformations the [skip](https://source.skip.tools/skip) plugin makes to SwiftUI code. And while Skip generally strives to write Kotlin that is similar to hand-crafted code, these SwiftUI transformations are not something you'd want to write yourself. Before discussing SkipUI's implementation, let's explore them.

Both SwiftUI and Compose are declarative UI frameworks. Both have mechanisms to track state and automatically re-render when state changes. SwiftUI models user interface elements with `View` objects, however, while Compose models them with `@Composable` functions. The Skip transpiler must therefore translate your code defining a `View` graph into `@Composable` function calls. This involves two primary transformations:

1. The transpiler inserts code to sync `View` members that have special meanings in SwiftUI - `@State`, `@EnvironmentObject`, etc - with the corresponding Compose state mechanisms, which are not member-based. The syncing goes two ways, so that your `View` members are populated from Compose's state values, and changing your `View` members updates Compose's state values. 
1. The transpiler turns `@ViewBuilders` - including `View.body` - into `@Composable` function calls.

The second transformation in particular deserves some explanation, because it may help you to understand SkipUI's internal API. Consider the following simple example:

```swift
struct V: View {
    let isHello: Bool

    var body: some View {
        if isHello {
            Text("Hello!")
        } else {
            Text("Goodbye!")
        }
    }
}
```

The transpilation would look something like the following:

```swift
class V: View {
    val isHello: Bool

    constructor(isHello: Bool) {
        this.isHello = isHello
    }

    override fun body(): View {
        return ComposeBuilder { composectx -> 
            if (isHello) {
                Text("Hello!").Compose(context = composectx)
            } else {
                Text("Goodbye!").Compose(context = composectx)
            }
            ComposeResult.ok
        }
    }

    ...
}
```

Notice the changes to the `body` content. Rather than returning an arbitrary view tree, the transpiled `body` always returns a single `ComposeBuilder`, a special SkipUI view type that invokes a `@Composable` block. The logic of the original `body` is now within that block, and any `View` that `body` would have returned instead invokes its own `Compose(context:)` function to render the corresponding Compose component. The `Compose(context:)` function is part of SkipUI's `View` API.

Thus the transpiler is able to turn any `View.body` - actually any `@ViewBuilder` - into a `ComposeBuilder`: a block of Compose code that it can invoke to render the desired content. A [later section](#composeview) details how you can use SkipUI's `ComposeView` yourself to move fluidly between SwiftUI and Compose when writing your Android UI. 

### Implementation Phases

SkipUI contains stubs for the entire SwiftUI framework. API generally goes through three phases:

1. Code that no one has begun to port to Skip starts in `#if !SKIP` blocks. This hides it from the Skip transpiler.
1. The first implementation step is to move code out of `#if !SKIP` blocks so that it will be transpiled. This is helpful on its own, even if you just mark the API `@available(*, unavailable)` because you are not ready to implement it for Compose. An `unavailable` attribute will provide Skip users with a clear error message, rather than relying on the Kotlin compiler to complain about unfound API.
    - When moving code out of a `#if !SKIP` block, please strip Apple's extensive API comments. There is no reason for Skip to duplicate the official SwiftUI documentation, and it obscures any Skip-specific implementation comments we may add.
    - SwiftUI uses complex generics extensively, and the generics systems of Swift and Kotlin have significant differences. You may have to replace some generics or generic constraints with looser typing in order to transpile successfully. Typing will still be enforced in user code by the Swift compiler.
    - Reducing the number of Swift extensions and instead folding API into the primary declaration of a type can make Skip's internal symbol storage more efficient. You should, however, leave `View` modifiers that are specific to a given component - e.g. `.navigationTitle` is specific to `NavigationStack` - within the component's source file.
1. Finally, we add a Compose implementation and remove any `unavailable` attribute.

Note that SkipUI should remain buildable throughout this process. Being able to successfully compile SkipUI in Xcode helps us validate that our ported components still mesh with the rest of the framework.

### Components

Before implementing a component, familiarize yourself with SkipUI's `View` protocol in `Sources/View/View.swift` as well as the files in the `Sources/Compose` directory. It is also helpful to browse the source code for components and modifiers that have already been ported. See the table of [Supported SwiftUI](#supported-swiftui).

This simplified `Text` view exemplifies a typical SwiftUI component implementation:

```swift
public struct Text: View, Renderable Equatable, Sendable {
    let text: String

    public init(_ text: String) {
        self.text = text
    }

    ...

    #if SKIP
    @Composable override func Render(context: ComposeContext) {
        let modifier = context.modifier
        let font = EnvironmentValues.shared.font ?? Font(fontImpl: { LocalTextStyle.current })
        ...
        androidx.compose.material3.Text(text: text, modifier: modifier, style: font.fontImpl(), ...)
    }
    #else
    public var body: some View {
        stubView()
    }
    #endif
}

```

As you can see, the `Text` type is defined just as it is in SwiftUI. We then use an `#if SKIP` block to implement the composable `Renderable.Render` function for Android, while we stub the `body` var to satisfy the Swift compiler. `Render` makes the necessary Compose calls to render the component, applying the modifier from the given `context` as well as any applicable environment values. If `Text` had any child views, `Render` would call `child.Compose(context: context.content())` to compose its child content.

### Modifiers

Modifiers, on the other hand, use the `ModifiedContent` to perform actions, including changing the `androidx.compose.ui.Modifier` passed to the modified view. Here is the `.opacity` modifier:

```swift
extension View {
    public func opacity(_ opacity: Double) -> some View {
        #if SKIP
        return ModifiedContent(content: self, modifier: RenderModifier { context in
            return context.modifier.alpha(Float(opacity))
        })
        #else
        return self
        #endif
    }
}
```

Some modifiers have their own rendering logic. These modifiers use a different `RenderModifier` constructor that defines the composition. Here, for example, `.frame` composes the view within a Compose `Box` with the proper dimensions and alignment:

```swift
extension View {
    public func frame(width: CGFloat? = nil, height: CGFloat? = nil, alignment: Alignment = .center) -> some View {
        #if SKIP
        return ModifiedContent(content: self, modifier: RenderModifier { renderable, context in
            var modifier = context.modifier
            if let width {
                modifier = modifier.width(width.dp)
            }
            if let height {
                modifier = modifier.height(height.dp)
            }
            let contentContext = context.content()
            ComposeContainer(modifier: modifier, fixedWidth: width != nil, fixedHeight: height != nil) { modifier in
                Box(modifier: modifier, contentAlignment: alignment.asComposeAlignment()) {
                    renderable.Render(context: contentContext)
                }
            }
        })
        #else
        return self
        #endif
    }
}
```

Still other modifiers don't affect rendering at all, but perform side effects or the environment. Pass a `SideEffectModifier` or `EnvironmentModifier` to the `ModifiedContent` in these cases.

Like other SwiftUI components, modifiers use `#if SKIP ... #else ...` to stub the Swift implementation and keep SkipUI buildable in Xcode.

## License

This software is licensed under the
[GNU Lesser General Public License v3.0](https://spdx.org/licenses/LGPL-3.0-only.html),
with a [linking exception](https://spdx.org/licenses/LGPL-3.0-linking-exception.html)
to clarify that distribution to restricted environments (e.g., app stores) is permitted.
