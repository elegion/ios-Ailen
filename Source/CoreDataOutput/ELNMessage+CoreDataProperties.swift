//
//  ELNMessage+CoreDataProperties.swift
//  ios-logger
//
//  Created by Evgeniy Akhmerov on 27/11/2017.
//  Copyright © 2017 e-Legion. All rights reserved.
//
//

import Foundation
import CoreData


extension ELNMessage {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ELNMessage> {
        return NSFetchRequest<ELNMessage>(entityName: "ELNMessage")
    }

    @NSManaged public var date: NSDate
    @NSManaged public var payload: String
    @NSManaged public var tag: NSSet
    @NSManaged public var token: NSSet

}

// MARK: Generated accessors for tag
extension ELNMessage {

    @objc(addTagObject:)
    @NSManaged public func addToTag(_ value: ELNTag)

    @objc(removeTagObject:)
    @NSManaged public func removeFromTag(_ value: ELNTag)

    @objc(addTag:)
    @NSManaged public func addToTag(_ values: NSSet)

    @objc(removeTag:)
    @NSManaged public func removeFromTag(_ values: NSSet)

}
