public import Array
public import Buffer_Linear_Primitive
import Buffer_Linear
public import Byte_Parser
import Byte
import Column
import Input
public import Memory_Heap
import Ownership_Shared_Primitive
public import Storage_Contiguous

extension Input.Slice where Base == Array<Byte>.Shared {

    public static func bytes(_ values: Byte...) -> Byte.Input {
        Byte.Input(values)
    }
}
