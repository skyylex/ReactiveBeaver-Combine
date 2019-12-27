//
//  File.swift
//  
//
//  Created by skyylex on 28/12/2019.
//

import Foundation

struct Epub {
    let sha1: String
    let sourcePath: String
    let destinationPath: String
    let spineElements: [AnyObject] // TODO: improve types here
    let manifestElements: [AnyObject] // TODO: improve types here
    let coverPath: String?
    
    class NavPointElement {
        let level: String // FIXME type is not optimized here
        var parentElement: NavPointElement?
        let childElements: [NavPointElement]
        
        init(level: String, parentElement: NavPointElement? = nil, childElements: [NavPointElement] = []) {
            self.level = level
            self.parentElement = parentElement
            self.childElements = childElements
        }
    }
    
    enum ManifestXMLKey: String {
        case identifier = "id"
        case href = "href"
        case mediaType = "media-type"
    }
    
    struct ManifestElement {
        /// Should be unique inside manifest
        let identifier: String

        /// Relative URI string
        let href: String

        ///
        let mediaType: String // FIXME: not optimal type
    }
    
    struct Metadata {
        let title: String
        let creator: String
        let identifier: String
        let publisher: String
        let contributor: String
        let rights: String
    }
    
    struct SpineElement {
        let index: Int
        let idRef: String
        let fileName: String
    }
    
    struct OpfElement { }
}
