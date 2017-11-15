//
//  Created by Evgeniy Akhmerov on 15/11/2017.
//  Copyright © 2017 e-Legion. All rights reserved.
//

import Foundation

public class DebugProcessor: Processor {
    
    // MARK: - Processor
    
    public func process(token: Token, object: Any) -> String? {
        return String(describing: object)
    }
}
