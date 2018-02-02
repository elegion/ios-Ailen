//
//  Created by Evgeniy Akhmerov on 08/11/2017.
//  Copyright © 2017 e-Legion. All rights reserved.
//

import Foundation

public protocol Token: RawRepresentable, Hashable where RawValue == String {
    // MARK: - Definitions
    var qos: Qos { get }
    
}

extension Token {
    public var hashValue: Int {
        return rawValue.hashValue
    }
}
