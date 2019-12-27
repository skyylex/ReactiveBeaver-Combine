//
//  File.swift
//  
//
//  Created by skyylex on 27/12/2019.
//

import Foundation

extension FileManager {
    func directoryExists(at path: String) -> Bool {
        var isDirectory = ObjCBool(booleanLiteral: false)
        let isDirectoryPointer = UnsafeMutablePointer<ObjCBool>(mutating: &isDirectory)
        let exists = fileExists(atPath: path, isDirectory: isDirectoryPointer)
        
        return exists && isDirectory.boolValue
    }
}
