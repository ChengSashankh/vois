//
//  CommentTest.swift
//  VoisTests
//
//  Created by Tan Yong He on 15/3/20.
//  Copyright © 2020 Vois. All rights reserved.
//

import XCTest
@testable import Vois

class CommentTest: XCTestCase {
<<<<<<< HEAD
    let audioComment = AudioComment(
        timeStamp: 1584204199,
        author: "John Doe",
        filePath: URL(fileURLWithPath: "/recording/audio.mp3")
    )

    let textComment = TextComment(timeStamp: 1584204199,
=======
    let audioComment = AudioComment(timeStamp: 1_584_204_199,
                                    author: "John Doe",
                                    filePath: URL(fileURLWithPath: "/recording/audio.mp3"))
    let textComment = TextComment(timeStamp: 1_584_204_199,
>>>>>>> d219b25cc48572af0cd4a35ce69d9f944149cccb
                                  author: "John Doe",
                                  text: "Nice pitch!")

    func testGetTimeStamp() {
        XCTAssertEqual(audioComment.timeStamp, 1_584_204_199)
        XCTAssertNotEqual(audioComment.timeStamp, 1_584_204_190)

        XCTAssertEqual(textComment.timeStamp, 1_584_204_199)
        XCTAssertNotEqual(textComment.timeStamp, 1_584_204_190)
    }

    func testGetAuthor() {
        XCTAssertEqual(audioComment.author, "John Doe")
        XCTAssertNotEqual(audioComment.author, "John D.")

        XCTAssertEqual(textComment.author, "John Doe")
        XCTAssertNotEqual(textComment.author, "John D.")
    }

    func testSetTimeStamp() {
        audioComment.timeStamp = 1_584_204_190
        XCTAssertEqual(audioComment.timeStamp, 1_584_204_190)
        XCTAssertNotEqual(audioComment.timeStamp, 1_584_204_199)

        textComment.timeStamp = 1_584_204_190
        XCTAssertEqual(textComment.timeStamp, 1_584_204_190)
        XCTAssertNotEqual(textComment.timeStamp, 1_584_204_199)
    }

    func testSetAuthor() {
        audioComment.author = "John D."
        XCTAssertEqual(audioComment.author, "John D.")
        XCTAssertNotEqual(audioComment.author, "John Doe")

        textComment.author = "John D."
        XCTAssertEqual(textComment.author, "John D.")
        XCTAssertNotEqual(textComment.author, "John Doe")
    }
}
