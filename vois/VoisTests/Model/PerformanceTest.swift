//
//  PerformanceTest.swift
//  VoisTests
//
//  Created by Tan Yong He on 22/3/20.
//  Copyright © 2020 Vois. All rights reserved.
//

import XCTest
@testable import Vois

class PerformanceTest: XCTestCase {
    let performance = Performance(name: "Performance", date: Date(timeIntervalSince1970: 123_456_789))
    let practice = Performance(name: "Practice")
    let songOne = Song(name: "SongOne")
    let songTwo = Song(name: "SongTwo")

    func testNoSegments() {
        XCTAssertTrue(performance.hasNoSongs)
    }

    func testNumOfSongs() {
        XCTAssertEqual(performance.numOfSongs, 0)
        performance.addSong(song: songOne)
        XCTAssertEqual(performance.numOfSongs, 1)
        performance.addSong(song: songTwo)
        XCTAssertEqual(performance.numOfSongs, 2)
        performance.updateSong(oldSong: songOne, newSong: songTwo)
        XCTAssertEqual(performance.numOfSongs, 2)
        performance.removeSong(song: songTwo)
        XCTAssertEqual(performance.numOfSongs, 1)
        performance.removeAllSongs()
        XCTAssertEqual(performance.numOfSongs, 0)
    }

    func testGetName() {
        XCTAssertEqual(performance.name, "Performance")
        XCTAssertNotEqual(performance.name, "Performances")
        XCTAssertNotEqual(performance.name, "Best Performance")
    }

    func testSetName() {
        performance.name = "Best Performance"
        XCTAssertEqual(performance.name, "Best Performance")
        XCTAssertNotEqual(performance.name, "BestPerformance")
        XCTAssertNotEqual(performance.name, "Performance")
    }

    func testGetDate() {
        XCTAssertEqual(performance.date, Date(timeIntervalSince1970: 123_456_789))
        XCTAssertNotEqual(performance.date, Date(timeIntervalSince1970: 432_156_789))

        XCTAssertNil(practice.date)
    }

    func testSetDate() {
        performance.date = Date(timeIntervalSince1970: 432_156_789)
        XCTAssertEqual(performance.date, Date(timeIntervalSince1970: 432_156_789))
        XCTAssertNotEqual(performance.date, Date(timeIntervalSince1970: 123_456_789))

        practice.date = Date(timeIntervalSince1970: 543_216_789)
        XCTAssertEqual(practice.date, Date(timeIntervalSince1970: 543_216_789))
        XCTAssertNotNil(practice.date)
    }

    func testAddSong() {
        performance.addSong(song: songOne)
        XCTAssertTrue(performance.getSongs().elementsEqual([songOne]))
        performance.addSong(song: songTwo)
        XCTAssertTrue(performance.getSongs().elementsEqual([songOne, songTwo]))
        performance.addSong(song: songOne)
        XCTAssertTrue(performance.getSongs().elementsEqual([songOne, songTwo, songOne]))
    }

    func testRemoveSong() {
        performance.addSong(song: songOne)
        performance.addSong(song: songTwo)
        performance.addSong(song: songOne)

        performance.removeSong(song: songTwo)
        XCTAssertTrue(performance.getSongs().elementsEqual([songOne, songOne]))
        performance.removeSong(song: songOne)
        XCTAssertTrue(performance.getSongs().elementsEqual([songOne]))
        performance.removeSong(song: songOne)
        XCTAssertTrue(performance.getSongs().isEmpty)
    }

    func testUpdateSong() {
        performance.addSong(song: songOne)
        XCTAssertTrue(performance.getSongs().elementsEqual([songOne]))
        performance.addSong(song: songTwo)
        XCTAssertTrue(performance.getSongs().elementsEqual([songOne, songTwo]))
        performance.updateSong(oldSong: songOne, newSong: songTwo)
        XCTAssertTrue(performance.getSongs().elementsEqual([songTwo, songTwo]))
    }

    func testRemoveAllSongs() {
        XCTAssertTrue(performance.hasNoSongs)

        performance.addSong(song: songOne)
        performance.addSong(song: songTwo)

        XCTAssertFalse(performance.hasNoSongs)
        performance.removeAllSongs()
        XCTAssertTrue(performance.hasNoSongs)
    }
}
