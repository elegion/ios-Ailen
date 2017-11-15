//
//  Created by Evgeniy Akhmerov on 07/11/2017.
//  Copyright © 2017 e-Legion. All rights reserved.
//

import Foundation

public protocol Message {
    var token: Token { get }
    var tags: [Tag] { get }
    var payload: Any { get }
}

public protocol Output {
    var processors: [Processor] { get }
    func isDisplayAvailable(for token: Token, with tags: [Tag]) -> Bool
    func display(_ message: Message, with tags: [Tag])
}

public protocol Processor {
    func process(token: Token, object: Any) -> String?
}
