// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

#if !SKIP_BRIDGE

// For our purposes, Bindable and ObservedObject act exactly the same
public typealias ObservedObject<T> = Bindable<T>

#endif
