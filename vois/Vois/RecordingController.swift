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
        return audioRecorder.isRecording
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

    func startRecording(recorderDelegate: AVAudioRecorderDelegate) {
        if recordingInProgress {
            return
        }

        let recordingFileName = getDefaultFileName()
        let recordingFilePath = getRecordingDirectoryPath().appendingPathComponent(recordingFileName)

        let settingsDict = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]

        do {
            audioRecorder = try AVAudioRecorder(
                url: recordingFilePath,
                settings: settingsDict
            )

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

    func getCurrentRecordingDuration() -> TimeInterval {
        return audioRecorder.currentTime
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
