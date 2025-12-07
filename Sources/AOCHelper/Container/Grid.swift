// Copyright © 2024 Brent Tunnicliff <brent@tunnicliff.dev>

import Foundation
import Synchronization

// MARK: - GridType

public typealias GridKeyType = CoordinatesType & Sendable
public typealias GridValueType = CustomStringConvertible & Sendable & Hashable

public protocol GridType: Sendable, CustomStringConvertible, Equatable, Hashable {
    associatedtype Key: GridKeyType
    associatedtype Value: GridValueType
    associatedtype Grid: GridType = Self

    var values: [Key: Value] { get }
    subscript(key: Key) -> Value? { get }

    init(values: [Key: Value])

    /// Returns copy that adds all the input values.
    ///
    /// Defaults to overriding any existing values with the new inputs.
    func adding(_ newValues: [Key: Value]) -> Grid

    /// Returns copy that adds all the input values.
    func adding(_ newValues: [Key: Value], overrideExisting: Bool) -> Grid

    /// Returns copy that removed all occurrences of input keys.
    func removing(keys: [Key]) -> Grid

    /// Returns copy that removed all occurrences equal to the value input.
    func removing(value: Value) -> Grid
}

extension GridType where Grid.Key == Key, Grid.Value == Value {
    public init() {
        self.init(values: [:])
    }

    public func adding(_ newValues: [Key: Value]) -> Grid {
        adding(newValues, overrideExisting: true)
    }

    public func adding(_ newValues: [Key: Value], overrideExisting: Bool) -> Grid {
        Grid(
            values: values.merging(newValues, uniquingKeysWith: { current, new in
                overrideExisting ? new : current
            })
        )
    }

    public func removing(keys: [Key]) -> Grid {
        var newValues = self.values
        for key in keys {
            newValues[key] = nil
        }

        return Grid(values: newValues)
    }

    public func removing(value: Value) -> Grid {
        Grid(values: values.filter { $0.value != value })
    }

    public func toImmutableGrid() -> ImmutableGrid<Key, Value> {
        ImmutableGrid(values: values)
    }

    @available(macOS 15.0, *)
    public func toMutableGrid() -> MutableGrid<Key, Value> {
        MutableGrid(values: values)
    }
}

extension GridType {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(values)
    }
}

// MARK: - Positions

extension GridType {
    public var bottomLeft: Coordinates {
        .init(x: minX, y: maxY)
    }

    public var bottomRight: Coordinates {
        .init(x: maxX, y: maxY)
    }

    public var topLeft: Coordinates {
        .init(x: minX, y: minY)
    }

    public var topRight: Coordinates {
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

// MARK: - CustomStringConvertible

extension GridType {
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

extension GridType {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.values == rhs.values
    }

    // Allow comparing different grid types.
    public static func == <OtherGrid>(
        lhs: OtherGrid,
        rhs: Self
    ) -> Bool where OtherGrid: GridType, OtherGrid.Key == Key, OtherGrid.Value == Value {
        lhs.values == rhs.values
    }

    // Allow comparing different grid types.
    public static func != <OtherGrid>(
        lhs: OtherGrid,
        rhs: Self
    ) -> Bool where OtherGrid: GridType, OtherGrid.Key == Key, OtherGrid.Value == Value {
        lhs.values != rhs.values
    }
}

// MARK: - Coordinates

extension GridType where Key == Coordinates {
    public init(data: String, separator: String = "\n", valueMapper: (String) -> Value) {
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

extension GridType where Key == Coordinates {
    public func getCoordinates(from: Key, direction: CompassDirection) -> Key? {
        let coordinates = from.next(in: direction)
        return values.keys.contains(coordinates) ? coordinates : nil
    }
}

extension GridType where Key == Coordinates, Value: CaseIterable {
    public init(data: String) {
        self.init(data: data) { value in
            Value.allCases.first(where: { $0.description == value })!
        }
    }
}

extension GridType where Key == Coordinates, Value == Int {
    public init(data: String) {
        self.init(data: data) { Int($0)! }
    }
}

extension GridType where Key == Coordinates, Value == String {
    public init(data: String) {
        self.init(data: data) { $0 }
    }
}

// MARK: - Grid

// Mapping `ImmutableGrid` back to `Grid` for backwards compatibility.
@available(*, deprecated, renamed: "ImmutableGrid", message: "Replaced now we also have a mutable version.")
public typealias Grid = ImmutableGrid

public final class ImmutableGrid<Key: GridKeyType, Value: GridValueType>: GridType {
    public let values: [Key: Value]

    public subscript(key: Key) -> Value? {
        get { values[key] }
    }

    public init(values: [Key: Value]) {
        self.values = values
    }
}

@available(macOS 15.0, *)
public final class MutableGrid<Key: GridKeyType, Value: GridValueType>: GridType {
    public var values: [Key: Value] {
        valuesMutex.withLock { $0 }
    }

    private let valuesMutex: Mutex<[Key: Value]>

    public subscript(key: Key) -> Value? {
        get { valuesMutex.withLock { $0[key] } }
        set { valuesMutex.withLock { $0[key] = newValue } }
    }

    public init(values: [Key: Value]) {
        self.valuesMutex = Mutex(values)
    }

    /// Adds all the input values.
    ///
    /// Defaults to overriding any existing values with the new inputs.
    public func add(_ newValues: [Key: Value]) {
        add(newValues, overrideExisting: true)
    }

    /// Adds all the input values.
    public func add(_ newValues: [Key: Value], overrideExisting: Bool) {
        valuesMutex.withLock { values in
            values.merge(newValues) { old, new in
                overrideExisting ? new : old
            }
        }
    }

    /// Removes all values of all input keys.
    public func remove(keys: [Key]) {
        valuesMutex.withLock { values in
            for key in values.keys {
                values.removeValue(forKey: key)
            }
        }
    }

    /// Removes all occurrences equal to the value input.
    public func remove(value: Value) {
        valuesMutex.withLock { values in
            for element in values where element.value == value {
                values.removeValue(forKey: element.key)
            }
        }
    }
}
