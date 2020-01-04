//
//  File.swift
//  
//
//  Created by Yury Lapitsky on 02/01/2020.
//

import Foundation

struct ManifestXMLBeaver {
    
    static func gnaw(manifestXML: SimpleXMLElement) -> Manifest? {
        guard manifestXML.name == Manifest.Keys.manifest else { return nil }
        
        let nullableItems = manifestXML.children.map { (element) -> Manifest.Item? in
            guard let identifier = element.attributes[Manifest.Keys.id],
                  let path = element.attributes[Manifest.Keys.href],
                  let mediaType = element.attributes[Manifest.Keys.mediaType] else {
                return nil
            }
            
            return Manifest.Item(identifier: identifier, path: path, mediaType: mediaType)
        }
        
        let filteredItems = nullableItems.compactMap { $0 }
        
        return Manifest(items: filteredItems)
    }
}
