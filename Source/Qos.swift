//
//  Qos.swift
//  Ailen
//
//  Created by Arkady Smirnov on 2/2/18.
//  Copyright © 2018 e-Legion. All rights reserved.
//

import Foundation

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