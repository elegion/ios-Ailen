//
//  Created by Evgeniy Akhmerov on 08/11/2017.
//  Copyright © 2017 e-Legion. All rights reserved.
//

import Foundation

public typealias Tag = String

public struct LogMessage: Message {
    public let token: Token
    public let tags: [Tag]
    public let payload: String
    
    // MARK: - CustomStringConvertible
    
    public var description: String {
        //TODO:
        return "wat?"
//        return String(format: token.format, arguments: [self])
    }
}

public class AbstractToken: Token {

    // MARK: - Life cycle
    
    public init(name: String, format: String, isOn: Bool = false) {
        self.name = name
        self.format = format
        self.isOn = isOn
    }

    // MARK: - Token
    
    public var name: String
    public var format: String = ""
    public var isOn: Bool = false
}

public class ResponseToken: AbstractToken {
    
    // MARK: - Life cycle
    
    public init() {
        super.init(name: "Response", format: "Response: %@")
    }
}

public class RequestToken: AbstractToken {
    
    // MARK: - Life cycle
    
    public init() {
        super.init(name: "Request", format: "Request: %@")
    }
}

public class ErrorToken: AbstractToken {
    
    // MARK: - Life cycle
    
    public init() {
        super.init(name: "Error", format: "Error: %@")
    }
}

public class WarningToken: AbstractToken {
    
    // MARK: - Life cycle
    
    public init() {
        super.init(name: "Warning", format: "Warning: %@")
    }
}

public class DebugToken: AbstractToken {
    
    // MARK: - Life cycle
    
    public init() {
        super.init(name: "Debug", format: "Debug: %@")
    }
}

public class InfoToken: AbstractToken {
    
    // MARK: - Life cycle
    
    public init() {
        super.init(name: "Info", format: "Info: %@")
    }
}

public class AnalitycToken: AbstractToken {
    
    // MARK: - Life cycle
    
    public init() {
        super.init(name: "Analityc", format: "Analityc: %@")
    }
}

public class StatisticToken: AbstractToken {
    
    // MARK: - Life cycle
    
    public init() {
        super.init(name: "Statistic", format: "Statistic: %@")
    }
}

public class StorageToken: AbstractToken {
    
    // MARK: - Life cycle
    
    public init() {
        super.init(name: "Storage", format: "Storage: %@")
    }
}

public class UIToken: AbstractToken {
    
    // MARK: - Life cycle
    
    public init() {
        super.init(name: "UI", format: "UI: %@")
    }
}
