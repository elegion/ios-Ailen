//
//  Created by Evgeniy Akhmerov on 20/11/2017.
//  Copyright © 2017 e-Legion. All rights reserved.
//

import XCTest
import CoreData
@testable import Ailen

class DefaultDataConverterTests: StorageTestCase {
    
    private struct Constants {
        static let msg = "DefaultDataConverterTests.message"
    }
    
    private var output: DefaultStorage?
    private var logger: Ailen?
    private var persistent: PersistentStoraging!
    override func setUp() {
        super.setUp()
        
        guard let _core = core else {
            XCTFail("CoreData stack uninitialized")
            return
        }
        
        let settings = DefaultStorage.Settings(autosaveCount: 0)
        persistent = AilenPersistentStorage(core: _core)
        output = DefaultStorage(settings: settings, persistent: persistent)
        
        logger = Ailen(outputs: [output!], processors: [])
    }
    
    func testConverting() {
        guard let _logger = logger else {
            XCTFail("Logger uninitialized")
            return
        }
        guard let _output = output else {
            XCTFail("Storage output uninitialized")
            return
        }
        
        guard let _persistent  = persistent else {
            XCTFail("Persistent uninitialized")
            return
        }
        
        XCTAssertEqual(_persistent.filter.data.count, 0)
        
        let logExpectation = expectation(description: "Save data wait")
        
        _logger.log(as: TestToken.UI, tags: [TestTag.client, TestTag.internal], values: Constants.msg)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            XCTAssertEqual(_persistent.filter.data.count, 1)
            
            let message = _persistent.filter.data.first!
            
            XCTAssertEqual(message.token, "UI.Token")
            XCTAssertEqual(message.message, Constants.msg)
            XCTAssertEqual(message.tags.count, 2)
            
            let storedTags = message.tags.sorted()
            let requestedTags = ["Client.Tag", "Internal.Tag"].sorted()
            
            XCTAssertEqual(storedTags, requestedTags)
            
            logExpectation.fulfill()
        }
        
        waitForExpectations(timeout: 10)
    }
}
