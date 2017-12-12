//
//  Created by Evgeniy Akhmerov on 10/11/2017.
//  Copyright © 2017 e-Legion. All rights reserved.
//

import CoreData

public class DefaultStorageCore: PersistentStoreCore {
    
    // MARK: - Definitions
    
    private struct Constants {
        static let dataModelName = "com.e-legion.DefaultStorageDataModel"
        static let testLaunchArguments = "com.e-legion.TestLaunchArguments"
    }
    
    enum StorageError: Error {
        case applicationDocumentsDirectory
        case dataModelPath
        case managedObjectModel
        
        var localizedDescription: String {
            switch self {
            case .applicationDocumentsDirectory:    return "Failure to instantiate app documents directory URL"
            case .dataModelPath:                    return "Failure to instantiate data model path"
            case .managedObjectModel:               return "Failure to instantiate managed object model"
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
    public var errorLogger: ErrorLogger?
    
    // MARK: - Life cycle
    
    public init?(storeURL: URL? = nil) {
        let bundle: Bundle
        
        if ProcessInfo.processInfo.arguments.contains(Constants.testLaunchArguments) {
            bundle = Bundle(for: DefaultStorageCore.self)
            
        } else {
            let podBundle = Bundle(for: DefaultStorageCore.self)
            guard let bundleURL = podBundle.url(forResource: "ios-logger", withExtension: "bundle"),
                let _bundle = Bundle(url: bundleURL) else {
                    errorLogger?.display(StorageError.dataModelPath)
                    return nil
            }
            bundle = _bundle
        }
        
        guard let urlString = bundle.path(forResource: Constants.dataModelName, ofType: "momd"),
            let url = URL(string: urlString)
            else {
                errorLogger?.display(StorageError.dataModelPath)
                return nil
        }
        
        guard let mom = NSManagedObjectModel(contentsOf: url) else {
            errorLogger?.display(StorageError.managedObjectModel)
            return nil
        }
        
        self.managedObjectModel = mom
        self.persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        
        let _storeURL = storeURL ?? applicationDocumentsDirectory?.appendingPathComponent(Constants.dataModelName + ".sqlite")
        guard let storeLocation = _storeURL else {
            errorLogger?.display(StorageError.applicationDocumentsDirectory)
            return nil
        }
        
        do {
            try setupPersistentStore(storeURL: storeLocation)
        } catch {
            errorLogger?.display(error)
            do {
                try removePersistentModel(storeURL: storeLocation)
                try setupPersistentStore(storeURL: storeLocation)
            } catch  {
                errorLogger?.display(error)
                return nil
            }
        }
    }
    
    // MARK: - Private
    
    private func setupPersistentStore(storeURL: URL) throws {
        try persistentStoreCoordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: storeURL, options: nil)
    }
    
    private func removePersistentModel(storeURL: URL) throws {
        try FileManager.default.removeItem(at: storeURL)
    }
    
    private func saveParentContext() {
        parentMoc.perform {
            do {
                try self.parentMoc.save()
            } catch {
                self.errorLogger?.display(error)
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
    
    public func saveContext(_ context: NSManagedObjectContext) {
        guard context.hasChanges else { return }
        do {
            try context.save()
            saveParentContext()
        } catch {
            errorLogger?.display(error)
        }
    }
}
