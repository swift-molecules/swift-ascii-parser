public import Byte
public import Byte_Parser

extension Byte.Input {

    public static func bytes(_ values: UInt8...) -> Byte.Input {
        Byte.Input(values)
    }
}
