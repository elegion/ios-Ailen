//
//  Created by Evgeniy Akhmerov on 08/11/2017.
//  Copyright © 2017 e-Legion. All rights reserved.
//

import Foundation
import CoreData

//public class DefaultStorage: Storaging {
//
//    // MARK: - Definitions
//
//    private struct Consts {
//        static let messageEntityName = "DBMessage"
//        static let tokenEntityName = "DBToken"
//        static let tagEntityName = "DBTag"
//    }
//
//    enum StorageError: Error {
//        case pullLogsFileCreation(String)
//        case tokenUniquenessLost
//        case tagUniquenessLost
//
//        var localizedDescription: String {
//            switch self {
//            case .pullLogsFileCreation(let path):   return "Can't create file at \(path)"
//            case .tokenUniquenessLost:              return "There are non unique token in data base"
//            case .tagUniquenessLost:                return "There are non unique tag in data base"
//            }
//        }
//    }
//
//    // MARK: - Properties
//
//    private let configuration: MultipleContextsStorageConfiguration
//
//    // MARK: - Life cycle
//
//    public init(configuration: MultipleContextsStorageConfiguration) {
//        self.configuration = configuration
//    }
//
//    // MARK: - Public
//
//    public func pullLogs(to filePath: String, filter: ((Message) -> Bool)? = nil) throws {
//        let pulledMessages: [Message]
//        if let _filter = filter {
//            pulledMessages = messages().filter(_filter)
//        } else {
//            pulledMessages = messages()
//        }
//
//        let fileData = Data(pulledMessages.flatMap { $0.description.data(using: .utf8) }.joined())
//        guard FileManager.default.createFile(atPath: filePath, contents: fileData, attributes: nil) else {
//            throw StorageError.pullLogsFileCreation(filePath)
//        }
//    }
//
//    // MARK: - Private
//
//    private func save(_ token: Token) {
//        let dbToken = NSEntityDescription.insertNewObject(forEntityName: Consts.tokenEntityName, into: configuration.writeManagedObjectContext) as! DBToken
//        dbToken.name = token.name
//        dbToken.format = token.format
//        configuration.saveContext()
//    }
//
//    private func save(_ tags: [Tag]) {
//        tags.forEach {
//            [weak self] (tag) in
//            guard let sSelf = self else { return }
//
//            let dbTag = NSEntityDescription.insertNewObject(forEntityName: Consts.tagEntityName, into: sSelf.configuration.writeManagedObjectContext) as! DBTag
//            dbTag.name = tag
//        }
//
//        configuration.saveContext()
//    }
//
//    private func fetch<ResultType: NSFetchRequestResult>(entityName: String, predicate: NSPredicate) throws -> [ResultType] {
//        let request = NSFetchRequest<ResultType>(entityName: entityName)
//        request.predicate = predicate
//        return try configuration.readManagedObjectContext.fetch(request)
//    }
//
//    private func fetchTokens(with names: [String]) throws -> [DBToken] {
//        return try fetch(entityName: Consts.tokenEntityName, predicate: NSPredicate(format: "name IN %@", names))
//    }
//
//    private func fetchTags(with names: [String]) throws -> [DBTag] {
//        return try fetch(entityName: Consts.tagEntityName, predicate: NSPredicate(format: "name IN %@", names))
//    }
//
//    private func save(_ message: Message) {
//        //TODO: это нужно оптимизировать!!!
//
//        save(message.token)
//        save(message.tags)
//
//        do {
//            let tokens = try fetchTokens(with: [message.token.name])
//            let tags = try fetchTags(with: message.tags)
//            let dbMessage = NSEntityDescription.insertNewObject(forEntityName: Consts.messageEntityName, into: configuration.writeManagedObjectContext) as! DBMessage
//            dbMessage.token = tokens.first!
//            dbMessage.tags = Set(tags) as NSSet
//            dbMessage.payload = message.payload
//            configuration.saveContext()
//        } catch {
//            fatalError(error.localizedDescription)
//        }
//    }
//
//    // MARK: - Storaging
//
//    public func save(_ messages: [Message]) {
//        messages.forEach { save($0) }
//    }
//
//    func messages() -> [Message] {
//        return messages(for: [], with: [])
//    }
//
//    public func messages(for tokens: [Token]) -> [Message] {
//        return messages(for: tokens, with: [])
//    }
//
//    public func messages(with tags: [Tag]) -> [Message] {
//        return messages(for: [], with: tags)
//    }
//
//    public func messages(for tokens: [Token], with tags: [Tag]) -> [Message] {
//        let request = NSFetchRequest<DBMessage>(entityName: Consts.messageEntityName)
//        let predicate: NSPredicate?
//
//        let tokenNames = tokens.map { $0.name }
//
//        switch (tokens.count, tags.count) {
//        case (_, 0):
//            predicate = NSPredicate(format: "token.name IN %@", tokenNames)
//        case (0, _):
//            predicate = NSPredicate(format: "tags IN %@", tags)
//        case (0, 0):
//            predicate = nil
//        default:
//            predicate = NSPredicate(format: "token.name in %@ AND tags IN %@", tokenNames, tags)
//        }
//
//        do {
//            let result = try configuration.managedObjectContext.fetch(request)
//            request.predicate = predicate
//            return result.map({ LogMessage(from: $0) })
//        } catch {
//            fatalError(error.localizedDescription)
//        }
//    }
//}
//
//fileprivate struct LogToken: Token {
//    var name: String
//    var format: String
//    var isOn: Bool
//
//    init(from source: DBToken) {
//        self.name = source.name!
//        self.format = source.format!
//        self.isOn = false
//    }
//}
//
//fileprivate extension LogMessage {
//    init(from source: DBMessage) {
//        self.token = LogToken(from: source.token!)
//        self.tags = (source.tags?.allObjects as? [Tag]) ?? [Tag]()
//        self.payload = source.payload!
//    }
//}

