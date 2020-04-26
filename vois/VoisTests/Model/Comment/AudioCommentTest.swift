//
//  AudioCommentTest.swift
//  VoisTests
//
//  Created by Tan Yong He on 14/3/20.
//  Copyright © 2020 Vois. All rights reserved.
//

import XCTest
@testable import Vois

class AudioCommentTest: XCTestCase {
    let comment = AudioComment(timeStamp: 1_584_204_199,
                               author: "John Doe",
                               filePath: URL(fileURLWithPath: "/recording/audio.mp3"))
    let equalComment = AudioComment(timeStamp: 1_584_204_199,
                                    author: "John Doe",
                                    filePath: URL(fileURLWithPath: "/recording/audio.mp3"))
    let unequalCommentOne = AudioComment(timeStamp: 1_584_204_190,
                                         author: "John Doe",
                                         filePath: URL(fileURLWithPath: "/recording/audio.mp3"))
    let unequalCommentTwo = AudioComment(timeStamp: 1_584_204_199,
                                         author: "John D.",
                                         filePath: URL(fileURLWithPath: "/recording/audio.mp3"))
    let unequalCommentThree = AudioComment(timeStamp: 1_584_204_199,
                                           author: "John Doe",
                                           filePath: URL(fileURLWithPath: "/recording/song.mp3"))

    func testGetFilePath() {
        XCTAssertEqual(comment.filePath, URL(fileURLWithPath: "/recording/audio.mp3"))
        XCTAssertNotEqual(comment.filePath, URL(fileURLWithPath: "/recording/song.mp3"))
    }

    func testEqualComment() {
        XCTAssertEqual(comment, equalComment)
    }

    func testUnequalComment() {
        XCTAssertFalse(comment == unequalCommentOne)
        XCTAssertFalse(comment == unequalCommentTwo)
        XCTAssertFalse(comment == unequalCommentThree)
    }
}
