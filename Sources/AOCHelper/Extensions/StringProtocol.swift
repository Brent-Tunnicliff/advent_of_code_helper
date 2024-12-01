// Copyright © 2024 Brent Tunnicliff <brent@tunnicliff.dev>

extension StringProtocol {
    /// Trims all while spaces from the start and end of the value.
    func trimmingWhitespaces() -> String {
        trimmingCharacters(in: .whitespacesAndNewlines)
    }

    /// Converts current value to type Int. Ignores any whitespace at the start and end of the value.
    ///
    /// Throws a fatal error if unable to convert.
    func toInt() -> Int {
        guard let value = Int(self.trimmingWhitespaces()) else {
            fatalError("Unable to convert \(self) to Int.")
        }

        return value
    }

    /// Converts current value to type String.
    func toString() -> String {
        String(self)
    }
}
