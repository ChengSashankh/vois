//
//  Performance.swift
//  Vois
//
//  Created by Tan Yong He on 14/3/20.
//  Copyright © 2020 Vois. All rights reserved.
//

import Foundation

class Performance: Equatable, Codable, Shareable, StorageObservable {

    private var songs: [Song]
    var name: String
    var date: Date?
    var id: String?

    var storageObserverDelegate: StorageObserverDelegate? {
        didSet {
            for song in songs {
                song.storageObserverDelegate = storageObserverDelegate
            }
            id = upload()
        }
    }
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

    init (name: String) {
        self.name = name
        self.songs = []
    }

    convenience init?(dictionary: [String: Any], id: String, storageObserverDelegate: DatabaseObserver) {
        guard let name = dictionary["name"] as? String,
            let songsReferences = dictionary["songs"] as? [String] else {
                return nil
        }

        let date = dictionary["data"] as? Date
        self.init(name: name, date: date)
        self.id = id
        self.songs = songsReferences.compactMap {
            Song(reference: $0, storageObserverDelegate: storageObserverDelegate)
        }
    }

    required convenience init?(reference: String, storageObserverDelegate: DatabaseObserver) {
        let data = storageObserverDelegate.initializationRead(reference: reference)
        self.init(dictionary: data, id: reference, storageObserverDelegate: storageObserverDelegate)
    }

    func addSong(song: Song) {
        self.songs.append(song)
        song.storageObserverDelegate = storageObserverDelegate
        storageObserverDelegate?.update(operation: .update, object: self)
    }

    func updateSong(oldSong: Song, newSong: Song) {
        guard let index = self.songs.firstIndex(of: oldSong) else {
            return
        }
        self.songs[index] = newSong
        newSong.storageObserverDelegate = storageObserverDelegate
        _ = storageObserverDelegate?.update(operation: .delete, object: oldSong)
        storageObserverDelegate?.update(operation: .update, object: self)
    }

    func removeSong(song: Song) {
        guard let index = self.songs.firstIndex(of: song) else {
            return
        }
        self.songs.remove(at: index)
        storageObserverDelegate?.update(operation: .delete, object: song)
        storageObserverDelegate?.update(operation: .update, object: self)
    }

    func getSongs() -> [Song] {
        return self.songs
    }

    func removeAllSongs() {
        self.songs.forEach {
            storageObserverDelegate?.update(operation: .delete, object: $0)
        }
        self.songs = []
        storageObserverDelegate?.update(operation: .update, object: self)
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
        self.id = UUID().uuidString
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(songs, forKey: .songs)
        try container.encode(name, forKey: .name)
        try? container.encode(date, forKey: .date)
    }

    var dictionary: [String: Any] {
        return [
            "name": name,
            "date": date?.toString ?? "",
            "songs": songs.compactMap { $0.upload() }
        ]
    }

    private var songsReference = "songs"

    func upload() -> String? {
        id = storageObserverDelegate?.upload(object: self) ?? id
        return id
    }

    func getPendingSongs() -> [Song] {
        songs.filter { $0.allRecordings.isEmpty  }
    }

    func getCompleteSongs() -> [Song] {
        songs.filter { !$0.allRecordings.isEmpty }
    }
}
