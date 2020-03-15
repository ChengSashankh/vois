//
//  TextComment.swift
//  Vois
//
//  Created by Tan Yong He on 14/3/20.
//  Copyright © 2020 vois. All rights reserved.
//

import Foundation

class TextComment: Comment, Equatable {
    var text: String
    var timeStamp: Double
    var author: String

    init (timeStamp: Double, author: String, text: String) {
        self.timeStamp = timeStamp
        self.author = author
        self.text = text
    }

    static func == (lhs: TextComment, rhs: TextComment) -> Bool {
        return lhs.timeStamp == rhs.timeStamp
            && lhs.author == rhs.author
            && lhs.text == rhs.text
    }
}
