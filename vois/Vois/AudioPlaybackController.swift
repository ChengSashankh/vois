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
import AVFoundation

class AudioPlaybackController: UIViewController, FDPlaybackDelegate, AVAudioRecorderDelegate {

    private var displayLink: CADisplayLink!
    var recording: Recording!
    var recordingList: [Recording]!
    var creater: String?
    var commenter: String?
    var audioPlayer: AudioPlayer!
    var textCommentButtons = [TextCommentButton]()
    var audioCommentButtons = [AudioCommentButton]()

    @IBOutlet private var uiSlider: UISlider!
    @IBOutlet private var uiSongLabel: UILabel!
    @IBOutlet private var playPauseButton: UIButton!

    @IBOutlet weak var uiWaveformView: FDWaveformWithCommentView! {
        didSet {
            uiWaveformView.playbackDelegate = self
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        uiSongLabel.text = recording.name
        commenter = UserSession.currentUsername
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        recordingList.forEach { $0.updateRecording(handler: nil) }
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

        controller.commenter = commenter
        controller.creater = creater ?? commenter
        controller.addCommentClosure = { text in
            let comment = TextComment(timeStamp: self.audioPlayer.currentTime,
                                      author: UserSession.currentUsername ?? "Reviewer", text: text)
            self.recording.addTextComment(textComment: comment)
            self.uiWaveformView.addTextComment(author: comment.author, text: comment.text,
                                               timeStamp: comment.timeStamp, delegate: self)
            self.uiWaveformView.setNeedsDisplay()
            self.audioPlayer.playFrom(time: self.audioPlayer.currentTime)
        }
        present(controller, animated: true)
    }

    private func refreshView() {
        uiWaveformView.audioLength = audioPlayer.audioLength
        uiWaveformView.removeTextCommentButtons(from: self)
        let textComments = recording.getTextComments()
        textComments.forEach({ comment in
            self.uiWaveformView.addTextComment(author: comment.author, text: comment.text,
                                               timeStamp: comment.timeStamp, delegate: self)
        })
        let audioComments = recording.getAudioComments()
        audioComments.forEach( { comment in
            self.uiWaveformView.addAudioComment(author: comment.author,
                                                filePath: comment.filePath, timeStamp: comment.timeStamp)
        })
    }

    @objc func showComment(_ sender: TextCommentButton) {
        guard let author = sender.author, let text = sender.text, let delegate = sender.delegate else {
            return
        }

        let alert = UIAlertController(title: "Comment by " + author, message: text, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { _ in
            self.removeComment(sender: sender)
        }
        alert.addAction(action)
        alert.addAction(deleteAction)
        present(alert, animated: true)
    }

    private func removeComment(sender: TextCommentButton) {
        sender.removeFromSuperview()
        textCommentButtons.removeAll(where: { $0 == sender })
        recording.removeTextComment(textComment:
            TextComment(timeStamp: sender.timeStamp!, author: sender.author!, text: sender.text!) )
    }

    var recordingController: RecordingController!
    var audioCommentfilePath: URL!

    private let recordButtonImageName = "Record Button.png"
    private let stopButtonImageName = "Stop Button.png"

    @IBOutlet weak var audioCommentButton: UIButton! {
        didSet {
            let longPressGestureRecognizer =
                UILongPressGestureRecognizer(target: self, action: #selector(handleAudioComment(sender:)))
            audioCommentButton.addGestureRecognizer(longPressGestureRecognizer)
        }
    }

    @objc private func handleAudioComment(sender: UILongPressGestureRecognizer) {
        switch sender.state {
        case .began:
            guard let url = recording.generateAudioCommentUrl() else {
                return
            }
            audioPlayer.pause()
            recordingController = RecordingController(recordingFilePath: url)
            self.audioCommentfilePath = url
            startRecording()
            audioCommentButton.setImage(UIImage(named: stopButtonImageName), for: .normal)
        case .ended:
            stopRecording()
            audioCommentButton.setImage(UIImage(named: recordButtonImageName), for: .normal)
            showAudioCommentSaveController(for: audioCommentfilePath)
        default:
            break
        }
    }

    private func startRecording() {
        if !recordingController.startRecording(recorderDelegate: self) {
            displayErrorAlert(title: "Oops", message: "Could not start recording")
        }
    }

    func displayErrorAlert(title: String, message: String) {
           let uiErrorAlert = UIAlertController(title: title, message: message, preferredStyle: .alert)
           uiErrorAlert.addAction(UIAlertAction(title: "Okay", style: .cancel,handler: nil))
           present(uiErrorAlert, animated: true, completion: nil)
       }

    private func stopRecording() {
        recordingController.stopRecording()
    }

    private func showAudioCommentSaveController(for audioUrl: URL) {
        let audioCommentSaveController = UIAlertController(title: "Do you want to save this comment?", message: nil, preferredStyle: .alert)
        let saveAction = UIAlertAction(title: "Save", style: .default) { _ in
            let audioComment = AudioComment(timeStamp: self.audioPlayer.currentTime, author: self.commenter ?? "Reviewer", filePath: audioUrl)
            self.recording.addAudioComment(audioComment: audioComment)
            self.uiWaveformView.addAudioComment(author: audioComment.author, filePath: audioComment.filePath, timeStamp: audioComment.timeStamp)
            self.uiWaveformView.setNeedsDisplay()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            self.recording.removeAudioComment(at: audioUrl)
        }
        audioCommentSaveController.addAction(saveAction)
        audioCommentSaveController.addAction(cancelAction)
        present(audioCommentSaveController, animated: true)
    }

}
