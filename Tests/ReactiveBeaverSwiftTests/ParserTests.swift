import XCTest
@testable import ReactiveBeaverSwift

final class ParserTests: XCTestCase {
    var mobyDickEpubURL: URL!
    var destinationFolderURL: URL!
    
    override func setUp() {
        mobyDickEpubURL = mobyDickFileURL()
        destinationFolderURL = createTempFolderURL()
    }
    
    func testParserCreation() {
        XCTAssertNotNil(Parser())
    }
    
    func testParsing() {
        let parser = Parser()
        
        let expectation = self.expectation(description: "Parsing should return valid Epub object")
        parser.parse(epubURL: mobyDickEpubURL, destinationFolderURL: destinationFolderURL) { result in
            switch (result) {
            case .failure(_):
                break
            case .success(_):
                expectation.fulfill()
            }
        }
        
        wait(for: [expectation], timeout: 0.1)
    }
    
    private func sharedTemporaryFolderURL() -> URL {
        return URL(fileURLWithPath: NSTemporaryDirectory())
    }
    
    private func createTempFolderURL() -> URL {
        let newFolderURL = sharedTemporaryFolderURL().appendingPathComponent(UUID().uuidString)
        do {
            try FileManager.default.createDirectory(at: newFolderURL, withIntermediateDirectories: true, attributes: nil)
        } catch (let error) {
            preconditionFailure("Cannot create temp folder due to error: \(error)")
        }
        
        guard FileManager.default.fileExists(atPath: newFolderURL.path) else {
            preconditionFailure("Cannot create temp folder at \(newFolderURL.path)")
        }
        
        return newFolderURL
    }
    
    private func mobyDickFileURL() -> URL {
        let bundle = Bundle(for: self.classForCoder)
        
        guard let path = bundle.path(forResource: "moby-dick", ofType: "epub") else {
            preconditionFailure("moby-dick.epub cannot be located (or you're running tests from Xcode, => use `swift test` instead)")
        }
        
        return URL(fileURLWithPath: path)
    }
    
    static var allTests = [
        ("testParserCreation", testParserCreation),
    ]
}
