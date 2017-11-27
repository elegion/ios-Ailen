//
//  Created by Evgeniy Akhmerov on 15/11/2017.
//  Copyright © 2017 e-Legion. All rights reserved.
//

import Foundation

public class DefaultOutput: Output {
    
    // MARK: - Properties
    
    private let blocker = DefaultTokenBlocker()
    
    // MARK: - Life cycle
    
    public init() {}
    
    // MARK: - Output
    
    public func set(enabled: Bool, for token: Token) {
        if enabled {
            blocker.unlock(token: token)
        } else {
            blocker.lock(token: token)
        }
    }
    
    public func proccess(_ message: Message) {
        guard !blocker.isLocked(token: message.token) else { return }
        
        print("Token: \(message.token) | Payload: \(message.payload)")
    }
}
