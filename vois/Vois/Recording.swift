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
    var filePath: URL
    internal var id: String
    var cloudReference: String?

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

    init (filePath: URL) {
        self.filePath = filePath
        self.audioComments = []
        self.textComments = []
        self.cloudReference = ""
        id = UUID().uuidString
    }

    /* AudioComment API */
    func addAudioComment(audioComment: AudioComment) {
        self.audioComments.append(audioComment)
    }

    func updateAudioComment(oldAudioComment: AudioComment, newAudioComment: AudioComment) {
        guard let index = self.audioComments.firstIndex(of: oldAudioComment) else {
            return
        }
        self.audioComments[index] = newAudioComment
    }

    func removeAudioComment(audioComment: AudioComment) {
        guard let index = self.audioComments.firstIndex(of: audioComment) else {
            return
        }
        self.audioComments.remove(at: index)
    }

    func getAudioComments() -> [AudioComment] {
        return self.audioComments
    }

    func removeAllAudioComments() {
        self.audioComments = []
    }

    /* TextComment API */
    func addTextComment(textComment: TextComment) {
        self.textComments.append(textComment)
    }

    func updateTextComment(oldTextComment: TextComment, newTextComment: TextComment) {
        guard let index = textComments.firstIndex(of: oldTextComment) else {
            return
        }
        textComments[index] = newTextComment
    }

    func removeTextComment(textComment: TextComment) {
        guard let index = textComments.firstIndex(of: textComment) else {
            return
        }
        textComments.remove(at: index)
    }

    func getTextComments() -> [TextComment] {
        return self.textComments
    }

    func removeAllTextComments() {
        self.textComments = []
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

    enum CodingKeys: String, CodingKey {
        case filePath
    }

    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        filePath = try values.decode(URL.self, forKey: .filePath)
        audioComments = []
        textComments = []
        id = UUID().uuidString
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(filePath, forKey: .filePath)
    }
}
