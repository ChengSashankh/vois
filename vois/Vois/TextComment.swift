//
//  TextComment.swift
//  Vois
//
//  Created by Tan Yong He on 14/3/20.
//  Copyright © 2020 vois. All rights reserved.
//

import Foundation

class TextComment: Comment, Equatable {
    private var text: String
    internal var timeStamp: Double
    internal var author: String

    init (timeStamp: Double, author: String, text: String) {
        self.timeStamp = timeStamp
        self.author = author
        self.text = text
    }

    func setText(newText: String) {
        self.text = newText
    }

    func getText() -> String {
        return self.text
    }

    static func == (lhs: TextComment, rhs: TextComment) -> Bool {
        return lhs.timeStamp == rhs.timeStamp
            && lhs.author == rhs.author
            && lhs.text == rhs.text
    }
}
