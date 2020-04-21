//
//  CloudStorage.swift
//  Vois
//
//  Created by Jiang Yuxin on 16/4/20.
//  Copyright © 2020 Vois. All rights reserved.
//

import Foundation

class CloudStorage: DatabaseObserver {

    private let database = Database()
    private let recordingStorage = RecordingCloudStorage()

    init() {
        database.recordingStorageDelegate = recordingStorage
    }

    func update(operation: Operation, object: Shareable) -> String {
        switch operation {
        case .create:
            return database.createObject(object: object)
        case .update:
            return database.updateObject(object: object)
        case .delete:
            return database.remove(object: object)
        }
    }

    func read(reference: String, _ completionHandler: (([String: Any]) -> Void)? = nil) {
        database.readObject(with: reference, completionHandler)
    }

    func setup(for username: String, email: String, _ completionHandler: ((User) -> Void)?) {
        database.getUser(email: email) { data in
            if let userData = data {
                self.database.setup {
                    if let user = User(dictionary: userData.0, id: userData.1, cloudStorage: self) {
                        completionHandler?(user)
                        return
                    } else {
                        let user = User(username: username, email: email)
                        completionHandler?(user)
                        return
                    }
                }
            } else {
                let user = User(username: username, email: email)
                completionHandler?(user)
            }
        }
    }

    func initializationRead(reference: String) -> [String: Any] {
        return database.initializationReadObject(reference: reference)
    }

    func clean() {
        database.clean()
    }
}
