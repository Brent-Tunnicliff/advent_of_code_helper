// Copyright © 2024 Brent Tunnicliff <brent@tunnicliff.dev>

import Foundation

/// Simple in memory cache.
public actor Cache<Key: Hashable, Value> {
    private var values: [Key: Value]

    public init() {
        values = [:]
    }

    public func object(for key: Key) -> Value? {
        values[key]
    }

    public func set(_ value: Value?, for key: Key) {
        values[key] = value
    }
}
