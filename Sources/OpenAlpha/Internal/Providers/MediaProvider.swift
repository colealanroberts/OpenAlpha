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
/// The method can throw an error if the retrieval fails.
protocol MediaProviding {
    /// Asynchronously retrieves an array of `Media` objects from the given IPv4 address.
    /// - Parameters:
    ///   - from: The IPv4 address to retrieve media from.
    /// - Returns: An array of `Media` objects.
    /// - Throws: An error if the retrieval fails.
    func media(sizes: [Media.Size], from ip: String) async throws -> [Media]
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
    
    func media(sizes: [Media.Size], from ip: String) async throws -> [Media] {
        do {
            let _ = try await DLNA.StartAction(ip: ip).request(with: session)
            let _ = try await DLNA.GetPushRootAction(ip: ip).request(with: session)
            let response = try await DLNA.BrowseAction(ip: ip).request(with: session)
            let result = try await ResultXMLParser(data: response).parse()
            let items = try await ItemXMLParser(result).parse()
            let media = items.compactMap(Media.init)
            try await fetch(media, with: sizes)
            _ = try await DLNA.EndAction(ip: ip).request(with: session)
            return media
        } catch {
            throw error
        }
    }
    
    // MARK: - `Private Methods` -
    
    private func fetch(_ media: [Media], with sizes: [Media.Size]) async throws {
        return try await withThrowingTaskGroup(of: Void.self) { group in
            for medium in media {
                group.addTask { try await medium.fetch(sizes: sizes) }
            }
            
            return try await group.waitForAll()
        }
    }
}
