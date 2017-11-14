//
//  Created by Evgeniy Akhmerov on 07/11/2017.
//  Copyright © 2017 e-Legion. All rights reserved.
//

import Foundation
import CoreData

public protocol Token {
    var name: String { get }
    var format: String { get }
    var isOn: Bool { get set }
}

public protocol Message: CustomStringConvertible {
    var token: Token { get }
    var tags: [Tag] { get }
    var payload: String { get }
}

public protocol Output {
    func isDisplayAvailable(for token: Token, with tags: [Tag]) -> Bool
    func display(_ messages: [Message], with tags: [Tag])
}

public protocol Storaging {
    func save(_ messages: [Message])
    func messages(for tokens: [Token]) -> [Message]
    func messages(with tags: [Tag]) -> [Message]
    func messages(for tokens: [Token], with tags: [Tag]) -> [Message]
}

public protocol StorageConfiguration {
    var managedObjectContext: NSManagedObjectContext { get }
    var managedObjectModel: NSManagedObjectModel { get }
    var persistentStoreCoordinator: NSPersistentStoreCoordinator { get }
    
    func saveContext()
}

public protocol MultipleContextsStorageConfiguration: StorageConfiguration {
    var readManagedObjectContext: NSManagedObjectContext { get }
    var writeManagedObjectContext: NSManagedObjectContext { get }
    
    func saveContext(_ context: NSManagedObjectContext)
}
