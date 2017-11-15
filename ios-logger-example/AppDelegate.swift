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
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
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
        
        return true
    }
}
