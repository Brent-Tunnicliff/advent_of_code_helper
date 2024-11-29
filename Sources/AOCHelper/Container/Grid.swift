// Copyright © 2024 Brent Tunnicliff <brent@tunnicliff.dev>

import Foundation

// MARK: - Grid

public typealias GridKeyType = CoordinatesType & Sendable
public typealias GridValueType = CustomStringConvertible & Sendable & Hashable

// Using class because grid can be large and tends to be passed around a lot.
// In 2023 Advent of Code I found using recursion and priority lists a bunch, so passing around a reference
// instead of copying all the data can significantly reduce memory use without needing workarounds.
// Lets see how this goes for 2024.
public final class Grid<Key: GridKeyType, Value: GridValueType>: Sendable {
    public let values: [Key: Value]

    public subscript(key: Key) -> Value? {
        get { values[key] }
    }

    public init() {
        self.values = [:]
    }

    public init(values: [Key: Value]) {
        self.values = values
    }

    /// Returns copy that adds all the input values.
    ///
    /// Defaults to overriding any existing values with the new inputs.
    public func adding(
        _ newValues: [Key: Value],
        overrideExisting: Bool = true
    ) -> Grid<Key, Value> {
        Grid(
            values: values.merging(newValues, uniquingKeysWith: { current, new in
                overrideExisting ? new : current
            })
        )
    }

    /// Returns copy that removed all occurrences of input keys.
    public func removing(keys: [Key]) -> Grid<Key, Value> {
        var newValues = self.values
        for key in keys {
            newValues[key] = nil
        }

        return Grid(values: newValues)
    }

    /// Returns copy that removed all occurrences equal to the value input.
    public func removing(value: Value) -> Grid {
        Grid(values: values.filter { $0.value != value })
    }
}

// MARK: CustomStringConvertible

extension Grid: CustomStringConvertible {
    public var description: String {
        String(
            values.keys.reduce(into: [Int: [Int: String]]()) { partialResult, coordinates in
                if partialResult[coordinates.y] == nil {
                    partialResult[coordinates.y] = [:]
                }

                partialResult[coordinates.y]![coordinates.x] = values[coordinates]!.description
            }
            .map { $0 }
            .sorted(by: { $0.key < $1.key })
            .reduce(into: "") { partialResult, item in
                for character in item.value.sorted(by: { $0.key < $1.key }) {
                    partialResult += character.value
                }

                partialResult += "\n"
            }
            .dropLast()
        )
    }
}

// MARK: - Equatable

extension Grid: Equatable {
    public static func == (lhs: Grid<Key, Value>, rhs: Grid<Key, Value>) -> Bool {
        lhs.values == rhs.values
    }
}

// MARK: - Hashable

extension Grid: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(values)
    }
}

// MARK: Positions

public extension Grid {
    var bottomLeft: Coordinates {
        .init(x: minX, y: maxY)
    }

    var bottomRight: Coordinates {
        .init(x: maxX, y: maxY)
    }

    var topLeft: Coordinates {
        .init(x: minX, y: minY)
    }

    var topRight: Coordinates {
        .init(x: maxX, y: minY)
    }

    private var minX: Int {
        self.values.keys.map(\.x).min()!
    }

    private var minY: Int {
        self.values.keys.map(\.y).min()!
    }

    private var maxX: Int {
        self.values.keys.map(\.x).max()!
    }

    private var maxY: Int {
        self.values.keys.map(\.y).max()!
    }
}

// MARK: - Coordinates

public extension Grid where Key == Coordinates {
    convenience init(data: String, separator: String = "\n", valueMapper: (String) -> Value) {
        let values = data.split(separator: separator)
            .enumerated()
            .reduce(into: [Key: Value]()) { partialResult, item in
                let (y, line) = item
                for (x, value) in line.enumerated() {
                    partialResult[.init(x: x, y: y)] = valueMapper(String(value))
                }
            }

        self.init(values: values)
    }
}

public extension Grid where Key == Coordinates {
    func getCoordinates(from: Key, direction: CompassDirection) -> Key? {
        let coordinates = from.next(in: direction)
        return values.keys.contains(coordinates) ? coordinates : nil
    }
}

public extension Grid where Key == Coordinates, Value: CaseIterable {
    convenience init(data: String) {
        self.init(data: data) { value in
            Value.allCases.first(where: { $0.description == value })!
        }
    }
}

public extension Grid where Key == Coordinates, Value == Int {
    convenience init(data: String) {
        self.init(data: data) { Int($0)! }
    }
}

public extension Grid where Key == Coordinates, Value == String {
    convenience init(data: String) {
        self.init(data: data) { $0 }
    }
}
