//
//  File.swift
//  
//
//  Created by skyylex on 27/12/2019.
//

import Foundation

extension ZipUnarchiver {
    
    enum ErrorType: Error {
        case incorrectDestinationPath
        case incorrectSourcePath
        case incorrectArchive
    }
}

extension Parser {
    
    enum ErrorType: Error {
        case incorrectDestinationPath
        case incorrectSourcePath
        case inputParamsValidation
        case noDestinationFolder
        case xmlFileOpening
        case xmlNoFullPathAttribute
        case xmlNoRootFileElement
    }
    
}

extension PathValidator {
    enum ErrorType: Error {
        case missingFile(URL)
        case missingDirectory(URL)
    }
}

