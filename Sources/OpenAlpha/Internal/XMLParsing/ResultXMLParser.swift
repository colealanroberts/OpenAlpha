//
//  ResultXMLParser.swift
//  
//
//  Created by Cole Roberts on 1/4/23.
//

import Foundation

final class ResultXMLParser: BaseXMLParser<String>, XMLParserDelegate {
    override init(data: Data, shouldProcessNamespaces: Bool = true) {
        super.init(data: data, shouldProcessNamespaces: shouldProcessNamespaces)
        delegate = self
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        switch elementName {
        case "Result":
            parserContinuation?.resume(returning: current)
            parserContinuation = nil
            current = ""
        default:
            break
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        current += string
    }
    
    override func parse() async throws -> String {
        return try await withCheckedThrowingContinuation { continuation in
            parserContinuation = continuation
            super.parse()
        }
    }
}
