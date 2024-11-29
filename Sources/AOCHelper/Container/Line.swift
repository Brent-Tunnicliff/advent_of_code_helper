// Copyright © 2024 Brent Tunnicliff <brent@tunnicliff.dev>

import simd

public final class Line<Value: CoordinatesType & Sendable>: Sendable {
    public let from: Value
    public let to: Value

    public init(from: Value, to: Value) {
        self.from = from
        self.to = to
    }
}

// MARK: - CustomStringConvertible

extension Line: CustomStringConvertible {
    public var description: String {
        "(\(from.description))-(\(to.description))"
    }
}

// MARK: - Equatable

extension Line: Equatable {
    public static func == (lhs: Line<Value>, rhs: Line<Value>) -> Bool {
        lhs.from == rhs.from && lhs.to == rhs.to
    }
}

// MARK: - Hashable

extension Line: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(from)
        hasher.combine(to)
    }
}

// MARK: - Coordinates

public extension Line where Value == Coordinates {
    /// Extends line length to be within the box.
    ///
    /// Since this is using Int instead of Double the accuracy isn't great, but should be good enough.
    func extending(within box: Box<Value>) -> Line? {
        let boxX = box.corners.map(\.x)
        let boxY = box.corners.map(\.y)

        let boxWidth = boxX.max()! - boxX.min()!
        let boxHeight = boxY.max()! - boxY.min()!

        // Found solution here https://stackoverflow.com/a/17761763.
        // AC - we are using a much larger length than the box borders so it is a little more accurate with Ints
        let length = (boxWidth + boxHeight) * 2
        // AB = sqrt( (Xb - Xa)² + (Yb - Ya)² )
        let lengthOfLine = Int(sqrt(pow(Double(to.x - from.x), 2.0) + pow(Double(to.y - from.y), 2.0)))
        // Xc = Xa + (AC * (Xb - Xa) / AB)
        let newToX = from.x + (length * (to.x - from.x)) / lengthOfLine
        // Yc = Ya + (AC * (Yb - Ya) / AB)
        let newToY = from.y + (length * (to.y - from.y)) / lengthOfLine
        let longLine = Line(
            from: from,
            to: Coordinates(x: Int(newToX), y: Int(newToY))
        )

        // Now lets cut that line at the box border.
        // Making sure it is unique otherwise if the intersection is at a corner then it will appear from two lines.
        let intersectingCoordinates = box.lines
            .compactMap {
                $0.overlaps(longLine)
            }
            .toUnique()

        guard let first = intersectingCoordinates.first else {
            return nil
        }

        // If only one value, return it
        guard intersectingCoordinates.count > 1 else {
            return Line(from: from, to: first)
        }

        // This method currently only supports rectangle-like shapes.
        // It cannot account for entering and exiting the shape multiple times.
        guard intersectingCoordinates.count == 2 else {
            fatalError("Method only currently supports rectangle like shapes as the box.")
        }

        // Otherwise, work out which line is closest.
        let finalTo = getClosestPoint(to: longLine.to, in: intersectingCoordinates)!

        // If there are two, then lets also trim the from
        let finalFrom = getClosestPoint(to: longLine.from, in: intersectingCoordinates.filter { $0 != finalTo })!

        guard finalTo != finalFrom else {
            fatalError("Unexpected result, from and to are same value.")
        }

        return Line(from: finalFrom, to: finalTo)
    }

    // Solution found here https://stackoverflow.com/a/45931831.
    func overlaps(_ other: Line) -> Value? {
        let p1 = from.simdValue
        let p2 = to.simdValue
        let p3 = other.from.simdValue
        let p4 = other.to.simdValue

        let matrix = simd_double2x2(p4 - p3, p1 - p2)
        guard matrix.determinant != 0 else {
            // Determinent == 0 => parallel lines
            return nil
        }

        let multipliers = matrix.inverse * (p1 - p3)

        // If either of the multipliers is outside the range 0 ... 1, then the
        // intersection would be off the end of one of the line segments.
        guard
            (0.0...1.0).contains(multipliers.x),
            (0.0...1.0).contains(multipliers.y)
        else {
            return nil
        }

        let result = p1 + multipliers.y * (p2 - p1)

        // Will converting double back to int cause issues?
        return .init(
            x: Int(result.x),
            y: Int(result.y)
        )
    }

    private func getClosestPoint(to coordinate: Value, in intersectingCoordinates: [Coordinates]) -> Value? {
        intersectingCoordinates
            .map {
                let xDifference = max($0.x, coordinate.x) - min($0.x, coordinate.x)
                let yDifference = max($0.y, coordinate.y) - min($0.y, coordinate.y)
                return (coordinates: $0, difference: xDifference + yDifference)
            }
            .min {
                $0.difference < $1.difference
            }
            .map(\.coordinates)
    }
}

private extension Coordinates {
    var simdValue: simd_double2 {
        .init(x: Double(x), y: Double(y))
    }
}

// MARK: - ThreeDimensionalCoordinates

public extension Line where Value == ThreeDimensionalCoordinates {
    /// Ignores the z axis and returns a line between x and y.
    var twoDimensionalLine: Line<Coordinates> {
        .init(from: from.twoDimensional, to: to.twoDimensional)
    }
}
