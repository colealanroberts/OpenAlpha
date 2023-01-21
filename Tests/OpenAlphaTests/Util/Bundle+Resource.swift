//
//  Bundle+Resource.swift
//  
//
//  Created by Cole Roberts on 1/20/23.
//

import Foundation

// MARK: - `Bundle+Response` -

extension Bundle {
    static func response(for camera: Camera) throws -> String {
        guard let url = Bundle.module.url(forResource: camera.rawValue, withExtension: "xml") else {
            fatalError("Unable to locate resource for \(camera.rawValue).xml")
        }
        
        return try String(contentsOf: url)
    }
}
