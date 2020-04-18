//
//  DatabaseObserver.swift
//  Vois
//
//  Created by Jiang Yuxin on 11/4/20.
//  Copyright © 2020 Vois. All rights reserved.
//

import Foundation

protocol DatabaseObserver {
    func update(operation: Operation, object: Shareable) -> String
    func read(reference: String, _ completionHandler: (([String: Any]) -> Void)?)

    func initializationRead(reference: String) -> [String: Any]
}

enum Operation {
    case create
    case update
    case delete
}
