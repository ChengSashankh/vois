//
//  UserSession.swift
//  Vois
//
//  Created by Jiang Yuxin on 30/3/20.
//  Copyright © 2020 Vois. All rights reserved.
//

import Foundation

class UserSession {
    static func login(userName: String, uid: String) {
        UserDefaults.standard.set(userName, forKey: "current-user")
        UserDefaults.standard.set(uid, forKey: "current-uid")
    }

    static func logout() {
        UserDefaults.standard.removeObject(forKey: "current-user")
        UserDefaults.standard.removeObject(forKey: "current-uid")
    }

    static var currentUserName: String? {
        UserDefaults.standard.value(forKey: "current-user") as? String
    }

    static var currentUID: String? {
        UserDefaults.standard.value(forKey: "current-uid") as? String
    }
}
