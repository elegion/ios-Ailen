//
//  Created by Evgeniy Akhmerov on 08/11/2017.
//  Copyright © 2017 e-Legion. All rights reserved.
//

import CoreData

public class DefaultStorage: DefaultOutput, CountdownDelegate {
    
    // MARK: - Definitions
    
    public struct Settings {
        public let autosaveCount: Int
        public let autosaveInterval: TimeInterval?
        public let lifeTime: TimeInterval?
        
        public init(autosaveCount: Int = 20, autosaveInterval: TimeInterval? = nil, lifeTime: TimeInterval? = nil) {
            if autosaveInterval != nil && autosaveCount < 0 {
                self.autosaveCount = 1
                preconditionFailure("You should define autosaveCount to use buffering.")
            }
            
            self.autosaveCount = autosaveCount
            self.autosaveInterval = autosaveInterval
            self.lifeTime = lifeTime
        }
    }
    
    // MARK: - Properties
    
    private let queue = DispatchQueue(label: "com.e-legion.DefaultStorage.queue")
    private let core: PersistentStoreCore
    private let autosaveTimer: Countdown?
    private let settings: Settings
    private var _accumulator: [Message]?
    private var accumulator: [Message]? {
        get { return queue.sync { self._accumulator } }
        set { queue.async { self._accumulator = newValue } }
    }
    public var errorLogger: ErrorLogger?
    public var filter: FilterStore {
        let fetched = fetchAll()
        let mapped = fetched.flatMap { DefaultDataConverter.convert($0) }
        return FilterStore(data: mapped)
    }
    
    // MARK: - Life cycle
    
    public init(core: PersistentStoreCore, settings: Settings) {
        self.core = core
        self.settings = settings
        
        if let interval = self.settings.autosaveInterval {
            self.autosaveTimer = Countdown(interval: interval)
        } else {
            self.autosaveTimer = nil
        }
        
        super.init()
        
        setupAccumulator()
        setupAutosaveTimer()
    }
    
    // MARK: - Private
    
    private func setupAccumulator() {
        if settings.autosaveCount > 0 {
            accumulator = [Message]()
        }
    }
    
    private func setupAutosaveTimer() {
        autosaveTimer?.delegate = self
        autosaveTimer?.activate()
    }
    
    private func savePersistentIfNeeded() {
        guard let count = accumulator?.count, count >= settings.autosaveCount else { return }
        
        saveAccumulatedMessages()
    }
    
    private func saveAccumulatedMessages() {
        guard let _accumulator = accumulator else { return }
        guard _accumulator.count > 0 else { return }
        
        save(_accumulator)
        accumulator?.removeAll()
    }
    
    private func save(_ messages: [Message]) {
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
        
        core.saveContext(context)
    }
    
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
        
        messages.forEach { context.delete($0) }
        
        core.saveContext(context)
    }
    
    private func fetchAll() -> [ELNMessage] {
        removeOldRecordsIfNeeded()
        return fetchMessages(predicate: nil)
    }
    
    private func removeOldRecordsIfNeeded() {
        guard let interval = settings.lifeTime else { return }
        
        let date = Date(timeIntervalSinceNow: -interval)
        let predicate = NSPredicate(format: "date < %@", argumentArray: [date])
        
        removeMessages(predicate: predicate)
    }
    
    // MARK: - Output
    
    open override func display(_ message: Message) {
        if self.accumulator != nil {
            self.accumulator!.append(message)
            self.savePersistentIfNeeded()
        } else {
            self.save([message])
        }
    }
    
    // MARK: - CountdownDelegate
    
    func countdownDidFinishLap(_ countdown: Countdown) {
        saveAccumulatedMessages()
    }
}
