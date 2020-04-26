//
//  SongSegment.swift
//  Vois
//
//  Created by Tan Yong He on 14/3/20.
//  Copyright © 2020 Vois. All rights reserved.
//

import Foundation

class SongSegment: Equatable, Codable, Serializable, Shareable, StorageObservable {
    var uid: String?
    private var recordings: [Recording]
    var name: String
    var storageObserverDelegate: StorageObserverDelegate? {
        didSet {
            for recording in recordings {
                recording.storageObserverDelegate = storageObserverDelegate
            }
            _ = upload()
        }
    }

    private enum CodingKeys: String, CodingKey {
        case recordings, name
    }

    var hasNoRecordings: Bool {
        return recordings.isEmpty
    }

    var numOfRecordings: Int {
        return recordings.count
    }

    var dictionary: [String: Any] {
        return [
            "recordings": recordings.compactMap { $0.upload() },
            "name": name
        ]
    }

    private var recordingsReference = "recordings"

    func upload() -> String? {
        for recording in recordings {
            _ = recording.upload()
        }
        uid = storageObserverDelegate?.upload(object: self) ?? uid
        return uid
    }


    init (name: String) {
        self.name = name
        self.recordings = []
        self.uid = UUID().uuidString
    }

    convenience init?(dictionary: [String: Any], id: String, storageObserverDelegate: DatabaseObserver) {
        guard let name = dictionary["name"] as? String,
            let recordingReferences = dictionary["recordings"] as? [String] else {
                return nil
        }
        self.init(name: name)
        self.uid = uid
        self.recordings = recordingReferences.compactMap {
            Recording(reference: $0, storageObserverDelegate: storageObserverDelegate)
        }
    }

    required convenience init?(reference: String, storageObserverDelegate: DatabaseObserver) {
        let data = storageObserverDelegate.initializationRead(reference: reference)
        self.init(dictionary: data, id: reference, storageObserverDelegate: storageObserverDelegate)
    }

    func addRecording(recording: Recording) {
        self.recordings.append(recording)
        recording.storageObserverDelegate = storageObserverDelegate
        storageObserverDelegate?.update(operation: .update, object: self)
    }

    func updateRecording(oldRecording: Recording, newRecording: Recording) {
        guard let index = self.recordings.firstIndex(of: oldRecording) else {
            return
        }
        self.recordings[index] = newRecording
        newRecording.storageObserverDelegate = storageObserverDelegate
        storageObserverDelegate?.update(operation: .delete, object: oldRecording)
        oldRecording.storageObserverDelegate = nil
        storageObserverDelegate?.update(operation: .update, object: self)
    }

    func removeRecording(recording: Recording) {
        guard let index = self.recordings.firstIndex(of: recording) else {
            return
        }
        recording.storageObserverDelegate = nil
        self.recordings.remove(at: index)
        storageObserverDelegate?.update(operation: .delete, object: recording)
        storageObserverDelegate?.update(operation: .update, object: self)
    }

    func getRecordings() -> [Recording] {
        return self.recordings
    }

    func removeAllRecordings() {
        self.recordings.forEach {
            storageObserverDelegate?.update(operation: .delete, object: $0)
        }
        self.recordings = []
        storageObserverDelegate?.update(operation: .update, object: self)
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
