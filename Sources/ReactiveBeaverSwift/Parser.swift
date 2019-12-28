import Foundation

final class Parser {
    typealias ParserCompletion = (Result<Epub, Error>) -> ()
    
    let unpacker: ZipUnarchiver
    
    init(unpacker: ZipUnarchiver = ZipUnarchiver()) {
        self.unpacker = unpacker
    }
    
    func parse(epubURL: URL, destinationFolderURL: URL, completion: ParserCompletion) {
        guard PathValidator.validate(fileURL: epubURL) else {
            completion(.failure(ErrorType.incorrectSourcePath))
            return
        }
        
        guard PathValidator.validate(directoryURL: destinationFolderURL) else {
            completion(.failure(ErrorType.incorrectDestinationPath))
            return
        }
        
        completion(.success(createDummyEpub(epubURL: epubURL, destinationFolderURL: destinationFolderURL)))
    }
    
    // MARK: Dummy data
    
    func createDummyEpub(epubURL: URL, destinationFolderURL: URL) -> Epub {
        return Epub(
            sha1: "",
            sourcePath: epubURL,
            destinationPath: destinationFolderURL,
            spineElements: [],
            manifestElements: [],
            coverPath: nil
        )
    }
}
