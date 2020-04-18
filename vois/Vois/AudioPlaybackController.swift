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

    private var displayLink: CADisplayLink!
    var recording: Recording!
    var recordingList: [Recording]!
    var audioPlayer: AudioPlayer!
    var textCommentButtons = [TextCommentButton]()

    @IBOutlet private var uiSlider: UISlider!
    @IBOutlet private var uiSongLabel: UILabel!
    @IBOutlet private var playPauseButton: UIButton!

    @IBOutlet private var uiWaveformView: FDWaveformView!

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        uiSongLabel.text = recording.name
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        displayLink = CADisplayLink(target: self, selector: #selector(step))
        displayLink.add(to: .current, forMode: .default)
        self.audioPlayer = AudioPlayer(audioFileURL: recording.filePath,
        recordingList: recordingList.map { $0.filePath })
        uiSlider.minimumValue = 0.0
        uiSlider.maximumValue = Float(audioPlayer.audioLength)
        uiSlider.setValue(0.0, animated: false)
        uiWaveformView.audioURL = audioPlayer.getAudioURL()
        uiWaveformView.progressColor = .cyan
        uiWaveformView.wavesColor = .blue
        refreshView()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is AudioEditController {
            guard let audioEditVC = segue.destination as? AudioEditController else {
                return
            }
            audioEditVC.setAudioURL(url: recording.filePath, recordingList: self.audioPlayer.recordings)
        }
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

    private func getCurrentRecording() -> Recording? {
        recordingList.first { $0.filePath == audioPlayer.getAudioURL() }
    }

    private func refresh() {
        audioPlayer.updatePlayer()
        uiSlider.maximumValue = Float(audioPlayer.audioLength)
        uiSongLabel.text = getCurrentRecording()?.name ?? audioPlayer.audioName()
        refreshButtonImage()
        uiWaveformView.audioURL = audioPlayer.getAudioURL()
        refreshView()
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

    @IBAction func makeTextComment(_ sender: UIButton) {
        guard let controller = storyboard?.instantiateViewController(withIdentifier: "TextCommentController")
            as? TextCommentController else {
            return
        }

        audioPlayer.pause()

        controller.addCommentClosure = { text in
            let comment = TextComment(timeStamp: self.audioPlayer.currentTime, author: "Reviewer", text: text)
            self.recording.addTextComment(textComment: comment)
            self.uiWaveformView.addComment(
                audioLength: self.audioPlayer.audioLength,
                textComment: comment,
                delegate: self)
            self.audioPlayer.playFrom(time: self.audioPlayer.currentTime)
        }
        present(controller, animated: true)
    }

    private func refreshView() {
        uiWaveformView.removeTextCommentButtons(from: self)
        let textComments = recording.getTextComments()
        textComments.forEach({ self.uiWaveformView.addComment(
            audioLength: audioPlayer.audioLength,
            textComment: $0,
            delegate: self) })
    }
}
