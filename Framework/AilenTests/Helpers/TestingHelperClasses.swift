//
//  Created by Evgeniy Akhmerov on 21/11/2017.
//  Copyright © 2017 e-Legion. All rights reserved.
//

import Foundation
@testable import Ailen

internal class TestingDefaultOutput: DefaultOutput {
    
    private(set) var messagesDisplayed = 0
    
    override func display<TokenType: Token>(_ message: Message<TokenType>) {
        DispatchQueue.main.async {
            self.messagesDisplayed += 1
        }
    }
}

internal class TestingProcessor: Processor {
    func process<TokenType: Token>(token: TokenType, object: Any) -> String? {
        return nil
    }
}
