// Copyright © 2024 Brent Tunnicliff <brent@tunnicliff.dev>

/// Simple 2D coordinates.
public final class Coordinates: CoordinatesType {
    public let x: Int
    public let y: Int

    public init(x: Int, y: Int) {
        self.x = x
        self.y = y
    }
}

// MARK: - Equatable

extension Coordinates: Equatable {
    public static func == (lhs: Coordinates, rhs: Coordinates) -> Bool {
        lhs.x == rhs.x && lhs.y == rhs.y
    }
}

// MARK: - Hashable

extension Coordinates: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(x)
        hasher.combine(y)
    }
}

// MARK:

public extension Coordinates {
    func next(in direction: CompassDirection, distance: Int = 1) -> Coordinates {
        switch direction {
        case .east: .init(x: x + distance, y: y)
        case .north: .init(x: x, y: y - distance)
        case .south: .init(x: x, y: y + distance)
        case .west: .init(x: x - distance, y: y)
        }
    }
}

extension Coordinates: CustomStringConvertible {
    public var description: String {
        "\(x),\(y)"
    }
}
