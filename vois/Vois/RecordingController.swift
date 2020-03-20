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
    var recordingCounter: Int

    var recordingInProgress: Bool {
        audioRecorder.isRecording
    }

    var currentRecordingDuration: TimeInterval {
        audioRecorder.currentTime
    }

    init(recordingCounter: Int) {
        self.recordingSession = AVAudioSession()
        self.audioRecorder = AVAudioRecorder()
        self.recordingCounter = recordingCounter
    }

    convenience init() {
        self.init(recordingCounter: 0)
    }

    func getDefaultFileName() -> String {
        recordingCounter += 1
        return String("Recording_\(recordingCounter).m4a")
    }

    func getRecordingDirectoryPath() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectoryPath = paths[0]
        return documentDirectoryPath
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

    func discardRecording(atPath: URL) -> Bool {
        let fileManager = FileManager()

        do {
            try fileManager.removeItem(at: atPath)
        } catch {
            return false
        }

        return true
    }

    func renameRecording(atPath: URL, toPath: URL) -> Bool {
        let fileManager = FileManager()

        do {
            try fileManager.moveItem(at: atPath, to: toPath)
        } catch {
            return false
        }

        return true
    }

    func startRecording(recorderDelegate: AVAudioRecorderDelegate) {
        if recordingInProgress {
            return
        }

        let recordingFileName = getDefaultFileName()
        let recordingFilePath = getRecordingDirectoryPath().appendingPathComponent(recordingFileName)

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
            // TODO: Handle error correctly
            print("Something went wrong here!")
        }
    }

    func stopRecording() {
        if !recordingInProgress {
            return
        }

        UserDefaults.standard.set(recordingCounter, forKey: "recordingCounter")
        audioRecorder.stop()
    }

    func getRecordings() -> [URL] {
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        do {
            let fileURLs = try
                FileManager.default.contentsOfDirectory(at: documentsURL, includingPropertiesForKeys: nil)
            return fileURLs
        } catch {
            print("Error while enumerating files \(documentsURL.path): \(error.localizedDescription)")
            return [URL]()
        }
    }

}
