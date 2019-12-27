//
//  ZipUnarchiver.swift
//  
//
//  Created by skyylex on 28/12/2019.
//

import Foundation
import ZIPFoundation

final class ZipUnarchiver {
    func unpack(sourcePath: String, destinationPath: String) -> Error? {
        guard FileManager.default.fileExists(atPath: sourcePath) else {
            return ErrorType.incorrectSourcePath
        }
        
        guard FileManager.default.directoryExists(at: destinationPath) else {
           return ErrorType.incorrectDestinationPath
        }
        
        let sourceURL = URL(fileURLWithPath: sourcePath)
        let destinationURL = URL(fileURLWithPath: destinationPath)
        
        
        do {
            try FileManager.default.unzipItem(at: sourceURL, to: destinationURL)
        } catch {
            return ErrorType.incorrectArchive
        }
        
        return nil // Success with no error
    }
}
