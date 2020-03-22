//
//  SongSegment.swift
//  Vois
//
//  Created by Tan Yong He on 14/3/20.
//  Copyright © 2020 Vois. All rights reserved.
//

import Foundation

class SongSegment: Equatable {
    private var recordings: [Recording]
    var name: String

    var hasNoRecordings: Bool {
        return recordings.isEmpty
    }

    var numOfRecordings: Int {
        return recordings.count
    }

    init (name: String) {
        self.name = name
        self.recordings = []
    }

    func addRecording(recording: Recording) {
        self.recordings.append(recording)
    }

    func updateRecording(oldRecording: Recording, newRecording: Recording) {
        guard let index = self.recordings.firstIndex(of: oldRecording) else {
            return
        }
        self.recordings[index] = newRecording
    }

    func removeRecording(recording: Recording) {
        guard let index = self.recordings.firstIndex(of: recording) else {
            return
        }
        self.recordings.remove(at: index)
    }

    func getRecordings() -> [Recording] {
        return self.recordings
    }

    func removeAllRecordings() {
        self.recordings = []
    }

    static func == (lhs: SongSegment, rhs: SongSegment) -> Bool {
        return lhs.name == rhs.name
            && lhs.recordings == rhs.recordings
    }
}
