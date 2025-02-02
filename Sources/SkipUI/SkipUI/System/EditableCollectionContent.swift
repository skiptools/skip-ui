// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

#if false
/// An opaque wrapper view that adds editing capabilities to a row in a list.
///
/// You don't use this type directly. Instead SkipUI creates this type on
/// your behalf.
@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
public struct EditableCollectionContent<Content, Data> {
}

@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
extension EditableCollectionContent : View where Content : View {

    @MainActor public var body: some View { get { return stubView() } }

//    public typealias Body = some View
}
#endif
