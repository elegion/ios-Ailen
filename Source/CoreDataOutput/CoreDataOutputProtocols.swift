//
//  CoreDataOutputProtocols.swift
//  Ailen
//
//  Created by Arkady Smirnov on 2/1/18.
//  Copyright © 2018 e-Legion. All rights reserved.
//

import Foundation
import CoreData

public protocol PersistentStoreCore {
    var managedObjectModel: NSManagedObjectModel { get }
    var persistentStoreCoordinator: NSPersistentStoreCoordinator { get }
    var readManagedObjectContext: NSManagedObjectContext { get }
    var writeManagedObjectContext: NSManagedObjectContext { get }
    var currentManagedObjectContext: NSManagedObjectContext { get }
    
    func saveContext(_ context: NSManagedObjectContext, completion: ((Error?) -> Void)?)
}

protocol EntityDescribing {
    static var entityName: String { get }
}

extension EntityDescribing {
    static var entityName: String {
        return String(describing: Self.self)
    }
}

public struct PersistentMessage {
    let token: String
    let tags: [String]
    let date: Date
    let payload: String
}

public protocol PersistentStoraging {
    var filter: FilterStore { get }
    func save(_ messages: [PersistentMessage])
    func deleteAll(till date: Date)
}
