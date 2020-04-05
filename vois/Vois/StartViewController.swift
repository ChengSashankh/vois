//
//  StartViewController.swift
//  Vois
//
//  Created by Tan Yong He on 15/3/20.
//  Copyright © 2020 Vois. All rights reserved.
//

import UIKit
import Firebase

class StartViewController: UIViewController {
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if Auth.auth().currentUser != nil {
            self.performSegue(withIdentifier: "alreadyLoggedIn", sender: nil)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        splitViewController?.presentsWithGesture = false
    }
}
