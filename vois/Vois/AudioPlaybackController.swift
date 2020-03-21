//
//  AudioPlaybackController.swift
//  Vois
//
//  Created by Sudharshan Madhavan on 21/3/20.
//  Copyright © 2020 Vois. All rights reserved.
//

import Foundation
import UIKit

class AudioPlaybackController: UIViewController {

    var fileURL: URL!
    var audioPlayer: AudioPlayer!
    private var displayLink: CADisplayLink!
    @IBOutlet private var uiSlider: UISlider!

    override func viewDidLoad() {
        super.viewDidLoad()
        uiSlider.minimumValue = 0.0
        uiSlider.maximumValue = Float(audioPlayer.audioLength)
        uiSlider.setValue(0.0, animated: false)

        displayLink = CADisplayLink(target: self, selector: #selector(step))
        displayLink.add(to: .current, forMode: .default)
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
        resumeLoop()
        audioPlayer.playFrom(time: Double(uiSlider!.value))
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

    private func refresh() {
        audioPlayer.updatePlayer()
        uiSlider.maximumValue = Float(audioPlayer.audioLength)
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
    }
    
}
