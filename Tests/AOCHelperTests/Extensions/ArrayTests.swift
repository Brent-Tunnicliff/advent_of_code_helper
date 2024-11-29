// Copyright © 2024 Brent Tunnicliff <brent@tunnicliff.dev>

import Testing

@testable import AOCHelper

struct ArrayTests {
    private let input = [1, 1, 2, 3, 2, 4, 5, 2]
    private let expectedResult = [1, 2, 3, 4, 5]

    @Test
    func testToUnique() {
        // Sorting the results as an easy way to compare.
        let result = input.toUnique().sorted()
        #expect(result == expectedResult)
    }

    @Test
    func testToUniqueMaintainOrder() {
        let result = input.toUniqueMaintainOrder()
        #expect(result == expectedResult)
    }

    @Test
    func testToSet() {
        let result = input.toSet()
        #expect(result == Set(expectedResult))
    }
}
