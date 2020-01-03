//
//  File.swift
//  
//
//  Created by Yury Lapitsky on 02/01/2020.
//

import Foundation

final class ContainerXMLBeaver {
    
    static func gnaw(containerXML: SimpleXMLElement) -> ContainerXML? {
        return gnaw(element: containerXML)
    }
    
    private static func gnaw(element: SimpleXMLElement) -> ContainerXML? {
        if let fullPath = element.attributes[ContainerXML.Keys.fullPathKey],
               element.name == ContainerXML.Keys.targetNodeKey {
            guard let url = URL(string: fullPath) else { return nil }
            
            return ContainerXML(packageOpfURL: url)
        }

        return element.children.map { gnaw(containerXML: $0) }.compactMap { $0 }.first
    }
    
}
