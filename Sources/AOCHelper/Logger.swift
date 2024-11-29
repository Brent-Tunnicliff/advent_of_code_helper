// Copyright © 2024 Brent Tunnicliff <brent@tunnicliff.dev>

import Foundation

/// Basic logger that prints to console if enabled.
/// Can disable for increased performance.
public final class Logger: Sendable {
    private let enabled: Bool

    init(enabled: Bool) {
        self.enabled = enabled
    }

    public func log(_ message: String) {
        guard enabled else {
            return
        }

        print("\(Date().description): \(message)")
    }
}
