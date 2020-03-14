//
//  AudioComment.swift
//  Vois
//
//  Created by Tan Yong He on 14/3/20.
//  Copyright © 2020 vois. All rights reserved.
//

import Foundation

class AudioComment: Comment, Equatable {
    internal var timeStamp: Double
    internal var author: String
    internal var audioFilePath: URL
    
    init (timeStamp: Double, author: String, audioFilePath: URL) {
        self.timeStamp = timeStamp
        self.author = author
        self.audioFilePath = audioFilePath
    }
    
    func setAudio(newAudioFilePath: URL) {
        self.audioFilePath = newAudioFilePath
    }
    
    func getAudio() -> URL {
        return self.audioFilePath
    }
    
    static func == (lhs: AudioComment, rhs: AudioComment) -> Bool {
        return lhs.timeStamp == rhs.timeStamp
            && lhs.author == rhs.author
            && lhs.audioFilePath == rhs.audioFilePath
    }
}
