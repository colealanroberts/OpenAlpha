//
//  FetchableSize.swift
//  
//
//  Created by Cole Roberts on 1/21/23.
//

import Foundation

protocol FetchableSize: AnyObject {
    /// Begins asynchronously fetching content for the given sizes (`Media.Size`)
    func fetch(sizes: [Media.Size]) async throws
}
