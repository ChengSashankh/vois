//
//  DatePickerCell.swift
//  Vois
//
//  Created by Jiang Yuxin on 18/3/20.
//  Copyright © 2020 Vois. All rights reserved.
//

import UIKit

class DatePickerCell: UITableViewCell {

    @IBOutlet weak var datePicker: UIDatePicker! {
        didSet {
            datePicker.addTarget(self, action: #selector(dateValueChanged(_:)), for: .valueChanged)

            datePicker.minimumDate = Date()
        }
    }

    var dateValueChangedHandler: ((Date) -> Void)?
    @objc
    func dateValueChanged(_ sender: UIDatePicker) {
        dateValueChangedHandler?(sender.date)
    }
}
