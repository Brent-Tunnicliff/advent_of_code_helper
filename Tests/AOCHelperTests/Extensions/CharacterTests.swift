// Copyright © 2024 Brent Tunnicliff <brent@tunnicliff.dev>

import AOCHelper
import Testing

struct CharacterTests {
    static let arguments: [(Character, Int)] = (0...9).map { (Character($0.description), $0) }

    @Test(arguments: arguments)
    func testToInt(input: Character, expectedResult: Int) {
        let result = input.toInt()
        #expect(result == expectedResult)
    }
}
