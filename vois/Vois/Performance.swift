//
//  Performance.swift
//  Vois
//
//  Created by Tan Yong He on 14/3/20.
//  Copyright © 2020 vois. All rights reserved.
//

import Foundation

class Performance: Equatable {
    private var songs: [Song]
    var name: String
    var date: Date?

    var hasNoSongs: Bool {
        return songs.isEmpty
    }

    var numOfSongs: Int {
        return songs.count
    }

    init (name: String, date: Date?) {
        self.name = name
        self.songs = []
        self.date = date
    }

    func addSong(song: Song) {
        self.songs.append(song)
    }

    func updateSong(oldSong: Song, newSong: Song) {
        guard let index = self.songs.firstIndex(of: oldSong) else {
            return
        }
        self.songs[index] = newSong
    }

    func removeSegment(segment: Song) {
        guard let index = self.songs.firstIndex(of: segment) else {
            return
        }
        self.songs.remove(at: index)
    }

    func getSegments() -> [Song] {
        return self.songs
    }

    func removeAllSongs() {
        self.songs = []
    }

    static func == (lhs: Performance, rhs: Performance) -> Bool {
        return lhs.name == rhs.name
            && lhs.songs == rhs.songs
            && lhs.date == rhs.date
    }
}
