//
//  Created by Evgeniy Akhmerov on 20/11/2017.
//  Copyright © 2017 e-Legion. All rights reserved.
//

import Ailen

enum TestToken: String, Token {
    case response = "Response.Token"
    case error = "Error.Token"
    case UI = "UI.Token"
    case request
    
    var qos: Qos {
        switch self {
        case .UI:
            return Qos.main(async: false)
        default:
            return Qos.global(async: true)
        }
    }
}

enum TestTag: String {
    case client = "Client.Tag"
    case server = "Server.Tag"
    case `internal` = "Internal.Tag"
    case response = "Response"
    case fake = "FakeTag.value"
}
