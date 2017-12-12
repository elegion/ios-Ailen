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
    
    override func setUp() {
        super.setUp()
        
        guard let _core = core else {
            XCTFail("CoreData stack uninitialized")
            return
        }
        
        let settings = DefaultStorage.Settings(autosaveCount: 0)
        output = DefaultStorage(core: _core, settings: settings)
        
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
        
        XCTAssertEqual(_output.filter.data.count, 0)
        
        let logExpectation = expectation(description: "Save data wait")
        
        _logger.log(as: .UI, tags: [.client, .internal], values: Constants.msg)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            XCTAssertEqual(_output.filter.data.count, 1)
            
            let message = _output.filter.data.first!
            
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
