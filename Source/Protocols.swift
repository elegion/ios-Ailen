//
//  Created by Evgeniy Akhmerov on 07/11/2017.
//  Copyright © 2017 e-Legion. All rights reserved.
//

import CoreData

public protocol Message {
    var token: Token { get }
    var tags: [Tag] { get }
    var payload: String { get }
}

public protocol Output {
    func proccess(_ message: Message)
    func set(enabled: Bool, for token: Token)
}

public protocol Processor {
    func process(token: Token, object: Any) -> String?
}

public protocol PersistentStoreCore {
    var mom: NSManagedObjectModel { get }
    var psc: NSPersistentStoreCoordinator { get }
    var readMoc: NSManagedObjectContext { get }
    var writeMoc: NSManagedObjectContext { get }
    var currentMoc: NSManagedObjectContext { get }
    
    func saveContext(_ context: NSManagedObjectContext)
}

public protocol Storaging: Output {
    var filter: FilterStore { get }
}

public protocol ErrorLogger {
    func display(_ error: Error)
}

public protocol TokenLocking {
    func lock(token: Token)
    func unlock(token: Token)
    func isLocked(token: Token) -> Bool
}
