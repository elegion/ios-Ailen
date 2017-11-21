//
//  Created by Evgeniy Akhmerov on 08/11/2017.
//  Copyright © 2017 e-Legion. All rights reserved.
//

import Foundation

public struct Token: RawRepresentable, Hashable {
    
    // MARK: - Definitions
    
    public enum Qos {
        case global, main, custom(DispatchQueue)
    }
    
    // MARK: - Properties
    
    public var qos = Qos.global
    
    // MARK: - Life cycle
    
    public init?(rawValue: String, qos: Qos) {
        self.init(rawValue: rawValue)
        self.qos = qos
    }
    
    // MARK: - RawRepresentable
    
    public init?(rawValue: String) {
        self.rawValue = rawValue
    }
    
    public var rawValue: String
    
    // MARK: - Hashable
    
    public var hashValue: Int {
        return rawValue.hashValue
    }
}

extension Token {
    //TODO: define default tokens here
    
    static let request = Token(rawValue: "Request")!
}

// MARK: -

public struct Tag: RawRepresentable {
    
    // MARK: - RawRepresentable
    
    public init?(rawValue: String) {
        self.rawValue = rawValue
    }
    
    public var rawValue: String
}


public extension Tag {
    
    //TODO: define default tags here
    
    static let response = Tag(rawValue: "Response")!
}
