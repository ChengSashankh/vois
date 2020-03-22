//
//  SongNameCell.swift
//  Vois
//
//  Created by Jiang Yuxin on 17/3/20.
//  Copyright © 2020 Vois. All rights reserved.
//

import UIKit

class SongNameCell: UITableViewCell, UITextFieldDelegate {

    @IBOutlet weak var songNameTextField: UITextField! {
        didSet {
            songNameTextField.delegate = self
        }
    }

    @IBOutlet weak var songNameLabel: UILabel!

    @IBOutlet weak var addButton: UIButton!
    @IBAction func addSong(_ sender: UIButton) {
        songNameTextField.resignFirstResponder()
    }

    var endEditingHandler: ((String) -> Void)?
    var shouldEndEditingHandler: (() -> Bool)?

    func setEditingMode() {
        songNameLabel.isHidden = true
        songNameTextField.isHidden = false
        addButton.isHidden = false

        songNameTextField.becomeFirstResponder()
    }

    func setNonEditingMode() {
        songNameLabel.text = songNameTextField.text
        songNameLabel.isHidden = false
        songNameTextField.isHidden = true
        addButton.isHidden = true

        songNameTextField.resignFirstResponder()
    }

    var isEmptySongName: Bool {
        songNameTextField.text?.isEmpty ?? true
    }

    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if let handler = shouldEndEditingHandler {
            return handler()
        }
        return !isEmptySongName
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if isEmptySongName {
            return false
        } else {
            songNameTextField.resignFirstResponder()
            return true
        }
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let songName = songNameTextField.text else {
            return
        }
        endEditingHandler?(songName)
    }
}
