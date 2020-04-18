//
//  StorageObserverDelegate.swift
//  Vois
//
//  Created by Jiang Yuxin on 10/4/20.
//  Copyright © 2020 Vois. All rights reserved.
//

import Foundation

protocol StorageObserverDelegate {
    func update(operation: Operation, object: StorageObservable)
    func generateNewRecordingFilePath() -> URL?
    func removeRecording(at url: URL) -> Bool
    func convertToAbsoluteUrl(url: URL) -> URL
    func convertToRelativeUrl(url: URL) -> URL

    func upload(object: Shareable) -> String
    func read(reference: String, _ completionHandler: (([String: Any]) -> Void)?)

    var finishSetUp: Bool {set get}
}
