//
//  ManifestXMLBeaver.swift
//  
//
//  Created by Yury Lapitsky on 02/01/2020.
//

import Foundation

/// A beaver that consumes XML <manifest> elements
/// and produces typed Manifest struct
struct ManifestXMLBeaver {
    
    private init() { }
    
    static func gnaw(manifestXML: SimpleXMLElement) -> Manifest? {
        guard manifestXML.name == Manifest.Keys.manifest else { return nil }
        
        let filteredItems = manifestXML.children.map(Manifest.Item.init).compactMap { $0 }
        
        return Manifest(items: filteredItems)
    }
    
}
