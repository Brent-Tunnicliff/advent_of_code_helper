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
        (.east, 20, Coordinates(x: 21, y: 2)),
        (.east, -20, Coordinates(x: -19, y: 2)),
        (.north, 1, Coordinates(x: 1, y: 1)),
        (.north, 20, Coordinates(x: 1, y: -18)),
        (.north, -20, Coordinates(x: 1, y: 22)),
        (.south, 1, Coordinates(x: 1, y: 3)),
        (.south, 20, Coordinates(x: 1, y: 22)),
        (.south, -20, Coordinates(x: 1, y: -18)),
        (.west, 1, Coordinates(x: 0, y: 2)),
        (.west, 20, Coordinates(x: -19, y: 2)),
        (.west, -20, Coordinates(x: 21, y: 2)),
    ])
    func testNext(direction: CompassDirection, distance: Int, expectedResult: Coordinates) {
        let startingPosition = Coordinates(x: 1, y: 2)
        let result = startingPosition.next(in: direction, distance: distance)
        #expect(result == expectedResult)
    }

    @Test(arguments: [
        ((CompassDirection.north, CompassDirection.east), 1, Coordinates(x: 2, y: 1)),
        ((.north, .east), 5, Coordinates(x: 6, y: -3)),
        ((.east, .north), 1, Coordinates(x: 2, y: 1)),
        ((.east, .north), 5, Coordinates(x: 6, y: -3)),

        ((.south, .east), 1, Coordinates(x: 2, y: 3)),
        ((.south, .east), 5, Coordinates(x: 6, y: 7)),
        ((.east, .south), 1, Coordinates(x: 2, y: 3)),
        ((.east, .south), 5, Coordinates(x: 6, y: 7)),

        ((.north, .west), 1, Coordinates(x: 0, y: 1)),
        ((.north, .west), 5, Coordinates(x: -4, y: -3)),
        ((.west, .north), 1, Coordinates(x: 0, y: 1)),
        ((.west, .north), 5, Coordinates(x: -4, y: -3)),

        ((.south, .west), 1, Coordinates(x: 0, y: 3)),
        ((.south, .west), 5, Coordinates(x: -4, y: 7)),
        ((.west, .south), 1, Coordinates(x: 0, y: 3)),
        ((.west, .south), 5, Coordinates(x: -4, y: 7)),
    ])
    func testNextDiagonal(direction: (CompassDirection, CompassDirection), distance: Int, expectedResult: Coordinates) {
        let startingPosition = Coordinates(x: 1, y: 2)
        let result = startingPosition.next(in: direction, distance: distance)
        #expect(result == expectedResult)
    }
}
