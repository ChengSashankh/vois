//
//  RecordingController.swift
//  Vois
//
//  Created by Sashankh Chengavalli Kumar on 15.03.20.
//  Copyright © 2020 Vois. All rights reserved.
//

import Foundation
import AVFoundation

class RecordingController {
    var recordingSession: AVAudioSession
    var audioRecorder: AVAudioRecorder

    var recordingInProgress: Bool {
        audioRecorder.isRecording
    }

    var currentRecordingDuration: TimeInterval {
        audioRecorder.currentTime
    }

    init() {
        self.recordingSession = AVAudioSession()
        self.audioRecorder = AVAudioRecorder()
    }

    func getTrimmedName(fileName: String) -> String {
        let trimmedString = fileName
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .trimmingCharacters(in: .punctuationCharacters)
        return trimmedString
    }

    func convertLogScalePowerToLinear(logScaleValue: Float) -> Float {
        let linearScaleValue = pow(10.0, logScaleValue / 20.0) * 100.0
        return linearScaleValue
    }

    func getCurrentRecordingPower() -> Float {
        audioRecorder.updateMeters()
        let logScalePower = audioRecorder.peakPower(forChannel: 0)
        let linearScaleValue = convertLogScalePowerToLinear(logScaleValue: logScalePower)
        return linearScaleValue
    }

    func discardRecording() -> Bool {
        guard let userName = UserSession.currentUserName else {
            return false
        }
        do {
            try PerformanceFilesDirectory.removeTemporaryRecording(for: userName)
            return true
        } catch {
            return false
        }
    }

    func startRecording(recorderDelegate: AVAudioRecorderDelegate) -> Bool {
        if recordingInProgress {
            return false
        }

        guard let userName = UserSession.currentUserName,
            let recordingFilePath = PerformanceFilesDirectory.getTemporaryRecordingUrl(for: userName) else {
            return false
        }

        let settingsDict = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12_000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]

        do {
            audioRecorder = try AVAudioRecorder(
                url: recordingFilePath,
                settings: settingsDict
            )

            audioRecorder.prepareToRecord()
            audioRecorder.isMeteringEnabled = true
            audioRecorder.record()
            audioRecorder.delegate = recorderDelegate
        } catch {
            return false
        }

        return true
    }

    func stopRecording() {
        if !recordingInProgress {
            return
        }

        audioRecorder.stop()
    }

}
