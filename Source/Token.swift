//
//  Created by Evgeniy Akhmerov on 08/11/2017.
//  Copyright © 2017 e-Legion. All rights reserved.
//

import Foundation

public struct Token: RawRepresentable, Hashable {
    
    // MARK: - Definitions
    
    public enum Qos {
        case global(async: Bool)
        case main(async: Bool)
        case custom(queue: DispatchQueue, async: Bool)
        
        var queue: DispatchQueue {
            switch self {
            case .main:                 return .main
            case .global:               return .global(qos: .utility)
            case .custom(let params):   return params.queue
            }
        }
        
        var isAsync: Bool {
            switch self {
            case .main(async: let _isAsync):                return _isAsync
            case .global(async: let _isAsync):              return _isAsync
            case .custom(queue: _, async: let _isAsync):    return _isAsync
            }
        }
    }
    
    // MARK: - Properties
    
    public var qos = Qos.global(async: true)
    
    // MARK: - Life cycle
    
    public init(rawValue: String, qos: Qos) {
        self.init(rawValue: rawValue)
        self.qos = qos
    }
    
    // MARK: - RawRepresentable
    
    public init(rawValue: String) {
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
    
    static let request = Token(rawValue: "Request")
}


