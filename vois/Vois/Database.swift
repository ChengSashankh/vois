//
//  Database.swift
//  Vois
//
//  Created by Jiang Yuxin on 15/4/20.
//  Copyright © 2020 Vois. All rights reserved.
//

import Foundation

class Database {
    let database = FirestoreAdapter()

    var isConnected: Bool {
        database.isConnected
    }

    func createObject(object: Shareable) -> String {
        let collectionName = getCollectionName(for: object)
        return database.writeObject(inCollection: collectionName, data: object.dictionary)
    }

    func updateObject(object: Shareable) -> String {
        if object.id == nil {
            return createObject(object: object)
        } else {
            return database.updateObject(with: object.id!, newData: object.dictionary)
        }
    }

    func readObject(with id: String, _ completionHandler: (([String: Any]) -> Void)? = nil) {
        database.readObject(with: id, completionHandler)
    }

    func addReferences(from object: Shareable, referenceName: String, to objects: [Shareable]) -> String {
        let id = updateObject(object: object)

        database.readObject(with: id) { oldData in
            guard var references = oldData[referenceName] as? [String] else {
                return
            }

            for index in 0..<objects.count {
                let currentId = self.updateObject(object: objects[index])
                references.append(currentId)
            }

            _ = self.database.updateObject(with: id, newData: [referenceName: references])
        }
        return id
    }

    private func checkReferencesLeft(to object: Shareable, falseHandler: (() -> Void)?) {
        guard let id = object.id else {
            return
        }
        for collection in collectionNames {
            database.readObject(in: collection) { (objects: [[String: Any]]) in
                for index in 0..<objects.count {
                    let currentObject = objects[index]
                    for (_, value) in currentObject {
                        guard let references = value as? [String], references.contains(id) else {
                            continue
                        }
                        return
                    }
                }
                falseHandler?()
            }
        }
    }

    func removeReferences(from object: Shareable, referenceName: String, to objects: [Shareable]) -> String {
        let collectionName = getCollectionName(for: object)
        let id = updateObject(object: object)

        database.readObject(with: id) { oldData in
            guard var references = oldData[referenceName] as? [String] else {
                return
            }

            for index in 0..<objects.count {
                let currentId = self.updateObject(object: objects[index])
                references.removeAll { $0 == currentId }

                self.checkReferencesLeft(to: objects[index]) {
                    _ = self.remove(object: objects[index])
                }
            }
            _ = self.database.updateObject(inCollection: collectionName, withId: id, newData: [referenceName: references])
        }
        return id
    }

    private func removeAllReferences(to object: Shareable) {
        guard let id = object.id else {
            return
        }
        for collection in collectionNames {
            database.readObject(in: collection) { (objects: [[String: Any]]) in
                for index in 0..<objects.count {
                    let currentObject = objects[index]
                    for (key, value) in currentObject {
                        guard var references = value as? [String], references.contains(id),
                            let currentId = currentObject["id"] as? String else {
                            continue
                        }
                        references.removeAll { $0 == id }
                        _ = self.database.updateObject(with: currentId, newData: [key: references])
                    }
                }
            }
        }
    }

    func remove(object: Shareable) -> String {
        guard let id = object.id else {
            return ""
        }
        removeAllReferences(to: object)
        database.deleteObject(with: id)
        return id
    }

    var databaseCopy = [String: [String: Any]]()
    private var setupCompletionHandler: (() -> Void)?

    func setup(_ completionHandler: (() -> Void)? = nil) {
        setupCompletionHandler = completionHandler
        readCollection(at: 0)
    }

    private func readCollection(at index: Int) {
        if index >= collectionNames.count {
            setupCompletionHandler?()
            return
        }
        database.readObject(in: collectionNames[index]) { (documents: ([(String,[String: Any])])) in
            for document in documents {
                self.databaseCopy[document.0] = document.1
            }
            self.readCollection(at: index + 1)
        }
    }

    func clean() {
        for collection in collectionNames {
            database.deleteData(in: collection)
        }
    }

    func initializationReadObject(reference: String) -> [String: Any] {
        databaseCopy[reference] ?? [String: Any]()
    }

    func getUser(email: String, _ completionHandler: ((([String: Any], String)?) -> Void)? = nil) {
        database.query(inCollection: "users", field: "email", whereValueIs: email) {
            completionHandler?($0)
        }
    }

    private var collectionNames = ["users", "performances", "songs", "songSegments", "recordings", "comments"]

    private func getCollectionName(for object: Shareable) -> String {
        switch object {
        case is User:
            return "users"
        case is Performance:
            return "performances"
        case is Song:
            return "songs"
        case is SongSegment:
            return "songSegments"
        case is Recording:
            return "recordings"
        case is Comment:
            return "comments"
        default:
            return ""
        }
    }
}
