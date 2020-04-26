//
//  NewSegmentController.swift
//  Vois
//
//  Created by Jiang Yuxin on 10/4/20.
//  Copyright © 2020 Vois. All rights reserved.
//

import UIKit

class NewSegmentController: UIAlertController {
    var addSegment: ((String) -> Void)?
    override func viewDidLoad() {
        super.viewDidLoad()

        let addAction = UIAlertAction(title: "Add", style: .default) { [weak self] _ in
            guard let textField = self?.textFields?.first,
                let segmentName = textField.text else {
                    return
            }
            self?.addSegment?(segmentName)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        self.title = "Add new segment"
        self.addTextField()
        self.addAction(addAction)
        self.addAction(cancelAction)
    }

}
