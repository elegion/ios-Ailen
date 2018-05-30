//
//  Created by Evgeniy Akhmerov on 07/11/2017.
//  Copyright © 2017 e-Legion. All rights reserved.
//

import Foundation

public struct Message<TokenType: Token, PayloadType> {
    public let token: TokenType
    public let payload: PayloadType
    
    public init(token: TokenType, payload: PayloadType) {
        self.token = token
        self.payload = payload
    }
}

public protocol Output {
    func proccess<TokenType, PayloadType>(_ message: Message<TokenType, PayloadType>)
    func set<TokenType: Token>(enabled: Bool, for token: TokenType)
}

