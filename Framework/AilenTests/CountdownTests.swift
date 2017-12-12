//
//  Created by Evgeniy Akhmerov on 20/11/2017.
//  Copyright © 2017 e-Legion. All rights reserved.
//

import XCTest
@testable import Ailen

class CountdownTests: XCTestCase {
    
    private struct Constants {
        static let defaultInterval: TimeInterval = 2
        static let multipleLapsCount = 5
    }
    
    private class Destination: CountdownDelegate {
        var didFinishLap: (() -> Void)?
        
        func countdownDidFinishLap(_ countdown: Countdown) {
            didFinishLap?()
        }
    }
    
    private let delegate = Destination()
    
    func testSingleLap() {
        var counter = 0
        
        delegate.didFinishLap = {
            counter += 1
        }
        
        let lapsExpectation = expectation(description: "SingleLap.Measurement")
        let timer = Countdown(interval: Constants.defaultInterval, repeats: false)
        timer.delegate = delegate
        timer.activate()
        
        let timeout: TimeInterval = Constants.defaultInterval * TimeInterval(Constants.multipleLapsCount)
        let deadline = DispatchTime.now() + timeout
        
        DispatchQueue.main.asyncAfter(deadline: deadline) {
            lapsExpectation.fulfill()
        }
        
        waitForExpectations(timeout: Constants.defaultInterval * TimeInterval(Constants.multipleLapsCount))
        XCTAssertEqual(counter, 1)
        
        timer.deactivate()
        delegate.didFinishLap = nil
    }
    
    func testMultipleLaps() {
        var counter = 0
        
        delegate.didFinishLap = {
            DispatchQueue.main.async {
                counter += 1
            }
        }
        
        let lapsExpectation = expectation(description: "MultipleLaps.Measurement")
        let timer = Countdown(interval: Constants.defaultInterval)
        timer.delegate = delegate
        timer.activate()
        
        XCTAssertEqual(counter, 0)
        
        let fullCycle = Constants.defaultInterval * TimeInterval(Constants.multipleLapsCount) * 1.1
        let timeout: TimeInterval = fullCycle * 2
        
        DispatchQueue.main.asyncAfter(deadline: .now() + fullCycle) {
            XCTAssertEqual(counter, Constants.multipleLapsCount)
            lapsExpectation.fulfill()
            
            timer.deactivate()
            self.delegate.didFinishLap = nil
        }
        
        waitForExpectations(timeout: timeout)
    }
}
