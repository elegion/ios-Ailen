//
//  Created by Evgeniy Akhmerov on 07/11/2017.
//  Copyright © 2017 e-Legion. All rights reserved.
//

import Foundation

public struct Message<TokenType: Token> {
    public let token: TokenType
    public let tags: [String]
    public let date: Date = Date()
    public let payload: Any
}

public protocol Output {
    func proccess<TokenType>(_ message: Message<TokenType>)
    func set<TokenType: Token>(enabled: Bool, for token: TokenType)
}

public protocol Processor {
    func process<TokenType: Token>(token: TokenType, object: Any) -> String?
}
