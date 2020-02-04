import XCTest
@testable import ReactiveBeaverSwift

struct MockedUnarchiver: Unarchiver {
    func unpack(zipArchiveURL: URL, targetDirectoryURL: URL) -> Bool {
        return true
    }
}

final class ParserTests: XCTestCase {
    var mobyDickEpubURL: URL!
    var destinationFolderURL: URL!

    override func setUp() {
        super.setUp()
        
        mobyDickEpubURL = FileSupport.mobyDickFileURL()
        destinationFolderURL = FileSupport.createTempFolderURL()
    }
    
    override func tearDown() {
        _ = try? FileManager.default.removeItem(at: destinationFolderURL)
        
        super.tearDown()
    }
    
    func testParsing() {
        let parser = ReactiveBeaver(unpacker: ZipUnarchiver())

        let expectation = self.expectation(description: "Parsing should return valid Epub object")
        parser.gnaw(epubURL: mobyDickEpubURL, destinationFolderURL: destinationFolderURL) { result in
            switch (result) {
            case .failure(let error):
                XCTFail(error.localizedDescription)
                break
            case .success(let epub):
                XCTAssertEqual(epub.destinationPath.path, self.destinationFolderURL.path)
                XCTAssertEqual(epub.opfPackage.manifest.items.count, 151)
                XCTAssertEqual(epub.opfPackage.metadata.title, "Moby-Dick")
                XCTAssertEqual(epub.opfPackage.spine.items.count, 144)
                expectation.fulfill()
            }
        }

        wait(for: [expectation], timeout: 0.1)
    }
    
    static var allTests = [
        ("testParsing", testParsing),
    ]
}
