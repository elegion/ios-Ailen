//
//  Created by Evgeniy Akhmerov on 10/11/2017.
//  Copyright © 2017 e-Legion. All rights reserved.
//

import Foundation
import CoreData

public protocol ErrorLogger {
    func display(_ error: Error)
}

public class DefaultStorageCore {
    
    // MARK: - Definitions
    
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
        context.persistentStoreCoordinator = psc
        return context
    }()
    
    public var errorLogger: ErrorLogger?
    public var currentMoc: NSManagedObjectContext {
        return Thread.isMainThread ? readMoc : writeMoc
    }
    public let mom: NSManagedObjectModel
    public let psc: NSPersistentStoreCoordinator
    
    public lazy var readMoc: NSManagedObjectContext = {
        let context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        context.parent = parentMoc
        return context
    }()
    public var writeMoc: NSManagedObjectContext {
        let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        context.parent = parentMoc
        return context
    }
    
    // MARK: - Life cycle
    
    public init?(dataModelName: String) {
        let bundle = Bundle(for: type(of: self))
        guard let urlString = bundle.path(forResource: dataModelName, ofType: "momd"),
            let url = URL(string: urlString) else {
                errorLogger?.display(StorageError.dataModelPath)
                return nil
        }
        
        guard let mom = NSManagedObjectModel(contentsOf: url) else {
            errorLogger?.display(StorageError.managedObjectModel)
            return nil
        }
        
        self.mom = mom
        self.psc = NSPersistentStoreCoordinator(managedObjectModel: self.mom)
        
        guard let storeURL = applicationDocumentsDirectory?.appendingPathComponent(dataModelName + ".sqllite") else {
            errorLogger?.display(StorageError.applicationDocumentsDirectory)
            return nil
        }
        
        do {
            try setupPersistentStore(storeURL: storeURL)
        } catch {
            errorLogger?.display(error)
            do {
                try removePersistentModel(storeURL: storeURL)
                try setupPersistentStore(storeURL: storeURL)
            } catch  {
                errorLogger?.display(error)
                return nil
            }
        }
    }
    
    // MARK: - Public
    
    public func saveContext(_ context: NSManagedObjectContext) {
        guard context.hasChanges else { return }
        do {
            try context.save()
            try context.parent?.save()
        } catch {
            errorLogger?.display(error)
        }
    }
    
    // MARK: - Private
    
    private func setupPersistentStore(storeURL: URL) throws {
        try psc.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: storeURL, options: nil)
    }
    
    private func removePersistentModel(storeURL: URL) throws {
        try FileManager.default.removeItem(at: storeURL)
    }
}
