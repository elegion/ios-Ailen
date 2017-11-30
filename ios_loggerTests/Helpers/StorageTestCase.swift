//
//  Created by Evgeniy Akhmerov on 27/11/2017.
//  Copyright © 2017 e-Legion. All rights reserved.
//

import XCTest
import ios_logger

class StorageTestCase: XCTestCase {
    private struct Constants {
        static let dataStorageName = "com.e-legion.TestingDataStorage"
    }
    
    private var testModelPath: String?
    var core: DefaultStorageCore? {
        guard let modelPath = testModelPath,
            let core = DefaultStorageCore(storeURL: URL(fileURLWithPath: modelPath)) else {
                return nil
        }
        return core
    }
    
    override func setUp() {
        super.setUp()
        
        print(NSTemporaryDirectory())
        cleanStore()
        
        let path = NSTemporaryDirectory().appending(Constants.dataStorageName + ".sqlite")
        if FileManager.default.createFile(atPath: path, contents: nil, attributes: nil) {
            testModelPath = path
        }
    }
    
    override func tearDown() {
        super.tearDown()
        
        cleanStore()
    }
    
    // MARK: - Private
    
    private func cleanStore() {
        /*
        // Logic doesn't work properly. It should be done later.
        let paths = try? FileManager.default.contentsOfDirectory(atPath: NSTemporaryDirectory())
        let mapped = paths?.flatMap({
            guard $0.contains(Constants.dataStorageName) else { return nil }
            return $0
        })
        mapped?.forEach({
            do {
                try FileManager.default.removeItem(at: URL(fileURLWithPath: $0))
            } catch {
                XCTFail(error.localizedDescription)
            }
        })
        */
        
        do {
            let fm = FileManager.default
            let directory = NSTemporaryDirectory()
            
            let items = try fm.contentsOfDirectory(atPath: directory)
            for item in items {
                let path = directory.appending(item)
                try fm.removeItem(atPath: path)
            }
        } catch {
            XCTFail(error.localizedDescription)
        }
        
    }
}
