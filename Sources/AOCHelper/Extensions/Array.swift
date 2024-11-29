// Copyright © 2024 Brent Tunnicliff <brent@tunnicliff.dev>

public extension Array {
    /// Filters duplicates from the array.
    ///
    /// Order of elements is not maintained. It does this by converting to Set and back.
    func toUnique() -> [Element] where Element: Hashable {
        Array(toSet())
    }

    /// Filters duplicates from the array while maintaining the order of elements.
    ///
    /// Keeps the order of the first occurrence of duplicate element.
    /// Has high cost as loops through all items and compares.
    func toUniqueMaintainOrder() -> [Element] where Element: Equatable {
        reduce(into: [Element]()) { partialResult, element in
            guard !partialResult.contains(element) else {
                return
            }

            partialResult.append(element)
        }
    }

    func toSet() -> Set<Element> where Element: Hashable {
        Set(self)
    }
}
