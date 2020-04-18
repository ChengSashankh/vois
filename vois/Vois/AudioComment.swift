//
//  AudioComment.swift
//  Vois
//
//  Created by Tan Yong He on 14/3/20.
//  Copyright © 2020 Vois. All rights reserved.
//

import Foundation

class AudioComment: Comment, Equatable, Codable, Shareable, StorageObservable {

    var filePath: URL
    var timeStamp: Double
    var author: String
    var id: String?

    var storageObserverDelegate: StorageObserverDelegate? {
        didSet {
            _ = upload()
        }
    }

    init (timeStamp: Double, author: String, filePath: URL) {
        self.timeStamp = timeStamp
        self.author = author
        self.filePath = filePath
    }

    init?(dictionary: [String: Any], id: String, storageObserverDelegate: DatabaseObserver) {
        guard let timeStamp = dictionary["timeStamp"] as? Double,
            let author = dictionary["author"] as? String,
            let filePath = dictionary["filePath"] as? String else {
                return nil
        }
        self.timeStamp = timeStamp
        self.author = author
        self.filePath = URL(fileURLWithPath: filePath)
        self.id = id
    }

    required convenience init?(reference: String, storageObserverDelegate: DatabaseObserver) {
        let data = storageObserverDelegate.initializationRead(reference: reference)
        self.init(dictionary: data, id: reference, storageObserverDelegate: storageObserverDelegate)
    }

    static func == (lhs: AudioComment, rhs: AudioComment) -> Bool {
        return lhs.timeStamp == rhs.timeStamp
            && lhs.author == rhs.author
            && lhs.filePath == rhs.filePath
    }

    enum CodingKeys: String, CodingKey {
        case timeStamp
        case author
        case filePath
    }

    var dictionary: [String: Any] {
           [
               "timeStamp": timeStamp,
               "author": author,
               "filepath": filePath
           ]
       }

    func upload() -> String? {
        id = storageObserverDelegate?.upload(object: self) ?? id
        return id
    }
}
