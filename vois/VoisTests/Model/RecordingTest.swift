//
//  RecordingTest.swift
//  VoisTests
//
//  Created by Tan Yong He on 20/3/20.
//  Copyright © 2020 Vois. All rights reserved.
//

import XCTest
@testable import Vois

class RecordingTest: XCTestCase {
    let recording = Recording(filePath: URL(fileURLWithPath: "/recording/audio_one.mp3"))
    let audioCommentOne = AudioComment(timeStamp: 1584204199,
                                  author: "John Doe",
                                  filePath: URL(fileURLWithPath: "/recording/audio_two.mp3"))
    let audioCommentTwo = AudioComment(timeStamp: 1584204190,
                                       author: "John Doe",
                                       filePath: URL(fileURLWithPath: "/recording/audio.mp3"))
    let textCommentOne = TextComment(timeStamp: 1584204199,
                                  author: "John Doe",
                                  text: "Nice pitch!")
    let textCommentTwo = TextComment(timeStamp: 1584204190,
                                     author: "John Doe",
                                     text: "Nice volume!")

    func testNoComments() {
        XCTAssertTrue(recording.hasNoComments)
    }

    func testOnlyHasAudioComments() {
        XCTAssertTrue(recording.hasNoComments)
        recording.addAudioComment(audioComment: audioCommentOne)
        XCTAssertFalse(recording.hasNoAudioComments)
        XCTAssertTrue(recording.hasNoTextComments)
    }

    func testOnlyHasTextComments() {
        XCTAssertTrue(recording.hasNoComments)
        recording.addTextComment(textComment: textCommentOne)
        XCTAssertTrue(recording.hasNoAudioComments)
        XCTAssertFalse(recording.hasNoTextComments)
    }

    func testHasComments() {
        XCTAssertTrue(recording.hasNoComments)
        recording.addAudioComment(audioComment: audioCommentOne)
        recording.addTextComment(textComment: textCommentOne)
        XCTAssertFalse(recording.hasNoAudioComments)
        XCTAssertFalse(recording.hasNoTextComments)
    }

    func testNumOfAudioComments() {
        XCTAssertEqual(recording.numOfAudioComments, 0)
        recording.addAudioComment(audioComment: audioCommentOne)
        XCTAssertEqual(recording.numOfAudioComments, 1)
        recording.addAudioComment(audioComment: audioCommentTwo)
        XCTAssertEqual(recording.numOfAudioComments, 2)
        recording.updateAudioComment(oldAudioComment: audioCommentOne, newAudioComment: audioCommentTwo)
        XCTAssertEqual(recording.numOfAudioComments, 2)
        recording.removeAudioComment(audioComment: audioCommentTwo)
        XCTAssertEqual(recording.numOfAudioComments, 1)
        recording.removeAllAudioComments()
        XCTAssertEqual(recording.numOfAudioComments, 0)
    }

    func testNumOfTextComments() {
        XCTAssertEqual(recording.numOfTextComments, 0)
        recording.addTextComment(textComment: textCommentOne)
        XCTAssertEqual(recording.numOfTextComments, 1)
        recording.addTextComment(textComment: textCommentTwo)
        XCTAssertEqual(recording.numOfTextComments, 2)
        recording.updateTextComment(oldTextComment: textCommentOne, newTextComment: textCommentTwo)
        XCTAssertEqual(recording.numOfTextComments, 2)
        recording.removeTextComment(textComment: textCommentTwo)
        XCTAssertEqual(recording.numOfTextComments, 1)
        recording.removeAllTextComments()
        XCTAssertEqual(recording.numOfTextComments, 0)
    }

    func testAddAudioComments() {
        recording.addAudioComment(audioComment: audioCommentOne)
        XCTAssertTrue(recording.getAudioComments().elementsEqual([audioCommentOne]))
        recording.addAudioComment(audioComment: audioCommentTwo)
        XCTAssertTrue(recording.getAudioComments().elementsEqual([audioCommentOne, audioCommentTwo]))
        recording.addAudioComment(audioComment: audioCommentOne)
        XCTAssertTrue(recording.getAudioComments().elementsEqual([audioCommentOne, audioCommentTwo, audioCommentOne]))
    }

    func testRemoveAudioComments() {
        recording.addAudioComment(audioComment: audioCommentOne)
        recording.addAudioComment(audioComment: audioCommentTwo)
        recording.addAudioComment(audioComment: audioCommentOne)

        recording.removeAudioComment(audioComment: audioCommentTwo)
        XCTAssertTrue(recording.getAudioComments().elementsEqual([audioCommentOne, audioCommentOne]))
        recording.removeAudioComment(audioComment: audioCommentOne)
        XCTAssertTrue(recording.getAudioComments().elementsEqual([audioCommentOne]))
        recording.removeAudioComment(audioComment: audioCommentOne)
        XCTAssertTrue(recording.getAudioComments().isEmpty)
    }

    func testUpdateAudioComments() {
        recording.addAudioComment(audioComment: audioCommentOne)
        XCTAssertTrue(recording.getAudioComments().elementsEqual([audioCommentOne]))
        recording.addAudioComment(audioComment: audioCommentTwo)
        XCTAssertTrue(recording.getAudioComments().elementsEqual([audioCommentOne, audioCommentTwo]))
        recording.updateAudioComment(oldAudioComment: audioCommentOne, newAudioComment: audioCommentTwo)
        XCTAssertTrue(recording.getAudioComments().elementsEqual([audioCommentTwo, audioCommentTwo]))
    }

    func testAddTextComments() {
        recording.addTextComment(textComment: textCommentOne)
        XCTAssertTrue(recording.getTextComments().elementsEqual([textCommentOne]))
        recording.addTextComment(textComment: textCommentTwo)
        XCTAssertTrue(recording.getTextComments().elementsEqual([textCommentOne, textCommentTwo]))
        recording.addTextComment(textComment: textCommentOne)
        XCTAssertTrue(recording.getTextComments().elementsEqual([textCommentOne, textCommentTwo, textCommentOne]))
    }

    func testRemoveTextComments() {
        recording.addTextComment(textComment: textCommentOne)
        recording.addTextComment(textComment: textCommentTwo)
        recording.addTextComment(textComment: textCommentOne)

        recording.removeTextComment(textComment: textCommentTwo)
        XCTAssertTrue(recording.getTextComments().elementsEqual([textCommentOne, textCommentOne]))
        recording.removeTextComment(textComment: textCommentOne)
        XCTAssertTrue(recording.getTextComments().elementsEqual([textCommentOne]))
        recording.removeTextComment(textComment: textCommentOne)
        XCTAssertTrue(recording.getTextComments().isEmpty)
    }

    func testUpdateTextComments() {
        recording.addTextComment(textComment: textCommentOne)
        XCTAssertTrue(recording.getTextComments().elementsEqual([textCommentOne]))
        recording.addTextComment(textComment: textCommentTwo)
        XCTAssertTrue(recording.getTextComments().elementsEqual([textCommentOne, textCommentTwo]))
        recording.updateTextComment(oldTextComment: textCommentOne, newTextComment: textCommentTwo)
        XCTAssertTrue(recording.getTextComments().elementsEqual([textCommentTwo, textCommentTwo]))
    }

    func testRemoveAllAudioComments() {
        XCTAssertTrue(recording.hasNoAudioComments)
        XCTAssertTrue(recording.hasNoTextComments)

        recording.addAudioComment(audioComment: audioCommentOne)
        recording.addAudioComment(audioComment: audioCommentTwo)
        XCTAssertFalse(recording.hasNoAudioComments)
        XCTAssertTrue(recording.hasNoTextComments)

        recording.removeAllAudioComments()
        XCTAssertTrue(recording.hasNoAudioComments)
        XCTAssertTrue(recording.hasNoTextComments)
    }

    func testRemoveAllTextComments() {
        XCTAssertTrue(recording.hasNoAudioComments)
        XCTAssertTrue(recording.hasNoTextComments)

        recording.addTextComment(textComment: textCommentOne)
        recording.addTextComment(textComment: textCommentTwo)
        XCTAssertTrue(recording.hasNoAudioComments)
        XCTAssertFalse(recording.hasNoTextComments)

        recording.removeAllTextComments()
        XCTAssertTrue(recording.hasNoAudioComments)
        XCTAssertTrue(recording.hasNoTextComments)
    }

    func testRemoveAllComments() {
        XCTAssertTrue(recording.hasNoComments)

        recording.addAudioComment(audioComment: audioCommentOne)
        recording.addTextComment(textComment: textCommentOne)

        XCTAssertFalse(recording.hasNoComments)
        recording.removeAllComments()
        XCTAssertTrue(recording.hasNoComments)
    }
}
