//
//  Created by Evgeniy Akhmerov on 15/11/2017.
//  Copyright © 2017 e-Legion. All rights reserved.
//

import UIKit
import ios_logger

class MyProcessor: Processor {
    func process(token: Token, object: Any) -> String? {
        return "Wow..."
    }
}

class MyOutput: Output {
    func set(enabled: Bool, for token: Token) {
        // nothing
    }
    
    func display(_ message: Message) {
        print(message.payload)
    }
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var logger: Ailen?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        if let core = DefaultStorageCore(dataModelName: "com.e-legion.DefaultStorageDataModel") {
            let settings = DefaultStorage.Settings(autosaveCount: 0, autosaveInterval: 1, storeInterval: nil)
            let coreDataOutput = DefaultStorage(core: core, settings: settings)
            let consoleOutput = DefaultOutput()
            logger = Ailen()
            logger!.outputs = [coreDataOutput, consoleOutput]
            
            let token = Token(rawValue: "SomeToken")!
            let tag1 = Tag(rawValue: "SomeTag1")!
            let tag2 = Tag(rawValue: "SomeTag2")!
            
            let msg1 = "Praesent commodo cursus magna, vel scelerisque nisl consectetur et. Sed posuere consectetur est at lobortis."
            let msg2 = "Risus Justo Amet"
            
            logger!.log(as: token, tags: [tag1, tag2], values: msg1, msg2)
            logger!.log(as: token, tags: [tag1, tag2], values: msg1, msg2)
            logger!.log(as: token, tags: [tag1, tag2], values: msg1, msg2)
            logger!.log(as: token, tags: [tag1, tag2], values: msg1, msg2)
            logger!.log(as: token, tags: [tag1, tag2], values: msg1, msg2)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 5, execute: {
                print("Hey there..")
                display(coreDataOutput.filter)
            })
        }
        
        
        return true
    }
}

func display(_ filtered: FilterStore) {
    print(filtered.data)
}

func versionOne() {
    let logQueue = DispatchQueue(label: "com.e-legion.logger.example.queue")
    let strings = "Condimentum Sem Inceptos Tristique Euismod".components(separatedBy: " ")
    
    var token = Token(rawValue: "Info Strings")!
    token.qos = .custom(logQueue)
    
    let logger = Ailen()
    
    //        let out = MyOutput()
    //        logger.outputs = [out]
    
    var count = 2
    while count > 0 {
        logger.log(as: token, tags: [.response], values: strings)
        count -= 1
    }
}
