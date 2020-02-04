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
        do {
            try FileManager.default.unzipItem(at: zipArchiveURL, to: targetDirectoryURL)
        } catch {
            return false
        }
        
        return true
    }
}
