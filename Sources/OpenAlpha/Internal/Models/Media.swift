//
//  Media.swift
//  
//
//  Created by Cole Roberts on 12/28/22.
//

import Foundation

// MARK: - `Media` -

public final class Media: FetchableSize {
    
    /// An automatically assigned identifier
    public let id = UUID()
    
    /// The asset suitable for thumbnails, the smallest available asset
    public let thumbnail: Asset?
    
    /// The small available asset
    public let small: Asset?
    
    /// The large available asset
    /// - Note: If available, `original` contains the highest-resolution asset
    public let large: Asset?
    
    /// The original asset, usually at the highest-resolution
    /// - Note: This may not be available on all camera models
    public let original: Asset?
    
    /// The type of asset, currently only `.photo` is available
    public let kind: Kind
    
    init(
        _ item: DIDLLite.Item
    ) {
        self.thumbnail = .init(item.resource.thumbnail)
        self.small = .init(item.resource.small)
        self.large = .init(item.resource.large)
        self.original = .init(item.resource.original)
        self.kind = .init(item.class)
    }
    
    func fetch(sizes: [Size]) async throws {
        for size in sizes {
            switch size {
            case .thumbnail:
                try await thumbnail?.fetch()
            case .small:
                try await small?.fetch()
            case .large:
                try await large?.fetch()
            case .original:
                try await original?.fetch()
            }
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

// MARK: - `Media+Size` -

public extension Media {
    enum Size: CaseIterable {
        /// Provides a 1:1 mapping for an `Asset` size, e.g. `Asset.large`
        /// - Note: This is used solely for specifying which asset sizes
        /// to retrieve using `OpenAlpha.media(sizes:from:)`
        case thumbnail, small, large, original
    }
}

// MARK: - `Array+Media.Size`

public extension Array where Element == Media.Size {
    static func all() -> Self { Media.Size.allCases }
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
