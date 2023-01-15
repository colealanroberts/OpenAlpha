//
//  LocalNetworkPermissionProvider.swift
//
//
//  Created by Cole Roberts on 1/2/23.
//

#if os(iOS)
import Foundation
import Network
import NetworkExtension
import UIKit

// MARK: - `LocalNetworkPermissionProviding` -

/// A protocol for managing access to a local network.
protocol LocalNetworkPermissionProviding {
    /// Whether or not the application has previously requested access to the local network.
    static var hasRequestedAuthorization: Bool { get }
    
    /// Asynchronously requests access to a local network with a specific host.
    /// - Parameters:
    ///   - gateway: The host to request access to the local network from.
    /// - Throws: An error if the request fails.
    func requestAuthorization(gateway: Gateway) async throws
}

// MARK: - `LocalNetworkPermissionProvider+Error`

extension LocalNetworkPermissionProvider {
    enum Error: Swift.Error {
        /// A port could not be created using `NWEndpoint.Port`
        case invalidPort(UInt16)
        
        /// The user denied access to the Local Network.
        case accessDenied
    }
}

// MARK: - `LocalNetworkPermissionProvider` -

final class LocalNetworkPermissionProvider: LocalNetworkPermissionProviding {
    
    // MARK: - `Public Properties` -
    
    public static var hasRequestedAuthorization: Bool {
        UserDefaults.openAlpha.localNetworkAuthorization
    }
    
    private var statusContinuation: CheckedContinuation<Void, Swift.Error>?
    
    private var worker: DispatchWorkItem?
    
    private lazy var timer: Timer = {
        .scheduledTimer(
            withTimeInterval: .zero,
            repeats: false,
            block: { [weak self] _ in
                guard let self = self, let worker = self.worker else { return }
                DispatchQueue.main.asyncAfter(deadline: .now(), execute: worker)
            }
        )
    }()
    
    // MARK: - `Private Properties` -
    
   private let userDefaults: UserDefaults
    
    // MARK: - `Init` -
    
    init(
        userDefaults: UserDefaults
    ) {
        self.userDefaults = userDefaults
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(onDidBecomeActive(_:)),
            name: UIApplication.didBecomeActiveNotification,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
           self,
           selector: #selector(onWillResignActive(_:)),
           name: UIApplication.willResignActiveNotification,
           object: nil
       )
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - `Public Methods` -
    
    func requestAuthorization(gateway: Gateway) async throws {
        let port = UInt16(Port.default)
        
        guard let port = NWEndpoint.Port(rawValue: port) else {
            throw Error.invalidPort(port)
        }
        
        let connection = NWConnection(
            host: .init(gateway.ipv4.description),
            port: port,
            using: .tcp
        )
        
        return try await withCheckedThrowingContinuation { continuation in
            statusContinuation = continuation
            self.observeState(connection)
        }
    }
    
    // MARK: - `Private Methods` -
    
    private func observeState(_ connection: NWConnection) {
        connection.start(queue: .main)
        
        worker = DispatchWorkItem { [weak self] in
            self?.userDefaults.localNetworkAuthorization = true
            
            if connection.state == .ready {
                self?.statusContinuation?.resume(with: .success(()))
                self?.statusContinuation = nil
            } else {
                self?.statusContinuation?.resume(throwing: Error.accessDenied)
                self?.statusContinuation = nil
            }
            
            self?.timer.invalidate()
        }
        
        timer.fire()
    }
    
    @objc
    private func onWillResignActive(_ notification: Notification?) {
        timer.invalidate()
    }
    
    @objc
    private func onDidBecomeActive(_ notification: Notification?) {
        guard let worker else { return }
        DispatchQueue.main.asyncAfter(deadline: .now(), execute: worker)
    }
}
#endif
