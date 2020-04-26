//
//  UserSession.swift
//  Vois
//
//  Created by Jiang Yuxin on 30/3/20.
//  Copyright © 2020 Vois. All rights reserved.
//

import Foundation

class UserSession {
    static var user: User?
    static func login(username: String, email: String, _ completionHandler: (() -> Void)?) {
        let cloudStorage = CloudStorage()
        cloudStorage.setup(for: username, email: email) { user in
            self.user = user
            completionHandler?()
        }
    }

    static func logout() {
        self.user = nil
    }

    static var currentUsername: String? {
        user?.username
    }

    static var currentUserEmail: String? {
        user?.email
    }
}
