//
//  Created by Evgeniy Akhmerov on 30/11/2017.
//  Copyright © 2017 e-Legion. All rights reserved.
//

import Foundation
import Ailen

extension Token {
    static let request = Token(rawValue: "Token.Sample.Request")
    static let response = Token(rawValue: "Token.Sample.Response")
    static let UI = Token(rawValue: "Token.Sample.UI", qos: .main(async: false))
}

extension Tag {
    static let error = Tag(rawValue: "Tag.Sample.Error")
    static let analityc = Tag(rawValue: "Tag.Sample.Analytic")
    static let user = Tag(rawValue: "Tag.Sample.User")
    static let app = Tag(rawValue: "Tag.Sample.Application")
    static let info = Tag(rawValue: "Tag.Sample.Info")
}

struct ErrLog: ErrorLogger {
    func display(_ error: Error) {
        print("ErrorLogger -->> \(error.localizedDescription)")
    }
}
