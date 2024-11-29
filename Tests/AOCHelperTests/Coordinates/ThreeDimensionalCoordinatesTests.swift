// Copyright © 2024 Brent Tunnicliff <brent@tunnicliff.dev>

import Testing

@testable import AOCHelper

struct ThreeDimensionalCoordinatesTests {
    @Test
    func testEquatable() {
        let value = ThreeDimensionalCoordinates(x: 1, y: 2, z: 3)
        let otherValue = ThreeDimensionalCoordinates(x: 1, y: 2, z: 3)
        #expect(value == otherValue)
    }

    @Test
    func testDescription() {
        #expect(ThreeDimensionalCoordinates(x: 124, y: -21, z: 26).description == "124,-21,26")
    }

    @Test
    func testTwoDimensional() {
        let startingPosition = ThreeDimensionalCoordinates(x: 1, y: 2, z: 3)
        let result = startingPosition.twoDimensional
        #expect(result == Coordinates(x: 1, y: 2))
    }
}
