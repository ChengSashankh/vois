//
//  HomeViewController.swift
//  Vois
//
//  Created by Tan Yong He on 15/3/20.
//  Copyright © 2020 Vois. All rights reserved.
//

import UIKit
import Firebase

class HomeViewController: UIViewController {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    @IBAction func logOutAction(_ sender: Any) {
        do {
            try Auth.auth().signOut()
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let initial = storyboard.instantiateInitialViewController()
        UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.rootViewController = initial
    }
}
