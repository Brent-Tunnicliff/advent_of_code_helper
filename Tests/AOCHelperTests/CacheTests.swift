// Copyright © 2024 Brent Tunnicliff <brent@tunnicliff.dev>

import AOCHelper
import Testing

struct CacheTests {
    private let cache = Cache<Key, Int>()
    private enum Key: Hashable {
        case a, b, c
    }

    @Test
    func testCache() async {
        let value = 1
        await cache.set(value, for: .a)
        #expect(await cache.object(for: .a) == value)
        #expect(await cache.object(for: .b) == nil)
        #expect(await cache.object(for: .c) == nil)
    }
}
