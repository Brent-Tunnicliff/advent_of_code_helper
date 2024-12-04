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
    /// Returns the next coordinates in a direction.
    func next(in direction: CompassDirection, distance: Int = 1) -> Coordinates {
        switch direction {
        case .east: Coordinates(x: x + distance, y: y)
        case .north: Coordinates(x: x, y: y - distance)
        case .south: Coordinates(x: x, y: y + distance)
        case .west: Coordinates(x: x - distance, y: y)
        }
    }

    /// Returns the next coordinates in a diagonal direction.
    ///
    /// Throws a fatal error if input is invalid. Invalid value is two directions that are the same, or are opposite.
    func next(in direction: (CompassDirection, CompassDirection), distance: Int = 1) -> Coordinates {
        switch (direction.0, direction.1) {
        case (.north, .east), (.east, .north):
            Coordinates(x: x + distance, y: y - distance)
        case (.north, .west), (.west, .north):
            Coordinates(x: x - distance, y: y - distance)
        case (.south, .east), (.east, .south):
            Coordinates(x: x + distance, y: y + distance)
        case (.south, .west), (.west, .south):
            Coordinates(x: x - distance, y: y + distance)
        case (.east, .east), (.north, .north), (.south, .south), (.west, .west):
            fatalError("Directions must be different values: \(direction)")
        case (.east, .west), (.north, .south), (.south, .north), (.west, .east):
            fatalError("Directions not be opposite: \(direction)")
        }
    }
}

extension Coordinates: CustomStringConvertible {
    public var description: String {
        "\(x),\(y)"
    }
}
