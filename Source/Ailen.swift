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
    
    public var outputs: [Output]
    
    // MARK: - Life cycle
    
    public init(outputs: [Output] = [ConsoleOutput()]) {
        self.outputs = outputs
    }
    
    // MARK: - Public
    
    public func log<TokenType: Token> (as token: TokenType, value: Any)  {
        self.log(as: token, tags: [EmptyTag](), value: value)
    }
    
    public func log<Tag: RawRepresentable, TokenType: Token> (as token: TokenType, tags: [Tag], value: Any) where Tag.RawValue == String {
        
        perform(on: token.qos) {
            let tagsArray = tags.map { $0.rawValue }
            let message = Message(token: token, tags: tagsArray, payload: value)
            
            self.outputs.forEach { $0.proccess(message) }
        }
    }
    
    // MARK: - Private
    
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
