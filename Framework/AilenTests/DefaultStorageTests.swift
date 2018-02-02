//
//  Created by Evgeniy Akhmerov on 20/11/2017.
//  Copyright © 2017 e-Legion. All rights reserved.
//

import XCTest
import Ailen

class DefaultStorageTests: StorageTestCase {
    
    private typealias InstancesType = (logger: Ailen, storage: DefaultStorage, persistant: PersistentStoraging)
    
    private struct Constants {
        static let autosaveCount = 2
        static let autosaveInterval: TimeInterval = 3
        static let lifeTime: TimeInterval = 10
        static let msg = "DefaultStorageTests.testAutosaveInterval.message"
    }
    
    private enum ConfigType {
        case autosaveCount, autosaveInterval, lifeTime
    }
    
    func testAutosaveCount() {
        let setup = instances(config: .autosaveCount)
        let logger = setup.logger
        //let storage = setup.storage
        let persistant = setup.persistant
        
        let savingExpectation = expectation(description: "Autosave by count wait")
        
        XCTAssertEqual(persistant.filter.data.count, 0)
        
        logger.log(as: TestToken.UI, values: [Constants.msg])
        XCTAssertEqual(persistant.filter.data.count, 0)
        
        logger.log(as: TestToken.error, values: [Constants.msg])
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            XCTAssertEqual(persistant.filter.data.count, 2)
            savingExpectation.fulfill()
        }
        
        waitForExpectations(timeout: 3)
    }
    
    func testAutosaveInterval() {
        let setup = instances(config: .autosaveInterval)
        let logger = setup.logger
        //let storage = setup.storage
        let persistant = setup.persistant
        let autosaveExpectation = expectation(description: "Autosave timer expectation")
        
        XCTAssertEqual(persistant.filter.data.count, 0)
        
        logger.log(as: TestToken.UI, values: [Constants.msg])
        logger.log(as: TestToken.response, values: [Constants.msg])
        XCTAssertEqual(persistant.filter.data.count, 0)
        
        let deadline: DispatchTime = .now() + Constants.autosaveInterval * 2
        DispatchQueue.main.asyncAfter(deadline: deadline) {
            XCTAssertEqual(persistant.filter.data.count, 2)
            autosaveExpectation.fulfill()
        }
        
        waitForExpectations(timeout: Constants.autosaveInterval * 3)
    }
    
    func testlifeTime() {
        let setup = instances(config: .lifeTime)
        let logger = setup.logger
        //let storage = setup.storage
        let persistant = setup.persistant
        
        let lifeTimeExpectation = expectation(description: "Store interval expectation")
        
        XCTAssertEqual(persistant.filter.data.count, 0)
        
        logger.log(as: TestToken.UI, values: [Constants.msg])
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            XCTAssertEqual(persistant.filter.data.count, 1)
            
            let deadline: DispatchTime = .now() + Constants.lifeTime * 2
            DispatchQueue.main.asyncAfter(deadline: deadline) {
                XCTAssertEqual(persistant.filter.data.count, 0)
                lifeTimeExpectation.fulfill()
            }
        }
        
        waitForExpectations(timeout: Constants.lifeTime * 3)
    }
    
    // MARK: - Private
    
    private func instances(config: ConfigType) -> InstancesType {
        let settings: DefaultStorage.Settings
        switch config {
        case .autosaveCount:
            settings = DefaultStorage.Settings(autosaveCount: Constants.autosaveCount)
        case .autosaveInterval:
            settings = DefaultStorage.Settings(autosaveCount: Int.max, autosaveInterval: Constants.autosaveInterval)
        case .lifeTime:
            settings = DefaultStorage.Settings(autosaveCount: 0, lifeTime: Constants.lifeTime)
        }
        
        guard let _persistant = persistant else {
            XCTFail("CoreData stack uninitialized")
            fatalError()
        }
        
        
        
        let storage = DefaultStorage(settings: settings, persistent: _persistant)
        
//        let storage = DefaultStorage(core: _core, settings: settings)
        return (Ailen(outputs: [storage]), storage, _persistant)
    }
}
