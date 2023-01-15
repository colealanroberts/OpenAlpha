//
//  File.swift
//  
//
//  Created by Cole Roberts on 1/9/23.
//

#if os(iOS)
import Foundation
import Network
import NetworkExtension

// MARK: - `HotspotProviding` -

/// A protocol for connecting to a Wi-Fi hotspot.
protocol HotspotProviding {
    /// Attempts to connect to a Wi-Fi hotspot.
    /// - Parameters:
    ///   - hotspot: The hotspot to connect to.
    /// - Returns: An IPv4 address as a string.
    /// - Throws: An error if the connection fails.
    func connect(to hotspot: OpenAlpha.Hotspot) async throws -> String
}

// MARK: - `HotspotProvider` -

final class HotspotProvider: HotspotProviding {
    
    // MARK: - `Private Properties` -
    
    private var localNetworkPermissionProvider: LocalNetworkPermissionProviding?
    
    // MARK: - `Init` -
    
    init(
        localNetworkPermissionProvider: LocalNetworkPermissionProviding
    ) {
        self.localNetworkPermissionProvider = localNetworkPermissionProvider
    }
    
    // MARK: - `Public Methods` - 
    
    func connect(to hotspot: OpenAlpha.Hotspot) async throws -> String {
        let hotspotManager = NEHotspotConfigurationManager()
        try await hotspotManager.apply(hotspot)
        try await hotspot.ensureCurrent()
        
        let monitor = NWPathMonitor(requiredInterfaceType: .wifi)
        monitor.start(queue: .global())
        let gateway = try await monitor.gateway()
        monitor.cancel()
        
        if !LocalNetworkPermissionProvider.hasRequestedAuthorization {
            try await localNetworkPermissionProvider?.requestAuthorization(gateway: gateway)
        } else {
            localNetworkPermissionProvider = nil
        }
        
        return gateway.ipv4.description
    }
}

// MARK: - `HotspotProvider` -

fileprivate extension HotspotProvider {
    enum Error: Swift.Error {
        case invalidGateway
    }
}

// MARK: - `NWPathMonitor+Async`

fileprivate extension NWPathMonitor {
    /// Returns the first `Gateway` from a `NWEndpoint`
    func gateway() async throws -> Gateway {
        try await withCheckedThrowingContinuation { continuation in
            pathUpdateHandler = { path in
                guard let first = path.gateways.first else {
                    continuation.resume(throwing: Error.emptyGateway)
                    return
                }
                
                continuation.resume(returning: Gateway(first))
            }
        }
    }
}

// MARK: - `NWPathMonitor+Error` -

fileprivate extension NWPathMonitor {
    enum Error: Swift.Error {
        case emptyGateway
    }
}

// MARK: - `NEHotspotConfigurationManager+Hotspot` -

extension NEHotspotConfigurationManager {
    func apply(_ hotspot: OpenAlpha.Hotspot) async throws {
        try await apply(.init(ssid: hotspot.ssid, passphrase: hotspot.passphrase, isWEP: false))
    }
}

#endif
