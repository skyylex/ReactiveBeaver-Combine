//
//  File.swift
//  
//
//  Created by skyylex on 28/12/2019.
//

import Foundation

struct BasicPaths {
    private static let metaInfoKey = "META-INF"
    private static let containerXMLKey = "container.xml"
    
    let rootURL: URL
    let metaInfDirectory: URL
    let containerXML: URL
    
    init(rootURL: URL) {
        self.rootURL = rootURL
        self.metaInfDirectory = rootURL.appendingPathComponent(BasicPaths.metaInfoKey)
        self.containerXML = metaInfDirectory.appendingPathComponent(BasicPaths.containerXMLKey)
    }
}

struct DetailedPaths {
    let opfPackageURL: URL
    
    init(rootURL: URL, opfPackagePath: String) {
        self.opfPackageURL = DetailedPaths.completeURL(base: rootURL, pathToFile: opfPackagePath)
    }
    
    private static func completeURL(base: URL, pathToFile: String) -> URL {
        if pathToFile.hasPrefix(base.path) {
            return URL(fileURLWithPath: pathToFile)
        } else {
            return base.appendingPathComponent(pathToFile)
        }
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
    
    static func validate(paths: BasicPaths) -> [ErrorType] {
        let fileURLs = [
            paths.containerXML,
        ]
        
        let directoryURLs = [
            paths.metaInfDirectory,
        ]
        
        let errorFromURL = { (invalidItemURL: URL) in
            return invalidItemURL.pathExtension.isEmpty ? ErrorType.missingDirectory(invalidItemURL)
                                                        : ErrorType.missingFile(invalidItemURL)
                                                        
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
