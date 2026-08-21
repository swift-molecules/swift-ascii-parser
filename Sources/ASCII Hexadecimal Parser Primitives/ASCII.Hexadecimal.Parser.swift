public import Byte_Primitives
public import Collection_Primitives

extension ASCII.Hexadecimal {

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

extension ASCII.Hexadecimal.Parser: Parser.`Protocol` {

    public typealias Output = T

    public typealias Failure = ASCII.Hexadecimal.Error

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
            guard let digit = Self._hexValue(byte) else { break }

            let (shifted, shiftOverflow) = result.multipliedReportingOverflow(by: 16)
            guard !shiftOverflow else { throw .overflow }
            let combined =
                negative
                ? shifted.subtractingReportingOverflow(digit)
                : shifted.addingReportingOverflow(digit)
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

    @inlinable
    package static func _hexValue(_ byte: Byte) -> T? {
        let raw = byte.underlying
        switch raw {
        case 0x30...0x39: return T(raw &- 0x30)
        case 0x41...0x46: return T(raw &- 0x37)
        case 0x61...0x66: return T(raw &- 0x57)
        default: return nil
        }
    }
}
