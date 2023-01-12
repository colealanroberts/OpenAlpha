//
//  DLNA+EndAction.swift
//  
//
//  Created by Cole Roberts on 12/27/22.
//

import Foundation

extension DLNA {
    struct EndAction: Request {
        typealias Response = Data
        
        let ip: String
        var host: String { ip }
        var path: String { "/upnp/control/XPushList" }
        var action: String { "\"urn:schemas-sony-com:service:XPushList:1#X_TransferEnd\"" }
        var envelope: String {
            """
            <?xml version="1.0" encoding="UTF-8"?>
            <s:Envelope xmlns:s="http://schemas.xmlsoap.org/soap/envelope/" s:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
                <s:Body>
                    <u:X_TransferEnd xmlns:u="urn:schemas-sony-com:service:XPushList:1">
                        <ErrCode>0</ErrCode>
                    </u:X_TransferEnd>
                </s:Body>
            </s:Envelope>
            """
        }
    }
}
