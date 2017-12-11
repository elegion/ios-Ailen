//
//  ELNTag+CoreDataClass.swift
//  ios-logger
//
//  Created by Evgeniy Akhmerov on 27/11/2017.
//  Copyright © 2017 e-Legion. All rights reserved.
//
//

import Foundation
import CoreData

@objc(ELNTag)
public class ELNTag: NSManagedObject, EntityDescribing {
    
    override public func prepareForDeletion() {
        guard message.count == 0 else { return }
        
        super.prepareForDeletion()
    }
}
