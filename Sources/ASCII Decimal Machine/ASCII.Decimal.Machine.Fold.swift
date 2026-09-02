public import ASCII_Decimal_Parser

extension ASCII.Decimal.Machine {

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
