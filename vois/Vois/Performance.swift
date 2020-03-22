//
//  Performance.swift
//  Vois
//
//  Created by Tan Yong He on 14/3/20.
//  Copyright © 2020 vois. All rights reserved.
//

import Foundation

class Performance: Equatable, Codable {
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

    enum CodingKeys: String, CodingKey {
        case songs
        case name
        case date
    }

    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        songs = try values.decode([Song].self, forKey: .songs)
        name = try values.decode(String.self, forKey: .name)
        date = try? values.decode(Date.self, forKey: .date)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(songs, forKey: .songs)
        try container.encode(name, forKey: .name)
        try? container.encode(date, forKey: .date)
    }

    func encodeToJson() throws -> Data {
        return try JSONEncoder().encode(self)
    }

    convenience init?(json: Data) {
        guard let newValue = try? JSONDecoder().decode(Performance.self, from: json) else {
            return nil
        }
        self.init(name: newValue.name, date: newValue.date)
        self.songs = newValue.songs
       }
}
