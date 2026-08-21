public import Array_Primitives
public import Buffer_Linear_Primitive
import Buffer_Linear_Primitives
public import Byte_Parser_Primitives
import Byte_Primitives
import Column_Primitives
import Input_Primitives
public import Memory_Heap_Primitives
import Ownership_Shared_Primitive
public import Storage_Contiguous_Primitives

extension Input.Slice where Base == Array<Byte>.Shared {

    public static func bytes(_ values: Byte...) -> Byte.Input {
        Byte.Input(values)
    }
}
