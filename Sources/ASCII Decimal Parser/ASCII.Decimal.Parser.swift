public import Byte
public import Collection

extension ASCII.Decimal {

    public struct Parser<Input: Collection.Slice.`Protocol`, T: FixedWidthInteger>: Sendable
    where Input: Sendable, Input.Element == Byte {

        public let sign: ASCII.Digits.Sign

        public let count: ASCII.Digits.Count

        @inlinable
        public init(sign: ASCII.Digits.Sign = .none, count: ASCII.Digits.Count = .greedy) {
            self.sign = sign
            self.count = count
        }
    }
}

extension ASCII.Decimal.Parser: Parser.`Protocol` {

    public typealias Output = T

    public typealias Failure = ASCII.Decimal.Error

    public typealias Body = Never

    @inlinable
    public func parse(_ input: inout Input) throws(Failure) -> T {

        let limit: Int?
        switch count {
        case .greedy: limit = nil
        case .exactly(let n): limit = n
        case .atMost(let n): limit = n
        }

        if case .exactly(let n) = count, n == 0 { throw .insufficientDigits }

        var result: T = 0
        var consumed = 0
        var index = input.startIndex

        var negative = false
        if sign == .optional, index < input.endIndex {
            let byte = input[index]
            if byte == 0x2B {
                input.formIndex(after: &index)
            } else if byte == 0x2D {
                guard T.isSigned else { throw .invalidSign }
                negative = true
                input.formIndex(after: &index)
            }
        }

        while index < input.endIndex {
            if let limit, consumed == limit { break }
            let byte = input[index]
            guard byte >= 0x30, byte <= 0x39 else {
                break
            }
            let digit = T(byte.underlying &- 0x30)

            let (product, mulOverflow) = result.multipliedReportingOverflow(by: 10)
            guard !mulOverflow else { throw .overflow }
            let combined =
                negative
                ? product.subtractingReportingOverflow(digit)
                : product.addingReportingOverflow(digit)
            guard !combined.overflow else { throw .overflow }
            result = combined.partialValue
            input.formIndex(after: &index)
            consumed += 1
        }

        switch count {
        case .exactly(let n):
            guard consumed == n else { throw .insufficientDigits }

        case .greedy, .atMost:
            guard consumed > 0 else { throw .noDigits }
        }

        input = input[index...]
        return result
    }
}
