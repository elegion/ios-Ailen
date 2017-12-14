//
//  Created by Evgeniy Akhmerov on 07/11/2017.
//  Copyright © 2017 e-Legion. All rights reserved.
//

import CoreData

public protocol Message {
    var token: Token { get }
    var tags: [Tag] { get }
    var date: Date { get }
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
    var managedObjectModel: NSManagedObjectModel { get }
    var persistentStoreCoordinator: NSPersistentStoreCoordinator { get }
    var readManagedObjectContext: NSManagedObjectContext { get }
    var writeManagedObjectContext: NSManagedObjectContext { get }
    var currentManagedObjectContext: NSManagedObjectContext { get }
    
    func saveContext(_ context: NSManagedObjectContext, completion: ((Error?) -> Void)?)
}

public protocol ErrorLogger {
    func display(_ error: Error)
}

public protocol TokenLocking {
    func lock(token: Token)
    func unlock(token: Token)
    func isLocked(token: Token) -> Bool
}

protocol EntityDescribing {
    static var entityName: String { get }
}

extension EntityDescribing {
    static var entityName: String {
        return String(describing: Self.self)
    }
}

public protocol PersistentStoraging {
    var filter: FilterStore { get }
    func save(_ messages: [Message])
}
