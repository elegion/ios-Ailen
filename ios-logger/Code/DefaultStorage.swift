//
//  Created by Evgeniy Akhmerov on 08/11/2017.
//  Copyright © 2017 e-Legion. All rights reserved.
//

import CoreData

public class DefaultStorage: Storaging, CountdownDelegate {
    
    // MARK: - Definitions
    
    public struct Settings {
        public let autosaveCount: Int
        public let autosaveInterval: TimeInterval?
        public let storeInterval: TimeInterval?
        
        public init(autosaveCount: Int = 20, autosaveInterval: TimeInterval? = nil, storeInterval: TimeInterval? = nil) {
            if autosaveInterval != nil && autosaveCount < 0 {
                self.autosaveCount = 1
                preconditionFailure("You should define autosaveCount to use buffering.")
            }
            
            self.autosaveCount = autosaveCount
            self.autosaveInterval = autosaveInterval
            self.storeInterval = storeInterval
        }
    }
    
    private struct Consts {
        static let messageEntityName = "ELNMessage"
        static let tokenEntityName = "ELNToken"
        static let tagEntityName = "ELNTag"
    }
    
    //    enum StorageError: Error {
    //        case pullLogsFileCreation(String)
    //        case tokenUniquenessLost
    //        case tagUniquenessLost
    //
    //        var localizedDescription: String {
    //            switch self {
    //            case .pullLogsFileCreation(let path):   return "Can't create file at \(path)"
    //            case .tokenUniquenessLost:              return "There are non unique token in data base"
    //            case .tagUniquenessLost:                return "There are non unique tag in data base"
    //            }
    //        }
    //    }
    
    // MARK: - Properties
    
    private let core: PersistentStoreCore
    private let autosaveCount: Int
    private let autosaveTimer: Countdown?
    private let storeInterval: TimeInterval?
    private var accumulator: [Message]?
    public var errorLogger: ErrorLogger?
    public var tokenBlocker: TokenLocking?
    
    // MARK: - Life cycle
    
    public init(core: PersistentStoreCore, settings: Settings) {
        self.core = core
        
        self.autosaveCount = settings.autosaveCount
        self.storeInterval = settings.storeInterval
        
        if let interval = settings.autosaveInterval {
            self.autosaveTimer = Countdown(interval: interval)
        } else {
            self.autosaveTimer = nil
        }
        
        setupAccumulator()
        setupAutosaveTimer()
    }
    
    // MARK: - Private
    
    private func setupAccumulator() {
        if autosaveCount > 0 {
            accumulator = [Message]()
        }
    }
    
    private func setupAutosaveTimer() {
        autosaveTimer?.delegate = self
        autosaveTimer?.activate()
    }
    
    private func savePersistentIfNeeded() {
        guard let count = accumulator?.count, count >= autosaveCount else { return }
        
        saveAccumulatedMessages()
    }
    
    private func saveAccumulatedMessages() {
        guard let _accumulator = accumulator else { return }
        guard _accumulator.count > 0 else { return }
        
        save(_accumulator)
        accumulator?.removeAll()
    }
    
    private func save(_ messages: [Message]) {
        let context = core.writeMoc
        
        messages.forEach {
            (current) in
            
            let tokenObj: ELNToken = managedObject(for: Consts.tokenEntityName, in: context)
            tokenObj.value = current.token.rawValue
            
            let tagEntities: [ELNTag] = current.tags.map({
                let tagObj: ELNTag = managedObject(for: Consts.tagEntityName, in: context)
                tagObj.value = $0.rawValue
                return tagObj
            })
            
            let messageObj: ELNMessage = managedObject(for: Consts.messageEntityName, in: context)
            
            messageObj.token = tokenObj
            messageObj.addToTag(NSSet(array: tagEntities))
            messageObj.payload = current.payload
        }
        
        core.saveContext(context)
    }
    
    private func managedObject<Result>(for name: String, in context: NSManagedObjectContext) -> Result {
        return NSEntityDescription.insertNewObject(forEntityName: name, into: context) as! Result
    }
    
    private func fetchMessages(predicate: NSPredicate?) -> [ELNMessage] {
        let context = core.readMoc
        
        let request = NSFetchRequest<ELNMessage>(entityName: Consts.messageEntityName)
        request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
        request.predicate = predicate
        
        do {
            return try context.fetch(request)
        } catch {
            errorLogger?.display(error)
            return [ELNMessage]()
        }
    }
    
    private func fetchAll() -> [ELNMessage] {
        removeOldRecordsIfNeeded()
        return fetchMessages(predicate: nil)
    }
    
    private func removeOldRecordsIfNeeded() {
        guard let interval = storeInterval else { return }
        
        let date = Date(timeIntervalSinceNow: -interval)
        let predicate = NSPredicate(format: "date < \(date)")
        let messages = fetchMessages(predicate: predicate)
        
        let context = core.writeMoc
        
        messages.forEach { context.delete($0) }
        
        core.saveContext(context)
    }
    
    // MARK: - Storaging
    
    public var filter: FilterStore {
        let fetched = fetchAll()
        let mapped = fetched.flatMap { DefaultDataConverter.convert($0) }
        return FilterStore(data: mapped)
    }
    
    public func display(_ message: Message) {
        if accumulator != nil {
            accumulator!.append(message)
            savePersistentIfNeeded()
        } else {
            save([message])
        }
    }
    
    public func set(enabled: Bool, for token: Token) {
        guard let blocker = tokenBlocker else { return }
        
        if enabled {
            blocker.unlock(token: token)
        } else {
            blocker.lock(token: token)
        }
    }
    
    // MARK: - CountdownDelegate
    
    func countdownDidFinishLap(_ countdown: Countdown) {
        saveAccumulatedMessages()
    }
}
