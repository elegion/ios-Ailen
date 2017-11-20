//
//  Created by Evgeniy Akhmerov on 20/11/2017.
//  Copyright © 2017 e-Legion. All rights reserved.
//

import XCTest
import ios_logger

class FilterStoreTests: XCTestCase {
    
    private struct Constants {
        enum Token: String {
            case token1 = "UnitTest.FilterStoreTests.token1"
            case token2 = "UnitTest.FilterStoreTests.token2"
        }

        enum Tag: String {
            case tag1 = "UnitTest.FilterStoreTests.tag1"
            case tag2 = "UnitTest.FilterStoreTests.tag2"
            case tag3 = "UnitTest.FilterStoreTests.tag3"
            case tag4 = "UnitTest.FilterStoreTests.tag4"
            case tag5 = "UnitTest.FilterStoreTests.tag5"
        }
        
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
        
        let tagSet1 = [Constants.Tag.tag4.rawValue, Constants.Tag.tag5.rawValue]
        let tagSet2 = [Constants.Tag.tag2.rawValue, Constants.Tag.tag5.rawValue, Constants.Tag.tag1.rawValue]
        let tagSet3 = [Constants.Tag.tag4.rawValue]
        let emptyTagSet = [String]()
        
        let msg1: FilterStore.Message = (tagSet2, Constants.Token.token2.rawValue, fourHoursBefore, Constants.Message.msg1.rawValue)
        let msg2: FilterStore.Message = (tagSet3, Constants.Token.token2.rawValue, fourHoursBefore, Constants.Message.msg2.rawValue)
        let msg3: FilterStore.Message = (tagSet2, Constants.Token.token1.rawValue, hourBefore, Constants.Message.msg3.rawValue)
        let msg4: FilterStore.Message = (tagSet1, Constants.Token.token2.rawValue, now, Constants.Message.msg4.rawValue)
        let msg5: FilterStore.Message = (emptyTagSet, Constants.Token.token1.rawValue, now, Constants.Message.msg5.rawValue)
        
        store = FilterStore(data: [msg1, msg2, msg3, msg4, msg5])
    }
    
    func testFiltering() {
        XCTAssertFalse(store.data.isEmpty)
        
        let tag2Store = store.containing(tag: Constants.Tag.tag2.rawValue)
        XCTAssertEqual(tag2Store.data.count, 2)

        let tag5Store = store.containing(tag: Constants.Tag.tag5.rawValue)
        XCTAssertEqual(tag5Store.data.count, 3)

        let tag3Store = store.containing(tag: Constants.Tag.tag3.rawValue)
        XCTAssertEqual(tag3Store.data.count, 0)
    }
}
