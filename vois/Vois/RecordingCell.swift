//
//  RecordingCell.swift
//  Vois
//
//  Created by Jiang Yuxin on 10/4/20.
//  Copyright © 2020 Vois. All rights reserved.
//

import UIKit

class RecordingCell: UITableViewCell {

    @IBOutlet weak var recordingNameLabel: UILabel!

    var shareDelegate: (() -> Void)?
    var playbackDelegate: (() -> Void)?

    @IBAction func share(_ sender: UIButton) {
        shareDelegate?()
    }

    @IBAction func playback(_ sender: UIButton) {
        playbackDelegate?()
    }

}
