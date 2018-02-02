//
//  Created by Evgeniy Akhmerov on 07/11/2017.
//  Copyright © 2017 e-Legion. All rights reserved.
//

import Foundation

public class Ailen {
    
    private enum EmptyTag: String {
        case empty = ""
    }
    
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
    
    public init(outputs: [Output] = [ConsoleOutput()], processors: [Processor] = []) {
        self.outputs = outputs
        self.processors = processors
    }
    
    // MARK: - Public
    
    public func log<TokenType: Token> (as token: TokenType, values: Any...)  {
        self.log(as: token, tags: [EmptyTag](), values: values)
    }
    
    public func log<Tag: RawRepresentable, TokenType: Token> (as token: TokenType, tags: [Tag], values: Any...) where Tag.RawValue == String {
        
        perform(on: token.qos) {
            let mapped: [Message<TokenType>] = values.flatMap {
                value in
                
                guard let processed = self.convert(value, for: token) else { return nil }
                
                let tagsArray = tags.map { $0.rawValue }
                return Message(token: token, tags: tagsArray, payload: processed)
            }
            self.outputs.forEach { self.log(mapped, in: $0) }
        }
    }
    
    // MARK: - Private
    
    private func log<TokenType: Token>(_ messages: [Message<TokenType>], in output: Output) {
        messages.forEach(output.proccess)
    }
    
    private func convert<TokenType: Token>(_ source: Any, for token: TokenType) -> String? {
        for processor in internalProcessors {
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
