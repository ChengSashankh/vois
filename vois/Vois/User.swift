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
    var uid: String
    var performances: Performances
    var invitedPerfs: Performances

    init(username: String, email: String, uid: String) {
        self.username = username
        self.email = email
        self.uid = uid
        self.performances = Performances()
        self.invitedPerfs = Performances()
    }

    convenience init(email: String, uid: String) {
        self.init(username: email, email: email, uid: uid)
    }
}
