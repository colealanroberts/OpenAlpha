//
//  Fetchable.swift
//  
//
//  Created by Cole Roberts on 1/4/23.
//

import Foundation

protocol Fetchable: AnyObject {
    /// Begins asynchronously fetching content
    func fetch() async throws
}
