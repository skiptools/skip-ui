// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

// TODO: Process for use in SkipUI

#if !SKIP
import protocol Combine.ObservableObject

/// A property wrapper type that subscribes to an observable object and
/// invalidates a view whenever the observable object changes.
///
/// Add the `@ObservedObject` attribute to a parameter of a SkipUI ``View``
/// when the input is an
///
/// and you want the view to update when the object's published properties
/// change. You typically do this to pass a ``StateObject`` into a subview.
///
/// The following example defines a data model as an observable object,
/// instantiates the model in a view as a state object, and then passes
/// the instance to a subview as an observed object:
///
///     class DataModel: ObservableObject {
///         @Published var name = "Some Name"
///         @Published var isEnabled = false
///     }
///
///     struct MyView: View {
///         @StateObject private var model = DataModel()
///
///         var body: some View {
///             Text(model.name)
///             MySubView(model: model)
///         }
///     }
///
///     struct MySubView: View {
///         @ObservedObject var model: DataModel
///
///         var body: some View {
///             Toggle("Enabled", isOn: $model.isEnabled)
///         }
///     }
///
/// When any published property of the observable object changes, SkipUI
/// updates any view that depends on the object. Subviews can
/// also make updates to the model properties, like the ``Toggle`` in the
/// above example, that propagate to other observers throughout the view
/// hierarchy.
///
/// Don't specify a default or initial value for the observed object. Use the
/// attribute only for a property that acts as an input for a view, as in the
/// above example.
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
@propertyWrapper @frozen public struct ObservedObject<ObjectType> : DynamicProperty where ObjectType : ObservableObject {

    /// A wrapper of the underlying observable object that can create bindings
    /// to its properties.
    @dynamicMemberLookup @frozen public struct Wrapper {

        /// Gets a binding to the value of a specified key path.
        ///
        /// - Parameter keyPath: A key path to a specific  value.
        ///
        /// - Returns: A new binding.
        public subscript<Subject>(dynamicMember keyPath: ReferenceWritableKeyPath<ObjectType, Subject>) -> Binding<Subject> { get { fatalError() } }
    }

    /// Creates an observed object with an initial value.
    ///
    /// This initializer has the same behavior as the ``init(wrappedValue:)``
    /// initializer. See that initializer for more information.
    ///
    /// - Parameter initialValue: An initial value.
    public init(initialValue: ObjectType) { fatalError() }

    /// Creates an observed object with an initial wrapped value.
    ///
    /// Don't call this initializer directly. Instead, declare
    /// an input to a view with the `@ObservedObject` attribute, and pass a
    /// value to this input when you instantiate the view. Unlike a
    /// ``StateObject`` which manages data storage, you use an observed
    /// object to refer to storage that you manage elsewhere, as in the
    /// following example:
    ///
    ///     class DataModel: ObservableObject {
    ///         @Published var name = "Some Name"
    ///         @Published var isEnabled = false
    ///     }
    ///
    ///     struct MyView: View {
    ///         @StateObject private var model = DataModel()
    ///
    ///         var body: some View {
    ///             Text(model.name)
    ///             MySubView(model: model)
    ///         }
    ///     }
    ///
    ///     struct MySubView: View {
    ///         @ObservedObject var model: DataModel
    ///
    ///         var body: some View {
    ///             Toggle("Enabled", isOn: $model.isEnabled)
    ///         }
    ///     }
    ///
    /// Explicitly calling the observed object initializer in `MySubView` would
    /// behave correctly, but would needlessly recreate the same observed object
    /// instance every time SkipUI calls the view's initializer to redraw the
    /// view.
    ///
    /// - Parameter wrappedValue: An initial value for the observable object.
    public init(wrappedValue: ObjectType) { fatalError() }

    /// The underlying value that the observed object references.
    ///
    /// The wrapped value property provides primary access to the observed
    /// object's data. However, you don't typically access it by name. Instead,
    /// SkipUI accesses this property for you when you refer to the variable
    /// that you create with the `@ObservedObject` attribute.
    ///
    ///     struct MySubView: View {
    ///         @ObservedObject var model: DataModel
    ///
    ///         var body: some View {
    ///             Text(model.name) // Reads name from model's wrapped value.
    ///         }
    ///     }
    ///
    /// When you change a wrapped value, you can access the new value
    /// immediately. However, SkipUI updates views that display the value
    /// asynchronously, so the interface might not update immediately.
    @MainActor public var wrappedValue: ObjectType { get { fatalError() } }

    /// A projection of the observed object that creates bindings to its
    /// properties.
    ///
    /// Use the projected value to get a ``Binding`` to a property of an
    /// observed object. To access the projected value, prefix the property
    /// variable with a dollar sign (`$`). For example, you can get a binding
    /// to a model's `isEnabled` Boolean so that a ``Toggle`` can control its
    /// value:
    ///
    ///     struct MySubView: View {
    ///         @ObservedObject var model: DataModel
    ///
    ///         var body: some View {
    ///             Toggle("Enabled", isOn: $model.isEnabled)
    ///         }
    ///     }
    ///
    @MainActor public var projectedValue: ObservedObject<ObjectType>.Wrapper { get { fatalError() } }
}

#endif
