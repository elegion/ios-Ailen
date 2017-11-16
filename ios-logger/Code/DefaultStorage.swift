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
        static let messageEntityName = "ENLMessage"
        static let tokenEntityName = "ENLToken"
        static let tagEntityName = "ENLTag"
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
        //TODO
    }
    
    // MARK: - Storaging
    
    public func display(_ message: Message) {
        if accumulator != nil {
            accumulator!.append(message)
            savePersistentIfNeeded()
        } else {
            save([message])
        }
    }
    
    public func set(enabled: Bool, for token: Token) {
        //TODO
    }
    
    // MARK: - CountdownDelegate
    
    func countdownDidFinishLap(_ countdown: Countdown) {
        saveAccumulatedMessages()
    }
}
