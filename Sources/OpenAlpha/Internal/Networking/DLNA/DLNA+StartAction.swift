//
//  DLNA+StartAction.swift
//  
//
//  Created by Cole Roberts on 12/27/22.
//

import Foundation

extension DLNA {
    struct StartAction: Request {
        typealias Response = Data
        
        let ip: String
        var host: String { ip }
        var path: String { "/upnp/control/XPushList" }
        var action: String { "\"urn:schemas-sony-com:service:XPushList:1#X_TransferStart\"" }
        var envelope: String {
            """
            <?xml version="1.0" encoding="UTF-8"?>
            <s:Envelope xmlns:s="http://schemas.xmlsoap.org/soap/envelope/" s:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
                <s:Body>
                    <u:X_TransferStart xmlns:u="urn:schemas-sony-com:service:XPushList:1">
                    </u:X_TransferStart>
                </s:Body>
            </s:Envelope>
            """
        }
    }
}
