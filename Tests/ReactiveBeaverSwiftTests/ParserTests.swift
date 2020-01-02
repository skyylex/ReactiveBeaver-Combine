import XCTest
import Kanna
@testable import ReactiveBeaverSwift

struct MockedUnarchiver: Unarchiver {
    func unpack(zipArchiveURL: URL, targetDirectoryURL: URL) -> Error? {
        return nil
    }
}

final class ParserTests: XCTestCase {
    var mobyDickEpubURL: URL!
    var destinationFolderURL: URL!
    
    override func setUp() {
        mobyDickEpubURL = mobyDickFileURL()
        destinationFolderURL = createTempFolderURL()
    }
    
    func testParsing() {
        let parser = Parser(unpacker: MockedUnarchiver())

        let expectation = self.expectation(description: "Parsing should return valid Epub object")
        parser.parse(epubURL: mobyDickEpubURL, destinationFolderURL: destinationFolderURL) { result in
            switch (result) {
            case .failure(_):
                break
            case .success(let epub):
                XCTAssertEqual(epub.sha1, "F9E72E387F1D844B767C961AE98B8AFED6BDE76A")
                expectation.fulfill()
            }
        }

        wait(for: [expectation], timeout: 0.1)
    }
    
    func testContainerXMLParsing() {
        let sampleContainerXML = """
        <?xml version="1.0" encoding="UTF-8"?><container xmlns="urn:oasis:names:tc:opendocument:xmlns:container" version="1.0">
        <rootfiles>
        <rootfile full-path="OPS/package.opf" media-type="application/oebps-package+xml"/>
        </rootfiles>
        </container>
        """
        
        guard let xmlData = sampleContainerXML.data(using: .utf8) else { preconditionFailure("Failed to create xml data") }
        
        let parser = SimpleXMLBeaver()
        let result = parser.gnaw(xmlData: xmlData)
        
        switch result {
        case .success(let element):
            let packageOpfURL = ContainerXMLBeaver.gnaw(containerXML: element)
            XCTAssertEqual(packageOpfURL?.path ?? "", "OPS/package.opf")
        case .failure(let error):
            XCTAssertFalse(true, "Container XML parsing failed \(error)")
        }
    }
    
    func testManifestXML() {
        let manifestXMLString = """
        <manifest>
        <item id="font.stix.regular" href="fonts/STIXGeneral.otf"
          media-type="application/vnd.ms-opentype"/>
        <item id="font.stix.italic" href="fonts/STIXGeneralItalic.otf"
          media-type="application/vnd.ms-opentype"/>
        <item id="font.stix.bold" href="fonts/STIXGeneralBol.otf"
          media-type="application/vnd.ms-opentype"/>
        <item id="font.stix.bold.italic" href="fonts/STIXGeneralBolIta.otf"
          media-type="application/vnd.ms-opentype"/>
        """
        
        guard let xmlData = manifestXMLString.data(using: .utf8) else { preconditionFailure("Failed to create xml data") }
        
        let parser = SimpleXMLBeaver()
        let result = parser.gnaw(xmlData: xmlData)
        
        switch result {
        case .success(let element):
            let manifest = ManifestXMLBeaver.gnaw(manifestXML: element)
            XCTAssertEqual(manifest?.items.count ?? 0, 4)
        case .failure(let error):
            XCTAssertFalse(true, "Manifest XML parsing failed \(error)")
        }
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
        ("testParsing", testParsing),
        ("testContainerXMLParsing", testContainerXMLParsing),
        ("testManifestXML", testManifestXML),
    ]
}
