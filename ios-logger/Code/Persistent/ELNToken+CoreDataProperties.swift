//
//  ELNToken+CoreDataProperties.swift
//  ios-logger
//
//  Created by Evgeniy Akhmerov on 27/11/2017.
//  Copyright © 2017 e-Legion. All rights reserved.
//
//

import Foundation
import CoreData


extension ELNToken {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ELNToken> {
        return NSFetchRequest<ELNToken>(entityName: "ELNToken")
    }

    @NSManaged public var value: String
    @NSManaged public var message: NSSet

}

// MARK: Generated accessors for message
extension ELNToken {

    @objc(addMessageObject:)
    @NSManaged public func addToMessage(_ value: ELNMessage)

    @objc(removeMessageObject:)
    @NSManaged public func removeFromMessage(_ value: ELNMessage)

    @objc(addMessage:)
    @NSManaged public func addToMessage(_ values: NSSet)

    @objc(removeMessage:)
    @NSManaged public func removeFromMessage(_ values: NSSet)

}
