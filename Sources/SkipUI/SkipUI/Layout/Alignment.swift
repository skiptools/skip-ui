// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

public struct Alignment : Equatable {
    public var horizontal: HorizontalAlignment
    public var vertical: VerticalAlignment
}

extension Alignment {
    public static let center = Alignment(horizontal: .center, vertical: .center)
    public static let leading = Alignment(horizontal: .leading, vertical: .center)
    public static let trailing = Alignment(horizontal: .trailing, vertical: .center)
    public static let top = Alignment(horizontal: .center, vertical: .top)
    public static let bottom = Alignment(horizontal: .leading, vertical: .bottom)
    public static let topLeading = Alignment(horizontal: .leading, vertical: .top)
    public static let topTrailing = Alignment(horizontal: .trailing, vertical: .top)
    public static let bottomLeading = Alignment(horizontal: .leading, vertical: .bottom)
    public static let bottomTrailing = Alignment(horizontal: .trailing, vertical: .bottom)
}

extension Alignment {
    public static var centerFirstTextBaseline = Alignment(horizontal: .center, vertical: .firstTextBaseline)
    public static var centerLastTextBaseline = Alignment(horizontal: .center, vertical: .lastTextBaseline)
    public static var leadingFirstTextBaseline = Alignment(horizontal: .leading, vertical: .firstTextBaseline)
    public static var leadingLastTextBaseline = Alignment(horizontal: .leading, vertical: .lastTextBaseline)
    public static var trailingFirstTextBaseline = Alignment(horizontal: .trailing, vertical: .firstTextBaseline)
    public static var trailingLastTextBaseline = Alignment(horizontal: .trailing, vertical: .lastTextBaseline)
}

extension Alignment : Sendable {
}
