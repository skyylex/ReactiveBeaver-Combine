//
//  File.swift
//  
//
//  Created by Yury Lapitsky on 02/01/2020.
//

import Foundation

class ManifestXMLBeaver {
    struct Manifest {
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
    
    struct Keys {
        static let id = "id"
        static let href = "href"
        static let mediaType = "media-type"
        static let manifest = "manifest"
    }
    
    static func gnaw(manifestXML: SimpleXMLElement) -> Manifest? {
        guard manifestXML.name == Keys.manifest else { return nil }
        
        let nullableItems = manifestXML.children.map { (element) -> Manifest.Item? in
            guard let identifier = element.attributes[Keys.id],
                  let path = element.attributes[Keys.href],
                  let mediaType = element.attributes[Keys.mediaType] else {
                return nil
            }
            
            return Manifest.Item(identifier: identifier, path: path, mediaType: mediaType)
        }
        
        let filteredItems = nullableItems.compactMap { $0 }
        
        return Manifest(items: filteredItems)
    }
}
