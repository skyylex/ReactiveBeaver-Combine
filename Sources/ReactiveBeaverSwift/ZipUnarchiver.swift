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
            return ErrorGenerator.unpackerError(with: ZipUnarchiver.ErrorCode.incorrectSourcePath)
        }
        
        guard FileManager.default.directoryExists(at: destinationPath) else {
           return ErrorGenerator.unpackerError(with: ZipUnarchiver.ErrorCode.incorrectDestinationPath)
        }
        
        let sourceURL = URL(fileURLWithPath: sourcePath)
        let destinationURL = URL(fileURLWithPath: destinationPath)
        
        return nil
    }
}
