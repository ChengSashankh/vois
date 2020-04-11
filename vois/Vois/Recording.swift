//
//  Recording.swift
//  Vois
//
//  Created by Tan Yong He on 14/3/20.
//  Copyright © 2020 Vois. All rights reserved.
//

import Foundation

class Recording: Equatable, Codable, Serializable {
    private var audioComments: [AudioComment]
    private var textComments: [TextComment]

    private var uniqueFilePath: URL

    var filePath: URL {
        storageObserverDelegate?.convertToAbsoluteUrl(url: uniqueFilePath) ?? uniqueFilePath
    }
    var name: String
    internal var id: String
    var cloudReference: String?

    var storageObserverDelegate: StorageObserverDelegate? {
        didSet {
            uniqueFilePath = storageObserverDelegate?.convertToRelativeUrl(url: uniqueFilePath) ?? uniqueFilePath
            storageObserverDelegate?.update(updateRecordings: false)
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
            "filePath": filePath,
            "audioComments": audioComments,
            "textComments": textComments,
            "id": id,
            "cloudReference": cloudReference ?? ""
        ]
    }

    init (name: String, filePath: URL) {
        self.uniqueFilePath = storageObserverDelegate?.convertToRelativeUrl(url: filePath) ?? filePath
        self.audioComments = []
        self.textComments = []
        self.cloudReference = ""
        self.name = name
        id = UUID().uuidString
    }

    /* AudioComment API */
    func addAudioComment(audioComment: AudioComment) {
        self.audioComments.append(audioComment)
        storageObserverDelegate?.update(updateRecordings: false)
    }

    func updateAudioComment(oldAudioComment: AudioComment, newAudioComment: AudioComment) {
        guard let index = self.audioComments.firstIndex(of: oldAudioComment) else {
            return
        }
        self.audioComments[index] = newAudioComment
        storageObserverDelegate?.update(updateRecordings: true)
    }

    func removeAudioComment(audioComment: AudioComment) {
        guard let index = self.audioComments.firstIndex(of: audioComment) else {
            return
        }
        self.audioComments.remove(at: index)
        storageObserverDelegate?.update(updateRecordings: true)
    }

    func getAudioComments() -> [AudioComment] {
        return self.audioComments
    }

    func removeAllAudioComments() {
        self.audioComments = []
        storageObserverDelegate?.update(updateRecordings: true)
    }

    /* TextComment API */
    func addTextComment(textComment: TextComment) {
        self.textComments.append(textComment)
        storageObserverDelegate?.update(updateRecordings: false)
    }

    func updateTextComment(oldTextComment: TextComment, newTextComment: TextComment) {
        guard let index = textComments.firstIndex(of: oldTextComment) else {
            return
        }
        textComments[index] = newTextComment
        storageObserverDelegate?.update(updateRecordings: false)
    }

    func removeTextComment(textComment: TextComment) {
        guard let index = textComments.firstIndex(of: textComment) else {
            return
        }
        textComments.remove(at: index)
        storageObserverDelegate?.update(updateRecordings: false)
    }

    func getTextComments() -> [TextComment] {
        return self.textComments
    }

    func removeAllTextComments() {
        self.textComments = []
        storageObserverDelegate?.update(updateRecordings: false)
    }

    func removeAllComments() {
        removeAllAudioComments()
        removeAllTextComments()
        storageObserverDelegate?.update(updateRecordings: true)
    }

    static func == (lhs: Recording, rhs: Recording) -> Bool {
        return lhs.filePath == rhs.filePath
            && lhs.audioComments == rhs.audioComments
            && lhs.textComments == rhs.textComments
    }

    enum CodingKeys: String, CodingKey {
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
        id = UUID().uuidString
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(uniqueFilePath, forKey: .uniqueFilePath)
        try container.encode(name, forKey: .name)
        try container.encode(textComments, forKey: .textComments)
        try container.encode(audioComments, forKey: .audioComments)
    }
}
