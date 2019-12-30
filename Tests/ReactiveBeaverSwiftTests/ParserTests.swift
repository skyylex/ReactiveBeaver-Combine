import XCTest
@testable import ReactiveBeaverSwift

final class ParserTests: XCTestCase {
    var mobyDickEpubPath: String!
    
    override func setUp() {
        let bundle = Bundle(for: self.classForCoder)
        
        guard let path = bundle.path(forResource: "moby-dick", ofType: "epub") else {
            preconditionFailure("moby-dick.epub cannot be located (or you're running tests from Xcode, => use `swift test` instead)")
        }
        
        mobyDickEpubPath = path
    }
    
    func testParserCreation() {
        XCTAssertNotNil(Parser())
    }
    
    static var allTests = [
        ("testParserCreation", testParserCreation),
    ]
}
