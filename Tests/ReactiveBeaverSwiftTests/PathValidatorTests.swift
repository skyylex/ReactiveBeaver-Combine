import XCTest
@testable import ReactiveBeaverSwift

final class PathValidatorTests: XCTestCase {
    static let epubContentsURL = FileSupport.temporaryDirectoryURL()
    var paths: BasicPaths = { BasicPaths(rootURL: PathValidatorTests.epubContentsURL) }()
    
    override func setUp() {
        cleanUpFileSystem()
    }
    
    override func tearDown() {
        cleanUpFileSystem()
    }
    
    func testNonExistingPathsValidation() {
        let fileURLs = Set([paths.containerXML])
        let directoryURLs = Set([paths.metaInfDirectory])
        
        let validationErrors = PathValidator.validate(paths: paths)
        let brokenURLs = validationErrors.map { (error: PathValidator.ErrorType) -> URL in
            switch error {
            case .missingDirectory(let url):
                XCTAssertTrue(directoryURLs.contains(url))
                return url
            case .missingFile(let url):
                XCTAssertTrue(fileURLs.contains(url))
                return url
            }
        }
        
        XCTAssertEqual(brokenURLs.count, fileURLs.count + directoryURLs.count)
    }
    
    func testExistingPathsValidation() {
        createAllItems(from: paths)
        
        XCTAssertTrue(PathValidator.validate(paths: paths).isEmpty)
    }
    
    // Shortcuts
    
    func createAllItems(from paths: BasicPaths) {
        FileSupport.createDirectory(at: paths.metaInfDirectory)
        FileSupport.createDummyFile(using: paths.containerXML)
    }
    
    func cleanUpFileSystem() {
        do {
            try FileManager.default.removeItem(at: paths.containerXML)
        } catch {}
        
        do {
            try FileManager.default.removeItem(at: paths.metaInfDirectory)
        } catch {}
    }
}
