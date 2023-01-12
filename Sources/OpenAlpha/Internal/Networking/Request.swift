//
//  SOAPRequest.swift
//  
//
//  Created by Cole Roberts on 12/27/22.
//

import Foundation

// MARK: - `SOAPRequest` -

protocol Request {
    associatedtype Response
    
    var host: String { get }
    var path: String { get }
    var port: Int { get }
    var action: String { get }
    var envelope: String { get }
    var method: String { get }
}

// MARK: - `SOAPRequest+Defaults` -

extension Request {
    var method: String { "POST" }
    var port: Int {  Port.default }
    var request: URLRequest {
        var components = URLComponents()
        components.scheme = "http"
        components.host = host
        components.path = path
        components.port = port
        var req = URLRequest(url: components.url!)
        req.httpMethod = method
        req.httpBody = envelope.data(using: .utf8)
        req.setValue("text/xml; charset=UTF-8", forHTTPHeaderField: "Content-Type")
        req.setValue(action, forHTTPHeaderField: "soapaction")
        
        return req
    }
}

// MARK: - `SOAPRequest+Task` -

extension Request where Response == Data {
    func request(
        with session: URLSession = .shared
    ) async throws -> Response {
        do {
            let (data, response) = try await session.data(for: request)
            
            guard let response = response as? HTTPURLResponse else {
                fatalError()
            }
            
            guard response.statusCode == 200 else {
                fatalError()
            }
            
            return data
        } catch {
            throw error
        }
    }
}
