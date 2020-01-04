import XCTest
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
        let parser = Parser(unpacker: ZipUnarchiver())

        let expectation = self.expectation(description: "Parsing should return valid Epub object")
        parser.parse(epubURL: mobyDickEpubURL, destinationFolderURL: destinationFolderURL) { result in
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
    
    func testSpineXMLParsing() {
        let cover = "cover"
        let titlePage = "titlepage"
        
        let spineXMLString = """
        <spine>
          <itemref idref="\(cover)" linear="no"/>
          <itemref idref="\(titlePage)" linear="yes"/>
        </spine>
        """
        
        guard let xmlData = spineXMLString.data(using: .utf8) else { preconditionFailure("Failed to create xml data") }
        
        let parser = SimpleXMLBeaver()
        let result = parser.gnaw(xmlData: xmlData)
        
        switch result {
        case .success(let element):
            guard let spine = SpineXMLBeaver.gnaw(spineXML: element) else { XCTFail("SpineXML wasn't parsed"); return; }
            guard spine.items.count == 2 else { XCTFail("Wrong number of items inside Spine"); return; }
        
            XCTAssertEqual(spine.items[0].idRef, cover)
            XCTAssertEqual(spine.items[0].linear, false)
            XCTAssertEqual(spine.items[1].idRef, titlePage)
            XCTAssertEqual(spine.items[1].linear, true)
            
        case .failure(let error):
            XCTAssertFalse(true, "Spine XML parsing failed \(error)")
        }
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
            let container = ContainerXMLBeaver.gnaw(containerXML: element)
            XCTAssertEqual(container?.opfPackagePath ?? "", "OPS/package.opf")
        case .failure(let error):
            XCTAssertFalse(true, "Container XML parsing failed \(error)")
        }
    }
    
    func testMetadataXML() {
        let title = "Moby-Dick"
        let creator = "Herman Melville"
        let identifier = "code.google.com.epub-samples.moby-dick-basic"
        let language = "en-US"
        let publisher = "Harper &amp; Brothers, Publishers"
        let contributor = "Dave Cramer"
        let rights = "This work is shared using CC BY-SA 3.0 license."
        
        let metadataXMLString = """
        <metadata xmlns:dc="http://purl.org/dc/elements/1.1/">
          <dc:title id="title">\(title)</dc:title>
          <meta refines="#title" property="title-type">main</meta>
          <dc:creator id="creator">\(creator)</dc:creator>
          <meta refines="#creator" property="file-as">MELVILLE, HERMAN</meta>
          <meta refines="#creator" property="role" scheme="marc:relators">aut</meta>
          <dc:identifier id="pub-id">\(identifier)</dc:identifier>
          <dc:language>\(language)</dc:language>
          <meta property="dcterms:modified">2012-01-18T12:47:00Z</meta>
          <dc:publisher>\(publisher)</dc:publisher>
          <dc:contributor id="contrib1">\(contributor)</dc:contributor>
          <meta refines="#contrib1" property="role" scheme="marc:relators">mrk</meta>
          <dc:rights>\(rights)</dc:rights>
          <link rel="cc:license" href="http://creativecommons.org/licenses/by-sa/3.0/"/>
          <meta property="cc:attributionURL">http://code.google.com/p/epub-samples/</meta>
        </metadata>
        """
        
        guard let xmlData = metadataXMLString.data(using: .utf8) else { preconditionFailure("Failed to create xml data") }
        
        let parser = SimpleXMLBeaver()
        let result = parser.gnaw(xmlData: xmlData)
        
        switch result {
        case .success(let element):
            let metadata = MetadataXMLBeaver.gnaw(metadataXML: element)
            XCTAssertEqual(metadata?.title, title)
            XCTAssertEqual(metadata?.creator, creator)
            XCTAssertEqual(metadata?.publisher, publisher.replacingOccurrences(of: "&amp;", with: "&"))
            XCTAssertEqual(metadata?.contributor, contributor)
            XCTAssertEqual(metadata?.identifier, identifier)
            XCTAssertEqual(metadata?.language, language)
            XCTAssertEqual(metadata?.rights, rights)
        case .failure(let error):
            XCTAssertFalse(true, "Manifest XML parsing failed \(error)")
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
        ("testMetadataXML", testMetadataXML),
        ("testSpineXMLParsing", testSpineXMLParsing),
    ]
}
