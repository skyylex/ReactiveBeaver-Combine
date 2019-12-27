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
        let error = unpacker.unpack(sourcePath: temporaryFile().absoluteString, destinationPath: "")
        
        guard let unwrapedError = error as? ZipUnarchiver.ErrorType else { XCTFail(); return; }
        
        XCTAssertEqual(unwrapedError, ZipUnarchiver.ErrorType.incorrectDestinationPath)
    }
    
    func testUnzippingForBrokenArchive() {
        let unpacker = ZipUnarchiver()
        let error = unpacker.unpack(sourcePath: temporaryFile().absoluteString, destinationPath: NSTemporaryDirectory())
        
        guard let unwrapedError = error as? ZipUnarchiver.ErrorType else { XCTFail(); return; }
        
        XCTAssertEqual(unwrapedError, ZipUnarchiver.ErrorType.incorrectArchive)
    }

    static var allTests = [
        ("testParserCreation", testParserCreation),
        ("testUnzippingForEmptySourcePath", testUnzippingForEmptySourcePath),
        ("testUnzippingForEmptyDestinationPath", testUnzippingForEmptyDestinationPath),
    ]
}

func temporaryFile(for directoryPath: String = NSTemporaryDirectory(), name: String = UUID().uuidString) -> URL {
    guard let directoryURL = temporaryDirectoryURL(for: directoryPath) else { preconditionFailure() }
    let fileName = ProcessInfo().globallyUniqueString

    let fileURL = directoryURL.appendingPathComponent(fileName)
    try? Data(base64Encoded: "dummy-string")?.write(to: fileURL, options: .atomic)
    
    let exists = FileManager.default.fileExists(atPath: fileURL.absoluteString)
    
    return fileURL
}

func temporaryDirectoryURL(for directoryPath: String = NSTemporaryDirectory()) -> URL? {
    let destinationURL = URL(fileURLWithPath: directoryPath)

    return try? FileManager.default.url(for: .itemReplacementDirectory,
                                        in: .userDomainMask,
                                        appropriateFor: destinationURL,
                                        create: true)
}
