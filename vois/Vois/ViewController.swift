//
//  ViewController.swift
//  Vois
//
//  Created by Jiang Yuxin on 14/3/20.
//  Copyright © 2020 Vois. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let dbController = FirestoreAdapter()
        dbController.exampleCode()
    }

}
