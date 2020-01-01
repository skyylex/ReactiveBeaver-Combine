//
//  File.swift
//  
//
//  Created by skyylex on 28/12/2019.
//

import Foundation

struct Paths {
    private static let metaInfoKey = "META-INF"
    private static let oebpsKey = "OEBPS"
    private static let containerXMLKey = "container.xml"
    
    let metaInfDirectory: URL
    let oebpsDirectory: URL
    let containerXML: URL
    
    init(epubUnzippedFolderURL: URL) {
        metaInfDirectory = epubUnzippedFolderURL.appendingPathComponent(Paths.metaInfoKey)
        oebpsDirectory = epubUnzippedFolderURL.appendingPathComponent(Paths.oebpsKey)
        containerXML = metaInfDirectory.appendingPathComponent(Paths.containerXMLKey)
    }
}

struct PathValidator {
    static func validate(fileURL: URL) -> Bool {
        return FileManager.default.fileExists(atPath: fileURL.path) == true &&
               FileManager.default.directoryExists(at: fileURL.path) == false
    }
    
    static func validate(directoryURL: URL) -> Bool {
        return FileManager.default.directoryExists(at: directoryURL.path)
    }
    
    static func validate(paths: Paths) -> [ErrorType] {
        let fileURLs = [
            paths.containerXML,
        ]
        
        let directoryURLs = [
            paths.metaInfDirectory,
            paths.oebpsDirectory,
        ]
        
        let errorFromURL = { (invalidItemURL: URL) in
            return invalidItemURL.isFileURL ? ErrorType.missingFile(invalidItemURL)
                                            : ErrorType.missingDirectory(invalidItemURL)
        }
        
        let validatedFileURLs = fileURLs.map { (fileURL: URL) -> (URL, Bool) in
            return (fileURL, PathValidator.validate(fileURL: fileURL))
        }
        
        let validatedDirectoryURLs = directoryURLs.map { (directoryURL: URL) -> (URL, Bool) in
            return (directoryURL, PathValidator.validate(directoryURL: directoryURL))
        }
        
        let validatedItems = validatedDirectoryURLs + validatedFileURLs
        let invalidItems = validatedItems.filter { (url, isValid) -> Bool in return !isValid }
        let brokenURLs = invalidItems.map { (url, _) -> URL in return url }
        
        return brokenURLs.map(errorFromURL)
    }
}
