//
//  NewSongViewController.swift
//  Vois
//
//  Created by Jiang Yuxin on 2/4/20.
//  Copyright © 2020 Vois. All rights reserved.
//

import UIKit

class NewSongViewController: UIAlertController {

    var addSong: ((String) -> Void)?
    override func viewDidLoad() {
        super.viewDidLoad()

        let addAction = UIAlertAction(title: "Add", style: .default) { [weak self] _ in
            guard let textField = self?.textFields?.first,
                let songName = textField.text else {
                    return
            }
            self?.addSong?(songName)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        self.title = "Add new song"
        self.addTextField()
        self.addAction(addAction)
        self.addAction(cancelAction)
    }
}
