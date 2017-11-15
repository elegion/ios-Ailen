//
//  Created by Evgeniy Akhmerov on 07/11/2017.
//  Copyright © 2017 e-Legion. All rights reserved.
//

import Foundation

public class Ailen {
    
    // MARK: - Properties
    
    private var internalProcessors = [Processor]()
    public var outputs: [Output]
    public var processors: [Processor] {
        set {
            var value = newValue
            value.append(DebugProcessor())
            internalProcessors = value
        }
        get {
            return Array(internalProcessors.dropLast())
        }
    }
    
    // MARK: - Life cycle
    
    public init(outputs: [Output] = [DefaultOutput()]) {
        self.outputs = outputs
    }
    
    // MARK: - Public
    
    public func log(as token: Token, tags: [Tag] = [], values: Any...) {
        queue(for: token.qos).async {
            let mapped: [Message] = values.flatMap({
                guard let processed = self.convert($0, for: token) else { return nil }
                return LogMessage(token: token, tags: tags, payload: processed)
            })
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
    
    private func convert(_ source: Any, for token: Token) -> String? {
        for processor in internalProcessors {
            if let processed = processor.process(token: token, object: source) {
                return processed
            }
        }
        return nil
    }
}

// MARK: -

internal struct LogMessage: Message {
    let token: Token
    let tags: [Tag]
    let payload: String
}
