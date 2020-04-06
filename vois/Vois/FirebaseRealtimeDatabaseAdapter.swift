//
//  FirebaseRealtimeDatabaseAdapter.swift
//  Vois
//
//  Created by Sashankh Chengavalli Kumar on 06.04.20.
//  Copyright © 2020 Vois. All rights reserved.
//

import Foundation
import FirebaseDatabase

class FirebaseRealtimeDatabaseAdapter {
    var isConnected: Bool
    var ref: DatabaseReference!

    init() {
        isConnected = false
        ref = Database.database().reference()
    }

    func setUpConnection() throws {
    }

    func getData(at: String) -> String {
        var ans = "Something went wrong"

        self.ref.child(at).observeSingleEvent(of: .value, with: {(snapshot) in
            let value = snapshot.value as? NSDictionary
            let res = value?["testNode"] as? String ?? ""
            ans = res
        })

        return ans
    }

    func writeData(key: String, value: String) {
        self.ref.child("comments").child("testNode").setValue("newValue")
    }
}
