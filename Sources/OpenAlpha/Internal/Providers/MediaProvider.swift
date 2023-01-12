//
//  MediaProvider.swift
//  
//
//  Created by Cole Roberts on 12/28/22.
//

import Foundation
import Network

// MARK: - `MediaProviding` -

/// `MediaProviding` is a protocol that defines a method for asynchronously retrieving an array of `Media` objects from a given IPv4 address.
/// The method can throw an error if the retrieval fails. Conforming types are expected to provide an implementation for this method.
protocol MediaProviding {
    /// Asynchronously retrieves an array of `Media` objects from the given IPv4 address.
    /// - Parameters:
    ///   - ip: The IPv4 address to retrieve media from.
    /// - Returns: An array of `Media` objects.
    /// - Throws: An error if the retrieval fails.
    func media(ip: String) async throws -> [Media]
}

// MARK: - `MediaProvider` -

final class MediaProvider: MediaProviding {
    
    // MARK: - `Private Properties` -
    
    private let session: URLSession
    
    // MARK: - `Init` -
    
    init(
        session: URLSession
    ) {
        self.session = session
    }
    
    // MARK: - `Public Methods` -
    
    func media(ip: String) async throws -> [Media] {
        do {
            let _ = try await DLNA.StartAction(ip: ip).send(session: session)
            let _ = try await DLNA.GetPushRootAction(ip: ip).send(session: session)
            let response = try await DLNA.BrowseAction(ip: ip).send(session: session)
            let result = try await ResultXMLParser(data: response).parse()
            let items = try await ItemXMLParser(result).parse()
            let media = items.compactMap(Media.init)
            
            for item in media {
                try await item.fetch()
            }
            
            _ = try await DLNA.EndAction(ip: ip).send(session: session)
            return media
        } catch {
            throw error
        }
    }
}
