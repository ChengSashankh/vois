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

    func testAddAudioComments() {
        recording.addAudioComment(audioComment: audioCommentOne)
        XCTAssertTrue(recording.getAudioComments().elementsEqual([audioCommentOne]))
        recording.addAudioComment(audioComment: audioCommentTwo)
        XCTAssertTrue(recording.getAudioComments().elementsEqual([audioCommentOne, audioCommentTwo]))
        recording.addAudioComment(audioComment: audioCommentOne)
        XCTAssertTrue(recording.getAudioComments().elementsEqual([audioCommentOne, audioCommentTwo, audioCommentOne]))
    }

    func testDeleteAudioComments() {
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

    func testAddTextComments() {
        recording.addTextComment(textComment: textCommentOne)
        XCTAssertTrue(recording.getTextComments().elementsEqual([textCommentOne]))
        recording.addTextComment(textComment: textCommentTwo)
        XCTAssertTrue(recording.getTextComments().elementsEqual([textCommentOne, textCommentTwo]))
        recording.addTextComment(textComment: textCommentOne)
        XCTAssertTrue(recording.getTextComments().elementsEqual([textCommentOne, textCommentTwo, textCommentOne]))
    }

    func testDeleteTextComments() {
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

    func testRemoveAllComments() {
        XCTAssertTrue(recording.hasNoComments)

        recording.addAudioComment(audioComment: audioCommentOne)
        XCTAssertFalse(recording.hasNoAudioComments)
        XCTAssertTrue(recording.hasNoTextComments)

        recording.addTextComment(textComment: textCommentOne)
        XCTAssertFalse(recording.hasNoAudioComments)
        XCTAssertFalse(recording.hasNoTextComments)

        recording.removeAllAudioComments()
        XCTAssertTrue(recording.hasNoAudioComments)
        XCTAssertFalse(recording.hasNoTextComments)

        recording.removeAllTextComments()
        XCTAssertTrue(recording.hasNoComments)
    }
}
