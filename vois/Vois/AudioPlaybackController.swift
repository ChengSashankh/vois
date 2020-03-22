//
//  AudioPlaybackController.swift
//  Vois
//
//  Created by Sudharshan Madhavan on 21/3/20.
//  Copyright © 2020 Vois. All rights reserved.
//

import Foundation
import UIKit
import FDWaveformView

class AudioPlaybackController: UIViewController, FDPlaybackDelegate {

    var fileURL: URL!
    var audioPlayer: AudioPlayer!
    private var displayLink: CADisplayLink!
    var textCommentButtons = [TextCommentButton]()

    @IBOutlet private var uiSlider: UISlider!
    @IBOutlet private var uiSongLabel: UILabel!
    @IBOutlet private var playPauseButton: UIButton!

    @IBOutlet private var uiWaveformView: FDWaveformView!

    override func viewDidLoad() {
        super.viewDidLoad()
        uiSlider.minimumValue = 0.0
        uiSlider.maximumValue = Float(audioPlayer.audioLength)
        uiSlider.setValue(0.0, animated: false)

        uiSongLabel.text = audioPlayer.audioName()

        displayLink = CADisplayLink(target: self, selector: #selector(step))
        displayLink.add(to: .current, forMode: .default)

        uiWaveformView.audioURL = audioPlayer.getAudioURL()
        uiWaveformView.progressColor = .cyan
        uiWaveformView.wavesColor = .blue

        refreshView()
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
        refreshView()
    }

    func resumeLoop() {
        displayLink.isPaused = false
    }

    @objc func step() {
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

    @IBAction func makeTextComment(_ sender: UIButton) {
        guard let controller = storyboard?.instantiateViewController(withIdentifier: "TextCommentController") as? TextCommentController else {
            return
        }

        audioPlayer.pause()

        controller.addCommentClosure = { text in
            let comment = TextComment(timeStamp: self.audioPlayer.currentTime, author: "Reviewer", text: text)
            RecordingTable.addTextComment(nameOfRecording: self.audioPlayer.audioName(), comment: comment)
            self.uiWaveformView.addComment(audioLength: self.audioPlayer.audioLength, textComment: comment, delegate: self)
            self.audioPlayer.playFrom(time: self.audioPlayer.currentTime)
            do {
                try RecordingTable.saveRecordingsToStorage()
            } catch {
                //print("RIP")
            }
        }
        present(controller, animated: true)
    }

    private func refreshView() {
        //print(textCommentButtons)
        uiWaveformView.removeTextCommentButtons(from: self)
        let textComments = RecordingTable.getTextComments(nameOfRecording: audioPlayer.audioName())
        textComments.forEach({ self.uiWaveformView.addComment(audioLength: audioPlayer.audioLength, textComment: $0, delegate: self) })
        //print(textCommentButtons)
    }
}
