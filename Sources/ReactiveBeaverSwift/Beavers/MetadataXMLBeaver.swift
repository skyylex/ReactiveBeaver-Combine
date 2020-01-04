//
//  File.swift
//  
//
//  Created by Yury Lapitsky on 02/01/2020.
//

import Foundation

struct MetadataXMLBeaver {
    typealias MetadataMap = [String : String]
    
    static func gnaw(metadataXML: SimpleXMLElement) -> Metadata? {
        let supportedKeys = [
            Metadata.Keys.titleKey,
            Metadata.Keys.creatorKey,
            Metadata.Keys.publisherKey,
            Metadata.Keys.identifierKey,
            Metadata.Keys.contributorKey,
            Metadata.Keys.languageKey,
            Metadata.Keys.rightsKey
        ]
        
        let singleAttributes = metadataXML.children.map { (xmlElement: SimpleXMLElement) -> MetadataMap in
            if supportedKeys.contains(xmlElement.name) {
                return [xmlElement.name : xmlElement.content]
            }
            
            return [:]
        }
        
        let combined = singleAttributes.reduce(MetadataMap()) { (aggregated: MetadataMap, current: MetadataMap) -> MetadataMap in
            return aggregated.merging(current) { (first, second) in
                return first
            }
        }
        
        return Metadata(metadataMap: combined)
    }
}
