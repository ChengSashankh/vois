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

    func setUpConnection() throws

    func writeObject(inCollection: String, withId: String, data: [String: Any])

    func writeObject(inCollection: String, data: [String: Any])

    func readObject(inCollection: String, withId: String) -> [String: Any]

    func updateObject(inCollection: String, withId: String, newData: [String: Any])

    func deleteObject(inCollection: String, withId: String)
}
