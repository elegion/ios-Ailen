//
//  Created by Evgeniy Akhmerov on 20/11/2017.
//  Copyright © 2017 e-Legion. All rights reserved.
//

import ios_logger

extension Token {
    static let response = Token(rawValue: "Response.Token")!
    static let error = Token(rawValue: "Error.Token")!
    static let UI = Token(rawValue: "UI.Token", qos: .main)!
}

extension Tag {
    static let client = Tag(rawValue: "Client.Tag")!
    static let server = Tag(rawValue: "Server.Tag")!
    static let `internal` = Tag(rawValue: "Internal.Tag")!
}
