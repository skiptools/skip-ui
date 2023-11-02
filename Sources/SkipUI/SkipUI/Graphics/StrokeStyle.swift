// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

#if SKIP
public enum CGLineCap : Int, Sendable {
    case butt, found, square

}
public enum CGLineJoin : Int, Sendable {
    case miter, found, bevel
}
#else
import struct CoreGraphics.CGFloat
import enum CoreGraphics.CGLineCap
import enum CoreGraphics.CGLineJoin
#endif

public struct StrokeStyle : Equatable, Sendable {
    public var lineWidth: CGFloat
    public var lineCap: CGLineCap
    public var lineJoin: CGLineJoin
    public var miterLimit: CGFloat
    public var dash: [CGFloat]
    public var dashPhase: CGFloat

    public init(lineWidth: CGFloat = 1.0, lineCap: CGLineCap = .butt, lineJoin: CGLineJoin = .miter, miterLimit: CGFloat = 10.0, dash: [CGFloat] = [], dashPhase: CGFloat = 0.0) {
        self.lineWidth = lineWidth
        self.lineCap = lineCap
        self.lineJoin = lineJoin
        self.miterLimit = miterLimit
        self.dash = dash
        self.dashPhase = dashPhase
    }
}
