//
//  File.swift
//  
//
//  Created by Yury Lapitsky on 04/01/2020.
//

import Foundation

struct ArchiveBeaver {
    
    static func gnaw(archiveURL: URL,
                     where destinationFolder: URL,
                     using unarhiver: Unarchiver) -> Result<BasicPaths, Error> {
        guard PathValidator.validate(fileURL: archiveURL) else {
            return .failure(ErrorType.incorrectSourcePath)
        }
        
        guard PathValidator.validate(directoryURL: destinationFolder) else {
            return .failure(ErrorType.incorrectDestinationPath)
        }
        
        guard unarhiver.unpack(zipArchiveURL: archiveURL, targetDirectoryURL: destinationFolder) else {
            return .failure(ErrorType.cannotUnarchive)
        }
        
        let paths = BasicPaths(rootURL: destinationFolder)
        if let error = PathValidator.validate(paths: paths).first {
            return .failure(error)
        } else {
            return .success(paths)
        }
    }
    
}
