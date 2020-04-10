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
    var id: String

    var dictionary: [String: Any] {
        [
            "timeStamp": timeStamp,
            "author": author,
            "id": id,
            "text": text
        ]
    }

    init (timeStamp: Double, author: String, text: String, id: String) {
        self.timeStamp = timeStamp
        self.author = author
        self.text = text
        self.id = id
    }

    convenience init(timeStamp: Double, author: String, text: String) {
        self.init(
            timeStamp: timeStamp,
            author: author,
            text: text,
            id: UUID().uuidString
        )
    }

    convenience init?(dictionary: [String: Any]) {
        guard let timeStamp = dictionary["timeStamp"] as? Double,
            let author = dictionary["author"] as? String,
            let text = dictionary["text"] as? String,
            let id = dictionary["id"] as? String
            else { return nil }

        self.init(timeStamp: timeStamp, author: author, text: text, id: id)
    }

    static func == (lhs: TextComment, rhs: TextComment) -> Bool {
        return lhs.timeStamp == rhs.timeStamp
            && lhs.author == rhs.author
            && lhs.text == rhs.text
    }
}
