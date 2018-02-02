//
//  Created by Evgeniy Akhmerov on 15/11/2017.
//  Copyright © 2017 e-Legion. All rights reserved.
//

import Foundation

public class DebugProcessor: Processor {
    
    // MARK: - Life cycle
    
    public init() {}
    
    // MARK: - Processor
    
    public func process<TokenType: Token>(token: TokenType, object: Any) -> String? {
        return String(describing: object)
    }
}
