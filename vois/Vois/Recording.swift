//
//  Recording.swift
//  Vois
//
//  Created by Tan Yong He on 14/3/20.
//  Copyright © 2020 Vois. All rights reserved.
//

import Foundation

class Recording: Equatable, Codable, Shareable, StorageObservable {
    var uid: String?
    private var audioComments: [AudioComment]
    private var textComments: [TextComment]
    var uniqueFilePath: URL
    var cloudReference: String?
    var id: String?

    private var updated = false
    var filePath: URL {
        return storageObserverDelegate?.convertToAbsoluteUrl(url: uniqueFilePath) ?? uniqueFilePath
    }

    func updateRecording(handler: (() -> Void)?) {
        if !updated {
            storageObserverDelegate?.download(recording: self, successHandler: handler, failureHandler: handler)
            updated = true
        } else {
            handler?()
        }
    }

    var name: String

    var storageObserverDelegate: StorageObserverDelegate? {
        didSet {
            uniqueFilePath = storageObserverDelegate?.convertToRelativeUrl(url: uniqueFilePath) ?? uniqueFilePath
            audioComments.forEach { $0.storageObserverDelegate = storageObserverDelegate }
            textComments.forEach { $0.storageObserverDelegate = storageObserverDelegate }
            _ = upload()
        }
    }

    var hasNoAudioComments: Bool {
        return audioComments.isEmpty
    }

    var hasNoTextComments: Bool {
        return textComments.isEmpty
    }

    var hasNoComments: Bool {
        return self.hasNoAudioComments && self.hasNoTextComments
    }

    var numOfAudioComments: Int {
        return audioComments.count
    }

    var numOfTextComments: Int {
        return textComments.count
    }

    var numOfComments: Int {
        return self.numOfAudioComments + self.numOfTextComments
    }

    var dictionary: [String: Any] {
        return [
            "name": name,
            "filePath": uniqueFilePath.path,
            "audioComments": audioComments.compactMap { $0.upload() },
            "textComments": textComments.compactMap { $0.upload() }
        ]
    }
    private let audioCommentsReference = "audioComments"
    private let textCommentsReference = "textComments"

    init (name: String, filePath: URL) {
        self.uniqueFilePath = storageObserverDelegate?.convertToRelativeUrl(url: filePath) ?? filePath
        self.audioComments = []
        self.textComments = []
        self.name = name
    }

    init?(dictionary: [String: Any], uid: String, storageObserverDelegate: DatabaseObserver) {
        guard let name = dictionary["name"] as? String,
            let path = dictionary["filePath"] as? String,
            let audioCommentsReferences = dictionary["audioComments"] as? [String],
            let textCommentsReferences = dictionary["textComments"] as? [String] else {
                return nil
        }
        self.name = name
        self.uniqueFilePath = URL(fileURLWithPath: path)
        self.uid = uid
        self.audioComments = audioCommentsReferences
            .compactMap { AudioComment(reference: $0, storageObserverDelegate: storageObserverDelegate) }
        self.textComments = textCommentsReferences.compactMap {
            TextComment(reference: $0, storageObserverDelegate: storageObserverDelegate)
        }
    }

    convenience init?(reference: String, storageObserverDelegate: DatabaseObserver) {
        let data = storageObserverDelegate.initializationRead(reference: reference)
        self.init(dictionary: data, uid: reference, storageObserverDelegate: storageObserverDelegate)
    }

    /* AudioComment API */
    func addAudioComment(audioComment: AudioComment) {
        self.audioComments.append(audioComment)
        audioComment.storageObserverDelegate = storageObserverDelegate
        storageObserverDelegate?.update(operation: .update, object: self)
    }

    func updateAudioComment(oldAudioComment: AudioComment, newAudioComment: AudioComment) {
        guard let index = self.audioComments.firstIndex(of: oldAudioComment) else {
            return
        }
        self.audioComments[index] = newAudioComment
        newAudioComment.storageObserverDelegate = storageObserverDelegate
        storageObserverDelegate?.update(operation: .delete, object: oldAudioComment)
        storageObserverDelegate?.update(operation: .update, object: self)
    }

    func removeAudioComment(audioComment: AudioComment) {
        guard let index = self.audioComments.firstIndex(of: audioComment) else {
            return
        }
        self.audioComments.remove(at: index)
        storageObserverDelegate?.update(operation: .delete, object: audioComment)
        storageObserverDelegate?.update(operation: .update, object: self)
    }

    func getAudioComments() -> [AudioComment] {
        return self.audioComments
    }

    func removeAllAudioComments() {
        self.audioComments.forEach { storageObserverDelegate?.update(operation: .delete, object: $0) }
        self.audioComments = []
        storageObserverDelegate?.update(operation: .update, object: self)
    }

    /* TextComment API */
    func addTextComment(textComment: TextComment) {
        self.textComments.append(textComment)
        textComment.storageObserverDelegate = storageObserverDelegate
        storageObserverDelegate?.update(operation: .update, object: self)
    }

    func updateTextComment(oldTextComment: TextComment, newTextComment: TextComment) {
        guard let index = textComments.firstIndex(of: oldTextComment) else {
            return
        }
        textComments[index] = newTextComment
        newTextComment.storageObserverDelegate = storageObserverDelegate
        storageObserverDelegate?.update(operation: .delete, object: oldTextComment)
        storageObserverDelegate?.update(operation: .update, object: self)
    }

    func removeTextComment(textComment: TextComment) {
        guard let index = textComments.firstIndex(of: textComment) else {
            return
        }
        textComments.remove(at: index)
        storageObserverDelegate?.update(operation: .delete, object: textComment)
    }

    func getTextComments() -> [TextComment] {
        return self.textComments
    }

    func removeAllTextComments() {
        self.textComments.forEach {
            storageObserverDelegate?.update(operation: .delete, object: $0) }
        self.textComments = []
        storageObserverDelegate?.update(operation: .update, object: self)
    }

    func removeAllComments() {
        removeAllAudioComments()
        removeAllTextComments()
    }

    static func == (lhs: Recording, rhs: Recording) -> Bool {
        return lhs.filePath == rhs.filePath
            && lhs.audioComments == rhs.audioComments
            && lhs.textComments == rhs.textComments
    }

    private enum CodingKeys: String, CodingKey {
        case uniqueFilePath
        case name
        case textComments
        case audioComments
    }

    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        uniqueFilePath = try values.decode(URL.self, forKey: .uniqueFilePath)
        name = try values.decode(String.self, forKey: .name)
        textComments = try values.decode([TextComment].self, forKey: .textComments)
        audioComments = try values.decode([AudioComment].self, forKey: .audioComments)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(uniqueFilePath, forKey: .uniqueFilePath)
        try container.encode(name, forKey: .name)
        try container.encode(textComments, forKey: .textComments)
        try container.encode(audioComments, forKey: .audioComments)
    }

    func upload() -> String? {
        for textComment in textComments {
            _ = textComment.upload()
        }

        for audioComment in audioComments {
            _ = audioComment.upload()
        }
        id = storageObserverDelegate?.upload(object: self) ?? id
        return id
    }

    func generateAudioCommentUrl() -> URL? {
        storageObserverDelegate?.generateNewRecordingFilePath()
    }

    func removeAudioComment(at url: URL) -> Bool {
        storageObserverDelegate?.removeRecording(at: url) ?? false
    }
}
