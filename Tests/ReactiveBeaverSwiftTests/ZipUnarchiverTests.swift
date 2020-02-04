import XCTest
@testable import ReactiveBeaverSwift

final class ZipUnarchiverTests: XCTestCase {
    var tempDirectoryURL = FileSupport.temporaryDirectoryURL()
    
    override func setUp() {
        super.setUp()
        
        tempDirectoryURL = FileSupport.temporaryDirectoryURL()
    }
    
    override func tearDown() {
        // Remove test artifacts
        _ = try? FileManager.default.removeItem(at: tempDirectoryURL)
        
        super.tearDown()
    }
    
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
        
        XCTAssertFalse(result)
    }
    
    func testUnzippingWithProperArchive() {
        let unarchiver = ZipUnarchiver()
        let result = unarchiver.unpack(zipArchiveURL: FileSupport.mobyDickFileURL(),
                                       targetDirectoryURL: FileSupport.temporaryDirectoryURL())
        
        XCTAssertTrue(result)
    }

    static var allTests = [
        ("testUnzippingForEmptySourcePath", testUnzippingForEmptySourcePath),
        ("testUnzippingForEmptyDestinationPath", testUnzippingForEmptyDestinationPath),
    ]
}
