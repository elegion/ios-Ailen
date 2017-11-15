//
//  DefaultOutput.swift
//  ios-logger
//
//  Created by Evgeniy Akhmerov on 15/11/2017.
//  Copyright © 2017 e-Legion. All rights reserved.
//

import Foundation

public class DefaultOutput: Output {
    
    // MARK: - Properties
    
    private lazy var _processor: Processor = { DebugProcessor() }()
    
    // MARK: - Life cycle
    
    public init() {}
    
    // MARK: - Output
    
    public var processors: [Processor] {
        return [_processor]
    }
    
    public func isDisplayAvailable(for token: Token, with tags: [Tag]) -> Bool {
        return true
    }
    
    public func display(_ message: Message, with tags: [Tag]) {
        var converted: String = ""
        _ = processors.first {
            guard let s = $0.handle(token: message.token, object: message.payload) else { return false }
            converted = s
            return true
        }
        print(converted)
    }
}
