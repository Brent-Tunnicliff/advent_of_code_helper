// Copyright © 2024 Brent Tunnicliff <brent@tunnicliff.dev>

import AOCHelper
import Testing

struct CoordinatesTests {
    @Test
    func testEquatable() {
        let value = Coordinates(x: 1, y: 2)
        let otherValue = Coordinates(x: 1, y: 2)
        #expect(value == otherValue)
    }

    @Test
    func testDescription() {
        #expect(Coordinates(x: 124, y: -21).description == "124,-21")
    }

    @Test(arguments: [
        (CompassDirection.east, 1, Coordinates(x: 2, y: 2)),
        (CompassDirection.east, 20, Coordinates(x: 21, y: 2)),
        (CompassDirection.east, -20, Coordinates(x: -19, y: 2)),
        (CompassDirection.north, 1, Coordinates(x: 1, y: 1)),
        (CompassDirection.north, 20, Coordinates(x: 1, y: -18)),
        (CompassDirection.north, -20, Coordinates(x: 1, y: 22)),
        (CompassDirection.south, 1, Coordinates(x: 1, y: 3)),
        (CompassDirection.south, 20, Coordinates(x: 1, y: 22)),
        (CompassDirection.south, -20, Coordinates(x: 1, y: -18)),
        (CompassDirection.west, 1, Coordinates(x: 0, y: 2)),
        (CompassDirection.west, 20, Coordinates(x: -19, y: 2)),
        (CompassDirection.west, -20, Coordinates(x: 21, y: 2)),
    ])
    func testTurnRight(direction: CompassDirection, distance: Int, expectedResult: Coordinates) {
        let startingPosition = Coordinates(x: 1, y: 2)
        let result = startingPosition.next(in: direction, distance: distance)
        #expect(result == expectedResult)
    }
}
