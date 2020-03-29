//
//  SignupViewController.swift
//  Vois
//
//  Created by Tan Yong He on 15/3/20.
//  Copyright © 2020 Vois. All rights reserved.
//

import UIKit
import Firebase

class SignupViewController: UIViewController {
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var passwordConfirm: UITextField!

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        password.isSecureTextEntry = true
        passwordConfirm.isSecureTextEntry = true
    }

    @IBAction private func signUpAction (_ sender: Any) {
        if password.text != passwordConfirm.text {
            let alertController = UIAlertController(title: "Mismatched Password",
                                                    message: "Please re-type password.",
                                                    preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
        } else {
            Auth.auth().createUser(withEmail: email.text!, password: password.text!) { _, error in
                if error == nil {
                    self.performSegue(withIdentifier: "signupToHome", sender: self)
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
    }
}
