//
//  ProfileViewController.swift
//  Vois
//
//  Created by Jiang Yuxin on 16/3/20.
//  Copyright © 2020 Vois. All rights reserved.
//

import UIKit
import Firebase

class ProfileViewController: UIViewController {
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

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if let displayMode = splitViewController?.displayMode, displayMode == .allVisible {
            splitViewController?.preferredDisplayMode = .primaryHidden
        }
    }

    @IBAction private func logOutAction(_ sender: Any) {
        do {
            try Auth.auth().signOut()
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let initial = storyboard.instantiateInitialViewController()
        UIApplication.shared.windows.first(where: { $0.isKeyWindow })?.rootViewController = initial
    }
}
