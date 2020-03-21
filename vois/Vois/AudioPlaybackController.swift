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

    func setAudioURL(url: URL, recordingList: [URL]) {
        self.fileURL = url
        self.audioPlayer = AudioPlayer(audioFileURL: fileURL, recordingList: recordingList)
    }

    @IBAction func forwardEnd(_ sender: UIButton) {
        audioPlayer.forwardEnd()
        audioPlayer.next()
        audioPlayer.updatePlayer()
    }

    @IBAction func play(_ sender: UIButton) {
        audioPlayer.play()
    }
    
    func pause() {
        audioPlayer.pause()
    }

    @IBAction func backwardEnd(_ sender: UIButton) {
        if audioPlayer.currentTime < 0.1 {
            audioPlayer.pause()
            audioPlayer.prev()
        }
        audioPlayer.backwardEnd()
        audioPlayer.updatePlayer()
    }
    
}
