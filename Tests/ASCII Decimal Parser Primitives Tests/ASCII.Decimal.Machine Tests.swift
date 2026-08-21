import ASCII_Decimal_Parser_Primitives
import Testing

extension ASCII.Decimal.Machine {
    @Suite
    struct Test {
        @Test
        func `builds an unsigned decimal parser`() {
            let _: Binary.Machine.Parser<UInt32> = ASCII.Decimal.Machine.unsigned()
        }

        @Test
        func `builds a signed decimal parser`() {
            let _: Binary.Machine.Parser<Int32> = ASCII.Decimal.Machine.signed()
        }
    }
}
