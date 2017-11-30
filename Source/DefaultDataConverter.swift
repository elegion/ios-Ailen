//
//  Created by Evgeniy Akhmerov on 17/11/2017.
//  Copyright © 2017 e-Legion. All rights reserved.
//

import Foundation

struct DefaultDataConverter {
    
    static func convert(_ source: ELNMessage) -> FilterStore.Message? {
        var tags = [String]()
        if let _tags = source.tag.allObjects as? [ELNTag] {
            tags = _tags.flatMap({ $0.value })
        }
        
        return (tags, source.token.value, source.date as Date, source.payload)
    }
}
