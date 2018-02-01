//
//  Created by Evgeniy Akhmerov on 07/11/2017.
//  Copyright © 2017 e-Legion. All rights reserved.
//

import Foundation

public protocol Message {
    var token: Token { get }
    var tags: [Tag] { get }
    var date: Date { get }
    var payload: String { get }
}

public protocol Output {
    func proccess(_ message: Message)
    func set(enabled: Bool, for token: Token)
}

public protocol Processor {
    func process(token: Token, object: Any) -> String?
}
