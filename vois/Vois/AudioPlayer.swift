//
//  AudioPlayer.swift
//  Vois
//
//  Created by Sudharshan Madhavan on 21/3/20.
//  Copyright © 2020 Vois. All rights reserved.
//

import Foundation
import AVKit

class AudioPlayer: Listenable, RecordingList {
    var player: AVAudioPlayer
    var recordings: [URL]
    internal var currentIndex: Int
    var currentTime: Double {
        player.currentTime
    }

    init(audioFileURL: URL, recordingList: [URL]) {
        do {
            self.player = try AVAudioPlayer(contentsOf: audioFileURL)
            self.recordings = recordingList
            self.currentIndex = recordings.firstIndex(of: audioFileURL)!
        } catch {
            fatalError("Invalid file URL.")
        }
    }

    func updatePlayer() {
        do {
            player = try AVAudioPlayer(contentsOf: recordings[currentIndex])
        } catch {
            fatalError("rip")
        }
    }
}
