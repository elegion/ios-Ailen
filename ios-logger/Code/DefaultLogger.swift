//
//  Created by Evgeniy Akhmerov on 09/11/2017.
//  Copyright © 2017 e-Legion. All rights reserved.
//

import Foundation

internal class DefaultLogger: Output {
    
    // MARK: - Private
    
    private func _display(_ messages: [Message]) {
        messages.forEach { print(String(format: $0.token.format, arguments: [$0.payload])) }
    }
    
    // MARK: - Output
    
    func isDisplayAvailable(for token: Token, with tags: [Tag]) -> Bool {
        return token.isOn
    }
    
    func display(_ messages: [Message], with tags: [Tag]) {
        guard tags.count > 0 else {
            _display(messages)
            return
        }
        
        let filtered = messages.filter {
            let source = Set(tags)
            let destination = Set($0.tags)
            return source.isSubset(of: destination)
        }
        
        _display(filtered)
    }
}
