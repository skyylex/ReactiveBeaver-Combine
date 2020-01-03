//
//  File.swift
//  
//
//  Created by skyylex on 28/12/2019.
//

import Foundation

struct Epub {
    let sha1: String // FIXME: type is not optimized here
    let sourcePath: URL
    let destinationPath: URL
    let spine: Spine
    let manifest: Manifest
    let metadata: Metadata
    let container: ContainerXML
    let coverPath: URL?
    
    class NavPointElement {
        let level: String // FIXME: type is not optimized here
        var parentElement: NavPointElement?
        let childElements: [NavPointElement]
        
        init(level: String, parentElement: NavPointElement? = nil, childElements: [NavPointElement] = []) {
            self.level = level
            self.parentElement = parentElement
            self.childElements = childElements
        }
    }
}

struct ContainerXML {
    struct Keys {
        static let targetNodeKey = "rootfile"
        static let fullPathKey = "full-path"
    }
    
    let packageOpfURL: URL
}

struct Metadata {
    let title: String
    let creator: String
    let identifier: String
    let publisher: String
    let contributor: String
    let language: String
    let rights: String
    
    init(metadataMap: [String : String]) {
        self.title = metadataMap[Keys.titleKey] ?? ""
        self.creator = metadataMap[Keys.creatorKey] ?? ""
        self.publisher = metadataMap[Keys.publisherKey] ?? ""
        self.identifier = metadataMap[Keys.identifierKey] ?? ""
        self.contributor = metadataMap[Keys.contributorKey] ?? ""
        self.language = metadataMap[Keys.languageKey] ?? ""
        self.rights = metadataMap[Keys.rightsKey] ?? ""
    }
    
    struct Keys {
        static let titleKey = "dc:title"
        static let languageKey = "dc:language"
        static let creatorKey = "dc:creator"
        static let publisherKey = "dc:publisher"
        static let identifierKey = "dc:identifier"
        static let contributorKey = "dc:contributor"
        static let rightsKey = "dc:rights"
    }
}

struct Manifest {
    
    struct Keys {
        static let id = "id"
        static let href = "href"
        static let mediaType = "media-type"
        static let manifest = "manifest"
    }
    
    struct Item {
        let identifier: String
        let path: String // URL?
        let mediaType: String // Ideally, should be enum
        
        init(identifier: String, path: String, mediaType: String) {
            self.identifier = identifier
            self.path = path
            self.mediaType = mediaType
        }
        
        init?(xmlElement: SimpleXMLElement) {
            guard let identifier = xmlElement.attributes[Keys.id],
                  let path = xmlElement.attributes[Keys.href],
                  let mediaType = xmlElement.attributes[Keys.mediaType] else {
                return nil
            }
            
            self.init(identifier: identifier, path: path, mediaType: mediaType)
        }
    }
    
    let items: [Item]
    
    init(items: [Item]) {
        self.items = items
    }

}

struct Spine {
    struct Keys {
        static let spineKey = "spine"
        static let idRefKey = "idref"
        static let linearKey = "linear"
        static let itemRefKey = "itemref"
    }
    
    struct ItemRef {
        let linear: Bool
        let idRef: String
        
        init?(xmlElement: SimpleXMLElement) {
            guard xmlElement.name == Keys.itemRefKey else { return nil }
            guard let linear = BoolLiteral(rawValue: xmlElement.attributes[Keys.linearKey] ?? "") else { return nil }
            guard let idRef = xmlElement.attributes[Keys.idRefKey] else { return nil }
            
            self.linear = linear.boolValue
            self.idRef = idRef
        }
    }
    
    let items: [ItemRef]
}

final class SimpleXMLElement {
    
    let name: String
    let parent: SimpleXMLElement?
    let attributes: [String : String]
    
    private(set) var isFrozen = false
    private(set) var content: String = ""
    private(set) var children = [SimpleXMLElement]()
    
    init(title: String, parent: SimpleXMLElement?, attributes: [String : String]) {
        self.name = title
        self.parent = parent
        self.attributes = attributes
    }
    
    func freeze() {
        isFrozen = true
    }
    
    func add(child: SimpleXMLElement) {
        guard !isFrozen else { preconditionFailure("Frozen elements shouldn't be changed") }
        
        children += [child]
    }
    
    func addContent(row: String) {
        guard !isFrozen else { preconditionFailure("Frozen elements shouldn't be changed") }
        
        self.content += row
    }
    
}
