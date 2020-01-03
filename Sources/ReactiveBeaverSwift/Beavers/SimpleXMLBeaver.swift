//
//  File.swift
//  
//
//  Created by Yury Lapitsky on 02/01/2020.
//

import Foundation

final class SimpleXMLBeaver: NSObject, XMLParserDelegate {
    
    enum ErrorType: Error {
        case unknownError
    }
    
    var currentElement: SimpleXMLElement?
    var validationError: Error?
    var parsingError: Error?
    
    func gnaw(xmlData: Data) -> Result<SimpleXMLElement, Error> {
        let parser = XMLParser(data: xmlData)
        parser.delegate = self
        
        parser.parse()
        
        if let xmlElement = currentElement {
            return .success(xmlElement)
        } else if let error = anyError() {
            return .failure(error)
        } else {
            return .failure(ErrorType.unknownError)
        }
    }
    
    // MARK: Private
    private func anyError() -> Error? {
        return [parsingError, validationError].compactMap { $0 }.first
    }
    
    // MARK: <XMLParserDelegate>
    func parser(_ parser: XMLParser,
                didStartElement elementName: String,
                namespaceURI: String?,
                qualifiedName qName: String?,
                attributes attributeDict: [String : String] = [:]) {
        let newElement = SimpleXMLElement(title: elementName,
                                          parent: self.currentElement,
                                          attributes: attributeDict)
        currentElement?.add(child: newElement)
        currentElement = newElement
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        currentElement?.addContent(row: string)
    }
    
    func parser(_ parser: XMLParser,
                didEndElement elementName: String,
                namespaceURI: String?,
                qualifiedName qName: String?) {
        currentElement?.freeze()
        
        if let parent = currentElement?.parent {
            currentElement = parent
        }
    }
    
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        self.parsingError = parseError
    }
    
    func parser(_ parser: XMLParser, validationErrorOccurred validationError: Error) {
        self.validationError = validationError
    }
    
}
