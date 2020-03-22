//
//  SongTest.swift
//  VoisTests
//
//  Created by Tan Yong He on 22/3/20.
//  Copyright © 2020 Vois. All rights reserved.
//

import XCTest
@testable import Vois

class SongTest: XCTestCase {
    let song = Song(name: "Song")
    let segmentOne = SongSegment(name: "SongSegmentOne")
    let segmentTwo = SongSegment(name: "SongSegmentTwo")

    func testNoSegments() {
        XCTAssertTrue(song.hasNoSegments)
    }

    func testNumOfSegments() {
        XCTAssertEqual(song.numOfSegments, 0)
        song.addSegment(segment: segmentOne)
        XCTAssertEqual(song.numOfSegments, 1)
        song.addSegment(segment: segmentTwo)
        XCTAssertEqual(song.numOfSegments, 2)
        song.updateSegment(oldSegment: segmentOne, newSegment: segmentTwo)
        XCTAssertEqual(song.numOfSegments, 2)
        song.removeSegment(segment: segmentTwo)
        XCTAssertEqual(song.numOfSegments, 1)
        song.removeAllSegments()
        XCTAssertEqual(song.numOfSegments, 0)
    }

    func testGetName() {
        XCTAssertEqual(song.name, "Song")
        XCTAssertNotEqual(song.name, "Songs")
        XCTAssertNotEqual(song.name, "Best Song")
    }

    func testSetName() {
        song.name = "Best Song"
        XCTAssertEqual(song.name, "Best Song")
        XCTAssertNotEqual(song.name, "BestSong")
        XCTAssertNotEqual(song.name, "Song")
    }

    func testAddRecording() {
        song.addSegment(segment: segmentOne)
        XCTAssertTrue(song.getSegments().elementsEqual([segmentOne]))
        song.addSegment(segment: segmentTwo)
        XCTAssertTrue(song.getSegments().elementsEqual([segmentOne, segmentTwo]))
        song.addSegment(segment: segmentOne)
        XCTAssertTrue(song.getSegments().elementsEqual([segmentOne, segmentTwo, segmentOne]))
    }

    func testRemoveRecording() {
        song.addSegment(segment: segmentOne)
        song.addSegment(segment: segmentTwo)
        song.addSegment(segment: segmentOne)

        song.removeSegment(segment: segmentTwo)
        XCTAssertTrue(song.getSegments().elementsEqual([segmentOne, segmentOne]))
        song.removeSegment(segment: segmentOne)
        XCTAssertTrue(song.getSegments().elementsEqual([segmentOne]))
        song.removeSegment(segment: segmentOne)
        XCTAssertTrue(song.getSegments().isEmpty)
    }

    func testUpdateRecording() {
        song.addSegment(segment: segmentOne)
        XCTAssertTrue(song.getSegments().elementsEqual([segmentOne]))
        song.addSegment(segment: segmentTwo)
        XCTAssertTrue(song.getSegments().elementsEqual([segmentOne, segmentTwo]))
        song.updateSegment(oldSegment: segmentOne, newSegment: segmentTwo)
        XCTAssertTrue(song.getSegments().elementsEqual([segmentTwo, segmentTwo]))
    }

    func testRemoveAllRecordings() {
        XCTAssertTrue(song.hasNoSegments)

        song.addSegment(segment: segmentOne)
        song.addSegment(segment: segmentTwo)

        XCTAssertFalse(song.hasNoSegments)
        song.removeAllSegments()
        XCTAssertTrue(song.hasNoSegments)
    }
}
