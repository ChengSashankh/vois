//
//  FDPlaybackDelegate.swift
//  Vois
//
//  Created by Sudharshan Madhavan on 22/3/20.
//  Copyright © 2020 Vois. All rights reserved.
//

import Foundation
import FDWaveformView

protocol FDPlaybackDelegate: FDWaveformViewDelegate {
    var textCommentButtons: [TextCommentButton] { get set }
    var audioCommentButtons: [AudioCommentButton] { get set }
}
