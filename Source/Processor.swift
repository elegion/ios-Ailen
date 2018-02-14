//
//  Processor.swift
//  Ailen
//
//  Created by Arkady Smirnov on 2/14/18.
//  Copyright © 2018 e-Legion. All rights reserved.
//

import Foundation

public protocol Processor {
    associatedtype PayloadType
    func process<TokenType: Token>(token: TokenType, object: Any) -> PayloadType?
}


public class AnyProcessor<PayloadType>: Processor {
    
    fileprivate init() { }
    
    public func process<TokenType: Token>(token: TokenType, object: Any) -> PayloadType? {
        return nil
    }
    
}

class AnyProcessorEraser<ErasedType: Processor>: AnyProcessor<ErasedType.PayloadType> {
    typealias PayloadType = ErasedType.PayloadType
    
    let erased: ErasedType
    
    init(_ erased: ErasedType) {
        self.erased = erased
        super.init()
    }
    
    override func process<TokenType: Token>(token: TokenType, object: Any) -> PayloadType? {
        return erased.process(token: token, object: object)
    }
    
}
