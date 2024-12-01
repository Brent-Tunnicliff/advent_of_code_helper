// Copyright © 2024 Brent Tunnicliff <brent@tunnicliff.dev>

public final class ThreeDimensionalCoordinates: CoordinatesType {
    public let x: Int
    public let y: Int
    public let z: Int

    public init(x: Int, y: Int, z: Int) {
        self.x = x
        self.y = y
        self.z = z
    }
}

// MARK: - CustomStringConvertible

extension ThreeDimensionalCoordinates: CustomStringConvertible {
    public var description: String {
        "\(x),\(y),\(z)"
    }
}

// MARK: - Equatable

extension ThreeDimensionalCoordinates: Equatable {
    public static func == (lhs: ThreeDimensionalCoordinates, rhs: ThreeDimensionalCoordinates) -> Bool {
        lhs.x == rhs.x && lhs.y == rhs.y && lhs.z == rhs.z
    }
}

// MARK: - Hashable

extension ThreeDimensionalCoordinates: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(x)
        hasher.combine(y)
        hasher.combine(z)
    }
}

// MARK: - Coordinates

public extension ThreeDimensionalCoordinates {
    var twoDimensional: Coordinates {
        .init(x: x, y: y)
    }
}
