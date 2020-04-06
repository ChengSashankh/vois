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
    let audioComment = AudioComment(
        timeStamp: 1584204199,
        author: "John Doe",
        filePath: URL(fileURLWithPath: "/recording/audio.mp3")
    )

    let textComment = TextComment(timeStamp: 1584204199,
                                  author: "John Doe",
                                  text: "Nice pitch!")

    func testGetTimeStamp() {
        XCTAssertEqual(audioComment.timeStamp, 1584204199)
        XCTAssertNotEqual(audioComment.timeStamp, 1584204190)

        XCTAssertEqual(textComment.timeStamp, 1584204199)
        XCTAssertNotEqual(textComment.timeStamp, 1584204190)
    }

    func testGetAuthor() {
        XCTAssertEqual(audioComment.author, "John Doe")
        XCTAssertNotEqual(audioComment.author, "John D.")

        XCTAssertEqual(textComment.author, "John Doe")
        XCTAssertNotEqual(textComment.author, "John D.")
    }

    func testSetTimeStamp() {
        audioComment.timeStamp = 1584204190
        XCTAssertEqual(audioComment.timeStamp, 1584204190)
        XCTAssertNotEqual(audioComment.timeStamp, 1584204199)

        textComment.timeStamp = 1584204190
        XCTAssertEqual(textComment.timeStamp, 1584204190)
        XCTAssertNotEqual(textComment.timeStamp, 1584204199)
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
