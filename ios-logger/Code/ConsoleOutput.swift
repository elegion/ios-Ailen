//
//  Created by Evgeniy Akhmerov on 20/11/2017.
//  Copyright © 2017 e-Legion. All rights reserved.
//

import Foundation

public class ConsoleOutput: DefaultOutput {
    
    open override func display(_ message: Message) {
        print("Token: \(message.token) | Payload: \(message.payload)")
    }
}
