//
//  File.swift
//  
//
//  Created by Yury Lapitsky on 02/01/2020.
//

import Foundation

struct ContainerXMLBeaver {
    
    static func gnaw(containerXML: SimpleXMLElement) -> Container? {
        return gnaw(element: containerXML)
    }
    
    private static func gnaw(element: SimpleXMLElement) -> Container? {
        if let fullPath = element.attributes[Container.Keys.fullPathKey],
               element.name == Container.Keys.targetNodeKey {
            guard let url = URL(string: fullPath) else { return nil }
            
            return Container(opfPackagePath: url.path)
        }

        return element.children.map { gnaw(containerXML: $0) }.compactMap { $0 }.first
    }
    
}
