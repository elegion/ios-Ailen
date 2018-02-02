//
//  Created by Evgeniy Akhmerov on 20/11/2017.
//  Copyright © 2017 e-Legion. All rights reserved.
//

import Ailen

enum TokenKeys: String {
    case responce = "Response.Token"
    case error = "Error.Token"
    case UI = "UI.Token"
}

extension Token {
    static let response = Token(tokenKey: TokenKeys.responce)
    static let error = Token(tokenKey: TokenKeys.error)
    static let UI = Token(tokenKey: TokenKeys.UI, qos: .main(async: false))
}

enum Tag: String {
    case client = "Client.Tag"
    case server = "Server.Tag"
    case `internal` = "Internal.Tag"
    case response = "Response"
    case fake = "FakeTag.value"
}
