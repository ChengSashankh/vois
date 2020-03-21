//
//  RecordingList.swift
//  Vois
//
//  Created by Sudharshan Madhavan on 22/3/20.
//  Copyright © 2020 Vois. All rights reserved.
//

import Foundation

protocol RecordingList {
    var recordings: [URL] { get }
    var currentIndex: Int { get set }
}

extension RecordingList {
    mutating func next() {
        self.currentIndex = (self.currentIndex + 1) % recordings.count
    }

    mutating func prev() {
        self.currentIndex = (self.currentIndex - 1)
        if self.currentIndex < 0 {
            self.currentIndex += self.recordings.count
        }
    }
}
