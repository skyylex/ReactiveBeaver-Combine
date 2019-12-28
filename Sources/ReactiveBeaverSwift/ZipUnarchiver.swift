//
//  ZipUnarchiver.swift
//  
//
//  Created by skyylex on 28/12/2019.
//

import Foundation
import ZIPFoundation

final class ZipUnarchiver {
    func unpack(zipArchiveURL: URL, targetDirectoryURL: URL) -> Error? {
        guard PathValidator.validate(fileURL: zipArchiveURL) else {
            return ErrorType.incorrectSourcePath
        }
        
        guard PathValidator.validate(directoryURL: targetDirectoryURL) else {
           return ErrorType.incorrectDestinationPath
        }
        
        do {
            try FileManager.default.unzipItem(at: zipArchiveURL, to: targetDirectoryURL)
        } catch {
            return ErrorType.incorrectArchive
        }
        
        return nil // Success with no error
    }
}
