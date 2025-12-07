// Copyright © 2024 Brent Tunnicliff <brent@tunnicliff.dev>

import AOCHelper
import Testing

struct CacheTests {
    private enum Key: Hashable {
        case a, b, c
    }

    @Test
    func testCache() async {
        let cache = Cache<Key, Int>()
        let value = 1
        await cache.set(value, for: .a)
        #expect(await cache.object(for: .a) == value)
        #expect(await cache.object(for: .b) == nil)
        #expect(await cache.object(for: .c) == nil)
    }

    @Test
    @available(macOS 15.0, *)
    func testSimpleCache() {
        let cache = SimpleCache<Key, Int>()
        let value = 1
        cache[.a] = value
        #expect(cache[.a] == value)
        #expect(cache[.b] == nil)
        #expect(cache[.c] == nil)
    }
}
