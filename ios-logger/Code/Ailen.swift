//
//  Created by Evgeniy Akhmerov on 07/11/2017.
//  Copyright © 2017 e-Legion. All rights reserved.
//

import Foundation

public class Ailen {
    
    // MARK: - Properties
    
    public var outputs: [Output]
    
    // MARK: - Life cycle
    
    public init(outputs: [Output] = []) {
        if outputs.count == 0 {
            self.outputs = [DefaultOutput()]
        } else {
            self.outputs = outputs
        }
    }
    
    // MARK: - Public
    
    public func log(as token: Token, tags: [Tag] = [], values: Any...) {
        precondition(values.count > 0, "Messages are zero count. You should pass a least one message.")
        
        queue(for: token.qos).async {
            let mapped = values.map { LogMessage(token: token, tags: tags, payload: $0) }
            self.outputs.forEach { self.log(mapped, in: $0) }
        }
    }
    
    // MARK: - Private
    
    private func log(_ messages: [Message], in output: Output) {
        messages.forEach {
            guard output.isDisplayAvailable(for: $0.token, with: $0.tags) else { return }
            output.display($0, with: $0.tags)
        }
    }
    
    private func queue(for qos: Token.Qos) -> DispatchQueue {
        switch qos {
        case .main:             return .main
        case .global:           return .global(qos: .utility)
        case .custom(let q):    return q
        }
    }
}

// MARK: -

internal struct LogMessage: Message {
    let token: Token
    let tags: [Tag]
    let payload: Any
}
