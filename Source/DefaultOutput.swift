//
//  Created by Evgeniy Akhmerov on 15/11/2017.
//  Copyright © 2017 e-Legion. All rights reserved.
//

import Foundation

open class DefaultOutput: Output {
    
    // MARK: - Properties
    
    private var blockedTokens = Set<AnyHashable>()
    
    // MARK: - Life cycle
    
    public init() {}
    
    // MARK: - Public
    
    open func display<TokenType, PayloadType>(_ message: Message<TokenType, PayloadType>) {
        preconditionFailure("Abstract")
    }
    
    // MARK: - Private
    
    private func lock<TokenType: Token>(token: TokenType) {
        let _ = blockedTokens.insert(token)
    }
    
    private func unlock<TokenType: Token>(token: TokenType) {
        blockedTokens.remove(token)
    }
    
    private func isLocked<TokenType: Token>(token: TokenType) -> Bool {
        return blockedTokens.contains(token)
    }
    
    // MARK: - Output
    
    public func set<TokenType: Token>(enabled: Bool, for token: TokenType) {
        if enabled {
            unlock(token: token)
        } else {
            lock(token: token)
        }
    }
    
    public func proccess<TokenType, PayloadType>(_ message: Message<TokenType, PayloadType>) {
        guard !isLocked(token: message.token) else { return }
        
        display(message)
    }
}
