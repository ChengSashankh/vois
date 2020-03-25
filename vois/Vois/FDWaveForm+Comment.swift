//
//  FDWaveForm+Comment.swift
//  Vois
//
//  Created by Sudharshan Madhavan on 22/3/20.
//  Copyright © 2020 Vois. All rights reserved.
//

import Foundation
import FDWaveformView
import UIKit

extension FDWaveformView {

    class CommentContainer: NSObject {
        var author: String
        var timeStamp: Double
        var text: String

        init(comment: TextComment) {
            self.author = comment.author
            self.timeStamp = comment.timeStamp
            self.text = comment.text
        }
    }

    func addComment(audioLength: Double, textComment: TextComment, delegate: UIViewController) {

        let xLocation = (textComment.timeStamp / audioLength) * Double(self.bounds.maxX)
        let yLocation = self.bounds.minY
        let frame = CGRect(x: xLocation, y: Double(yLocation), width: 20.0, height: 20.0)
        let button = TextCommentButton(frame: frame)
        button.titleLabel?.text = ""
        let image = UIImage(systemName: "text.bubble.fill")
        button.setImage(image!, for: .normal)

        button.author = textComment.author
        button.text = textComment.text
        button.timeStamp = textComment.timeStamp
        button.delegate = delegate

        guard let playbackDelegate = delegate as? FDPlaybackDelegate else {
            print("oops")
            return
        }

        playbackDelegate.textCommentButtons.append(button)

        button.addTarget(self, action: #selector(showComment(sender:)), for: .touchUpInside)
        button.addTarget(self, action: #selector(removeComment(sender:)), for: .touchDragExit)

        self.addSubview(button)

    }

    func removeTextCommentButtons(from playbackDelegate: FDPlaybackDelegate) {
        playbackDelegate.textCommentButtons.forEach({ $0.removeFromSuperview() })
        playbackDelegate.textCommentButtons.removeAll()
    }

    @objc private func showComment(sender: TextCommentButton) {
        guard let author = sender.author, let text = sender.text, let delegate = sender.delegate else {
            return
        }

        let alert = UIAlertController(title: "Comment by " + author, message: text, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        delegate.present(alert, animated: true)
    }

    @objc private func removeComment(sender: TextCommentButton) {
        guard let delegate = sender.delegate as? FDPlaybackDelegate else {
            return
        }

        sender.removeFromSuperview()
        delegate.textCommentButtons.removeAll(where: { $0 == sender })
    }
}
