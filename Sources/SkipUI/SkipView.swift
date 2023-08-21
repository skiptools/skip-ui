// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

#if SKIP
#if SKIP
// SKIP INSERT: import android.os.*
// SKIP INSERT: import androidx.compose.foundation.*
// SKIP INSERT: import androidx.compose.foundation.layout.*
// SKIP INSERT: import androidx.compose.material3.*
// SKIP INSERT: import androidx.compose.runtime.*
// SKIP INSERT: import androidx.compose.runtime.saveable.*
// SKIP INSERT: import androidx.compose.ui.*
// SKIP INSERT: import androidx.compose.ui.draw.*
// SKIP INSERT: import androidx.compose.ui.platform.*
// SKIP INSERT: import androidx.compose.ui.semantics.*
// SKIP INSERT: import androidx.compose.ui.text.*
// SKIP INSERT: import androidx.compose.ui.text.style.*
// SKIP INSERT: import androidx.compose.ui.unit.*
#else
//import SwiftUI
#endif

#if SKIP
public protocol View {
    /// The transpiler adds `Compose(ctx)` tail calls to compose each view.
    // SKIP INSERT:
    // @Composable fun Compose(ctx: ComposeContext): Unit = body().Compose(ctx)
    //
    // SKIP DECLARE: fun body(): View = EmptyView()
    @ViewBuilder var body: any View { get }
}

extension View {
    @Composable public func Compose() {
        Compose(ComposeContext())
    }
}

/// View that wraps `Composable` content.
///
/// Used to wrap the content of SwiftUI `@ViewBuilders`, and may be used manually to embed Jetpack Compose code.
public struct ComposeView: View {
    private let content: @Composable (ComposeContext) -> Void

    public init(content: @Composable (ComposeContext) -> Void) {
        self.content = content
    }

    @Composable public override func Compose(ctx: ComposeContext) {
        content(ctx)
    }
}
#else
//public typealias View = SwiftUI.View
#endif

#if SKIP
/// Context to provide modifiers, environment, etc to composables.
public struct ComposeContext {
    public var modifier: Modifier = Modifier
    public var tag: AnyHashable? = nil

    // TODO: Environment
    public var font: Font? = nil
    public var color: Color? = nil

    public var stateSaver: Saver<Any, Any> = ComposeStateSaver()

    /// The context to pass to child views.
    public func child() -> ComposeContext {
        return ComposeContext(font: font, color: color, stateSaver: stateSaver)
    }
}

/// Used internally by modifiers to apply changes to the context supplied to modified views.
struct ComposeContextView: View {
    let view: View
    let contextTransform: @Composable (inout ComposeContext) -> Void

    init(_ view: any View, contextTransform: @Composable (inout ComposeContext) -> Void) {
        self.view = view
        self.contextTransform = contextTransform
    }

    @Composable override func Compose(ctx: ComposeContext) {
        var ctx = ctx
        contextTransform(&ctx)
        view.Compose(ctx)
    }
}

/// Used in conjunction with `rememberSaveable` to save and restore state with SwiftUI-like behavior.
struct ComposeStateSaver: Saver<Any, Any> {
    // TODO: Discard state when popped / dismissed
    private let state: MutableMap<Key, Any> = mutableMapOf()

    override func restore(value: Any) -> Any? {
        if let key = value as? Key {
            return state[key]
        } else {
            return value
        }
    }

    // SKIP DECLARE: override fun SaverScope.save(value: Any): Any?
    override func save(value: Any) -> Any? {
        if value is Boolean || value is Number || value is String || value is Char {
            return value
        } else {
            let key = Key.next()
            state[key] = value
            return key
        }
    }

    /// Key under which to save values that cannot be stored directly in the Bundle.
    private struct Key: Parcelable {
        private static var keyValue = 0

        static func next() -> Key {
            keyValue += 1
            return Key(value: keyValue)
        }

        private let value: Int

        private init(value: Int) {
            self.value = value
        }

        init(parcel: Parcel) {
            self.init(parcel.readInt())
        }

        override func writeToParcel(parcel: Parcel, flags: Int) {
            parcel.writeInt(value)
        }

        override func describeContents() -> Int {
            return 0
        }

        static let CREATOR: Parcelable.Creator<Key> = Creator()

        private class Creator: Parcelable.Creator<Key> {
            override func createFromParcel(parcel: Parcel) -> Key {
                return Key(parcel)
            }
            override func newArray(size: Int) -> kotlin.Array<Key?> {
                return arrayOfNulls(size)
            }
        }
    }
}
#endif

public struct Button<Label> : View where Label : View {
    let action: () -> Void
    let label: Label

    public init(action: @escaping () -> Void, @ViewBuilder label: () -> Label) {
        self.action = action
        self.label = label()
    }

    #if SKIP
    /*
     https://cs.android.com/androidx/platform/frameworks/support/+/androidx-main:compose/material3/material3/src/commonMain/kotlin/androidx/compose/material3/Button.kt
     @Composable
     fun Button(
        onClick: () -> Unit,
        modifier: Modifier = Modifier,
        enabled: Boolean = true,
        shape: Shape = ButtonDefaults.shape,
        colors: ButtonColors = ButtonDefaults.buttonColors(),
        elevation: ButtonElevation? = ButtonDefaults.buttonElevation(),
        border: BorderStroke? = null,
        contentPadding: PaddingValues = ButtonDefaults.ContentPadding,
        interactionSource: MutableInteractionSource = remember { MutableInteractionSource() },
        content: @Composable RowScope.() -> Unit
     )
     */
    @Composable public override func Compose(ctx: ComposeContext) {
        androidx.compose.material3.Button(modifier: ctx.modifier, onClick: action, content: {
            label.Compose(ctx.child())
        })
    }
    #else
    public var body: some View {
        stubView()
        //SwiftUI.Button(action: action) {
        //    label
        //}
    }
    #endif
}

public struct Divider : View {
    public init() {
    }

    #if SKIP
    /*
     https://cs.android.com/androidx/platform/frameworks/support/+/androidx-main:compose/material3/material3/src/commonMain/kotlin/androidx/compose/material3/Divider.kt
     @Composable
     fun Divider(
        modifier: Modifier = Modifier,
        thickness: Dp = DividerDefaults.Thickness,
        color: Color = DividerDefaults.color,
     )
     */
    @Composable public override func Compose(ctx: ComposeContext) {
        let dividerColor = ctx.color?.colorImpl.composeColor?.invoke()
        androidx.compose.material3.Divider(modifier: ctx.modifier, color: dividerColor ?? androidx.compose.ui.graphics.Color.Unspecified)
    }
    #else
    public var body: some View {
        //SwiftUI.Divider()
        stubView()
    }
    #endif
}

public struct EmptyView : View {
    #if SKIP
    @Composable public override func Compose(ctx: ComposeContext) {
    }
    #else
    public var body: some View {
        //SwiftUI.EmptyView()
        stubView()
    }
    #endif
}

public struct Group<Content> : View where Content : View {
    private let content: Content

    public init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    #if SKIP
    @Composable public override func Compose(ctx: ComposeContext) {
        content.Compose(ctx)
    }
    #else
    public var body: some View {
        content
    }
    #endif
}

public struct HStack<Content> : View where Content : View {
    private let spacing: CGFloat?
    private let content: Content

    public init(spacing: CGFloat? = nil, @ViewBuilder content: () -> Content) {
        self.spacing = spacing
        self.content = content()
    }

    #if SKIP
    /*
     https://cs.android.com/androidx/platform/frameworks/support/+/androidx-main:compose/foundation/foundation-layout/src/commonMain/kotlin/androidx/compose/foundation/layout/Row.kt
     @Composable
     inline fun Row(
         modifier: Modifier = Modifier,
         horizontalArrangement: Arrangement.Horizontal = Arrangement.Start,
         verticalAlignment: Alignment.Vertical = Alignment.Top,
         content: @Composable RowScope.() -> Unit
     )
     */
    @Composable public override func Compose(ctx: ComposeContext) {
        androidx.compose.foundation.layout.Row(modifier: ctx.modifier, horizontalArrangement: Arrangement.spacedBy((spacing ?? 8.0).dp)) {
            content.Compose(ctx.child())
        }
    }
    #else
    public var body: some View {
        stubView()
        //SwiftUI.HStack(spacing: spacing) { content }
    }
    #endif
}

public struct Slider : View {
    private let value: Binding<Double>
    private let range: ClosedRange<Double>

    public init(value: Binding<Double>, in range: ClosedRange<Double>) {
        self.value = value
        self.range = range
    }

    #if SKIP
    /*
     https://cs.android.com/androidx/platform/frameworks/support/+/androidx-main:compose/material3/material3/src/commonMain/kotlin/androidx/compose/material3/Slider.kt
     @Composable
     fun Slider(
        value: Float,
        onValueChange: (Float) -> Unit,
        modifier: Modifier = Modifier,
        enabled: Boolean = true,
        valueRange: ClosedFloatingPointRange<Float> = 0f..1f,
        @IntRange(from = 0)
        steps: Int = 0,
        onValueChangeFinished: (() -> Unit)? = null,
        colors: SliderColors = SliderDefaults.colors(),
        interactionSource: MutableInteractionSource = remember { MutableInteractionSource() }
     )
     */
    @Composable public override func Compose(ctx: ComposeContext) {
        androidx.compose.material3.Slider(value: Float(value.get()), onValueChange: { value.set(Double($0)) }, modifier: ctx.modifier, valueRange: Float(self.range.start)...Float(self.range.endInclusive))
    }
    #else
    public var body: some View {
        //SwiftUI.Slider(value: value, in: range)
        stubView()
    }
    #endif
}

public struct Spacer : View {
    public var minLength: CGFloat?

    public init(minLength: CGFloat? = nil) {
        self.minLength = minLength
    }

    #if SKIP
    /*
     https://cs.android.com/androidx/platform/frameworks/support/+/androidx-main:compose/foundation/foundation-layout/src/commonMain/kotlin/androidx/compose/foundation/layout/Spacer.kt
     @Composable
     fun Spacer(modifier: Modifier)
     */
    @Composable public override func Compose(ctx: ComposeContext) {
        androidx.compose.foundation.layout.Spacer(modifier: ctx.modifier) // TODO distribute space : .weight(1.0f)
    }
    #else
    public var body: some View {
        //SwiftUI.Spacer(minLength: minLength)
        stubView()
    }
    #endif
}

public struct Text: View {
    let text: String

    public init(_ text: String) {
        self.text = text
    }

    #if SKIP
    /*
     https://cs.android.com/androidx/platform/frameworks/support/+/androidx-main:compose/material3/material3/src/commonMain/kotlin/androidx/compose/material3/Text.kt
     @Composable
     fun Text(
         text: String,
         modifier: Modifier = Modifier,
         color: Color = Color.Unspecified,
         fontSize: TextUnit = TextUnit.Unspecified,
         fontStyle: FontStyle? = null,
         fontWeight: FontWeight? = null,
         fontFamily: FontFamily? = null,
         letterSpacing: TextUnit = TextUnit.Unspecified,
         textDecoration: TextDecoration? = null,
         textAlign: TextAlign? = null,
         lineHeight: TextUnit = TextUnit.Unspecified,
         overflow: TextOverflow = TextOverflow.Clip,
         softWrap: Boolean = true,
         maxLines: Int = Int.MAX_VALUE,
         minLines: Int = 1,
         onTextLayout: ((TextLayoutResult) -> Unit)? = null,
         style: TextStyle = LocalTextStyle.current
     )
     */
    @Composable public override func Compose(ctx: ComposeContext) {
        let modifier = ctx.modifier
        let textStyle = ctx.font?.fontImpl.composeTextStyle?.invoke()
        let textColor = ctx.color?.colorImpl.composeColor?.invoke()
        androidx.compose.material3.Text(text: text, modifier: modifier, color: textColor ?? androidx.compose.ui.graphics.Color.Unspecified, style: textStyle ?? androidx.compose.material3.LocalTextStyle.current)
    }
    #else
    public var body: some View {
        //SwiftUI.Text(text)
        stubView()
    }
    #endif
}

public struct VStack<Content> : View where Content : View {
    private let spacing: CGFloat?
    private let content: Content

    public init(spacing: CGFloat? = nil, @ViewBuilder content: () -> Content) {
        self.spacing = spacing
        self.content = content()
    }

    #if SKIP
    /*
     https://cs.android.com/androidx/platform/frameworks/support/+/androidx-main:compose/foundation/foundation-layout/src/commonMain/kotlin/androidx/compose/foundation/layout/Column.kt
     @Composable
     inline fun Column(
         modifier: Modifier = Modifier,
         verticalArrangement: Arrangement.Vertical = Arrangement.Top,
         horizontalAlignment: Alignment.Horizontal = Alignment.Start,
         content: @Composable ColumnScope.() -> Unit
     )
     */
    @Composable public override func Compose(ctx: ComposeContext) {
        androidx.compose.foundation.layout.Column(modifier: ctx.modifier, verticalArrangement: Arrangement.spacedBy((spacing ?? 8.0).dp), horizontalAlignment: androidx.compose.ui.Alignment.CenterHorizontally) {
            content.Compose(ctx.child())
        }
    }
    #else
    public var body: some View {
        //SwiftUI.VStack(spacing: spacing) { content }
        stubView()
    }
    #endif
}

public struct ZStack<Content> : View where Content : View {
    private let content: Content

    public init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    #if SKIP
    /*
     https://cs.android.com/androidx/platform/frameworks/support/+/androidx-main:compose/foundation/foundation-layout/src/commonMain/kotlin/androidx/compose/foundation/layout/Box.kt
     @Composable
     inline fun Box(
        modifier: Modifier = Modifier,
        contentAlignment: Alignment = Alignment.TopStart,
        propagateMinConstraints: Boolean = false,
        content: @Composable BoxScope.() -> Unit
     )
     */
    @Composable public override func Compose(ctx: ComposeContext) {
        androidx.compose.foundation.layout.Box(modifier: ctx.modifier, contentAlignment: androidx.compose.ui.Alignment.Center) {
            content.Compose(ctx.child())
        }
    }
    #else
    public var body: some View {
        //SwiftUI.ZStack { content }
        stubView()
    }
    #endif
}

// MARK: Common Compose Functions
// Wrapping the components from https://developer.android.com/reference/kotlin/androidx/compose/material/package-summary

//Text (androidx.compose.material.Text): Displays a text element on the screen.
//Button (androidx.compose.material.Button): Creates a clickable button.
//Surface (androidx.compose.material.Surface): Defines a surface with a background color and elevation.
//Image (androidx.compose.foundation.Image): Displays an image.
//Box (androidx.compose.foundation.Box): A composable that places its children in a box layout.
//Row (androidx.compose.foundation.layout.Row): Lays out its children in a horizontal row.
//Column (androidx.compose.foundation.layout.Column): Lays out its children in a vertical column.
//Spacer (androidx.compose.ui.layout.Spacer): Adds empty space between composables.
//Card (androidx.compose.material.Card): Creates a Material Design card.
//TextField (androidx.compose.material.TextField): Creates an editable text field.
//TopAppBar (androidx.compose.material.TopAppBar): Creates a Material Design top app bar.
//BottomAppBar (androidx.compose.material.BottomAppBar): Creates a Material Design bottom app bar.
//FloatingActionButton (androidx.compose.material.FloatingActionButton): Creates a floating action button.
//AlertDialog (androidx.compose.material.AlertDialog): Creates a Material Design alert dialog.
//ModalBottomSheetLayout (androidx.compose.material.ModalBottomSheetLayout): Creates a modal bottom sheet.
//IconButton (androidx.compose.material.IconButton): Creates an icon button.
//OutlinedTextField (androidx.compose.material.OutlinedTextField): Creates an outlined text field.
//LazyColumn (androidx.compose.foundation.lazy.LazyColumn): Creates a lazily laid out column.
//LazyRow (androidx.compose.foundation.lazy.LazyRow): Creates a lazily laid out row.
//LazyVerticalGrid (androidx.compose.foundation.lazy.LazyVerticalGrid): Creates a lazily laid out vertical grid.
//LazyRow (androidx.compose.foundation.lazy.LazyRow): Creates a lazily laid out row with horizontally scrolling items.
//LazyColumnFor (androidx.compose.foundation.lazy.LazyColumnFor): Creates a lazily laid out column for a list of items.
//LazyRowFor (androidx.compose.foundation.lazy.LazyRowFor): Creates a lazily laid out row for a list of items.
//LazyVerticalGridFor (androidx.compose.foundation.lazy.LazyVerticalGridFor): Creates a lazily laid out vertical grid for a list of items.
//Clickable (androidx.compose.ui.Modifier.clickable): Adds a click listener to a composable.
//Icon (androidx.compose.material.Icon): Displays an icon from the Material Icons font.
//IconButton (androidx.compose.material.IconButton): Creates an icon button with optional click listener.
//Checkbox (androidx.compose.material.Checkbox): Creates a checkbox.
//RadioButton (androidx.compose.material.RadioButton): Creates a radio button.
//Switch (androidx.compose.material.Switch): Creates a switch (on/off toggle).
//Slider (androidx.compose.material.Slider): Creates a slider for selecting a value within a range.
//LinearProgressIndicator (androidx.compose.material.LinearProgressIndicator): Creates a linear progress indicator.
//CircularProgressIndicator (androidx.compose.material.CircularProgressIndicator): Creates a circular progress indicator.
//Divider (androidx.compose.material.Divider): Creates a horizontal divider.
//Spacer (androidx.compose.foundation.layout.Spacer): Adds empty space between composables.
//AlertDialog (androidx.compose.material.AlertDialog): Creates an alert dialog with customizable buttons and content.
//Snackbar (androidx.compose.material.SnackbarHost): Creates a snackbar to display short messages.
//DropdownMenu (androidx.compose.material.DropdownMenu): Creates a dropdown menu with a list of items.
//Drawer (androidx.compose.material.Drawer): Creates a sliding drawer panel for navigation.
//MaterialTheme (androidx.compose.material.MaterialTheme): Applies Material Design styles to its children.
#endif
