// Copyright © 2024 Brent Tunnicliff <brent@tunnicliff.dev>

public protocol CoordinatesType: Hashable, CustomStringConvertible, Sendable {
    var x: Int { get }
    var y: Int { get }
}
