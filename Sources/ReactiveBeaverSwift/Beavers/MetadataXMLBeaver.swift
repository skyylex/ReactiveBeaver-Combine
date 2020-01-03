//
//  File.swift
//  
//
//  Created by Yury Lapitsky on 02/01/2020.
//

import Foundation

final class MetadataXMLBeaver {
    typealias MetadataMap = [String : String]
    
    struct SupportedMetaKeys {
        static let titleKey = "dc:title"
        static let languageKey = "dc:language"
        static let creatorKey = "dc:creator"
        static let publisherKey = "dc:publisher"
        static let identifierKey = "dc:identifier"
        static let contributorKey = "dc:contributor"
        static let rightsKey = "dc:rights"
    }
    
    struct Metadata {
        let title: String
        let creator: String
        let identifier: String
        let publisher: String
        let contributor: String
        let language: String
        let rights: String
        
        init(metadataMap: MetadataMap) {
            self.title = metadataMap[SupportedMetaKeys.titleKey] ?? ""
            self.creator = metadataMap[SupportedMetaKeys.creatorKey] ?? ""
            self.publisher = metadataMap[SupportedMetaKeys.publisherKey] ?? ""
            self.identifier = metadataMap[SupportedMetaKeys.identifierKey] ?? ""
            self.contributor = metadataMap[SupportedMetaKeys.contributorKey] ?? ""
            self.language = metadataMap[SupportedMetaKeys.languageKey] ?? ""
            self.rights = metadataMap[SupportedMetaKeys.rightsKey] ?? ""
        }
    }
    
    static func gnaw(metadataXML: SimpleXMLElement) -> Metadata {
        let supportedKeys = [
            SupportedMetaKeys.titleKey,
            SupportedMetaKeys.creatorKey,
            SupportedMetaKeys.publisherKey,
            SupportedMetaKeys.identifierKey,
            SupportedMetaKeys.contributorKey,
            SupportedMetaKeys.languageKey,
            SupportedMetaKeys.rightsKey
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
