//
//  Created by Ilya Kulebyakin on 16/11/2017.
//  Copyright © 2017 e-Legion. All rights reserved.
//

import Foundation

public class FilterStore {
    
    typealias Message = (tags: [String], token: String, date: Date, message: String)
    
    var data: [Message]
    
    init(data: [Message]) {
        self.data = data
    }
    
    private func filter(predicate: (Message) -> Bool) -> FilterStore {
        return FilterStore(data: self.data.filter(predicate))
    }
    
    func containing(tag: String) -> FilterStore {
        return filter { $0.0.contains(tag) }
    }
}
