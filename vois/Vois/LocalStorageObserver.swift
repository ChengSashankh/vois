//
//  LocalStorage.swift
//  Vois
//
//  Created by Jiang Yuxin on 10/4/20.
//  Copyright © 2020 Vois. All rights reserved.
//

import Foundation

class LocalStorage: LocalStorageObserver {
    let localStorage: PerformanceFilesDirectory
    let recordingStorage: RecordingStorage
    let userName: String
    let database = FirestoreAdapter()

    init(userName: String) {
        self.userName = userName
        self.localStorage = PerformanceFilesDirectory(userName: userName)
        self.recordingStorage = RecordingStorage(userName: userName)
    }

    private func updateRecordingFiles(_ performances: Performances) {
        let performancesRecordings = performances.allRecordings.map { recording in recording.filePath }
        recordingStorage.cleanUpRecordingsAccordingTo(data: performancesRecordings)
    }

    func update(performances: Performances, updateRecordings: Bool = false) throws {
        try localStorage.savePerformancesFile(with: try performances.encodeToJson())
        if updateRecordings {
            updateRecordingFiles(performances)
        }
    }

    func generateRecordingUrl() -> URL? {
        recordingStorage.getNewRecordingFilePath()
    }

    func removeRecording(at url: URL) throws {
        try recordingStorage.removeRecording(at: url)
    }

    func initializeModel() -> Performances {
        guard let data = localStorage.getPerformancesFile() else {
            return Performances()
        }
        let performances = Performances(json: data) ?? Performances()
        return performances
    }

    func convertToRelativeUrl(url: URL) -> URL {
        recordingStorage.convertToRelativeUrl(url: url)
    }

    func convertToAbsoluteUrl(url: URL) -> URL {
        recordingStorage.convertToAbsoluteUrl(url: url)
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
            recordings.append(contentsOf: segment.allRecordings)
        }
        return recordings
    }
}

extension SongSegment {
    var allRecordings: [Recording] {
        var allRecordings = [Recording]()
        for recording in self.getRecordings() {
            allRecordings.append(recording)
            allRecordings.append(contentsOf: recording.getAudioComments())
        }
        return allRecordings
    }
}
