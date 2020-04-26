//
//  AudioEditController.swift
//  Vois
//
//  Created by Tan Yong He on 31/3/20.
//  Copyright © 2020 Vois. All rights reserved.
//

import UIKit
import AVFoundation
import FDWaveformView

class AudioEditController: UIViewController, FDPlaybackDelegate, UITextFieldDelegate {

    var fileURL: URL!
    var audioPlayer: AudioPlayer!
    private var displayLink: CADisplayLink!
    var textCommentButtons = [TextCommentButton]()
    var audioCommentButtons = [AudioCommentButton]()
    private var minimumValue: Float = 0.0
    private var maximumValue: Float = 0.0

    @IBOutlet private var uiSlider: UISlider!
    @IBOutlet private var uiSongLabel: UILabel!
    @IBOutlet private var playPauseButton: UIButton!
    @IBOutlet private var uiWaveformView: FDWaveformView!

    @IBOutlet weak var trimAudioName: UITextField!
    @IBOutlet weak var trimStartTime: UITextField!
    @IBOutlet weak var trimEndTime: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        //print(NSHomeDirectory())
        self.minimumValue = 0.0
        self.maximumValue = Float(audioPlayer.audioLength)

        // Set delegates for restricting UTTextField input
        trimAudioName.delegate = self
        trimStartTime.delegate = self
        trimEndTime.delegate = self

        // Set default value for UITextFields
        trimAudioName.text = "audio_trimmed"
        trimStartTime.text = String(self.minimumValue)
        trimEndTime.text = String(self.maximumValue)

        uiSlider.minimumValue = self.minimumValue
        uiSlider.maximumValue = self.maximumValue
        uiSlider.setValue(0.0, animated: false)

        uiSongLabel.text = audioPlayer.audioName()

        displayLink = CADisplayLink(target: self, selector: #selector(step))
        displayLink.add(to: .current, forMode: .default)

        uiWaveformView.audioURL = audioPlayer.getAudioURL()
        uiWaveformView.progressColor = .cyan
        uiWaveformView.wavesColor = .blue

        //refreshView()
    }

    //override func beginTracking(_ touch: UITouch, with //event: UIEvent?) -> Bool {
  //      previousLocation = touch.location(in: self)
//
      //  if lowerThumb
    //}

    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        switch textField.tag {
        case UITextFieldIdentifier.trimTime.rawValue:
            // Checks for at most one decimal point.
            var dotCount = 0
            let typedCharacters = [Character](textField.text ?? "")
            for char in typedCharacters where char == "." {
                dotCount += 1
            }

            // Checks for allowed characters (numerical and decimal) only.
            var allowedCharacters = ".1234567890"
            if dotCount > 0 {
                allowedCharacters = "1234567890"
            }
            let allowedCharacterSet = CharacterSet(charactersIn: allowedCharacters)
            let typedCharacterSet = CharacterSet(charactersIn: string)
            return allowedCharacterSet.isSuperset(of: typedCharacterSet)

        case UITextFieldIdentifier.fileName.rawValue:
            let allowedCharacters = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz1234567890_"
            let allowedCharacterSet = CharacterSet(charactersIn: allowedCharacters)
            let typedCharacterSet = CharacterSet(charactersIn: string)
            return allowedCharacterSet.isSuperset(of: typedCharacterSet)

        default:
            return true
        }
    }

    func setAudioURL(url: URL, recordingList: [URL]) {
        self.fileURL = url
        self.audioPlayer = AudioPlayer(audioFileURL: fileURL, recordingList: recordingList)
    }

    @IBAction private func forwardEnd(_ sender: UIButton) {
        audioPlayer.forwardEnd()
        audioPlayer.next()
        refresh()
    }

    @IBAction private func play(_ sender: UIButton) {
        if audioPlayer.isPlaying {
            audioPlayer.pause()
        } else {
            resumeLoop()
            audioPlayer.playFrom(time: Double(uiSlider!.value))
        }
        refreshButtonImage()
    }

    func pause() {
        audioPlayer.pause()
    }

    @IBAction private func backwardEnd(_ sender: UIButton) {
        if audioPlayer.currentTime < 0.1 {
            audioPlayer.pause()
            audioPlayer.prev()
        }
        audioPlayer.backwardEnd()
        refresh()
    }

    private func refreshButtonImage() {
        if audioPlayer.isPlaying {
            playPauseButton.setImage(UIImage(systemName: "pause.circle.fill"), for: .normal)
        } else {
            playPauseButton.setImage(UIImage(systemName: "play.circle.fill"), for: .normal)
        }
    }

    private func refresh() {
        audioPlayer.updatePlayer()
        uiSlider.maximumValue = Float(audioPlayer.audioLength)
        uiSongLabel.text = audioPlayer.audioName()
        refreshButtonImage()
        uiWaveformView.audioURL = audioPlayer.getAudioURL()
    }

    func resumeLoop() {
        displayLink.isPaused = false
    }

    @objc
    func step() {
        if uiSlider.isHighlighted {
            displayLink?.isPaused = true
            audioPlayer.pause()
        } else {
            uiSlider.setValue(Float(audioPlayer.currentTime), animated: false)
        }
        refreshButtonImage()
        let ratio = audioPlayer.currentTime / audioPlayer.audioLength
        uiWaveformView.highlightedSamples = Range((0...Int(Double(uiWaveformView.totalSamples) * ratio)))
    }

    @IBAction private func trim(_ sender: Any) {
        guard let trimStartField = trimStartTime.text,
            let trimEndField = trimEndTime.text,
            let trimAudioNameField = trimAudioName.text else {
            return
        }
        if trimStartField.isEmpty || trimEndField.isEmpty || trimAudioNameField.isEmpty {
            print("Trim fields should not be empty.")
            return
        }

        let trimAudioFileName = trimAudioNameField + ".m4a"

        let asset = AVAsset(url: self.fileURL)
        self.exportAsset(asset: asset, fileName: trimAudioFileName,
                         startTimeValue: Float(trimStartField) ?? self.minimumValue,
                         endTimeValue: Float(trimEndField) ?? self.maximumValue)
        return
    }

    func exportAsset(asset: AVAsset, fileName: String, startTimeValue: Float, endTimeValue: Float) {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let trimmedAudioURL = documentsDirectory.appendingPathComponent(fileName)
        print("Saving to \(trimmedAudioURL.absoluteString)")

        if FileManager.default.fileExists(atPath: trimmedAudioURL.absoluteString) {
            print("Sound exists; removing \(trimmedAudioURL.absoluteString)")
            do {
                if try trimmedAudioURL.checkResourceIsReachable() {
                    print("File is reachable")
                }

                try FileManager.default.removeItem(atPath: trimmedAudioURL.absoluteString)
            } catch {
                print("Could not remove \(trimmedAudioURL.absoluteString)")
                print(error.localizedDescription)
            }
        }

        print("Creating export session for \(asset)")

        if let exporter = AVAssetExportSession(asset: asset, presetName: AVAssetExportPresetAppleM4A) {
            exporter.outputFileType = AVFileType.m4a
            exporter.outputURL = trimmedAudioURL

            let duration = CMTimeGetSeconds(asset.duration)
            if duration < 5.0 {
                print("Audio duration too short")
                return
            }

            // Multiply values to cater digits after decimal point as CMTimeMake only allows Int64.
            let startTime = CMTimeMake(value: Int64(startTimeValue * 1_000), timescale: 1_000)
            let stopTime = CMTimeMake(value: Int64(endTimeValue * 1_000), timescale: 1_000)
            exporter.timeRange = CMTimeRangeFromTimeToTime(start: startTime, end: stopTime)

            exporter.exportAsynchronously(completionHandler: {
                print("export complete \(exporter.status)")

                switch exporter.status {
                case AVAssetExportSessionStatus.failed:
                    if let exportError = exporter.error {
                        print("export failed \(exportError)")
                    }
                case AVAssetExportSessionStatus.cancelled:
                    print("export cancelled \(String(describing: exporter.error))")
                default:
                    print("export completed")
                }
            })
        } else {
            print("cannot create AVAssetExportSession for asset \(asset)")
        }
        self.promptReplaceAudio(newAudioURL: trimmedAudioURL)
    }

    // Message prompt assumes successful audio trimming because the asset export process
    // is asynchronous and may not have finished by then.
    private func promptReplaceAudio(newAudioURL: URL) {
        let alert = UIAlertController(title: "Audio Edit",
                                      message: "Replace current audio with trimmed audio if successful?",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .default) { _ in
            self.audioPlayer.recordings.append(newAudioURL)
            self.setAudioURL(url: newAudioURL, recordingList: self.audioPlayer.recordings)
            self.refresh()
        })
        alert.addAction(UIAlertAction(title: "No", style: .cancel) { _ in
            self.dismiss(animated: true, completion: nil)
        })
        self.present(alert, animated: true, completion: nil)
    }
}

enum UITextFieldIdentifier: Int {
    case trimTime = 1
    case fileName = 2
    case allElse = 0
}
