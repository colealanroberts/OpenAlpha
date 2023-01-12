//
//  Gateway.swift
//  
//
//  Created by Cole Roberts on 1/9/23.
//

import Foundation
import Network
import NetworkExtension

struct Gateway {
    
    // MARK: - `Properties` -
    
    let ipv4: IPv4Address
    
    // MARK: - `Init` -
    
    init?(_ value: String) {
        self.ipv4 = .init(value) ?? .any
    }
    
    init(_ endpoint: Network.NWEndpoint) {
        switch endpoint {
        case .hostPort(let host, port: _):
            switch host {
            case .ipv4(let ipv4):
                self.ipv4 = ipv4
                return
            default:
                break
            }
        default:
            break
        }
        
        self.ipv4 = .any
    }
}

// MARK: - `IPv4Address`

extension IPv4Address {
    var description: String {
        debugDescription
    }
}
