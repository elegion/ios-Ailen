//
//  Created by Evgeniy Akhmerov on 20/11/2017.
//  Copyright © 2017 e-Legion. All rights reserved.
//

import XCTest
import ios_logger

class DebugProcessorTests: XCTestCase {
    
    let processor = DebugProcessor()
    
    func testObjectRepresentation() {
        let source = "Pharetra Tortor Lorem"
        guard let processed = processor.process(token: .response, object: source) else {
            XCTFail("DebugProcessor did fail proccessing for \(type(of: source))")
            return
            
        }
        XCTAssertEqual(source, processed)
    }

    func testPrimitiveRepresentation() {
        let source = 154
        guard let processed = processor.process(token: .response, object: source) else {
            XCTFail("DebugProcessor did fail proccessing for \(type(of: source))")
            return
            
        }
        XCTAssertEqual("154", processed)
    }
}
