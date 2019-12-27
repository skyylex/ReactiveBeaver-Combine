import XCTest
@testable import ReactiveBeaverSwift

final class ReactiveBeaverSwiftTests: XCTestCase {
    func testParserCreation() {
        XCTAssertNotNil(Parser())
    }
    
    func testUnpackingForEmptyPaths() {
        let unpacker = ZipUnpacker()
        XCTAssertNil(unpacker.unpack(sourcePath: "", destinationPath: ""))
    }

    static var allTests = [
        ("testParserCreation", testParserCreation),
        ("testUnpackingForEmptyPaths", testUnpackingForEmptyPaths),
    ]
}
