// Copyright © 2024 Brent Tunnicliff <brent@tunnicliff.dev>

import AOCHelper
import Testing

struct CompassDirectionTests {
    @Test(arguments: [
        (CompassDirection.east, CompassDirection.west),
        (CompassDirection.north, CompassDirection.south),
        (CompassDirection.south, CompassDirection.north),
        (CompassDirection.west, CompassDirection.east),
    ])
    func testOpposite(input: CompassDirection, expectedResult: CompassDirection) {
        #expect(input.opposite == expectedResult)
    }

    @Test(arguments: [
        (CompassDirection.east, CompassDirection.north),
        (CompassDirection.north, CompassDirection.west),
        (CompassDirection.south, CompassDirection.east),
        (CompassDirection.west, CompassDirection.south),
    ])
    func testTurnLeft(input: CompassDirection, expectedResult: CompassDirection) {
        #expect(input.turnLeft == expectedResult)
    }

    @Test(arguments: [
        (CompassDirection.east, CompassDirection.south),
        (CompassDirection.north, CompassDirection.east),
        (CompassDirection.south, CompassDirection.west),
        (CompassDirection.west, CompassDirection.north),
    ])
    func testTurnRight(input: CompassDirection, expectedResult: CompassDirection) {
        #expect(input.turnRight == expectedResult)
    }
}
