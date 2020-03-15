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
    //mutating func setTimeStamp(newTimeStamp: Double)
    //func getTimeStamp() -> Double
    //mutating func setAuthor(newAuthor: String)
    //func getAuthor() -> String
}

enum CommentType: String {
    case audio
    case text

    func type() -> String {
        return self.rawValue
    }
}