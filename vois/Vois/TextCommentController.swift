//
//  TextCommentController.swift
//  Vois
//
//  Created by Sudharshan Madhavan on 22/3/20.
//  Copyright © 2020 Vois. All rights reserved.
//

import Foundation
import UIKit

class TextCommentController: UIViewController, UITextFieldDelegate {
    @IBOutlet var uiComment: UITextField!

    var addCommentClosure: ((String) -> Void)?

    @IBAction func submitComment(_ sender: UIButton) {
        guard let text = uiComment.text, !text.isEmpty else {
            let alert = UIAlertController(title: "Invalid Comment!", message: "Comments cannot be blank.", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(action)
            present(alert, animated: true)
            return
        }

        guard addCommentClosure != nil else {
            return
        }

        addCommentClosure!(text)
        dismiss(animated: true, completion: nil)
    }
}
