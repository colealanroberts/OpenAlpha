//
//  AttributeBuildable.swift
//  
//
//  Created by Cole Roberts on 1/9/23.
//

import Foundation

// MARK: - `AttributeBuildable` -

protocol AttributeBuildable {
    static func build(with attributes: [String: String]) -> Self
}
