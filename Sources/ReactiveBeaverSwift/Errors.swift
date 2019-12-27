//
//  File.swift
//  
//
//  Created by skyylex on 27/12/2019.
//

import Foundation

extension ZipUnpacker {
    static let errorDomain = "ReactiveBeaverSwift.ZipUnpacker.Error"
    
    enum ErrorCode: Int {
        case incorrectDestinationPath
        case incorrectSourcePath
    }
}

extension Parser {
    
    static let errorDomain = "ReactiveBeaverSwift.Epub.Parser.Error"
    
    enum ErrorCode: Int {
        case incorrectDestinationPath
        case incorrectSourcePath
        case inputParamsValidation
        case noDestinationFolder
        case xmlFileOpening
        case xmlNoFullPathAttribute
        case xmlNoRootFileElement
    }
    
}

extension Epub.ManifestElement {
    
    static let errorDomain = "ReactiveBeaverSwift.ManifestElement.Parser.Error"
    
    enum ErrorCode: Int {
        case multipleTags
        case noDocument
    }
    
}

extension Epub.Metadata {
    
    static let errorDomain = "ReactiveBeaverSwift.Metadata.Parser.Error"
    
    enum ErrorCode: Int {
        case wrongNumberOfTags
        case noDocument
    }
    
}

extension Epub.SpineElement {
    
    static let errorDomain = "ReactiveBeaverSwift.SpineElement.Parser.Error"
    
    enum ErrorCode: Int {
        case noSpineElements
        case noDocument
        case noElementByIDRef
    }
    
}

extension Epub.OpfElement {
    
    static let errorDomain = "ReactiveBeaverSwift.OpfElement.Parser.Error"
    
    enum ErrorCode: Int {
        case noDocument
        case wrongArguments
    }
    
}

struct ErrorGenerator {
    
    static func unpackerError(with errorCode: ZipUnpacker.ErrorCode) -> Error {
        return NSError(domain: ZipUnpacker.errorDomain, code: errorCode.rawValue)
    }
    
    static func epubParserError(with errorCode: Parser.ErrorCode) -> Error {
        return NSError(domain: Parser.errorDomain, code: errorCode.rawValue)
    }
    
    static func manifestParserError(with errorCode: Epub.ManifestElement.ErrorCode) -> Error {
        return NSError(domain: Epub.ManifestElement.errorDomain, code: errorCode.rawValue)
    }
    
    static func metadataParserError(with errorCode: Epub.Metadata.ErrorCode) -> Error {
        return NSError(domain: Epub.Metadata.errorDomain, code: errorCode.rawValue)
    }
    
    static func spineParserError(with errorCode: Epub.SpineElement.ErrorCode) -> Error {
        return NSError(domain: Epub.SpineElement.errorDomain, code: errorCode.rawValue)
    }
    
    static func opfParserError(with errorCode: Epub.OpfElement.ErrorCode) -> Error {
        return NSError(domain: Epub.OpfElement.errorDomain, code: errorCode.rawValue)
    }
    
}

