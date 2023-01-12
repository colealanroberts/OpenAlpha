//
//  OpenAlpha+Hotspot.swift
//  
//
//  Created by Cole Roberts on 12/30/22.
//

import Foundation

// MARK: - `OpenAlpha+Hotspot` -

public extension OpenAlpha {
    struct Hotspot: Equatable {
        
        /// The SSID for a hotspot
        public let ssid: String
        
        /// The Passphrase/Password for a hotspot
        public let passphrase: String
        
        /// Initializes a `Hotspot` from a QR code with the following String representation.
        /// S:(SSID)
        /// P:(Password)
        /// C:(Camera)
        ///
        /// W01:S:P3E1;P:GB44SZnb;C:ILCE-7M2;M:A0C9A052F529;
        ///
        /// The above string is represented as, SSID: DIRECT-P3E1:ILCE-7M2 / Passphrase: GB44SZnb
        ///
        /// Interally this utilizes `NSScanner` to attempt the construction of a `Hotspot`
        /// - Parameters:
        ///   - value: The String value to initialize.
        public init?(_ value: String) {
            guard let hotspot = Scanner.hotspot(from: value) else {
                return nil
            }
            
            self = hotspot
        }

        public init(
            ssid: String,
            passphrase: String
        ) {
            self.ssid = ssid
            self.passphrase = passphrase
        }
    }
}
