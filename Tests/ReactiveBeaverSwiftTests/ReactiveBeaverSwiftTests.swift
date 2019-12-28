import XCTest
@testable import ReactiveBeaverSwift

final class ReactiveBeaverSwiftTests: XCTestCase {
    func testParserCreation() {
        XCTAssertNotNil(Parser())
    }
    
    func testUnzippingForEmptySourcePath() {
        let unpacker = ZipUnarchiver()
        let error = unpacker.unpack(sourcePath: "", destinationPath: NSTemporaryDirectory())
        
        guard let unwrapedError = error as? ZipUnarchiver.ErrorType else { XCTFail(); return; }
        
        XCTAssertEqual(unwrapedError, ZipUnarchiver.ErrorType.incorrectSourcePath)
    }
    
    func testUnzippingForEmptyDestinationPath() {
        let unpacker = ZipUnarchiver()
        let error = unpacker.unpack(sourcePath: createDummyFile().path, destinationPath: "")
        
        guard let unwrapedError = error as? ZipUnarchiver.ErrorType else { XCTFail(); return; }
        
        XCTAssertEqual(unwrapedError, ZipUnarchiver.ErrorType.incorrectDestinationPath)
    }
    
    func testUnzippingForBrokenArchive() {
        let unpacker = ZipUnarchiver()
        let error = unpacker.unpack(sourcePath: createDummyFile().path, destinationPath: NSTemporaryDirectory())
        
        guard let unwrapedError = error as? ZipUnarchiver.ErrorType else { XCTFail(); return; }
        
        XCTAssertEqual(unwrapedError, ZipUnarchiver.ErrorType.incorrectArchive)
    }

    static var allTests = [
        ("testParserCreation", testParserCreation),
        ("testUnzippingForEmptySourcePath", testUnzippingForEmptySourcePath),
        ("testUnzippingForEmptyDestinationPath", testUnzippingForEmptyDestinationPath),
    ]
}

fileprivate extension ReactiveBeaverSwiftTests {
    func createDummyFile(for directoryPath: String = NSTemporaryDirectory(),
                         fileName: String = UUID().uuidString) -> URL {
        let directoryURL = URL(fileURLWithPath: directoryPath)
        let fileURL = directoryURL.appendingPathComponent(fileName)
        
        do { try createDummyData().write(to: fileURL, options: .atomicWrite) }
        catch { preconditionFailure("Cannot write dummy data") }
        
        guard FileManager.default.fileExists(atPath: fileURL.path) else { preconditionFailure("Dummy file wasn't written") }
        
        return fileURL
    }

    func createDummyData() -> Data {
        let randomString = UUID().uuidString
        guard let data = randomString.data(using: .utf8) else { preconditionFailure("Cannot create dummy data") }
        
        return data
    }
}
