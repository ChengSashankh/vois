//
//  LocalStorage.swift
//  Vois
//
//  Created by Jiang Yuxin on 10/4/20.
//  Copyright © 2020 Vois. All rights reserved.
//

import Foundation

class LocalStorage {
    let localStorage: PerformanceFilesDirectory
    let userName: String

    init(userName: String) {
        self.userName = userName
        self.localStorage = PerformanceFilesDirectory(userName: userName)
    }

    private func updateRecordingFiles(_ performances: Performances) {
        let performancesRecordings = performances.allRecordings.map { recording in recording.filePath }
        for recordingUrl in localStorage.getAllRecordingUrls() {
            if !performancesRecordings.contains(recordingUrl) {
                localStorage.removeRecording(at: recordingUrl)
            }
        }
    }

    func update(performances: Performances, updateRecordings: Bool = false) throws {
        try localStorage.savePerformancesFile(with: try performances.encodeToJson())
        if updateRecordings {
            updateRecordingFiles(performances)
        }
    }

}

extension Performances {
    var allRecordings: [Recording] {
        var recordings = [Recording]()
        for performance in self.getPerformances() {
            recordings.append(contentsOf: performance.allRecordings)
        }
        return recordings
    }
}

extension Performance {
    var allRecordings: [Recording] {
        var recordings = [Recording]()
        for song in self.getSongs() {
            recordings.append(contentsOf: song.allRecordings)
        }
        return recordings
    }
}

extension Song {
    var allRecordings: [Recording] {
        var recordings = [Recording]()
        for segment in self.getSegments() {
            recordings.append(contentsOf: segment.getRecordings())
        }
        return recordings
    }
}
