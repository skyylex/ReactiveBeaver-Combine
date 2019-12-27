import Combine

struct Epub {
    let sha1: String
    let sourcePath: String
    let destinationPath: String
    let spineElements: [AnyObject] // TODO: improve types here
    let manifestElements: [AnyObject] // TODO: improve types here
    let coverPath: String?
}

final class ZipUnpacker {
    func unpack(sourcePath: String) -> String? {
        return nil
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
