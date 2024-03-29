//
//  SongCell.swift
//  Vois
//
//  Created by Jiang Yuxin on 19/3/20.
//  Copyright © 2020 Vois. All rights reserved.
//

import UIKit

class SongCell: UITableViewCell {
    @IBOutlet weak var songNameLabel: UILabel!

    private static let cornerRadiusToWidth: CGFloat = 0.03
    private static let verticalSpacingToHeight: CGFloat = 0.1

    private var verticalSpacing: CGFloat {
        bounds.height * SongCell.verticalSpacingToHeight
    }
    private var cornerRadius: CGFloat {
        bounds.width * SongCell.cornerRadiusToWidth
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)

        let roundedRect = UIBezierPath(
            roundedRect: rect.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: verticalSpacing, right: 0)),
            cornerRadius: cornerRadius)

        #colorLiteral(red: 0.5546258092, green: 0.7963129878, blue: 1, alpha: 0.5).setFill()
        roundedRect.fill()
    }
}
