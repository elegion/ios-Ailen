//
//  Created by Evgeniy Akhmerov on 10/11/2017.
//  Copyright © 2017 e-Legion. All rights reserved.
//

import Foundation
import CoreData

public class DefaultStorageConfiguration: MultipleContextsStorageConfiguration {
    
    private struct Consts {
        static let dataModelName = "DefaultStorageDataModel"
    }
    
    // MARK: - Properties
    
    private var applicationDocumentsDirectory: URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last!
    }
    private let parentManagedObjectContext: NSManagedObjectContext
    
    // MARK: - Life cycle
    
    public init() {
        self.parentManagedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        self.readManagedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        self.readManagedObjectContext.parent = self.parentManagedObjectContext
        let bundle = Bundle(for: DefaultStorageConfiguration.self)
        let urlString = bundle.path(forResource: Consts.dataModelName, ofType: "momd")
        let url = URL(string: urlString!)!
        self.managedObjectModel = NSManagedObjectModel(contentsOf: url)!
        self.persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        self.managedObjectContext.persistentStoreCoordinator = self.persistentStoreCoordinator
        setupPersistentStore()
    }
    
    // MARK: - Private
    
    private func setupPersistentStore() {
        let storeURL = applicationDocumentsDirectory.appendingPathComponent(Consts.dataModelName + ".sqllite")
        do {
            try persistentStoreCoordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: storeURL, options: nil)
        } catch {
            assertionFailure(error.localizedDescription)
            do {
                try FileManager.default.removeItem(at: storeURL)
                setupPersistentStore()
            } catch {
                fatalError(error.localizedDescription)
            }
        }
    }
    
    // MARK: - StorageConfiguration
    
    public var managedObjectContext: NSManagedObjectContext {
        if Thread.isMainThread {
            return readManagedObjectContext
        } else {
            return writeManagedObjectContext
        }
    }
    public let managedObjectModel: NSManagedObjectModel
    public let persistentStoreCoordinator: NSPersistentStoreCoordinator
    
    public func saveContext() {
        assertionFailure("Unimplemented there. Use saveContext(:)")
    }
    
    // MARK: - MultipleContextsStorageConfiguration
    
    public let readManagedObjectContext: NSManagedObjectContext
    public var writeManagedObjectContext: NSManagedObjectContext {
        let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        context.parent = parentManagedObjectContext
        return context
    }
    
    public func saveContext(_ context: NSManagedObjectContext) {
        guard context.hasChanges else { return }
        do {
            try context.save()
        } catch {
            fatalError(error.localizedDescription)
        }
    }
}
