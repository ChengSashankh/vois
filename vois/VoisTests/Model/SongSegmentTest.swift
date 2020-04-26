//
//  SongSegmentTest.swift
//  VoisTests
//
//  Created by Tan Yong He on 22/3/20.
//  Copyright © 2020 Vois. All rights reserved.
//

import XCTest
@testable import Vois
/*
class SongSegmentTest: XCTestCase {
    let segment = SongSegment(name: "SongSegment")
    let recordingOne = Recording(from: URL(fileURLWithPath: "/recording/audio_one.mp3"))
    let recordingTwo = Recording(from: URL(fileURLWithPath: "/recording/audio_two.mp3"))

    func testNoRecordings() {
        XCTAssertTrue(segment.hasNoRecordings)
    }

    func testNumOfRecordings() {
        XCTAssertEqual(segment.numOfRecordings, 0)
        segment.addRecording(recording: recordingOne)
        XCTAssertEqual(segment.numOfRecordings, 1)
        segment.addRecording(recording: recordingTwo)
        XCTAssertEqual(segment.numOfRecordings, 2)
        segment.updateRecording(oldRecording: recordingOne, newRecording: recordingTwo)
        XCTAssertEqual(segment.numOfRecordings, 2)
        segment.removeRecording(recording: recordingTwo)
        XCTAssertEqual(segment.numOfRecordings, 1)
        segment.removeAllRecordings()
        XCTAssertEqual(segment.numOfRecordings, 0)
    }

    func testGetName() {
        XCTAssertEqual(segment.name, "SongSegment")
        XCTAssertNotEqual(segment.name, "SongSegments")
        XCTAssertNotEqual(segment.name, "Song Segment")
    }

    func testSetName() {
        segment.name = "Song Segment"
        XCTAssertEqual(segment.name, "Song Segment")
        XCTAssertNotEqual(segment.name, "SongSegment")
        XCTAssertNotEqual(segment.name, "SongSegments")
    }

    func testAddRecording() {
        segment.addRecording(recording: recordingOne)
        XCTAssertTrue(segment.getRecordings().elementsEqual([recordingOne]))
        segment.addRecording(recording: recordingTwo)
        XCTAssertTrue(segment.getRecordings().elementsEqual([recordingOne, recordingTwo]))
        segment.addRecording(recording: recordingOne)
        XCTAssertTrue(segment.getRecordings().elementsEqual([recordingOne, recordingTwo, recordingOne]))
    }

    func testRemoveRecording() {
        segment.addRecording(recording: recordingOne)
        segment.addRecording(recording: recordingTwo)
        segment.addRecording(recording: recordingOne)

        segment.removeRecording(recording: recordingTwo)
        XCTAssertTrue(segment.getRecordings().elementsEqual([recordingOne, recordingOne]))
        segment.removeRecording(recording: recordingOne)
        XCTAssertTrue(segment.getRecordings().elementsEqual([recordingOne]))
        segment.removeRecording(recording: recordingOne)
        XCTAssertTrue(segment.getRecordings().isEmpty)
    }

    func testUpdateRecording() {
        segment.addRecording(recording: recordingOne)
        XCTAssertTrue(segment.getRecordings().elementsEqual([recordingOne]))
        segment.addRecording(recording: recordingTwo)
        XCTAssertTrue(segment.getRecordings().elementsEqual([recordingOne, recordingTwo]))
        segment.updateRecording(oldRecording: recordingOne, newRecording: recordingTwo)
        XCTAssertTrue(segment.getRecordings().elementsEqual([recordingTwo, recordingTwo]))
    }

    func testRemoveAllRecordings() {
        XCTAssertTrue(segment.hasNoRecordings)

        segment.addRecording(recording: recordingOne)
        segment.addRecording(recording: recordingTwo)

        XCTAssertFalse(segment.hasNoRecordings)
        segment.removeAllRecordings()
        XCTAssertTrue(segment.hasNoRecordings)
    }
}
*/
