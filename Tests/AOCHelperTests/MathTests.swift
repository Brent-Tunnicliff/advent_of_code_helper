// Copyright © 2024 Brent Tunnicliff <brent@tunnicliff.dev>

import AOCHelper
import Testing

struct MathTests {

    @Test(arguments: [
        (16, 20, 80),
    ])
    func testLcm(a: Int, b: Int, expectedResult: Int) async {
        #expect(Math.lcm(a, b) == expectedResult)
    }

    @Test(arguments: [
        ([16, 20], 80),
        ([16, 20, 30], 240),
        ([-7, 20, 30], -420),
    ])
    func testLcm(vector: [Int], expectedResult: Int) async {
        #expect(Math.lcm(vector) == expectedResult)
    }

    @Test(arguments: [
        (15, 10, 5),
        (128, 96, 32),
    ])
    func testGcd(a: Int, b: Int, expectedResult: Int) async {
        #expect(Math.gcd(a, b) == expectedResult)
    }

    @Test(arguments: [
        ([4, 8, 16], 4),
        ([24, 30, 36], 6),
    ])
    func testGcd(vector: [Int], expectedResult: Int) async {
        #expect(Math.gcd(vector) == expectedResult)
    }
}
