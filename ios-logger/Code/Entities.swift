//
//  Created by Evgeniy Akhmerov on 08/11/2017.
//  Copyright © 2017 e-Legion. All rights reserved.
//

import Foundation

public struct Token: RawRepresentable {
    
    // MARK: - Definitions
    
    public enum Qos {
        case global, main, custom(DispatchQueue)
    }
    
    // MARK: - Properties
    
    public var qos = Qos.global
    
    // MARK: - RawRepresentable
    
    public typealias RawValue = String
    
    public init?(rawValue: String) {
        self.rawValue = rawValue
    }
    
    public var rawValue: String
}

// MARK: -

public struct Tag: RawRepresentable {
    
    // MARK: - RawRepresentable
    
    public typealias RawValue = String
    
    public init?(rawValue: String) {
        self.rawValue = rawValue
    }
    
    public var rawValue: String
}


public extension Tag {
    
    //TODO: define default tags here
    
    static let response = Tag(rawValue: "Response")!
}
