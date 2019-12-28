//
//  File.swift
//  
//
//  Created by skyylex on 28/12/2019.
//

import Foundation

struct FileSupport {
    static func nonExistingURL() -> URL {
        return temporaryDirectoryURL().appendingPathComponent(UUID().uuidString)
    }
    
    static func temporaryDirectoryURL() -> URL {
        return URL(fileURLWithPath: NSTemporaryDirectory())
    }
    
    static func createDummyFile(for directoryPath: String = NSTemporaryDirectory(),
                         fileName: String = UUID().uuidString) -> URL {
        let directoryURL = URL(fileURLWithPath: directoryPath)
        let fileURL = directoryURL.appendingPathComponent(fileName)
        
        do { try createDummyData().write(to: fileURL, options: .atomicWrite) }
        catch { preconditionFailure("Cannot write dummy data") }
        
        guard FileManager.default.fileExists(atPath: fileURL.path) else { preconditionFailure("Dummy file wasn't written") }
        
        return fileURL
    }

    static func createDummyData() -> Data {
        let randomString = UUID().uuidString
        guard let data = randomString.data(using: .utf8) else { preconditionFailure("Cannot create dummy data") }
        
        return data
    }
}
