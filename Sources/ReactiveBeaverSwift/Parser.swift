import Foundation

protocol Unarchiver {
    func unpack(zipArchiveURL: URL, targetDirectoryURL: URL) -> Error?
}

final class Parser {
    typealias ParserCompletion = (Result<Epub, Error>) -> ()
    
    let unpacker: Unarchiver
    
    init(unpacker: Unarchiver) {
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
        
        let error = unpacker.unpack(zipArchiveURL: epubURL, targetDirectoryURL: destinationFolderURL)
        if let error = error {
            completion(.failure(error))
        } else {
            let paths = BasicPaths(rootURL: destinationFolderURL)
            if let error = PathValidator.validate(paths: paths).first {
                completion(.failure(error))
            } else {
                guard let containerXMLData = try? Data(contentsOf: paths.containerXML) else {
                    completion(.failure(ErrorType.xmlFileOpening))
                    return
                }
                
                let xmlBeaver = SimpleXMLBeaver()
                
                let containerResult = xmlBeaver.gnaw(xmlData: containerXMLData)
                
                switch containerResult {
                case .success(let containerXML):
                    guard let containerDocument = ContainerXMLBeaver.gnaw(containerXML: containerXML) else {
                        completion(.failure(ErrorType.incorrectContainerXML))
                        return
                    }
                    
                    let detailedPath = DetailedPaths(rootURL: paths.rootURL,
                                                     opfPackagePath: containerDocument.opfPackagePath)
                    
                    guard let opfData = try? Data(contentsOf: detailedPath.opfPackageURL) else {
                        completion(.failure(ErrorType.xmlFileOpening))
                        return
                    }
            
                    let xmlBeaver = SimpleXMLBeaver()
                    let opfResult = xmlBeaver.gnaw(xmlData: opfData)
                    switch opfResult {
                    case .success(let xmlDocument):
                        guard let opfPackage = OPFPackageBeaver.gnaw(packageXML: xmlDocument) else {
                            completion(.failure(ErrorType.cannotParseOPFFile))
                            return
                        }
                        
                        completion(.success(
                            Epub(destinationPath: destinationFolderURL, opfPackage: opfPackage)
                        ))
                    case .failure(let error):
                        completion(.failure(error))
                    }
                    
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }

}
