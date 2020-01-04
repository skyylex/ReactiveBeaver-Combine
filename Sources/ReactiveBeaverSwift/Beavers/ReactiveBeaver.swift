import Foundation

protocol Unarchiver {
    func unpack(zipArchiveURL: URL, targetDirectoryURL: URL) -> Bool
}

struct ReactiveBeaver {
    typealias ParserCompletion = (Result<Epub, Error>) -> ()
    
    let unarchiver: Unarchiver
    
    init(unpacker: Unarchiver) {
        self.unarchiver = unpacker
    }
    
    func gnaw(epubURL: URL, destinationFolderURL: URL, completion: ParserCompletion) {
        let unarchivedResult = ArchiveBeaver.gnaw(archiveURL: epubURL, where: destinationFolderURL, using: unarchiver)
        
        switch unarchivedResult {
        case .success(let paths):
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
        case .failure(let error):
            completion(.failure(error))
        }
    }
    
}
