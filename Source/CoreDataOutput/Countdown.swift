//
//  Created by Evgeniy Akhmerov on 16/11/2017.
//  Copyright © 2017 e-Legion. All rights reserved.
//

import Foundation

internal protocol CountdownDelegate: class {
    func countdownDidFinishLap(_ countdown: Countdown)
}

internal class Countdown {
    
    // MARK: - Properties
    
    private let interval: TimeInterval
    private let repeats: Bool
    private var timer: Timer?
    weak var delegate: CountdownDelegate?
    
    // MARK: - Life cycle
    
    init(interval: TimeInterval, repeats: Bool = true) {
        self.interval = interval
        self.repeats = repeats
    }
    
    // MARK: - Public
    
    func activate() {
        timer = Timer.scheduledTimer(timeInterval: interval, target: self, selector: #selector(timerFireMethod(_:)), userInfo: nil, repeats: repeats)
    }
    
    func deactivate() {
        timer?.invalidate()
        timer = nil
    }
    
    // MARK: - Private
    
    @objc private func timerFireMethod(_ timer: Timer) {
        delegate?.countdownDidFinishLap(self)
    }
}
