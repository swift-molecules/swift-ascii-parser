import ASCII_Decimal_Parser
import Input
import Parser_Test_Support
import Testing

private typealias Cursor = Byte.Input

@Suite
struct `Declarative Parser Syntax Tests` {
    @Suite struct Unit {}
    @Suite struct `Edge Case` {}
    @Suite struct Integration {}
    @Suite struct `Endpoint Tests` {}
    @Suite struct `Point Tests` {}
    @Suite struct `Range Tests` {}
    @Suite struct `Composition Tests` {}
}

struct Network: Sendable {}

extension Network {
    struct Endpoint: Equatable, Sendable {
        let host: UInt16
        let port: UInt16
    }
}

extension Network.Endpoint {
    enum Error: Swift.Error, Sendable, Equatable {
        case invalidHost
        case expectedColon
        case invalidPort
    }
}

struct Geometry: Sendable {}

extension Geometry {
    struct Point: Equatable, Sendable {
        let x: UInt16
        let y: UInt16
        let z: UInt16
    }
}

extension Geometry.Point {
    enum Error: Swift.Error, Sendable, Equatable {
        case invalidX
        case expectedComma
        case invalidY
        case invalidZ
    }
}

struct Measurement: Sendable {}

extension Measurement {
    struct Range: Equatable, Sendable {
        let lower: UInt32
        let upper: UInt32
    }
}

extension Measurement.Range {
    enum Error: Swift.Error, Sendable, Equatable {
        case invalidLower
        case expectedDash
        case invalidUpper
    }
}

extension Network.Endpoint {
    struct Parser<Input: Collection.Slice.`Protocol` & Input.Input.Streaming>: Sendable
    where Input: Sendable, Input.Element == Byte {
    }
}

extension Network.Endpoint.Parser: Parser.`Protocol` {
    typealias Output = Network.Endpoint
    typealias Failure = Network.Endpoint.Error

    var body: some Parser.`Protocol`<Input, Network.Endpoint, Network.Endpoint.Error> {
        Parser.Take.Sequence {
            ASCII.Decimal.Parser<_, UInt16>()
            ":"
            ASCII.Decimal.Parser<_, UInt16>()
        }
        .map { host, port in Network.Endpoint(host: host, port: port) }
        .error.map { either -> Network.Endpoint.Error in
            switch either {
            case .right: .invalidPort
            case .left(.left): .invalidHost
            case .left(.right): .expectedColon
            }
        }
    }
}

extension Geometry.Point {
    struct Parser<Input: Collection.Slice.`Protocol` & Input.Input.Streaming>: Sendable
    where Input: Sendable, Input.Element == Byte {
    }
}

extension Geometry.Point.Parser: Parser.`Protocol` {
    typealias Output = Geometry.Point
    typealias Failure = Geometry.Point.Error

    var body: some Parser.`Protocol`<Input, Geometry.Point, Geometry.Point.Error> {
        Parser.Take.Sequence {
            ASCII.Decimal.Parser<_, UInt16>()
            ","
            ASCII.Decimal.Parser<_, UInt16>()
            ","
            ASCII.Decimal.Parser<_, UInt16>()
        }
        .map { x, y, z in Geometry.Point(x: x, y: y, z: z) }
        .error.map { either -> Geometry.Point.Error in
            switch either {
            case .right:
                return .invalidZ

            case .left(.right):
                return .expectedComma

            case .left(.left(.right)):
                return .invalidY

            case .left(.left(.left(.right))):
                return .expectedComma

            case .left(.left(.left(.left))):
                return .invalidX
            }
        }
    }
}

extension Measurement.Range {
    struct Parser<Input: Collection.Slice.`Protocol` & Input.Input.Streaming>: Sendable
    where Input: Sendable, Input.Element == Byte {
    }
}

extension Measurement.Range.Parser: Parser.`Protocol` {
    typealias Output = Measurement.Range
    typealias Failure = Measurement.Range.Error

    var body: some Parser.`Protocol`<Input, Measurement.Range, Measurement.Range.Error> {
        Parser.Take.Sequence {
            ASCII.Decimal.Parser<_, UInt32>()
            "-"
            ASCII.Decimal.Parser<_, UInt32>()
        }
        .map { lower, upper in Measurement.Range(lower: lower, upper: upper) }
        .error.map { either -> Measurement.Range.Error in
            switch either {
            case .right: .invalidUpper
            case .left(.left): .invalidLower
            case .left(.right): .expectedDash
            }
        }
    }
}

struct Weighted: Sendable {}

extension Weighted {
    struct Endpoint: Equatable, Sendable {
        let endpoint: Network.Endpoint
        let weight: UInt16
    }
}

extension Weighted.Endpoint {
    enum Error: Swift.Error, Sendable, Equatable {
        case invalidEndpoint
        case expectedSlash
        case invalidWeight
    }
}

extension Weighted.Endpoint {
    struct Parser<Input: Collection.Slice.`Protocol` & Input.Input.Streaming>: Sendable
    where Input: Sendable, Input.Element == Byte {
    }
}

extension Weighted.Endpoint.Parser: Parser.`Protocol` {
    typealias Output = Weighted.Endpoint
    typealias Failure = Weighted.Endpoint.Error

    var body: some Parser.`Protocol`<Input, Weighted.Endpoint, Weighted.Endpoint.Error> {
        Parser.Take.Sequence {
            Network.Endpoint.Parser<Input>()
            "/"
            ASCII.Decimal.Parser<_, UInt16>()
        }
        .map { endpoint, weight in Weighted.Endpoint(endpoint: endpoint, weight: weight) }
        .error.map { either -> Weighted.Endpoint.Error in
            switch either {
            case .right: .invalidWeight
            case .left(.left): .invalidEndpoint
            case .left(.right): .expectedSlash
            }
        }
    }
}

extension `Declarative Parser Syntax Tests`.`Endpoint Tests` {
    @Test
    func `parses host:port`() throws {
        let parser = Network.Endpoint.Parser<Cursor>()
        var input = Cursor(utf8: "192:8080")

        let endpoint = try parser.parse(&input)

        #expect(endpoint == Network.Endpoint(host: 192, port: 8080))
        #expect(input.isEmpty)
    }

    @Test
    func `consumes only its portion`() throws {
        let parser = Network.Endpoint.Parser<Cursor>()
        var input = Cursor(utf8: "80:443/path")

        let endpoint = try parser.parse(&input)

        #expect(endpoint == Network.Endpoint(host: 80, port: 443))
        #expect(input.first == 0x2F)
    }

    @Test
    func `reports invalidHost on non-digit`() {
        let parser = Network.Endpoint.Parser<Cursor>()
        var input = Cursor(utf8: "abc:80")

        #expect(throws: Network.Endpoint.Error.invalidHost) {
            try parser.parse(&input)
        }
    }

    @Test
    func `reports expectedColon on missing delimiter`() {
        let parser = Network.Endpoint.Parser<Cursor>()
        var input = Cursor(utf8: "80 443")

        #expect(throws: Network.Endpoint.Error.expectedColon) {
            try parser.parse(&input)
        }
    }

    @Test
    func `reports invalidPort after colon`() {
        let parser = Network.Endpoint.Parser<Cursor>()
        var input = Cursor(utf8: "80:abc")

        #expect(throws: Network.Endpoint.Error.invalidPort) {
            try parser.parse(&input)
        }
    }

    @Test
    func `reports invalidHost on empty`() {
        let parser = Network.Endpoint.Parser<Cursor>()
        var input = Cursor([])

        #expect(throws: Network.Endpoint.Error.invalidHost) {
            try parser.parse(&input)
        }
    }
}

extension `Declarative Parser Syntax Tests`.`Point Tests` {
    @Test
    func `parses x,y,z`() throws {
        let parser = Geometry.Point.Parser<Cursor>()
        var input = Cursor(utf8: "10,20,30")

        let point = try parser.parse(&input)

        #expect(point == Geometry.Point(x: 10, y: 20, z: 30))
        #expect(input.isEmpty)
    }

    @Test
    func `parses max UInt16 values`() throws {
        let parser = Geometry.Point.Parser<Cursor>()
        var input = Cursor(utf8: "65535,0,65535")

        let point = try parser.parse(&input)

        #expect(point == Geometry.Point(x: 65535, y: 0, z: 65535))
    }

    @Test
    func `reports invalidX on empty`() {
        let parser = Geometry.Point.Parser<Cursor>()
        var input = Cursor([])

        #expect(throws: Geometry.Point.Error.invalidX) {
            try parser.parse(&input)
        }
    }

    @Test
    func `reports expectedComma after x`() {
        let parser = Geometry.Point.Parser<Cursor>()
        var input = Cursor(utf8: "10 20")

        #expect(throws: Geometry.Point.Error.expectedComma) {
            try parser.parse(&input)
        }
    }

    @Test
    func `reports invalidY after first comma`() {
        let parser = Geometry.Point.Parser<Cursor>()
        var input = Cursor(utf8: "10,abc")

        #expect(throws: Geometry.Point.Error.invalidY) {
            try parser.parse(&input)
        }
    }

    @Test
    func `reports invalidZ at end`() {
        let parser = Geometry.Point.Parser<Cursor>()
        var input = Cursor(utf8: "10,20,abc")

        #expect(throws: Geometry.Point.Error.invalidZ) {
            try parser.parse(&input)
        }
    }
}

extension `Declarative Parser Syntax Tests`.`Range Tests` {
    @Test
    func `parses lower-upper`() throws {
        let parser = Measurement.Range.Parser<Cursor>()
        var input = Cursor(utf8: "100:999")

        #expect(throws: Measurement.Range.Error.expectedDash) {
            try parser.parse(&input)
        }
    }

    @Test
    func `parses with dash delimiter`() throws {
        let parser = Measurement.Range.Parser<Cursor>()
        var input = Cursor(utf8: "100-999")

        let range = try parser.parse(&input)

        #expect(range == Measurement.Range(lower: 100, upper: 999))
        #expect(input.isEmpty)
    }

    @Test
    func `parses UInt32 max`() throws {
        let parser = Measurement.Range.Parser<Cursor>()
        var input = Cursor(utf8: "0-4294967295")

        let range = try parser.parse(&input)

        #expect(range == Measurement.Range(lower: 0, upper: UInt32.max))
    }

    @Test
    func `reports invalidLower on non-digit`() {
        let parser = Measurement.Range.Parser<Cursor>()
        var input = Cursor(utf8: "abc-999")

        #expect(throws: Measurement.Range.Error.invalidLower) {
            try parser.parse(&input)
        }
    }

    @Test
    func `reports invalidUpper after dash`() {
        let parser = Measurement.Range.Parser<Cursor>()
        var input = Cursor(utf8: "100-abc")

        #expect(throws: Measurement.Range.Error.invalidUpper) {
            try parser.parse(&input)
        }
    }
}

extension `Declarative Parser Syntax Tests`.`Composition Tests` {
    @Test
    func `nested parser composes`() throws {
        let parser = Weighted.Endpoint.Parser<Cursor>()
        var input = Cursor(utf8: "80:443/10")

        let weighted = try parser.parse(&input)

        #expect(
            weighted
                == Weighted.Endpoint(
                    endpoint: Network.Endpoint(host: 80, port: 443),
                    weight: 10
                )
        )
        #expect(input.isEmpty)
    }

    @Test
    func `nested parser propagates inner error`() {
        let parser = Weighted.Endpoint.Parser<Cursor>()
        var input = Cursor(utf8: "abc:80/10")

        #expect(throws: Weighted.Endpoint.Error.invalidEndpoint) {
            try parser.parse(&input)
        }
    }

    @Test
    func `nested parser reports expectedSlash`() {
        let parser = Weighted.Endpoint.Parser<Cursor>()
        var input = Cursor(utf8: "80:443 10")

        #expect(throws: Weighted.Endpoint.Error.expectedSlash) {
            try parser.parse(&input)
        }
    }

    @Test
    func `nested parser reports invalidWeight`() {
        let parser = Weighted.Endpoint.Parser<Cursor>()
        var input = Cursor(utf8: "80:443/abc")

        #expect(throws: Weighted.Endpoint.Error.invalidWeight) {
            try parser.parse(&input)
        }
    }

    @Test
    func `body delegates to composed parser`() throws {
        let parser = Network.Endpoint.Parser<Cursor>()
        var input1 = Cursor(utf8: "80:443")
        var input2 = Cursor(utf8: "80:443")

        let fromBody = try parser.body.parse(&input1)
        let fromParse = try parser.parse(&input2)

        #expect(fromBody == fromParse)
    }
}
