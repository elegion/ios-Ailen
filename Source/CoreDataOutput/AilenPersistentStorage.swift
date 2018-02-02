//
//  Created by Evgeniy Akhmerov on 14/12/2017.
//  Copyright © 2017 e-Legion. All rights reserved.
//

import CoreData

public protocol AilenPersistentStorageDelegate: class {
    func storageDidFailSaving(_ persistentStorage: AilenPersistentStorage, with error: Error)
    func storageDidFailFetchMessages(_ persistentStorage: AilenPersistentStorage, predicate: NSPredicate?, with error: Error)
}

public class AilenPersistentStorage: PersistentStoraging {
    
    // MARK: - Properties
    
    private let core: PersistentStoreCore
    public var delegate: AilenPersistentStorageDelegate?
    
    // MARK: - Life cycle
    
    public init(core: PersistentStoreCore) {
        self.core = core
    }
    
    // MARK: - Private
    
    private func managedObject<Result>(for name: String, in context: NSManagedObjectContext) -> Result {
        return NSEntityDescription.insertNewObject(forEntityName: name, into: context) as! Result
    }
    
    private func fetchMessages(predicate: NSPredicate?, in context: NSManagedObjectContext? = nil) -> [ELNMessage] {
        let context = context ?? core.readManagedObjectContext
        
        let request = NSFetchRequest<ELNMessage>(entityName: ELNMessage.entityName)
        request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
        request.predicate = predicate
        
        do {
            return try context.fetch(request)
        } catch {
            delegate?.storageDidFailFetchMessages(self, predicate: predicate, with: error)
            return [ELNMessage]()
        }
    }
    
    private func removeMessages(predicate: NSPredicate? = nil, in context: NSManagedObjectContext? = nil) {
        let context = context ?? core.writeManagedObjectContext
        
        let messages = fetchMessages(predicate: predicate, in: context)
        
        messages.forEach(context.delete)
        
        core.saveContext(context) {
            [weak self] (error) in
            if let _error = error {
                self?.handleSaveContextError(_error)
            }
        }
    }
    
    private func fetchAll() -> [ELNMessage] {
        return fetchMessages(predicate: nil)
    }
    
    private func handleSaveContextError(_ error: Error) {
        delegate?.storageDidFailSaving(self, with: error)
    }
    
    // MARK: - PersistentStoraging
    
    public var filter: FilterStore {
        let fetched = fetchAll()
        let mapped = fetched.flatMap { DefaultDataConverter.convert($0) }
        return FilterStore(data: mapped)
    }
    
    public func save(_ messages: [PersistentMessage]) {
        let context = core.writeManagedObjectContext
        
        messages.forEach {
            (current) in
            
            let tokenObj: ELNToken = managedObject(for: ELNToken.entityName, in: context)
            tokenObj.value = current.token
            
            let tagEntities: [ELNTag] = current.tags.map({
                let tagObj: ELNTag = managedObject(for: ELNTag.entityName, in: context)
                tagObj.value = $0
                return tagObj
            })
            
            let messageObj: ELNMessage = managedObject(for: ELNMessage.entityName, in: context)
            
            messageObj.token = NSSet(object: tokenObj)
            messageObj.addToTag(NSSet(array: tagEntities))
            messageObj.date = current.date as NSDate
            messageObj.payload = current.payload
        }
        
        core.saveContext(context) {
            [weak self] (error) in
            if let _error = error {
                self?.handleSaveContextError(_error)
            }
        }
    }
    
    public func deleteAll(till date: Date) {
        let predicate = NSPredicate(format: "date < %@", argumentArray: [date])
        
        removeMessages(predicate: predicate)
    }
}
