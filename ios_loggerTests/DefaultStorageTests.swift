//
//  Created by Evgeniy Akhmerov on 20/11/2017.
//  Copyright © 2017 e-Legion. All rights reserved.
//

import XCTest
import ios_logger

class DefaultStorageTests: StorageTestCase {
    
    private typealias InstancesType = (logger: Ailen, storage: DefaultStorage)
    
    private struct Constants {
        static let autosaveCount = 2
        static let autosaveInterval: TimeInterval = 3
        static let storeInterval: TimeInterval = 10
        static let msg = "DefaultStorageTests.testAutosaveInterval.message"
    }
    
    private enum ConfigType {
        case autosaveCount, autosaveInterval, storeInterval
    }
    
    func testAutosaveCount() {
        let setup = instances(config: .autosaveCount)
        let logger = setup.logger
        let storage = setup.storage
        
        let savingExpectation = expectation(description: "Autosave by count wait")
        
        XCTAssertEqual(storage.filter.data.count, 0)
        
        logger.log(as: .UI, values: [Constants.msg])
        XCTAssertEqual(storage.filter.data.count, 0)
        
        logger.log(as: .error, values: [Constants.msg])
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            XCTAssertEqual(storage.filter.data.count, 2)
            savingExpectation.fulfill()
        }
        wait(for: [savingExpectation], timeout: 3)
    }
    
    func testAutosaveInterval() {
        let setup = instances(config: .autosaveInterval)
        let logger = setup.logger
        let storage = setup.storage
        
        let autosaveExpectation = expectation(description: "Autosave timer expectation")
        
        XCTAssertEqual(storage.filter.data.count, 0)
        
        logger.log(as: .UI, values: [Constants.msg])
        logger.log(as: .response, values: [Constants.msg])
        XCTAssertEqual(storage.filter.data.count, 0)
        
        let deadline: DispatchTime = .now() + Constants.autosaveInterval * 2
        DispatchQueue.main.asyncAfter(deadline: deadline) {
            XCTAssertEqual(storage.filter.data.count, 2)
            autosaveExpectation.fulfill()
        }
        
        wait(for: [autosaveExpectation], timeout: Constants.autosaveInterval * 3)
    }
    
    func testStoreInterval() {
        let setup = instances(config: .storeInterval)
        let logger = setup.logger
        let storage = setup.storage
        
        let storeIntervalExpectation = expectation(description: "Store interval expectation")
        
        XCTAssertEqual(storage.filter.data.count, 0)
        
        logger.log(as: .UI, values: [Constants.msg])
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            XCTAssertEqual(storage.filter.data.count, 1)
            
            let deadline: DispatchTime = .now() + Constants.storeInterval * 2
            DispatchQueue.main.asyncAfter(deadline: deadline) {
                XCTAssertEqual(storage.filter.data.count, 0)
                storeIntervalExpectation.fulfill()
            }
        }
        
        wait(for: [storeIntervalExpectation], timeout: Constants.storeInterval * 3)
    }
    
    // MARK: - Private
    
    private func instances(config: ConfigType) -> InstancesType {
        let settings: DefaultStorage.Settings
        switch config {
        case .autosaveCount:
            settings = DefaultStorage.Settings(autosaveCount: Constants.autosaveCount)
        case .autosaveInterval:
            settings = DefaultStorage.Settings(autosaveCount: Int.max, autosaveInterval: Constants.autosaveInterval)
        case .storeInterval:
            settings = DefaultStorage.Settings(autosaveCount: 0, storeInterval: Constants.storeInterval)
        }
        
        guard let _core = core else {
            XCTFail("CoreData stack uninitialized")
            fatalError()
        }
        
        let storage = DefaultStorage(core: _core, settings: settings)
        return (Ailen(outputs: [storage]), storage)
    }
}
