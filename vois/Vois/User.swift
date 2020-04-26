//
//  User.swift
//  Vois
//
//  Created by Tan Yong He on 28/3/20.
//  Copyright © 2020 Vois. All rights reserved.
//

import Foundation

class User: StorageObserverDelegate, Shareable {

    var id: String?

    var username: String
    var email: String
    var performances: Performances
    var invitedPerfs: Performances
    var localStorageObserver: LocalStorage
    var cloudStorageObserver: CloudStorage

    init(username: String, email: String) {
        self.username = username
        self.email = email
        self.localStorageObserver = LocalStorage(userName: username)
        self.cloudStorageObserver = CloudStorage()
        self.performances = localStorageObserver.initializeModel()
        self.invitedPerfs = Performances()
        self.invitedPerfs.storageObserverDelegate = self
        self.performances.storageObserverDelegate = self
        _ = upload()
    }

    init?(dictionary: [String: Any], id: String, cloudStorage: CloudStorage) {
        guard let username = dictionary["username"] as? String,
            let email = dictionary["email"] as? String,
            let performancesReferences = dictionary["performances"] as? [String] else {
                return nil
        }
        self.username = username
        self.email = email
        self.id = id
        self.localStorageObserver = LocalStorage(userName: username)
        let performancesList = performancesReferences.compactMap {
            Performance(reference: $0, storageObserverDelegate: cloudStorage)
        }
        self.performances = Performances(performancesList)
        self.cloudStorageObserver = cloudStorage
        self.invitedPerfs = Performances()
        self.invitedPerfs.storageObserverDelegate = self
        self.performances.storageObserverDelegate = self
        try? localStorageObserver.update(performances: performances, updateRecordings: true)
    }

    convenience init(email: String) {
        self.init(username: email, email: email)
    }

    func generateNewRecordingFilePath() -> URL? {
        localStorageObserver.generateRecordingUrl()
    }

    func removeRecording(at url: URL) -> Bool {
        do {
            try localStorageObserver.removeRecording(at: url)
            return true
        } catch {
            return false
        }
    }

    func convertToAbsoluteUrl(url: URL) -> URL {
        localStorageObserver.convertToAbsoluteUrl(url: url)
    }

    func convertToRelativeUrl(url: URL) -> URL {
        localStorageObserver.convertToRelativeUrl(url: url)
    }

    private func updatePerformances() {
         _ = cloudStorageObserver.update(operation: .update, object: self)
    }

    func update(operation: Operation, object: StorageObservable) {
        if let shareableObject = object as? Shareable {
            _ = cloudStorageObserver.update(operation: operation, object: shareableObject)
        }
        if object is Performances || object is Performance {
            updatePerformances()
        }
        try? localStorageObserver.update(performances: performances)
    }

    func upload(object: Shareable) -> String {
        return cloudStorageObserver.update(operation: .update, object: object)
    }

    func upload() -> String? {
        id = cloudStorageObserver.update(operation: .update, object: self)
        return id
    }

    func read(reference: String, _ completionHandler: (([String: Any]) -> Void)? = nil) {
        cloudStorageObserver.read(reference: reference, completionHandler)
    }

    var dictionary: [String: Any] {
        ["username": username,
         "email": email,
         "performances":
            performances.getPerformances().compactMap { $0.upload() }]
    }

    private let performancesReference = "performances"

    func download(recording: Recording, successHandler: (() -> Void)? = nil, failureHandler: (() -> Void)? = nil) {
        cloudStorageObserver.download(recording: recording, successHandler: successHandler, failureHandler: failureHandler)
    }
}
