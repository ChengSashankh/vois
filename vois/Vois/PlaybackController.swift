//
//  PlaybackController.swift
//  Vois
//
//  Created by Sashankh Chengavalli Kumar on 15.03.20.
//  Copyright © 2020 Vois. All rights reserved.
//

import Foundation
import AVFoundation

class PlaybackController {
    var audioPlayer: AVAudioPlayer

    init(recordingFileName: URL) throws {
        audioPlayer = try AVAudioPlayer(contentsOf: recordingFileName)
    }

    func play() {
        audioPlayer.play()
    }
}
