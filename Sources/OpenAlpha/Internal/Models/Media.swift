//
//  Media.swift
//  
//
//  Created by Cole Roberts on 12/28/22.
//

import Foundation

// MARK: - `Media` -

public final class Media: Fetchable {
    
    /// An automatically assigned identifier
    public let id = UUID()
    
    /// The smallest available asset
    public let small: Asset
    
    /// The largest available asset
    public let large: Asset
    
    /// An asset suitable for thumbnails
    public let thumbnail: Asset
    
    public let kind: Kind
    
    init(
        _ item: DIDLLite.Item
    ) {
        self.small = .init(item.resource.small)
        self.large = .init(item.resource.large)
        self.thumbnail = .init(item.resource.thumbnail)
        self.kind = .init(item.class)
    }
    
    func fetch() async throws {
        do {
            try await small.fetch()
            try await large.fetch()
            try await thumbnail.fetch()
        } catch {
            throw error
        }
    }
}

// MARK: - `Media+Kind` -

extension Media {
    public enum Kind {
        case unknown
        case photo
        
        init(_ rawValue: String?) {
            switch rawValue {
            case "object.item.imageItem.photo":
                self = .photo
                return
            default:
                self = .unknown
                return
            }
        }
    }
}

// MARK: - `Media+Hashable` -

extension Media: Hashable {
    public static func == (lhs: Media, rhs: Media) -> Bool {
        return lhs.id == rhs.id
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
