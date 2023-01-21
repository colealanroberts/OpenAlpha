//
//  OpenAlpha
//
//
//  Created by Cole Roberts on 12/27/22.
//

import Foundation

// MARK: - `OpenAlphaSDK` -

public protocol OACore: AnyObject {
    /// Asynchronously retrieves an array of `Media` objects from the given IPv4 address.
    /// - Parameters:
    ///   - sizes: An array of sizes (`Media.Size`) to request, to request all available sizes utilize `media(sizes: Media.Size.all(), ...)`.
    ///   It's worth noting that `Asset.original` may be a large request, utilizing more battery from the camera. If you prefer to avoid a larger data task,
    ///   and don't need the high-resolution image, opt to pass in `.large` instead.
    ///   - from: The IPv4 address to retrieve media from.
    /// - Returns: An array of `Media` objects.
    /// - Throws: An error if the retrieval fails.
    func media(sizes: [Media.Size], from ip: String) async throws -> [Media]
}

public protocol OAHotspotConnectable: AnyObject {
    /// Attempts to connect to a Wi-Fi hotspot with the given SSID and passphrase.
    /// Only available on iOS. On macOS, connect to the DIRECT- Wi-Fi network directly.
    /// - Parameters:
    ///   - to: The hotspot to connect to.
    /// - Returns: An IPv4 address as a string.
    /// - Throws: An error if the connection fails.
    func connect(to hotspot: OpenAlpha.Hotspot) async throws -> String
}

// MARK: - `OpenAlpha` -

public final class OpenAlpha {
        
    // MARK: - `Static Properties` -
    
    public static let shared: OpenAlpha = .init()
    
    // MARK: - `Private Properties` -
    
    private let mediaProvider: MediaProviding
    
    #if os(iOS)
    private let hotspotProvider: HotspotProviding
    #endif
    
    // MARK:- `Init` -
    
    public init() {
        self.mediaProvider = MediaProvider(session: .shared)
        
        #if os(iOS)
        self.hotspotProvider = HotspotProvider(
            localNetworkPermissionProvider: LocalNetworkPermissionProvider(
                userDefaults: .openAlpha
            )
        )
        #endif
    }
}

// MARK: - `OpenAlpha+OACore` -

extension OpenAlpha: OACore {
    public func media(sizes: [Media.Size], from ip: String) async throws -> [Media] {
        try await mediaProvider.media(sizes: sizes, from: ip)
    }
}

// MARK: - `OpenAlpha+OAHotspotConnectable`

#if os(iOS)
extension OpenAlpha: OAHotspotConnectable {
    public func connect(to hotspot: OpenAlpha.Hotspot) async throws -> String {
        return try await hotspotProvider.connect(to: hotspot)
    }
}
#endif
