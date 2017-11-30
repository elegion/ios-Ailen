//
//  Created by Evgeniy Akhmerov on 17/11/2017.
//  Copyright © 2017 e-Legion. All rights reserved.
//

import Foundation

public class DefaultTokenBlocker: TokenLocking {
    
    // MARK: - Properties
    
    private var blockedTokens = Set<Token>()
    
    // MARK: - TokenLocking
    
    public func lock(token: Token) {
        blockedTokens.insert(token)
    }
    
    public func unlock(token: Token) {
        blockedTokens.remove(token)
    }
    
    public func isLocked(token: Token) -> Bool {
        return blockedTokens.contains(token)
    }
}
