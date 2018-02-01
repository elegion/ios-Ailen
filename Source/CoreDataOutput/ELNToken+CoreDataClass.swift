//
//  ELNToken+CoreDataClass.swift
//  ios-logger
//
//  Created by Evgeniy Akhmerov on 27/11/2017.
//  Copyright © 2017 e-Legion. All rights reserved.
//
//

import Foundation
import CoreData

@objc(ELNToken)
public class ELNToken: NSManagedObject, EntityDescribing {
    
    override public func prepareForDeletion() {
        guard message.count == 0 else { return }
        
        super.prepareForDeletion()
    }
}
