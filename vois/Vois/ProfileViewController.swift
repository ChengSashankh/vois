//
//  ProfileViewController.swift
//  Vois
//
//  Created by Jiang Yuxin on 16/3/20.
//  Copyright © 2020 Vois. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func closeMasterViewController(_ sender: UIBarButtonItem) {
        guard let displayModeBarButton = splitViewController?.displayModeButtonItem,
            let displayAction = displayModeBarButton.action else {
            return
        }

        if splitViewController?.isCollapsed ?? false {
            performSegue(withIdentifier: "closeProfile", sender: self)
        } else {
        UIApplication.shared.sendAction(displayAction, to: displayModeBarButton.target, from: nil, for: nil)
        }
    }
}
