// Copyright © 2024 Brent Tunnicliff <brent@tunnicliff.dev>

import Foundation
import Synchronization

/// Simple in memory cache.
@available(macOS, deprecated: 15.0, renamed: "SimpleCache", message: "Replaced with a non-async type.")
public actor Cache<Key: Hashable, Value> {
    private var values: [Key: Value]

    public subscript(_ key: Key) -> Value? {
        get async {
            object(for: key)
        }
    }

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

/// Simple and sendable in memory cache.
@available(macOS 15.0, *)
public final class SimpleCache<Key, Value>: Sendable where Key: Hashable, Key: Sendable, Value: Sendable {
    private let values = Mutex<[Key: Value]>([:])

    public subscript(_ key: Key) -> Value? {
        get {
            object(for: key)
        }
        set {
            set(newValue, for: key)
        }
    }

    public init() {}

    public func object(for key: Key) -> Value? {
        values.withLock { values in
            values[key]
        }
    }

    public func set(_ value: Value?, for key: Key) {
        values.withLock { dict in
            dict[key] = value
        }
    }
}
