//
//  Listenable.swift
//  Vois
//
//  Created by Sudharshan Madhavan on 21/3/20.
//  Copyright © 2020 Vois. All rights reserved.
//

import Foundation
import AVKit

protocol Listenable {
    var player: AVAudioPlayer { get }
}

extension Listenable {
    func play() {
        if self.player.isPlaying {
            return
        }

        self.player.play()
    }

    func fastForward() {
        self.player.enableRate = true
        self.player.rate = 2.0
    }

    func slowDown() {
        self.player.enableRate = true
        self.player.rate = 0.5
    }

    func pause() {
        self.player.pause()
    }

    func forwardEnd() {
        player.stop()
    }

    func backwardEnd() {
        player.currentTime = 0.0
    }

    func playFrom(time: Double) {
        guard time >= 0 && time <= self.player.duration else {
            return
        }

        self.player.pause()
        self.player.currentTime = time
        self.player.play()
    }

    var audioLength: Double {
        self.player.duration
    }

    var isPlaying: Bool {
        self.player.isPlaying
    }
}
