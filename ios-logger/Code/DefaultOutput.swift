//
//  Created by Evgeniy Akhmerov on 15/11/2017.
//  Copyright © 2017 e-Legion. All rights reserved.
//

import Foundation

public class DefaultOutput: Output {
    
    // MARK: - Life cycle
    
    public init() {}
    
    // MARK: - Output
    
    }
    
    public func isDisplayAvailable(for token: Token, with tags: [Tag]) -> Bool {
        return true
    }
    
    public func display(_ message: Message) {
        print("Token: \(message.token) | Payload: \(message.payload)")
    }
}
