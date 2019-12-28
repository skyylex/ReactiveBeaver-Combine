//
//  File.swift
//  
//
//  Created by skyylex on 28/12/2019.
//

import Foundation

struct PathValidator {
    static func validate(fileURL: URL) -> Bool {
        return FileManager.default.fileExists(atPath: fileURL.path) == true &&
               FileManager.default.directoryExists(at: fileURL.path) == false
    }
    
    static func validate(directoryURL: URL) -> Bool {
        return FileManager.default.directoryExists(at: directoryURL.path)
    }
}
