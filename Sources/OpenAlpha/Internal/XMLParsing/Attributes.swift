//
//  Attributes.swift
//  
//
//  Created by Cole Roberts on 1/4/23.
//

import Foundation

// MARK: - `Attributes`

@dynamicMemberLookup
struct Attributes {
    let attributes: [String: String]
    
    init(
        _ attributes: [String: String]
    ) {
        self.attributes = attributes
    }
    
    subscript(dynamicMember member: String) -> String {
        return attributes[member, default: ""]
    }
}
