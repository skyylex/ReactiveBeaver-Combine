import XCTest
@testable import ReactiveBeaverSwift

final class ReactiveBeaverSwiftTests: XCTestCase {
    func testParserCreation() {
        XCTAssertNotNil(Parser())
    }
    
    func testUnpackingForEmptyPath() {
        let unpacker = ZipUnpacker()
        XCTAssertNil(unpacker.unpack(sourcePath: ""))
    }

    static var allTests = [
        ("testParserCreation", testParserCreation),
        ("testUnpackingForEmptyPath", testUnpackingForEmptyPath),
    ]
}
