import XCTest
@testable import ReactiveBeaverSwift

final class ZipUnarchiverTests: XCTestCase {
    func testUnzippingForEmptySourcePath() {
        let unpacker = ZipUnarchiver()
        let error = unpacker.unpack(zipArchiveURL: FileSupport.nonExistingURL(),
                                    targetDirectoryURL: FileSupport.temporaryDirectoryURL())
        
        guard let unwrapedError = error as? ZipUnarchiver.ErrorType else { XCTFail(); return; }
        
        XCTAssertEqual(unwrapedError, ZipUnarchiver.ErrorType.incorrectSourcePath)
    }
    
    func testUnzippingForEmptyDestinationPath() {
        let unpacker = ZipUnarchiver()
        let error = unpacker.unpack(zipArchiveURL: FileSupport.createDummyFile(),
                                    targetDirectoryURL: FileSupport.nonExistingURL())
        
        guard let unwrapedError = error as? ZipUnarchiver.ErrorType else { XCTFail(); return; }
        
        XCTAssertEqual(unwrapedError, ZipUnarchiver.ErrorType.incorrectDestinationPath)
    }
    
    func testUnzippingForBrokenArchive() {
        let unpacker = ZipUnarchiver()
        let error = unpacker.unpack(zipArchiveURL: FileSupport.createDummyFile(),
                                    targetDirectoryURL: FileSupport.temporaryDirectoryURL())
        
        guard let unwrapedError = error as? ZipUnarchiver.ErrorType else { XCTFail(); return; }
        
        XCTAssertEqual(unwrapedError, ZipUnarchiver.ErrorType.incorrectArchive)
    }

    static var allTests = [
        ("testUnzippingForEmptySourcePath", testUnzippingForEmptySourcePath),
        ("testUnzippingForEmptyDestinationPath", testUnzippingForEmptyDestinationPath),
    ]
}
