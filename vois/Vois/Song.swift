//
//  Song.swift
//  Vois
//
//  Created by Tan Yong He on 14/3/20.
//  Copyright © 2020 Vois. All rights reserved.
//

import Foundation

class Song: Equatable, Codable, Shareable, StorageObservable {
    var uid: String?
    private var segments: [SongSegment]
    var name: String

    var storageObserverDelegate: StorageObserverDelegate? {
        didSet {
            for segment in segments {
                segment.storageObserverDelegate = storageObserverDelegate
            }
        }
    }

    private enum CodingKeys: String, CodingKey {
        case segments, name
    }

    var hasNoSegments: Bool {
        return segments.isEmpty
    }

    var numOfSegments: Int {
        return segments.count
    }

    var dictionary: [String: Any] {
        return [
            "segments": segments.compactMap { $0.upload() },
            "name": name,
            "uid": uid
        ]
    }

    init (name: String) {
        self.name = name
        self.segments = []
        _ = upload()
    }

    convenience init?(dictionary: [String: Any], id: String, storageObserverDelegate: DatabaseObserver) {
        guard let name = dictionary["name"] as? String,
            let segmentReferences = dictionary["segments"] as? [String] else {
                return nil
        }
        self.init(name: name)
        self.segments = segmentReferences.compactMap {
            SongSegment(reference: $0, storageObserverDelegate: storageObserverDelegate)
        }
    }

    required convenience init?(reference: String, storageObserverDelegate: DatabaseObserver) {
        let data = storageObserverDelegate.initializationRead(reference: reference)
        self.init(dictionary: data, id: reference, storageObserverDelegate: storageObserverDelegate)
    }

    func addSegment(segment: SongSegment) {
        self.segments.append(segment)
        segment.storageObserverDelegate = storageObserverDelegate
       storageObserverDelegate?.update(operation: .update, object: self)
    }

    func updateSegment(oldSegment: SongSegment, newSegment: SongSegment) {
        guard let index = self.segments.firstIndex(of: oldSegment) else {
            return
        }
        self.segments[index] = newSegment
        newSegment.storageObserverDelegate = storageObserverDelegate

        storageObserverDelegate?.update(operation: .delete, object: oldSegment)
        storageObserverDelegate?.update(operation: .update, object: self)
    }

    func removeSegment(segment: SongSegment) {
        guard let index = self.segments.firstIndex(of: segment) else {
            return
        }
        self.segments.remove(at: index)
        storageObserverDelegate?.update(operation: .delete, object: segment)
        storageObserverDelegate?.update(operation: .update, object: self)
    }

    func getSegments() -> [SongSegment] {
        return self.segments
    }

    func removeAllSegments() {
        self.segments.forEach {
            storageObserverDelegate?.update(operation: .delete, object: $0)
        }
        self.segments = []
        storageObserverDelegate?.update(operation: .update, object: self)
    }

    static func == (lhs: Song, rhs: Song) -> Bool {
        return lhs.name == rhs.name
            && lhs.segments == rhs.segments
    }

    func upload() -> String? {
        for segment in segments {
            segment.uid = segment.upload()
        }
        uid = storageObserverDelegate?.upload(object: self) ?? uid
        return uid
    }
}
