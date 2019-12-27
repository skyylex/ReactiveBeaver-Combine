import XCTest
@testable import ReactiveBeaverSwift

final class ReactiveBeaverSwiftTests: XCTestCase {
    func testParserCreation() {
        XCTAssertNotNil(Parser())
    }
    
    func testUnzippingForEmptySourcePath() {
        let unpacker = ZipUnarchiver()
        let error = unpacker.unpack(sourcePath: "", destinationPath: NSTemporaryDirectory())
        XCTAssertNotNil(error)
    }
    
    func testUnzippingForEmptyDestinationPath() {
        let unpacker = ZipUnarchiver()
        let error = unpacker.unpack(sourcePath: temporaryFile().absoluteString, destinationPath: "")
        XCTAssertNotNil(error)
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

    return directoryURL.appendingPathComponent(fileName)
}

func temporaryDirectoryURL(for directoryPath: String = NSTemporaryDirectory()) -> URL? {
    let destinationURL = URL(fileURLWithPath: directoryPath)

    return try? FileManager.default.url(for: .itemReplacementDirectory,
                                        in: .userDomainMask,
                                        appropriateFor: destinationURL,
                                        create: true)
}
