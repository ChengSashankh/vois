//
//  RecordingReview.swift
//  Vois
//
//  Created by Jiang Yuxin on 25/4/20.
//  Copyright © 2020 Vois. All rights reserved.
//

import Foundation

class RecordingReview: Recording {

    let reviewer = UserSession.currentUsername ?? "Reviewer"

    override init?(dictionary: [String: Any], id: String, storageObserverDelegate: DatabaseObserver) {
        super.init(dictionary: dictionary, id: id, storageObserverDelegate: storageObserverDelegate)
    }
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
    }

    override func getAudioComments() -> [AudioComment] {
        super.getAudioComments().filter { $0.author == reviewer }
    }

    override func getTextComments() -> [TextComment] {
        super.getTextComments().filter { $0.author == reviewer }
    }
}
