//
//  Created by Ilya Kulebyakin on 16/11/2017.
//  Copyright © 2017 e-Legion. All rights reserved.
//

import Foundation

public class FilterStore {
    
    public typealias Message = (tags: [String], token: String, date: Date, message: String)
    
    public var data: [Message]
    
    public init(data: [Message]) {
        self.data = data
    }
    
    private func filter(predicate: (Message) -> Bool) -> FilterStore {
        return FilterStore(data: self.data.filter(predicate))
    }
    
    public func containing(tag: String) -> FilterStore {
        if tag.isEmpty {
            return self
        } else {
            return filter { $0.0.contains(tag) }
        }
    }
}
