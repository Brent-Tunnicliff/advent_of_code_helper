// Copyright © 2024 Brent Tunnicliff <brent@tunnicliff.dev>

import Testing

@testable import AOCHelper

struct LineTests {
    @Test(arguments: [
        (
            Line(
                from: Coordinates(x: 16, y: 16),
                to: Coordinates(x: 20, y: 20)
            ),
            Coordinates(x: 80, y: 80)
        ),
        (
            Line(
                from: Coordinates(x: 19, y: 13),
                to: Coordinates(x: 17, y: 14)
            ),
            Coordinates(x: -61, y: 53)
        ),
    ])
    func lineExtending(_ argument: (line: Line<Coordinates>, expectedToResult: Coordinates)) async throws {
        // given
        let box = Box(
            bottomLeft: .init(x: 7, y: 7),
            bottomRight: .init(x: 27, y: 7),
            topLeft: .init(x: 7, y: 27),
            topRight: .init(x: 27, y: 27)
        )

        // when
        let result = argument.line.extending(within: box)

        // then
        #expect(result.from == argument.line.from)
        #expect(result.to.x == argument.expectedToResult.x)
        #expect(result.to.y == argument.expectedToResult.y)
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
    func testOverlapLine(input: CoordinatesOverlapLineInput) async throws {
        let result = input.lineOne.overlaps(input.lineTwo)
        #expect(result == input.expectedResult)
    }

    struct CoordinatesOverlapLineInput {
        let lineOne: Line<Coordinates>
        let lineTwo: Line<Coordinates>
        let expectedResult: Coordinates?
    }
}
