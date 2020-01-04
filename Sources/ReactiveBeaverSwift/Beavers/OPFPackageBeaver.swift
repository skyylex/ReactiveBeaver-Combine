//
//  File.swift
//  
//
//  Created by Yury Lapitsky on 03/01/2020.
//

import Foundation

struct OPFPackage {
    enum SupportedElement: String {
        case spine = "spine"
        case metadata = "metadata"
        case manifest = "manifest"
        case package = "package"
    }
    
    let metadata: Metadata
    let manifest: Manifest
    let spine: Spine
    
    init?(itemsMap: [SupportedElement : AnyObject]) {
        guard let spine = itemsMap[.spine] as? Spine else { return nil }
        guard let metadata = itemsMap[.metadata] as? Metadata else { return nil }
        guard let manifest = itemsMap[.manifest] as? Manifest else { return nil }
        
        self.spine = spine
        self.manifest = manifest
        self.metadata = metadata
    }
}

struct OPFPackageBeaver {
    typealias ElementType = OPFPackage.SupportedElement
    typealias PackageInfoMap = [ElementType : AnyObject]
    
    static func gnaw(packageXML: SimpleXMLElement) -> OPFPackage? {
        guard let supportedType = ElementType(rawValue: packageXML.name) else { return nil }
        guard supportedType == .package else { return nil }
        
        let xmlsMap = packageXML.children.reduce(PackageInfoMap()) { (aggregated, element) -> PackageInfoMap in
            guard let (type, info) = gnaw(xmlElement: element) else { return aggregated }
            
            return aggregated.merging([type : info]) { (first, second) in first }
        }
        
        return OPFPackage(itemsMap: xmlsMap)
    }
    
    private static func gnaw(xmlElement: SimpleXMLElement) -> (ElementType, AnyObject)? {
        guard let type = ElementType(rawValue: xmlElement.name) else { return nil }
        
        var processed: AnyObject?
        switch type {
        case .spine:
            processed = SpineXMLBeaver.gnaw(spineXML: xmlElement) as AnyObject
        case .metadata:
            processed = MetadataXMLBeaver.gnaw(metadataXML: xmlElement) as AnyObject
        case .manifest:
            processed = ManifestXMLBeaver.gnaw(manifestXML: xmlElement) as AnyObject
        case .package:
            processed = nil
        }
        
        guard let info = processed else { return nil }
        
        return (type, info)
    }
    
}
