//
//  RecordingControllerTests.swift
//  VoisTests
//
//  Created by Sashankh Chengavalli Kumar on 22.03.20.
//  Copyright © 2020 Vois. All rights reserved.
//

import XCTest
import AVFoundation
@testable import Vois

class RecordingControllerTests: XCTestCase, AVAudioRecorderDelegate {
    let recordingController = RecordingController()
    let nameWithTrailingSpace = "name with trailing spaces    "
    let nameWithLeadingSpace = "  name with trailing spaces"
    let trimmedName = "name with trailing spaces"

    // Boundary values
    let logScaleValues: [Float] = [-160.0, 0.0]
    let linearScaleValues: [Float] = [1e-6, 100.0]

    func testIsRecordingInProgress() {
        XCTAssertFalse(recordingController.recordingInProgress)
    }

    func testCurrentRecordingDuration() {
        XCTAssertEqual(recordingController.currentRecordingDuration, TimeInterval())
    }

    func testGetTrimmedName() {
        XCTAssertEqual(
            trimmedName,
            recordingController.getTrimmedName(fileName: nameWithLeadingSpace)
        )
        XCTAssertEqual(
            trimmedName,
            recordingController.getTrimmedName(fileName: nameWithTrailingSpace)
        )
    }

    func testLogToLinearConversion() {
        XCTAssertEqual(
            recordingController.convertLogScalePowerToLinear(logScaleValue: logScaleValues[0]),
            linearScaleValues[0]
        )

        XCTAssertEqual(
            recordingController.convertLogScalePowerToLinear(logScaleValue: logScaleValues[1]),
            linearScaleValues[1]
        )
    }

    func testRenameRecording() {
        let oldURL = recordingController.getRecordingDirectoryPath().appendingPathComponent("testfile.txt")
        do {
            try "Sample text".write(to: oldURL, atomically: true, encoding: .utf8)
        } catch {
            XCTFail("Could not write file to documents directory")
        }
        XCTAssertTrue(recordingController.getRecordings().contains(oldURL))

        let newURL = recordingController.getRecordingDirectoryPath().appendingPathComponent("testfile_new.txt")

        XCTAssertTrue(recordingController.renameRecording(atPath: oldURL, toPath: newURL))
        XCTAssertFalse(recordingController.getRecordings().contains(oldURL))
        XCTAssertTrue(recordingController.getRecordings().contains(newURL))
    }

    func testDiscardRecording() {
        let newURL = recordingController.getRecordingDirectoryPath().appendingPathComponent("testfile_new.txt")
        XCTAssertTrue(recordingController.getRecordings().contains(newURL))

        XCTAssertTrue(recordingController.discardRecording(atPath: newURL))
        XCTAssertFalse(recordingController.getRecordings().contains(newURL))
    }

    func testDiscardRecording_shouldReturnFalseForFakeFileName() {
        let newURL = recordingController.getRecordingDirectoryPath().appendingPathComponent("nonexistent.txt")
        XCTAssertFalse(recordingController.getRecordings().contains(newURL))
        XCTAssertFalse(recordingController.discardRecording(atPath: newURL))
    }

    func testStartRecording() {
        recordingController.startRecording(recorderDelegate: self)
        XCTAssertTrue(recordingController.recordingInProgress)
        XCTAssertTrue(recordingController.audioRecorder.isMeteringEnabled)
    }

    func testStopRecording() {
        recordingController.stopRecording()
        XCTAssertFalse(recordingController.recordingInProgress)
    }

}
