//
//  UserSession.swift
//  Vois
//
//  Created by Jiang Yuxin on 30/3/20.
//  Copyright © 2020 Vois. All rights reserved.
//

import Foundation

class UserSession {
    static func login(user: User) {
        UserDefaults.standard.set(user.username, forKey: "current-username")
        UserDefaults.standard.set(user.email, forKey: "current-user-email")
    }

    static func logout() {
        UserDefaults.standard.removeObject(forKey: "current-username")
        UserDefaults.standard.removeObject(forKey: "current-user-email")
    }

    static var currentUsername: String? {
        UserDefaults.standard.value(forKey: "current-username") as? String
    }

    static var currentUserEmail: String? {
        UserDefaults.standard.value(forKey: "current-user-email") as? String
    }
}
