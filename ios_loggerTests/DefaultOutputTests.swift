//
//  Created by Evgeniy Akhmerov on 20/11/2017.
//  Copyright © 2017 e-Legion. All rights reserved.
//

import XCTest
@testable import ios_logger

class DefaultOutputTests: XCTestCase {
    
    private struct InnerMessage: Message {
        let token: Token
        let tags: [Tag]
        let payload: String
    }
        
    private struct Constants {
        enum Message: String {
            case msg1 = "UnitTest.DefaultOutputTests.msg1"
            case msg2 = "UnitTest.DefaultOutputTests.msg2"
            case msg3 = "UnitTest.DefaultOutputTests.msg3"
            case msg4 = "UnitTest.DefaultOutputTests.msg4"
            case msg5 = "UnitTest.DefaultOutputTests.msg5"
        }
    }
    
    private var messages = [Message]()
    
    override func setUp() {
        super.setUp()
        
        let msg1 = InnerMessage(token: .request, tags: [], payload: Constants.Message.msg1.rawValue)
        let msg2 = InnerMessage(token: .response, tags: [], payload: Constants.Message.msg2.rawValue)
        let msg3 = InnerMessage(token: .request, tags: [], payload: Constants.Message.msg3.rawValue)
        let msg4 = InnerMessage(token: .UI, tags: [], payload: Constants.Message.msg4.rawValue)
        let msg5 = InnerMessage(token: .error, tags: [], payload: Constants.Message.msg5.rawValue)
        
        messages = [msg1, msg2, msg3, msg4, msg5]
    }
    
    func testFullDisplaying() {
        let logExpectation = expectation(description: "Messages displaying expectation")
        
        let output = TestingDefaultOutput()
        
        messages.forEach { output.display($0) }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            XCTAssertEqual(output.messagesDisplayed, self.messages.count)
            logExpectation.fulfill()
        }
        
        wait(for: [logExpectation], timeout: 10)
    }
    
    func testBlockingMessages() {
        let logExpectation = expectation(description: "Messages displaying expectation")
        
        let output = TestingDefaultOutput()
        output.set(enabled: false, for: .request)
        
        messages.forEach { output.display($0) }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            XCTAssertEqual(output.messagesDisplayed, self.messages.count - 2)
            logExpectation.fulfill()
        }
        
        wait(for: [logExpectation], timeout: 10)
    }
}
