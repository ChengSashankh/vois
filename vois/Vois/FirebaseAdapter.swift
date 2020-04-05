//
//  FirebaseAdapter.swift
//  Vois
//
//  Created by Sashankh Chengavalli Kumar on 01.04.20.
//  Copyright © 2020 Vois. All rights reserved.
//

import Foundation
import FirebaseFirestore

class FirebaseAdapter: DatabaseAdapter {
    var isConnected: Bool
    var connection: Firestore

    init() {
        isConnected = false
        connection = Firebase.fire
    }

    // TODO
    func setUpConnection() throws {
    }

    // TODO
    func readObject(collection: String) -> [String : Any] {
        return [String: Any]()
    }

    // TODO
    func writeObject(collection: String, data: [String : Any]) {
    }

    // TODO
    func writeObject(collection: String, id: String, data: [String : Any]) {
    }

    // TODO
    func deleteObject(collection: String, id: String, newData: [String : Any]) {
    }

    // TODO
    func updateObject(collection: String, id: String, newData: [String : Any]) {
    }
}
