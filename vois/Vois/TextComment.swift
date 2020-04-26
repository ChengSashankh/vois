//
//  TextComment.swift
//  Vois
//
//  Created by Tan Yong He on 14/3/20.
//  Copyright © 2020 Vois. All rights reserved.
//

import Foundation

class TextComment: Comment, Equatable, Codable, Shareable, StorageObservable {
    var uid: String?
    var text: String
    var timeStamp: Double
    var author: String

    var storageObserverDelegate: StorageObserverDelegate? {
        didSet {
            _ = upload()
        }
    }

    var dictionary: [String: Any] {
        [
            "timeStamp": timeStamp,
            "author": author,
            "text": text
        ]
    }

    init (timeStamp: Double, author: String, text: String) {
        self.timeStamp = timeStamp
        self.author = author
        self.text = text
    }

    convenience init?(dictionary: [String: Any], uid: String) {
        guard let timeStamp = dictionary["timeStamp"] as? Double,
            let author = dictionary["author"] as? String,
            let text = dictionary["text"] as? String
            else { return nil }
        self.init(timeStamp: timeStamp, author: author, text: text)
        self.uid = uid
    }

    required convenience init?(reference: String, storageObserverDelegate: DatabaseObserver) {
        let data = storageObserverDelegate.initializationRead(reference: reference)
        self.init(dictionary: data, uid: reference)
    }

    enum CodingKeys: String, CodingKey {
        case timeStamp
        case author
        case text
    }

    static func == (lhs: TextComment, rhs: TextComment) -> Bool {
        return lhs.timeStamp == rhs.timeStamp
            && lhs.author == rhs.author
            && lhs.text == rhs.text
    }

    func upload() -> String? {
        uid = storageObserverDelegate?.upload(object: self) ?? uid
        return uid
    }

}
