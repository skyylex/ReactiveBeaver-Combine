import ZIPFoundation
import Foundation

struct Epub {
    let sha1: String
    let sourcePath: String
    let destinationPath: String
    let spineElements: [AnyObject] // TODO: improve types here
    let manifestElements: [AnyObject] // TODO: improve types here
    let coverPath: String?
    
    class NavPointElement {
        let level: String // FIXME type is not optimized here
        var parentElement: NavPointElement?
        let childElements: [NavPointElement]
        
        init(level: String, parentElement: NavPointElement? = nil, childElements: [NavPointElement] = []) {
            self.level = level
            self.parentElement = parentElement
            self.childElements = childElements
        }
    }
    
    enum ManifestXMLKey: String {
        case identifier = "id"
        case href = "href"
        case mediaType = "media-type"
    }
    
    struct ManifestElement {
        /// Should be unique inside manifest
        let identifier: String

        /// Relative URI string
        let href: String

        ///
        let mediaType: String // FIXME: not optimal type
    }
    
    struct Metadata {
        let title: String
        let creator: String
        let identifier: String
        let publisher: String
        let contributor: String
        let rights: String
    }
    
    struct SpineElement {
        let index: Int
        let idRef: String
        let fileName: String
    }
    
    struct OpfElement { }
}

final class ZipUnpacker {
    func unpack(sourcePath: String, destinationPath: String) {
        let sourceURL = URL(fileURLWithPath: sourcePath)
        let destinationURL = URL(fileURLWithPath: destinationPath)
        
        let error = try? FileManager.default.unzipItem(at: sourceURL, to: destinationURL)
    }
}

final class Parser {
    let unpacker: ZipUnpacker
    
    init(unpacker: ZipUnpacker = ZipUnpacker()) {
        self.unpacker = unpacker
    }
    
    func parse(sourcePath: String) -> Epub? {
        return nil
    }
    
    
}
