//
//  SongSegment.swift
//  Vois
//
//  Created by Tan Yong He on 14/3/20.
//  Copyright © 2020 Vois. All rights reserved.
//

import Foundation

class SongSegment: Equatable, Codable, Serializable {
    private var recordings: [Recording]
    var name: String
    var id: String

    var storageObserverDelegate: StorageObserverDelegate?

    private enum CodingKeys: String, CodingKey {
        case recordings, name, id
    }

    var hasNoRecordings: Bool {
        return recordings.isEmpty
    }

    var numOfRecordings: Int {
        return recordings.count
    }

    var dictionary: [String: Any] {
        return [
            "recordings": recordings,
            "name": name,
            "id": id
        ]
    }

    init (name: String) {
        self.name = name
        self.recordings = []
        id = UUID().uuidString
    }

    func addRecording(recording: Recording) {
        self.recordings.append(recording)
        storageObserverDelegate?.update(updateRecordings: true)
    }

    func updateRecording(oldRecording: Recording, newRecording: Recording) {
        guard let index = self.recordings.firstIndex(of: oldRecording) else {
            return
        }
        self.recordings[index] = newRecording
        storageObserverDelegate?.update(updateRecordings: true)
    }

    func removeRecording(recording: Recording) {
        guard let index = self.recordings.firstIndex(of: recording) else {
            return
        }
        self.recordings.remove(at: index)
        storageObserverDelegate?.update(updateRecordings: true)
    }

    func getRecordings() -> [Recording] {
        return self.recordings
    }

    func removeAllRecordings() {
        self.recordings = []
        storageObserverDelegate?.update(updateRecordings: true)
    }

    static func == (lhs: SongSegment, rhs: SongSegment) -> Bool {
        return lhs.name == rhs.name
            && lhs.recordings == rhs.recordings
    }

    func generateRecordingUrl() -> URL? {
        storageObserverDelegate?.generateNewRecordingFilePath()
    }

    func removeRecording(at url: URL) -> Bool {
        storageObserverDelegate?.removeRecording(at: url) ?? false
    }
}
