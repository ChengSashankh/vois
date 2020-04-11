//
//  TextComment.swift
//  Vois
//
//  Created by Tan Yong He on 14/3/20.
//  Copyright © 2020 Vois. All rights reserved.
//

import Foundation

class TextComment: Comment, Equatable, Serializable {
    var text: String
    var timeStamp: Double
    var author: String
    var uid: String

    var dictionary: [String: Any] {
        [
            "timeStamp": timeStamp,
            "author": author,
            "uid": uid,
            "text": text
        ]
    }

    init (timeStamp: Double, author: String, text: String, uid: String) {
        self.timeStamp = timeStamp
        self.author = author
        self.text = text
        self.uid = uid
    }

    convenience init(timeStamp: Double, author: String, text: String) {
        self.init(
            timeStamp: timeStamp,
            author: author,
            text: text,
            uid: UUID().uuidString
        )
    }

    convenience init?(dictionary: [String : Any]) {
        guard let timeStamp = dictionary["timeStamp"] as? Double,
            let author = dictionary["author"] as? String,
            let text = dictionary["text"] as? String,
            let uid = dictionary["uid"] as? String
            else { return nil }

        self.init(timeStamp: timeStamp, author: author, text: text, uid: uid)
    }

    static func == (lhs: TextComment, rhs: TextComment) -> Bool {
        return lhs.timeStamp == rhs.timeStamp
            && lhs.author == rhs.author
            && lhs.text == rhs.text
    }
}
