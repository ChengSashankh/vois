//
//  DatabaseAdapter.swift
//  Vois
//
//  Created by Sashankh Chengavalli Kumar on 01.04.20.
//  Copyright © 2020 Vois. All rights reserved.
//

import Foundation

protocol DatabaseAdapter {
    var isConnected: Bool { get }
    var connection: Any { get }

    func setUpConnection() throws

    func writeObject(collection: String, id: String, data: [String: Any])

    func writeObject(collection: String, data: [String: Any])

    func readObject(collection: String) -> [String: Any]

    func updateObject(collection: String, id: String, newData: [String: Any])

    func deleteObject(collection: String, id: String, newData: [String: Any])
}
