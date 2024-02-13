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

## Tests

SkipUI utilizes a combination of unit tests, UI tests, and basic snapshot tests in which the snapshots are converted into ASCII art for easy processing. 

Perhaps the most common way to test SkipUI's support for a SwiftUI component, however, is through the [Skip Showcase app](https://github.com/skiptools/skipapp-showcase). Whenever you add or update support for a visible element of SwiftUI, make sure there is a showcase view that exercises the element. This not only gives us a mechanism to test appearance and behavior, but the showcase app becomes a demonstration of supported SwiftUI components on Android over time.


## Supported SwiftUI

The following table summarizes SkipUI's SwiftUI support on Android. Anything not listed here is likely not supported. Note that in your iOS-only code - i.e. code within `#if !SKIP` blocks - you can use any SwiftUI you want.

Support levels:

  - ✅ – Full
  - 🟢 – High
  - 🟡 – Medium 
  - 🔴 – Low

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
      <td>Custom Views</td>
    </tr>
    <tr>
      <td>✅</td>
      <td>Custom ViewModifiers</td>
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
                  <li>See <a href="#lists">Lists</a></li>
              </ul>
          </details>      
       </td>
    </tr>
    <tr>
      <td>✅</td>
      <td><code>Form</code> (<a href="https://skip.tools/docs/components/form/">example</a>)</td>
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
      <td>🔴</td>
      <td>
          <details>
              <summary><code>Image</code> (<a href="https://skip.tools/docs/components/image/">example</a>)</summary>
              <ul>
                  <li><code>init(systemName: String)</code></li>
                  <li>See <a href="#images">Images</a></li>
              </ul>
          </details>      
       </td>
    </tr>
    <tr>
      <td>🔴</td>
      <td>
          <details>
              <summary><code>Label</code> (<a href="https://skip.tools/docs/components/label/">example</a>)</summary>
              <ul>
                  <li><code>init(@ViewBuilder title: () -> any View, @ViewBuilder icon: () -> any View)</code></li>
                  <li><code>init(_ title: String, systemImage: String)</code></li>
                  <li>See <a href="#images">Images</a></li>
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
      <td>🟡</td>
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
      <td>🟡</td>
      <td>
          <details>
              <summary><code>NavigationStack</code> (<a href="https://skip.tools/docs/components/navigationstack/">example</a>)</summary>
              <ul>
                  <li>See <a href="#navigation">Navigation</a></li>
                  <li><code>init(@ViewBuilder root: () -> Root)</code></li>
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
      <td>🔴</td>
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
      <td>🟡</td>
      <td>
          <details>
              <summary><code>Spacer</code> (<a href="https://skip.tools/docs/components/border/">example</a>)</summary>
              <ul>
                  <li><code>init()</code></li>
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
                  <li>Formatting is not supported</li>
                  <li><code>Text(...) + Text(...)</code> is not supported</li>
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
      <td>✅</td>
      <td><code>UnevenRoundedRectangle</code> (<a href="https://skip.tools/docs/components/shape/">example</a>)</td>
    </tr>
    <tr>
      <td>✅</td>
      <td><code>VStack</code> (<a href="https://skip.tools/docs/components/stack/">example</a>)</td>
    </tr>
    <tr>
      <td>✅</td>
      <td><code>ZStack</code> (<a href="https://skip.tools/docs/components/stack/">example</a>)</td>
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
      <td><code>.background</code></td>
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
      <td><code>.border</code></td>
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
      <td><code>.confirmationDialog</code></td>
    </tr>
    <tr>
      <td>✅</td>
      <td><code>.cornerRadius</code></td>
    </tr>
    <tr>
      <td>🔴</td>
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
      <td><code>.font</code></td>
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
              <summary><code>.frame</code></summary>
              <ul>
                  <li>Some combinations of parameters do not behave exactly the same in SwiftUI and Android</li>
              </ul>
          </details>      
       </td>
    </tr>
    <tr>
      <td>🟢</td>
      <td>
          <details>
              <summary><code>.gesture</code></summary>
              <ul>
                  <li>See <a href="#gestures">Gestures</a></li>
              </ul>
          </details>      
       </td>
    </tr>
    <tr>
      <td>✅</td>
      <td><code>.gradient</code> (Color)</td>
    </tr>
    <tr>
      <td>✅</td>
      <td><code>.hidden</code></td>
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
      <td><code>.keyboardType</code></td>
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
      <td><code>.modifier</code></td>
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
      <td>🟡</td>
      <td>
          <details>
              <summary><code>.navigationBarBackButtonHidden</code></summary>
              <ul>
                  <li>Does not disable system back button</li>
              </ul>
          </details>      
       </td>
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
      <td><code>.offset</code></td>
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
              <summary><code>.onLongPressGesture</code></summary>
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
      <td><code>.overlay</code></td>
    </tr>
    <tr>
      <td>🟢</td>
      <td>
          <details>
              <summary><code>.padding</code></summary>
              <ul>
                  <li>Compose does not support negative padding</li>
              </ul>
          </details>      
       </td>
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
                  <li>Custom styles are not supported</li>
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
      <td>🔴</td>
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
              <summary><code>.searchable</code></summary>
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
              <summary><code>.shadow</code></summary>
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
              <summary><code>.sheet</code></summary>
              <ul>
                  <li>See <a href="#navigation">Navigation</a></li>
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
              </ul>
          </details>      
       </td>
    </tr>
    <tr>
      <td>✅</td>
      <td><code>.zIndex</code></td>
    </tr>
  </tbody>
</table>

## Topics

### Environment Keys

SwiftUI has many built-in environment keys. These keys are defined in `EnvironmentValues` and typically accessed with the `@Environment` property wrapper. In additional to supporting your custom environment keys, SkipUI exposes the following built-in environment keys:

- `autocorrectionDisabled` (read-only)
- `backgroundStyle`
- `dismiss`
- `font`
- `isEnabled`
- `isSearching` (read-only)
- `layoutDirection`
- `lineLimit`
- `locale`
- `openURL`
- `timeZone`

### Gestures

SkipUI currently supports tap, long press, and drag gestures. You can use either the general `.gesture` modifier or the specialized modifiers like `.onTapGesture` to add gesture support to your views. The following limitations apply:

- `@GestureState` is not yet supported. Use the `Gesture.onEnded` modifier to reset your state.
- Tap counts > 2 are not supported.
- Gesture velocity and predicted end location are always reported as zero and the current location, respectively.
- Only the `onChanged` and `onEnded` gesture modifiers are supported.
- Customization of minimum touch duration, distance, etc. is not supported.

### Images

SkipUI supports loading images from URLs using SwiftUI's `AsyncImage`. Our implementation uses the [Coil](https://coil-kt.github.io/coil/) library to download images on Android.

To display a standard SwiftUI `Image`, SkipUI currently only supports the `Image(systemName:)` constructor. The table below details the mapping between iOS and Android system images. Other system names are not supported, though you can display any emoji using `Text`. These restrictions also apply to other components that load images, such as `Label`.

Skip cannot yet read iOS asset catalogs, so `Image(name:)` is not yet available on Android. You can, however, use `AsyncImage` to display local image resources. This works on both iOS and through Skip on Android. So if you have an image `Sources/MyModule/Resources/sample.jpg` and your `.target` in `Package.swift` properly marks the `Resources` folder for SPM resource processing:

```swift
.target(name: "MyModule", dependencies: ..., resources: [.process("Resources")], plugins: skipstone)
```

Then the following SwiftUI will display the image on both platforms:

```swift
AsyncImage(url: Bundle.module.url(forResource: "sample", withExtension: "jpg"))
```

If these image display options do not meet your needs, consider [embedding Compose code](#composeview) directly until resource loading is implemented.

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
- SkipUI does not support placing modifiers on `Section` or `ForEach` views within lists, other than `ForEach.onDelete` and `ForEach.onMove`.

### Navigation

SwiftUI has three primary forms of navigation: `TabView`, `NavigationStack`, and modal presentations. SkipUI has implemented all three, albeit with the restrictions explained below.

SkipUI's `TabView` does yet not support SwiftUI's overflow tab behavior. Adding too many tabs will just result in too many tabs rather than SwiftUI's automatic "More" tab. Otherwise, `TabView` acts as you would expect.

In SwiftUI, you push vies onto a `NavigationStack` with `NavigationLink`. `NavigationLink` has two ways to specify its destination view: embedding the view directly, or specifying a value that is mapped to a view through the `.navigationDestination` modifier, as in the following code sample:

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

Finally, SkipUI does not yet support binding to an array of destination values to specify the navigation stack.

For modal presentations, SkipUI supports the `.sheet(isPresented:onDismiss:content:)` modifier **only**. We will add support for other forms of modal presentations in the future. 

### Restrictions on Identifiers

Compose requires all state values to be serializable. This restriction is typically transparent to your code, because when you use property wrappers like `@State`, SkipUI automatically tracks your state objects and gives Compose serializable identifiers in their place. Some SwiftUI values, however, must be stored directly in Compose, including `navigationDestination` values and `List` item identifiers. When this is the case, SkipUI creates a `String` from the value you supply using the following algorithm:

- If the value is `Identifiable`, use `String(describing: value.id)`
- If the value is `RawRepresentable`, use `String(describing: value.rawValue)`
- Else use `String(describing: value)`

Please ensure that when using these API, the above algorithm will create unique, stable strings for unique values.

