// Copyright © 2024 Brent Tunnicliff <brent@tunnicliff.dev>

import Testing

@testable import AOCHelper

struct GridTests {
    private let testData = """
        ...1......
        .......2..
        1.........
        ..........
        ......2...
        .1........
        .........1
        ..........
        .......2..
        2...1.....
        """

    @Test
    func testDescription() throws {
        // when
        let result = TestGrid(data: testData).description

        // then
        #expect(result == testData)
    }

    @Test
    func testBottomLeft() throws {
        // when
        let result = TestGrid(data: testData).bottomLeft

        // then
        #expect(result.x == 0)
        #expect(result.y == 9)
    }

    @Test
    func testBottomRight() throws {
        // when
        let result = TestGrid(data: testData).bottomRight

        // then
        #expect(result.x == 9)
        #expect(result.y == 9)
    }

    @Test
    func testTopLeft() throws {
        // when
        let result = TestGrid(data: testData).topLeft

        // then
        #expect(result.x == 0)
        #expect(result.y == 0)
    }

    @Test
    func testTopRight() throws {
        // when
        let result = TestGrid(data: testData).topRight

        // then
        #expect(result.x == 9)
        #expect(result.y == 0)
    }

    @Test
    func testGetCoordinatesEastInvalid() throws {
        // when
        let result = TestGrid(data: testData).getCoordinates(from: .init(x: 9, y: 9), direction: .east)

        // then
        #expect(result == nil)
    }

    @Test
    func testGetCoordinatesEastValid() throws {
        // when
        let result = TestGrid(data: testData).getCoordinates(from: .init(x: 0, y: 0), direction: .east)

        // then
        #expect(result?.x == 1)
        #expect(result?.y == 0)
    }

    @Test
    func testGetCoordinatesNorthInvalid() throws {
        // when
        let result = TestGrid(data: testData).getCoordinates(from: .init(x: 0, y: 0), direction: .north)

        // then
        #expect(result == nil)
    }

    @Test
    func testGetCoordinatesNorthValid() throws {
        // when
        let result = TestGrid(data: testData).getCoordinates(from: .init(x: 9, y: 9), direction: .north)

        // then
        #expect(result?.x == 9)
        #expect(result?.y == 8)
    }

    @Test
    func testGetCoordinatesSouthInvalid() throws {
        // when
        let result = TestGrid(data: testData).getCoordinates(from: .init(x: 9, y: 9), direction: .south)

        // then
        #expect(result == nil)
    }

    @Test
    func testGetCoordinatesSouthValid() throws {
        // when
        let result = TestGrid(data: testData).getCoordinates(from: .init(x: 0, y: 0), direction: .south)

        // then
        #expect(result?.x == 0)
        #expect(result?.y == 1)
    }

    @Test
    func testGetCoordinatesWestInvalid() throws {
        // when
        let result = TestGrid(data: testData).getCoordinates(from: .init(x: 0, y: 0), direction: .west)

        // then
        #expect(result == nil)
    }

    @Test
    func testGetCoordinatesWest() throws {
        // when
        let result = TestGrid(data: testData).getCoordinates(from: .init(x: 9, y: 9), direction: .west)

        // then
        #expect(result?.x == 8)
        #expect(result?.y == 9)
    }
}

private extension GridTests {
    typealias TestGrid = Grid<Coordinates, Value>
    enum Value: String, CustomStringConvertible, CaseIterable {
        case empty = "."
        case one = "1"
        case two = "2"

        var description: String {
            rawValue
        }
    }
}
