public import ASCII_Decimal_Parser_Primitives
public import Array_Primitives
public import Buffer_Linear_Primitive
public import Buffer_Linear_Primitives
public import Byte_Parser_Primitives
public import Ownership_Shared_Primitive
public import Parseable_ASCII_Primitives

extension Int: ASCII.Parseable {

    public static var parser: ASCII.Decimal.Parser<Byte.Input, Int> { .init() }
}

extension UInt: ASCII.Parseable {

    public static var parser: ASCII.Decimal.Parser<Byte.Input, UInt> { .init() }
}

extension Int8: ASCII.Parseable {

    public static var parser: ASCII.Decimal.Parser<Byte.Input, Int8> { .init() }
}

extension Int16: ASCII.Parseable {

    public static var parser: ASCII.Decimal.Parser<Byte.Input, Int16> { .init() }
}

extension Int32: ASCII.Parseable {

    public static var parser: ASCII.Decimal.Parser<Byte.Input, Int32> { .init() }
}

extension Int64: ASCII.Parseable {

    public static var parser: ASCII.Decimal.Parser<Byte.Input, Int64> { .init() }
}

extension UInt8: ASCII.Parseable {

    public static var parser: ASCII.Decimal.Parser<Byte.Input, UInt8> { .init() }
}

extension UInt16: ASCII.Parseable {

    public static var parser: ASCII.Decimal.Parser<Byte.Input, UInt16> { .init() }
}

extension UInt32: ASCII.Parseable {

    public static var parser: ASCII.Decimal.Parser<Byte.Input, UInt32> { .init() }
}

extension UInt64: ASCII.Parseable {

    public static var parser: ASCII.Decimal.Parser<Byte.Input, UInt64> { .init() }
}

extension FixedWidthInteger where Self: ASCII.Parseable {

    @inlinable
    public init<Bytes: Swift.Collection>(ascii bytes: Bytes) throws(ASCII.Decimal.Error)
    where Bytes.Element == Byte {
        var input = Byte.Input(bytes)
        let leaf = ASCII.Decimal.Parser<Byte.Input, Self>()
        self = try leaf.parse(&input)
    }
}
