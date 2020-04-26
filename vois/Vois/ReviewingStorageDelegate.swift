//
//  ReviewingStorageDelegate.swift
//  Vois
//
//  Created by Jiang Yuxin on 25/4/20.
//  Copyright © 2020 Vois. All rights reserved.
//

import Foundation

class ReviewingStorageDelegate: StorageObserverDelegate {

    let cloudStorageObserver: CloudStorage
    let localStorageObserver: LocalStorage

    init(reviewer: User, cloudStorage: CloudStorage) {
        self.cloudStorageObserver = cloudStorage
        self.localStorageObserver = LocalStorage(userName: reviewer.username)
    }

    func update(operation: Operation, object: StorageObservable) {
        guard let shareableObject = object as? Shareable else {
            return
        }
        cloudStorageObserver.update(operation: operation, object: shareableObject)
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

    func upload(object: Shareable) -> String {
        return cloudStorageObserver.update(operation: .update, object: object)
    }

    func read(reference: String, _ completionHandler: (([String : Any]) -> Void)?) {
        cloudStorageObserver.read(reference: reference, completionHandler)
    }

    func download(recording: Recording, successHandler: (() -> Void)?, failureHandler: (() -> Void)?) {
        cloudStorageObserver.download(recording: recording, successHandler: successHandler, failureHandler: failureHandler)
    }


}
