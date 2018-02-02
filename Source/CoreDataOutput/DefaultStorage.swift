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
    private let autosaveTimer: Countdown?
    private let settings: Settings
    private let persistent: PersistentStoraging
    private var _accumulator: [PersistentMessage]?
    private var accumulator: [PersistentMessage]? {
        get { return queue.sync { self._accumulator } }
        set { queue.async { self._accumulator = newValue } }
    }
    
    // MARK: - Life cycle
    
    public init(settings: Settings, persistent: PersistentStoraging) {
        self.settings = settings
        self.persistent = persistent
        
        if let interval = self.settings.autosaveInterval {
            self.autosaveTimer = Countdown(interval: interval)
        } else {
            self.autosaveTimer = nil
        }
        
        super.init()
        
        setupAccumulator()
        setupAutosaveTimer()
    }
    
    deinit {
        autosaveTimer?.deactivate()
    }
    
    // MARK: - Private
    
    private func setupAccumulator() {
        if settings.autosaveCount > 0 {
            accumulator = [PersistentMessage]()
        }
    }
    
    private func setupAutosaveTimer() {
        autosaveTimer?.delegate = self
        autosaveTimer?.activate()
    }
    
    private func saveAccumulatedMessagesIfNeeded() {
        guard let count = accumulator?.count, count >= settings.autosaveCount else { return }
        
        saveAccumulatedMessages()
    }
    
    private func saveAccumulatedMessages() {
        guard let _accumulator = accumulator else { return }
        guard _accumulator.count > 0 else { return }
        
        save(_accumulator)
        accumulator?.removeAll()
    }
    
    private func save(_ messages: [PersistentMessage]) {
        if let lifeTimeInterval = settings.lifeTime {
            let tillDate = Date(timeInterval: -lifeTimeInterval, since: Date())
            persistent.deleteAll(till: tillDate)
        }
        persistent.save(messages)
    }
    
    // MARK: - Output
    
    open override func display<TokenType: Token>(_ message: Message<TokenType>) {
        let persistentMessage =  PersistentMessage(token: message.token.rawValue, tags: message.tags, date: message.date, payload: message.payload)
        if self.accumulator != nil {
            self.accumulator!.append(persistentMessage)
            self.saveAccumulatedMessagesIfNeeded()
        } else {
            self.save([persistentMessage])
        }
    }
    
    // MARK: - CountdownDelegate
    
    func countdownDidFinishLap(_ countdown: Countdown) {
        saveAccumulatedMessages()
    }
}
