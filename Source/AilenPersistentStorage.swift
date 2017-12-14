//
//  Created by Evgeniy Akhmerov on 14/12/2017.
//  Copyright © 2017 e-Legion. All rights reserved.
//

import CoreData

class AilenPersistentStorage: PersistentStoraging {
    
    // MARK: - Properties
    
    private let core: PersistentStoreCore
    public let lifeTime: TimeInterval?
    public var errorLogger: ErrorLogger?
    
    // MARK: - Life cycle
    
    public init(core: PersistentStoreCore, lifeTime: TimeInterval? = nil) {
        self.core = core
        self.lifeTime = lifeTime
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
            errorLogger?.display(error)
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
                self?.errorLogger?.display(_error)
            }
        }
    }
    
    private func fetchAll() -> [ELNMessage] {
        removeOldRecordsIfNeeded()
        return fetchMessages(predicate: nil)
    }
    
    private func removeOldRecordsIfNeeded() {
        guard let interval = lifeTime else { return }
        
        let date = Date(timeIntervalSinceNow: -interval)
        let predicate = NSPredicate(format: "date < %@", argumentArray: [date])
        
        removeMessages(predicate: predicate)
    }
    
    // MARK: - PersistentStoraging
    
    public var filter: FilterStore {
        let fetched = fetchAll()
        let mapped = fetched.flatMap { DefaultDataConverter.convert($0) }
        return FilterStore(data: mapped)
    }
    
    public func save(_ messages: [Message]) {
        let context = core.writeManagedObjectContext
        
        messages.forEach {
            (current) in
            
            let tokenObj: ELNToken = managedObject(for: ELNToken.entityName, in: context)
            tokenObj.value = current.token.rawValue
            
            let tagEntities: [ELNTag] = current.tags.map({
                let tagObj: ELNTag = managedObject(for: ELNTag.entityName, in: context)
                tagObj.value = $0.rawValue
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
                self?.errorLogger?.display(_error)
            }
        }
    }
}
