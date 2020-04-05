//
//  User.swift
//  Vois
//
//  Created by Tan Yong He on 28/3/20.
//  Copyright © 2020 Vois. All rights reserved.
//

import Foundation

class User {
    var username: String
    var email: String
    var performances: Performances
    var invitedPerfs: Performances

    init(username: String, email: String) {
        self.username = username
        self.email = email
        self.performances = Performances()
        self.invitedPerfs = Performances()
    }

    convenience init(email: String) {
        self.init(username: email, email: email)
    }
}
