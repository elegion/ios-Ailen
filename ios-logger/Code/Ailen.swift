//
//  Created by Evgeniy Akhmerov on 07/11/2017.
//  Copyright © 2017 e-Legion. All rights reserved.
//

import Foundation

public class Ailen {
    
    // MARK: - Properties
    
    public var outputs: [Output]
    
    // MARK: - Life cycle
    
    public init(outputs: [Output] = [DefaultOutput()]) {
        self.outputs = outputs
    }
    
    var processors: [Processor] {
        set {
            var value = newValue
            value.append(DebugProcessor())
            internalProcessors = value
        }
        get {
            return Array(internalProcessors.dropLast())
        }
    }
    private var internalProcessors: [Processor]
    
    // MARK: - Public
    
    public func log(as token: Token, tags: [Tag] = [], values: Any...) {
        queue(for: token.qos).async {
            let mapped = values.map { LogMessage(token: token, tags: tags, payload: $0) }
            self.outputs.forEach { self.log(mapped, in: $0) }
        }
    }
    
    // MARK: - Private
    
    private func log(_ messages: [Message], in output: Output) {
        messages.forEach { output.display($0) }
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
