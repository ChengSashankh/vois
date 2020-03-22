//
//  Comment.swift
//  Vois
//
//  Created by Tan Yong He on 14/3/20.
//  Copyright © 2020 vois. All rights reserved.
//

import Foundation

protocol Comment {
    var timeStamp: Double { get set }
    var author: String { get set }
}

enum CommentType: String {
    case audio
    case text

    func type() -> String {
        return self.rawValue
    }
}
