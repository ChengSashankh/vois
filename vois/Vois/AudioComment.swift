//
//  AudioComment.swift
//  Vois
//
//  Created by Tan Yong He on 14/3/20.
//  Copyright © 2020 Vois. All rights reserved.
//

import Foundation

class AudioComment: Comment, Equatable, Serializable {
    var filePath: URL
    var timeStamp: Double
    var author: String
    var uid: String

    var dictionary: [String: Any] {
        [
            "timeStamp": timeStamp,
            "author": author,
            "uid": uid
        ]
    }

    init (timeStamp: Double, author: String, filePath: URL) {
        self.timeStamp = timeStamp
        self.author = author
        self.filePath = filePath
        self.uid = UUID().uuidString
    }

    init (timeStamp: Double, author: String, filePath: URL, uid: String) {
        self.timeStamp = timeStamp
        self.author = author
        self.filePath = filePath
        self.uid = uid
    }

    static func == (lhs: AudioComment, rhs: AudioComment) -> Bool {
        return lhs.timeStamp == rhs.timeStamp
            && lhs.author == rhs.author
            && lhs.filePath == rhs.filePath
    }
}
