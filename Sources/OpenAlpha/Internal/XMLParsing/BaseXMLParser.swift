//
//  BaseXMLParser.swift
//  
//
//  Created by Cole Roberts on 12/28/22.
//

import Foundation

// MARK: - `XMLProviding` -

protocol XMLParsing: XMLParser {
    associatedtype Result
    func parse() async throws -> Result
}

// MARK: - `XMLProvider` -

class BaseXMLParser<T>: XMLParser, XMLParsing {
    
    typealias Result = T
    
    // MARK: - `Private Properties` -
    
    var current: String = ""
    
    var parserContinuation: CheckedContinuation<T, Error>?
    
    // MARK: - `Init` -
    
    init(data: Data, shouldProcessNamespaces: Bool = true) {
        super.init(data: data)
        self.shouldProcessNamespaces = shouldProcessNamespaces
    }
    
    // MARK: - `Public Methods` -
    
    func parse() async throws -> T {
        return try await withCheckedThrowingContinuation { continuation in
            parserContinuation = continuation
            self.parse()
        }
    }
}
