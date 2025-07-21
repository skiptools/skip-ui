// Copyright 2023–2025 Skip
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception
/*
/// A structure that computes views and disclosure groups on demand from an
/// underlying collection of tree-structured, identified data.
///
/// Use an outline group when you need a view that can represent a hierarchy
/// of data by using disclosure views. This allows the user to navigate the
/// tree structure by using the disclosure views to expand and collapse
/// branches.
///
/// In the following example, a tree structure of `FileItem` data offers a
/// simplified view of a file system. Passing the root of this tree and the
/// key path of its children allows you to quickly create a visual
/// representation of the file system.
///
///     struct FileItem: Hashable, Identifiable, CustomStringConvertible {
///         var id: Self { self }
///         var name: String
///         var children: [FileItem]? = nil
///         var description: String {
///             switch children {
///             case nil:
///                 return "📄 \(name)"
///             case .some(let children):
///                 return children.isEmpty ? "📂 \(name)" : "📁 \(name)"
///             }
///         }
///     }
///
///     let data =
///       FileItem(name: "users", children:
///         [FileItem(name: "user1234", children:
///           [FileItem(name: "Photos", children:
///             [FileItem(name: "photo001.jpg"),
///              FileItem(name: "photo002.jpg")]),
///            FileItem(name: "Movies", children:
///              [FileItem(name: "movie001.mp4")]),
///               FileItem(name: "Documents", children: [])
///           ]),
///          FileItem(name: "newuser", children:
///            [FileItem(name: "Documents", children: [])
///            ])
///         ])
///
///     OutlineGroup(data, children: \.children) { item in
///         Text("\(item.description)")
///     }
///
/// ### Type parameters
///
/// Five generic type constraints define a specific `OutlineGroup` instance:
///
/// - `Data`: The type of a collection containing the children of an element in
///   the tree-shaped data.
/// - `ID`: The type of the identifier for an element.
/// - `Parent`: The type of the visual representation of an element whose
///   children property is non-`nil`
/// - `Leaf`: The type of the visual representation of an element whose
///   children property is `nil`.
/// - `Subgroup`: A type of a view that groups a parent view and a view
///   representing its children, typically with some mechanism for showing and
///   hiding the children
@available(iOS 14.0, macOS 11.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
public struct OutlineGroup<Data, ID, Parent, Leaf, Subgroup> where Data : RandomAccessCollection, ID : Hashable {
}

@available(iOS 17.0, macOS 14.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension OutlineGroup where ID == Data.Element.ID, Parent : TableRowContent, Parent == Leaf, Leaf == Subgroup, Data.Element == Parent.TableRowValue {

    /// Creates an outline group from a root data element and a key path to
    /// its children.
    ///
    /// This initializer provides a default `TableRowBuilder` using `TableRow`
    /// for each data element.
    ///
    /// This initializer creates an instance that uniquely identifies table rows
    /// across updates based on the identity of the underlying data element.
    ///
    /// All generated disclosure groups begin in the collapsed state.
    ///
    /// - Parameters:
    ///   - root: The root of a collection of tree-structured, identified
    ///     data.
    ///   - children: A key path to a property whose non-`nil` value gives the
    ///     children of `data`. A non-`nil` but empty value denotes an element
    ///     capable of having children that's currently childless, such as an
    ///     empty directory in a file system. On the other hand, if the property
    ///     at the key path is `nil`, then the outline group treats `data` as a
    ///     leaf in the tree, like a regular file in a file system.
    public init<DataElement>(_ root: DataElement, children: KeyPath<DataElement, Data?>) where ID == DataElement.ID, Parent == TableRow<DataElement>, Leaf == TableRow<DataElement>, Subgroup == TableRow<DataElement>, DataElement : Identifiable, DataElement == Data.Element { fatalError() }

    /// Creates an outline group from a collection of root data elements and
    /// a key path to element's children.
    ///
    /// This initializer provides a default `TableRowBuilder` using `TableRow`
    /// for each data element.
    ///
    /// This initializer creates an instance that uniquely identifies table rows
    /// across updates based on the identity of the underlying data element.
    ///
    /// All generated disclosure groups begin in the collapsed state.
    ///
    /// - Parameters:
    ///   - data: A collection of tree-structured, identified data.
    ///   - children: A key path to a property whose non-`nil` value gives the
    ///     children of `data`. A non-`nil` but empty value denotes an element
    ///     capable of having children that's currently childless, such as an
    ///     empty directory in a file system. On the other hand, if the property
    ///     at the key path is `nil`, then the outline group treats `data` as a
    ///     leaf in the tree, like a regular file in a file system.
    public init<DataElement>(_ data: Data, children: KeyPath<DataElement, Data?>) where ID == DataElement.ID, Parent == TableRow<DataElement>, Leaf == TableRow<DataElement>, Subgroup == TableRow<DataElement>, DataElement : Identifiable, DataElement == Data.Element { fatalError() }

    /// Creates an outline group from a root data element and a key path to
    /// its children.
    ///
    /// This initializer exposes `content` as a `TableRowBuilder` to allow
    /// custom table row content for each data element.
    ///
    /// This initializer creates an instance that uniquely identifies table rows
    /// across updates based on the identity of the underlying data element.
    ///
    /// All generated disclosure groups begin in the collapsed state.
    ///
    /// - Parameters:
    ///   - root: The root of a collection of tree-structured, identified
    ///     data.
    ///   - children: A key path to a property whose non-`nil` value gives the
    ///     children of `data`. A non-`nil` but empty value denotes an element
    ///     capable of having children that's currently childless, such as an
    ///     empty directory in a file system. On the other hand, if the property
    ///     at the key path is `nil`, then the outline group treats `data` as a
    ///     leaf in the tree, like a regular file in a file system.
    ///   - content: A table row builder that produces a row based on an
    ///     element in `data`.
    public init<DataElement>(_ root: DataElement, children: KeyPath<DataElement, Data?>, @TableRowBuilder<DataElement> content: @escaping (DataElement) -> Leaf) where ID == DataElement.ID, DataElement == Data.Element { fatalError() }

    /// Creates an outline group from a root data element, a key path to the its
    /// identifier, as well as a key path to its children.
    ///
    /// This initializer exposes `content` as a `TableRowBuilder` to allow
    /// custom table row content for each data element.
    ///
    /// This initializer creates an instance that uniquely identifies views
    /// across updates based on the identity of the underlying data element.
    ///
    /// All generated disclosure groups begin in the collapsed state.
    ///
    /// Make sure that the identifier of a data element only changes if you
    /// mean to replace that element with a new element, one with a new
    /// identity. If the ID of an element changes, then the content view
    /// generated from that element will lose any current state and animations.
    ///
    /// - Parameters:
    ///   - root: The root of a collection of tree-structured, identified
    ///     data.
    ///   - id: The key path to a data element's identifier.
    ///   - children: A key path to a property whose non-`nil` value gives the
    ///     children of `data`. A non-`nil` but empty value denotes an element
    ///     capable of having children that's currently childless, such as an
    ///     empty directory in a file system. On the other hand, if the property
    ///     at the key path is `nil`, then the outline group treats `data` as a
    ///     leaf in the tree, like a regular file in a file system.
    ///   - content: A view builder that produces a content view based on an
    ///    element in `data`.
    public init<DataElement>(_ root: DataElement, id: KeyPath<DataElement, ID>, children: KeyPath<DataElement, Data?>, @TableRowBuilder<DataElement> content: @escaping (DataElement) -> Leaf) where ID == DataElement.ID, DataElement == Data.Element { fatalError() }

    /// Creates an outline group from a collection of root data elements and
    /// a key path to element's children.
    ///
    /// This initializer exposes `content` as a `TableRowBuilder` to allow
    /// custom table row content for each data element.
    ///
    /// This initializer creates an instance that uniquely identifies table rows
    /// across updates based on the identity of the underlying data element.
    ///
    /// All generated disclosure groups begin in the collapsed state.
    ///
    /// - Parameters:
    ///   - data: A collection of tree-structured, identified data.
    ///   - children: A key path to a property whose non-`nil` value gives the
    ///     children of `data`. A non-`nil` but empty value denotes an element
    ///     capable of having children that's currently childless, such as an
    ///     empty directory in a file system. On the other hand, if the property
    ///     at the key path is `nil`, then the outline group treats `data` as a
    ///     leaf in the tree, like a regular file in a file system.
    ///   - content: A table row builder that produces a row based on an
    ///     element in `data`.
    public init<DataElement>(_ data: Data, children: KeyPath<DataElement, Data?>, @TableRowBuilder<DataElement> content: @escaping (DataElement) -> Leaf) where ID == DataElement.ID, DataElement == Data.Element { fatalError() }

    /// Creates an outline group from a collection of root data elements, a key
    /// path to the element's identifier, as well as a key path to element's
    /// children.
    ///
    /// This initializer exposes `content` as a `TableRowBuilder` to allow
    /// custom table row content for each data element.
    ///
    /// This initializer creates an instance that uniquely identifies table rows
    /// across updates based on the identity of the underlying data element.
    ///
    /// All generated disclosure groups begin in the collapsed state.
    ///
    /// - Parameters:
    ///   - data: A collection of tree-structured, identified data.
    ///   - id: The key path to a data element's identifier.
    ///   - children: A key path to a property whose non-`nil` value gives the
    ///     children of `data`. A non-`nil` but empty value denotes an element
    ///     capable of having children that's currently childless, such as an
    ///     empty directory in a file system. On the other hand, if the property
    ///     at the key path is `nil`, then the outline group treats `data` as a
    ///     leaf in the tree, like a regular file in a file system.
    ///   - content: A table row builder that produces a row based on an
    ///     element in `data`.
    public init<DataElement>(_ data: Data, id: KeyPath<DataElement, ID>, children: KeyPath<DataElement, Data?>, @TableRowBuilder<DataElement> content: @escaping (DataElement) -> Leaf) where ID == DataElement.ID, DataElement == Data.Element { fatalError() }
}

@available(iOS 17.0, macOS 14.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension OutlineGroup : TableRowContent where ID == Data.Element.ID, Parent : TableRowContent, Parent == Leaf, Leaf == Subgroup, Data.Element == Parent.TableRowValue {

    /// The type of value represented by this table row content.
    public typealias TableRowValue = Leaf.TableRowValue

    /// The composition of content that comprise the table row content.
    public var tableRowBody: some TableRowContent { get { return stubTableRowContent() } }

    /// The type of content representing the body of this table row content.
    //public typealias TableRowBody = NeverView
}

//@available(iOS 14.0, macOS 11.0, *)
//@available(tvOS, unavailable)
//@available(watchOS, unavailable)
//extension OutlineGroup where ID == Data.Element.ID, Parent : View, Parent == Leaf, Subgroup == DisclosureGroup<Parent, OutlineSubgroupChildren>, Data.Element : Identifiable {

    /// Creates an outline group from a root data element and a key path to
    /// its children.
    ///
    /// This initializer creates an instance that uniquely identifies views
    /// across updates based on the identity of the underlying data element.
    ///
    /// All generated disclosure groups begin in the collapsed state.
    ///
    /// Make sure that the identifier of a data element only changes if you
    /// mean to replace that element with a new element, one with a new
    /// identity. If the ID of an element changes, then the content view
    /// generated from that element will lose any current state and animations.
    ///
    /// - Parameters:
    ///   - root: The root of a collection of tree-structured, identified
    ///     data.
    ///   - children: A key path to a property whose non-`nil` value gives the
    ///     children of a data element. A non-`nil` but empty value denotes an
    ///     element capable of having children that's currently childless, such
    ///     as an empty directory in a file system. On the other hand, if the
    ///     property at the key path is `nil`, then the outline group treats the
    ///     data element as a leaf in the tree, like a regular file in a file
    ///     system.
    ///   - content: A view builder that produces a content view based on a
    ///     data element.
//    public init<DataElement>(_ root: DataElement, children: KeyPath<DataElement, Data?>, @ViewBuilder content: @escaping (DataElement) -> Leaf) where ID == DataElement.ID, DataElement : Identifiable, DataElement == Data.Element { fatalError() }

    /// Creates an outline group from a collection of root data elements and
    /// a key path to its children.
    ///
    /// This initializer creates an instance that uniquely identifies views
    /// across updates based on the identity of the underlying data element.
    ///
    /// All generated disclosure groups begin in the collapsed state.
    ///
    /// Make sure that the identifier of a data element only changes if you
    /// mean to replace that element with a new element, one with a new
    /// identity. If the ID of an element changes, then the content view
    /// generated from that element will lose any current state and animations.
    ///
    /// - Parameters:
    ///   - data: A collection of tree-structured, identified data.
    ///   - children: A key path to a property whose non-`nil` value gives the
    ///     children of `data`. A non-`nil` but empty value denotes an element
    ///     capable of having children that's currently childless, such as an
    ///     empty directory in a file system. On the other hand, if the property
    ///     at the key path is `nil`, then the outline group treats `data` as a
    ///     leaf in the tree, like a regular file in a file system.
    ///   - content: A view builder that produces a content view based on an
    ///     element in `data`.
//    public init<DataElement>(_ data: Data, children: KeyPath<DataElement, Data?>, @ViewBuilder content: @escaping (DataElement) -> Leaf) where ID == DataElement.ID, DataElement : Identifiable, DataElement == Data.Element { fatalError() }
//}
//
//@available(iOS 14.0, macOS 11.0, *)
//@available(tvOS, unavailable)
//@available(watchOS, unavailable)
//extension OutlineGroup where Parent : View, Parent == Leaf, Subgroup == DisclosureGroup<Parent, OutlineSubgroupChildren> {
    
    /// Creates an outline group from a root data element, the key path to its
    /// identifier, and a key path to its children.
    ///
    /// This initializer creates an instance that uniquely identifies views
    /// across updates based on the identity of the underlying data element.
    ///
    /// All generated disclosure groups begin in the collapsed state.
    ///
    /// Make sure that the identifier of a data element only changes if you
    /// mean to replace that element with a new element, one with a new
    /// identity. If the ID of an element changes, then the content view
    /// generated from that element will lose any current state and animations.
    ///
    /// - Parameters:
    ///   - root: The root of a collection of tree-structured, identified
    ///     data.
    ///   - id: The key path to a data element's identifier.
    ///   - children: A key path to a property whose non-`nil` value gives the
    ///     children of a data element. A non-`nil` but empty value denotes an
    ///     element capable of having children that's currently childless, such
    ///     as an empty directory in a file system. On the other hand, if the
    ///     property at the key path is `nil`, then the outline group treats the
    ///     data element as a leaf in the tree, like a regular file in a file
    ///     system.
    ///   - content: A view builder that produces a content view based on a
    ///     data element.
//    public init<DataElement>(_ root: DataElement, id: KeyPath<DataElement, ID>, children: KeyPath<DataElement, Data?>, @ViewBuilder content: @escaping (DataElement) -> Leaf) where DataElement == Data.Element { fatalError() }
    
    /// Creates an outline group from a collection of root data elements, the
    /// key path to a data element's identifier, and a key path to its children.
    ///
    /// This initializer creates an instance that uniquely identifies views
    /// across updates based on the identity of the underlying data element.
    ///
    /// All generated disclosure groups begin in the collapsed state.
    ///
    /// Make sure that the identifier of a data element only changes if you
    /// mean to replace that element with a new element, one with a new
    /// identity. If the ID of an element changes, then the content view
    /// generated from that element will lose any current state and animations.
    ///
    /// - Parameters:
    ///   - data: A collection of tree-structured, identified data.
    ///   - id: The key path to a data element's identifier.
    ///   - children: A key path to a property whose non-`nil` value gives the
    ///     children of `data`. A non-`nil` but empty value denotes an element
    ///     capable of having children that's currently childless, such as an
    ///     empty directory in a file system. On the other hand, if the property
    ///     at the key path is `nil`, then the outline group treats `data` as a
    ///     leaf in the tree, like a regular file in a file system.
    ///   - content: A view builder that produces a content view based on an
    ///     element in `data`.
//    public init<DataElement>(_ data: Data, id: KeyPath<DataElement, ID>, children: KeyPath<DataElement, Data?>, @ViewBuilder content: @escaping (DataElement) -> Leaf) where DataElement == Data.Element { fatalError() }

//}

@available(iOS 14.0, macOS 11.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension OutlineGroup : View where Parent : View, Leaf : View, Subgroup : View {

    @MainActor public var body: some View { get { return stubView() } }

//    public typealias Body = some View
}

//@available(iOS 15.0, macOS 12.0, *)
//@available(tvOS, unavailable)
//@available(watchOS, unavailable)
//extension OutlineGroup where ID == Data.Element.ID, Parent : View, Parent == Leaf, Subgroup == DisclosureGroup<Parent, OutlineSubgroupChildren>, Data.Element : Identifiable {

    /// Creates an outline group from a binding to a root data element and a key
    /// path to its children.
    ///
    /// This initializer creates an instance that uniquely identifies views
    /// across updates based on the identity of the underlying data element.
    ///
    /// All generated disclosure groups begin in the collapsed state.
    ///
    /// Make sure that the identifier of a data element only changes if you
    /// mean to replace that element with a new element, one with a new
    /// identity. If the ID of an element changes, then the content view
    /// generated from that element will lose any current state and animations.
    ///
    /// - Parameters:
    ///   - root: The root of a collection of tree-structured, identified
    ///     data.
    ///   - children: A key path to a property whose non-`nil` value gives the
    ///     children of a data element. A non-`nil` but empty value denotes an
    ///     element capable of having children that's currently childless, such
    ///     as an empty directory in a file system. On the other hand, if the
    ///     property at the key path is `nil`, then the outline group treats the
    ///     data element as a leaf in the tree, like a regular file in a file
    ///     system.
    ///   - content: A view builder that produces a content view based on a
    ///     data element.
//    public init<C, E>(_ root: Binding<E>, children: WritableKeyPath<E, C?>, @ViewBuilder content: @escaping (Binding<E>) -> Leaf) where Data == Binding<C>, ID == E.ID, C : MutableCollection, C : RandomAccessCollection, E : Identifiable, E == C.Element { fatalError() }

    /// Creates an outline group from a binding to a collection of root data
    /// elements and a key path to its children.
    ///
    /// This initializer creates an instance that uniquely identifies views
    /// across updates based on the identity of the underlying data element.
    ///
    /// All generated disclosure groups begin in the collapsed state.
    ///
    /// Make sure that the identifier of a data element only changes if you
    /// mean to replace that element with a new element, one with a new
    /// identity. If the ID of an element changes, then the content view
    /// generated from that element will lose any current state and animations.
    ///
    /// - Parameters:
    ///   - data: A collection of tree-structured, identified data.
    ///   - children: A key path to a property whose non-`nil` value gives the
    ///     children of `data`. A non-`nil` but empty value denotes an element
    ///     capable of having children that's currently childless, such as an
    ///     empty directory in a file system. On the other hand, if the property
    ///     at the key path is `nil`, then the outline group treats `data` as a
    ///     leaf in the tree, like a regular file in a file system.
    ///   - content: A view builder that produces a content view based on an
    ///     element in `data`.
//    public init<C, E>(_ data: Binding<C>, children: WritableKeyPath<E, C?>, @ViewBuilder content: @escaping (Binding<E>) -> Leaf) where Data == Binding<C>, ID == E.ID, C : MutableCollection, C : RandomAccessCollection, E : Identifiable, E == C.Element { fatalError() }
//}

//@available(iOS 15.0, macOS 12.0, *)
//@available(tvOS, unavailable)
//@available(watchOS, unavailable)
//extension OutlineGroup where Parent : View, Parent == Leaf, Subgroup == DisclosureGroup<Parent, OutlineSubgroupChildren> {

    /// Creates an outline group from a binding to a root data element, the key
    /// path to its identifier, and a key path to its children.
    ///
    /// This initializer creates an instance that uniquely identifies views
    /// across updates based on the identity of the underlying data element.
    ///
    /// All generated disclosure groups begin in the collapsed state.
    ///
    /// Make sure that the identifier of a data element only changes if you
    /// mean to replace that element with a new element, one with a new
    /// identity. If the ID of an element changes, then the content view
    /// generated from that element will lose any current state and animations.
    ///
    /// - Parameters:
    ///   - root: The root of a collection of tree-structured, identified
    ///     data.
    ///   - id: The key path to a data element's identifier.
    ///   - children: A key path to a property whose non-`nil` value gives the
    ///     children of a data element. A non-`nil` but empty value denotes an
    ///     element capable of having children that's currently childless, such
    ///     as an empty directory in a file system. On the other hand, if the
    ///     property at the key path is `nil`, then the outline group treats the
    ///     data element as a leaf in the tree, like a regular file in a file
    ///     system.
    ///   - content: A view builder that produces a content view based on a
    ///     data element.
//    public init<C, E>(_ root: Binding<E>, id: KeyPath<E, ID>, children: WritableKeyPath<E, C?>, @ViewBuilder content: @escaping (Binding<E>) -> Leaf) where Data == Binding<C>, C : MutableCollection, C : RandomAccessCollection, E == C.Element { fatalError() }

    /// Creates an outline group from a binding to a collection of root data
    /// elements, the key path to a data element's identifier, and a key path to
    /// its children.
    ///
    /// This initializer creates an instance that uniquely identifies views
    /// across updates based on the identity of the underlying data element.
    ///
    /// All generated disclosure groups begin in the collapsed state.
    ///
    /// Make sure that the identifier of a data element only changes if you
    /// mean to replace that element with a new element, one with a new
    /// identity. If the ID of an element changes, then the content view
    /// generated from that element will lose any current state and animations.
    ///
    /// - Parameters:
    ///   - data: A collection of tree-structured, identified data.
    ///   - id: The key path to a data element's identifier.
    ///   - children: A key path to a property whose non-`nil` value gives the
    ///     children of `data`. A non-`nil` but empty value denotes an element
    ///     capable of having children that's currently childless, such as an
    ///     empty directory in a file system. On the other hand, if the property
    ///     at the key path is `nil`, then the outline group treats `data` as a
    ///     leaf in the tree, like a regular file in a file system.
    ///   - content: A view builder that produces a content view based on an
    ///     element in `data`.
//    public init<C, E>(_ data: Binding<C>, id: KeyPath<E, ID>, children: WritableKeyPath<E, C?>, @ViewBuilder content: @escaping (Binding<E>) -> Leaf) where Data == Binding<C>, C : MutableCollection, C : RandomAccessCollection, E == C.Element { fatalError() }
//}

/// A type-erased view representing the children in an outline subgroup.
///
/// ``OutlineGroup`` uses this type as a generic constraint for the `Content`
/// of the ``DisclosureGroup`` instances it creates.
@available(iOS 14.0, macOS 11.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
public struct OutlineSubgroupChildren : View {

    public typealias Body = NeverView
    public var body: Body { fatalError() }
}
*/
