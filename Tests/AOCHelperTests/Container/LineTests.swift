// Copyright © 2024 Brent Tunnicliff <brent@tunnicliff.dev>

import AOCHelper
import Testing

struct LineTests {
    @Test(arguments: [
        (
            Line(
                from: Coordinates(x: 16, y: 16),
                to: Coordinates(x: 20, y: 20)
            ),
            Line(
                from: Coordinates(x: 16, y: 16),
                to: Coordinates(x: 27, y: 27)
            )
        ),
        (
            Line(
                from: Coordinates(x: 19, y: 13),
                to: Coordinates(x: 17, y: 14)
            ),
            Line(
                from: Coordinates(x: 19, y: 13),
                to: Coordinates(x: 7, y: 19)
            )
        ),
        (
            Line(
                from: Coordinates(x: -72, y: -25),
                to: Coordinates(x: 72, y: 25)
            ),
            nil
        ),
        (
            Line(
                from: Coordinates(x: 0, y: 0),
                to: Coordinates(x: 5, y: 5)
            ),
            Line(
                from: Coordinates(x: 7, y: 7),
                to: Coordinates(x: 27, y: 27)
            )
        ),
    ])
    func testExtending(line: Line<Coordinates>, expectedToResult: Line<Coordinates>?) {
        // given
        let box = Box(
            bottomLeft: .init(x: 7, y: 7),
            bottomRight: .init(x: 27, y: 7),
            topLeft: .init(x: 7, y: 27),
            topRight: .init(x: 27, y: 27)
        )

        // when
        let result = line.extending(within: box)

        // then
        #expect(result == expectedToResult)
    }

    @Test(arguments: [
        CoordinatesOverlapLineInput(
            lineOne: .init(from: .init(x: 2, y: 6), to: .init(x: 5, y: 1)),
            lineTwo: .init(from: .init(x: 4, y: 0), to: .init(x: 5, y: 5)),
            expectedResult: .init(x: 4, y: 2)
        ),
        CoordinatesOverlapLineInput(
            lineOne: .init(from: .init(x: 19, y: 13), to: .init(x: 17, y: 14)),
            lineTwo: .init(from: .init(x: 7, y: 7), to: .init(x: 27, y: 27)),
            expectedResult: nil
        ),
        CoordinatesOverlapLineInput(
            lineOne: .init(from: .init(x: 0, y: 0), to: .init(x: 48, y: 48)),
            lineTwo: .init(from: .init(x: 19, y: 13), to: .init(x: -21, y: 33)),
            expectedResult: .init(x: 15, y: 15)
        ),
    ])
    func testOverlapLine(input: CoordinatesOverlapLineInput) {
        let result = input.lineOne.overlaps(input.lineTwo)
        #expect(result == input.expectedResult)
    }

    struct CoordinatesOverlapLineInput {
        let lineOne: Line<Coordinates>
        let lineTwo: Line<Coordinates>
        let expectedResult: Coordinates?
    }

    @Test
    func testDescription() {
        let line = Line(
            from: Coordinates(x: 15, y: 16),
            to: Coordinates(x: 20, y: 21)
        )
        #expect(line.description == "(15,16)-(20,21)")
    }

    @Test
    func testEquatable() {
        let lineOne = Line(
            from: Coordinates(x: 15, y: 16),
            to: Coordinates(x: 20, y: 21)
        )
        let lineTwo = Line(
            from: Coordinates(x: 15, y: 16),
            to: Coordinates(x: 20, y: 21)
        )
        #expect(lineOne == lineTwo)
    }

    @Test
    func testTwoDimensionalLine() {
        let value = Line(
            from: ThreeDimensionalCoordinates(x: 1, y: 2, z: 3),
            to: ThreeDimensionalCoordinates(x: 4, y: 5, z: 6)
        )
        let expectedResult = Line(
            from: Coordinates(x: value.from.x, y: value.from.y),
            to: Coordinates(x: value.to.x, y: value.to.y)
        )
        #expect(value.twoDimensionalLine == expectedResult)
    }
}
