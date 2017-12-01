//
//  Created by Evgeniy Akhmerov on 30/11/2017.
//  Copyright © 2017 e-Legion. All rights reserved.
//

import UIKit
import ios_logger

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var logger: Ailen?
    let errorLogger: ErrorLogger = ErrLog()
    
    // MARK: - Private
    
    private func display(_ filtered: FilterStore) {
        if filtered.data.count == 0 {
            print("No data fetched.")
        } else {
            filtered.data.forEach({ print("Token: \($0.token) | Tags: \($0.tags) | Message: \($0.message)") })
        }
    }
    
    // MARK: - UIApplicationDelegate
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        guard let core = DefaultStorageCore() else { fatalError() }
        
        let settings = DefaultStorage.Settings(autosaveCount: 2)
        let coreDataOutput = DefaultStorage(core: core, settings: settings)
        core.errorLogger = errorLogger
        let consoleOutput = DefaultOutput()
        logger = Ailen()
        logger!.outputs = [coreDataOutput, consoleOutput]
        
        logger!.log(as: .request, tags: [.error, .analityc, .app], values: "один", "два")
        logger!.log(as: .response, tags: [.response, .info], values: "три", "четыре", "пять")
        logger!.log(as: .response, tags: [.analityc, .user], values: "шесть")
        logger!.log(as: .UI, values: "семь", "восемь", "девять")
        logger!.log(as: .request, tags: [.app, .error], values: "десять")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5, execute: {
            self.display(coreDataOutput.filter)
        })
        
        return true
    }
}
