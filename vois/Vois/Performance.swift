//
//  Performance.swift
//  Vois
//
//  Created by Tan Yong He on 14/3/20.
//  Copyright © 2020 Vois. All rights reserved.
//

import Foundation

class Performance: Equatable, Codable, Serializable {
    private var songs: [Song]
    var name: String
    var date: Date?
    var uid: String
    var ownerUID: String
    var editorUIDs: [String]
    
    var hasNoSongs: Bool {
        return songs.isEmpty
    }

    var numOfSongs: Int {
        return songs.count
    }

    var dictionary: [String: Any] {
        return [
            "songs": songs,
            "name": name,
            "date": date,
            "uid": uid,
            "ownerUID": ownerUID,
            "editorUIDs": editorUIDs
        ]
    }

    convenience init (name: String, ownerUID: String, date: Date?) {
        self.init(name: name, ownerUID: ownerUID)
        self.date = date
    }

    init (name: String, ownerUID: String) {
        self.name = name
        self.songs = []
        self.uid = UUID().uuidString
        self.ownerUID = ownerUID
        self.editorUIDs = [ownerUID]
        self.uid = UUID().uuidString
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

    func removeSong(song: Song) {
        guard let index = self.songs.firstIndex(of: song) else {
            return
        }
        self.songs.remove(at: index)
    }

    func getSongs() -> [Song] {
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
        case ownerUID
        case editorUIDs
    }

    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.songs = try values.decode([Song].self, forKey: .songs)
        self.name = try values.decode(String.self, forKey: .name)
        self.date = try? values.decode(Date.self, forKey: .date)
        self.ownerUID = try values.decode(String.self, forKey: .ownerUID)
        self.editorUIDs = try values.decode([String].self, forKey: .editorUIDs)
        self.uid = UUID().uuidString
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(songs, forKey: .songs)
        try container.encode(name, forKey: .name)
        try? container.encode(date, forKey: .date)
        try container.encode(ownerUID, forKey: .ownerUID)
        try container.encode(editorUIDs, forKey: .editorUIDs)
    }

    func encodeToJson() throws -> Data {
        return try JSONEncoder().encode(self)
    }

    convenience init?(json: Data) {
        guard let newValue = try? JSONDecoder().decode(Performance.self, from: json) else {
            return nil
        }
        self.init(name: newValue.name, ownerUID: newValue.ownerUID, date: newValue.date)
        self.songs = newValue.songs
       }
}
