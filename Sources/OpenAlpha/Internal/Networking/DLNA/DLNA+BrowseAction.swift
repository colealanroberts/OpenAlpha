//
//  DLNA+BrowseAction.swift
//  
//
//  Created by Cole Roberts on 12/27/22.
//

import Foundation

extension DLNA {
    struct BrowseAction: Request {
        typealias Response = Data
        
        let ip: String
        var host: String { ip }
        var path: String { "/upnp/control/ContentDirectory" }
        var action: String { "\"urn:schemas-upnp-org:service:ContentDirectory:1#Browse\"" }
        var envelope: String {
            """
            <?xml version="1.0"?>
            <s:Envelope xmlns:s="http://schemas.xmlsoap.org/soap/envelope/" s:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
                <s:Body>
                    <u:Browse xmlns:u="urn:schemas-upnp-org:service:ContentDirectory:1">
                        <ObjectID>PushRoot</ObjectID>
                        <BrowseFlag>BrowseDirectChildren</BrowseFlag>
                        <Filter>*</Filter>
                        <StartingIndex>0</StartingIndex>
                        <RequestedCount>100</RequestedCount>
                        <SortCriteria></SortCriteria>
                    </u:Browse>
                </s:Body>
            </s:Envelope>
            """
        }
    }
}
