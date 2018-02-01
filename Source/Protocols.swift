//
//  Created by Evgeniy Akhmerov on 07/11/2017.
//  Copyright © 2017 e-Legion. All rights reserved.
//

import Foundation

public struct Message {
    let token: Token
    let tags: [Tag]
    let date: Date = Date()
    let payload: String
}

public protocol Output {
    func proccess(_ message: Message)
    func set(enabled: Bool, for token: Token)
}

public protocol Processor {
    func process(token: Token, object: Any) -> String?
}
