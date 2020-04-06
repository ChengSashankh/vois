//
//  ShareRecordingController.swift
//  Vois
//
//  Created by Jiang Yuxin on 6/4/20.
//  Copyright © 2020 Vois. All rights reserved.
//

import UIKit

class ShareRecordingController: UIAlertController {
    var copyHandler: (() -> Void)?
    override func viewDidLoad() {
        super.viewDidLoad()

        let copyAction = UIAlertAction(title: "Copy", style: .default) { [weak self] _ in
            UIPasteboard.general.string = self?.message
            self?.copyHandler?()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        self.addAction(copyAction)
        self.addAction(cancelAction)
    }
}
