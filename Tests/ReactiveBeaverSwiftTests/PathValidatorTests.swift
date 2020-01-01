import XCTest
@testable import ReactiveBeaverSwift

final class PathValidatorTests: XCTestCase {
    static let epubContentsURL = FileSupport.temporaryDirectoryURL()
    var paths: Paths = { Paths(epubUnzippedFolderURL: PathValidatorTests.epubContentsURL) }()
    
    override func setUp() {
        cleanUpFileSystem()
    }
    
    override func tearDown() {
        cleanUpFileSystem()
    }
    
    func testNonExistingPathsValidation() {
        XCTAssertFalse(PathValidator.validate(paths: paths).isEmpty)
    }
    
    func testExistingPathsValidation() {
        FileSupport.createDirectory(at: paths.metaInfDirectory)
        FileSupport.createDirectory(at: paths.oebpsDirectory)
        FileSupport.createDummyFile(using: paths.containerXML)
        
        XCTAssertTrue(PathValidator.validate(paths: paths).isEmpty)
    }
    
    // Shortcuts
    
    func cleanUpFileSystem() {
        do {
            try FileManager.default.removeItem(at: paths.containerXML)
        } catch {}
        
        do {
            try FileManager.default.removeItem(at: paths.oebpsDirectory)
        } catch {}
        
        do {
            try FileManager.default.removeItem(at: paths.metaInfDirectory)
        } catch {}
    }
}
