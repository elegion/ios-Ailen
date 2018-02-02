//
//  Tag.swift
//  Ailen
//
//  Created by Arkady Smirnov on 2/2/18.
//  Copyright © 2018 e-Legion. All rights reserved.
//

import Foundation

public struct Tag: RawRepresentable {
    
    // MARK: - RawRepresentable
    
    public init(rawValue: String) {
        self.rawValue = rawValue
    }
    
    public var rawValue: String
}

public extension Tag {
    
    //TODO: define default tags here
    
    static let response = Tag(rawValue: "Response")
}
