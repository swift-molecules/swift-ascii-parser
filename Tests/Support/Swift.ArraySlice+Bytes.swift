public import Byte
public import Cursor_Standard_Library_Integration

extension Swift.ArraySlice where Element == Byte {

    public static func bytes(_ values: UInt8...) -> ArraySlice<Byte> {
        values.map(Byte.init(bitPattern:))[...]
    }
}
