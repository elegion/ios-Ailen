//
//  Created by Evgeniy Akhmerov on 07/11/2017.
//  Copyright © 2017 e-Legion. All rights reserved.
//

import Foundation

public class Ailen {
    
    // MARK: - Properties
    
    public static let shared = Ailen()
    public var outputs = [Output]()
    public var storage: Storaging?
    
    // MARK: - Life cycle
    
    private init() {}
    
    // MARK: - Public
    
    public func log<T: CustomDebugStringConvertible>(as token: Token, tags: [Tag] = [], store: Bool = false, values: T...) {
        precondition(values.count > 0, "Messages are zero count. You should pass a least one message.")
        
        let converted = values.map { LogMessage(token: token, tags: tags, payload: $0.debugDescription) }
        
        if store {
            guard let _storage = storage else { preconditionFailure("Undefined storage. Define a repository instance to use the persistent ability.") }
            _storage.save(converted)
        }
        
        let out: [Output] = outputs.count > 0 ? outputs : [DefaultLogger()]
        out.forEach { self.log(converted, for: token, with: tags, in: $0) }
    }
    
    // MARK: - Private
    
    private func log(_ messages: [Message], for token: Token, with tags: [Tag], in output: Output) {
        guard output.isDisplayAvailable(for: token, with: tags) else { return }
        output.display(messages, with: tags)
    }
}
