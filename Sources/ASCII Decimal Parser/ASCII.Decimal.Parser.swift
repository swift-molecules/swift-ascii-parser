public import Byte
public import Checkpoint
public import Cursor
public import Iterator
public import Iterator_Protocol
public import Parser

extension ASCII.Decimal {

    public struct Parser<Input: Cursor.`Protocol`, T: FixedWidthInteger>
    where Input.Element == Byte, Input.Failure == Never {

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
        let start = input.checkpoint

        let limit: Int?
        switch count {
        case .greedy: limit = nil
        case .exactly(let n): limit = n
        case .atMost(let n): limit = n
        }

        if case .exactly(let n) = count, n == 0 { throw .insufficientDigits }

        var result: T = 0
        var consumed = 0

        var negative = false
        if sign == .optional {
            let mark = input.checkpoint
            if let byte = input.next() {
                let code = byte.bitPattern
                if code == 0x2B {
                } else if code == 0x2D {
                    guard T.isSigned else {
                        input.seek(to: start)
                        throw .invalidSign
                    }
                    negative = true
                } else {
                    input.seek(to: mark)
                }
            } else {
                input.seek(to: mark)
            }
        }

        while true {
            if let limit, consumed == limit { break }
            let mark = input.checkpoint
            guard let byte = input.next() else { break }
            let code = byte.bitPattern
            guard code >= 0x30, code <= 0x39 else {
                input.seek(to: mark)
                break
            }
            let digit = T(code &- 0x30)

            let (product, mulOverflow) = result.multipliedReportingOverflow(by: 10)
            guard !mulOverflow else {
                input.seek(to: start)
                throw .overflow
            }
            let combined =
                negative
                ? product.subtractingReportingOverflow(digit)
                : product.addingReportingOverflow(digit)
            guard !combined.overflow else {
                input.seek(to: start)
                throw .overflow
            }
            result = combined.partialValue
            consumed += 1
        }

        switch count {
        case .exactly(let n):
            guard consumed == n else {
                input.seek(to: start)
                throw .insufficientDigits
            }

        case .greedy, .atMost:
            guard consumed > 0 else {
                input.seek(to: start)
                throw .noDigits
            }
        }

        return result
    }
}
