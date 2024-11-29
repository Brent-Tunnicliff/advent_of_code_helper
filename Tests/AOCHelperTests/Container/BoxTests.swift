// Copyright © 2024 Brent Tunnicliff <brent@tunnicliff.dev>

import Testing

@testable import AOCHelper

struct BoxTests {
    private let box = Box(
        bottomLeft: .init(x: 7, y: 7),
        bottomRight: .init(x: 27, y: 7),
        topLeft: .init(x: 7, y: 27),
        topRight: .init(x: 27, y: 27)
    )

    @Test
    func testDescription() {
        let result = box.description
        #expect(result == "[(7,7)-(27,7), (7,7)-(7,27), (27,7)-(27,27), (7,27)-(27,27)]")
    }

    @Test
    func testEquatable() {
        let otherBox = Box(
            bottomLeft: .init(x: 7, y: 7),
            bottomRight: .init(x: 27, y: 7),
            topLeft: .init(x: 7, y: 27),
            topRight: .init(x: 27, y: 27)
        )
        #expect(box == otherBox)
    }

    @Test(arguments: [
        (Coordinates(x: 0, y: 0), false),
        (Coordinates(x: 7, y: 6), false),
        (Coordinates(x: 6, y: 7), false),
        (Coordinates(x: 7, y: 7), true),
        (Coordinates(x: 16, y: 7), true),
        (Coordinates(x: 27, y: 27), true),
        (Coordinates(x: 27, y: 28), false),
        (Coordinates(x: 28, y: 27), false),
        (Coordinates(x: 273, y: 1), false),
    ])
    func testContains(coordinates: Coordinates, expectedResult: Bool) {
        #expect(box.contains(coordinates) == expectedResult)
    }
}
