//
//  Created by Evgeniy Akhmerov on 20/11/2017.
//  Copyright © 2017 e-Legion. All rights reserved.
//

import XCTest
@testable import Ailen

class DefaultTokenBlockerTests: XCTestCase {
    
    private let blocker = DefaultTokenBlocker()
    
    func testBlocking() {
        let token = Token.request
        
        XCTAssertFalse(blocker.isLocked(token: token))
        
        blocker.lock(token: token)
        
        XCTAssertTrue(blocker.isLocked(token: token))
        
        blocker.unlock(token: token)
        
        XCTAssertFalse(blocker.isLocked(token: token))
    }
}
