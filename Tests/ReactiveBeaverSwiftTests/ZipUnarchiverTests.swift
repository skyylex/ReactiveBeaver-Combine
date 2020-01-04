import XCTest
@testable import ReactiveBeaverSwift

final class ZipUnarchiverTests: XCTestCase {
    func testUnzippingForEmptySourcePath() {
        let unarchiver = ZipUnarchiver()
        let result = unarchiver.unpack(zipArchiveURL: FileSupport.nonExistingURL(),
                                       targetDirectoryURL: FileSupport.temporaryDirectoryURL())
        
        XCTAssertFalse(result)
    }
    
    func testUnzippingForEmptyDestinationPath() {
        let unarchiver = ZipUnarchiver()
        let result = unarchiver.unpack(zipArchiveURL: FileSupport.createDummyFile(),
                                       targetDirectoryURL: FileSupport.nonExistingURL())
        
        XCTAssertFalse(result)
    }
    
    func testUnzippingForBrokenArchive() {
        let unarchiver = ZipUnarchiver()
        let result = unarchiver.unpack(zipArchiveURL: FileSupport.createDummyFile(),
                                       targetDirectoryURL: FileSupport.temporaryDirectoryURL())
        
        XCTAssertTrue(result)
    }

    static var allTests = [
        ("testUnzippingForEmptySourcePath", testUnzippingForEmptySourcePath),
        ("testUnzippingForEmptyDestinationPath", testUnzippingForEmptyDestinationPath),
    ]
}
