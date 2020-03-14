//
//  Song.swift
//  Vois
//
//  Created by Tan Yong He on 14/3/20.
//  Copyright © 2020 vois. All rights reserved.
//

import Foundation

class Song: Equatable {
    private var name: String
    private var segments: [SongSegment]

    var hasNoSegments: Bool {
        return segments.isEmpty
    }

    var numOfSegments: Int {
        return segments.count
    }

    init (name: String) {
        self.name = name
        self.segments = []
    }

    func setName(newName: String) {
        self.name = newName
    }

    func getName() -> String {
        return self.name
    }

    func addSegment(segment: SongSegment) {
        self.segments.append(segment)
    }

    func updateSegment(oldSegment: SongSegment, newSegment: SongSegment) {
        guard let index = self.segments.firstIndex(of: oldSegment) else {
            return
        }
        self.segments[index] = newSegment
    }

    func removeSegment(segment: SongSegment) {
        guard let index = self.segments.firstIndex(of: segment) else {
            return
        }
        self.segments.remove(at: index)
    }

    func getSegments() -> [SongSegment] {
        return self.segments
    }

    func removeAllSegments() {
        self.segments = []
    }

    static func == (lhs: Song, rhs: Song) -> Bool {
        return lhs.name == rhs.name
            && lhs.segments == rhs.segments
    }
}
