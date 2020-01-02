//
//  File.swift
//  
//
//  Created by Yury Lapitsky on 02/01/2020.
//

import Foundation

final class ContainerXMLBeaver {
    struct Keys {
        static let targetNodeKey = "rootfile"
        static let fullPathKey = "full-path"
    }
    
    typealias PackageOpfURL = URL
    
    static func gnaw(containerXML: SimpleXMLElement) -> PackageOpfURL? {
        return gnaw(element: containerXML)
    }
    
    private static func gnaw(element: SimpleXMLElement) -> PackageOpfURL? {
        if let fullPath = element.attributes[Keys.fullPathKey], element.title == Keys.targetNodeKey {
            return URL(string: fullPath)
        }

        return element.children.map { gnaw(containerXML: $0) }.compactMap { $0 }.first
    }
}
