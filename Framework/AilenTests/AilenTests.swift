//
//  Created by Evgeniy Akhmerov on 20/11/2017.
//  Copyright © 2017 e-Legion. All rights reserved.
//

import XCTest
@testable import Ailen

class AilenTests: XCTestCase {
    
    private struct Constants {
        static let msg = "Mock testing string"
    }
    
    private var logger: Ailen?
    
    override func setUp() {
        super.setUp()
        
        logger = Ailen()
    }
    
    override func tearDown() {
        super.tearDown()
        
        logger = nil
    }
    
    func testDefaultOutput() {
        guard let logger = logger else {
            XCTFail("Logger uninitialized")
            return
        }
        
        XCTAssertEqual(logger.outputs.count, 1)
        
        let newOutput = ConsoleOutput()
        logger.outputs = [newOutput]
        
        XCTAssertEqual(logger.outputs.count, 1)
        
        logger.outputs.removeAll()
        
        XCTAssertEqual(logger.outputs.count, 0)
    }
    
//    func testDefaultProcessor() {
//        guard let logger = logger else {
//            XCTFail("Logger uninitialized")
//            return
//        }
//        
//        let logExpectation = expectation(description: "Async logging wait")
//        
//        let output = TestingDefaultOutput()
//        logger.outputs = [output]
//        
//        logger.log(as: TestToken.UI, values: [Constants.msg])
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//            XCTAssertEqual(logger.processors.count, 0)
//            XCTAssertEqual(output.messagesDisplayed, 1)
//            
//            let processor = TestingProcessor()
//            logger.processors = [processor]
//            
//            logger.log(as: TestToken.UI, values: [Constants.msg])
//            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//                XCTAssertEqual(logger.processors.count, 1)
//                XCTAssertEqual(output.messagesDisplayed, 2)
//                
//                logger.processors.removeAll()
//                
//                logger.log(as: TestToken.UI, values: [Constants.msg])
//                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//                    XCTAssertEqual(logger.processors.count, 0)
//                    XCTAssertEqual(output.messagesDisplayed, 3)
//                    logExpectation.fulfill()
//                }
//            }
//        }
//        
//        waitForExpectations(timeout: 10)
//    }
}
