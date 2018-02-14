//
//  Created by Evgeniy Akhmerov on 07/11/2017.
//  Copyright © 2017 e-Legion. All rights reserved.
//

import Foundation

public class Ailen<PayloadType> {
    
    private enum EmptyTag: String {
        case empty = ""
    }
    
    // MARK: - Properties
    
    public var outputs: [Output]
    public var processors: [AnyProcessor<PayloadType>]
    
    // MARK: - Life cycle
    
    public init<ProcessorType: Processor>(outputs: [Output] = [ConsoleOutput()], processors: [ProcessorType]) where ProcessorType.PayloadType == PayloadType {
        self.outputs = outputs
        self.processors = processors.map { AnyProcessorEraser($0) }
    }
    
    // MARK: - Public
    
    public func log<TokenType: Token> (as token: TokenType, value: Any){
        
        perform(on: token.qos) {
            if let convertedPayload = self.convert(value, for: token) {
                let message = Message(token: token, payload: convertedPayload)
                self.outputs.forEach { $0.proccess(message) }
            }
        }
    }
    
    // MARK: - Private
    
    private func convert<TokenType: Token>(_ source: Any, for token: TokenType) -> PayloadType? {
        for processor in processors {
            if let processed = processor.process(token: token, object: source) {
                return processed
            }
        }
        return nil
    }

    private func perform(on qos: Qos, block: @escaping () -> Void) {
        guard qos.queue != DispatchQueue.main && qos.isAsync else {
            block()
            return
        }
        
        if qos.isAsync {
            qos.queue.async { block() }
        } else {
            qos.queue.sync { block() }
        }
    }
}
