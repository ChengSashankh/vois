//
//  Recording.swift
//  Vois
//
//  Created by Tan Yong He on 14/3/20.
//  Copyright © 2020 vois. All rights reserved.
//

import Foundation

class Recording: Equatable {
    private var audioFilePath: URL
    private var audioComments: [AudioComment]
    private var textComments: [TextComment]

    init (audioFilePath: URL) {
        self.audioFilePath = audioFilePath
        self.audioComments = []
        self.textComments = []
    }

    /* AudioComment API */
    func addAudioComment(audioComment: AudioComment) {
        self.audioComments.append(audioComment)
    }

    func updateAudioComment(oldAudioComment: AudioComment, newAudioComment: AudioComment) {
        guard let index = audioComments.firstIndex(of: oldAudioComment) else {
            return
        }
        audioComments[index] = newAudioComment
    }

    func removeAudioComment(audioComment: AudioComment) {
        guard let index = audioComments.firstIndex(of: audioComment) else {
            return
        }
        audioComments.remove(at: index)
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

    static func == (lhs: Recording, rhs: Recording) -> Bool {
        return lhs.audioFilePath == rhs.audioFilePath
            && lhs.audioComments == rhs.audioComments
            && lhs.textComments == rhs.textComments
    }
}
