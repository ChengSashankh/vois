//
//  SongSegment.swift
//  Vois
//
//  Created by Tan Yong He on 14/3/20.
//  Copyright © 2020 vois. All rights reserved.
//

import Foundation

class SongSegment: Equatable {
    private var name: String
    private var recordings: [Recording]

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

    func setName(newName: String) {
        self.name = newName
    }

    func getName() -> String {
        return self.name
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

    func getAudioComments() -> [Recording] {
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
