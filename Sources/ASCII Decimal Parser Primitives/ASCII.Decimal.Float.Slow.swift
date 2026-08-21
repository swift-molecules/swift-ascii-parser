extension ASCII.Decimal.Float {

    @inlinable
    package static func slowPath<Input: Collection.`Protocol`>(
        input: borrowing Input,
        start: Input.Index,
        end: Input.Index
    ) throws(Self.Error) -> Double
    where Input.Element == UInt8 {
        var bytes: [UInt8] = []
        var i = start
        while i < end {
            bytes.append(input[i])
            input.formIndex(after: &i)
        }
        let string = Swift.String(decoding: bytes, as: Swift.UTF8.self)
        guard let value = Swift.Double(string), value.isFinite else {
            throw .overflow
        }
        return value
    }
}
