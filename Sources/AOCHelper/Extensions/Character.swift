// Copyright © 2024 Brent Tunnicliff <brent@tunnicliff.dev>

public extension Character {
    /// Converts current value to type Int.
    ///
    /// Throws a fatal error if unable to convert.
    func toInt() -> Int {
        guard let value = Int(self.toString()) else {
            fatalError("Unable to convert \(self) to Int.")
        }

        return value
    }

    /// Converts current value to type String.
    func toString() -> String {
        String(self)
    }
}
