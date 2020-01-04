//
//  ZipUnarchiver.swift
//  
//
//  Created by skyylex on 28/12/2019.
//

import Foundation
import ZIPFoundation

final class ZipUnarchiver: Unarchiver {
    func unpack(zipArchiveURL: URL, targetDirectoryURL: URL) -> Bool {
        guard PathValidator.validate(fileURL: zipArchiveURL) else {
            return false
        }
        
        guard PathValidator.validate(directoryURL: targetDirectoryURL) else {
           return false
        }
        
        do {
            try FileManager.default.unzipItem(at: zipArchiveURL, to: targetDirectoryURL)
        } catch {
            return false
        }
        
        return true
    }
}
