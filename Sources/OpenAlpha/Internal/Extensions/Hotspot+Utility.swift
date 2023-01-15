//
//  Hotspot+Utility.swift
//  
//
//  Created by Cole Roberts on 12/31/22.
//

import Network
import NetworkExtension

#if os(iOS)

// MARK: - `OpenAlphaSDK.Hotspot`

extension OpenAlpha.Hotspot {
    func ensureCurrent() async throws {
        do {
            let current = await NEHotspotNetwork.fetchCurrent()
            
            guard let current else {
                throw Error.unavailable
            }
        
            guard ssid == current.ssid else {
                throw Error.unrecognizedDevice
            }
        } catch {
            throw error
        }
    }
}

// MARK: - `OpenAlphaSDK.Hotspot+Error`

extension OpenAlpha.Hotspot {
    enum Error: Swift.Error {
        /// The backing `NEHotspotNetwork` is unavailable or disconnected
        case unavailable
        
        /// The SSID entered does not match the current `NEHotspotNetwork`
        case unrecognizedDevice
    }
}

#endif
