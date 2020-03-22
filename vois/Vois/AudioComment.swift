//
//  AudioComment.swift
//  Vois
//
//  Created by Tan Yong He on 14/3/20.
//  Copyright © 2020 Vois. All rights reserved.
//

import Foundation

class AudioComment: Comment, Equatable {
    var filePath: URL
    var timeStamp: Double
    var author: String

    init (timeStamp: Double, author: String, filePath: URL) {
        self.timeStamp = timeStamp
        self.author = author
        self.filePath = filePath
    }

    static func == (lhs: AudioComment, rhs: AudioComment) -> Bool {
        return lhs.timeStamp == rhs.timeStamp
            && lhs.author == rhs.author
            && lhs.filePath == rhs.filePath
    }
}
