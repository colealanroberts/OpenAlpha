//
//  ItemXMLParser.swift
//  
//
//  Created by Cole Roberts on 1/4/23.
//

import Foundation

final class ItemXMLParser: BaseXMLParser<[DIDLLite.Item]>, XMLParserDelegate {
    
    // MARK: - `Private Properties` -
    
    private var items = [DIDLLite.Item]()
    private var currentItem: DIDLLite.Item?
    private var currentSize: DIDLLite.Resource.Size?
    
    // MARK: - `Init` -
    
    init(_ value: String, shouldProcessNamespaces: Bool = true) {
        super.init(data: value.data(using: .utf8)!, shouldProcessNamespaces: shouldProcessNamespaces)
        delegate = self
    }

    override func parse() async throws -> [DIDLLite.Item] {
        return try await withCheckedThrowingContinuation { continuation in
            parserContinuation = continuation
            super.parse()
        }
    }
    
    // MARK: - `XMLParserDelegate` -
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        switch elementName {
        case "item":
            currentItem = .build(with: attributeDict)
        case "res":
            currentSize = .build(with: attributeDict)
        default:
            break
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        switch elementName {
        case "item":
            if let currentItem {
                items.append(currentItem)
                self.currentItem = nil
            }
        case "class":
            currentItem?.class = current.trimmingCharacters(in: .whitespacesAndNewlines)
        case "res":
            if let currentSize {
                let value = current.trimmingCharacters(in: .whitespacesAndNewlines)
                switch currentSize {
                case .small:
                    currentItem?.resource.small = value
                case .large:
                    currentItem?.resource.large = value
                case .thumbnail:
                    currentItem?.resource.thumbnail = value
                case .original:
                    currentItem?.resource.original = value
                }
            }
        default:
            break
        }
        
        current = ""
    }
    
    func parserDidEndDocument(_ parser: XMLParser) {
        parserContinuation?.resume(returning: items)
        parserContinuation = nil
        current = ""
    }

    func parser(_ parser: XMLParser, foundCharacters string: String) {
        current += string
    }
}
