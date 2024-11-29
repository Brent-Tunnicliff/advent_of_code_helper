// Copyright © 2024 Brent Tunnicliff <brent@tunnicliff.dev>

import Foundation

/// Directions for traversing grids.
///
/// Contains methods of getting next direction.
public enum CompassDirection: CaseIterable, Sendable {
    case east
    case north
    case south
    case west
}

public extension CompassDirection {
    var opposite: CompassDirection {
        switch self {
        case .east: .west
        case .north: .south
        case .south: .north
        case .west: .east
        }
    }

    var turnLeft: CompassDirection {
        switch self {
        case .east: .north
        case .north: .west
        case .south: .east
        case .west: .south
        }
    }

    var turnRight: CompassDirection {
        switch self {
        case .east: .south
        case .north: .east
        case .south: .west
        case .west: .north
        }
    }
}
