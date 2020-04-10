//
//  StorageObserverDelegate.swift
//  Vois
//
//  Created by Jiang Yuxin on 10/4/20.
//  Copyright © 2020 Vois. All rights reserved.
//

import Foundation

protocol StorageObserverDelegate {
    func update(updateRecordings: Bool)
    func generateNewRecordingFilePath() -> URL?
    func removeRecording(at url: URL) -> Bool
}
