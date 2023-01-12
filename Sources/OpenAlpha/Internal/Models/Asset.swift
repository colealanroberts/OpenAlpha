//
//  Asset.swift
//  
//
//  Created by Cole Roberts on 12/29/22.
//

import Foundation

// MARK: - `Asset` -

public final class Asset: Fetchable {
    /// The data representation of an image. This can be used to initialize
    /// an Image, UIImage, or NSImage
    public private(set) var data: Data?
    
    /// The backing URL for an asset
    ///
    /// - Note: This is intentionally marked `private` and set to nil
    /// when the backing dataTask finishes. This URL is ephemeral in nature and is inaccessible
    /// once a transfer completes.
    private var url: String?
    
    init(
        _ url: String
    ) {
        self.url = url
    }
    
    func fetch() async throws {
        guard let urlStr = url, let url = URL(string: urlStr) else {
            throw Error.invalidURL(url)
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(for: .init(url: url))
            self.data = data
            self.url = nil
        } catch {
            throw error
        }
    }
}

// MARK: - `Asset+Error` {

public extension Asset {
    enum Error: Swift.Error {
        case invalidURL(String?)
    }
}
