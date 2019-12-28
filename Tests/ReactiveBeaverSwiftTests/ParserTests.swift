import XCTest
@testable import ReactiveBeaverSwift

final class ParserTests: XCTestCase {
    func testParserCreation() {
        XCTAssertNotNil(Parser())
    }
    
    static var allTests = [
        ("testParserCreation", testParserCreation),
    ]
}
