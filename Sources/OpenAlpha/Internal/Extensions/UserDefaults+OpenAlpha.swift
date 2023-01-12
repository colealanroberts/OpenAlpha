//
//  UserDefaults+OpenAlpha.swift
//  
//
//  Created by Cole Roberts on 1/2/23.
//

import Foundation

extension UserDefaults {
    enum Keys {
        static let localNetworkAuthorization = "__localNetworkAuthorization"
    }
    
    static var openAlpha: UserDefaults {
        .init(suiteName: "group.openalpha.package")!
    }
    
    var localNetworkAuthorization: Bool {
        get {
            bool(forKey: Keys.localNetworkAuthorization)
        }
        
        set {
            set(newValue, forKey: Keys.localNetworkAuthorization)
        }
    }
}
