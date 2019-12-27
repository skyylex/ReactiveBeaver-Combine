import Foundation

final class Parser {
    let unpacker: ZipUnarchiver
    
    init(unpacker: ZipUnarchiver = ZipUnarchiver()) {
        self.unpacker = unpacker
    }
    
    func parse(sourcePath: String) -> Epub? {
        return nil
    }
    
    
}
