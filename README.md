# SkipUI

SwiftUI support for [Skip](https://skip.tools) apps.

## About SkipUI

SkipUI vends the `skip.ui` Kotlin package. It is a reimplementation of SwiftUI for Kotlin on Android using Jetpack Compose. Its goal is to mirror as much of SwiftUI as possible, allowing Skip developers to use SwiftUI with confidence.

![SkipUI Diagram](https://assets.skip.tools/diagrams/skip-diagrams-ui.svg)
{: .diagram-vector }


## Dependencies

SkipUI depends on the [skip](https://source.skip.tools/skip) transpiler plugin. The transpiler must transpile SkipUI's own source code, and SkipUI relies on the transpiler's transformation of SwiftUI code. See [Implementation Strategy](#implementation-strategy) for details. SkipUI also depends on the [SkipFoundation](https://github.com/skiptools/skip-foundation) and [SkipModel](https://github.com/skiptools/skip-model) packages.

SkipUI is part of the core *SkipStack* and is not intended to be imported directly.
The module is transparently adopted through the translation of `import SwiftUI` into `import skip.ui.*` by the Skip transpiler.

### Android Libraries

- SkipUI adds an Android dependency on [Coil](https://coil-kt.github.io/coil/) to implement `AsyncImage`.
- SkipUI includes source code from the [ComposeReorderable](https://github.com/aclassen/ComposeReorderable) project to implement drag-to-reorder in `Lists`.

## Status

SkipUI - together with the Skip transpiler - has robust support for the building blocks of SwiftUI, including its state flow and declarative syntax. SkipUI also implements many of SwiftUI's basic layout and control views, as well as many core modifiers. It is possible to write an Android app entirely in SwiftUI utilizing SkipUI's current component set.

SkipUI is a young library, however, and much of SwiftUI's vast surface area is not yet implemented. You are likely to run into limitations while writing real-world apps. See [Supported SwiftUI](#supported-swiftui) for a full list of supported components and constructs.

When you want to use a SwiftUI construct that has not been implemented, you have options. You can try to find a workaround using only supported components, [embed Compose code directly](#composeview), or [add support to SkipUI](#implementation-strategy). If you choose to enhance SkipUI itself, please consider [contributing](#contributing) your code back for inclusion in the official release.

## Contributing

We welcome contributions to SkipUI. The Skip product [documentation](https://skip.tools/docs/contributing/) includes helpful instructions and tips on local Skip library development. 

The most pressing need is to implement more core components and view modifiers. View modifiers in particular are a ripe source of low-hanging fruit. The Compose `Modifier` type often has built-in functions that replicate SwiftUI modifiers, making these SwiftUI modifiers easy to implement.
To help fill in unimplemented API in SkipUI:

1. Find unimplemented API. Unimplemented API will either be within `#if !SKIP` blocks, or will be marked with `@available(*, unavailable)`. Note that most unimplemented `View` modifiers are in the `View.swift` source file.
1. Write an appropriate Compose implementation. See [Implementation Strategy](#implementation-strategy) below.
1. Write tests and/or showcase code to exercise your component. See [Tests](#tests).
1. [Submit a PR](https://github.com/skiptools/skip-ui/pulls).

Other forms of contributions such as test cases, comments, and documentation are also welcome!

## Implementation Strategy

### Code Transformations

SkipUI does not work in isolation. It depends on transformations the [skip](https://source.skip.tools/skip) transpiler plugin makes to SwiftUI code. And while Skip generally strives to write Kotlin that is similar to hand-crafted code, these SwiftUI transformations are not something you'd want to write yourself. Before discussing SkipUI's implementation, let's explore them.

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

The `Text` view exemplifies a typical SwiftUI component implementation. Here is an abbreviated code sample:

```swift
public struct Text: View, Equatable, Sendable {
    let text: String

    public init(_ text: String) {
        self.text = text
    }

    ...

    #if SKIP
    @Composable public override func ComposeContent(context: ComposeContext) {
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

As you can see, the `Text` type is defined just as it is in SwiftUI. We then use an `#if SKIP` block to implement the composable `View.ComposeContent` function for Android, while we stub the `body` var to satisfy the Swift compiler. `ComposeContent` makes the necessary Compose calls to render the component, applying the modifier from the given `context` as well as any applicable environment values. If `Text` had any child views, `ComposeContent` would call `child.Compose(context: context.content())` to compose its child content. (Note that `View.Compose(context:)` delegates to `View.ComposeContent(context:)` after performing other bookkeeping operations, which is why we override `ComposeContent` rather than `Compose`.)

### Modifiers

Modifiers, on the other hand, use the `ComposeModifierView` to perform actions, including changing the `context` passed to the modified view. Here is the `.opacity` modifier:

```swift
extension View {
    public func opacity(_ opacity: Double) -> some View {
        #if SKIP
        return ComposeModifierView(targetView: self) { context in
            context.modifier = context.modifier.alpha(Float(opacity))
            return ComposeResult.ok
        }
        #else
        return self
        #endif
    }
}
```

Some modifiers have their own composition logic. These modifiers use a different `ComposeModifierView` constructor whose block defines the composition. Here, for example, `.frame` composes the view within a Compose `Box` with the proper dimensions and alignment:

```swift
extension View {
    public func frame(width: CGFloat? = nil, height: CGFloat? = nil, alignment: Alignment = .center) -> some View {
        #if SKIP
        return ComposeModifierView(contentView: self) { view, context in
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
                    view.Compose(context: contentContext)
                }
            }
        }
        #else
        return self
        #endif
    }
}
```

Like other SwiftUI components, modifiers use `#if SKIP ... #else ...` to stub the Swift implementation and keep SkipUI buildable in Xcode.

## ComposeView

`ComposeView` is an Android-only SwiftUI view that you can use to embed Compose code directly into your SwiftUI view tree. In the following example, we use a SwiftUI `Text` to write "Hello from SwiftUI", followed by calling the `androidx.compose.material3.Text()` Compose function to write "Hello from Compose" below it:

```swift
VStack {
    Text("Hello from SwiftUI")
    #if SKIP
    ComposeView { _ in
        androidx.compose.material3.Text("Hello from Compose")
    }
    #endif
}
```

Skip also enhances all SwiftUI views with a `Compose()` method, allowing you to use SwiftUI views from within Compose. The following example again uses a SwiftUI `Text` to write "Hello from SwiftUI", but this time from within a `ComposeView`:

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

Or:

```swift
#if SKIP
ComposeView { context in 
    VStack {
        Text("Hello from SwiftUI").Compose(context: context.content())
        androidx.compose.material3.Text("Hello from Compose")
    }.Compose(context: context)
}
#endif
```

With `ComposeView` and the `Compose()` function, you can move fluidly between SwiftUI and Compose code. These techniques work not only with standard SwiftUI and Compose components, but with your own custom SwiftUI views and Compose functions as well.

`ComposeView` and the `Compose()` function are only available in Android, so you must guard all uses with the `#if SKIP` or `#if os(Android)` compiler directives. 

### Additional Considerations

There are additional considerations when integrating SwiftUI into a Compose application that is **not** managed by Skip. SwiftUI relies on its own mechanisms to save and restore `Activity` UI state, such as `@AppStorage` and navigation path bindings. It is not compatible with Android's `Activity` UI state restoration. Use a pattern like the following to exclude SwiftUI from `Activity` state restoration when integrating SwiftUI views:

```kotlin
val stateHolder = rememberSaveableStateHolder()
stateHolder.SaveableStateProvider("myKey") {
    MySwiftUIRootView().Compose()
    SideEffect { stateHolder.removeState("myKey") }
}
```

This pattern allows SwiftUI to take advantage of Compose's UI state mechanisms internally while excluding it from `Activity` state restoration.

## composeModifier

In addition to `ComposeView` above, Skip offers the `composeModifier` SwiftUI modifier. This modifier allows you to apply any Compose modifiers to the underlying Compose view. It takes a block that accepts a single `androidx.compose.ui.Modifier` parameter and returns a `Modifier` as well. For example:

```swift
#if SKIP
import androidx.compose.foundation.layout.imePadding
#endif

...

TextField("Enter username:", text: $username)
    .textFieldStyle(.plain)
    #if SKIP
    .composeModifier { $0.imePadding() }
    #endif
```

Like `ComposeView`, the `composeModifier` function is only available in Android, so you must guard all uses with the `#if SKIP` or `#if os(Android)` compiler directives. 

## Tests

SkipUI utilizes a combination of unit tests, UI tests, and basic snapshot tests in which the snapshots are converted into ASCII art for easy processing. 

Perhaps the most common way to test SkipUI's support for a SwiftUI component, however, is through the [Skip Showcase app](https://github.com/skiptools/skipapp-showcase). Whenever you add or update support for a visible element of SwiftUI, make sure there is a showcase view that exercises the element. This not only gives us a mechanism to test appearance and behavior, but the showcase app becomes a demonstration of supported SwiftUI components on Android over time.


## Supported SwiftUI

The following table summarizes SkipUI's SwiftUI support on Android. Anything not listed here is likely not supported. Note that in your iOS-only code - i.e. code within `#if !SKIP` blocks - you can use any SwiftUI you want.

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
                  <li>See also <a href="#colors">Colors</a></li>
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
                  <li><code>func italic() -> Font</code></li>
                  <li><code>func weight(_ weight: Font.Weight) -> Font</code></li>
                  <li><code>func bold() -> Font</code></li>
                  <li><code>func monospaced() -> Font</code></li>
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
      <td>🟡</td>
      <td>
          <details>
              <summary><code>ProgressView</code> (<a href="https://skip.tools/docs/components/progressview/">example</a>)</summary>
              <ul>
                  <li><code>init()</code></li>
                  <li><code>init(value: Double?, total: Double = 1.0)</code></li>
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
      <td>✅</td>
      <td><code>RoundedRectangle</code> (<a href="https://skip.tools/docs/components/shape/">example</a>)</td>
    </tr>
    <tr>
      <td>✅</td>
      <td><code>ScrollView</code> (<a href="https://skip.tools/docs/components/frame/">example</a>)</td>
    </tr>
    <tr>
      <td>🟡</td>
      <td>
          <details>
              <summary><code>ScrollViewProxy</code></summary>
              <ul>
                  <li>Works only for <code>List</code> and lazy containers: <code>LazyVStack</code>, <code>LazyHStack</code>, <code>LazyVGrid</code>, <code>LazyHGrid</code></li>
                  <li><code>UnitRect</code> parameter is ignored</li>
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
                  <li>See <code>ScrollViewProxy</code></li>
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
                  <li><code>init(_ title: String, text: Binding&lt;String>, prompt: Text? = nil)</code></li>
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
      <td>✅</td>
      <td><code>ToolbarItem</code> (<a href="https://skip.tools/docs/components/toolbar/">example</a>)</td>
    </tr>
    <tr>
      <td>✅</td>
      <td><code>ToolbarItemGroup</code> (<a href="https://skip.tools/docs/components/toolbar/">example</a>)</td>
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
      <td><code>VStack</code> (<a href="https://skip.tools/docs/components/stack/">example</a>)</td>
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
                  <li>Only supported for images</li>
              </ul>
          </details>      
       </td>
    </tr>
    <tr>
      <td>✅</td>
      <td><code>.autocorrectionDisabled</code></td>
    </tr>
    <tr>
      <td>✅</td>
      <td><code>.background</code> (<a href="https://skip.tools/docs/components/background/">example</a>)</td>
    </tr>
    <tr>
      <td>✅</td>
      <td><code>.backgroundStyle</code></td>
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
                  <li>See also <a href="#colors">Colors</a></li>
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
                  <li>Note that covers are dismissible via swipe and the back button on Android.</li>
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
      <td>🟡</td>
      <td>
          <details>
              <summary><code>.lineLimit</code></summary>
              <ul>
                  <li>func lineLimit(_ number: Int?) -> some View</li>
              </ul>
          </details>      
       </td>
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
      <td>🟢</td>
      <td>
          <details>
              <summary><code>.navigationDestination</code></summary>
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
      <td>
            <details>
              <summary><code>.preferredColorScheme</code></summary>
              <ul>
                  <li>See <a href="#preferred-color-scheme">Preferred Color Scheme</a></li>
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
      <td><code>.tabItem</code></td>
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

Skip adds additional Android-only API that allows you to customize the Material colors used for your app's light and dark colors schemes. By default, Skip uses Material 3's dynamic colors on devices that support them, and falls back to Material 3's standard colors otherwise. You can customize these colors in Compose code using the following function: 

```kotlin
Material3ColorScheme(scheme: (@Composable (ColorScheme, Boolean) -> ColorScheme)?, content: @Composable () -> Unit)
```

The `scheme` argument takes a closure with two arguments: the default `androidx.compose.material3.ColorScheme`, and whether dark mode is being requested. Your closure returns the `androidx.compose.material3.ColorScheme` to use for the supplied content.

For example, to customize the surface colors for your app, you could edit `Main.kt` as follows:

```kotlin
@Composable
internal fun PresentationRootView(context: ComposeContext) {
    Material3ColorScheme({ colors, isDark ->
        colors.copy(surface = if (isDark) Color.purple.colorImpl() else Color.yellow.colorImpl())
    }, content = {
        // ... Original content of this function ...
    })
}
```

Skip also provides the SwiftUI `.material3ColorScheme(_:)` modifier to customize a SwiftUI view hierarchy. The modifier takes the same closure as the `Material3ColorScheme` Kotlin function. It is only available for Android, so you must use it within a `#if SKIP` block. For example:

```swift
MyView()
    #if SKIP
    .material3ColorScheme { colors, isDark in
        colors.copy(surface: isDark ? Color.purple.colorImpl() : Color.yellow.colorImpl())
    }
    #endif
```

Skips built-in components use the following Material 3 colors, if you'd like to customize them:

- `surface`
- `primary`
- `onBackground`
- `outline`
- `outlineVariant`

#### Preferred Color Scheme

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
- `timeZone`
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

SkipUI currently supports tap, long press, and drag gestures. You can use either the general `.gesture` modifier or the specialized modifiers like `.onTapGesture` to add gesture support to your views. The following limitations apply:

- `@GestureState` is not yet supported. Use the `Gesture.onEnded` modifier to reset your state.
- Tap counts > 2 are not supported.
- Gesture velocity and predicted end location are always reported as zero and the current location, respectively.
- Only the `onChanged` and `onEnded` gesture modifiers are supported.
- Customization of minimum touch duration, distance, etc. is generally not supported.

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

Once the asset catalog is added to your `Resources` folder, any bundled images can be loaded and displayed using the `Image(name:bundle:)` constructor. For example:

```swift
Image("Cat", bundle: .module, label: Text("Cat JPEG image"))
```

See the [Skip Showcase app](https://github.com/skiptools/skipapp-showcase) `ImagePlayground` for a concrete example of using a bundled image in an asset catalog, and see that project's Xcode project file ([screenshot](https://assets.skip.tools/screens/SkipUI_Asset_Image.png)) to see the configuration of the `.xcassets` file for the app module.

Note that you **must** specify the `bundle` parameter for images explicitly, since a Skip project uses per-module resources, rather than the default `Bundle.main` bundle that would be assumed of the parameter were omitted.
{: class="callout info"}

When an app project is first created with `skip init`, it will contain two separate asset catalogs: a project-level `Assets.xcassets` catalog that contains the app's icons, and an empty module-level `Module.xcassets` catalog. Only the module-level catalog will be transpiled, since the project-level catalog is not processed by the skip transpiler.
{: class="callout warning"}

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
| star | Icons.Outlined.Star |
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

- When multiple elements in a `HStack` use `.frame(maxWidth: .infinity)` or multiple elements in a `VStack` use `.frame(maxHeight: .infinity)`, your Android layout will always divide the available space evenly between them. If any `.infinity` element *also* specifies a `minWidth` or `minHeight` larger than its evenly-divided slice of space, it may overlap neighboring elements rather than force them to use less space.

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
- `Section` and `ForEach` views must be defined inline within their owning `List`. In other words, if your `List` contains `MyView`, `MyView` will be rendered as a single list row even if it contains `Section` or `ForEach` content.
- Nesting of `ForEach` and `Section` views is limited.
- SkipUI does not support placing modifiers on `Section` or `ForEach` views within lists, other than `ForEach.onDelete` and `ForEach.onMove`.
- See also the `ForEach` view [topic](#foreach).

### Navigation

SwiftUI has three primary forms of navigation: `TabView`, `NavigationStack`, and modal presentations. SkipUI has implemented all three, albeit with the restrictions explained below.

SkipUI's `TabView` does yet not support SwiftUI's overflow tab behavior. Adding too many tabs will just result in too many tabs rather than SwiftUI's automatic "More" tab. Otherwise, `TabView` acts as you would expect.

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

SkipUI supports both of these models. Using `.navigationDestinations`, however, requires some care. It is currently the case that if a pushed view defines a new `.navigationDestination` for key type `T`, it will overwrite any previous stack view's `T` destination mapping. **Take care not to unintentionally re-map the same key type in the same navigation stack.**

Compose imposes an additional restriction as well: we must be able to stringify `.navigationDestination` key types. See [Restrictions on Identifiers](#restrictions-on-identifiers) below.

### Restrictions on Identifiers

Compose requires all state values to be serializable. This restriction is typically transparent to your code, because when you use property wrappers like `@State`, SkipUI automatically tracks your state objects and gives Compose serializable identifiers in their place. Some SwiftUI values, however, must be stored directly in Compose, including `navigationDestination` values and `List` item identifiers. When this is the case, SkipUI creates a `String` from the value you supply using the following algorithm:

- If the value is `Identifiable`, use `String(describing: value.id)`
- If the value is `RawRepresentable`, use `String(describing: value.rawValue)`
- Else use `String(describing: value)`

Please ensure that when using these API, the above algorithm will create unique, stable strings for unique values.

### Safe Area

Like the iPhone, Android devices can render content behind system bars like the top status bar and bottom gesture area. SwiftUI code using the `.ignoresSafeArea` modifier to extend content behind system bars will work the same across SwiftUI and SkipUI, with one exception: SkipUI ignores the `SafeAreaRegions.keyboard` region. SkipUI does not represent the onscreen keyboard as a safe area. Rather, it follows the typical Android practice of shrinking the content area to fit above the keyboard. 

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
