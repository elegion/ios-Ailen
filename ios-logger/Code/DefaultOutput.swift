//
//  Created by Evgeniy Akhmerov on 15/11/2017.
//  Copyright © 2017 e-Legion. All rights reserved.
//

import Foundation

public class DefaultOutput: Output {
    
    // MARK: - Properties
    
    private var blockedTokens = Set<Token>()
    
    // MARK: - Life cycle
    
    public init() {}
    
    // MARK: - Output
    
    public func set(enabled: Bool, for token: Token) {
        if enabled {
            blockedTokens.remove(token)
        } else {
            blockedTokens.insert(token)
        }
    }
    
    public func display(_ message: Message) {
        print("Token: \(message.token) | Payload: \(message.payload)")
    }
}
