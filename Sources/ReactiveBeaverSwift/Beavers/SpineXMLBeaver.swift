//
//  File.swift
//  
//
//  Created by Yury Lapitsky on 03/01/2020.
//

import Foundation

enum BoolLiteral: String {
    case positive = "yes"
    case negative = "no"
    
    var boolValue: Bool {
        switch self {
        case .positive:
            return true
        case .negative:
            return false
        }
    }
}

struct SpineXMLBeaver {
    
    static func gnaw(spineXML: SimpleXMLElement) -> Spine? {
        guard spineXML.name == Spine.Keys.spineKey else { return nil }
        
        let items = spineXML.children.map { Spine.ItemRef(xmlElement: $0) }.compactMap { $0 }
        
        return Spine(items: items)
    }

}
