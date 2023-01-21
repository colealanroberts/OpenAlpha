//
//  DIDLite.swift
//  
//
//  Created by Cole Roberts on 1/4/23.
//

import Foundation

// MARK: - `DIDLLite` -

struct DIDLLite {
    private init() {}
}

// MARK: - `DIDLite+Item` -

extension DIDLLite {
    struct Item: AttributeBuildable {
        let id: String
        var `class`: String?
        var resource: Resource
        
        static func build(with attributes: [String : String]) -> Self {
            let attributes = Attributes(attributes)
            return self.init(id: attributes.id, class: nil, resource: .init())
        }
    }
}

// MARK: - `DIDLite+Resource` -

extension DIDLLite {
    struct Resource {
        var small: String!
        var large: String!
        var thumbnail: String!
        var original: String?
    }
}

// MARK: - `DIDLite.Resource+Size` -

extension DIDLLite.Resource {
    public enum Size: AttributeBuildable {
        case small
        case large
        case thumbnail
        case original
        
        init(
            value: String
        ) {
            switch value {
            case _ where value.contains("ORG_PN=JPEG_SM"):
                self = .small
                return
            case _ where value.contains("ORG_PN=JPEG_LRG"):
                self = .large
                return
            case _ where value.contains("ORG_PN=JPEG_TN"):
                self = .thumbnail
                return
            default:
                self = .original
            }
        }
        
        static func build(with attributes: [String : String]) -> DIDLLite.Resource.Size {
            let attributes = Attributes(attributes)
            return self.init(value: attributes.protocolInfo)
        }
    }
}
