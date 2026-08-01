//
//  ASCII.Decimal.Machine.Fold.swift
//  swift-ascii-parser-primitives
//

extension ASCII.Decimal.Machine {
    /// Accumulator type for folding decimal digits.
    ///
    /// Tracks both the multiplier (power of 10) and running sum to enable
    /// combining with the required first digit.
    @usableFromInline
    struct Fold<T: FixedWidthInteger & Sendable>: Sendable {
        @usableFromInline var multiplier: T
        @usableFromInline var sum: T

        @inlinable
        package init(multiplier: T, sum: T) {
            self.multiplier = multiplier
            self.sum = sum
        }
    }
}
