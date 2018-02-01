//
//  Created by Evgeniy Akhmerov on 10/11/2017.
//  Copyright © 2017 e-Legion. All rights reserved.
//

import CoreData

public class AilenPersistentCore: PersistentStoreCore {
    
    // MARK: - Definitions
    
    private struct Constants {
        static let dataModelName = "com.e-legion.DefaultStorageDataModel"
        static let testLaunchArguments = "com.e-legion.TestLaunchArguments"
    }
    
    enum StorageError: Error {
        case unableToLocateDataBase
        case unableToLocateDataModel
        case unableToInstantiateManagedObjectModel
        case unableToLocateBundle
        
        var localizedDescription: String {
            switch self {
            case .unableToLocateDataBase:                   return "Failure to instantiate data base URL"
            case .unableToLocateDataModel:                  return "Failure to instantiate data model path"
            case .unableToInstantiateManagedObjectModel:    return "Failure to instantiate managed object model"
            case .unableToLocateBundle:                     return "Failure to locate bundle"
            }
        }
    }
    
    // MARK: - Properties
    
    private var applicationDocumentsDirectory: URL? {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last
    }
    private lazy var parentMoc: NSManagedObjectContext = {
        let context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        context.persistentStoreCoordinator = persistentStoreCoordinator
        return context
    }()
    
    // MARK: - Life cycle
    
    public init(storeURL: URL? = nil) throws {
        let bundle: Bundle
        
        if ProcessInfo.processInfo.arguments.contains(Constants.testLaunchArguments) {
            bundle = Bundle(for: AilenPersistentCore.self)
            
        } else {
            let podBundle = Bundle(for: AilenPersistentCore.self)
            guard let bundleURL = podBundle.url(forResource: "ios-logger", withExtension: "bundle"),
                let _bundle = Bundle(url: bundleURL) else {
                    throw StorageError.unableToLocateBundle
            }
            bundle = _bundle
        }
        
        guard let urlString = bundle.path(forResource: Constants.dataModelName, ofType: "momd"),
            let url = URL(string: urlString)
            else {
                throw StorageError.unableToLocateDataModel
        }
        
        guard let mom = NSManagedObjectModel(contentsOf: url) else {
            throw StorageError.unableToInstantiateManagedObjectModel
        }
        
        self.managedObjectModel = mom
        self.persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        
        let _storeURL = storeURL ?? applicationDocumentsDirectory?.appendingPathComponent(Constants.dataModelName + ".sqlite")
        guard let storeLocation = _storeURL else {
            throw StorageError.unableToLocateDataBase
        }
        
        do {
            try setupPersistentStore(storeURL: storeLocation)
        } catch {
            try removePersistentModel(storeURL: storeLocation)
            try setupPersistentStore(storeURL: storeLocation)
        }
    }
    
    // MARK: - Private
    
    private func setupPersistentStore(storeURL: URL) throws {
        try persistentStoreCoordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: storeURL, options: nil)
    }
    
    private func removePersistentModel(storeURL: URL) throws {
        try FileManager.default.removeItem(at: storeURL)
    }
    
    private func saveParentContext(completion: ((Error?) -> Void)?) {
        parentMoc.perform {
            do {
                try self.parentMoc.save()
                completion?(nil)
            } catch {
                completion?(error)
            }
        }
    }
    
    // MARK: - PersistentStoreCore
    
    public let managedObjectModel: NSManagedObjectModel
    public let persistentStoreCoordinator: NSPersistentStoreCoordinator
    public lazy var readManagedObjectContext: NSManagedObjectContext = {
        let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        context.parent = parentMoc
        return context
    }()
    public var writeManagedObjectContext: NSManagedObjectContext {
        let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        context.parent = parentMoc
        return context
    }
    public var currentManagedObjectContext: NSManagedObjectContext {
        return Thread.isMainThread ? readManagedObjectContext : writeManagedObjectContext
    }
    
    public func saveContext(_ context: NSManagedObjectContext, completion: ((Error?) -> Void)?) {
        guard context.hasChanges else { return }
        
        context.perform {
            do {
                try context.save()
                self.saveParentContext(completion: completion)
            } catch {
                completion?(error)
            }
        }
    }
}
