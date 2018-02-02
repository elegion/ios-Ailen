//
//  Created by Evgeniy Akhmerov on 20/11/2017.
//  Copyright © 2017 e-Legion. All rights reserved.
//

import XCTest
import Ailen

class FilterStoreTests: XCTestCase {
    
    private struct Constants {
        enum Message: String {
            case msg1 = "UnitTest.FilterStoreTests.msg1"
            case msg2 = "UnitTest.FilterStoreTests.msg2"
            case msg3 = "UnitTest.FilterStoreTests.msg3"
            case msg4 = "UnitTest.FilterStoreTests.msg4"
            case msg5 = "UnitTest.FilterStoreTests.msg5"
        }
    }
    
    var store: FilterStore!
    
    override func setUp() {
        super.setUp()
        
        let now = Date()
        let hourBefore = Date(timeInterval: -(60 * 60), since: now)
        let fourHoursBefore = Date(timeInterval: -(60 * 60 * 4), since: now)
        
        let tagSet1 = [TestTag.client.rawValue, TestTag.response.rawValue]
        let tagSet2 = [TestTag.internal.rawValue, TestTag.client.rawValue]
        let tagSet3 = [TestTag.server.rawValue]
        let emptyTagSet = [String]()
        
        let msg1: FilterStore.Message = (tagSet1, TestToken.response.rawValue, fourHoursBefore, Constants.Message.msg1.rawValue)
        let msg2: FilterStore.Message = (tagSet3, TestToken.response.rawValue, fourHoursBefore, Constants.Message.msg2.rawValue)
        let msg3: FilterStore.Message = (tagSet2, TestToken.UI.rawValue, hourBefore, Constants.Message.msg3.rawValue)
        let msg4: FilterStore.Message = (tagSet1, TestToken.error.rawValue, now, Constants.Message.msg4.rawValue)
        let msg5: FilterStore.Message = (emptyTagSet, TestToken.UI.rawValue, now, Constants.Message.msg5.rawValue)
        
        store = FilterStore(data: [msg1, msg2, msg3, msg4, msg5])
    }
    
    func testFiltering() {
        XCTAssertFalse(store.data.isEmpty)
        
        let responseStore = store.containing(tag: TestTag.response.rawValue)
        XCTAssertEqual(responseStore.data.count, 2)

        let clientStore = store.containing(tag: TestTag.client.rawValue)
        XCTAssertEqual(clientStore.data.count, 3)
        
        let fakeTagStore = store.containing(tag: TestTag.fake.rawValue)
        XCTAssertEqual(fakeTagStore.data.count, 0)
        
        let emptyTagStore = store.containing(tag: "")
        XCTAssertEqual(emptyTagStore.data.count, 5)
    }
}
