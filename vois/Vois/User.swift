//
//  User.swift
//  Vois
//
//  Created by Tan Yong He on 28/3/20.
//  Copyright © 2020 Vois. All rights reserved.
//

import Foundation

class User: StorageObserverDelegate {
    var username: String
    var email: String
    var performances: Performances
    var invitedPerfs: Performances
    var localStorageObserver: LocalStorageObserver

    init(username: String, email: String) {
        self.username = username
        self.email = email
        self.localStorageObserver = LocalStorageObserver(userName: username)
        self.performances = localStorageObserver.initializeModel()
        self.invitedPerfs = Performances()
        performances.storageObserverDelegate = self
        invitedPerfs.storageObserverDelegate = self
    }

    convenience init(email: String) {
        self.init(username: email, email: email)
    }

    func update(updateRecordings: Bool) {
        try? localStorageObserver.update(performances: performances, updateRecordings: updateRecordings)
        //try? localStorageObserver.update(performances: invitedPerfs, updateRecordings: updateRecordings)
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
}
