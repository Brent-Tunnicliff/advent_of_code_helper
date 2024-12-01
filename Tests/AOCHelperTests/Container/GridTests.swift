// Copyright © 2024 Brent Tunnicliff <brent@tunnicliff.dev>

import AOCHelper
import Testing

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
    func testDescription() {
        // when
        let result = TestGrid(data: testData).description

        // then
        #expect(result == testData)
    }

    @Test
    func testBottomLeft() {
        // when
        let result = TestGrid(data: testData).bottomLeft

        // then
        #expect(result.x == 0)
        #expect(result.y == 9)
    }

    @Test
    func testBottomRight() {
        // when
        let result = TestGrid(data: testData).bottomRight

        // then
        #expect(result.x == 9)
        #expect(result.y == 9)
    }

    @Test
    func testTopLeft() {
        // when
        let result = TestGrid(data: testData).topLeft

        // then
        #expect(result.x == 0)
        #expect(result.y == 0)
    }

    @Test
    func testTopRight() {
        // when
        let result = TestGrid(data: testData).topRight

        // then
        #expect(result.x == 9)
        #expect(result.y == 0)
    }

    @Test
    func testGetCoordinatesEastInvalid() {
        // when
        let result = TestGrid(data: testData).getCoordinates(from: .init(x: 9, y: 9), direction: .east)

        // then
        #expect(result == nil)
    }

    @Test
    func testGetCoordinatesEastValid() {
        // when
        let result = TestGrid(data: testData).getCoordinates(from: .init(x: 0, y: 0), direction: .east)

        // then
        #expect(result?.x == 1)
        #expect(result?.y == 0)
    }

    @Test
    func testGetCoordinatesNorthInvalid() {
        // when
        let result = TestGrid(data: testData).getCoordinates(from: .init(x: 0, y: 0), direction: .north)

        // then
        #expect(result == nil)
    }

    @Test
    func testGetCoordinatesNorthValid() {
        // when
        let result = TestGrid(data: testData).getCoordinates(from: .init(x: 9, y: 9), direction: .north)

        // then
        #expect(result?.x == 9)
        #expect(result?.y == 8)
    }

    @Test
    func testGetCoordinatesSouthInvalid() {
        // when
        let result = TestGrid(data: testData).getCoordinates(from: .init(x: 9, y: 9), direction: .south)

        // then
        #expect(result == nil)
    }

    @Test
    func testGetCoordinatesSouthValid() {
        // when
        let result = TestGrid(data: testData).getCoordinates(from: .init(x: 0, y: 0), direction: .south)

        // then
        #expect(result?.x == 0)
        #expect(result?.y == 1)
    }

    @Test
    func testGetCoordinatesWestInvalid() {
        // when
        let result = TestGrid(data: testData).getCoordinates(from: .init(x: 0, y: 0), direction: .west)

        // then
        #expect(result == nil)
    }

    @Test
    func testGetCoordinatesWest() {
        // when
        let result = TestGrid(data: testData).getCoordinates(from: .init(x: 9, y: 9), direction: .west)

        // then
        #expect(result?.x == 8)
        #expect(result?.y == 9)
    }

    @Test(arguments: [
        (Coordinates(x: 3, y: 0), "1"),
        (Coordinates(x: 6, y: 4), "2"),
        (Coordinates(x: 7, y: 7), "."),
        (Coordinates(x: 50, y: 50), nil),
    ])
    func testSubscript(key: Coordinates, expectedResult: String?) {
        let grid = TestGrid(data: testData)
        #expect(grid[key]?.description == expectedResult)
    }

    @Test(arguments: [
        // Adding to an empty grid
        (
            TestGrid(),
            [Coordinates.zeroZero: Value.empty, .threeZero: Value.one],
            TestGrid(values: [Coordinates.zeroZero: Value.empty, .threeZero: .one]),
            false
        ),
        // Adding to a grid with conflicts, no override ignores the conflict but still adds the new.
        (
            TestGrid(values: [.zeroZero: .empty]),
            [.zeroZero: .two, .threeZero: .one],
            TestGrid(values: [.zeroZero: .empty, .threeZero: .one]),
            false
        ),
        // Adding to a grid with conflicts, with override adds all new values.
        (
            TestGrid(values: [.zeroZero: .empty]),
            [.zeroZero: .two, .threeZero: .one],
            TestGrid(values: [.zeroZero: .two, .threeZero: .one]),
            true
        ),
    ])
    func testAdding(
        grid: TestGrid,
        adding: [Coordinates: Value],
        expectedResult: TestGrid,
        overrideExisting: Bool
    ) {
        let result = grid.adding(adding, overrideExisting: overrideExisting)
        #expect(result == expectedResult)
    }

    @Test
    func testRemovingKeys() {
        let initialGrid = TestGrid(data: testData)
        let keysToRemove: [Coordinates] = [.zeroZero, .threeZero, .sixFour]
        let result = initialGrid.removing(keys: keysToRemove)

        #expect(result.values.count == initialGrid.values.count - keysToRemove.count)

        for key in keysToRemove {
            let comment = Comment(stringLiteral: key.description)
            #expect(initialGrid[key] != nil, comment)
            #expect(result[key] == nil, comment)
        }
    }

    @Test
    func testRemovingValue() {
        let expectedResult = TestGrid(values: [
            Coordinates(x: 3, y: 0): .one,
            Coordinates(x: 7, y: 1): .two,
            Coordinates(x: 0, y: 2): .one,
            Coordinates(x: 6, y: 4): .two,
            Coordinates(x: 1, y: 5): .one,
            Coordinates(x: 9, y: 6): .one,
            Coordinates(x: 7, y: 8): .two,
            Coordinates(x: 0, y: 9): .two,
            Coordinates(x: 4, y: 9): .one,
        ])
        let initialGrid = TestGrid(data: testData)
        let result = initialGrid.removing(value: .empty)
        #expect(result == expectedResult)
    }
}

private extension Coordinates {
    static let zeroZero = Coordinates(x: 0, y: 0)
    static let threeZero = Coordinates(x: 3, y: 0)
    static let sixFour = Coordinates(x: 6, y: 4)
    static let seven = Coordinates(x: 7, y: 7)
    static let fiftyFifty = Coordinates(x: 50, y: 50)
}

extension GridTests {
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
