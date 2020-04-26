//
//  TextCommentButton.swift
//  Vois
//
//  Created by Sudharshan Madhavan on 22/3/20.
//  Copyright © 2020 Vois. All rights reserved.
//

import Foundation
import UIKit

class TextCommentButton: CommentButton {
    var text: String!
    var author: String!
    weak var delegate: UIViewController!
}
