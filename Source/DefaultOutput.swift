//
//  Created by Evgeniy Akhmerov on 15/11/2017.
//  Copyright © 2017 e-Legion. All rights reserved.
//

import Foundation

open class DefaultOutput: Output {
    
    // MARK: - Properties
    
    private var blockedTokens = Set<Token>()
    
    // MARK: - Life cycle
    
    public init() {}
    
    // MARK: - Public
    
    open func display(_ message: Message) {
        preconditionFailure("Abstract")
    }
    
    // MARK: - Private
    
    private func lock(token: Token) {
        blockedTokens.insert(token)
    }
    
    private func unlock(token: Token) {
        blockedTokens.remove(token)
    }
    
    private func isLocked(token: Token) -> Bool {
        return blockedTokens.contains(token)
    }
    
    // MARK: - Output
    
    public func set(enabled: Bool, for token: Token) {
        if enabled {
            unlock(token: token)
        } else {
            lock(token: token)
        }
    }
    
    public func proccess(_ message: Message) {
        guard !isLocked(token: message.token) else { return }
        
        display(message)
    }
}
