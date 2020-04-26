//
//  LoginViewController.swift
//  Vois
//
//  Created by Tan Yong He on 15/3/20.
//  Copyright © 2020 Vois. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        password.isSecureTextEntry = true
    }

    @IBAction private func logInAction (_ sender: Any) {
        Auth.auth().signIn(withEmail: email.text!, password: password.text!) { _, error in
            if error == nil {
                guard let userName = Auth.auth().currentUser?.email, let uid = Auth.auth().currentUser?.uid else {
                    return
                }
                self.updateEmailsToUIDs(email: userName, uid: uid)
                UserSession.login(username: self.email.text!, email: self.email.text!) {
                    self.performSegue(withIdentifier: "loginToHome", sender: self)
                }

            } else {
                let alertController = UIAlertController(title: "Errpr",
                                                        message: error?.localizedDescription,
                                                        preferredStyle: .alert)
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(defaultAction)
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }

    private func updateEmailsToUIDs(email: String, uid: String) {
        let emailsToUIDs = Firestore.firestore().collection("emailsToUIDs")
        emailsToUIDs.document(email).setData(["uid": uid])
    }
}
