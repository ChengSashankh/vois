//
//  FDWaveWithCommentView.swift
//  Vois
//
//  Created by Sudharshan Madhavan on 22/3/20.
//  Copyright © 2020 Vois. All rights reserved.
//

import Foundation
import FDWaveformView
import UIKit

class FDWaveformWithCommentView: FDWaveformView {

    var playbackDelegate: FDPlaybackDelegate!
    var audioLength: Double!

    private func configureButton(_ button: CommentButton) {
        let xLocation = ((button.timeStamp ?? 0) / audioLength) * Double(self.bounds.maxX)
        let yLocation = self.bounds.minY
        let frame = CGRect(x: xLocation, y: Double(yLocation), width: 20.0, height: 20.0)
        button.frame = frame
        self.addSubview(button)
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        playbackDelegate.textCommentButtons.forEach({ button in configureButton(button)
        })

        playbackDelegate.audioCommentButtons.forEach({ button in configureButton(button)
        })
    }

    func addTextComment(author: String, text: String, timeStamp: Double, delegate: UIViewController) {
        let button = TextCommentButton()
        button.titleLabel?.text = ""
        let image = UIImage(systemName: "text.bubble.fill")
        button.setImage(image!, for: .normal)
        button.author = author
        button.text = text
        button.timeStamp = timeStamp
        button.delegate = delegate

        playbackDelegate.textCommentButtons.append(button)

        button.addTarget(delegate, action: #selector(AudioPlaybackController.showComment(_:)), for: .touchUpInside)
    }

    func addAudioComment(author: String, filePath: URL, timeStamp: Double) {
        let button = AudioCommentButton()
        button.titleLabel?.text = ""
        let image = UIImage(systemName: "play.circle")
        button.setImage(image!, for: .normal)
        button.author = author
        button.filePath = filePath
        button.timeStamp = timeStamp
        button.addTarget(delegate, action: #selector(AudioPlaybackController.showAudioComment(_:)), for: .touchUpInside)
        playbackDelegate.audioCommentButtons.append(button)
    }

    func removeTextCommentButtons(from playbackDelegate: FDPlaybackDelegate) {
        playbackDelegate.textCommentButtons.forEach({ $0.removeFromSuperview() })
        playbackDelegate.textCommentButtons.removeAll()

        playbackDelegate.audioCommentButtons.forEach({ $0.removeFromSuperview() })
        playbackDelegate.audioCommentButtons.removeAll()
    }
}
