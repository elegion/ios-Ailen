//
//  Created by Evgeniy Akhmerov on 08/11/2017.
//  Copyright © 2017 e-Legion. All rights reserved.
//

import CoreData

public class DefaultStorage: Storaging {
    
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
    private let settings: Settings
    private var accumulator: [Message]?
    private var autosaveTimer: Timer?
    
    // MARK: - Life cycle
    
    public init(core: PersistentStoreCore, settings: Settings) {
        self.core = core
        self.settings = settings
        setupAccumulator()
        setupTimer()
    }
    
    deinit {
        autosaveTimer?.invalidate()
    }
    
    // MARK: - Private
    
    private func setupAccumulator() {
        if settings.autosaveCount > 0 {
            accumulator = [Message]()
        }
    }
    
    private func setupTimer() {
        if let interval = settings.autosaveInterval {
            autosaveTimer = Timer.scheduledTimer(timeInterval: interval, target: self, selector: #selector(autosaveTimerLapHandler), userInfo: nil, repeats: true)
        }
    }
    
    @objc private func autosaveTimerLapHandler() {
        guard let _accumulator = accumulator else { return }
        guard _accumulator.count > 0 else { return }
        
        save(_accumulator)
        accumulator?.removeAll()
    }
    
    private func savePersistentIfNeeded() {
        guard let count = accumulator?.count,
            count >= settings.autosaveCount else { return }
        
        autosaveTimerLapHandler()
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
        //
    }
}
