//
//  Serializable.swift
//  Vois
//
//  Created by Sashankh Chengavalli Kumar on 06.04.20.
//  Copyright © 2020 Vois. All rights reserved.
//

import Foundation

protocol Serializable {
    var uid: String { get set }
    var dictionary: [String: Any] { get }
}
