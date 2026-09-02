public import Byte

extension ASCII.Decimal.Float {

    @inlinable
    package static func slowPath(bytes: [Byte]) throws(Self.Error) -> Double {
        var raw: [UInt8] = []
        raw.reserveCapacity(bytes.count)
        for byte in bytes {
            raw.append(byte.bitPattern)
        }
        let string = Swift.String(decoding: raw, as: Swift.UTF8.self)
        guard let value = Swift.Double(string), value.isFinite else {
            throw .overflow
        }
        return value
    }
}
