//
//  TextCommentButton.swift
//  Vois
//
//  Created by Sudharshan Madhavan on 22/3/20.
//  Copyright © 2020 Vois. All rights reserved.
//

import Foundation
import UIKit

class TextCommentButton: UIButton {
    var text: String?
    var author: String?
    var timeStamp: Double?
    weak var delegate: UIViewController?
}
