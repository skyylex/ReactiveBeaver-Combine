//
//  SpineXMLBeaverTests.swift
//  
//
//  Created by Yury Lapitsky on 04/02/2020.
//

import Foundation
import XCTest
@testable import ReactiveBeaverSwift

final class SpineXMLBeaverTests: XCTestCase {
    
    func testGnawingSpineSuccessfully() {
        let spine = SimpleXMLElement(title: "spine", parent: nil, attributes: [:])
        let item1 = SimpleXMLElement(title: "itemref", parent: nil, attributes: [
            "idref" : "cover",
            "linear" : "no",
        ])
        
        let item2 = SimpleXMLElement(title: "itemref", parent: nil, attributes: [
            "idref" : "xpreface",
            "linear" : "yes",
        ])
        
        spine.add(child: item1)
        spine.add(child: item2)
        
        let result = SpineXMLBeaver.gnaw(spineXML: spine)
        XCTAssertNotNil(result)
        XCTAssertEqual(result?.items.count, 2)
        
        XCTAssertEqual(result?.items.first?.idRef, "cover")
        XCTAssertEqual(result?.items.first?.linear, false)
        
        XCTAssertEqual(result?.items.last?.idRef, "xpreface")
        XCTAssertEqual(result?.items.last?.linear, true)
    }
    
    func testGnawingNotSpine() {
        let item = SimpleXMLElement(title: "itemref", parent: nil, attributes: [
            "idref" : "cover",
            "linear" : "no",
        ])
        
        let result = SpineXMLBeaver.gnaw(spineXML: item)
        XCTAssertNil(result)
    }
    
    func testGnawingSpineWithWrongElement() {
        let spine = SimpleXMLElement(title: "spine", parent: nil, attributes: [:])
        let wrongItem1 = SimpleXMLElement(title: "wrong-item", parent: nil, attributes: [:])
        let wrongItem2 = SimpleXMLElement(title: "wrong-item2", parent: nil, attributes: [:])
        
        spine.add(child: wrongItem1)
        spine.add(child: wrongItem2)
        
        let result = SpineXMLBeaver.gnaw(spineXML: spine)
        XCTAssertNotNil(result)
        XCTAssertEqual(result?.items.count, 0)
    }
    
}
