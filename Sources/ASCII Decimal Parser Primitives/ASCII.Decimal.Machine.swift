public import Binary_Machine_Primitives

extension ASCII.Decimal {

    public enum Machine {}
}

extension ASCII.Decimal.Machine {

    @inlinable
    public static func unsigned<T: UnsignedInteger & FixedWidthInteger & Sendable>(
        _ type: T.Type = T.self
    ) -> Binary.Machine.Parser<T> {
        return Binary.Machine.build { builder -> Binary.Machine.Expression<T> in

            let digit = Binary.Machine.take1(in: &builder).tryMap(
                { byte throws(Binary.Machine.Fault) -> T in
                    guard byte >= 0x30 && byte <= 0x39 else {
                        throw .predicateFailed(byte: byte)
                    }
                    return T(byte.underlying - 0x30)
                },
                in: &builder
            )

            let moreDigits = Binary.Machine.fold(
                digit,
                initial: Fold<T>(multiplier: 1, sum: 0),
                combine: { state, d in
                    Fold(
                        multiplier: state.multiplier &* 10,
                        sum: state.sum &* 10 &+ d
                    )
                },
                in: &builder
            )

            return Binary.Machine.sequence(
                digit,
                moreDigits,
                combine: { first, state in
                    first &* state.multiplier &+ state.sum
                },
                in: &builder
            )
        }
    }
}

extension ASCII.Decimal.Machine {

    @inlinable
    public static func signed<T: SignedInteger & FixedWidthInteger & Sendable>(
        _ type: T.Type = T.self
    ) -> Binary.Machine.Parser<T> {
        return Binary.Machine.build { builder -> Binary.Machine.Expression<T> in

            let minusSign = Binary.Machine.byte(0x2D, in: &builder).map(
                { _ in T(-1) },
                in: &builder
            )

            let plusSign = Binary.Machine.byte(0x2B, in: &builder).map({ _ in T(1) }, in: &builder)
            let noSign = Binary.Machine.pure(T(1), in: &builder)

            let sign = Binary.Machine.oneOf([minusSign, plusSign, noSign], in: &builder)

            let digit = Binary.Machine.take1(in: &builder).tryMap(
                { byte throws(Binary.Machine.Fault) -> T in
                    guard byte >= 0x30 && byte <= 0x39 else {
                        throw .predicateFailed(byte: byte)
                    }
                    return T(byte.underlying - 0x30)
                },
                in: &builder
            )

            let moreDigits = Binary.Machine.fold(
                digit,
                initial: Fold<T>(multiplier: 1, sum: 0),
                combine: { state, d in
                    Fold(
                        multiplier: state.multiplier &* 10,
                        sum: state.sum &* 10 &+ d
                    )
                },
                in: &builder
            )

            let magnitude = Binary.Machine.sequence(
                digit,
                moreDigits,
                combine: { first, state in
                    first &* state.multiplier &+ state.sum
                },
                in: &builder
            )

            return Binary.Machine.sequence(
                sign,
                magnitude,
                combine: { s, m in s &* m },
                in: &builder
            )
        }
    }
}
