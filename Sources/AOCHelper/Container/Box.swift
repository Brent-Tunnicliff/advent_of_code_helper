// Copyright © 2024 Brent Tunnicliff <brent@tunnicliff.dev>

public final class Box<Value: CoordinatesType & Sendable>: Sendable {
    public let corners: [Value]
    public let lines: [Line<Value>]

    private init(_ corners: [Value], _ lines: [Line<Value>]) {
        self.corners = corners
        self.lines = lines
    }
}

// MARK: - CustomStringConvertible

extension Box: CustomStringConvertible {
    public var description: String {
        lines.description
    }
}

// MARK: - Equatable

extension Box: Equatable {
    public static func == (lhs: Box<Value>, rhs: Box<Value>) -> Bool {
        lhs.corners == rhs.corners && lhs.lines == rhs.lines
    }
}

// MARK: - Equatable

extension Box: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(corners)
        hasher.combine(lines)
    }
}

// MARK: - Coordinates

public extension Box where Value == Coordinates {
    convenience init(bottomLeft: Value, bottomRight: Value, topLeft: Value, topRight: Value) {
        let lines: [Line<Value>] = [
            .init(from: bottomLeft, to: bottomRight),
            .init(from: bottomLeft, to: topLeft),
            .init(from: bottomRight, to: topRight),
            .init(from: topLeft, to: topRight),
        ]

        self.init([bottomLeft, bottomRight, topLeft, topRight], lines)
    }

    func contains(_ coordinates: Value) -> Bool {
        let boxXValues = corners.map(\.x)
        let boxYValues = corners.map(\.y)

        let isWithX = (boxXValues.min()!...boxXValues.max()!).contains(coordinates.x)
        let isWithY = (boxYValues.min()!...boxYValues.max()!).contains(coordinates.y)

        return isWithX && isWithY
    }
}
