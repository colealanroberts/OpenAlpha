//
//  Scanner.swift
//  
//
//  Created by Cole Roberts on 1/1/23.
//

import Foundation

// MARK: - `Scanner+OpenAlpha.Hotspot` -

extension Scanner {
    static func hotspot(from value: String) -> OpenAlpha.Hotspot? {
        let scanner = Scanner(string: value)
        let _ = scanner.scanUpToString("S:")
        let delimiterA = scanner.scanUpToString(";")
        let ssid = delimiterA?.replacingOccurrences(of: "S:", with: "")
        let _ = scanner.scanUpToString("P:")
        let delimiterB = scanner.scanUpToString(";")
        let passphrase = delimiterB?.replacingOccurrences(of: "P:", with: "")
        let _ = scanner.scanUpToString("C:")
        let delimiterC = scanner.scanUpToString(";")
        let camera = delimiterC?.replacingOccurrences(of: "C:", with: "")
        
        guard let ssid, let passphrase, let camera else {
            return nil
        }
        
        return .init(ssid: "DIRECT-\(ssid):\(camera)", passphrase: passphrase)
    }
}
