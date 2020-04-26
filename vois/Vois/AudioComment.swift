//
//  AudioComment.swift
//  Vois
//
//  Created by Tan Yong He on 14/3/20.
//  Copyright © 2020 Vois. All rights reserved.
//

import Foundation

class AudioComment: Recording, Comment {
    var timeStamp: Double
    var author: String

    init (timeStamp: Double, author: String, filePath: URL) {
        self.timeStamp = timeStamp
        self.author = author
        super.init(name: author, filePath: filePath)

    }

    private enum CodingKeys: String, CodingKey {
        case uniqueFilePath
        case author
        case timeStamp
    }

    override init?(dictionary: [String: Any], uid: String, storageObserverDelegate: DatabaseObserver) {
        guard let timeStamp = dictionary["timeStamp"] as? Double,
            let author = dictionary["author"] as? String,
            let filePath = dictionary["filepath"] as? String else {
                return nil
        }
        self.timeStamp = timeStamp
        self.author = author
        super.init(name: author, filePath: URL(fileURLWithPath: filePath))
        self.uid = uid
        self.uniqueFilePath = URL(fileURLWithPath: filePath)
    }

    required convenience init?(reference: String, storageObserverDelegate: DatabaseObserver) {
        let data = storageObserverDelegate.initializationRead(reference: reference)
        self.init(dictionary: data, uid: reference, storageObserverDelegate: storageObserverDelegate)
    }

    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: AudioComment.CodingKeys.self)
        author = try values.decode(String.self, forKey: .author)
        timeStamp = try values.decode(Double.self, forKey: .timeStamp)
        super.init(name: author, filePath: URL(fileURLWithPath: ""))
        uniqueFilePath = try values.decode(URL.self, forKey: .uniqueFilePath)
    }

    static func == (lhs: AudioComment, rhs: AudioComment) -> Bool {
        return lhs.timeStamp == rhs.timeStamp
            && lhs.author == rhs.author
            && lhs.uniqueFilePath == rhs.uniqueFilePath
    }

    override var dictionary: [String: Any] {
           [
               "timeStamp": timeStamp,
               "author": author,
               "filepath": uniqueFilePath.path
           ]
       }
}
