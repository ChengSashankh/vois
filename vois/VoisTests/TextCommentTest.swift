//
//  TextCommentTest.swift
//  VoisTests
//
//  Created by Tan Yong He on 14/3/20.
//  Copyright © 2020 Vois. All rights reserved.
//

import XCTest
@testable import Vois

class TextCommentTest: XCTestCase {
    var comment = TextComment(timeStamp: 1584204199,
                              author: "John Doe",
                              text: "Nice pitch!")
    let equalComment = TextComment(timeStamp: 1584204199,
                              author: "John Doe",
                              text: "Nice pitch!")
    let unequalCommentOne = TextComment(timeStamp: 1584204190,
                              author: "John Doe",
                              text: "Nice pitch!")
    let unequalCommentTwo = TextComment(timeStamp: 1584204199,
                                        author: "John D.",
                                        text: "Nice pitch!")
    let unequalCommentThree = TextComment(timeStamp: 1584204199,
                                          author: "John Doe",
                                          text: "Nice vocals!")

    func testGetText() {
        XCTAssertEqual(comment.getText(), "Nice pitch!")
        XCTAssertNotEqual(comment.getText(), "I love it!")
    }

    func testEqualComment() {
        XCTAssertEqual(comment, equalComment)
    }

    func testUnequalComment() {
        XCTAssertNotEqual(comment, unequalCommentOne)
        XCTAssertNotEqual(comment, unequalCommentTwo)
        XCTAssertNotEqual(comment, unequalCommentThree)
    }

    func testSetText() {
        comment.setText(newText: "I love it!")
        XCTAssertEqual(comment.getText(), "I love it!")
        XCTAssertNotEqual(comment.getText(), "Nice pitch!")
    }
}
